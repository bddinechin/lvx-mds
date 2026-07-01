#!/usr/bin/perl -w
use integer;

print "    registers: [";
for my $i (0..63) {
    my $j = 2*$i;
    print " A$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..63) {
    my $j = 2*$i + 1;
    print " A$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 2*$i;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 2*$i + 1;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..63) {
    my $j = 4*$i;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..63) {
    my $j = 4*$i + 1;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..63) {
    my $j = 4*$i + 2;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..63) {
    my $j = 4*$i + 3;
    print " B$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 4*$i;
    print " C$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 4*$i + 1;
    print " C$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 4*$i + 2;
    print " C$j,";
}
print " ]\n";

print "    registers: [";
for my $i (0..127) {
    my $j = 4*$i + 3;
    print " C$j,";
}
print " ]\n";

# vim: set ts=4 sw=4 et:
