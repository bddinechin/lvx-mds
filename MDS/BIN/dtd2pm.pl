#!/usr/bin/perl -w

use XML::DTDParser;

my $DTD = ParseDTDFile $ARGV[0];

#use Data::Dumper;
#print STDERR Dumper($DTD);

my $dtd = $ARGV[0];

# The reference map (DOC/MDD.refs, sibling of the DTD): for each IDREF/IDREFS attribute of
# an FE-authored element, which element it points at.  A DTD IDREF is untyped, so this is
# the one thing the DTD cannot supply.  Folded into %ATTLIST as a fourth field so the
# generic emitter can resolve `&<target>::ID(s)` without a hand-written sub per element.
my %REF;
(my $refs = $dtd) =~ s|[^/]*$|MDD.refs|;
if (open my $fh, '<', $refs) {
    while (<$fh>) {
        next if /^\s*#/ || /^\s*$/;
        my ($element, $attribute, $target, $kind) = split;
        die "$refs: $element.$attribute: kind must be ID or IDs, not '$kind'\n"
          unless defined $kind && ($kind eq 'ID' || $kind eq 'IDs');
        my $type = $DTD->{$element}{attributes}{$attribute}[0];
        die "$refs: $element.$attribute is not an attribute of $element\n"
          unless defined $type;
        die "$refs: $element.$attribute is $type, not an IDREF/IDREFS\n"
          unless $type eq 'IDREF' || $type eq 'IDREFS';
        my $want = $type eq 'IDREFS' ? 'IDs' : 'ID';
        warn "$refs: $element.$attribute is declared $kind but the DTD types it $type"
          . " (kept as $kind)\n" if $kind ne $want;
        $REF{$element}{$attribute} = [ $target, $kind ];
    }
    close $fh;
}

# The content model, straight from the DTD text: which child elements each element has,
# in order.  XML::DTDParser has this too, but a two-line regex over `<!ELEMENT X (...)>` is
# less coupled to its internals.  A capitalised name in the model is a child element;
# #PCDATA and EMPTY are not.  Emitted as @<Element>::CHILD_ELEMENTS (childElements(), not children() -- MDS::children is a real method) so the generic emitter knows
# which child parsers to run, and in what order, without a per-element sub.
my %CHILDREN;
{
    local $/;
    open my $fh, '<', $dtd or die "$dtd: $!\n";
    my $text = <$fh>;
    while ($text =~ /<!ELEMENT\s+(\w+)\s+\(([^)]*)\)/g) {
        my ($element, $model) = ($1, $2);
        $CHILDREN{$element} = [ grep { /^[A-Z]/ && $_ ne 'PCDATA' } ($model =~ /(\w+)/g) ];
    }
}
print << "EOT";
# Generated from $dtd by BIN/dtd2pm.pl -- DO NOT EDIT.
# Regenerate with: make -f Maintainer MDD.pm && mv MDD.pm LIB/
EOT
print << 'EOT';
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

EOT
foreach my $element (sort keys %{$DTD}) {
    my $attributes = $DTD->{$element}->{attributes};
    &process($element, $attributes);
}
print << 'EOT';

1;
# vim: set ts=4 sw=4 et:
EOT

sub process {
    my ($element, $attributes) = @_;
    print "package $element;\n";
    print '@ISA = ( "MDS" );', "\n";
    print << "EOT";
sub ID { &MDD::ID("$element", \$_[0]) }
sub IDs { &MDD::IDs("$element", \$_[0]) }
EOT
    print "%ATTLIST = (\n";
    foreach my $attribute (sort keys %{$attributes}) {
        my $type = $attributes->{$attribute}->[0];
        my $option = $attributes->{$attribute}->[1];
        my $default = $attributes->{$attribute}->[2] || 'undef';
        #print STDERR "ATTRIBUTE $attribute:\t$type\t$option\n";
        #print STDERR Dumper($$attributes{$attribute});
        # Fourth and fifth fields: the reference target and kind (ID/IDs), for IDREF/IDREFS
        # attributes of FE-authored elements, from DOC/MDD.refs.  Empty for the rest.
        my $ref = $REF{$element}{$attribute};
        my ($target, $kind) = $ref ? @{$ref} : ('', '');
        print "    $attribute=>\t[ '$type', '$option', '$default', '$target', '$kind' ],\n";
    }
    print "  );\n";
    my $children = $CHILDREN{$element} || [];
    print "\@CHILD_ELEMENTS = ( ", (join ', ', map { "'$_'" } @{$children}), " );\n";
    print << 'EOT';
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

EOT
}

# vim: set ts=4 sw=4 et:
