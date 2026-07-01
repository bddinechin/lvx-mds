#
# YAML Front-End to produce MDS tables.
# Authors:
# - Benoit Dupont de Dinechin 2009.
# Purpose:
# - Create sections BitField and Encoding
# - Strenghten the structure for use by yml2pl.pl
# - Emit one YAML file per section

use strict;
use Carp;
use Data::Dumper;

use YAML::XS;

my $core= $ENV{CORE};

sub get_required_attribute {
  my ($type,$ID,$entry,$attribute) = @_;
  confess  "$ID: Missing attribute '$attribute' for $type" unless defined $$entry{$attribute};
  return $$entry{$attribute};
}

sub get_implied_attribute {
  my ($type,$ID,$entry,$attribute) = @_;
  return $$entry{$attribute};
}

# Accumulator for all sections extracted from input.
my %Section;

# Load YAML input into %$Description.
local $/;
my $Description = Load(<>);

# Copy core sections into main sections according to $core.
if (ref $$Description{$core} eq 'HASH') {
  while (my ($key,$value) = each %{$$Description{$core}}) {
    if (ref $value eq 'HASH') {
      print STDERR "CORE $core sections: ", (keys %{$value}), "\n";
    }
  }
}


# Process the Storage section.
my %Storage;
my $Storage_number = 0;
foreach my $storage (@{$$Description{Storage}}) {
  my $what = $$storage{what};
  my $ID = $$storage{ID} || die "Missing ID for Storage";
  die "Storage $ID already exists" if exists $Section{Storage}{$ID};
  $Storage{$ID} = $storage;
  $Section{Storage}{$ID}{what} = $$storage{what};
  $Section{Storage}{$ID}{number} = $Storage_number++;
  my $kind  = $$storage{kind} || die "Missing kind for Storage $ID";
  my $count = $$storage{count};
  my $width = $$storage{width} || die "Missing width for Storage $ID";
  # Fill %Storage.
  $Section{Storage}{$ID}{count} = $count;
  $Section{Storage}{$ID}{width} = $width;
  $Section{Storage}{$ID}{kind} = $kind;
}

my %storage2register;

# Get mapping between Storages and Registers
foreach my $regfile (@{$$Description{RegFile}}) {
  my $ID = $$regfile{ID} || die "Missing ID for RegFile";
  my $registers = $$regfile{registers} || die "Missing registers for RegFile $ID";
  foreach my $register (@{$registers}) {
    my $regID = $$register{ID};
    my $location = $$register{location};
    my $storageID = @{$location}[0];
    if (not defined $storage2register{$storageID}) {
      $storage2register{$storageID} = $regID;
    }
  }
}


# Process the RegField section.
my %RegField;
my $RegField_number = 0;
my $got_error = 0;
foreach my $regField (@{$$Description{RegField}}) {
  my $ID = &regField($regField, \$got_error);
}
if ($got_error) {
  die "RegField errors";
}
sub regField {
  my ($regField, $got_error) = @_;
  my $what = $$regField{what};
  my $ID = $$regField{ID} || die "Missing ID for RegField";
  die "RegField $ID already exists" if exists $Section{RegField}{$ID};
  my $location = $$regField{location} || die "Missing location for RegField $ID";
  my $storageID = @{$location}[0];
  die "Undefined storage entry $storageID in storage2register hash table" if not defined $storage2register{$storageID};
  my $registerID = $storage2register{$storageID};
  if (defined $$regField{register}) {
      $registerID = $$regField{register};
  }
  my $bits = @{$location}[1];
  my ($offset, $width);
  if ($bits =~ /(\d+)\.\.(\d+)/) {
    my ($low, $high) = ($1, $2);
    die "Incorrect range $bits" unless $low <= $high;
    ($offset, $width) = ($low, $high - $low + 1);
  } elsif ($bits =~ /(\d+)/) {
    ($offset, $width) = ($1, 1);
  } else { die "Incorrect range $bits" }
  my @addresses = map { if (/(\d+)\.\.(\d+)/) { $1 .. $2 } else { $_ } } $bits;
  my $owners = $$regField{owners};
  my $reset = $$regField{reset};
  my $rerrors = $$regField{rerrors}; 
  my $werrors = $$regField{werrors};
  my %RERROR_TOKENS = ( 
      "READ"            => "Read even if bitfield is not owned",
      "READ0"           => "Read as zero if bitfield is not owned",
      "TRAP_PRIVILEGE" => "TRAP privilege in case of bad ownerchip",
  );
  my %WERROR_TOKENS = ( 
      "NONE"  => "No effect on bitfield if not owned (no TRAP)",
      "WRITE" => "Write even if bitfield is not owned",
      "TRAP_PRIVILEGE" => "TRAP privilege in case of bad ownerchip",
      "SET_NONE"  => "No effect on bitfield if not owned on SET access(no TRAP)",
      "SET_WRITE" => "Write even if bitfield is not owned on SET access",
      "SET_TRAP_PRIVILEGE" => "TRAP privilege in case of bad ownerchip on SET access",
      "WFX_NONE"  => "No effect on bitfield if not owned on WFX access (no TRAP)",
      "WFX_WRITE" => "Write even if bitfield is not owned on WFX access",
      "WFX_TRAP_PRIVILEGE" => "TRAP privilege in case of bad ownerchip on WFX access",
  );
  if ( defined $owners && scalar @{$owners} > 0 && (!defined $rerrors || !defined $werrors || scalar @{$rerrors} == 0 || scalar @{$werrors} == 0) ) {
    $$got_error = 1;
    if (!defined $rerrors || scalar @{$rerrors} == 0 ) {
      print STDERR "ERROR: $ID has owners @{$owners} but no rerrors\n";
    }
    if (!defined $werrors || scalar @{$werrors} == 0) {
      print STDERR "ERROR: $ID has owners @{$owners} but no werrors\n";
    }
  }
  foreach my $rerror  (@{$rerrors}) {
    die "$ID: Undefined keyword $rerror for rerror attribute" if (defined $rerror && not defined $RERROR_TOKENS{$rerror});
  }
  foreach my $werror  (@{$werrors}) {
    die "$ID: Undefined keyword $werror for werror attribute" if (defined $werror && not defined $WERROR_TOKENS{$werror});
  }
  # Fill RegField.
  $Section{RegField}{$ID}{what} = $what;
  $Section{RegField}{$ID}{register} = $registerID;
  $Section{RegField}{$ID}{offset} = $offset;
  $Section{RegField}{$ID}{width} = $width;
  $Section{RegField}{$ID}{owners} = $owners;
  $Section{RegField}{$ID}{reset} = $reset;
  $Section{RegField}{$ID}{rerrors} = $rerrors;
  $Section{RegField}{$ID}{werrors} = $werrors;
  $Section{RegField}{$ID}{number} = $RegField_number++;
  # Prepare Register@fields.
  push @{$RegField{$registerID}}, $ID;
  return $ID;
}

# Process the Register section.
my $Register_number = 0;
foreach my $register (@{$$Description{Register}}) {
  my ($ID) = &register($register);
}

sub isnum ($) {
    return 0 if $_[0] eq '';
    $_[0] ^ $_[0] ? 0 : 1
}

sub regfields {
  my ($register, $storage, $width, $_reset) = @_;
  my $register_reset = undef;
  my $reset_is_hardwired = 1;
  my $ID = $$register{ID};
  my @fields = sort {
    $Section{RegField}{$a}{offset} <=> $Section{RegField}{$b}{offset} ||
    $Section{RegField}{$a}{width} <=> $Section{RegField}{$b}{width}
  } @{$RegField{$ID}} if defined $RegField{$ID};
  if ((scalar(@fields) == 0) && ($Section{Storage}{$storage}{kind} eq "Special") && (not defined $$_reset)) {
    die "$ID: No reset value for Register with special storage";
  }
  foreach my $field (@fields) {
    my $regfield = $Section{RegField}{$field};
    if (not defined $$_reset and not defined $$regfield{reset}) {
      die "$ID: Register reset not defined and not all RegField reset defined: $field";
    }
    if (defined $$regfield{reset}) {
      $register_reset = 0 unless defined $register_reset;
      my $offset = $$regfield{offset};
      my $width = $$regfield{width};
      my $regfield_reset = ($$regfield{reset} =~ /^0x/ ? oct($$regfield{reset}) : $$regfield{reset});
      if (isnum($regfield_reset)) {
        # Not all register is hardwired
        $reset_is_hardwired = 0;
      }
      else {
        if ($regfield_reset ne "Hardwired") {
          die "RegField $field is not a numeric value and is not equal to 'Hardwired': $regfield_reset"
        }
        # Force to 0 waiting check on all register bitfields.
        # Register reset will be set to Hardwired if all bitfields are Hardwired
        $regfield_reset = 0;
      }
      my $mask = (1 << $$regfield{width}) - 1;
      die "Reset value bigger than RegField width: $width" if ((~$mask) & $regfield_reset);
      $register_reset |= (($regfield_reset & $mask) << $offset);
    }
    else {
      # Don't know if some bitfield reset are not defined
      $reset_is_hardwired = 0;
    }
  }
  if (defined $register_reset && $reset_is_hardwired)  {
    $register_reset = "Hardwired";
  }
  # Set reset value: numerical or Hardwired
  if (not defined $$register{reset}) {
    # Copy reset value from fields if not defined in Register
    $$_reset = $register_reset;
  } else {
    # Register reset value will be compared to register fields reset values if defined
    $$_reset = ($$_reset =~ /^0x/)? oct($$_reset): $$_reset;
  }
  if (defined $$_reset && !isnum($$_reset) && ($$_reset ne "Hardwired")) {
    die "Register ID: $ID has not a numerical reset value and it is not 'Hardwired': '$$_reset'\n";
  }
  # Check RegField resets with Register reset
  my $width_format = ($width % 4) ? ($width / 4 + 1) : ($width / 4);
  if (defined $register_reset) {
    if (isnum($$_reset) != isnum($register_reset)) {
      die "Register ID: $ID register reset '$$_reset' differs from RegField reset values '$register_reset'\n";
    }
    if (!isnum($$_reset) && !isnum($register_reset)) {
      # Must be both Hardwired
      if (($$_reset ne "Hardwired") || ($register_reset ne "Hardwired")) {
        die "Register ID: $ID register reset '$$_reset' differs from RegField reset '$register_reset'\n";
      }
    }
    else {
      # Numerical values
      if ($register_reset != $$_reset) {
        my $_reset_str = sprintf('%x', $$_reset);
        my $register_reset_str = sprintf('%x', $register_reset);
        die "Register $ID bad reset value: 0x${_reset_str} compared to associated regfields: 0x${register_reset_str}\n";
      }
    }
  }
  $$_reset = sprintf("0x%0${width_format}x",$$_reset) if ($$_reset ne "Hardwired");
  return @fields;
}

