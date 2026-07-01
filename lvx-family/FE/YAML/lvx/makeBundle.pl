#!/usr/bin/perl -w

use strict;
use Data::Dumper;

my $CORE = uc($ENV{CORE});
(my $LVX = $CORE) =~ s/(KV\d+).*/$1/;

my %Extension = ( ALU0=>'00', ALU1=>'01', MAU=>'10', LSU=>'11' );

# Bundling classes.
# EXTENSIONS count must match IMMXWORDS.
# ORDERING is the order used to produce the Bundling(s).
my %Bundling = ();
%Bundling = (
    'ALL'=>     { ORDERING=>0,  BASEWORDS=>1, IMMXWORDS=>0 },
    'BCU2'=>    { ORDERING=>1,  BASEWORDS=>1, IMMXWORDS=>1 },
    'BCU2.X'=>  { ORDERING=>2,  BASEWORDS=>1, IMMXWORDS=>1 },
    'BCU0'=>    { ORDERING=>3,  BASEWORDS=>1, IMMXWORDS=>0 },
    'BCU'=>     { ORDERING=>4,  BASEWORDS=>1, IMMXWORDS=>0 },
    'FULL'=>    { ORDERING=>5,  BASEWORDS=>1, IMMXWORDS=>0 },
'FULL.X'=>  { ORDERING=>6,  BASEWORDS=>1, IMMXWORDS=>1, EXTENSIONS=>'ALU0' },
'FULL.Y'=>  { ORDERING=>7,  BASEWORDS=>1, IMMXWORDS=>2, EXTENSIONS=>'ALU0 ALU0' },
    'LITE'=>    { ORDERING=>8,  BASEWORDS=>1, IMMXWORDS=>0 },
'LITE.X'=>  { ORDERING=>9,  BASEWORDS=>1, IMMXWORDS=>1, EXTENSIONS=>'ALU1' },
'LITE.Y'=>  { ORDERING=>10, BASEWORDS=>1, IMMXWORDS=>2, EXTENSIONS=>'ALU1 ALU1' },
    'LSU0'=>    { ORDERING=>11, BASEWORDS=>1, IMMXWORDS=>0 },
    'LSU0.X'=>  { ORDERING=>12, BASEWORDS=>1, IMMXWORDS=>1, EXTENSIONS=>'LSU' },
'LSU0.Y'=>  { ORDERING=>13, BASEWORDS=>1, IMMXWORDS=>2, EXTENSIONS=>'LSU LSU' },
    'LSU'=>     { ORDERING=>14, BASEWORDS=>1, IMMXWORDS=>0 },
    'LSU.X'=>   { ORDERING=>15, BASEWORDS=>1, IMMXWORDS=>1, EXTENSIONS=>'LSU' },
'LSU.Y'=>   { ORDERING=>16, BASEWORDS=>1, IMMXWORDS=>2, EXTENSIONS=>'LSU LSU' },
    'TINY'=>    { ORDERING=>17, BASEWORDS=>1, IMMXWORDS=>0 },
'TINY.X'=>  { ORDERING=>18, BASEWORDS=>1, IMMXWORDS=>1, EXTENSIONS=>'ALU0' },
'TINY.Y'=>  { ORDERING=>19, BASEWORDS=>1, IMMXWORDS=>2, EXTENSIONS=>'ALU0 ALU0' },
    'EXT'=>     { ORDERING=>20, BASEWORDS=>1, IMMXWORDS=>0 },
    'NOP'=>     { ORDERING=>21, BASEWORDS=>1, IMMXWORDS=>0 },
  ) if $LVX eq 'KV4';

# Bundle enumeration space: ARRAY means AND and HASH means OR (keys used to order the alternatives).
# Enumerated as ALL | (BCU? (FULL | FULL.X | ... | TINY.Y)? (ALU1 | ...)? ... (LSU | ...))
# The enumeration will use one of the BCU, EXT, ALU0, ALU1, MAU, LSU issue lanes at most once.
my @Bundle = ();
@Bundle = (
    { 0=>'ALL', 1=>
          [
            { 0=>'BCU0', 1=>'BCU', 2=>'BCU2', 3=>'BCU2.X', 4=>'' },
            { 0=>'FULL', 1=>'FULL.X', 2=>'FULL.Y', 3=>'LITE', 4=>'LITE.X', 5=>'LITE.Y', 6=>'TINY', 7=>'TINY.X', 8=>'TINY.Y', 9=>'NOP', 10=>'' },
            { 0=>'LITE', 1=>'LITE.X', 2=>'LITE.Y', 3=>'TINY', 4=>'TINY.X', 5=>'TINY.Y', 6=>'NOP', 7=>'' },
            { 0=>'LSU0', 1=>'LSU0.X', 2=>'LSU0.Y', 3=>'TINY', 4=>'TINY.X', 5=>'TINY.Y', 6=>'' },
            { 0=>'LSU', 1=>'LSU.X', 2=>'LSU.Y', 3=>'TINY', 4=>'TINY.X', 5=>'TINY.Y', 6=>'' },
            { 0=>'EXT', 1=>'' },
          ]
    }
  ) if $LVX eq 'KV4';

my $WordMaxcount = 18; # FIXME for KV4.
my $WordWidth = 32;
my $WordBytes = $WordWidth/8;

my $TemplateMaxcount = 200000;
my $TemplateCounter = 0;
# HACK! Cap the number of Template(s) with a NOP, because they are not used for bundling anymore.
my $NOPMaxcounts = 1;

my %Template;
my %Dispersal;
my %Pattern;
my %BitField;
my $EncodeMax = 0;
my $OpxdWereMax = 0;

# Recursive enumeration of @Bundle contents to populate the %Template table.
# By construction, the contents is a subsequence of the [ .. ] in @Bundle.
# We canonicalize the contents and this yieleds the unique Template key.
&enumerate(\@Bundle, 0, [ ]);
sub enumerate {
    my ($sequence, $index, $contents) = @_;
    my $wordCount = 0;
    map { $wordCount += $Bundling{$_}{BASEWORDS} + $Bundling{$_}{IMMXWORDS} } @$contents;
    if ($wordCount && $wordCount <= $WordMaxcount) {
        #return if (grep {/^NOP/} @$contents) && --$NOPMaxcount < 0;
        die "Maximum number of Templates ($TemplateMaxcount) reached" if --$TemplateMaxcount < 0;
        my @canonic = sort { $Bundling{$a}{ORDERING} <=> $Bundling{$b}{ORDERING} } @$contents;
        my $ID = join '_', @canonic;
        unless (defined $Template{$ID}) {
            $Template{$ID} = { CONTENTS=> [ @$contents ] };
            $TemplateCounter++;
        }
    }
    return unless $index < scalar @$sequence;
    foreach my $item (@$sequence[$index]) {
        die "Expecting HASH" unless ref $item eq 'HASH';
        foreach my $key (sort { $a <=> $b } keys %$item) {
            my $value = $$item{$key};
            if (ref $value) {
                die "Expecting ARRAY" unless ref $value eq 'ARRAY';
                my $subsequence = [ @$value, @$sequence[($index + 1) .. (@$sequence -1)] ];
                &enumerate($subsequence, 0, $contents);
            } else {
                push @$contents, $value if $value;
                &enumerate($sequence, $index + 1, $contents);
                pop @$contents if $value;
            }
        }
    }
}
#die "TemplateCounter = $TemplateCounter\n";

# For all Template(s), generate attributes.
print "\nTemplate:\n\n";
foreach my $templateID (sort keys %Template) {
    print "  - ID: $templateID\n";
    my $template = $Template{$templateID};
    my $contents = $$template{CONTENTS};
    my $wordCount = 0;
    map { $wordCount += $Bundling{$_}{BASEWORDS} } @$contents;
    my $immxOffset = $wordCount;
    my @extraPatterns = ();
    print "    dispersals: [";
    my ($dispersalWhere, @immxList) = (0);
    foreach my $bundlingID (@$contents) {
        my $immxWords = $Bundling{$bundlingID}{IMMXWORDS};
        my $dispersalID = "$bundlingID.$dispersalWhere";
        my $dispersal =  {
            BUNDLING=> $bundlingID,
            WHERE=> $dispersalWhere,
          };
        if ($immxWords && $Bundling{$bundlingID}{EXTENSIONS}) {
            my $immxExuNums = $Bundling{$bundlingID}{EXTENSIONS};
            die "Unrecognized extension in $bundlingID" unless defined $immxExuNums;
            my @immxExuNums = split ' ', $immxExuNums;
            for (my $index = 0; $index < $immxWords; $index++) {
                my $exuNum = $immxExuNums[$index];
                my $offset = $immxOffset + $index;
                die "Mismatch between IMMXWORDS and EXTENSIONS" unless defined $exuNum;
                my $immxItem = { BUNDLING=>$bundlingID, EXUNUM=>$exuNum, OFFSET=>$offset };
                push @{$$dispersal{IMMXLIST}}, $immxItem;
                push @immxList, $immxItem;
                $dispersalID .= ".$offset";
            }
        }
        $Bundling{$bundlingID}{DISPERSAL}{$dispersalID}++;
        $Dispersal{$dispersalID} = $dispersal;
        print " $dispersalID,";
        $dispersalWhere += $Bundling{$bundlingID}{BASEWORDS};
        $immxOffset += $immxWords;
        last; # TEMPLATES NO LONGER USED!
    }
    print " ]\n";
    my $count = $immxOffset;
    my $pattern = { TYPE=>'Parallel', COUNT=>$count };
    my $patternID = "Parallel.$count";
    $Pattern{$patternID} = $pattern;
    print "    patterns: [";
    print " $patternID,";
    for (my $index = 0; $index < @immxList; $index++) {
        my $immxOffset = $dispersalWhere + $index;
        my $immxItem = $immxList[$index];
        my $immxExuNum = $$immxItem{EXUNUM};
        my $pattern = { TYPE=>'IMMX', EXUNUM=>$immxExuNum, OFFSET=>$immxOffset };
        my $patternID = "IMMX.$immxOffset.$immxExuNum";
        $Pattern{$patternID} = $pattern;
        print " $patternID,";
    }
    foreach my $patternID (@extraPatterns) {
        print " $patternID,";
    }
    print " ]\n";
    print "    wordWidth: $WordWidth\n";
    print "    alignBase: 4\n";
    print "    alignBias: 0\n";
    print "    increment: ", $count*$WordBytes, "\n";
    print "\n";
}
print STDERR "Generated ", scalar(keys %Template), " Template(s)\n";

# For all Dispersal(s), generate attributes.
print "\nDispersal:\n\n";
foreach my $dispersalID (sort keys %Dispersal) {
    my $index = 0;
    print "  - ID: $dispersalID\n";
    my $dispersal = $Dispersal{$dispersalID};
    my $immxList = $$dispersal{IMMXLIST};
    my @immxList = $immxList? @{$immxList}: ();
    my $where = $$dispersal{WHERE};
    $EncodeMax = $where if $EncodeMax < $where;
    print "    fromFields: \[ ENCODE.$index";
    foreach my $immxItem (@immxList) {
        ++$index;
        print ", ENCODE.$index";
    }
    print " \]\n";
    print "    toFields: \[ ENCODE.$where";
    foreach my $immxItem (@immxList) {
        my $offset = $$immxItem{OFFSET};
        print ", ENCODE.$offset";
        $EncodeMax = $offset if $EncodeMax < $offset;
    }
    print " \]\n";
    my $distance = $where*4;
    print "    distance: $distance\n";
    print "\n";
}
print STDERR "Generated ", scalar(keys %Dispersal), " Dispersal(s)\n";

# For all Pattern(s), generate attributes.
print "\nPattern:\n\n";
foreach my $patternID (sort keys %Pattern) {
    print "  - ID: $patternID\n";
    my $pattern = $Pattern{$patternID};
    if ($$pattern{TYPE} eq 'Parallel') {
        my $count = $$pattern{COUNT}; my $i;
        print "    fields: \[";
        for ($i = 0; $i < $count; $i++) {
            my $bitFieldID = "P.$i";
            print " $bitFieldID,";
        }
        print " \]\n";
        print "    values: \[";
        for ($i = 0; $i < $count - 1; $i++) {
            print ' "0b1",';
        }
        print " \"0b0\", \]\n";
    } elsif ($$pattern{TYPE} eq 'IMMX') {
        my $exunum = $$pattern{EXUNUM};
        my $offset = $$pattern{OFFSET};
        print "    fields: \[ IMMX.$offset \]\n";
        print "    values: \[ \"0b00$Extension{$exunum}\" \]\n";
    } else { die "Unknown Pattern type $$pattern{TYPE}" }
    print "\n";
}
print STDERR "Generated ", scalar(keys %Pattern), " Pattern(s)\n";

# For all BitField(s), generate attributes. 
print "\nBitField:\n\n";
my $immxIndex;
for ($immxIndex = 1; $immxIndex < $WordMaxcount; $immxIndex++) {
    print "  - ID: IMMX.$immxIndex\n";
    my $offset = $immxIndex*$WordWidth + 27;
    print "    offset: $offset\n";
    print "    width: 4\n";
    print "\n";
}
my $encodeIndex;
for ($encodeIndex = 0; $encodeIndex <= $EncodeMax; $encodeIndex++) {
    print "  - ID: ENCODE.$encodeIndex\n";
    my $offset = $encodeIndex*$WordWidth;
    print "    offset: $offset\n";
    print "    width: 31\n";
    print "\n";
}
my $parallelIndex;
for ($parallelIndex = 0; $parallelIndex < $WordMaxcount; $parallelIndex++) {
    print "  - ID: P.$parallelIndex\n";
    my $offset = $parallelIndex*$WordWidth + 31;
    print "    offset: $offset\n";
    print "    width: 1\n";
    print "\n";
}

# Emit mandatory BitField(s)
print<<"EOT";
  - ID: DOUBLE
    offset: 0
    width: 64

  - ID: WORD
    offset: 0
    width: 32

  - ID: HALF
    offset: 0
    width: 16

  - ID: BYTE
    offset: 0
    width: 8
EOT

# For all Bundling(s), generate attributes.
print "\nBundling:\n\n";
foreach my $bundlingID (sort { $Bundling{$a}{ORDERING} <=> $Bundling{$b}{ORDERING} } keys %Bundling) {
    print "  - ID: $bundlingID\n";
    print "    dispersals: \[";
    my $dispersal = $Bundling{$bundlingID}{DISPERSAL};
    foreach my $dispersalID (sort keys %$dispersal) {
        print " $dispersalID,";
    }
    print " \]\n";
    my $resources = $Bundling{$bundlingID}{RESOURCES};
    if ($resources) {
        print "    resources \[";
        my @resources = split ' ', $resources;
        print " \]\n";
    }
    print "\n";
}
print STDERR "Generated ", scalar(keys %Bundling), " Bundling(s)\n";

# vim: set ts=4 sw=4 et:
