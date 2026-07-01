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

use Carp;
use MDS;
use Behavior;

&MDS::parse(*ARGV);

# Generated operators.
my %Operator = ();
my @Operators = ();

my $FAMILY = $ENV{FAMILY};

my $dump = 0;

# If true, the Operator(s) are expanded for all the Modifier values.
my $ExpandModifiers = 1;
$ExpandModifiers = 0 if($FAMILY eq "arm");

&Behavior::yyinit();

my %Storage2Method;

#
# Build a map from (storageName, addresses) to RegisterID.
#
#print STDERR "Register\n";
my %RegisterID;
foreach my $register (@Register::table) {
  my $registerID = $register->attribute("ID");
  my ($storage) = $register->access("storage");
  my $kind = $storage->attribute("kind");
  if ($kind ne 'Control') {
    my $storageName = $storage->name();
    my $storageCells = $storage->attribute("count");
    my @addresses = split ' ', $register->attribute("addresses");
    my $address_key = join '_', @addresses;
    #print STDERR "Register $registerID mapped on {$storageName}{$address_key}\n";
    $RegisterID{$storageName}{$address_key} = $registerID;
    if ($storageCells == scalar(@addresses)) {
      $Storage2Method{$storageName} = $registerID;
    }
  }
}

#
# Build a map from (storageName, address, extent) to RegClassID of one Register.
#
#print STDERR "RegClass\n";
my %RegClassID;
foreach my $regClass (@RegClass::table) {
  next unless defined $regClass->name();
  my $regClassID = $regClass->attribute("ID");
  my @registers = $regClass->access("registers");
  if (@registers == 1) {

    my $register = $registers[0];
    my ($storage) = $register->access("storage");
    my $storageName = $storage->name();
    my $storageCells = $storage->attribute("count");
    my @addresses = split ' ', $register->attribute("addresses");
    my $address_key = join '_', @addresses;
    #print STDERR "RegClass $regClassID mapped on {$storageName}{$address_key}\n";
    $RegClassID{$storageName}{$address_key} = $regClassID;
    if ($storageCells == scalar(@addresses)) {
      $Storage2Method{$storageName} = $regClassID;
    }
  }
}

#
# Process each Generic and Simulated to generate the corresponding Operator.
#
sub makeGenOperator {
    my (@ops) = @_;
#    foreach my $origin (sort { $a->attribute("ID") cmp $b->attribute("ID") } @ops) {
    foreach my $origin (@ops) {
        my $originID = $origin->attribute("ID");
        my $mnemonic = $origin->attribute("mnemonic");
        my $contents = $origin->contents();
        my @contents = grep {/\S/} @{$contents};
        my @parameters = $origin->children('Parameter');
        # Compute syntax.
        my $syntax = "%0";
        my @write_proxies; my @read_proxies; map {
            my $proxy = $_->attribute("proxy");
            my $action = $_->attribute("action");
            if ($proxy) {
                push @write_proxies, $proxy if $action=~ /^Write/;
                push @read_proxies, $proxy if $action=~ /^Read/;
            }
        } @parameters;
        $syntax .= " ". (join ", ", @write_proxies) if @write_proxies;
        $syntax .= " = ". (join ", ", @read_proxies) if @read_proxies;
        # Compute attributes.
        my @actions = map { $_->attribute("action") } @parameters;
        my @attributes =  split ' ', ($origin->attribute("attributes") || '');
        push @attributes, grep {/^(Read|Write)List/} @actions;
        my $attributes = join ' ', @attributes if @attributes;
        my $ID = &Operator::ID($origin->name());
        my $operator = &MDS::make("Operator", {
            ID=>		$ID,
            processors=>	&Processor::ID("cpu"),
            origins=>		$originID,
            attributes=>	$attributes,
            mnemonic=>	$mnemonic,
            syntax=>		$syntax,
        }, [ @contents ]);
        print $operator->emit();
        #print STDERR "Emitted generic $ID\n";
    }
}

my @lao_generic_operators_order = ("ENTRY", "LABEL", "FALLTO", "LOOPTO", "GOTO", "GOTRUE", "GOFALSE", "JUMP", "CALL", "LINK",
                                   "RETURN", "PHI", "PSI", "SIGMA", "KILL", "PCOPY", "ECOPY", "LCOPY", "COPY", "SKIP", "LNOT",
                                   "BNOT", "NEG", "ADD", "SUB", "MUL", "DIV", "REM", "SHL", "ASHR", "LSHR", "LAND", "LIOR",
                                   "LXOR", "BAND", "BIOR", "BXOR", "MIN", "MAX", "SELECT", "APPLY");


#print STDERR "Generic\n";
&makeGenOperator(@Generic::table, @Simulated::table);

#
# Process each Opcode to generate the corresponding Operator.
#
#print STDERR "Opcode\n";
foreach my $opcode (@Opcode::table) {
  my $opcodeID = $opcode->attribute("ID");
  #$dump = $opcodeID =~ /CMOVEBX/;
  $dump = 1;
  #print STDERR "$opcodeID\n" if $dump;
  my ($behavior) = $opcode->children('Behavior');
  unless (defined $behavior) {
    print STDERR "Undefined Opcode behavior for $opcodeID\n";
    next;
  }
  my @operands = $opcode->access("operands");
  my $opcode_properties = $opcode->attribute("properties");
  #print STDERR "properties($opcodeID)\t$opcode_properties\n" if $opcode_properties && $dump;
  my %opcode_properties = map {s/\W$//;$_} split ' ', $opcode_properties if $opcode_properties;
  #if ($opcode_properties && $dump) { while (my ($proxy, $value) = each %opcode_properties) { print STDERR "KEY($proxy)VAL($value)\n" } }
  # Process the Behavior.
  my $input = $behavior->contents();
  my @proxies = split ' ', ($behavior->attribute("proxies") || '');
  my @methodIDs = split ' ', ($behavior->attribute("methods") || '');
  map { &Behavior::Symbol($_, { }); } @proxies;
  #print STDERR "\n$opcodeID proxies\t", @proxies, "\n" if $dump;
  &Behavior::yyin(@{$input});
  if (&Behavior::yyparse) {
    print STDERR $opcode->name(), @{$input}, "\n";
    die "syntax error:\t", &Behavior::yylval, "\n";
  }
  &Behavior::yyflush;
  #print STDERR "Before Parallel\n" if $dump;
  #print STDERR &Pretty(&Behavior::yytree, "  ") if $dump;
  my $tree = &Parallel(&Behavior::yytree, $opcodeID);
  #print STDERR "After Parallel\n" if $dump;
  #print STDERR &Pretty($tree, "  ") if $dump;
  &Behavior::Symbol();
  my $parameters = { Write=>[], Read=>[] };
  &implicitParameters($tree, $parameters, \%opcode_properties);
  my %proxyMethodID; my @modifierMethods; my @modifierProxies;
  #if ($dump) { local $, = ' '; print STDERR "PROXIES(", @proxies, ")\n"; }
  #if ($dump) { local $, = ' '; print STDERR "METHODS(", @methodIDs, ")\n"; }
  while (@proxies && @methodIDs) {
    my $proxy = shift @proxies;
    my $methodID = shift @methodIDs;
    if ($ExpandModifiers && $methodID =~ /^Modifier/) {
      push @modifierMethods, &MDS::fetch($methodID);
      push @modifierProxies, $proxy;
    } else {
      $proxyMethodID{$proxy} = $methodID;
    }
  }
  &explicitParameters($tree, \%proxyMethodID, \%opcode_properties, $parameters, $opcodeID);
  my @parameters = (@{$$parameters{Write}}, @{$$parameters{Read}});
  my @attributes = map {split /[-;]/} grep{defined} $opcode_properties{'%0'};
  if (grep {/\bPredicated\b/} @attributes) {
    # If Predicated, add 'Partial' Read Parameter for each Write Parameter.
    foreach my $parameter (@{$$parameters{Write}}) {
      my $methodID = $parameter->attribute("method");
      die "Expecting RegClass or Register Method, got $methodID" unless $methodID =~ /^(RegClass|Register)/;
      my $proxy = $parameter->attribute("proxy");
      my $stages = $parameter->attribute("stages");
      # Assume read date is write date minus 1.
      $stages =~ s/(\d+)/$1 - 1/eg;
      push @parameters, &MDS::make("Parameter", {
          action=>	'Read',
          usage=>	'Partial',
          proxy=>	$proxy,
          method=>	$methodID,
          stages=>	$stages,
      });
    }
  }
  my %attributes; map {$attributes{$_}=1} @attributes;
  my $attributes = [ sort keys %attributes ];
  if (@modifierMethods) {
    my %proxy2modifier;
    croak "Not same number of proxies and modifiers" if(scalar(@modifierMethods) != scalar(@modifierProxies));
    for(my $i=0; $i < @modifierMethods; $i++) {
      my $proxy = $modifierProxies[$i];
      my $method = $modifierMethods[$i];
      my $methodID = $method->attribute("ID");
      my $method_properties = $method->attribute("properties");
#print STDERR "\t$method_properties\n" if $dump && $method_properties;
      $proxy2modifier{$proxy}{methodID} = $methodID;
      $proxy2modifier{$proxy}{properties} = $method_properties;
      $proxy2modifier{$proxy}{names} = [ split ' ', $method->attribute("members") ];
      $proxy2modifier{$proxy}{values} = $method->attribute("values");
    }
    my %modifiers_table;
    my @proxies = keys %proxy2modifier;
    my @name_ids = map {0} keys %proxy2modifier;
    &modifiersTable(\%modifiers_table, \@proxies, \%proxy2modifier, [], [], 0, @name_ids);
    foreach my $modifiers_key (sort keys %modifiers_table) {
      my @modifier_proxies = @{$modifiers_table{$modifiers_key}{proxies}};
      my @modifier_names = @{$modifiers_table{$modifiers_key}{names}};
      croak "Not same number of proxies/names (@modifier_proxies/@modifier_names)"
        if(scalar(@modifier_proxies) != scalar(@modifier_names));
      my %inlinedModifiers;
      for(my $i=0; $i < @modifier_proxies; $i++) {
        my $proxy = $modifier_proxies[$i];
        my $name = $modifier_names[$i];
        $inlinedModifiers{$proxy} =
            [ uc($name), $proxy2modifier{$proxy}{methodID}, $proxy2modifier{$proxy}{properties} ];
      }
      my $operatorID = &makeOperator($opcode, \@parameters, $attributes, \%inlinedModifiers);
#print STDERR "\tOperator $operatorID\n" if $dump;
    }
  } else {
    my $operatorID = &makeOperator($opcode, \@parameters, $attributes, { });
#print STDERR "\tOperator $operatorID\n" if $dump;
  }
}

sub modifiersTable {
  my ($modifiers_table, $proxies, $proxy2modifier,
      $modifiers_key, $modifiers_names, $index, @name_ids) = @_;
  my @proxies = @$proxies;
  if ($index == scalar(@$proxies)) {
    $$modifiers_table{$modifiers_key}{proxies} = [ @$proxies ];
    $$modifiers_table{$modifiers_key}{names} = $modifiers_names;
    return;
  }
  my $proxy = $proxies[$index];
  my @names = @{$$proxy2modifier{$proxy}{names}};
  my $properties = $$proxy2modifier{$proxy}{properties};
  &modifiersTable($modifiers_table, $proxies, $proxy2modifier,
                  $modifiers_key."_$names[$name_ids[$index]]",
                  [ @$modifiers_names, $names[$name_ids[$index]] ],
                  $index+1, @name_ids);
  return if $name_ids[$index] + 1 == scalar(@names);
  $name_ids[$index]++;
  &modifiersTable($modifiers_table, $proxies, $proxy2modifier,
                  $modifiers_key, $modifiers_names,
                  $index, @name_ids);
}

# Create and emit the Operator.
sub makeOperator {
  my ($opcode, $parameters, $attribute_list, $modified) = @_;
  my $opcodeID = $opcode->attribute("ID");
  my $mnemonic = $opcode->attribute("mnemonic");
  my ($encoding) = $opcode->access("encoding");
  my ($instruction) = $opcode->access("instruction");
  my ($synthetic) = $instruction->access("synthetic");
  my @expanded = sort {substr($a, 1)<=>substr($b, 1)} keys %$modified;
  my @members = map {$$modified{$_}[0]} @expanded;
  my @modifiers = map {$$modified{$_}[1]} @expanded;
  my @properties = map {$$modified{$_}[2]} @expanded;
#print STDERR "\tmembers\t", @members, "\n" if $dump && @members;
#print STDERR "\tproperties\t", @properties, "\n" if $dump && @properties;
  # Select the modifier attributes.
  my @modifier_attributes;
  for (my $i = 0; $i < @properties; $i++) {
    my $properties = $properties[$i];
    if (defined $properties) {
      my $key = "%0".$members[$i];
      my %properties = map {s/\W$//;$_} split ' ', $properties;
      my $attributes = $properties{$key};
#print STDERR "\t\tkey=$key\tproperties=$properties\tattributes=$attributes\n" if $dump;
      push @modifier_attributes, (split /;/, $attributes) if $attributes;
    }
  }
  # Compute expanded, modifiers and members.
  my $expanded = join ' ', @expanded if @expanded;
  my $modifiers = join ' ', @modifiers if @modifiers;
  my $members = join ' ', @members if @members;
  # Compute ID. We use the Synthetic name if any,
  my %signature;
  my @signature = map {
    $_->attribute("proxy").($_->access("method"))[0]->name()
  } grep {
    my $proxy = $_->attribute("proxy");
    $proxy && !$signature{$proxy}++;
  } @$parameters;
  my ($class, $name) = split /:/, ($synthetic || $instruction)->name();
  $name = join '', ($name, @members) if @members;
  $name = join '', ($name, @signature) if @signature;
  $name .= '_'. $encoding->name() unless $FAMILY eq "st200";
  $name =~ s/\W/_/g;
  my $ID = &Operator::ID($name);
#print STDERR "Operator $ID\n";
  die "Operator $ID already defined" if defined $Operator{$ID};
  $Operator{$ID} = 1;
  # Compute syntax.
  my $syntax = $opcode->attribute("syntax");
  foreach my $proxy (keys %$modified) {
    my $replace = lc($$modified{$proxy}[0]);
    $replace =~ s/\.(\W)/$1/;
    $syntax =~ s/$proxy/$replace/;
  }
  # Assume empty modifiers are '.', and remove them from $syntax
  undef while $syntax =~ s/\.\./\./g;
  $syntax =~ s/\.(\s)/$1/;
  # Complement the attribute list with the modifier attributes.
  my %attributes;
  map {++$attributes{$_}} @$attribute_list if @$attribute_list;
  map {++$attributes{$_}} @modifier_attributes if @modifier_attributes;
  my @attributes = sort { $a cmp $b } keys %attributes;
  my $attributes = join ' ', @attributes if @attributes;
#print STDERR "Attributes($ID)\t$attributes\n" if $attributes && $dump;
  # Make Operator.
  my $operator = &MDS::make("Operator", {
      ID=>	$ID,
      processors=>	&Processor::ID("cpu"),
      origins=>		$opcodeID,
      attributes=>	$attributes,
      mnemonic=>	$mnemonic,
      syntax=>		$syntax,
      modifiers=>	$modifiers,
      expanded=>	$expanded,
      members=>		$members,
    }, [ @$parameters ],
  );
  push @Operators, $operator;
  return $ID;
}

sub address_key {
  my ($location) = shift;
  die "Expecting AGGL or AGGB" unless $$location[0] =~ /^(AGGL|AGGB)$/;
  my $storage = $$location[1];
  my $address = $$location[2];
  my $extent = $$location[3];
  if ($$address[0] eq 'CONST' && $$extent[0] eq 'CONST') {
    my $address = $$address[1];
    my $cells = $$extent[1];
    my @addresses = ($address);
    while (--$cells) {
      push @addresses, ++$address;
    }
    return join '_', @addresses;
  }
  return undef;
}

sub implicitParametersRecurse {
  my ($tree, $result, $properties) = @_;
  return if ref $tree ne 'ARRAY';
  my $operator = $tree->[0];
  my %action = ( LOAD=>'Read', STORE=>'Write' );
  # Map the LOAD or STORE of Storage to RegClass methodID.
  if ($operator =~ /^(LOAD|STORE)$/) {
    my $action = $action{$1};
    my $stage = $tree->[1];
    my $location = $tree->[2];
    my $name = $location->[1];
    my $address_key = &address_key($location);
    # Returns register or regclass if addresses are constant (CONST).
#print STDERR "Search Register or RegClass mapped on {$name}{$address_key}\n" if defined $address_key;
    my $attribute = $$properties{"\%$name"};
#print STDERR "Implicit attribute $attribute for $name\n" if defined $attribute;
    if (defined $attribute && ($attribute eq "No$action" || $attribute eq "NoEffects")) {
      # BD3: NoRead or NoWrite of NoEffects forced for proxy "\%$name".
    } elsif (defined $address_key) {
      # [JV]: If no RegClass correspond to the accessed storage cells, use biggest register
      # in term of cells to catch all possible dependencies on dedicated registers.
      my $methodID = $RegClassID{$name}{$address_key} || $Storage2Method{$name} ||
                     $RegisterID{$name}{$address_key};
      if (defined $methodID) {
#print STDERR "Found $methodID\n";
        my $method = &MDS::fetch($methodID);
        my $lcname = lc($method->name($method));
        push @$result, {
          ACTION=>	$action,
          METHOD=>	$methodID,
          STAGE=>	$stage,
          LCNAME=>	$lcname,
        }
      }
    }
  }
  map { &implicitParametersRecurse($_, $result, $properties) } @{$tree};
}

sub implicitParameters {
  my @implicitParameters;
  my ($tree, $parameters, $properties) = @_;
  &implicitParametersRecurse($tree, \@implicitParameters, $properties);
  my ($prevAction, $prevMethodID, $prevStage) = ('', '', -1);
  map {
    my ($action, $methodID, $stage) = ($_->{ACTION}, $_->{METHOD}, $_->{STAGE});
    if (   $action ne $prevAction
        || $methodID ne $prevMethodID
        # HACK! Eliminate implicit (Register) Parameter(s) that only differ on $stage.
        || $stage != $prevStage && $methodID !~ /^Register/
       ) {
      my $parameter = &MDS::make("Parameter", {
        action=>      $action,
        method=>      $methodID,
        stages=>      $stage,
      });
      $$parameter{TYPE} = &MDS::fetch($methodID)->type();
      push @{$$parameters{$action}}, $parameter;
      ($prevAction, $prevMethodID, $prevStage) = ($action, $methodID, $stage);
    }
  } sort {
    # Sort implicit Parameter(s) by action, method name, stage.
    $a->{ACTION} cmp $b->{ACTION} ||
    $a->{LCNAME} cmp $b->{LCNAME} ||
    $a->{STAGE} <=> $b->{STAGE}
  } @implicitParameters;
}

# Map the METHOD references to Parameter(s).
sub explicitParameters {
  my ($tree, $proxyMethodID, $properties, $parameters, $opcodeID) = @_;
  # Use the collated tree to infer proxy action(s).
  my %action;
  my $collate = &Collate($tree);
  if (defined $collate) {
    foreach my $path (@{$collate}) {
#{ local $, = ' '; print STDERR "Collate:", @{$path}, "\n"; }
      my $leaf = $path->[-1];
      if ($leaf =~ /^METHOD\.(\%\d+(:\d+)?)$/) {
        my $proxy = $1;
        my $methodID = $$proxyMethodID{$proxy};
        my @loadstore = grep {/^(LOAD|STORE)\.(\d*)\[0\]$/} reverse @{$path};
        if (@loadstore) {
          if ($loadstore[0] =~ /^LOAD\.(\d*)\[0\]$/) {
            my $stage = $1 || 0;
            $action{$proxy}{Read}->{STAGE} = $stage;
          } elsif ($loadstore[0] =~ /^STORE\.(\d*)\[0\]$/) {
            my $stage = $1 || 0;
            $action{$proxy}{Write}->{STAGE} = $stage;
          }
        } elsif (@{$path} > 2 && $path->[-2] =~ /^[SZ]X\b/) {
            $action{$proxy}{Read}->{STAGE} = 0;
        } elsif (defined $methodID && $methodID =~ /^Immediate/) {
#print STDERR "Missing ZX or SX for proxy $proxy ($$proxyMethodID{$proxy}) in $opcodeID\n";
          $action{$proxy}{Read}->{STAGE} = 0;
        } # Else must be a direct use of METHOD in Behavior, ignore.
      }
    }
  }
  # Iterate the @proxies in order and make Parameter(s).
#print STDERR "proxyMethodID:\n";
  foreach my $proxy (sort keys %$proxyMethodID) {
    my $methodID = $$proxyMethodID{$proxy};
#print STDERR "    methodID=$methodID\n";
    foreach my $action (keys %{$action{$proxy}}) {
      my $stage = $action{$proxy}{$action}{STAGE};
#print STDERR "Proxy $proxy: action=$action stage=$stage";
      $proxy =~ /%([0-9]+)(:(\d+))?(#(.+))?/;
      $rank = $1;
      my $usage = $$properties{'%' . $rank} if $action eq "Read";
      my $parameter = &MDS::make("Parameter", {
          action=>	$action,
          usage=>	$usage,
          proxy=>	$proxy,
          method=>	$methodID,
          stages=>	$stage,
      });
      $$parameter{TYPE} = &MDS::fetch($methodID)->type();
      push @{$$parameters{$action}}, $parameter;
#print STDERR "\n";
    }
  }
}

#print STDERR "Emit\n";
foreach my $operator (sort { $a->attribute("ID") cmp $b->attribute("ID") } @Operators) {
    print $operator->emit();
}

