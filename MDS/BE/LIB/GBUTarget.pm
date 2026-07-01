
package GBUTarget;
use Carp;

my $Family = $ENV{FAMILY};
my $FAMILY = uc $Family;
my ($CORE) = split ' ', $ENV{CORES};

# Returns Instruction separator used in assembly.
sub getInstructionSeparator {
    return ";;";
}

sub getAdditionalOpndType {
    my $opdtypes = { };
    return $opdtypes;
}

sub getAdditionalCores {
    my $add_cores;
    return $add_cores;
}

sub wordWidth {
    return 32;
}

sub additionalOperands {
    my ($syntax) = @_;
    return 0
}

sub synthesizeMnemonics {
    # Synthetize the mnemonic with its adjacent modifiers.
    # Also enable the assembler to recognize obsolete mnemonics.
    my ($mnemonic, $syntax) = @_;
    my (@mnemonics) = ($mnemonic);

    # Expand the mnemonic with its instanced modifiers from syntax
    my (@results); map {
        (my $substitute = $syntax) =~ s/\%0/$_/;
        my ($result) = (split ' ', $substitute);
        push @results, $result;
        #print STDERR "\tRESULT($result)\n";
      } @mnemonics;
    return @results;
}

my %synthesizeOperands;
sub synthesizeOperands {
    # We want the operands expected by the assembler.
    my ($mnemonic, $syntax, $operands) = @_;
    my @operands = ();
    my @pieces = ($syntax =~ /(\%\d+|\=)/g);
    #    print STDERR "$mnemonic @pieces\n";
    foreach my $piece (reverse @pieces) {
        my $opdID;
        if ($piece =~ /^\%([1-9]\d*)$/) {
            $opdID = @$operands[$1-1];
        }
        unshift @operands, $opdID if ($opdID);
    }
    if ($mnemonic =~ /fmm4ahw\d/i) {
        if ($synthesizeOperands{$mnemonic}) {
            $operands[0] = "Operand-lvx-registerAp";
        }
        $synthesizeOperands{$mnemonic}++;
        #print STDERR "$mnemonic @operands\n";
    }
    #print STDERR "@operands\n";
    return @operands;
}

sub fixSyntax {
    my ($mnemonic, $syntax) = @_;
    # Insert the mnemonic into the syntax
    $syntax =~ s/\%0/$mnemonic/g;
    # Remove the mnemonic but its adjacent modifiers
    $syntax =~ s/^[^\s%]+//;
    #print STDERR "\tSYNTAX($mnemonic $syntax)\n";
    # Replace %<operand number> with %s.
    $syntax =~ s/\%\d/\%s/g;
    return $syntax;
}

sub isExtended {
    my $opcode = shift;
    my $formatID = $opcode->attribute("format");
    #    return $formatID =~ /\.X$/;
    return 0;
}

sub methodCanExtend {
    # This information does not appear to be available in MDS,
    # so synthesize from the method name.
    my $methodID = shift;
    my $canExtend = 0;
    return $canExtend;
}

sub elfCoreInfo {
    my $core = shift;
    my $type = "UNDEF";
    $type = "KV4_1" if $core =~ /kv4_v1/;
    return ("ELF_LVX_CORE_$type");
}

sub CoreNames {
    my $core = shift;
    $core =~ s/^(kv[0-9]+)_v([0-9]+)/$1-$2/g;
    return ($core);
}

sub addMacros {
    my ($file) = @_;
    print $file <<"EOT";
#define KV4_ACTIVATE_OFFSET\t6
#define KV4_ACTIVATE_WIDTH\t8
#define KV4_ACTIVATE_MASK\t\\
  (((1 << KV4_ACTIVATE_WIDTH) - 1) << KV4_ACTIVATE_OFFSET)
#define KV4_BCU_GUARD_OPCODE\t0x0f800000
#define KV4_BCU_GUARD_MASK\t0x7ffc0000
#define KV4_BCU_BLEND_OPCODE\t0x0f840000
#define KV4_BCU_BLEND_MASK\t0x7ffc0000
EOT
}

sub addCoreInfo {
    my ($file) = shift;
}

my %opcode_immx_nb;
my $BCU_STEERING_OPCODE=oct(0x0);
my $BCU_STEERING_MASK=oct(0x60000000);

my %opcode_flags = (
    LVX_OPCODE_FLAG_IMMX=>  1,
    LVX_OPCODE_FLAG_COND=>  2,
    LVX_OPCODE_FLAG_CALL=>  4,
    LVX_OPCODE_FLAG_LOAD=>  8,
    LVX_OPCODE_FLAG_STORE=> 16,
    LVX_OPCODE_FLAG_MODE32=>32,
    LVX_OPCODE_FLAG_MODE64=>64,
    LVX_OPCODE_FLAG_RISCV=> 128,
  );


my %encoding_flags = (
    simple => [ 'LVX_OPCODE_FLAG_MODE64', 'LVX_OPCODE_FLAG_MODE32' ],
    double => [ 'LVX_OPCODE_FLAG_MODE64', 'LVX_OPCODE_FLAG_MODE32' ],
    triple => [ 'LVX_OPCODE_FLAG_MODE64', 'LVX_OPCODE_FLAG_MODE32' ],
    riscv  => [ 'LVX_OPCODE_FLAG_MODE64', 'LVX_OPCODE_FLAG_RISCV' ],
  );


my %gas_define_options = (
    "LVX_OPCODE_FLAG_MODE32" => "-m32",
    "LVX_OPCODE_FLAG_MODE64" => "",
  );

# Returns GAS option to pass depending on the used define.
sub getGasDefineOptions {
    return %gas_define_options;
}

# Returns GAS define depending on opcode flags.
sub getOpcodeDefine {
    my ($opcode) = @_;

    my @flags = getEncodingFlags($opcode);
    if(grep {/LVX_OPCODE_FLAG_MODE32/} @flags) {
        return "LVX_OPCODE_FLAG_MODE32";
    }
    elsif(grep {/LVX_OPCODE_FLAG_MODE64/} @flags) {
        return "LVX_OPCODE_FLAG_MODE64";
    }
    else { croak "Do not know which gas option to pass."; }
}

# Return the list of possible opcode flags.
# Flags are mapped on one bit each of a 32 bits word.
sub getOpcodeFlagsList {
    return \%opcode_flags;
}

# Returns Encoding compatibility flags 64 or/and 32 bits.
sub getEncodingFlags {
    my ($opcode) = @_;

    my ($encoding) = $opcode->access("encoding");

    croak "ENCODING not defined: " . $encoding->name()
      if (not defined $encoding_flags{$encoding->name()});
    return @{$encoding_flags{$encoding->name()}};
}

# Must return target dependent flags attached to a code word of
# the form ${FAMILY}_OPCODE_FLAG_xxx | ${FAMILY}_OPCODE_FLAG_yyy ...
sub getOpcodeFlags {
    my ($opcode,$mnemonic,$codeword,$codeword_idx) = @_;

    my @flags = getEncodingFlags($opcode);

    $codeword = oct($codeword);
    my $opcode_key = "${mnemonic}_".$opcode->attribute("ID");
    if(not defined $opcode_immx_nb{$opcode_key}) {
        $opcode_immx_nb{$opcode_key} = 0;
    }

    if($codeword_idx > 0) {
        my ($format) = $opcode->access("format");
        if ($format->name() =~ /\.[GB]$/) {
            push @flags, "LVX_OPCODE_FLAG_COND";
        } else {
            push @flags, "LVX_OPCODE_FLAG_IMMX";
        }
    } else {
        push @flags, "LVX_OPCODE_FLAG_COND" if $mnemonic =~ /^(guard|blend)\b/;
        push @flags, "LVX_OPCODE_FLAG_CALL" if $mnemonic =~ /^call\b/;
        push @flags, "LVX_OPCODE_FLAG_LOAD" if $mnemonic =~ /^x?l[bhwdqo][sz]?\b/;
        push @flags, "LVX_OPCODE_FLAG_STORE" if $mnemonic =~ /^x?s[bhwdqo]\b/;
    }

    return join('|', @flags);
}

# Returns TRUE if must test this opcode (assembly and objdump style generation).
sub testIt {
    my ($opcode) = @_;
    my ($format) = $opcode->access("format");
    # Skip RISC-V instructions, identified by 'riscv' encoding.
    my ($encoding) = $format->access("encoding");
    my $encodingID = $encoding->attribute("ID");
    #print STDERR "Encoding $encodingID\n";
    return 0 if $encodingID =~ /riscv/;

    return 1;
}

sub ObjdumpPrint {
    my ($file,$elf_type,$opcode,$instrSeparator,$pc,$codings,$coding_size,$syntax,$pc_relative) = @_;

    my $new_syntax = $syntax;
    my @tokens = split(/ /, $syntax);
    my @new_tokens;

    map {
        if($_ =~ /^([\-0-9]+)\s*:\s*([\-0-9]+)/) {
            my $value1 = $1;
            my $value2 = $2;
            my $hex_value1 = sprintf("%#x",$value1 & 0xffffffff);
            my $hex_value2 = sprintf("%#x",$value2 & 0xffffffff);
            $_ =~ s/^$value1(\s*:\s*)$value2/$value1 ($hex_value1)$1$value2 ($hex_value2)/;
        }
        elsif($_ =~ /^([\-0-9]+)/) {
            my $value = $1;
            if($pc_relative) {
                $value += $pc;
                my $hex_value;
                if ($coding_size <= 4 || $elf_type eq "elf32") {
                    $hex_value = sprintf("%x", $value & 0xffffffff);
                } else {
                    $hex_value = sprintf("%x", $value);
                }
                $_ =~ s/^[\-0-9]+/$hex_value <main+0x$hex_value>/;
            }
            else {
                my $hex_value = sprintf("%#x",$value & 0xffffffff);
                my $test_value = $value;
                $test_value = -$value if($value < 0);
                if($test_value != ($test_value & 0xffffffff)) {
                    # Value is greater than 32 bits...
                    $hex_value = sprintf("%#x",$value);
                }
                if($hex_value eq "0") {
                    $hex_value = "0x0";
                }
                $_ =~ s/^([\-0-9]+)/$1 ($hex_value)/;
            }
        }
        push @new_tokens, $_;
      } @tokens;

    $syntax = join(' ', @new_tokens);

# main+offset in 64 bits printed on 64 bits: fffeb80c <main+0xfffeb80c> => fffffffffffeb80c <main+0xfffffffffffeb80c>
    if($pc_relative and $coding_size <= 4 and $elf_type eq "elf64") {
        $syntax =~ s/([0-9a-f]{8})/ffffffff$1/g;
    }

    my $spaces = ' ' x (3* (16 - $coding_size));

    if($coding_size > 4) {
        # IMMR case
        my $parallel = hex("0x".$$codings[3]);
        $parallel |= 0x80;
        $$codings[3] = sprintf("%02x",$parallel);

        my $BCU_STEERING_OPCODE = 0x0;
        my $BCU_STEERING_MASK = 0x60;
        my $immx_nb = 0;

        for(my $i=7; $i < $coding_size; $i+=4) {
            # Add exunum: ALU -> 0, LSU -> 1 on KV4.
            my $exu = hex("0x".$$codings[$i]);
            if($BCU_STEERING_OPCODE == ($BCU_STEERING_MASK & $exu)) {
                my ($format) = $opcode->access("format");
                my $format_name = $format->name();
                my $exunum;
                if($format_name =~ /^ALU/) {
                    $exunum = 0;
                }
                elsif ($CORE =~ /KV4/i) {
                    if ($format_name =~ /^LSU/) {
                        $exunum = 2;
                    }
                    if ($format_name =~ /^BCU/) {
                        $exunum = 0;
                    }
                }
                confess "Undefined exu number for format: $format_name"
                  if(not defined $exunum);

                $exu |= ($exunum << 3);
                $$codings[$i] = sprintf("%02x",$exu);

                $immx_nb++;
            }
        }
        print $file sprintf("%8x:\t%s %s $spaces\t%s%s\n\n",
            $pc,join(' ',splice(@$codings,0,4)),
            join(' ',@$codings),$syntax,$instrSeparator);

    }
    else {
        print $file sprintf("%8x:\t%s $spaces\t%s%s\n\n",
            $pc,join(' ',@$codings),$syntax,$instrSeparator);
    }
}

sub ConsiderScaling {
    return 1;
}

sub PCRelativeOperand {
    my ($operand) = @_;
    my ($method) = $operand->access("method");
    if(defined $method and $method->type() eq "Immediate") {
        my $methodID = $method->attribute("ID");
        # From gbu: opcodes/lvx-dis.c where print_address_func is used...
        if($methodID =~ /pcrel/) {
            return 1;
        }
    }
    return 0;
}

1;
# vim: set ts=4 sw=4 et:
