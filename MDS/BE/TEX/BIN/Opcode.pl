#
# Build the Opcode.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
use strict;
#do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Format = $$Load{Format};
my $Encoding = $$Load{Encoding};
my $Instruction = $$Load{Instruction};

# Order the Format(s) by increasing number.
my @Format = sort { $$a{number} <=> $$b{number} } values %{$Format};
#print STDERR Dumper(@Format);

# Order the Encoding(s) by increasing wordCount.
my @Encoding = sort {
    $$a{wordCount} <=> $$b{wordCount} || $$a{number} <=> $$b{number}
  } values %{$Encoding};
#print STDERR Dumper(@Format);

# Map Format ID to Instruction(s).
my %instructions;
while (my ($instruction_ID, $instruction) = each %{$Instruction}) {
    foreach my $format_ID (@{$$instruction{formats}}) {
        my ($class, $name) = split /:/, $instruction_ID;
        $instructions{$format_ID}{$name} = 1;
    }
}
#print STDERR Dumper(\%instructions);

# Emit the LaTeX code on STDOUT.
my $table = '';
my $prevWidth = 0;
my $landscapeEnv = 'landscape';
my $maxRowsPortrait = 80;
my $maxRowsLandscape = 52;
my $maxRows = $maxRowsPortrait;
my $numRows = 0;
my $latexvline = " \\vline ";
my $latexfalsevline = " \\hphantom{\\vline} ";
my $colWidthPortrait = 6; # in latex points (pt)
my $colSepPortrait = 3; # in latex points (pt)
my $colWidthLandscape = 5; # in latex points (pt)
my $colSepLandscape = 2; # in latex points (pt)
my $colWidth = $colWidthPortrait; # in latex points (pt)
my $colSep = $colSepPortrait; # in latex points (pt)
my $totalWidth;

# Change
#   - vertical and horizontal badness reports
print "{\n\\hbadness=10000\n\\vbadness=10000\n";

foreach my $encoding (@Encoding) {
    #print STDERR "Encoding $$encoding{ID}\n";
    my $wordWidth = $$encoding{wordWidth};
    my $wordCount = $$encoding{wordCount};
    $totalWidth = $wordCount*$wordWidth;
    foreach my $format (@Format) {
        if ($$format{encoding} eq $$encoding{ID}) {
            # TODO: add this again
            #print STDERR "Format $$format{ID}, encoding $$encoding{ID}:\n";
            my $format_ID = $$format{ID};
            my $format_fields = $$format{fields};

            # Do not print format only used to validate HW
            next if($$format{what} =~ /\[ONLY_FOR_HW\]/);

            next if $format_ID =~ /\.Y$/; # FIXME, else crashes on MAU_*.Y formats.
# new table if base of ID changes or if length changes or if too many rows already in table
            my ($newtable) = split '_', $format_ID;
            if (   ($newtable ne $table)
                || ($prevWidth != $totalWidth)
                || ($numRows > $maxRows)) {
                if ($table) {
                    print "\\end{tabular}\n}\n";
                    if ($prevWidth > 32 && $totalWidth <= 32) {
                        print "\\end{$landscapeEnv}\n";
                        $maxRows = $maxRowsPortrait;
                        $colWidth = $colWidthPortrait;
                        $colSep = $colSepPortrait;
                    }
                    print "\\smallskip\n\n";
                }
# print STDERR "New table for $format_ID (prev. $table), width $totalWidth, (prev. $prevWidth), prev $numRows rows.\n";
                if ($totalWidth > 32 && $prevWidth <= 32) {
                    print "\\begin{$landscapeEnv}\n";
                    $maxRows = $maxRowsLandscape;
                    $colWidth = $colWidthLandscape;
                    $colSep = $colSepLandscape;
                }
                my $tabWidth = $totalWidth;
                if($totalWidth > 64) {$tabWidth = 64;}
                # as many columns as width + space to put vertical lines
                print "{\\def\\nop{--}\\tiny\n\\begin{tabular}{"
                  . "|p{16mm}\@{}p{14mm}\@{}" # for format_ID + flag_ID
                  . "*{$tabWidth}{c\@{\\hskip " . ($colSep - 0.3) . "pt}p{${colWidth}pt}\@{}}|}"
                  . "\\hline\n";
                # latex vert line = .3pt wide, get colWidth+colSep pt per column
                $table = $newtable;
                $prevWidth = $totalWidth;
                $numRows = 0;
            }
            my @matches = ();
            (my $f = $format_ID) =~ s/_/\\_/g;
            print "$f \\\\ \\hline\n"; # print format_ID
            while (my ($offset, $array) = each %{$format_fields}) {
                if (ref $array eq 'ARRAY') {
                    my ($field, $width, $contents) = @{$array};
                    if (ref $contents eq 'HASH') {
                  #print STDERR "Format $format_ID:", Dumper($field, $contents);
                        foreach my $opcode (sort { $a <=> $b } keys %{$contents}) {
                            my $name = $$contents{$opcode};
                            if (!ref $name) {
                                if ($instructions{$format_ID}{$name}) {
                                    push @matches, [ $field, $offset, $width, $opcode, $name, ' ' ];
                                } else {
                                  #print STDERR "Orphan for $format_ID:$name\n";
                                    $instructions{$format_ID}{$name} = 0;
                                    push @matches, [ $field, $offset, $width, $opcode, $name, '*' ];
                                }
                            } else {
           #push @matches, [ $field, $offset, $width, $opcode, "FORMAT*", '*' ];
                            }
                        }
                    }
                }
            }
            foreach my $match (@matches) {
                my ($field, $offset, $width, $opcode, $name, $flag) = @{$match};
                my $save_offset = $$format_fields{$offset}->[2];
                my $specialized = sprintf("\%0${width}b", $opcode);
                #        my $specialized = $opcode;
                $$format_fields{$offset}->[2] = $specialized;
                &print_opcode($format_fields, $name, $flag);
                $$format_fields{$offset}->[2] = $save_offset;
                $numRows ++;
            }
            # Warn for the orphan instructions.
            my @orphans = grep { !$instructions{$format_ID}{$_} }
              keys %{$instructions{$format_ID}};
            if (@orphans) {
     # print STDERR "Orphans for $format_ID: ", (join ' ', sort @orphans), "\n";
            }
        }
    }
}
print "\\end{tabular}\n}\n\n" if $table;
if ($prevWidth > 32) { print "\\end{$landscapeEnv}\n";}
#print STDERR Dumper(%instructions);


my $linenum = 1;

sub print_opcode {
    my ($fields, $ID, $flag) = @_;
    my $rename = {
        parallel4=>'P',
        parallel3=>'P',
        parallel2=>'P',
        parallel=>'P',
        remote2=>'R',
        remote=>'R',
        SIMD2=>'S',
        SIMD=>'S',
      };
    my @offsets = sort {$a <=> $b} keys %{$fields};
    my @words; map { push @{$words[$_/32]}, $_ } @offsets;
    my $i = $ID ; $i =~ s/_/\\_/g;
    $linenum = 1; # multi-line for > 64 bits
    print " & $i\$^{$flag}\$ ";
    foreach my $word (reverse @words) {
        foreach my $offset (reverse @{$word}) {
            my $name = $$fields{$offset}[0];
            my $width = $$fields{$offset}[1];
            my $contents = $$fields{$offset}[2];
            if ($contents =~ /^[01_]+$/) {
                $width == length $contents || die "contents is $contents, should have width $width!";
                my $field = join "&$latexfalsevline&", (split //, $contents);
                $field =~ s/_/\\nop/g;
                print " & $latexvline & $field ";
            } else {
                # do some multi col magic here
                my $resize = 4*$width - 1;
                my $field = $$rename{$name} || $name;
                #        $field =~ s/bits_9_8/\\rlap{\\hskip -1.5pt b_9_8}/;
                $field =~ s/bits_9_8/b_9_8/;
                $field =~ s/bits_7_5/b_7_5/;
                $field =~ s/_/\\_/g; # escape _ for latex
                #        $field =~ s/register/reg/;
                #        $field =~ s/unsigned/u/;
                #        $field =~ s/signed/s/;
                $field =~ s/negate/N/; ## TODO neg overfull
                $field =~ s/comparison/comp/;
                $field =~ s/condition/cond/;
                $field =~ s/rounding/rnd/;
                $field =~ s/bytea/ba/;
                $field =~ s/floatcomp/fcomp/;
                $field =~ s/scaling/scal/;
                # delete exceeding chars
                #        while (length($field) > $resize) {
                #          $field =~ s/.$//;
                #        }
                #        while (length($field) < $resize) {
                #          $field .= ' ';
                #          $field = " $field" if length($field) < $resize;
                #        }
                if ($width > 1) {
                    my $cellnum = 2*$width - 1;
                    print " & $latexvline & \\multicolumn{$cellnum}{\@{}p{"
                      . ($width * ($colWidth+$colSep) - $colSep) . "pt}\@{}"
                      . (($offset==0 && $totalWidth != 96)?'|':($totalWidth > 64 && $offset == ($totalWidth - 64)?  '|':''))
                      # if last columns, add vertical bar
                      . "}{\\centering $field"
          #          . " \\ifx\\flodraft\\undefined\\else (w$width o$offset)\\fi
                      . "} ";
                } else {
                    print " & $latexvline & $field";
                }
            }
            if ( $totalWidth > 64 ) {
                if( $offset == ($totalWidth - 64)) {
#          print STDERR "****** totalWidth $totalWidth, offset is $offset, newline\n";
                    print "\\\\\n \\hhline{~~" . "-" x 128 . "} &"; # start second line, first field empty
                }
            }
        }
    }
    if ($totalWidth == 96) {
        my $width = 32;
        my $cellnum = 2*$width ;
        my $size = $width * ($colWidth+$colSep) - $colSep;

        print " & \\multicolumn{$cellnum}{|c|}{\\cellcolor[gray]{0.9}}" ;

#    print " & \\multicolumn{$cellnum}{|\@{}p{"
#          . $size . "pt}\@{}|"
#          . "}{\\colorbox{lightgray}{\\parbox{" . ($size - $colSep - 0.5) . "pt}{\\hfill}}}";
    }
    print "\\\\\n";
    if ( $totalWidth > 64 ) { print "\\hhline{~~" . "-" x 128 . "}"; }
}

print "}\n"; # end of change badness

close(INPUT) || die $!;

# vim: set ts=4 sw=4 et:
