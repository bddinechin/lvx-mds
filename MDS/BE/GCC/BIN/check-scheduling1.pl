#!/usr/bin/perl -w
# Apply this to .md files in GCC.

while(<>) {
    my ($mnemonic, $type);
    if (/^\s*\"([_\w]+)\s*\%\d/) {
        $mnemonic = $1;
        print "INSN($mnemonic)\t";
    }
    if (/^\s*\[\s*\(set_attr\s+\"type\"\s+\"([_\w]+)\b/) {
        $type = $1;
        print "TYPE($type)\n";
    }
}

# vim: set ts=4 sw=4 et:
