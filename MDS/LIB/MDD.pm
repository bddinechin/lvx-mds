# Generated from DOC/MDD.dtd by BIN/dtd2pm.pl -- DO NOT EDIT.
# Regenerate with: make -f Maintainer MDD.pm && mv MDD.pm LIB/
package MDD;
$CORE = $ENV{CORE};
$FAMILY =  $ENV{FAMILY};
sub ID {
    my ($type, $name) = @_;
    return undef unless defined $name;
    join '-', ($type, $CORE, $name);
}
sub IDs {
    my ($type, $names) = @_;
    return undef unless defined $names;
    my @names = ref $names? @{$names}: (split ' ', $names);
    [ map { &ID($type, $_) } @names ];
}

package Access;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Access", $_[0]) }
sub IDs { &MDD::IDs("Access", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    method=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    read=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    write=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Behavior;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Behavior", $_[0]) }
sub IDs { &MDD::IDs("Behavior", $_[0]) }
%ATTLIST = (
    methods=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    proxies=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package BitField;
@ISA = ( "MDS" );
sub ID { &MDD::ID("BitField", $_[0]) }
sub IDs { &MDD::IDs("BitField", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    offset=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Builtin;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Builtin", $_[0]) }
sub IDs { &MDD::IDs("Builtin", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    formats=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Format', 'IDs' ],
    instruction=>	[ 'IDREF', '#IMPLIED', 'undef', 'Instruction', 'ID' ],
    operands=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    prototype=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Declaration', 'Definition' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Bundle;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Bundle", $_[0]) }
sub IDs { &MDD::IDs("Bundle", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    alignBase=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    alignBias=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    canonic=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    contents=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    inverse=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    template=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Bundling;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Bundling", $_[0]) }
sub IDs { &MDD::IDs("Bundling", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    dispersals=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Dispersal', 'IDs' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Convention;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Convention", $_[0]) }
sub IDs { &MDD::IDs("Convention", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    argument=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    callee=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    caller=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    frame=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    fzero=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    global=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    handler=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    local=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    one=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    program=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    reserved=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    result=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    return=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    stack=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    static=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    struct=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    true=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    veneer=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    wired=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
    zero=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Register', 'IDs' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Declaration;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Declaration", $_[0]) }
sub IDs { &MDD::IDs("Declaration", $_[0]) }
%ATTLIST = (
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Decode;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Decode", $_[0]) }
sub IDs { &MDD::IDs("Decode", $_[0]) }
%ATTLIST = (
    case=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    mask=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    opcodes=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    shift=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Decode' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Decoding;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Decoding", $_[0]) }
sub IDs { &MDD::IDs("Decoding", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    encoding=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Decode' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Definition;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Definition", $_[0]) }
sub IDs { &MDD::IDs("Definition", $_[0]) }
%ATTLIST = (
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Dispersal;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Dispersal", $_[0]) }
sub IDs { &MDD::IDs("Dispersal", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    distance=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    fromFields=>	[ 'IDREFS', '#REQUIRED', 'undef', 'BitField', 'IDs' ],
    nopValues=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    toFields=>	[ 'IDREFS', '#REQUIRED', 'undef', 'BitField', 'IDs' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Encoding;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Encoding", $_[0]) }
sub IDs { &MDD::IDs("Encoding", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    wordCount=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    wordWidth=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Execution;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Execution", $_[0]) }
sub IDs { &MDD::IDs("Execution", $_[0]) }
%ATTLIST = (
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Format;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Format", $_[0]) }
sub IDs { &MDD::IDs("Format", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    encoding=>	[ 'IDREF', '#REQUIRED', 'undef', 'Encoding', 'ID' ],
    increment=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    operands=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Operand', 'IDs' ],
    patterns=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Pattern', 'IDs' ],
    properties=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    syntax=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    traps=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Execution', 'Behavior' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Generic;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Generic", $_[0]) }
sub IDs { &MDD::IDs("Generic", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    attributes=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    syntax=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Parameter' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Helper;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Helper", $_[0]) }
sub IDs { &MDD::IDs("Helper", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    arguments=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    result=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Immediate;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Immediate", $_[0]) }
sub IDs { &MDD::IDs("Immediate", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    bias=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    bitmask=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Immediate', 'IDs' ],
    canExtend=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Immediate', 'IDs' ],
    extend=>	[ '( Signed | Unsigned | Wrap )', '#REQUIRED', 'undef', '', '' ],
    range=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    rotate=>	[ 'IDREF', '#IMPLIED', 'undef', '', '' ],
    shift=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Instruction;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Instruction", $_[0]) }
sub IDs { &MDD::IDs("Instruction", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    formats=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Format', 'IDs' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    patterns=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Pattern', 'IDs' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    properties=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    replacement=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Operand', 'IDs' ],
    schedulings=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Scheduling', 'IDs' ],
    specialize=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Operand', 'IDs' ],
    syntax=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    synthetic=>	[ 'IDREF', '#IMPLIED', 'undef', 'Synthetic', 'IDs' ],
    traps=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Execution', 'Behavior' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Modifier;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Modifier", $_[0]) }
sub IDs { &MDD::IDs("Modifier", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    members=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    properties=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    values=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package NativeType;
@ISA = ( "MDS" );
sub ID { &MDD::ID("NativeType", $_[0]) }
sub IDs { &MDD::IDs("NativeType", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    align=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    printf=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    sizeof=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    slice=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    type=>	[ '( Float | Signed | Unsigned | Bool | Pointer | Void )', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Opcode;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Opcode", $_[0]) }
sub IDs { &MDD::IDs("Opcode", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    class=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    decoding=>	[ 'IDREF', '#IMPLIED', 'undef', '', '' ],
    encoded=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    encoding=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    format=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    increment=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    instruction=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    operands=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    patterns=>	[ 'IDREFS', '#REQUIRED', 'undef', '', '' ],
    properties=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    scheduling=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    syntax=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    traps=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Execution', 'Behavior' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Operand;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Operand", $_[0]) }
sub IDs { &MDD::IDs("Operand", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    default=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    fields=>	[ 'IDREFS', '#IMPLIED', 'undef', 'BitField', 'IDs' ],
    method=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    relocations=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Relocation', 'IDs' ],
    shortName=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Operator;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Operator", $_[0]) }
sub IDs { &MDD::IDs("Operator", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    attributes=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    expanded=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    members=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    modifiers=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    origins=>	[ 'IDREFS', '#REQUIRED', 'undef', '', '' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    syntax=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Parameter' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Parameter;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Parameter", $_[0]) }
sub IDs { &MDD::IDs("Parameter", $_[0]) }
%ATTLIST = (
    action=>	[ '( Read | Write | ReadList | WriteList )', '#REQUIRED', 'undef', '', '' ],
    method=>	[ 'IDREF', '#REQUIRED', 'undef', '', '' ],
    proxy=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    stages=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    usage=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Pattern;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Pattern", $_[0]) }
sub IDs { &MDD::IDs("Pattern", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#IMPLIED', 'undef', '', '' ],
    fields=>	[ 'IDREFS', '#REQUIRED', 'undef', 'BitField', 'IDs' ],
    values=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Platform;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Platform", $_[0]) }
sub IDs { &MDD::IDs("Platform", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    addrWidth=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    alignData=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    alignHeap=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    alignStack=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    alignText=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    charWidth=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    endian=>	[ '( Little | Big )', '#IMPLIED', 'undef', '', '' ],
    nativeFloat=>	[ 'IDREF', '#REQUIRED', 'undef', 'NativeType', 'ID' ],
    nativeInt=>	[ 'IDREF', '#REQUIRED', 'undef', 'NativeType', 'ID' ],
    nativePtr=>	[ 'IDREF', '#REQUIRED', 'undef', 'NativeType', 'ID' ],
    nativeUInt=>	[ 'IDREF', '#REQUIRED', 'undef', 'NativeType', 'ID' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Processor;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Processor", $_[0]) }
sub IDs { &MDD::IDs("Processor", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    interlocks=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    minTaken=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    pipeline=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    stages=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package RegClass;
@ISA = ( "MDS" );
sub ID { &MDD::ID("RegClass", $_[0]) }
sub IDs { &MDD::IDs("RegClass", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    bias=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    multi=>	[ 'IDREFS', '#IMPLIED', 'undef', 'RegClass', 'IDs' ],
    names=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    nativeTypes=>	[ 'IDREFS', '#IMPLIED', 'undef', 'NativeType', 'IDs' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    regFile=>	[ 'IDREF', '#REQUIRED', 'undef', 'RegClass', 'ID' ],
    regFileName=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    regFileNumber=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    registers=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Register', 'IDs' ],
    shift=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package RegField;
@ISA = ( "MDS" );
sub ID { &MDD::ID("RegField", $_[0]) }
sub IDs { &MDD::IDs("RegField", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    offset=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    owners=>	[ 'IDREFS', '#IMPLIED', 'undef', 'RegField', 'IDs' ],
    register=>	[ 'IDREF', '#REQUIRED', 'undef', 'Register', 'ID' ],
    rerrors=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    reset=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    werrors=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package RegMask;
@ISA = ( "MDS" );
sub ID { &MDD::ID("RegMask", $_[0]) }
sub IDs { &MDD::IDs("RegMask", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    count=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    first=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    regFile=>	[ 'IDREF', '#REQUIRED', 'undef', 'RegClass', 'ID' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Register;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Register", $_[0]) }
sub IDs { &MDD::IDs("Register", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    addresses=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    dwarfId=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    fields=>	[ 'IDREFS', '#IMPLIED', 'undef', 'RegField', 'IDs' ],
    names=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    owners=>	[ 'IDREFS', '#IMPLIED', 'undef', 'RegField', 'IDs' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    raccess=>	[ '(NONE|GET)', '#IMPLIED', 'undef', '', '' ],
    regFile=>	[ 'IDREF', '#IMPLIED', 'undef', 'RegClass', 'ID' ],
    reset=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    storage=>	[ 'IDREF', '#REQUIRED', 'undef', 'Storage', 'ID' ],
    waccess=>	[ '(NONE|SET|WFX)', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Relocation;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Relocation", $_[0]) }
sub IDs { &MDD::IDs("Relocation", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    elfIds=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    fields=>	[ 'IDREFS', '#REQUIRED', 'undef', 'BitField', 'IDs' ],
    linker=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    overflow=>	[ '( Signed | Unsigned | Bitfield )', '#IMPLIED', 'undef', '', '' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    relative=>	[ '( PC | GP | TP | BASE | GOT )', '#IMPLIED', 'undef', '', '' ],
    scaling=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    syntax=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    type=>	[ '( Rel_a | Rel_s | Rel_s_a )', '#IMPLIED', 'undef', '', '' ],
    underflow=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Reservation;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Reservation", $_[0]) }
sub IDs { &MDD::IDs("Reservation", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    requirements=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    resources=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Resource', 'IDs' ],
    stalls=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Resource;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Resource", $_[0]) }
sub IDs { &MDD::IDs("Resource", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    availability=>	[ 'NMTOKENS', '#REQUIRED', 'undef', '', '' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Scheduling;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Scheduling", $_[0]) }
sub IDs { &MDD::IDs("Scheduling", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    bundling=>	[ 'IDREF', '#IMPLIED', 'undef', 'Bundling', 'ID' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    reservation=>	[ 'IDREF', '#REQUIRED', 'undef', 'Reservation', 'ID' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Simulated;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Simulated", $_[0]) }
sub IDs { &MDD::IDs("Simulated", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    attributes=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    scheduling=>	[ 'IDREF', '#REQUIRED', 'undef', 'Scheduling', 'ID' ],
    syntax=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Parameter' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Storage;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Storage", $_[0]) }
sub IDs { &MDD::IDs("Storage", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    count=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    kind=>	[ '( Memory | Control | Special | Register | Neighbor | Constant )', '#REQUIRED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    width=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Synthetic;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Synthetic", $_[0]) }
sub IDs { &MDD::IDs("Synthetic", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    forced=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    formats=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Format', 'IDs' ],
    instruction=>	[ 'IDREF', '#REQUIRED', 'undef', 'Instruction', 'ID' ],
    mnemonic=>	[ 'CDATA', '#REQUIRED', 'undef', '', '' ],
    processors=>	[ 'IDREFS', '#IMPLIED', 'undef', '', '' ],
    properties=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    schedulings=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Scheduling', 'IDs' ],
    syntax=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    values=>	[ 'NMTOKENS', '#IMPLIED', 'undef', '', '' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = ( 'Execution', 'Behavior' );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}

package Template;
@ISA = ( "MDS" );
sub ID { &MDD::ID("Template", $_[0]) }
sub IDs { &MDD::IDs("Template", $_[0]) }
%ATTLIST = (
    ID=>	[ 'ID', '#REQUIRED', 'undef', '', '' ],
    alignBase=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    alignBias=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    dispersals=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Dispersal', 'IDs' ],
    increment=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
    nopAllow=>	[ 'NMTOKEN', '#IMPLIED', 'undef', '', '' ],
    nopified=>	[ 'IDREFS', '#IMPLIED', 'undef', 'Dispersal', 'IDs' ],
    original=>	[ 'IDREF', '#IMPLIED', 'undef', 'Template', 'ID' ],
    patterns=>	[ 'IDREFS', '#REQUIRED', 'undef', 'Pattern', 'IDs' ],
    what=>	[ 'CDATA', '#IMPLIED', 'undef', '', '' ],
    wordWidth=>	[ 'NMTOKEN', '#REQUIRED', 'undef', '', '' ],
  );
@CHILD_ELEMENTS = (  );
sub attlist { return \%ATTLIST; }
sub childElements { return \@CHILD_ELEMENTS; }
@table = ();
@noname = ();
sub enter {
    my ($self) = @_;
    my $ID = $self->{ATTRIBUTES}->{ID};
    if (defined $ID) {
        my $name = (split '-', $ID)[2];
        if (defined $name) {
            push @table, $self
        } else {
            push @noname, $self
        }
    }
}


1;
# vim: set ts=4 sw=4 et:
