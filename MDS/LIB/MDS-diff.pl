
use strict;
use Getopt::Long;

use MDS;
use Carp;
use Behavior;

my $found_diff = 0;

my $me;
($me = $0) =~ s|.*/(.*)|$1|;

my $ref_fh;
my $new_fh;

my $attribute_regexp;
my $entry_regexp;
my $content_regexp;

sub usage {
    my $code = shift;
    print STDERR <<EOM;
Usage: $me [options] file1 file2
  options:
    -a|-attribute : regexp to select attributes to exclude.
    -e|-entry     : regexp to select table entries to exclude.
    -c|-content   : regexp to select content of entry to exclude.
    -h|-help      : print this help.
    file1 : reference MDS tables
    file2 : generated MDS tables
EOM
    exit $code;
}

sub pwarn {
  my $ID = shift;
  my $msg = shift;

  print STDERR "\n===> $ID <===\n$msg\n";
}

sub pdiff {
  my $ID = shift;
  my $ref_msg = shift;
  my $new_msg = shift;

  if(defined $ref_fh and defined $new_fh) {
    print $ref_fh "\n===> $ID <===\n$ref_msg\n";
    print $new_fh "\n===> $ID <===\n$new_msg\n";
  }
  else {
    print STDERR "\n===> $ID <===\nRef:\n$ref_msg\nNew:\n$new_msg\n";
  }
}

sub fetch {
  my $from = shift;
  my $ID = shift;
  my $table = shift;
  my $object = $$table{$ID};
  pwarn $ID,"from $from: unknown" unless defined $object;
  return $object;
}

sub compare_attribute {
  my ($ID,$ref_obj, $new_obj, $child) = @_;

  my $ref_attributes = $$ref_obj{ATTRIBUTES};
  my $new_attributes = $$new_obj{ATTRIBUTES};
  while(my ($name, $value) = each %{$ref_attributes}) {
    if(defined $child) {
      pwarn $ID,"Child: $child, attribute: $name not defined in new object" unless defined $$new_attributes{$name};
    }
    else {
      pwarn $ID,"Attribute: $name not defined in new object" unless defined $$new_attributes{$name};
    }
    if (not defined($attribute_regexp) or eval "\$name !~ /$attribute_regexp/") {
      if($value ne $$new_attributes{$name}) {
        if(defined $child) {
          pdiff $ID,"Child: $child, attribute: $name, value: $value","Child: $child, attribute: $name, value: $$new_attributes{$name}";
        }
        else {
          pdiff $ID,"Attribute: $name, value: $value","Attribute: $name, value: $$new_attributes{$name}";
        }
        $found_diff = 1;
      }
    }
  }
}

sub compare_child {
  my ($ID, $child, $ref_obj, $new_obj) = @_;

  return if(not defined $child or $child eq "");

  my ($ref_child) = $ref_obj->children($child);
  my ($new_child) = $new_obj->children($child);

  if(defined $ref_child) {
    pwarn $ID,"Reference children not defined for $child" unless (defined $ref_child);
    pwarn $ID,"New children not defined for $child" unless (defined $new_child);
    if($child eq "Behavior" or $child eq "Semantics") {
      my $ref_entries = $$ref_child{CONTENTS};
      my $new_entries = $$new_child{CONTENTS};
      for(my $i = 0; $i < @$ref_entries; $i++) {
        if($$ref_entries[$i] ne $$new_entries[$i]) {
          pdiff $ID,"Content $child: $$ref_entries[$i]\n","Content $child: $$new_entries[$i]\n";
          $found_diff = 1;
        }
      }
    }
    else {
      compare_attribute($ID,$ref_child,$new_child,$child);
    }
  }
}

sub compare {
  my ($ref_table,$new_table) = @_;

  foreach my $key (keys %$ref_table) {
    my $ref_object = fetch("ref",$key,$ref_table);
    my $new_object = fetch("new",$key,$new_table);
    if (not defined($entry_regexp) or eval "\$key !~ /$entry_regexp/") {
      compare_attribute($key, $ref_object, $new_object);
      foreach my $content (@{$$ref_object{CONTENTS}}) {
        if(not defined $content_regexp or eval "\$content !~ /$content_regexp/") {
          compare_child($key, ref $content, $ref_object, $new_object);
        }
      }
    }
  }
  foreach my $key (keys %$new_table) {
    if(not defined $$ref_table{$key}) {
      pwarn $key,"Not defined in reference MDS tables";
      print_entry($key,$new_table);
      $found_diff = 1;
    }
  }
}

sub print_entry {
  my ($entry,$table) = @_;

  print STDERR "$entry\n";
  my $object = fetch("ref",$entry,$table);
  my $attributes = $$object{ATTRIBUTES};
  while( my ($name,$value) = each %{$attributes}) {
    print STDERR "\t$name= $value\n";
  }
}

sub print_table {
  my $table = shift;
  foreach my $key (sort keys %$table) {
    print_entry($key,$table);
  }
}

 Getopt::Long::config(qw(no_ignore_case));
usage(1) unless GetOptions('a|attribute=s' => \$attribute_regexp,
                           'e|entry=s' => \$entry_regexp,
                           'c|content=s' => \$content_regexp,
                           'h|help' => sub { usage(0); });
usage(1) if ((scalar @ARGV)  < 2);
my $reference = $ARGV[0];
my $generated = $ARGV[1];

my $ref_diff = $ARGV[2];
my $new_diff = $ARGV[3];

if(defined $ref_diff and defined $new_diff) {
  open($ref_fh,">",$ref_diff) or die "Unable to open $ref_diff";
  open($new_fh,">",$new_diff) or die "Unable to open $new_diff";
}

print STDERR "Diff between $reference and $generated";
open my $new_file, $reference or die $!;
&MDS::parse($new_file);
my %new_table = %MDS::table;
my %ref_table;
%MDS::table = %ref_table;
open my $ref_file, $generated or die $!;
&MDS::parse($ref_file);
%ref_table = %MDS::table;

#print "Ref table:\n";
#print_table(\%ref_table);
#print "New table:\n";
#print_table(\%new_table);

compare(\%ref_table,\%new_table);
if(not $found_diff) {
  print STDERR " -> No diff found ...\n";
}

if(defined $ref_diff and defined $new_diff) {
  print STDERR " -> Found diffs ...\n" if($found_diff);
  close($ref_fh);
  close($new_fh);
}

use strict;
use Getopt::Long;

use MDS;
use Carp;
use Behavior;

my $found_diff = 0;

my $me;
($me = $0) =~ s|.*/(.*)|$1|;

my $ref_fh;
my $new_fh;

my $attribute_regexp;
my $entry_regexp;
my $content_regexp;

sub usage {
    my $code = shift;
    print STDERR <<EOM;
Usage: $me [options] file1 file2
  options:
    -a|-attribute : regexp to select attributes to exclude.
    -e|-entry     : regexp to select table entries to exclude.
    -c|-content   : regexp to select content of entry to exclude.
    -h|-help      : print this help.
    file1 : reference MDS tables
    file2 : generated MDS tables
EOM
    exit $code;
}

sub pwarn {
  my $ID = shift;
  my $msg = shift;

  print STDERR "\n===> $ID <===\n$msg\n";
}

sub pdiff {
  my $ID = shift;
  my $ref_msg = shift;
  my $new_msg = shift;

  if(defined $ref_fh and defined $new_fh) {
    print $ref_fh "\n===> $ID <===\n$ref_msg\n";
    print $new_fh "\n===> $ID <===\n$new_msg\n";
  }
  else {
    print STDERR "\n===> $ID <===\nRef:\n$ref_msg\nNew:\n$new_msg\n";
  }
}

sub fetch {
  my $from = shift;
  my $ID = shift;
  my $table = shift;
  my $object = $$table{$ID};
  pwarn $ID,"from $from: unknown" unless defined $object;
  return $object;
}

sub compare_attribute {
  my ($ID,$ref_obj, $new_obj, $child) = @_;

  my $ref_attributes = $$ref_obj{ATTRIBUTES};
  my $new_attributes = $$new_obj{ATTRIBUTES};
  while(my ($name, $value) = each %{$ref_attributes}) {
    if(defined $child) {
      pwarn $ID,"Child: $child, attribute: $name not defined in new object" unless defined $$new_attributes{$name};
    }
    else {
      pwarn $ID,"Attribute: $name not defined in new object" unless defined $$new_attributes{$name};
    }
    if (not defined($attribute_regexp) or eval "\$name !~ /$attribute_regexp/") {
      if($value ne $$new_attributes{$name}) {
        if(defined $child) {
          pdiff $ID,"Child: $child, attribute: $name, value: $value","Child: $child, attribute: $name, value: $$new_attributes{$name}";
        }
        else {
          pdiff $ID,"Attribute: $name, value: $value","Attribute: $name, value: $$new_attributes{$name}";
        }
        $found_diff = 1;
      }
    }
  }
}

sub compare_child {
  my ($ID, $child, $ref_obj, $new_obj) = @_;

  return if(not defined $child or $child eq "");

  my ($ref_child) = $ref_obj->children($child);
  my ($new_child) = $new_obj->children($child);

  if(defined $ref_child) {
    pwarn $ID,"Reference children not defined for $child" unless (defined $ref_child);
    pwarn $ID,"New children not defined for $child" unless (defined $new_child);
    if($child eq "Behavior" or $child eq "Semantics") {
      my $ref_entries = $$ref_child{CONTENTS};
      my $new_entries = $$new_child{CONTENTS};
      for(my $i = 0; $i < @$ref_entries; $i++) {
        if($$ref_entries[$i] ne $$new_entries[$i]) {
          pdiff $ID,"Content $child: $$ref_entries[$i]\n","Content $child: $$new_entries[$i]\n";
          $found_diff = 1;
        }
      }
    }
    else {
      compare_attribute($ID,$ref_child,$new_child,$child);
    }
  }
}

sub compare {
  my ($ref_table,$new_table) = @_;

  foreach my $key (keys %$ref_table) {
    my $ref_object = fetch("ref",$key,$ref_table);
    my $new_object = fetch("new",$key,$new_table);
    if (not defined($entry_regexp) or eval "\$key !~ /$entry_regexp/") {
      compare_attribute($key, $ref_object, $new_object);
      foreach my $content (@{$$ref_object{CONTENTS}}) {
        if(not defined $content_regexp or eval "\$content !~ /$content_regexp/") {
          compare_child($key, ref $content, $ref_object, $new_object);
        }
      }
    }
  }
  foreach my $key (keys %$new_table) {
    if(not defined $$ref_table{$key}) {
      pwarn $key,"Not defined in reference MDS tables";
      print_entry($key,$new_table);
      $found_diff = 1;
    }
  }
}

sub print_entry {
  my ($entry,$table) = @_;

  print STDERR "$entry\n";
  my $object = fetch("ref",$entry,$table);
  my $attributes = $$object{ATTRIBUTES};
  while( my ($name,$value) = each %{$attributes}) {
    print STDERR "\t$name= $value\n";
  }
}

sub print_table {
  my $table = shift;
  foreach my $key (sort keys %$table) {
    print_entry($key,$table);
  }
}

 Getopt::Long::config(qw(no_ignore_case));
usage(1) unless GetOptions('a|attribute=s' => \$attribute_regexp,
                           'e|entry=s' => \$entry_regexp,
                           'c|content=s' => \$content_regexp,
                           'h|help' => sub { usage(0); });
usage(1) if ((scalar @ARGV)  < 2);
my $reference = $ARGV[0];
my $generated = $ARGV[1];

my $ref_diff = $ARGV[2];
my $new_diff = $ARGV[3];

if(defined $ref_diff and defined $new_diff) {
  open($ref_fh,">",$ref_diff) or die "Unable to open $ref_diff";
  open($new_fh,">",$new_diff) or die "Unable to open $new_diff";
}

print STDERR "Diff between $reference and $generated";
open my $new_file, $reference or die $!;
&MDS::parse($new_file);
my %new_table = %MDS::table;
my %ref_table;
%MDS::table = %ref_table;
open my $ref_file, $generated or die $!;
&MDS::parse($ref_file);
%ref_table = %MDS::table;

#print "Ref table:\n";
#print_table(\%ref_table);
#print "New table:\n";
#print_table(\%new_table);

compare(\%ref_table,\%new_table);
if(not $found_diff) {
  print STDERR " -> No diff found ...\n";
}

if(defined $ref_diff and defined $new_diff) {
  print STDERR " -> Found diffs ...\n" if($found_diff);
  close($ref_fh);
  close($new_fh);
}