my %RegisterDwarfId;
my $RegisterDwarfId;

sub register {
  my ($register, $regFile, $startDwarfId, $lastDwarfId) = @_;
  if (defined $RegisterDwarfId) {
    $RegisterDwarfId = undef if defined $startDwarfId && $RegisterDwarfId < $startDwarfId;
    $RegisterDwarfId = undef if defined $lastDwarfId && $RegisterDwarfId > $lastDwarfId;
  }
  my $what = $$register{what};
  my $ID = $$register{ID} || die "Missing ID for Register";
  die "Register $ID already exists in " . $Section{Register}{$ID}{storage} if exists $Section{Register}{$ID};
  my $location = $$register{location} || die "Missing location for Register $ID";
  my $names = $$register{names} || die "Missing names for Register $ID";
  my $storage = shift @{$location};
  my @addresses = map { if (/(\d+)\.\.(\d+)/) { $1 .. $2 } else { $_ } } @{$location};
  die "Unknown Storage @{$location} ($storage) for Register $ID" unless defined $Section{Storage}{$storage};
  my $owners = $$register{owners};
  my $raccess = $$register{raccess};
  my $waccess = $$register{waccess};
  my $width = $$register{width};
  my $reset = $$register{reset};
  my %RACCESS_TOKENS = ( 
      "NONE"  => "Trap opcode",
      "GET"   => "Can be read with GET, RSWAP",
  );
  my %WACCESS_TOKENS = ( 
      "NONE"   => "Trap opcode",
      "WFX"    => "Can be written with WFX",
      "SET"    => "Can be written with SET",
  );
  die "ERROR: $ID: bad raccess: $raccess" if (defined $raccess && not defined $RACCESS_TOKENS{$raccess});
  die "ERROR: $ID: bad waccess: $waccess" if (defined $waccess && not defined $WACCESS_TOKENS{$waccess});
  my @fields = &regfields($register, $storage, $width, \$reset);

  if (defined $owners) {
    # It is mandatory to have regfield associated to register with owners because rerror and werror are specified in RegField.
    if (scalar(@fields) == 0) {
      die "ERROR: $ID: got owners ($$owners[0]) and no associated RegField."
    }
  }
  my $storage_section = { $Section{Storage}{$storage} };
  if (defined $Storage{$storage}{count}) {
    map {
      croak "ERROR: $ID: address $_ out of range for storage $storage (count is $Storage{$storage}{count})"
          if ($_ >= $Storage{$storage}{count});
    } @addresses;
  }
  if (ref $regFile) {
    # Inherit defaults from a RegFile.
    $raccess = $$regFile{raccess} unless defined $raccess;
    $waccess = $$regFile{waccess} unless defined $waccess;
    $width = $$regFile{width} unless defined $width;
  }
  my ($minAddress) = sort { $a <=> $b } @addresses;
  my ($maxAddress) = reverse sort { $a <=> $b } @addresses;
  # Update Storage.
  $$storage_section{MIN} = $minAddress if $$storage_section{MIN} > $minAddress;
  $$storage_section{MAX} = $maxAddress if $$storage_section{MAX} < $maxAddress;
  die "No Storage for register $ID" unless defined $Section{Storage}{$storage};
  my $storage_count = $$storage_section{MAX} - $$storage_section{MIN} + 1;
  die "Storage $storage count mismatch: $storage_count was $Section{Storage}{$storage}{count}" if $storage_count > $Section{Storage}{$storage}{count};
  # Detect if we want to map several registers
  if (($width <= $Section{Storage}{$storage}{width}) && ($minAddress != $maxAddress) ) {
    my @registers;
    # Fill Multiple Registers.
    foreach my $address ($minAddress .. $maxAddress) {
      my $registerID = $ID;
      my $registerNames = join(" ",@$names);
      my $relative_index = $address - $minAddress;
      my $register_what = $what;
      my $registerDwarfId = defined $$register{dwarfId}?
                            $$register{dwarfId} + ($address - $minAddress):
                            (defined $RegisterDwarfId? $RegisterDwarfId++: undef);
      if (defined $registerDwarfId) {
        $registerDwarfId = undef if $registerDwarfId < $startDwarfId;
        $registerDwarfId = undef if $registerDwarfId > $lastDwarfId;
      }
      if (defined $registerDwarfId and defined $RegisterDwarfId{$registerDwarfId}) {
        die "1: Register $registerID assigned dwarfId $registerDwarfId already used by register $RegisterDwarfId{$registerDwarfId}";
      }
      $RegisterDwarfId{$registerDwarfId} = $registerID;
      # Replace <i> by absolute index in register file, <r> with relative index from minAddress.
      $registerID =~ s/<i>/$address/g;
      $registerID =~ s/<r>/$relative_index/g;
      $registerNames =~ s/<i>/$address/g;
      $registerNames =~ s/<r>/$relative_index/g;
      $register_what =~ s/<i>/$address/g;
      $register_what =~ s/<r>/$relative_index/g;
      $Section{Register}{$registerID}{what} = $register_what;
      $Section{Register}{$registerID}{storage} = $storage;
      $Section{Register}{$registerID}{addresses} = [$address];
      $Section{Register}{$registerID}{fields} = \@fields if @fields;
      $Section{Register}{$registerID}{dwarfId} = $registerDwarfId;
      $Section{Register}{$registerID}{names} = [ split(" ",$registerNames) ];
      $Section{Register}{$registerID}{raccess} = $raccess;
      $Section{Register}{$registerID}{waccess} = $waccess;
      $Section{Register}{$registerID}{width} = $width;
      $Section{Register}{$registerID}{owners} = $owners;
      $Section{Register}{$registerID}{reset} = $reset;
      $Section{Register}{$registerID}{number} = $Register_number++;
      push @registers, $registerID;
    }
    return @registers;
  } else {
    my $registerDwarfId = $$register{dwarfId}?
                          $$register{dwarfId}:
                          (defined $RegisterDwarfId? $RegisterDwarfId++: undef);
    if (defined $registerDwarfId) {
      $registerDwarfId = undef if $registerDwarfId < $startDwarfId;
      $registerDwarfId = undef if $registerDwarfId > $lastDwarfId;
    }
    if (defined $registerDwarfId and defined $RegisterDwarfId{$registerDwarfId}) {
      die "Register $ID assigned dwarf ID $registerDwarfId already used by register $RegisterDwarfId{$registerDwarfId}";
    }
    $RegisterDwarfId{$registerDwarfId} = $ID;
    # Fill Single Register.
    $Section{Register}{$ID}{what} = $what;
    $Section{Register}{$ID}{storage} = $storage;
    $Section{Register}{$ID}{addresses} = \@addresses;
    $Section{Register}{$ID}{fields} = \@fields if @fields;
    $Section{Register}{$ID}{dwarfId} = $registerDwarfId;
    $Section{Register}{$ID}{names} = $$register{names};
    $Section{Register}{$ID}{raccess} = $raccess;
    $Section{Register}{$ID}{waccess} = $waccess;
    $Section{Register}{$ID}{width} = $width;
    $Section{Register}{$ID}{owners} = $owners;
    $Section{Register}{$ID}{reset} = $reset;
    $Section{Register}{$ID}{number} = $Register_number++;
    return ($ID);
  }
}

