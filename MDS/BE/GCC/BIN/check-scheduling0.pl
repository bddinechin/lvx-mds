#!/usr/bin/perl -w
# Apply this to Opcode.txt file in processor

while(<>) {
  my ($mnemonic, $type);
  if (/^\s+([_\w]+)\s+\|.*/) {
    $mnemonic = lc($1);
    print "INSN($mnemonic)\t";
  }
  if (/\|\t([_\w]+)/) {
    $type = lc($1);
    print "TYPE($type)\n";
  }
}

