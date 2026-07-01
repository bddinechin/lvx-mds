#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

my $debug = $ENV{DEBUG} || 0;
my $FAMILY = $ENV{FAMILY} || 0;

use Carp;
use MDS;
use BitString;
use Execution;
use Behavior;

#
# Build a table of forced operands for Synthetic Instructions.
#
sub forced {
  my %forced;
  my ($instruction) = @_;
  my ($synthetic) = $instruction->access("synthetic");
  if (defined $synthetic) {
    my $forced = $synthetic->attribute("forced");
    my $values = $synthetic->attribute("values");
    my @forced = split ' ', $forced if defined $forced;
    my @values = split ' ', $values if defined $values;
    while (@forced && @values) {
      my $force = shift @forced;
      my $value = shift @values;
      $forced{$force} = $value;
    }
    if (@forced || @values) {
      my $syntheticID = $synthetic->attribute("ID");
      die "mismatch in $syntheticID forced and values";
    }
  }
  return \%forced;
}

#
# Make the Execution of an Opcode by combining Format and Instruction Execution(s).
# TODO: deal with operand specialization like in sub behavior.
#
sub execution {
  my ($format, $instruction, $forced) = @_;
  my $instructionID = $instruction->attribute("ID");
  #print STDERR "\nExecution($instructionID)\n";
  my ($synthetic) = $instruction->access("synthetic");
  my ($instruction_execution) = $instruction->children('Execution');
  if ($synthetic && $synthetic->children('Execution')) {
    ($instruction_execution) = $synthetic->children('Execution');
  }
  return undef unless defined $instruction_execution;
  my ($format_execution) = $format->children('Execution');
  my $instruction_lines = join '', @{$instruction_execution->contents()};
  my $format_lines = defined $format_execution? (join '', @{$format_execution->contents()}): '';
  my @instruction_lines = grep {/\S/} split /\n/, $instruction_lines;
  my @format_lines = grep {/\S/} split /\n/, $format_lines;
  my @contents = defined $format_execution? @{$format_execution->contents()}: ();
  push @format_lines, "\@Instruction\n" unless grep {/\@Instruction\b/} @format_lines;
  my @lines; map {
    if (s/(\s*)\@Instruction\b(.*)\b//) {
      my ($prefix, $suffix) = ($1, $2);
      push @lines, map {"$prefix$_$suffix\n"} @instruction_lines;
    } else {
      push @lines, "$_\n";
    }
  } @format_lines;
  #print STDERR @lines;
  my ($stage, @stages) = (0); map {
    if (s/\bstage\s+(\d+):\s*//) { $stage = $1; }
    elsif (s/\bstage\s+(\w+):\s*//) {
      $stage = $Behavior::pipeline{$1};
      croak "unknown pipeline stage $1" unless defined $stage;
    }
    push @{$stages[$stage]}, "  $_" if $_ =~ /\S/;
  } @lines;
  my @execution = ("\n");
  for (my $stage = 0; $stage < @stages; $stage++) {
    next unless defined $stages[$stage];
    my $pipestage = $Behavior::pipeline[$stage] || $stage;
    push @execution, "stage $pipestage:\n";
    push @execution, @{$stages[$stage]};
  }
  # Substitute specialized proxies.
  map {
    my @proxies = /(?<!\%)(\%[1-9]\d*)/g;
    foreach my $proxy (@proxies) {
      s/(?<!\%)$proxy/$$forced{$proxy}/ if exists $$forced{$proxy};
    }
  } @execution;
  &Execution::yyin(@execution);
  if (&Execution::yyparse) {
    print STDERR "Execution($instructionID)\n", @execution, "\n";
    die "Execution syntax error:\t", &Execution::yylval, "\n";
  }
  &Execution::yyflush;
  return &MDS::make("Execution", { }, [ @execution ]);
}

#
# Make the Behavior of an Opcode by expanding ACCESS(es) and COMMIT(s) to the proxies.
#
sub behavior {
  my ($format, $instruction, $forced, $properties, $AccessTable, $CommitTable, @operandIDs) = @_;
  my $formatID = $format->attribute("ID");
  my $instructionID = $instruction->attribute("ID");
  #my $dump = $instructionID =~ /ADDIW/;
  #print STDERR "\nBehavior($instructionID, $formatID)\n" if $dump;
  my ($synthetic) = $instruction->access("synthetic");
  my ($instruction_behavior) = $instruction->children('Behavior');
  if ($synthetic && $synthetic->children('Behavior')) {
    ($instruction_behavior) = $synthetic->children('Behavior');
  }
  return undef unless defined $instruction_behavior;
  my ($format_behavior) = $format->children('Behavior');
  my $behavior = $instruction_behavior;
  if (defined $format_behavior) {
    # Combine format behavior contents and instruction behavior contents.
    my $instruction_contents = $instruction_behavior->contents();
    my $format_contents = $format_behavior->contents();
    my @contents = @{$format_contents};
    if (grep {/\(MACRO\.Instruction\)/} @contents) {
      #print STDERR "Found MACRO in $instructionID\n" if $dump;
      @contents = map {
        my ($head, $tail) = split /\(MACRO\.Instruction\)/;
        if (defined $head && defined $tail) {
          ($head, @{$instruction_contents}, $tail);
        } else {
          $_;
        }
      } @contents;
      #print STDERR @contents, "\n" if $dump;
    } else {
      unshift @contents, "(SEQ";
      push @contents, @{$instruction_contents}, ")";
    }
    my $new_instruction = $instruction->clone($instructionID);
    ($behavior) = $new_instruction->children('Behavior');
    $behavior->contents(\@contents);
    $instruction = $new_instruction;
  }
  my %methodID; my %replaceTable;
  for (my $rank = 1; $rank <= @operandIDs; $rank++) {
    my ($operandID, $proxy) = ($operandIDs[$rank - 1], "\%$rank");
    #print STDERR "\t($operandID, $proxy)\n" if $dump;
    unless (defined $$forced{$proxy}) {
      my $operand = &MDS::fetch($operandID);
      my $methodID = $operand->attribute("method");
      $methodID{$proxy} = $methodID;
      $replaceTable{$proxy} = &METHOD($proxy);
      if ($methodID =~ /^RegClass/) {
        my $regClass = &MDS::fetch($methodID);
        my $regClassID = $regClass->attribute("ID");
        my ($multi, $index) = ($regClass->attribute("multi"), 0);
        if ($multi) {
          my @multi = split ' ', ($multi || '');
          foreach my $multiID (@multi) {
            my $multiProxy = "$proxy:$index";
            $methodID{$multiProxy} = "${methodID}.$index";
            $replaceTable{$multiProxy} = &METHOD($multiProxy);
            $index++;
          }
        }
      }
    }
  }
  my $input = $behavior->contents();
  my @proxies = &MDS::proxies(@{$input});
  #print STDERR "\n\t$instructionID\t@proxies\n" if $dump;
  foreach my $proxy (@proxies) {
    my $methodID = $methodID{$proxy};
    #print STDERR "\t($proxy, ", $methodID||'undef', ")" if $dump;
    if (defined $methodID) {
      $AccessTable->{$proxy} = $AccessTable->{$methodID};
      $CommitTable->{$proxy} = $CommitTable->{$methodID};
    }
  }
  #print STDERR "\n" if $dump;
  while (my ($proxy, $value) = each %$forced) {
    $AccessTable->{$proxy} = &CONST($value);
    $CommitTable->{$proxy} = &SKIP();
  }
  map { &Behavior::Symbol($_, { }); } (@proxies, keys %$forced);
  map {
    #print STDERR "ATTRLIST(", @{$$properties{$_}}, ")\n";
    foreach my $attribute (@{$$properties{$_}}) {
      my $value = ($attribute =~ s/=?(\d+)$//)? $1: 1;
      #print STDERR "$attribute => $value\n";
      &Behavior::Symbol($_, { $attribute=>$value})
    }
  } keys %$properties;
  &Behavior::yyin(@{$input});
  #print STDERR "Parsing:\n", @{$input}, "\n" if $dump;
  if (&Behavior::yyparse) {
    print STDERR $instructionID, "\n", @{$input}, "\n";
    die "Behavior syntax error:\t", &Behavior::yylval, "\n";
  }
  &Behavior::yyflush;
  #print STDERR "Parsed $instructionID:", &Pretty(&Behavior::yytree, "  ") if $dump;
  ($tree) = &Reorder(&Behavior::yytree);
  #print STDERR "Reordered $instructionID:", &Pretty($tree, "  ") if $dump;
  ($tree) = &Simplify($tree);
  #print STDERR "Simplified $instructionID:", &Pretty($tree, "  ", 1) if $dump;
  ($tree) = &Normalize($tree);
  #print STDERR "Normalized $instructionID:", &Pretty($tree, "  ", 1) if $dump;
  ($tree, $actions) = &Expand($tree, $AccessTable, $CommitTable, 'METHOD', \%replaceTable, 0);
  #print STDERR "Expanded $instructionID:", &Pretty($tree, "  ") if $dump;
  &Behavior::Symbol();
  map { $AccessTable->{$_} = $CommitTable->{$_} = undef } (@proxies, keys %$forced);
  $behavior = &MDS::make("Behavior", {
  }, [ &Pretty($tree, "  ") ]);
  if (defined $actions) {
    my (@proxies, @methods);
    foreach my $proxy (sort keys %{$actions}) {
      my $methodID = $methodID{$proxy};
      if (defined $methodID) {
        push @proxies, $proxy;
        push @methods, $methodID;
      }
    }
    $behavior->attribute("proxies", (join ' ', @proxies)) if @proxies;
    $behavior->attribute("methods", (join ' ', @methods)) if @methods;
    #print STDERR "  proxies:\t", $behavior->attribute("proxies"), "\n";
    #print STDERR "  methods:\t", $behavior->attribute("methods"), "\n";
  }
  else {
    print STDERR "Not defined actions...\n";
  }
  return $behavior;
}

sub encoded {
  my ($patternIDs, $encoding, $error) = @_;
  my @matches;
  if (defined $patternIDs) {
    foreach my $patternID (@{$patternIDs}) {
      my $pattern = &MDS::fetch($patternID);
      push @matches, @{$$pattern{MATCHES}};
    }
  }
  my $wordWidth = $encoding->attribute("wordWidth");
  my $wordCount = $encoding->attribute("wordCount");
  my $bitString = BitString->new($wordCount*$wordWidth);
  foreach my $match (@matches) {
    my $field = $match->{FIELD};
    my $value = $match->{VALUE};
    my $bitField = &MDS::fetch($field);
    $bitString->insert($bitField, $value, $error);
  }
  return $bitString;
}

#
# Renumber the Opcode numbered proxies in syntax and operandIDs and behavior
#
sub renumber {
  my ($syntax, $operandIDs, $properties, $execution, $behavior, $instructionID, $formatID) = @_;
  my @operandIDs = split ' ', ($operandIDs || '');
  # Build structures to renumber the proxies.
  my @proxies;
  my %proxy_mapping;
  my %method_mapping;
  my %operand_mapping;
  my $newproxy_rank = 1;
  map {
    unless (defined $proxy_mapping{$_}) {
      push @proxies, $_;
      my $rank = substr $_, 1;
      my $newProxy = "\%". ($newproxy_rank++);
      $proxy_mapping{$_} = $newProxy;
      $operand_mapping{$_} = $operandIDs[$rank-1];
      (my $from = $_) =~ s/\%/\@/g;
      (my $to = $newProxy) =~ s/\%/\@/g;
      $method_mapping{$from} = $to;
    }
  } ($syntax =~ /(?<!\%)(\%[1-9]\d*)/g);
  #print STDERR "  mapping:\t", (join ' ', map {"[$_]"} @proxies), "\n";
  # Update the $execution contents by remapping the proxies.
  if (defined $execution) {
    my $contents = $execution->contents();
    #print STDERR "Renumbering:"; map { print STDERR " $_=>$proxy_mapping{$_}" } @proxies;
    #print STDERR "Execution:\t", @{$contents}, "\n";
    foreach my $input (@{$contents}) {
      map {
        defined $proxy_mapping{$_} or die "($instructionID, $formatID) has no mapping for proxy $_ (syntax: '$syntax', operands: '$operandIDs')";
      } ($input =~ /(?<!\%)(\%[1-9]\d*)/g);
      $input =~ s/(?<!\%)(\%[1-9]\d*)/$proxy_mapping{$1}/g;
      $input =~ s/(?<!\%)(\@[1-9]\d*)/$method_mapping{$1}/g;
      #print STDERR $input;
    }
  }
  # Update the $behavior contents by remapping the proxies.
  if (defined $behavior) {
    my $contents = $behavior->contents();
    #print STDERR "Rebumbering:"; map { print STDERR " $_=>$proxy_mapping{$_}" } @proxies;
    foreach my $input (@{$contents}) {
      map {
        defined $proxy_mapping{$_} or die "no mapping for proxy $_ (syntax: '$syntax', operands: '$operandIDs')";
      } ($input =~ /(?<!\%)(\%[1-9]\d*)/g);
      $input =~ s/(?<!\%)(\%[1-9]\d*)/$proxy_mapping{$1}/g;
      #print STDERR $input;
    }
    # Update the $behavior properties by remapping the proxies.
    my $proxies = $behavior->attribute("proxies");
    if (defined $proxies) {
      $proxies =~ s/(?<!\%)(\%[1-9]\d*)/$proxy_mapping{$1}/g;
      $behavior->attribute(proxies=> $proxies);
    }
  }
  # Update the $syntax, $operandIDs, $properties.
  $syntax =~ s/(?<!\%)(\%[1-9]\d*)/$proxy_mapping{$1}/g;
  $operandIDs = @proxies?  join ' ', map {$operand_mapping{$_}} @proxies: undef;
  if (defined $properties) {
    my @properties = grep {
      /(?<!\%)\%[0A-Z]/ || # Keep %0 and named properties.
      /(?<!\%)(\%[1-9]\d*)/ && defined $proxy_mapping{$1}
    } split /, /, $properties;
    $properties = join ', ', map {
      s/(?<!\%)(\%[1-9]\d*)/$proxy_mapping{$1}/; $_
    } @properties;
  }
  return ($syntax, $operandIDs, $properties, $execution, $behavior);
}
&MDS::parse(*ARGV);

&Behavior::yyinit();

#
# Prepare the read and write Behavior for methods and tabulate by methodID.
#
my %AccessTable;
my %CommitTable;
foreach my $access (@Access::table) {
  my $methodID = $access->attribute("method");
  my $read = $access->attribute("read");
  if (defined $read) {
    &Behavior::yyin('(SKIP', $read, ')');
    if (&Behavior::yyparse) {
      die "Behavior syntax error in ", $read;
    }
    my $accessTable = &Behavior::yytree->[1];
    $AccessTable{$methodID} = $accessTable if defined $methodID;
    &Behavior::yyflush;
  }
  my $write = $access->attribute("write");
  if (defined $write) {
    &Behavior::yyin($write);
    if (&Behavior::yyparse) {
      die "Behavior syntax error in ", $write;
    }
    my $commitTable = &Behavior::yytree;
    $CommitTable{$methodID} = $commitTable if defined $methodID;
    &Behavior::yyflush;
  }
}

#
# Prepare the access and commit Behavior(s) for Register(s) and tabulate by Register name.
#
foreach my $register (@Register::table) {
  my $name = $register->name();
  my ($storage) = $register->access("storage");
  next if $storage->attribute("kind") eq 'Constant';
  my $storageName = $storage->name();
  my $storageWidth = $storage->attribute("width");
  my @addresses = split ' ', $register->attribute("addresses");
  my ($address) = sort { $a <=> $b } @addresses; my $extent = 0;
  my $aggregate = "ERROR";
  if ($address == $addresses[0]) {
    $aggregate = "AGGL";
    while (@addresses) {
      if ($addresses[0] == $address + $extent) {
        shift @addresses;
        ++$extent;
      } else {
        die "garbage in Register $name addresses:", (join ' ', @addresses);
      }
    }
  } elsif ($address == $addresses[-1]) {
    $aggregate = "AGGB";
    while (@addresses) {
      if ($addresses[-1] == $address + $extent) {
        pop @addresses;
        ++$extent;
      } else {
        die "garbage in Register $name addresses:", (join ' ', @addresses);
      }
    }
  }
  my $locations = "(CONST.$address)(CONST.$extent)";
  my $width = $storageWidth*$extent;
  my $read = "(F2I.$width(LOAD._($aggregate.$storageName $locations)))";
  &Behavior::yyin('(SKIP', $read, ')');
  if (&Behavior::yyparse) {
    die "Behavior syntax error in ", $read;
  }
  my $accessTable = &Behavior::yytree->[1];
  $AccessTable{$name} = $accessTable;
  &Behavior::yyflush;
  my $write = "(STORE._($aggregate.$storageName $locations)(I2F.$width(UNDEF)))";
  &Behavior::yyin($write);
  if (&Behavior::yyparse) {
    die "Behavior syntax error in ", $write;
  }
  my $commitTable = &Behavior::yytree;
  $CommitTable{$name} = $commitTable;
  &Behavior::yyflush;
}


#
# Compute the CHILDREN for all the Pattern(s).
#
my @Pattern_roots;
foreach my $pattern (@Pattern::table) {
  my $parent = $$pattern{PARENT};
  push @Pattern_roots, $pattern if ref($parent) ne 'Pattern';
  my @contents = @{$$pattern{CONTENTS}};
  @{$$pattern{CHILDREN}} = grep { ref($_) eq 'Pattern' } @contents;
  #print $pattern, "\tCHILDREN\t", @{$$pattern{CHILDREN}}, "\n";
}

#
# Compute the MATCHES for all the Pattern(s).
#
foreach my $pattern (@Pattern_roots) {
  my (@matches);
  my $fields = $pattern->attribute("fields");
  my $values = $pattern->attribute("values");
  my @fields = (split ' ', $fields) if defined $fields;
  my @values = (map {/^0/? oct($_): $_} split ' ', $values) if defined $values;
  while (@fields && @values) {
    push @matches, {
      FIELD=>(shift @fields),
      VALUE=>(shift @values),
    };
  }
  die $pattern->name(),": Pattern\@fields mismatch" if @fields;
  die $pattern->name(),": Pattern\@values mismatch" if @values;
  $$pattern{MATCHES} = \@matches;
}

if ($debug >= 2) {
  foreach my $pattern (@Pattern::table) {
    my @matches = @{$$pattern{MATCHES}};
    my @fields = map {$_->{FIELD}} @matches;
    my @values = map {$_->{VALUE}} @matches;
    my $ID = $pattern->attribute("ID");
    if (defined $ID) {
      print STDERR "$ID:";
      print STDERR "\tFIELDS: ", (join ' ', @fields);
      print STDERR "\tVALUES: ", (join ' ', @values);
      print STDERR "\n";
    }
  }
}


#
# Generate the Opcode(s) by enumerating the Format(s) of each Instruction.
#
foreach my $instruction (@Instruction::table) {
  my $instructionID = $instruction->attribute("ID");
  #print STDERR $instructionID, "\n";
  my $formatsI = $instruction->attribute("formats");
  my $mnemonic = $instruction->attribute("mnemonic");
  my ($synthetic) = $instruction->access("synthetic");
  my @specializeI = split ' ', ($instruction->attribute("specialize") || "");
  my @replacementI = split ' ', ($instruction->attribute("replacement") || "");
  my %overrideI;
  while (@specializeI && @replacementI) {
    my $specialize = shift @specializeI;
    my $replacement = shift @replacementI;
    $overrideI{$specialize} = $replacement;
  }
  die "mismatch in $instructionID specialize and replacement" if @specializeI || @replacementI;
  my @schedulings = split ' ', $instruction->attribute("schedulings");
  foreach my $formatID (split ' ', $formatsI) {
    my $format = &MDS::fetch($formatID);
    my ($encoding) = $format->access("encoding");
    my $encodingID = $encoding->attribute("ID");
    my $decodingID = &Decoding::ID($encoding->name());
    my $operandIDs = $format->attribute("operands") || "";
    my @operandIDs = map { $overrideI{$_} || $_ } (split ' ', $operandIDs);
    $operandIDs = @operandIDs? (join ' ', @operandIDs): undef;
    my $syntax = $mnemonic || "";
    if ($synthetic && not defined $synthetic->attribute("forced")) {
      $syntax = $format->attribute("syntax") || $instruction->attribute("syntax") || $mnemonic;
    } else {
      $syntax = $instruction->attribute("syntax") || $format->attribute("syntax") || $mnemonic;
    }
    $syntax =~ s/\b$mnemonic\b/%0/;
    my $shortformatID = $formatID;
    $shortformatID =~ s/.*-//;
    my $shortinsnID = $instructionID;
    my $shortsyntID = $instructionID;
    if ($synthetic) {
      $shortinsnID = $synthetic->attribute("instruction");
    }
    $shortinsnID =~ s/.*-//;
    $shortsyntID =~ s/.*-//;
    # Each instructions has patterns of the form FORMAT, FORMAT:INSN,
    # FORMAT:SYNTHETIC.  FORMAT:SYNTHETIC being the most specialized, and FORMAT
    # begin the less specialized.  When constructing an Opcode we want to take
    # only the relevant Patterns, hence we filter out those which are not
    # relevant (since an Instruction has them all).
    my %patternIDs = ();
    my @patternIDs = grep {!$patternIDs{$_}++}
        (split ' ', ($format->attribute("patterns") || '')),
        (grep {/${shortformatID}:${shortinsnID}/} (split ' ', ($instruction->attribute("patterns") || ''))),
        (grep {/${shortformatID}:${shortsyntID}/} (split ' ', ($instruction->attribute("patterns") || '')));
    my $patternIDs = join ' ', @patternIDs;
    my $encoded = &encoded(\@patternIDs, $encoding, "bits of $formatID by $instructionID");
    # Combine $format traps with $instruction traps.
    my @format_traps = split ' ', ($format->attribute("traps") || '');
    my @instruction_traps = split ' ', ($instruction->attribute("traps") || '');
    my %traps; map {++$traps{$_}} @format_traps, @instruction_traps;
    my @traps =  sort { $a cmp $b } keys %traps;
    my $traps =  (join ' ', @traps) if @traps;
    # Combine $format properties with $instruction properties.
    #print STDERR "Attributes($instructionID, $formatID)\n";
    my $format_properties = $format->attribute("properties");
    my $instruction_properties = $instruction->attribute("properties");
    #print STDERR "\tformat_properties='$format_properties'\n" if $format_properties;
    #print STDERR "\tinstruction_properties='$instruction_properties'\n" if $instruction_properties;
    my %format_properties; my %instruction_properties; my %properties;
    %format_properties = map {s/\W$//;$_} split ' ', $format_properties if $format_properties;
    %instruction_properties = map {s/\W$//;$_} split ' ', $instruction_properties if $instruction_properties;
    #print STDERR "\tformat_properties=", %format_properties, "\n";
    #print STDERR "\tinstruction_properties=", %instruction_properties, "\n";
    while (my ($key, $value) = each %instruction_properties) {
      delete $format_properties{$key} if $value =~ s/\b_\b//;
      push @{$properties{$key}}, (split /[-;]/, $value);
      #print STDERR "\tPUSHI($key,$value)\n";
    }
    while (my ($key, $value) = each %format_properties) {
      push @{$properties{$key}}, (split /[-;]/, $value);
      #print STDERR "\tPUSHF($key,$value)\n";
    }
    my @properties; map {
      my $value = join ';', grep {$_} @{$properties{$_}};
      push @properties, "$_: $value" if $value;
    } sort { substr($a,1) cmp substr($b,1) } keys %properties;
    my $properties = join ', ', @properties if @properties;
    #print STDERR "\tproperties=", $properties, "\n" if $properties;
    my $forced = &forced($instruction);
    my $execution = &execution($format, $instruction, $forced);
    # TODO: Compile $execution to $behavior if no $behavior.
    my $behavior = &behavior($format, $instruction, $forced, \%properties, \%AccessTable, \%CommitTable, @operandIDs);
    ($syntax, $operandIDs, $properties, $execution, $behavior) =
        &renumber($syntax, $operandIDs, $properties, $execution, $behavior, $instructionID, $formatID);
    @operandIDs = split ' ', $operandIDs || '';
    my %operandIDs = (); map { $operandIDs{$_}++ } @operandIDs;
    my $increment = $format->attribute("increment");
    # Use the Synthetic name if any.
    my ($class, $name) = split ':', ($synthetic || $instruction)->name();
    my @signature = map {&MDS::fetch($_)->name()} @operandIDs;
    $name = join '_', $name, @signature;
    $name .= '_'. $encoding->name() unless $FAMILY eq "st200";
    my $ID = &Opcode::ID($name);
    #print STDERR "Opcode($ID)\n";
    # Emit Opcode element.
    my $schedulingID = shift @schedulings;
    my $scheduling = &MDS::fetch($schedulingID);
    my $opcode = MDS::make("Opcode",
      {
        ID=>		$ID,
        class=>		$class,
        mnemonic=>	$mnemonic,
        instruction=>	$instructionID,
        patterns=>	$patternIDs,
        format=>	$formatID,
        syntax=>	$syntax,
        traps=>		$traps,
        operands=>	$operandIDs,
        increment=>	$increment,
        scheduling=>	$schedulingID,
        encoding=>	$encodingID,
        decoding=>	$decodingID,
        encoded=>	$encoded->pretty(),
        properties=>	$properties,
      }, 
      [ $execution, $behavior ],
    );
    print $opcode->emit();
  }
}