my $RegClass_number = 0;
sub multiRegClasses {
  my ($regClassID, $refFileID, $multi) = @_;
  my @multi = @$multi if ref $multi eq 'ARRAY';;
  my $what = $Section{RegClass}{$regClassID}{what};
  my $shortName = $Section{RegClass}{$regClassID}{shortName};
  # Create new RegClass(es) for each multi, each with a proper shift and bias.
  my ($count, $shift, $index) = (scalar @multi, 0, 0);
  die "$regClassID\@multi count not a power of 2" if ($count & ($count - 1));
  ++$shift while ($count >>= 1);
  my $mask = (1 << $shift) - 1;
  foreach my $multiID (@multi) {
    my $regClassID_m = "${regClassID}.$index";
    die "Multi RegClass $regClassID_m already defined" if exists $Section{RegClass}{$regClassID_m};
    $Section{RegClass}{$regClassID_m}{what} = "$what Multi $index";
    $Section{RegClass}{$regClassID_m}{number} = $RegClass_number++;
    $Section{RegClass}{$regClassID_m}{regFile} = $Section{RegClass}{$multiID}{regFile};
    my @registers = grep {
      ($count++ & $mask) == ($index & $mask)
    } @{$Section{RegClass}{$multiID}{registers}};
    $Section{RegClass}{$regClassID_m}{registers} = \@registers;
    $Section{RegClass}{$regClassID_m}{shift} = $shift;
    $Section{RegClass}{$regClassID_m}{bias} = $index;
    $Section{RegClass}{$regClassID_m}{shortName} = "$shortName$index" if $shortName;
    $index++;
  }
}

# Process the RegFile section.
my $RegFile_number = 0;
foreach my $regFile (@{$$Description{RegFile}}) {
  my $what = $$regFile{what};
  my $ID = $$regFile{ID} || die "Missing ID for RegFile";
#  print STDERR "REGFILE $ID\n";
  my $width = $$regFile{width} || 0;
  my $dwarfIds = $$regFile{dwarfIds};
  my ($startDwarfId, $lastDwarfId) = split /\.\./, $dwarfIds if defined $dwarfIds;
  $RegisterDwarfId = $startDwarfId;
  my $shortName = $$regFile{shortName};
  die "RegFile $ID already exists" if exists $Section{RegFile}{$ID};
  $Section{RegFile}{$ID}{what} = $what;
  $Section{RegFile}{$ID}{number} = $RegFile_number++;
  my $registers = $$regFile{registers} || die "Missing registers for RegFile $ID";
  my $index = 0;
  my @RegFile_registers;
  foreach my $register (@{$registers}) {
    my @registerIDs = &register($register, $regFile, $startDwarfId, $lastDwarfId);
    foreach my $RegisterID (@registerIDs) {
      $Section{Register}{$RegisterID}{regFile} = $$regFile{ID};
      $Section{Register}{$RegisterID}{index} = $index++;
      push @RegFile_registers, $RegisterID;
    }
  }
  $Section{RegFile}{$ID}{width} = $width;
  $Section{RegFile}{$ID}{registers} = \@RegFile_registers;
  $Section{RegFile}{$ID}{nativeTypes} = [ @{$$regFile{nativeTypes}} ];
  # Legacy multi on RegFile
  my $multi = $$regFile{multi};
  if ($multi) {
    die "RegFile\@multi requires RegFile\@regClass in $ID" unless $$regFile{regClass};
    $Section{RegFile}{$ID}{multi} = $multi;
  }
  # Make the RegClass corresponding to this RegFile.
  my $regClassID = $$regFile{regClass};
  if ($regClassID) {
    die "RegClass $regClassID already exists" if exists $Section{RegClass}{$regClassID};
    #print STDERR "Make RegClass $regClassID for RegFile $ID\n";
    $Section{RegFile}{$ID}{regClass} = $regClassID;
    #print STDERR "creating regclass $regClassID from regfile $ID\n";
    $Section{RegClass}{$regClassID}{what} = $what;
    $Section{RegClass}{$regClassID}{number} = $RegClass_number++;
    $Section{RegClass}{$regClassID}{regFile} = $ID;
    $Section{RegClass}{$regClassID}{registers} = $Section{RegFile}{$ID}{registers};
    my $multi = $$regFile{multi};
    if (defined $multi) {
      #print STDERR "\tRegFile $ID has multi\n";
      &multiRegClasses($regClassID, $ID, $multi);
    }
    my $execution = $$regFile{execution} || die "Missing execution for RegFile $ID";
    $Section{RegClass}{$regClassID}{execution} = $execution;
    $Section{RegClass}{$regClassID}{shortName} = $shortName;
  }
}

sub expand_registers {
  my ($registers) = @_;
  return $registers if (not defined $registers);
  my @registers;
  unless (ref $registers) {
    if ($registers =~ /^([\w]+)([0-9]+)\.\.\1([0-9]+)$/) {
      my ($prefix, $start, $stop) = ($1, $2, $3);
      @registers = map { sprintf "$prefix%d", $_ } ($start .. $stop);
    } else { die "Unrecognized registers: $registers"; }
    return \@registers;
  }
  foreach my $register (@{$registers}) {
    if ( ref($register) eq "ARRAY") {
      my ($prefix, $range) = @$register;
      for my $i (eval($range)) {
        my $reg_name = $prefix;
        $reg_name =~ s/<\w>/$i/;
        push @registers, $reg_name;
      }
    } else { push @registers, $register }
  }
  return \@registers;
}

# Process the RegClass section.
foreach my $regClass (@{$$Description{RegClass}}) {
  my $what = $$regClass{what};
  my $ID = $$regClass{ID} || die "Missing ID for RegClass";
#  print STDERR "REGCLASS $ID\n";
  die "RegClass $ID already exists" if exists $Section{RegClass}{$ID};
  my $shortName = $$regClass{shortName};
  #print STDERR "Enter \$Section{RegClass}{$ID}\n";
  $Section{RegClass}{$ID}{what} = $what;
  $Section{RegClass}{$ID}{number} = $RegClass_number++;
  $Section{RegClass}{$ID}{shortName} = $shortName;
  my $registers = &expand_registers($$regClass{registers});
  unless (defined $registers) {
    my $include = $$regClass{include} || die "Missing registers or include for RegClass $ID";
    $Section{RegClass}{$include} || die "Include registers from unknown RegClass $include";
    my %exclude; map {$exclude{$_}=1} @{&expand_registers($$regClass{exclude})};
    $registers = $Section{RegClass}{$include}{registers};
    my @registers = grep {!$exclude{$_}} @$registers;
    $registers = \@registers;
  }
  my $regFileID = undef;
  foreach my $register (@{$registers}) {
    die "Unknown register $register in RegClass $ID" unless defined $Section{Register}{$register};
    if (defined $regFileID) {
      die "Inconsistent RegFile in RegClass $ID" if $regFileID ne $Section{Register}{$register}{regFile};
    } else {
      $regFileID = $Section{Register}{$register}{regFile};
    }
  }
  $Section{RegClass}{$ID}{regFile} = $regFileID;
  unless (defined $Section{RegFile}{$regFileID}{regClass}) {
    # This the canonical RegClass for $regFileID.
    $Section{RegFile}{$regFileID}{regClass} = $ID;
  }
  # Process multi.
  my $multi = $$regClass{multi} || $Section{RegFile}{$regFileID}{multi};
  if (defined $multi) {
    #print STDERR "\tRegClass $ID has multi\n";
    $Section{RegClass}{$ID}{multi} = $multi;
    $Section{RegFile}{$regFileID}{multi} = $multi; # TODO: remove this.
    &multiRegClasses($ID, $regFileID, $multi);
  }
  $Section{RegClass}{$ID}{registers} = $registers;
  my $execution = $$regClass{execution} || die "Missing execution for RegClass $ID";
  $Section{RegClass}{$ID}{execution} = $execution;
  # Parse something like: GPR[%0] or XBR[(%0<<1)+1]
  $execution =~ s/\s+//g;
  if ($execution =~ s/(\w+)\[([^\]]+)\]/$2/) {
    die "Inconsistent RegFile $regFileID and $1 in RegClass $ID" if $1 ne $regFileID;
    die "Missing proxy in $regFileID index expression $2" unless $2 =~ /\%[0-9]/;
    if ($execution =~ s/([-+]\d+)$//) {
      my $bias = $1 + 0;
      $Section{RegClass}{$ID}{bias} = $bias;
    }
    if ($execution =~ s/<<(\d+)//) {
      my $shift = $1 + 0;
      $Section{RegClass}{$ID}{shift} = $shift;
    }
    $execution =~ s/^\(//; $execution =~ s/\)//; $execution =~ s/^(\%[0-9]|\w+)//;
    die "Unrecogized execution $execution in RegClass $ID" if $execution;
  } else { die "Unrecognized execution '$execution'"; }
}

