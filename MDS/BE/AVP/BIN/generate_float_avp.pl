#!/usr/bin/perl
use strict;
use Switch;
use warnings;

my $target = shift;
$target =~ s@lvx/@@g;

my $file = shift;

my $div_file = shift;

print "Generating floating point AVPs.\n";

my $gen_cnt = 0;
my $rm_cnt = 0;
my $parsed_cnt = 0;
my $bad_case = 0;
my %h_cnters_bad_case;
my %h_cnters;
my %h_cnters_rm;

my $testsPerFile = 3000;
my %currentTest = ();
my %testNbr = ();

my $prolog = ".text\n.globl _start\n_start:\n";
my $epilog = "make \$r0 = 0\n;;\nscall 4095\n;;\nfailure:\nmake \$r0 = 1\n;;\nscall 1\n;;\n";


my $avp_dir = $ENV{'PWD'};
if (defined($ENV{'AVP_DIR'})) {
    my $avp_dir = $ENV{'AVP_DIR'};
}

# First we retrieve the number of test for each instruction
open VEC, $file || die "need a file containing a set of test vectors as argument";
while (<VEC>) {
    $_ =~ /A=(\w+)\s*B=(\w*)?\s*C=(\w*)?\s*U=(\w*)?\s*EV=(\w*)\s*RndMode=(\w*)?\s*R=(\w+)\s*#\s*([a-zA-Z]+)(\.([a-zA-Z]{3}))?/;
    my $rm = $6;
    my $ins = $8;
    my $floatcomp = $10;

    if (!defined($rm)) {
        $rm = "";
    }

    my $hashKey = "${ins}_${rm}";
    $testNbr{$hashKey}++;
}
close VEC;



open VEC, $file || die "need a file containing a set of test vectors as argument";
while (<VEC>) {

    $parsed_cnt++;

    $_ =~ /A=(\w+)\s*B=(\w*)?\s*C=(\w*)?\s*U=(\w*)?\s*EV=(\w*)\s*RndMode=(\w*)?\s*R=(\w+)\s*#\s*([a-zA-Z]+)(\.([a-zA-Z]{3}))?/;

    my $a = $1;
    my $b = $2;
    my $c = $3;
    my $u = $4;
    my $ev = $5;
    my $rm = $6;
    my $r = $7;
    my $ins = $8;
    my $floatcomp = $10;

    my $rm_name = "";

    if (defined($rm)) {
        switch ($rm) {
            case 0 {$rm_name = "rn";}
            case 1 {$rm_name = "rp";}
            case 2 {$rm_name = "rm";}
            case 3 {$rm_name = "rz";}
        }
    }

    my @handled_instructions = ("floatud");

    #    my @handled_instructions = ("ffma", "ffmarn", "ffman", "ffmanrn",
    #    "ffms", "ffmsrn", "ffmsn", "ffmsnrn", "fadd", "faddrn", "fsbf",
    #    "fsbfrn", "fmul", "fmulrn", "fmuln", "fmulnrn", "ffmawd", "ffmanwd",
    #    "ffmswd", "ffmsnwd", "fmuld", "faddd", "fsbfd", "fmulnd", "fixed",
    #    "fixedu", "fixedd", "fixedud", "float", "floatu", "floatd",
    #    "floatud", "fnarrow", "fneg", "fnegd", "fmax", "fmaxs", "fmaxd",
    #    "fmin", "fmins", "fmind", "fcomp", "fcompdl", "fabs", "fabsd",
    #    "fwidend", "fdma", "fdms", "fdmawd", "fdmswd", "fdiv", "finv",
    #    "fdualdiv", "fsqrt", "fcma", "fcms", "fcmawd", "fcmswd");

    unless (grep(/^$ins$/, @handled_instructions)) {
        if ($ins eq "") {
            print "Line number $. in test vectors file $file: no instruction found => skipping this line and not creating the test !!\n";
        } else {
            print "Line number $. in test vectors file $file: unknown instruction $ins => skipping this line and not creating the test !!\n";
        }
        $bad_case++;
        $h_cnters_bad_case{$ins}++;
        next;
    }

    if (!defined($rm)) {
        $rm = "";
    }

    my $fileIndex;
    my $hashKey = "${ins}_${rm}";
    if (!defined($currentTest{$hashKey})) {
        $currentTest{$hashKey} = 0;
    }
    $fileIndex = int($currentTest{$hashKey} / $testsPerFile);

    my $operation = uc($ins);
    my $fulldir = "$avp_dir/Opcode-$target-$operation";
    my $dir = "Opcode-$target-$operation";
    my $current_test_name;

    if ($ins eq "fabs" || $ins eq "fabsd" || $ins eq "fcomp" || $ins eq
        "fcompdl" || $ins eq "fneg" || $ins eq "fnegd") {
        $current_test_name = "$fulldir/$dir\_$fileIndex.s";
    } else {
        $current_test_name = "$fulldir/$dir\_rm$rm\_$fileIndex.s";
    }

    mkdir "$fulldir";

    open (TEST, '>>', "$current_test_name") || die "could not open $current_test_name";

    if (($currentTest{$hashKey} % $testsPerFile) == 0) {
        print TEST $prolog;
    }

    {
        my $mask = (3 << 8) | ($rm << 40);
        my $wfxl_value = sprintf("0x%x", $mask);
        print TEST "make \$r0 = $wfxl_value\n;;\n"; # Clear and Set Rounding Mode
        print TEST "wfxl \$cs, \$r0\n;;\n";
    }
    print TEST "barrier\n;;\n";
    reset_exceptions();
    if ($ins eq "ffma" || $ins eq "ffmarn" || $ins eq "ffms" || $ins eq
        "ffmsrn" || $ins eq "ffmsn" || $ins eq "ffmsnrn" || $ins eq
        "ffman" || $ins eq "ffmanrn") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "make \$r2 = 0x$c\n;;\n";
        print TEST "$ins \$r0 = \$r2, \$r0, \$r1\n;;\n";
        check_float_simple($r);
    }
    elsif ($ins eq "fdma" || $ins eq "fdms") {
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "make \$r2 = 0x$c_lsb\n;;\n";
        print TEST "make \$r3 = 0x$c_msb\n;;\n";
        print TEST "$ins \$r0 = \$p0, \$p2\n;;\n";
        check_float_simple($r);
    }
    elsif ($ins eq "fcma" || $ins eq "fcms") {
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "make \$r0 = 0x$b\n;;\n";
        print TEST "make \$r1 = 0x$a\n;;\n";
        print TEST "make \$r2 = 0x$c_lsb\n;;\n";
        print TEST "make \$r3 = 0x$c_msb\n;;\n";
        print TEST "$ins \$r0 = \$p0, \$p2\n;;\n";
        check_float_simple($r);
    }
    elsif ($ins eq "fcmawd" || $ins eq "fcmswd") {
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "make \$r0 = 0x$b\n;;\n";
        print TEST "make \$r1 = 0x$a\n;;\n";
        print TEST "make \$r2 = 0x$c_lsb\n;;\n";
        print TEST "make \$r3 = 0x$c_msb\n;;\n";
        print TEST "$ins \$p0 = \$p0, \$p2\n;;\n";
        check_float_double($r);
    }
    elsif ($ins eq "fdmawd" || $ins eq "fdmswd") {
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "make \$r2 = 0x$c_lsb\n;;\n";
        print TEST "make \$r3 = 0x$c_msb\n;;\n";
        print TEST "$ins \$p0 = \$p0, \$p2\n;;\n";
        check_float_double($r);
    }
    elsif ($ins eq "ffmawd" || $ins eq "ffmswd" || $ins eq "ffmsnwd" | $ins eq "ffmanwd") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "maked \$r2:\$r3 = 0x$c_lsb:0x$c_msb\n;;\n";
        print TEST "$ins \$p0 = \$p2, \$r0, \$r1\n;;\n";
        check_float_double($r);

    } elsif ($ins eq "fadd" || $ins eq "faddrn") {
        print TEST "make \$r0 = 0x$b\n;;\n";
        print TEST "make \$r1 = 0x$c\n;;\n";
        print TEST "$ins \$r0 = \$r0, \$r1\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "fsbf" || $ins eq "fsbfrn") {
        print TEST "make \$r0 = 0x$c\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "$ins \$r0 = \$r0, \$r1\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "fmul" || $ins eq "fmuln" || $ins eq "fmulrn" ||
        $ins eq "fmulnrn" ||  $ins eq "fmax" || $ins eq "fmin") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "$ins \$r0 = \$r0, \$r1\n;;\n";
        check_float_simple($r);
    }
    elsif (($ins eq "fmaxs") || ($ins eq "fmins")) {
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "make \$r2 = 0x$c_msb\n;;\n";
        print TEST "make \$r3 = 0x$c_lsb\n;;\n";
        print TEST "$ins \$r0 = \$r0, \$r1?\$r2 = \$r2, \$r3\n;;\n";
        check_fmaxs_fmins($r);
    } elsif ($ins eq "fcomp") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "$ins.$floatcomp \$r0 = \$r0, \$r1\n;;\n";
        check_float_simple($r);
    } elsif ($ins eq "fmind" || $ins eq "fmaxd") {
        $a =~ /(\w{8})(\w{8})/;
        my $a_lsb = $2;
        my $a_msb = $1;
        $b =~ /(\w{8})(\w{8})/;
        my $b_lsb = $2;
        my $b_msb = $1;
        print TEST "maked \$r0:\$r1 = 0x$a_lsb:0x$a_msb\n;;\n";
        print TEST "maked \$r2:\$r3 = 0x$b_lsb:0x$b_msb\n;;\n";
        print TEST "$ins \$r0:\$r1 = \$r0:\$r1, \$r2:\$r3\n;;\n";
        check_float_double($r);
    } elsif ($ins eq "fcompdl") {
        $a =~ /(\w{8})(\w{8})/;
        my $a_lsb = $2;
        my $a_msb = $1;
        $b =~ /(\w{8})(\w{8})/;
        my $b_lsb = $2;
        my $b_msb = $1;
        print TEST "maked \$r0:\$r1 = 0x$a_lsb:0x$a_msb\n;;\n";
        print TEST "maked \$r2:\$r3 = 0x$b_lsb:0x$b_msb\n;;\n";
        print TEST "$ins.$floatcomp \$r0 = \$r0:\$r1, \$r2:\$r3\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "faddd" || $ins eq "fsbfd" || $ins eq "fmuld" || $ins eq "fmulnd") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        $c =~ /(\w{8})(\w{8})/;
        my $c_lsb = $2;
        my $c_msb = $1;
        print TEST "maked \$r2:\$r3 = 0x$c_lsb:0x$c_msb\n;;\n";
        print TEST "$ins \$p0 = \$p0, \$p2\n;;\n";
        check_float_double($r);

    } elsif ($ins eq "fixed" || $ins eq "fixedu") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "$ins.$rm_name \$r0 = \$r0, 0x$u\n;;\n";
        check_integer_simple($r);

    } elsif ($ins eq "float" || $ins eq "floatu") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "$ins.$rm_name \$r0 = \$r0, 0x$u\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "fabs" | $ins eq "fneg") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "$ins \$r0 = \$r0\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "fixedd" || $ins eq "fixedud") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "$ins.$rm_name \$p0 = \$p0, 0x$u\n;;\n";
        check_integer_double($r);

    } elsif ($ins eq "floatd" || $ins eq "floatud") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "$ins.$rm_name \$r0 = \$r0, 0x$u\n;;\n";
        check_float_double($r);

    } elsif ($ins eq "fabsd" | $ins eq "fnegd") {
        $a =~ /(\w{8})(\w{8})/;
        my $a_lsb = $2;
        my $a_msb = $1;
        print TEST "maked \$r0:\$r1 = 0x$a_lsb:0x$a_msb\n;;\n";
        print TEST "$ins \$r0:\$r1 = \$r0:\$r1\n;;\n";
        check_float_double($r);

    } elsif ($ins eq "fnarrow") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "$ins \$r0 = \$p0\n;;\n";
        check_float_simple($r);

    } elsif ($ins eq "fwidend") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "$ins \$r0:\$r1 = \$r0\n;;\n";
        check_float_double($r);

    } elsif ($ins eq "fdiv") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "call __divsf3\n;;\n";
        check_float_simple($r);
    } elsif ($ins eq "finv") {
        print TEST "make \$r0 = 0x$b\n;;\n";
        print TEST "call __invf\n;;\n";
        check_float_simple($r);
    } elsif ($ins eq "fdualdiv") {
        print TEST "make \$r0 = 0x$b\n;;\n";
        print TEST "call dual_divf_p0\n;;\n";
        # dual_divf_p0 call fsinvn which should not generate any exception
        check_exceptions(0);
        print TEST "copy \$r2 = \$r0\n;;\n";
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "make \$r1 = 0x$b\n;;\n";
        print TEST "call dual_divf_p1\n;;\n";
        check_float_simple($r);
    }
    elsif ($ins eq "fsqrt") {
        print TEST "make \$r0 = 0x$a\n;;\n";
        print TEST "call sqrtf\n;;\n";
        check_float_simple($r);
    }
    else {
        print "Bad case when treating line number $. in test vectors file $file: unsupported instruction $ins => skipping this line and deleting test $current_test_name !!\n";
        unlink $current_test_name;
        $h_cnters_bad_case{$ins}++;
        $bad_case++;
        next;
    }

    $h_cnters{$ins}++;
    $h_cnters_rm{"rm"."$rm"}++ if $rm ne "";
    $rm_cnt++ if $rm ne "";


    if ((($currentTest{$hashKey} % $testsPerFile) == ($testsPerFile - 1)) ||
        ($currentTest{$hashKey} == ($testNbr{$hashKey} - 1))) {
        print TEST $epilog;
    }
    close TEST;
    $currentTest{$hashKey}++;
    $gen_cnt++;
}

print "\nDone !
Parsed $parsed_cnt test vectors
Generated $gen_cnt tests :\n";

foreach my $key (sort keys %h_cnters) {
    print "\t$h_cnters{$key} $key\n";
}

print "\n";
print "$rm_cnt avps for which rounding mode is important, spread as follows :\n";

foreach my $key (sort keys %h_cnters_rm) {
    print "\t$h_cnters_rm{$key} $key\n";
}

print "\nSkipped $bad_case bad cases :\n\n";

foreach my $key (sort keys %h_cnters_bad_case) {
    print "\t$h_cnters_bad_case{$key} $key\n";
}

print "\n";

close VEC;

sub check_fmaxs_fmins {
    $_[0] =~ /(\w{8})(\w{8})/;
    my $result_max = $1;
    my $result_select = $2;

    if (($result_max =~ m/[f7]f[89abcdef]\w{5}/) and ($_[0] !~ m/[f7]f800000/)) {
        # just check that the result is Nan
        print TEST "comp.all \$r63 = \$r0, 0x7f800000\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
        print TEST "comp.any \$r63 = \$r0, 0x007fffff\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    } else {
        # check we get the full expected result
        print TEST "comp.eq \$r63 = \$r0, 0x$result_max\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    }

    if (($result_select =~ m/[f7]f[89abcdef]\w{5}/) and ($_[0] !~ m/[f7]f800000/)) {
        # just check that the result is Nan
        print TEST "comp.all \$r63 = \$r2, 0x7f800000\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
        print TEST "comp.any \$r63 = \$r2, 0x007fffff\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    } else {
        # check we get the full expected result
        print TEST "comp.eq \$r63 = \$r2, 0x$result_select\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    }
}

sub check_float_simple {
    if (($_[0] =~ m/[f7]f[89abcdef]\w{5}/) and ($_[0] !~ m/[f7]f800000/)) {
        # just check that the result is Nan
        # Don't check bit exactly because mpfr can't be easily tweaked to
        # return our NaNs. 
        print TEST "comp.all \$r63 = \$r0, 0x7f800000\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
        print TEST "comp.any \$r63 = \$r0, 0x007fffff\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    } else {
        # check we get the full expected result
        print TEST "comp.eq \$r63 = \$r0, 0x$_[0]\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    }
}

sub check_float_double {
    if (($_[0] =~ m/[f7]ff\w{13}/) and ($_[0] !~ m/[f7]ff0000000000000/)) {
        # just check that the result is Nan
        print TEST "compdl.all \$r63 = \$r0:\$r1, 0x00000000:0x7ff00000\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
        print TEST "compdl.any \$r63 = \$r0:\$r1, 0xffffffff:0x000fffff\n;;\n";
        print TEST "cb.eqz \$r63, failure\n;;\n";
    } else {
        # check we get the full expected result
        print TEST "make \$r1 = 0x$_[0]\n;;\n";
        print TEST "compd.eq \$r63 = \$r0, \$r1\n;;\n";
        print TEST "cb.deqz \$r63, failure\n;;\n";
    }
}

sub check_integer_simple {
    # check we get the full expected result
    print TEST "comp.eq \$r63 = \$r0, 0x$_[0]\n;;\n";
    print TEST "cb.eqz \$r63, failure\n;;\n";
}


sub check_integer_double {
    # check we get the full expected result
    $_[0] =~ /(\w{8})(\w{8})/;
    my $r_lsb = $2;
    my $r_msb = $1;
    print TEST "compdl.eq \$r63 = \$r0:\$r1, 0x$r_lsb:0x$r_msb\n;;\n";
    print TEST "cb.eqz \$r63, failure\n;;\n";
}

sub reset_exceptions {
    my $wfxl_value = 0x3E;
    print TEST "make \$r0 = $wfxl_value\n;;\n";
    print TEST "wfxl \$cs, \$r0\n;;\n";
    print TEST "barrier\n;;\n";
}

sub check_exceptions {
    my $ev = shift;
    print TEST "get \$r60 = \$cs\n;;\n";
    print TEST "make \$r61 = 0x1\n;;\n";
    print TEST "make \$r62 = 0x1F\n;;\n";
    print TEST "sra \$r63 = \$r60, \$r61\n;;\n";
    print TEST "and \$r63 = \$r63, \$r62\n;;\n";
    print TEST "comp.eq \$r63 = \$r63, 0x$ev\n;;\n";
    print TEST "cb.eqz \$r63, failure\n;;\n";
}
# vim: set ts=4 sw=4 et:
