#!/usr/bin/perl -w
use integer;

my $min = 0;
#my $min = 256;
my $max = 511; 

for my $c ($min..$max) {
  my $b = $c/2;
  my $a = $c/4;
  my @letter = ('x', 'y', 'z', 't');
  my $l = $letter[$c & 3];
  print<<"EOT";
      - { ID: C$c, location: [ XRS, $c ], names: [ "\$a${a}_$l", "\$a${a}.$l" ] }
EOT
}
print "\n";

for my $b ($min/2..$max/2) {
  my $c0 = $b*2;
  my $c1 = $c0 + 1;
  my $a = $b/2;
  my @hilo = ('lo', 'hi');
  my $hl = $hilo[$b & 1];
  print<<"EOT";
      - { ID: B$b, location: [ XRS, $c0, $c1 ], names: [ "\$a${a}_$hl", "\$a${a}.$hl" ] }
EOT
}
print "\n";

for my $a ($min/4..$max/4) {
  my $b = $a*2;
  my @hilo = ('lo', 'hi');
  my $hl = $hilo[$a & 1];
  my @letter = ('x', 'y', 'z', 't');
  my $l = $letter[$a & 3];
  my @pair = map {($_, $_ + 1)} ($a&-2);
  my $pair = "a$pair[0]a$pair[1]";
  my @quad = map {($_, $_ + 1, $_ + 2, $_ + 3)} ($a&-4);
  my $quad = "a$quad[0]a$quad[1]a$quad[2]a$quad[3]";
  my @c = ($a*4 .. $a*4 + 3);
  print<<"EOT";
      - { ID: A$a, location: [ XRS, $c[0], $c[1], $c[2], $c[3] ], names: [ "\$a$a", "\$$pair.$hl", "\$$quad.$l" ] }
EOT
}
print "\n";

for my $w ($min/8..$max/8) {
  my $a0 = $w*2;
  my $a1 = $a0 + 1;
  my @hilo = ('lo', 'hi');
  my $hl = $hilo[$w & 1];
  my @pair = map {($_, $_ + 1)} ($a0&-2);
  my $pair = "a$pair[0]a$pair[1]";
  my @quad = map {($_, $_ + 1, $_ + 2, $_ + 3)} ($a0&-4);
  my $quad = "a$quad[0]a$quad[1]a$quad[2]a$quad[3]";
  my @c = ($w*8 .. $w*8 + 7);
  print<<"EOT";
      - { ID: W$w, location: [ XRS, $c[0], $c[1], $c[2], $c[3], $c[4], $c[5], $c[6], $c[7] ], names: [ "\$$pair", "\$$quad.$hl" ] }
EOT
}
print "\n";

for my $m ($min/16..$max/16) {
  my @quad = map {($_, $_ + 1, $_ + 2, $_ + 3)} ($m*4);
  my $quad = "a$quad[0]a$quad[1]a$quad[2]a$quad[3]";
  my @c = ($m*16 .. $m*16 + 15);
  print<<"EOT";
      - { ID: M$m, location: [ XRS, $c[0], $c[1], $c[2], $c[3], $c[4], $c[5], $c[6], $c[7], $c[8], $c[9], $c[10], $c[11], $c[12], $c[13], $c[14], $c[15] ], names: [ "\$$quad" ] }
EOT
}
print "\n";

