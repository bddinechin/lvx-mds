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

package MDS;
use Carp;
use warnings;
use MDD;

# Stack of currently parsed MDS(s).
my @stack;

# Table to map {$ID} to MDS object.
my %table = ();

#
# Parse using XML::Parser::Expat.
#

use XML::Parser::Expat;
use strict;

# Require this version to support bignum.
require 5.0010_0000;

sub get_copyrights {
    my ($prefix,$suffix) = @_;

    my @copyrights = ( "Copyright (C) 2026 Liesme Tech.");

    my @formated_copyrights = map { "${prefix}$_${suffix}"  } @copyrights;

    return join("\n",@formated_copyrights);
}

sub parse {
    my $handle = shift;
    my $p1 = new XML::Parser::Expat;
    $p1->setHandlers(
        Start => sub {
            shift;
            my $element = shift;
            my %attributes = @_;
            my $parent = $stack[-1];
            my $self = &MDS::make($element, \%attributes);
            $$self{PARENT} = $parent;
            push @stack, $self;
            $self->enter();
            if (defined $parent) {
                push @{$$parent{CONTENTS}}, $self;
            }
          },
        Char => sub {
            shift;
            my $self = $stack[-1];
            push @{$$self{CONTENTS}}, @_;
          },
        End => sub {
            shift;
            my $element = shift;
            my $self = $stack[-1];
            pop @stack;
          },
      );
    local $/ = undef;
    $p1->parse(<$handle>);
}

#
# Reset every generated @<Element>::table / @<Element>::noname, so a back-end
# that parses one core file per core (rather than one concatenated stream)
# starts each core clean.  Uses the full element list @MDD::ELEMENTS emitted by
# dtd2pm.pl, so it can never miss a table the way a hand-written clear can.
# Note: %table (the ID map) is intentionally left alone -- IDs are core-qualified
# so it does not collide across cores.
#
sub clearTables {
    no strict 'refs';
    foreach my $element (@MDD::ELEMENTS) {
        @{"${element}::table"}  = ();
        @{"${element}::noname"} = ();
    }
}

#
# Drive a multi-core build: for each ($files->[i], $cores->[i]) pair, clear the
# tables, parse the file, and call $callback->($cores->[i]).  Replaces the
# open/clearTables/parse loop hand-written in every per-core back-end.
#
sub forCores {
    my ($files, $cores, $callback) = @_;
    for my $i (0 .. $#{$cores}) {
        open(my $handle, '<', $files->[$i])
          or croak "cannot open $files->[$i]: $!";
        &MDS::clearTables();
        &MDS::parse(*$handle);
        close $handle;
        $callback->($cores->[$i]);
    }
}

#
# Make a new MDS element, and enter it in MDS::table.
#
sub make {
    my ($element, $attributes, $contents) = @_;
    $contents = [] unless defined $contents;
    # Do the white-space normalization of the XML attributes.
    my %attributes;
    while (my ($name, $value) = each %{$attributes}) {
        if (defined $value) {
            $value = [ split(' ', $value) ] unless ref $value;
            $value = join ' ', @{$value};
            $value =~ s|\&amp;|&|g;
            $value =~ s|\&gt;|>|g;
            $value =~ s|\&lt;|<|g;
            $value =~ s|\&apos;|'|g;
            $value =~ s|\&quot;|"|g;
        }
        $attributes{$name} = $value;
    }
    my @contents = map {
        unless (ref $_) {
            s|\&amp;|&|g;
            s|\&gt;|>|g;
            s|\&lt;|<|g;
            s|\&apos;|'|g;
            s|\&quot;|"|g;
        }
        $_
      } grep {defined} @{$contents};
    my $self = {
        PARENT => undef,
        CORES => $MDD::CORE || "",
        ATTRIBUTES => \%attributes,
        CONTENTS => \@contents,
      };
    bless $self, $element;
    $self->validate();
    my $ID = $$attributes{ID};
    if (defined $ID) {
        confess "Element $ID already exists" if defined $table{$ID};
        $table{$ID} = $self;
    }
    return $self;
}

#
# Clone a MDS object.
#
sub clone {
    my $self = shift;
    my $ID = shift;
    my $class = ref($self);
    my %attributes = ();
    my $attributes = $$self{ATTRIBUTES};
    while (my ($name, $value) = each %{$attributes}) {
        $attributes{$name} = $value;
    }
    $attributes{ID} = $ID if defined $ID;
    my @contents = map {
        ref $_? $_->clone(): $_;
      } @{$$self{CONTENTS}};
    my $clone = {
        PARENT => undef,
        CORES => $$self{CORES},
        ATTRIBUTES => \%attributes,
        CONTENTS => \@contents,
      };
    bless $clone, $class;
    $clone->validate();
    if (defined $ID) {
        foreach my $core (split ' ', $$self{CORES}) {
            $table{$ID} = $clone;
        }
    }
    return $clone;
}

#
# Enter a MDS element; overriden in the derived classes.
#

sub enter {
    my $self = shift;
}

#
# Get the name of a MDS element. It is derived from the ID.
#
sub name {
    my $self = shift;
    my $char = shift;
    my $ID = $self->{ATTRIBUTES}->{ID};
    return undef unless defined $ID;
    my $name = (split '-', $ID)[2];
    $name =~ s/\W/$char/g if(defined $char);
    return $name;
}

#
# Get the full name of a MDS element. It is derived from the ID.
#
sub fullName {
    my $self = shift;
    my $char = shift;
    my $ID = $self->{ATTRIBUTES}->{ID};
    return undef unless defined $ID;
    my @name = (split '-', $ID)[1, 2];
    $name[1] = '' unless defined $name[1];
    my $name = join $char, @name;
    $name =~ s/\W/$char/g;
    return $name;
}

#
# Get the whole ID of a MDS element as a C identifier: the full, type-prefixed
# ID (Type-core-name) with non-word characters replaced by $char (default '_').
# Unlike name()/fullName(), which drop the element-type prefix, this is the
# token the back-ends actually emit into C (RegClass_lvx_v1_singleReg, ...).
#
sub cName {
    my $self = shift;
    my $char = shift;
    $char = '_' unless defined $char;
    my $ID = $self->{ATTRIBUTES}->{ID};
    return undef unless defined $ID;
    (my $name = $ID) =~ s/\W/$char/g;
    return $name;
}

#
# Get the core of a MDS element. It is derived from the ID.
#
sub core {
    my $self = shift;
    my $ID = $self->{ATTRIBUTES}->{ID};
    return undef unless defined $ID;
    return (split '-', $ID)[1];
}

#
# Get the type of a MDS element. It is derived from the ID.
#
sub type {
    my $self = shift;
    my $ID = $self->{ATTRIBUTES}->{ID};
    return undef unless defined $ID;
    return (split '-', $ID)[0];
}

#
# Fetch ID in table and die if not defined.
#
sub fetch {
    my $ID = shift;
    my $object = $table{$ID};
    croak "$ID unknown" unless defined $object;
    return $object;
}

#
# Return if ID exists in table.
#
sub exists {
    my $ID = shift;
    my $object = $table{$ID};
    return defined($object);
}

#
# Return a reference on XML tables
sub getTable {
    return \%table;
}

#
# Access the objects from the contents of an ID or IDREF attribute.
#
sub access {
    my $self = shift;
    my $name = shift;
    my $attributes = $$self{ATTRIBUTES};
    unless (exists $self->attlist()->{$name}) {
        croak "No attribute $name for element ", ref $self;
    }
    my $value = $$attributes{$name} || '';
    map {&MDS::fetch($_)} split ' ', $value;
}

#
# Access the single object of an IDREF attribute.  Same as (access)[0], but safe
# in scalar context (access is a map, so `my $x = $self->access(...)` would get
# the list length, not the object).  Returns undef if the attribute is empty.
#
sub reference {
    my ($self, $name) = @_;
    my ($object) = $self->access($name);
    return $object;
}

#
# Filter the existing IDs in a ID or IDREF attribute
#
sub filterID {
    my $self = shift;
    my $name = shift;
    my $attributes = $$self{ATTRIBUTES};
    unless (exists $self->attlist()->{$name}) {
        croak "No attribute $name for element ", ref $self;
    }
    my $value = $$attributes{$name} || '';
    grep {defined $table{$_}} split ' ', $value;
}

#
# Set or get an attribute of a MDS element.
#
sub attribute {
    my $self = shift;
    my ($name, $value) = @_;
    my $attributes = $$self{ATTRIBUTES};
    unless (exists $self->attlist()->{$name}) {
        croak "No attribute $name for element ", ref $self;
    }
    if (@_ == 1) {
        # Get attribute.
        return $$attributes{$name};
    } else {
        # Set attribute.
        if (defined $value) {
            $value = [ split(' ', $value) ] unless ref $value;
            $value = join ' ', @{$value};

        }
        $$attributes{$name} = $value;
    }
}

#
# Get a space-separated list attribute as a Perl list (empty if unset).  The
# common shape for names/members/fields/resources/... attributes.
#
sub attributeList {
    my ($self, $name) = @_;
    return split ' ', ($self->attribute($name) // '');
}

#
# Set or get a MDS element contents.
#
sub contents {
    my $self = shift;
    if (!@_) {
        return $$self{CONTENTS};
    } else {
        my $contents = shift;
        if (defined $contents && ref $contents eq 'ARRAY') {
            my @contents = grep {defined} @{$contents};
            $$self{CONTENTS} = \@contents;
        } else {
            print STDERR (ref $contents), "\n";
            croak "Array contents expected for element ", ref $self;
        }
    }
}

#
# Get the MDS element children of some type.
#
sub children {
    my ($self, $type) = @_;
    grep { ref $_ eq $type } @{$$self{CONTENTS}};
}

#
# Simple element validation.
#
sub validate {
    my $self = shift;
    my $element = ref $self;
    return if $element eq 'MDS';
    my $attributes = $$self{ATTRIBUTES};
    my @attributes = keys %{$attributes};
    my $attlist = $self->attlist();
    my @invalid = grep {!exists $$attlist{$_}} @attributes;
    if (@invalid) {
        my $invalid = join ' ', @invalid;
        croak "invalid $element attributes:\t", $invalid;
        return 0;
    }
    return 1;
}

#
# Check equality
#
sub equal {
    my $self = shift;
    my $element = shift;
    $self->validate();
    $element->validate();
    my @attributes1 = sort keys %{$$self{ATTRIBUTES}};
    my @contents1 = @{$$self{CONTENTS}};
    my @attributes2 = sort keys %{$$element{ATTRIBUTES}};
    my @contents2 = @{$$element{CONTENTS}};
    if(@attributes1 != @attributes2) { return 0; }
    if(@contents1 != @contents2) { return 0; }
    for(my $i=0; $i < @attributes1; $i++) {
        if($attributes1[$i] ne $attributes2[$i]) {
            return 0;
        }
    }
    for(my $i=0; $i < @contents1; $i++) {
        if((scalar @contents1) ne (scalar @contents2)) {
            return 0;
        }
    }
    return 1;
}

#use Data::Dumper;

#
# Emit a MDS object under XML form and return the list.
#
sub emit {
    my @emit;
    my $sep = '';
    my $self = shift;
    my $inner = shift;
    $self->validate();
    my $element = ref($self);
    my $attributes = $$self{ATTRIBUTES};
    my $contents = $$self{CONTENTS};
    push @emit, "\n" unless $inner;
    push @emit, "<$element";
    foreach my $attribute (sort keys %{$attributes}) {
        my $value = $$attributes{$attribute};
        if (defined $value) {
            $value =~ s|\&|&amp;|g;
            $value =~ s|\>|&gt;|g;
            $value =~ s|\<|&lt;|g;
            $value =~ s|\'|&apos;|g;   #' (for syntax coloring)
            $value =~ s|\"|&quot;|g;   #" (for syntax coloring)
            push @emit, "\n  $attribute=\t\"$value\"";
            $sep = "\n";
        }
    }
    if (@{$contents}) {
        push @emit, "$sep>";
        foreach my $emit (@{$contents}) {
            if (ref $emit) {
                push @emit, $emit->emit(1);
            } else {
                $emit =~ s|\&|&amp;|g;
                $emit =~ s|\>|&gt;|g;
                $emit =~ s|\<|&lt;|g;
                $emit =~ s|\'|&apos;|g;
                $emit =~ s|\"|&quot;|g;
                push @emit, $emit;
            }
        }
        push @emit, "</$element>";
    } else {
        push @emit, "$sep/>";
    }
    @emit;
}

#
# Find a list of operand proxies.
#
sub proxies {
    my @collect; my %seen;
    map { push @collect, /(?<!\%)(%[1-9]\d*(:\d+)?)/g; } @_;
    my @proxies =  sort grep {!$seen{$_}++}
      grep {defined $_ && /^\%/ } @collect;
    return @proxies;
}

#
# Get the RegClass(es) that are register files, in register file order. A
# RegClass is a register file when it carries a regFileName, which also means
# that it carries the width and the nativeTypes of that file and that it refers
# to itself through regFile. These used to be a RegFile element of their own,
# so this is what replaces @RegFile::table.
#
sub regFiles {
    return sort {
        $a->attribute("regFileNumber") <=> $b->attribute("regFileNumber")
      } grep { $_->isRegFile() } @RegClass::table;
}

package RegClass;

#
# Whether this RegClass is a register file rather than a view of one.
#
sub isRegFile {
    my $self = shift;
    return defined $self->attribute("regFileName");
}

#
# Get the name of the register file this RegClass is, as the back-ends emit it.
# It is unrelated to the name of the RegClass, so it cannot be derived from the
# ID the way MDS::name does it.
#
sub regFileName {
    my $self = shift;
    my $char = shift;
    my $name = $self->attribute("regFileName");
    return undef unless defined $name;
    $name =~ s/\W/$char/g if (defined $char);
    return $name;
}

#
# Get the full name of the register file this RegClass is, in the same shape as
# MDS::fullName gives for the other elements.
#
sub regFileFullName {
    my $self = shift;
    my $char = shift;
    my $name = $self->attribute("regFileName");
    return undef unless defined $name;
    my $full = join $char, ($self->core(), $name);
    $full =~ s/\W/$char/g;
    return $full;
}

1;

# vim: set ts=4 sw=4 et:
