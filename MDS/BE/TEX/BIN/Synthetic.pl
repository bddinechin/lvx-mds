#
# Build the Synthetic.tex LaTeX file.
# Benoit Dupont de Dinechin 2009.
#

use YAML::XS;

use Data::Dumper;
#use instr;
use strict;
do 'display.pl';

open(INPUT, "<", $ARGV[0]) || die "can't open $ARGV[0]\n";

local $/;
my $Load = Load(<INPUT>);
my $Register = $$Load{Register};
my $RegClass = $$Load{RegClass};
my $Immediate = $$Load{Immediate};
my $Modifier = $$Load{Modifier};
my $Operand = $$Load{Operand};
my $Format = $$Load{Format};
my $Instruction = $$Load{Instruction};
my $Synthetic = $$Load{Synthetic};

# Order the Synthetic(s) alphabetically by class then ID.
my @Synthetic = sort { ($$a{class} cmp $$b{class}) || ($$a{ID} cmp $$b{ID}) } values %{$Synthetic};
#print STDERR Dumper(@Synthetic);

# Emit the LaTeX code on STDOUT.
my $prev_class = '';

# Emit the LaTeX code on STDOUT.
print "\\subsubsectionfont{\\color{kalrayblue}}\n";
print "{\n\\tolerance=4000\n\\hbadness=10000\n\\vbadness=10000\n";

foreach my $synthetic (@Synthetic) {
  #print STDERR Dumper($instruction);

  my $base_instruction = $$synthetic{instruction};
  my $class = $$synthetic{class};
  my $what = $$synthetic{what};
  my $ID = $$synthetic{ID};
  my $synthetic_mnemonic = $$synthetic{mnemonic};
  my $synthetic_forced = $$synthetic{forced};
  my $synthetic_values = $$synthetic{values};
  my $synthetic_syntax = $$synthetic{syntax};
  my $synthetic_formats = $$synthetic{formats};
  my @synthetic_formats = @{$synthetic_formats};
  unless (defined $class) {
    ($class) = split /_/, $synthetic_formats[0];
  }

  my $instruction = $$Instruction{$base_instruction};
  my $instruction_what = $$instruction{what};
  my $instruction_ID = $$instruction{ID};
  my $instruction_class = $$instruction{class};
  my $instruction_syntax = $$instruction{syntax};
  my $instruction_mnemonic = $$instruction{mnemonic};
  my $instruction_formats = $$instruction{formats};
  my $instruction_description = $$instruction{description};
  my $instruction_execution = $$instruction{execution};
  #print STDERR "Synthetic $ID\tInstruction $instruction_ID)\n";
  next if $ID =~ /_$/;	# Assume trailing _ means dummy Instruction.
  if ($class ne $instruction_class) {
    die "Synthetic instruction does not have same class as base ($class <-> $instruction_class)";
  }
  if ($prev_class && $prev_class ne $class) {
    die "Synthetic instructions should not change class";
  }
  my ($class, $name) = split /:/, $ID;
  $name =~ s/_/\\_/g;
  (my $mnemonic = $synthetic_mnemonic) =~ s/_/\\_/g;

  print "\\subsubsection[{\\small $name: $what}]{$name\\hfill $what}\n";
  print "\\label{instr:$name}\\index{$mnemonic}\n";

  # Format(s)
  foreach my $formatID (@synthetic_formats) {
    (my $format_latex = $formatID) =~ s/_/\\_/g;
    my $format_fields = $$Format{$formatID}{fields};
    my $format_operands = $$Format{$formatID}{operands};
    my ($match_field, $match_offset, $match_width, $match_opcode);
    while (my ($offset, $array) = each %{$format_fields}) {
      if (ref $array eq 'ARRAY') {
        my ($field, $width, $contents) = @{$array};
        if (ref $contents eq 'HASH') {
          while (my ($opcode, $names) = each %{$contents}) {
            foreach my $name (@$names) {
              if ("$class:$name" eq $instruction_ID) {
                  ($match_field, $match_offset, $match_width, $match_opcode) = ($field, $offset, $width, $opcode);
                }
              }
            }
          }
        }
      }
    die "No Instruction $instruction_ID in Format $formatID:\t", Dumper($format_fields) unless defined $match_offset;
    # Preserve format_fields
    my $save_match_offset = $$format_fields{$match_offset}->[2];

    # latex operands
    my @operands_latex; my $operand_index = 0; map {
      ++$operand_index;
      my $operand = $_; $operand =~ s/_/\\_/g;
      $operands_latex[$operand_index] = $operand;
    } @{$format_operands};

    # Encoding
    my $specialized = sprintf("\%0${match_width}b", $match_opcode);
    $$format_fields{$match_offset}->[2] = $specialized;
    #print STDERR "FIELDS($ID):\t", Dumper($format_fields);
    print "\n\\paragraph{Encoding} Format \\textsf{${format_latex}, ${match_field} = $specialized}\\\\\n";

    my @save_field_offsets;

    # Modify format fields according to specialization
    foreach my $f (0..$#{$synthetic_forced}) {
#     $$synthetic_forced[$f] . ' = ' . $$synthetic_values[$f];
      my $forced = $$synthetic_forced[$f] ;
      $forced =~ s/\%//;
      $forced = $operands_latex[$forced];
      my $value = $$synthetic_values[$f];

      #print STDERR "replacing $forced by $value\n";

      foreach my $off (keys %{$format_fields}) {
        if ($$format_fields{$off}[0] eq $forced) {
          my $bits = $$format_fields{$off}[1];
          my $newstring;
          if ($value < 0) {
            die "cannot handle fixed value < -1 ($value)" if $value < -1 ;
            $newstring = '1' x $bits;
          } else {
            $newstring = sprintf("%0${bits}b",$value);
          }
          #print STDERR "    FOUND at $off: bits $bits: $$format_fields{$off}[2] changed into $newstring\n";
          push @save_field_offsets, [$off, $$format_fields{$off}[2]];
          $$format_fields{$off}[2] = $newstring;
        }
      }
    }
    print &display($format_fields);

    # Specialization
    my ($class, $instruction_ID_latex) = split /:/, $instruction_ID;
    $instruction_ID_latex =~ s/_/\\_/g;
    print "\n\\paragraph{Specializes} Instruction $instruction_ID_latex, format $format_latex\n";

    
    # Forced operands 
    my @forced;
    foreach my $f (0..$#{$synthetic_forced}) {
      push @forced, $$synthetic_forced[$f] . ' = ' . $$synthetic_values[$f];
    }


    my $forced = join ", ", @forced;
    $forced =~ s/(?<!\%)\%([1-9]\d*)/\\emph{$operands_latex[$1]}/g;
    print "\n\\paragraph{Forced operands} $forced\n";

    # Syntax
    my $syntax = $synthetic_syntax || $$Format{$formatID}{syntax} || die "no syntax for synthetic $ID";
    $syntax =~ s/(?<!\%)\%0\b/\\texttt{$mnemonic}/;

    foreach my $f (0..$#{$synthetic_forced}) {
      # replace operand by forced value
      my $index = $$synthetic_forced[$f];
      $index =~ s/\%//;
      $operands_latex[$index] = $$synthetic_values[$f];
    }
    
    $syntax =~ s/(?<!\%)\%([1-9]\d*)/\\emph{$operands_latex[$1]}/g;
    print "\n\\paragraph{Syntax} $syntax\n";
    # Description
#    my $description = $$Format{$formatID}{description} || '';
#    $description .= $instruction_description if $instruction_description;
#    $description =~ s/(?<!\%)\%([1-9])/\\emph{$operands_latex[$1]}/g;
#    $description =~ s/:\\emph{}//g; # remove things like 'signed10:.' in '%5:%6'
#    print "\n\\paragraph{Description} $description\n";

    # Execution
#    print "\n\\paragraph{Execution}\n";
#    my @methods = @{$$Format{$formatID}{methods}};
#    my $method_index = 0;
#    my @execution_operands = map {
#      my $operand = $$format_operands[$method_index++];
#      my $execution = $$RegClass{$_}{execution} || $$Immediate{$_}{execution} || $$Modifier{$_}{execution} || 'FIXME!';
#      $execution =~ s/(?<!\%)\%0\b/$operand/;
#      $execution;
#    } @methods;
#    unshift @execution_operands, 'MICROCODE';
#    my $format_execution = $$Format{$formatID}{execution};
#    my @execution_steps; my $step = 1;
#    map {
#      if (/stage\s+(\d+)/) { $step = 4*$1 }
#      else {
#        my ($access, $commit) = (0, 0);
#        if (/\=[^=]*(?<!\%)\%([1-9]\d*)/) {
#          ++$access;
#        } elsif (/(?<!\%)\%([1-9]\d*)[^=]*\=/) {
#          ++$commit;
#        }
#        s/(?<!\%)\%([1-9]\d*)/$execution_operands[$1]/g;
#        push @{$execution_steps[$step - $access + $commit]}, $_
#      }
#    } (split /\n/, $format_execution), (split /\n/, $instruction_execution);
#    my @execution = map { @{$execution_steps[$_]} } 0 .. (scalar @execution_steps - 1);
#    if (@execution) {
#      print "\\begin{verbatim}\n", (join "\n", @execution), "\\end{verbatim}\n";
#    } else {
#      print "\\textbf{MISSING}\n";
#    }
    # Modifier(s)
    my $operank = 1;
    my @modifiers;
    foreach my $operandID (@{$format_operands}) {
      my $method = $$Operand{$operandID}{method};
      my ($method_type) = keys %{$method};
      my $method_name = $$method{$method_type};
      if ($method_type eq 'Modifier') {
        push @modifiers, { METHOD=>$method_name, OPERAND=>$operandID };
      }
      $operank++;
    }
    foreach my $modifier (@modifiers) {
      my $method_name = $$modifier{METHOD};
      my $operandID = $$modifier{OPERAND};
      my $ID = $$Modifier{$method_name}{ID};
      my @members = @{$$Modifier{$method_name}{members}};
      my @cases = @{$$Modifier{$method_name}{cases}};
      my @values = @{$$Modifier{$method_name}{values}};
      (my $latex_modifier = $method_name) =~ s/_/\\_/g;
      (my $latex_operand = $operandID) =~ s/_/\\_/g;
      print "\n\\paragraph{Modifier} \\textsf{$latex_operand}:\\\\\n";
      print "\n\\noindent \\begin{tabular}{|l|l|r|} \\hline\n";
      print "\\bf{Name} & \\bf{Case} & \\bf{Value} \\\\ \\hline\n";
      while (@members) {
        my $name = shift @members;
        my $case = shift @cases;
        my $value = shift @values;
        print "$name & $case & $value \\\\\n";
      }
      print "\\hline \\end{tabular}\n";
    }
    # Restore format_fields
    foreach my $ff (@save_field_offsets) {
      $$format_fields{$$ff[0]}->[2] = $$ff[1];
    }
    $$format_fields{$match_offset}->[2] = $save_match_offset;
  }
  print "\\newpage\n";
}

print "\\subsubsectionfont{}\n}\n"; # end of kalrayblue color

close(INPUT) || die $!;

