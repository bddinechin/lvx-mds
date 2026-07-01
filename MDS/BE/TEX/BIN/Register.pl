#
# Build the Register.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;
use File::Basename;
use Data::Dumper;
use TEXTarget;

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";
my ($name,$path,$suffix) = fileparse($ARGV[0]);

local $/;
my $Load = Load(<INPUT>);
my $RegField = $$Load{RegField};

my @RegField = sort { ($$a{register} cmp $$b{register})
                   || ($$a{offset} <=> $$b{offset}) } values %{$RegField};

my %BitFields;
foreach my $regField (@RegField) {
  my $ID = $$regField{ID};
  my $registerID = $$regField{register};
  my $offset = $$regField{offset};
  my $width = $$regField{width};
  my ($start, $stop) = ($offset, $offset + $width - 1);
  $BitFields{$registerID}{$ID}{REGFIELD} = $ID;
  $BitFields{$registerID}{$ID}{START} = $start;
  $BitFields{$registerID}{$ID}{STOP} = $stop;
}

my $ExtraBitFields = Target::extra_register_bitfields();
foreach my $registerID (keys %$ExtraBitFields) {
  my $regFields = $$ExtraBitFields{$registerID};
  foreach my $regFieldID (@$regFields) {
    if(not defined $$RegField{$regFieldID}) {
	die "RegField $regFieldID not defined";
    }
    my $regField = $$RegField{$regFieldID};
    my $offset = $$regField{offset};
    my $width = $$regField{width};
    my ($start, $stop) = ($offset, $offset + $width - 1);
    $BitFields{$registerID}{$regFieldID}{REGFIELD} = $regFieldID;
    $BitFields{$registerID}{$regFieldID}{START} = $start;
    $BitFields{$registerID}{$regFieldID}{STOP} = $stop;
  }
}

foreach $registerID (sort keys %BitFields) {
  my @BitFields;
  my @TmpBitFields;
  my @fields = sort {
    $$b{STOP} <=> $$a{STOP}
  } values %{$BitFields{$registerID}};
  my $prev_start = 64;
  my $prev_stop = 64;
  foreach my $field (@fields) {
    my $start = $$field{START};
    my $stop = $$field{STOP};
    if ($prev_start - 1 > $stop) {
      push @TmpBitFields, { STOP=>$prev_start-1, START=>$stop+1, REGFIELD=>'-' };
    }
    push @TmpBitFields, $field;
    $prev_start = $start;
    $prev_stop = $stop;
  }
  if ($prev_start > 0) {
     push @TmpBitFields, { STOP=>$prev_start-1, START=>0, REGFIELD=>'-' };
  }

  foreach my $field (@TmpBitFields) {
    my $fstart = $$field{START};
    my $fstop = $$field{STOP};
    my $foundBiggerField = 0;
    SUBFIELD_LOOP: {
      foreach my $subfield (@TmpBitFields) {
        my $substart = $$subfield{START};
        my $substop = $$subfield{STOP};
        if( ( (($substart <= $fstart) and ($substart < $fstop)) and
              (($fstart < $substop) and ($fstop <= $substop)) )
            and (($substop - $substart) > ($fstop - $fstart))) {
          $foundBiggerField = 1;
          print STDERR "WARNING: $registerID $$subfield{REGFIELD} $substart-$substop contains $$field{REGFIELD} $fstart-$fstop -> skip\n";
          last SUBFIELD_LOOP;
        }
      }
    }
    if($foundBiggerField == 0) {
      push @BitFields, $field;
    }
  }

  foreach my $i (0 .. $#BitFields) { #Foreach bitfields
      if (($BitFields[$i]{'START'} < 32) and ($BitFields[$i]{'STOP'} >= 32)) {
          #If a bitfield cut a border of 32b : cut the bitfield in 2 to display the register on 2 lines
          my %tmp = %{$BitFields[$i]};
          splice(@BitFields, $i, 0, \%tmp); #Duplicate the bitfield
          $BitFields[$i]{'START'} = 32; #Start of the bitfield on 32 msb
          $BitFields[$i+1]{'STOP'} = 31; #Stop of the bitfield on 32 lsb
      }
  }
  if (($BitFields[0]{'REGFIELD'} eq '-') and ($BitFields[$i]{'START'} == 32) and ($BitFields[$i]{'STOP'} == 63)) {
      #If a register is only 32b (so the 32b msb are '-'), remove the 32b msbs to not display them
      shift(@BitFields);
  }

  open(FILE, '>', "${path}Register-$registerID.tex") || die $!;
  print FILE "\\bitfields\{ ";
  my $separator = '';
  foreach my $field (@BitFields) {
    my $regFieldID = $$field{REGFIELD};
    my $start = $$field{START};
    my $stop = $$field{STOP};
    if($registerID =~ /^([^-]+)-([^-]+)$/) {
	$registerID = $1;
    }
    $regFieldID =~ s/${registerID}_//;
    print FILE $separator, $stop-$start+1, "/$regFieldID";
    $separator = ', ';
  }
  print FILE " \}\n";
  close(FILE) || die $!;
}