# Process the Immediate section.
my $Immediate_number = 0;
foreach my $immediate (@{$$Description{Immediate}}) {
  my $what = $$immediate{what};
  my $ID = $$immediate{ID} || die "Missing ID for Immediate";
  die "Immediate $ID already exists" if exists $Section{Immediate}{$ID};
  my $shortName = $$immediate{shortName};
  $Section{Immediate}{$ID}{what} = $what;
  $Section{Immediate}{$ID}{number} = $Immediate_number++;
  $Section{Immediate}{$ID}{shortName} = $shortName;
  my $execution = $$immediate{execution} || die "Missing execution for Immediate $ID";
  $Section{Immediate}{$ID}{execution} = $execution;
  # Parse something like: _ZX_5(%0) or (_SX_27(%0)<<2)
  if ($execution =~ /^\(*_([SZW])X_([0-9]+)\s*\(\s*\%.\s*\)/) {
    $Section{Immediate}{$ID}{extend} = ($1 eq "S") ? "Signed" : (($1 eq "Z") ? "Unsigned" : "Wrap");
    $Section{Immediate}{$ID}{width} = $2;
  } else { die "Unrecognized execution '$execution' for Immediate $ID" }
  die "Immediate extend not defined" if not defined $Section{Immediate}{$ID}{extend};
  if ($execution =~ /<<\s*([0-9]+)\s*\)*\s*$/) {
    $Section{Immediate}{$ID}{shift} = $1;
  }
  $Section{Immediate}{$ID}{canExtend} = $$immediate{canExtend} if defined $$immediate{canExtend};
}


# Process the Modifier section.
my $Modifier_number = 0;
foreach my $modifier (@{$$Description{Modifier}}) {
  my $what = $$modifier{what};
  my $ID = $$modifier{ID} || die "Missing ID for Modifier";
  die "Modifier $ID already exists" if exists $Section{Modifier}{$ID};
  my $shortName = $$modifier{shortName};
  my $properties = $$modifier{properties} || { };
  $Section{Modifier}{$ID}{what} = $what;
  $Section{Modifier}{$ID}{number} = $Modifier_number++;
  $Section{Modifier}{$ID}{shortName} = $shortName;
  my $execution = $$modifier{execution} || die "Missing execution for Modifier $ID";
  $Section{Modifier}{$ID}{execution} = $execution;
  if ($execution =~ /^\(*_([SZ])X_([0-9]+)\s*\(\s*\%.\s*\)/) {
    $Section{Modifier}{$ID}{extend} = $1 eq "S" ? "Signed" : "Unsigned";
    $Section{Modifier}{$ID}{width} = $2;
  } else { die "Unrecognized execution '$execution' for Modifier $ID" }
  my $members = $$modifier{members} || die "Missing members for Modifier $ID";
  if (ref $members eq 'ARRAY' || !scalar(@{$members})) {
    $Section{Modifier}{$ID}{members} = $members;
    $Section{Modifier}{$ID}{values} = [ 0..scalar(@$members)-1 ];
  } else {
    die "Expecting array for members in Modifier $ID";
  }
  my $cases = $$modifier{cases};
  if (defined $cases) {
    die "Invalid cases for Modifier $ID" if ref $cases ne 'ARRAY';
    die "Wrong cases size for Modifier $ID" if scalar(@{$cases}) ne scalar(@{$members});
    $Section{Modifier}{$ID}{cases} = $cases;
  }
  if (keys %$properties) {
    my %member; map { $member{$_}=1 } @$members;
    foreach my $key (keys %$properties) {
      if ($key =~ /(\%\w+)(\.\S+)$/) {
        my ($proxy, $member) = ($1, $2);
        die "Unknown properties member '$member' in Modifier $ID" unless $member{$member};
      } else { die "Unrecogized properties key '$key' in Modifier $ID" }
    }
    $Section{Modifier}{$ID}{properties} = $properties;
  }
}


# Process the Macro section
foreach my $macro (@{$$Description{Macro}}) {
  my $ID = $$macro{ID} || die "Missing ID for Format";
  die "Macro $ID already exists" if exists $Section{Macro}{$ID};
  $Section{Macro}{$ID} = 1;
}

my %encoding = (
  '.O'=> 'double',
  '.D'=> 'triple',
  '.M'=> 'double',
  '.W'=> 'double',
  '.X'=> 'double',
  '.Y'=> 'triple',
);

# Process the Format section.
my $Format_number = 0;
my $Operand_number = 0;
my $Encoding_number = 0;
my %Encoding;
foreach my $format (@{$$Description{Format}}) {
  #print STDERR Dumper($format);
  my @fields = ();
  my $what = $$format{what};
  my $description = $$format{description};
  my $ID = $$format{ID} || die "Missing ID for Format";
  die "Format $ID already exists" if exists $Section{Format}{$ID};
  $Section{Format}{$ID}{what} = $what;
  $Section{Format}{$ID}{number} = $Format_number++;
  my $encoding = $$format{encoding} || die "Missing encoding for Format $ID";
  (my $suffixF = $ID) =~ s/[^\.]+//;
  if (length $suffixF) {
    die "Wrong suffix '$suffixF' for encoding $encoding in Format $ID" if $encoding{$suffixF} ne $encoding;
    $Encoding{$suffixF} = $encoding unless exists $Encoding{$suffixF};
  }
  my $execution = $$format{execution};
  my $properties = $$format{properties} || { };
  my $scheduling = $$format{scheduling};
  (my $suffixS = $scheduling) =~ s/[^\.]+//;
  if (length $suffixS && $encoding{$suffixS} ne $encoding) {
    die "Wrong suffix '$suffixS' for scheduling $scheduling in Format $ID";
  }
  my $syntax = $$format{syntax} || die "Missing syntax for Format $ID";
  push @fields, reverse @{$$format{fields}} if defined $$format{fields};
  push @fields, reverse @{$$format{fields0}} if defined $$format{fields0};
  push @fields, reverse @{$$format{fields1}} if defined $$format{fields1};
  push @fields, reverse @{$$format{fields2}} if defined $$format{fields2};
  push @fields, reverse @{$$format{fields3}} if defined $$format{fields3};
  push @fields, reverse @{$$format{fields4}} if defined $$format{fields4};
  push @fields, reverse @{$$format{fields5}} if defined $$format{fields5};
  push @fields, reverse @{$$format{fields6}} if defined $$format{fields6};
  push @fields, reverse @{$$format{fields7}} if defined $$format{fields7};
  die "Missing fields for Format $ID" unless @fields;
  # Process fields.
  my $offset = 0;
  my %fields = ();
  my @format_fields;
  my @format_patterns;
  foreach my $field (@fields) {
    my ($fieldID) = keys %{$field};
    push @format_fields, $fieldID;
    my $contents = $$field{$fieldID};
    my ($width, $opcode, $operand);
    if (ref $contents eq 'HASH') {
      ($width, $opcode) = &opcode($ID, $fieldID, $contents);
      $Section{Format}{$ID}{fields}{$offset} = [ $fieldID, $width, $opcode ];
    } elsif (!ref $contents) {
      $width = length($contents);
      $Section{Format}{$ID}{fields}{$offset} = [ $fieldID, $width, $contents ];
    } else { die "Invalid value for field $fieldID in Format $ID"; }
    $fields{$offset} = [ $fieldID, $width, $contents ];
    # Fill BitField.
    $Section{BitField}{$fieldID}{width} = $width unless exists $Section{BitField}{$fieldID}{width};
    die "Inconsistent $fieldID width in Format $ID" unless $Section{BitField}{$fieldID}{width} == $width;
    $Section{BitField}{$fieldID}{offset} = $offset unless exists $Section{BitField}{$fieldID}{offset};
    die "Inconsistent $fieldID offset in Format $ID" unless $Section{BitField}{$fieldID}{offset} == $offset;
    $offset += $width;
    if (not grep { $_ eq $fieldID } @{$$format{operand}}) {
      if (not ref $contents and $contents =~ /^([0-1]+)$/) {
        my $patternID = "$ID.$fieldID";
        push @format_patterns, $patternID;
        $Section{Pattern}{$patternID}{fields} = $fieldID;
        $Section{Pattern}{$patternID}{values} = "0b".$contents;
      }
    }
  }
  # Fill MDS Format
  $Section{Format}{$ID}{encoding} = $encoding;
  $Section{Format}{$ID}{patterns} = \@format_patterns if @format_patterns;
  $Section{Format}{$ID}{execution} = $execution if defined $execution;
  $Section{Format}{$ID}{properties} = $properties if keys %$properties;
  if (defined $scheduling) {
    if (ref $scheduling eq 'HASH') {
      my %expanded_scheduling;
      foreach my $key (keys %$scheduling) {
        if ($key =~ /^\[([^]]*)\]$/) {
          foreach my $insn (split ',', ($1 =~ s/ //gr)) {
            $expanded_scheduling{$insn} = $$scheduling{$key};
          }
        } else {
          die "Bad format in the scheduling of $ID."
        }
      }
      $Section{Format}{$ID}{scheduling} = \%expanded_scheduling;
    } else {
      $Section{Format}{$ID}{scheduling} = $scheduling;
    }
  }
  # Fill MDS Encoding.
  my $wordWidth = 32;
  my $wordCount = $offset/$wordWidth;
  die "Problem with $encoding count and width in Format $ID" unless $wordCount*$wordWidth == $offset;
  unless (exists $Section{Encoding}{$encoding}) {
    $Section{Encoding}{$encoding}{wordWidth} = $wordWidth;
    $Section{Encoding}{$encoding}{wordCount} = $wordCount;
    $Section{Encoding}{$encoding}{number} = $Encoding_number++;
  }
  # Process operands.
  my $operands = $$format{operands};
  #print STDERR Dumper($operands);
  my (@operands, @methods);
  foreach my $operand (@{$operands}) {
    if (ref $operand eq 'HASH') {
      my ($methodID) = keys %{$operand};
      my @fields = (ref $$operand{$methodID} eq 'ARRAY')? @{$$operand{$methodID}}: ($$operand{$methodID});
      foreach my $field (@fields) {
        die "Unknown field $field in Format $ID" unless grep { $_ eq $field } @format_fields;
      }
      my $operandID = join '_', @fields;
      push @operands, &operand($ID, $methodID, $operandID, \@fields);
      push @methods, $methodID;
    } elsif (!ref $operand) {
      my $methodID = $operand;
      my $operandID = $operand;
      my $field = $operand;
      die "Unknown field $field in Format $ID" unless grep { $_ eq $field } @format_fields;
      push @operands, &operand($ID, $methodID, $operandID, [ $field ]);
      push @methods, $methodID;
    } else { die "Operand must be an scalar or map in Format $ID"; }
  }
  # Check syntax.
  my @proxies = $syntax =~ /(?<!\%)(%[0-9]+)/g;
  if ((scalar @proxies) != (scalar @operands) + 1) {
    die "Mismatch between operands and syntax in Format $ID:",
        "\tPROXIES=@proxies OPERANDS=@operands\n";
  }
  $Section{Format}{$ID}{syntax} = $syntax;
  $Section{Format}{$ID}{description} = $description if defined $description;
  $Section{Format}{$ID}{operator} = $$format{operator} if defined $$format{operator};
  $Section{Format}{$ID}{operands} = \@operands;
  $Section{Format}{$ID}{methods} = \@methods;
  #
  my $behavior = "";
  my @behavior = split(/\n/, $$format{behavior}) if defined $$format{behavior};
  foreach my $line (@behavior) {
    $line =~ s|^\s*#.+$||g;
    $behavior .= $line."\n" if $line ne "";
  }
  $Section{Format}{$ID}{behavior} = $behavior;
}

sub operand {
  my ($ID, $methodID, $operandID, $fields) = @_;
#  print STDERR "*** Operand $methodID $operandID\n";
  $methodID = $operandID unless defined $methodID;
  my $shortName;
  my $methodType = undef;
#  print STDERR "*** Operand $operandID\n";
  foreach my $s (keys %Section) {
    if (exists $Section{$s}{$methodID}) {
#      print STDERR "  * Section $s exists for $operandID (method $methodID)\n";
    }
  }
#  print STDERR "*** Operand $operandID\n";
#  print STDERR "Exists \$Section{RegClass}{$methodID} ? ($Section{RegClass}{$methodID})\n";
  if (exists $Section{RegClass}{$methodID}) {
    die "Ambiguous method type (RegClass or $methodType) for Operand $operandID" if defined $methodType;
    $methodType = 'RegClass';
    $shortName = $Section{RegClass}{$methodID}{shortName};
#    print STDERR "  * Section, shortName is $shortName\n";
  }
  if (exists $Section{Immediate}{$methodID}) {
    die "Ambiguous method type (Immediate or $methodType) for Operand $operandID" if defined $methodType;
    $methodType = 'Immediate';
    $shortName = $Section{Immediate}{$methodID}{shortName};
  }
  if (exists $Section{Modifier}{$methodID}) {
    die "Ambiguous method type (Modifier or $methodType) for Operand $operandID" if defined $methodType;
    $methodType = 'Modifier';
    $shortName = $Section{Modifier}{$methodID}{shortName};
  }
  die "Operand $operandID has no method in Format $ID" unless defined $methodType;
  if (exists $Section{Operand}{$operandID}) {
    my ($operand_methodType) = keys %{$Section{Operand}{$operandID}{method}};
    my $operand_methodID = $Section{Operand}{$operandID}{method}{$operand_methodType};
    die "$ID: Redefinition of method $methodID type (was $operand_methodType) for Operand $operandID"
      unless $methodType eq $operand_methodType;
    die "$ID: Redefinition of method $methodID name (was $operand_methodID) for Operand $operandID"
      unless $methodID eq $operand_methodID;
  } else {
    $Section{Operand}{$operandID}{number} = $Operand_number++;
    $Section{Operand}{$operandID}{what} = $Section{$methodType}{$methodID}{what};
    $Section{Operand}{$operandID}{method} = { $methodType=> $methodID };
    $Section{Operand}{$operandID}{shortName} = $shortName if $shortName;
    foreach my $field (@$fields) {
      die "Field $field does not exists" unless defined $Section{BitField}{$field};
    }
    $Section{Operand}{$operandID}{fields} = $fields;
    # Create the Operand(s) implied by the multi RegClass(es).
    if ($methodType eq 'RegClass') {
      #print STDERR "OPERANDS for $methodID\t";
      my $regFileID = $Section{RegClass}{$methodID}{regFile};
      #print STDERR "$regFileID\t";
      my $multi = $Section{RegClass}{$methodID}{multi} || $Section{RegFile}{$regFileID}{multi};
      if (defined $multi) {
        #print STDERR "has multi\n";
        my $index = 0;
        foreach my $multiID (@$multi) {
          my $operandID_m = "${operandID}.$index";
          #print STDERR "\t$multiID:\t$operandID_m\n";
          $Section{Operand}{$operandID_m}{number} = $Operand_number++;
          $Section{Operand}{$operandID_m}{what} = $Section{Operand}{$operandID}{what}." Multi $index";
          $Section{Operand}{$operandID_m}{method} = { $methodType=> "$methodID.$index" };
          $Section{Operand}{$operandID_m}{shortName} = "$shortName$index" if $shortName;
          $Section{Operand}{$operandID_m}{fields} = $Section{Operand}{$operandID}{fields};
          $index++;
        }
      } else {
        #print STDERR "has no multi\n";
      }
    }
  }
  return $operandID;
}

sub opcode {
  my $width = 0;
  my %opcode = ();
  my ($ID, $name, $contents) = @_;
  #print STDERR Dumper($contents);
  die "Unknown contents type:\t", Dumper($contents) unless ref $contents eq 'HASH';
  while (my ($value, $key) = each %{$contents}) {
    if ($key =~ /^([01]+)$/) {
      if ($width && $width != length $1) {
        die "Invalid width $width in Format $ID:\t", Dumper($key);
      } else { $width = length $1; }
      $width = length $1;
      my $number = oct("0b$1");
      $opcode{$number} = [ ] if (not exists $opcode{$number});
      if ($value =~ /^\[([^]]*)\]$/) {
        foreach my $insn (split ',', ($1 =~ s/ //gr)) {
          push @{$opcode{$number}}, $insn;
        }
      } else {
        push @{$opcode{$number}}, $value;
      }
      if (ref $value eq 'HASH') {
        # Format $ID is the parent of Format(s) keys %{$value}.
        my $binary = sprintf("\%0${width}b", $number);
        $Section{Format}{$ID}{children}{$binary} = [ $name, keys %{$value} ];
        # print STDERR "Format $ID children:", Dumper($Section{Format}{$ID}{children});
      } elsif (ref $value) { die "Invalid value $value in Format $ID:\t", Dumper($value); }
    } elsif ($key =~ /^([01]+)\.\.([01]+)$/) {
      if ($width && $width != length $1) {
        die "Invalid width $width in Format $ID:\t", Dumper($key);
      } else { $width = length $1; }
      if ($width && $width != length $2) {
        die "Invalid width $width in Format $ID:\t", Dumper($key);
      } else { $width = length $2; }
      my ($opcode1, $opcode2) = (oct("0b$1"), oct("0b$2"));
      if (ref $value eq 'HASH') {
        # Format $ID is the parent of Format(s) keys %{$value}.
        for (my $number = $opcode1; $number <= $opcode2; $number++) {
          my $binary = sprintf("\%0${width}b", $number);
          $Section{Format}{$ID}{children}{$binary} = [ $name, keys %{$value} ];
          #print STDERR "Format $ID children:", Dumper($Section{Format}{$ID}{children});
        }
      } elsif ($value =~ /^\[([^]]*)\]$/) {
        my @insn = split ',', ($1 =~ s/ //rg);
        my $index = 0;
        for (my $number = $opcode1; $number <= $opcode2; $number++) {
          my $binary = sprintf("\%0${width}b", $number);
          my $operation = $insn[$index++];
          unless (defined $operation) {
            die "Not enough operations for $name in Format $ID:\t", Dumper($key, @insn);
          }
          # print STDERR "$operation: $binary ($ID)\n";
          unless ($operation =~ /^[\w\.]+$/) {
            die "Invalid operation name $operation for $binary in Format $ID:\t", Dumper($key, @insn);
          }
          $opcode{$number} = [ ] if (not exists $opcode{$number});
          push @{$opcode{$number}}, $operation;
        }
        if (defined $insn[$index]) {
          die "Extra operation $$value[$index] for $name in Format $ID:\t", Dumper($key, @insn);
        }
      } else {
        $value =~ /^[\w\.]+$/ or die "Invalid value $value in Format $ID:\t", Dumper($key, $value);
        for (my $number = $opcode1; $number <= $opcode2; $number++) {
          my $operation = $value;
          my $binary = sprintf("\%0${width}b", $number);
          if (exists $opcode{$number}) {
            die "Redefinition with $operation for $binary in Format $ID:\t", Dumper($key, $value);
          }
          $opcode{$number} = $operation;
        }
      }
    } else {
      die "Invalid contents key in Format $ID:\t", Dumper($key);
    }
  }
  #foreach my $number (0 .. (1<<$width) - 1) {
    #my $binary = sprintf("\%0${width}b", $number);
    #die "Missing assignment for $binary in field of Format $ID" unless exists $opcode{$number};
  #}
  return $width, \%opcode;
}

# Process the Format samefields.
foreach my $format (@{$$Description{Format}}) {
  my $this_ID = $$format{ID} || die "Missing ID for Format";
  my $samefields = $$format{samefields};
  next unless defined $samefields;
  my $this_fields = $Section{Format}{$this_ID}{fields};
  while (my ($same_ID, $same_bits) = each %{$samefields}) {
    my $this_scheduling = $Section{Format}{$this_ID}{scheduling};
    my $same_scheduling = $Section{Format}{$same_ID}{scheduling};
    if ((ref $this_scheduling eq 'HASH') && (ref $same_scheduling eq 'HASH')) {
      # The keys (i.e. instructions) covered by both hashs should have the same
      # scheduling class.
      my %this_insn_sched;
      my %same_insn_sched;

      foreach my $key (sort keys %$this_scheduling) {
        if ($key =~ /^\[([^]]*)\]$/) {
          my @insn = sort (split ',', ($1 =~ s/ //rg));
          foreach my $insn (@insn) {
            $this_insn_sched{$insn} = $$this_scheduling{$key};
          }
        } else {
          $this_insn_sched{$key} = $$this_scheduling{$key};
        }
      }

      foreach my $key (sort keys %$same_scheduling) {
        if ($key =~ /^\[([^]]*)\]$/) {
          my @insn = sort (split ',', ($1 =~ s/ //rg));
          foreach my $insn (@insn) {
            $same_insn_sched{$insn} = $$same_scheduling{$key};
          }
        } else {
          $same_insn_sched{$key} = $$same_scheduling{$key};
        }
      }

      my @this_keys = sort (keys %this_insn_sched);
      my @same_keys = sort (keys %same_insn_sched);

      die "Format mismatch between the scheduling classes of $this_ID and $same_ID"
          unless @this_keys eq @same_keys;

      foreach my $insn (@this_keys) {
        my $this_real_scheduling = $this_insn_sched{$insn};
        my $same_real_scheduling = $same_insn_sched{$insn};
        die "Format mismatch between $this_ID:$this_real_scheduling and $same_ID:$same_real_scheduling"
            unless index($this_real_scheduling, "$same_real_scheduling.") == 0;
      }
    } elsif ((ref $this_scheduling eq 'HASH') && (ref $same_scheduling ne 'HASH')) {
      foreach my $key (sort keys %$this_scheduling) {
        my $this_real_scheduling = $$this_scheduling{$key};
        die "Format mismatch between $this_ID:$this_real_scheduling and $same_ID:$same_scheduling"
            unless index($this_real_scheduling, "$same_scheduling.") == 0;
      }
    } elsif ((ref $this_scheduling ne 'HASH') && (ref $same_scheduling eq 'HASH')) {
      foreach my $key (sort keys %$same_scheduling) {
        my $same_real_scheduling = $$same_scheduling{$key};
        die "Format mismatch between $this_ID:$this_scheduling and $same_ID:$same_real_scheduling"
            unless index($this_scheduling, "$same_real_scheduling.") == 0;
      }
    } else {
      die "Format mismatch between $this_ID:$this_scheduling and $same_ID:$same_scheduling"
          unless index($this_scheduling, "$same_scheduling.") == 0;
    }
    die "Error in Format $this_ID samefields: $same_ID unknown\n" unless defined $Section{Format}{$same_ID};
    my $same_fields = $Section{Format}{$same_ID}{fields};
    my ($first_bit, $last_bit) = split /\.\./, $same_bits;
    my @this_offsets = grep {$_ >= $first_bit && $_ < $last_bit} sort {$a<=>$b} keys %$this_fields;
    my @same_offsets = grep {$_ >= $first_bit && $_ < $last_bit} sort {$a<=>$b} keys %$same_fields;
    if (@this_offsets != @same_offsets) {
      my ($this_count, $same_count) = (scalar (@this_offsets), scalar (@same_offsets));
      #print STDERR "$this_ID\t", Dumper @this_offsets;
      #print STDERR "$same_ID\t", Dumper @same_offsets;
      die "Error in Format $this_ID samefields $same_ID: $this_count and $same_count fields\n";
    }
    while (@this_offsets && @same_offsets) {
      my $this_offset = shift @this_offsets;
      my $same_offset = shift @same_offsets;
      if ($this_offset != $same_offset) {
        die "Error in Format $this_ID samefields $same_ID: offsets $this_offset and $same_offset\n";
      }
      my ($this_name, $this_width, $this_contents) = @{$$this_fields{$this_offset}};
      my ($same_name, $same_width, $same_contents) = @{$$same_fields{$same_offset}};
      if (0 && $this_name ne $same_name) {
        die "Error in Format $this_ID samefields $same_ID: names $this_name and $same_name\n";
      }
      if (ref $this_contents ne ref $same_contents) {
        die "Error in Format $this_ID samefields $same_ID $this_name: contents differ\n";
      }
       if (!ref $this_contents) {
        if ($this_contents ne $same_contents) {
          die "Error in Format $this_ID samefields $same_ID $this_name: contents $this_contents and $same_contents\n";
        }
      }
    }
  }
}

# Process the Dispersal section
my $Dispersal_number = 0;
foreach my $dispersal (@{$$Description{Dispersal}}) {
  #print STDERR Dumper($dispersal);
  my $what = $$dispersal{what};
  my $ID = $$dispersal{ID} || die "Missing ID for Dispersal";
  my $fromFields = get_required_attribute("Dispersal",$ID,$dispersal,"fromFields");
  my $toFields = get_required_attribute("Dispersal",$ID,$dispersal,"toFields");
  my $nopValues = get_implied_attribute("Dispersal",$ID,$dispersal,"nopValues");
  my $distance = get_required_attribute("Dispersal",$ID,$dispersal,"distance");
  $Section{Dispersal}{$ID}{what} = $what;
  $Section{Dispersal}{$ID}{number} = $Dispersal_number++;
  $Section{Dispersal}{$ID}{fromFields} = $fromFields;
  $Section{Dispersal}{$ID}{toFields} = $toFields;
  $Section{Dispersal}{$ID}{nopValues} = $nopValues;
  $Section{Dispersal}{$ID}{distance} = $distance;
}


# Process the Resource section
my $Resource_number = 0;
foreach my $resource (@{$$Description{Resource}}) {
  #print STDERR Dumper($resource);
  my $what = $$resource{what};
  my $ID = $$resource{ID} || die "Missing ID for Resource";
  my $availability = get_required_attribute("Resource",$ID,$resource,"availability");
  $Section{Resource}{$ID}{what} = $what;
  $Section{Resource}{$ID}{number} = $Resource_number++;
  $Section{Resource}{$ID}{availability} = $availability;
}


# Process the Reservation section
my $Reservation_number = 0;
foreach my $reservation (@{$$Description{Reservation}}) {
  #print STDERR Dumper($reservation);
  my $what = $$reservation{what};
  my $ID = $$reservation{ID} || die "Missing ID for Reservation";
  my $resources = get_required_attribute("Reservation",$ID,$reservation,"resources");
  my $requirements = get_required_attribute("Reservation",$ID,$reservation,"requirements");
  die "Missing requirements in Reservation $ID" unless @{$requirements} >= @{$resources};
  my $stalls = get_implied_attribute("Reservation",$ID,$reservation,"stalls");
  $Section{Reservation}{$ID}{what} = $what;
  $Section{Reservation}{$ID}{number} = $Reservation_number++;
  $Section{Reservation}{$ID}{resources} = $resources;
  $Section{Reservation}{$ID}{requirements} = $requirements;
  $Section{Reservation}{$ID}{stalls} = $stalls;
}


# Process the Bundling section
my $Bundling_number = 0;
foreach my $bundling (@{$$Description{Bundling}}) {
  #print STDERR Dumper($bundling);
  my $what = $$bundling{what};
  my $ID = $$bundling{ID} || die "Missing ID for Bundling";
  my $dispersals = get_required_attribute("Bundling",$ID,$bundling,"dispersals");
  $Section{Bundling}{$ID}{what} = $what;
  $Section{Bundling}{$ID}{number} = $Bundling_number++;
  $Section{Bundling}{$ID}{dispersals} = $dispersals;
}


# Process the Scheduling section
my $Scheduling_number = 0;
foreach my $scheduling (@{$$Description{Scheduling}}) {
  #print STDERR Dumper($scheduling);
  my $what = $$scheduling{what};
  my $ID = $$scheduling{ID} || die "Missing ID for Scheduling";
  my $bundling = get_required_attribute("Scheduling",$ID,$scheduling,"bundling");
  my $reservation = get_required_attribute("Scheduling",$ID,$scheduling,"reservation");
  $Section{Scheduling}{$ID}{what} = $what;
  $Section{Scheduling}{$ID}{number} = $Scheduling_number++;
  $Section{Scheduling}{$ID}{bundling} = $bundling;
  $Section{Scheduling}{$ID}{reservation} = $reservation;
}

# Process the Instruction section.
my $Instruction_number = 0;
foreach my $instruction (@{$$Description{Instruction}}) {
  #print STDERR Dumper($instruction);
  my @formats = $$instruction{formats}? @{$$instruction{formats}}: ();
  die "Missing formats for Instruction $$instruction{ID}" unless scalar @formats;
  my $what = $$instruction{what};
  my $description = $$instruction{description};
  my $motivation = $$instruction{motivation};
  my $properties = $$instruction{properties} || { };
  my $syntax = $$instruction{syntax};
  my $class = $$instruction{class};
  unless (defined $class) {
    ($class) = split /_/, $formats[0];
  }
  my $ID = "$class:$$instruction{ID}";
  die "Instruction $ID already exists" if exists $Section{Instruction}{$ID};
  my @formats = $$instruction{formats}? @{$$instruction{formats}}: ();
  die "Missing formats for Instruction $ID" unless scalar @formats;
  #print STDERR "Instruction $ID\n";
  my @schedulings = ();
  # Instruction schedulings that override format schedulings if it exists
  my @instr_schedulings = $$instruction{schedulings}? @{$$instruction{schedulings}}: ();
  die "Mismatch between Instruction $ID formats and schedulings" if @instr_schedulings && @instr_schedulings != @formats;
  my $format_index = -1;
  foreach my $formatID (@formats) {
    next if $formatID =~ /^\*/;
    die "Unknown format $formatID for Instruction $ID" unless defined $Section{Format}{$formatID};
    my @matches;
    my $format_fields = $Section{Format}{$formatID}{fields};
    while (my ($offset, $array) = each %{$format_fields}) {
      if (ref $array eq "ARRAY") {
        my ($field, $width, $contents) = @{$array};
        if (ref $contents eq 'HASH') {
          while (my ($opcode, $names) = each %{$contents}) {
            foreach my $name (@$names) {
              if ("$class:$name" eq $ID) {
                push @matches, [ $formatID, $field, $offset, $width, $opcode ];
              }
            }
          }
        }
      }
    }
    if (@matches) {
      $format_index++;
      for my $match (@matches) {
        my ($formatID, $field, $offset, $width, $opcode) = @{$match};
        my $value = sprintf("0b\%0${width}b", $opcode);
        my $pattern = "${formatID}:${ID}.${field}";
        if (defined $Section{Pattern}{$pattern}{fields}) {
          die "Redefinition of pattern $pattern field in format $formatID"
            unless $Section{Pattern}{$pattern}{fields} eq $field;
        }
        $Section{Pattern}{$pattern}{fields} = $field;
        if (defined $Section{Pattern}{$pattern}{values}) {
          die "Redefinition of pattern $pattern value in format $formatID"
            unless $Section{Pattern}{$pattern}{values} eq $value;
        }
        $Section{Pattern}{$pattern}{values} = $value;
        # if (defined $Section{Instruction}{$ID}{patterns}) {
        #   my ($instruction_pattern) = @{$Section{Instruction}{$ID}{patterns}};
        #   if ($instruction_pattern ne $pattern) {
        #     croak "Pattern mismatch ($instruction_pattern and $pattern) for Instruction $ID";
        #   }
        # } else {
          push @{$Section{Instruction}{$ID}{patterns}}, $pattern unless $pattern ~~ @{$Section{Instruction}{$ID}{patterns}};
        # }
      }
    } else { die "No Instruction $ID in Format $formatID:\t", Dumper($format_fields); }
    my $scheduling = $schedulings[$format_index] || $Section{Format}{$formatID}{scheduling};
    if (ref $scheduling eq 'HASH') {
      my $name = $$instruction{ID};
      $scheduling = $$scheduling{$name};
    }
    unless (defined $Section{Scheduling}{$scheduling}) {
      print STDERR Dumper($scheduling);
      die "Scheduling $scheduling not defined for Instruction $ID in Format $formatID"
    }
    $schedulings[$format_index] = $scheduling;
  }
  if (scalar (grep { ! ($_ =~ /^\*/) } @formats) != 0) {
    $Section{Instruction}{$ID}{what} = $what;
    $Section{Instruction}{$ID}{number} = $Instruction_number++;
    $Section{Instruction}{$ID}{class} = $class;
    $Section{Instruction}{$ID}{mnemonic} = lc $$instruction{ID};
    $Section{Instruction}{$ID}{formats} = [ grep { ! ($_ =~ /^\*/) } @formats ];
    $Section{Instruction}{$ID}{schedulings} = \@schedulings;
    $Section{Instruction}{$ID}{schedulings} = \@instr_schedulings if @instr_schedulings;
    $Section{Instruction}{$ID}{syntax} = $syntax if defined $syntax;
    $Section{Instruction}{$ID}{description} = $description if defined $description;
    $Section{Instruction}{$ID}{motivation} = $motivation if defined $motivation;
    $Section{Instruction}{$ID}{properties} = $properties if keys %$properties;
    $Section{Instruction}{$ID}{execution} = $$instruction{execution} if defined $$instruction{execution};
    my $behavior = "";
    my @behavior = split(/\n/, $$instruction{behavior}) if defined $$instruction{behavior};
    foreach my $line (@behavior) {
      $line =~ s|^\s*#.+$||g;
      $behavior .= $line."\n" if $line ne "";
    }
    $Section{Instruction}{$ID}{behavior} = $behavior;
  }
}


# Process the Synthetic section.
my $Synthetic_number = 0;
foreach my $synthetic (@{$$Description{Synthetic}}) {
  #print STDERR Dumper($synthetic);
  my @formats = $$synthetic{formats}? @{$$synthetic{formats}}: ();
  die "Missing formats for Synthetic $$synthetic{ID}" unless scalar @formats;
  foreach my $formatID (@formats) {
    die "Unknown Format $formatID for Synthetic $$synthetic{ID}" unless defined $Section{Format}{$formatID}
  }
  my $class = $$synthetic{class};
  unless (defined $class) {
    ($class) = split /_/, $formats[0];
  }
  my $ID = "$class:$$synthetic{ID}";
  die "Synthetic $ID already exists" if exists $Section{Synthetic}{$ID};
  my $what = $$synthetic{what};
  my $properties = $$synthetic{properties} || { };
  my @schedulings = $$synthetic{schedulings}? @{$$synthetic{schedulings}}: ();
  $Section{Synthetic}{$ID}{what} = $what;
  $Section{Synthetic}{$ID}{number} = $Synthetic_number++;
  my $instructionID = "$class:$$synthetic{instruction}";
  die "Unknown Instruction $instructionID for Synthetic $ID" unless defined $Section{Instruction}{$instructionID};
  my @instr_formats = $Section{Instruction}{$instructionID}{formats}? @{$Section{Instruction}{$instructionID}{formats}}: ();
  my $specialize = $$synthetic{specialize};
  my $syntax = $$synthetic{syntax};
  if (not defined $syntax and not defined $specialize) {
      # This is just an asm alias. Get syntax from formats
      $specialize = {};
      $syntax = $Section{Format}{$formats[0]}{syntax};
  }
  die "Missing specialize for Synthetic $ID" unless ref $specialize eq 'HASH'; 
  die "Missing syntax for Synthetic $ID" unless defined $syntax;
  my (@forced, @values);
  foreach my $proxy (sort keys %{$specialize}) {
    my $value = $$specialize{$proxy};
    $proxy =~ /^\%[1-9]$/ || die "Invalid proxy $proxy in Synthetic $ID specialize";
    push @forced, $proxy;
    push @values, ($value =~ /^0/)? oct($value): $value;
    #print STDERR "proxy=$proxy\tvalue=$value => $values[-1]\n";
  }
  foreach my $formatID (@formats) {
    next if $formatID =~ /^\*/;
    die "Unknown format $formatID for Synthetic $ID" unless defined $Section{Format}{$formatID};
    my $find_format = 0;
    foreach my $instr_formatID (@instr_formats) {
      if ($formatID eq $instr_formatID) {
        $find_format = 1;
      }
    }
    die "Format $formatID not defined in instruction $instructionID (@instr_formats)" unless $find_format;
  }
  $Section{Synthetic}{$ID}{forced} = [ @forced ];
  $Section{Synthetic}{$ID}{values} = [ @values ];
  $Section{Synthetic}{$ID}{instruction} = "$class:$$synthetic{instruction}";
  $Section{Synthetic}{$ID}{properties} = $properties if keys %$properties;
  $Section{Synthetic}{$ID}{formats} = [ @formats ];
  $Section{Synthetic}{$ID}{schedulings} = [ @schedulings ];
  $Section{Synthetic}{$ID}{mnemonic} = lc $$synthetic{ID};
  $Section{Synthetic}{$ID}{class} = $class;
  $Section{Synthetic}{$ID}{syntax} = $syntax;
  $Section{Synthetic}{$ID}{execution} = $$synthetic{execution} if defined $$synthetic{execution};
  my $behavior = "";
  my @behavior = split(/\n/, $$synthetic{behavior}) if defined $$synthetic{behavior};
  foreach my $line (@behavior) {
    $line =~ s|^\s*#.+$||g;
    $behavior .= $line."\n" if $line ne "";
  }
  $Section{Synthetic}{$ID}{behavior} = $behavior;
}


# Process the Simulated section.
my $Simulated_number = 0;
foreach my $simulated (@{$$Description{Simulated}}) {
  #print STDERR Dumper($simulated);
  my $ID = $$simulated{ID};
  die "Simulated $ID already exists" if exists $Section{Simulated}{$ID};
  my $attributes = $$simulated{attributes};
  $Section{Simulated}{$ID}{mnemonic} = $ID;
  $Section{Simulated}{$ID}{syntax} = $$simulated{syntax};
  $Section{Simulated}{$ID}{attributes} = $attributes;
  $Section{Simulated}{$ID}{scheduling} = $$simulated{scheduling};
  $Section{Simulated}{$ID}{number} = $Simulated_number++;
  $Section{Simulated}{$ID}{parameters} = [ @{$$simulated{parameters}} ];
}

# Process the Generic section.
my $Generic_number = 0;
foreach my $generic (@{$$Description{Generic}}) {
  #print STDERR Dumper($generic);
  my $ID = $$generic{ID};
  die "Generic $ID already exists" if exists $Section{Generic}{$ID};
  my $attributes = $$generic{attributes};
  $Section{Generic}{$ID}{mnemonic} = $ID;
  $Section{Generic}{$ID}{attributes} = $attributes;
  $Section{Generic}{$ID}{syntax} = $$generic{syntax};
  $Section{Generic}{$ID}{number} = $Generic_number++;
  $Section{Generic}{$ID}{parameters} = [ @{$$generic{parameters}} ];
}


# Process the Relocation section.
my $Relocation_number = 0;
foreach my $relocation (@{$$Description{Relocation}}) {
  #print STDERR Dumper($relocation);
  my $ID = $$relocation{ID};
  die "Relocation $ID already exists" if exists $Section{Relocation}{$ID};
  $Section{Relocation}{$ID}{relative} = $$relocation{relative} if defined $$relocation{relative};
  $Section{Relocation}{$ID}{type} = $$relocation{type} if defined $$relocation{type};
  $Section{Relocation}{$ID}{syntax} = $$relocation{syntax} if defined $$relocation{syntax};
  $Section{Relocation}{$ID}{overflow} = $$relocation{overflow} if defined $$relocation{overflow};
  $Section{Relocation}{$ID}{underflow} = $$relocation{underflow} if defined $$relocation{underflow};
  $Section{Relocation}{$ID}{scaling} = $$relocation{scaling} if defined $$relocation{scaling};
  if (not defined $$relocation{linker}) {
    croak "Relocation: Undefined linker attribute";
  }
  $Section{Relocation}{$ID}{linker} = $$relocation{linker};
  if (not defined $$relocation{elfIds}) {
    croak "Relocation: Undefined elfIds attribute";
  }
  $Section{Relocation}{$ID}{elfIds} = $$relocation{elfIds};
  if (not defined $$relocation{elfIds}) {
    croak "Relocation: Undefined fields attribute";
  }
  $Section{Relocation}{$ID}{fields} = $$relocation{fields};
  $Section{Relocation}{$ID}{number} = $Relocation_number++;
  my $operands = $$relocation{operands};
  foreach my $operand (@$operands) {
    if (not defined $Section{Operand}{$operand}) {
      croak "Unknown relocated operand $operand";
    }
    push @{$Section{Operand}{$operand}{relocations}}, $ID;
    $Section{Operand}{$operand}{default} = 0;
  }
}


# Process the Builtin section
my $Builtin_number = 0;
foreach my $builtin (@{$$Description{Builtin}}) {
  #print STDERR Dumper($builtin);
  my $what = $$builtin{what};
  my $ID = $$builtin{ID} || die "Missing ID for Builtin";
  my $declaration = $$builtin{declaration};
  my $definition = $$builtin{definition};
  my $prototype = $$builtin{prototype};
  if (defined $prototype) {
    $prototype =~ /$ID/i || die "Builtin prototype '$prototype' does not match $ID";
    $declaration = '' unless defined $declaration;
    $declaration .= $prototype;
  }
  my $emulation = $$builtin{emulation};
  if (defined $emulation) {
    $definition = '' unless defined $definition;
    (my $implement = $prototype) =~ s/;\s*$//;
    $definition .= "$implement\n{\n$emulation}\n";
  }
  my $instructionID = $$builtin{instruction};
  if (defined $instructionID) {
    $ID =~ /$instructionID/i || warn "Builtin instruction '$instructionID' does not match $ID";
    exists $Section{Instruction}{$instructionID}
        || die "Unknown Instruction $instructionID in Builtin $ID";
    my $instruction_formats = $Section{Instruction}{$instructionID}{formats};
    my %formatIDs; map {$formatIDs{$_}++} @{$instruction_formats};
    my @formatIDs = $$builtin{formats}? @{$$builtin{formats}}: @{$instruction_formats};
    my @operands = $$builtin{operands}? @{$$builtin{operands}}: ();
    foreach my $formatID (@formatIDs) {
      unless (defined $formatIDs{$formatID}) {
        die "Unknown format $formatID for Instruction $instructionID in Builtin $ID";
      }
      unless (@{$Section{Format}{$formatID}{operands}} == @operands) {
        die "Number of operands (", scalar @operands,
            ") does not match Format $formatID in Builtin $ID";
      }
    }
    $Section{Builtin}{$ID}{instruction} = $instructionID;
    $Section{Builtin}{$ID}{operands} = [ @operands ];
    $Section{Builtin}{$ID}{formats} = [ @formatIDs ];
  }
  $Section{Builtin}{$ID}{number} = $Builtin_number++;
  $Section{Builtin}{$ID}{declaration} = $declaration;
  $Section{Builtin}{$ID}{definition} = $definition;
  $Section{Builtin}{$ID}{prototype} = $prototype;
}


my @Fixup = qw(
BitField Convention NativeType Pattern Platform Processor Template
);

foreach my $fixup (@Fixup) {
  my $fixup_number = 0;
  foreach my $entry (@{$$Description{$fixup}}) {
    my $ID = $$entry{ID} || die "Undefined $fixup ID.";
    foreach my $attribute (keys %$entry) {
      if ($attribute ne "ID") {
        $Section{$fixup}{$ID}{$attribute} = $$entry{$attribute};
        croak "Fixup: $fixup has 'number' attribute" if ($attribute eq "number");
      }
    }
    $Section{$fixup}{$ID}{number} = $fixup_number++;
  }
  foreach my $ID (sort keys %{$Section{$fixup}}) {
    #print STDERR "Entry: $ID\n";
    if (not defined $Section{$fixup}{$ID}{number}) {
      $Section{$fixup}{$ID}{number} = $fixup_number++;
    }
  }
}

my @Tables = qw(
BitField Bundling Convention Encoding Format Generic Immediate Instruction
Modifier NativeType Operand Pattern Platform Processor RegClass RegField
RegFile Register RegMask Relocation Reservation Resource Scheduling Simulated
Storage Dispersal Synthetic Template Builtin
);

foreach my $table (@Tables) {
  open(YAMLTABLE, ">", "$table.yml") or die $!;
  print YAMLTABLE <<EOT;
#
# $table.yml
# Automatically generated by Description2MDS.pl from the Description.yml and Bundle.yml files.
#
EOT
  if (defined $Section{$table}) {
    # Add the ID field to the table entries.
    while (my ($ID, $entry) = each %{$Section{$table}}) {
      $$entry{ID} = $ID;
    }
    print YAMLTABLE Dump({$table => ($Section{$table})});
  } else {
    print YAMLTABLE Dump({});
  }
  close(YAMLTABLE);
}

#die "STOP";

