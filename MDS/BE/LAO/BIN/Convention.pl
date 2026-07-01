#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
#
# Benoit Dupont de Dinechin (Benoit.Dupont-de-Dinechin@st.com).
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.


my $debug = $ENV{DEBUG} || 0;
my $FAMILY = $ENV{FAMILY};

my $MDS_SPLIT_MODE = 0;
if ($ARGV[0] eq "--split") {
    $MDS_SPLIT_MODE = 1;
    shift @ARGV;
}

use MDS;
use Behavior;
use integer;
&MDS::parse(*ARGV);

my $copyrights = &MDS::get_copyrights(" *  ","");

print<<"EOT";
/*
 * $FAMILY/Convention.tuple
${copyrights}
 * Automatically generated from the Machine Description System (MDS).
 */

#ifndef Convention
#define Convention(ID, RESERVED, ARGUMENT, RESULT, STRUCT, CALLER, CALLEE, PROGRAM, HANDLER, \\
                   VENEER, RETURN, STACK, STATIC, FRAME, GLOBAL, LOCAL, WIRED, ZERO, ONE)
#else /*Convention*/
EOT

foreach my $convention (@Convention::table) {
    my $ID = $convention->fullName('_');
    my @reserved = map {"REGISTER(".$_->fullName('_').")"} $convention->access("reserved");
    my $reserved = @reserved? (join ' ', @reserved): "/**/";
    my $RESERVED = "RESERVED(".@reserved.", $reserved)";
    my @argument = map {"REGISTER(".$_->fullName('_').")"} $convention->access("argument");
    my $argument = @argument? (join ' ', @argument): "/**/";
    my $ARGUMENT = "ARGUMENT(".@argument.", $argument)";
    my @result = map {"REGISTER(".$_->fullName('_').")"} $convention->access("result");
    my $result = @result? (join ' ', @result): "/**/";
    my $RESULT = "RESULT(".@result.", $result)";
    my @struct = map {"REGISTER(".$_->fullName('_').")"} $convention->access("struct");
    my $struct = @struct? (join ' ', @struct): "/**/";
    my $STRUCT = "STRUCT(".@struct.", $struct)";
    my @caller = map {"REGISTER(".$_->fullName('_').")"} $convention->access("caller");
    my $caller = @caller? (join ' ', @caller): "/**/";
    my $CALLER = "CALLER(".@caller.", $caller)";
    my @callee = map {"REGISTER(".$_->fullName('_').")"} $convention->access("callee");
    my $callee = @callee? (join ' ', @callee): "/**/";
    my $CALLEE = "CALLEE(".@callee.", $callee)";
    my @program = map {"REGISTER(".$_->fullName('_').")"} $convention->access("program");
    my $program = @program? (join ' ', @program): "/**/";
    my $PROGRAM = "PROGRAM(".@program.", $program)";
    my @handler = map {"REGISTER(".$_->fullName('_').")"} $convention->access("handler");
    my $handler = @handler? (join ' ', @handler): "/**/";
    my $HANDLER = "HANDLER(".@handler.", $handler)";
    my @veneer = map {"REGISTER(".$_->fullName('_').")"} $convention->access("veneer");
    my $veneer = @veneer? (join ' ', @veneer): "/**/";
    my $VENEER = "VENEER(".@veneer.", $veneer)";
    my @return = map {"REGISTER(".$_->fullName('_').")"} $convention->access("return");
    my $return = @return? (join ' ', @return): "/**/";
    my $RETURN = "RETURN(".@return.", $return)";
    my @stack = map {"REGISTER(".$_->fullName('_').")"} $convention->access("stack");
    my $stack = @stack? (join ' ', @stack): "/**/";
    my $STACK = "STACK(".@stack.", $stack)";
    my @static = map {"REGISTER(".$_->fullName('_').")"} $convention->access("static");
    my $static = @static? (join ' ', @static): "/**/";
    my $STATIC = "STATIC(".@static.", $static)";
    my @frame = map {"REGISTER(".$_->fullName('_').")"} $convention->access("frame");
    my $frame = @frame? (join ' ', @frame): "/**/";
    my $FRAME = "FRAME(".@frame.", $frame)";
    my @global = map {"REGISTER(".$_->fullName('_').")"} $convention->access("global");
    my $global = @global? (join ' ', @global): "/**/";
    my $GLOBAL = "GLOBAL(".@global.", $global)";
    my @local = map {"REGISTER(".$_->fullName('_').")"} $convention->access("local");
    my $local = @local? (join ' ', @local): "/**/";
    my $LOCAL = "LOCAL(".@local.", $local)";
    my @wired = map {"REGISTER(".$_->fullName('_').")"} $convention->access("wired");
    my $wired = @wired? (join ' ', @wired): "/**/";
    my $WIRED = "WIRED(".@wired.", $wired)";
    my @zero = map {"REGISTER(".$_->fullName('_').")"} $convention->access("zero");
    my $zero = @zero? (join ' ', @zero): "/**/";
    my $ZERO = "ZERO(".@zero.", $zero)";
    my @one = map {"REGISTER(".$_->fullName('_').")"} $convention->access("one");
    my $one = @one? (join ' ', @one): "/**/";
    my $ONE = "ONE(".@one.", $one)";
    print<<"EOT";
Convention($ID,
           $RESERVED,
           $ARGUMENT,
           $RESULT,
           $STRUCT,
           $CALLER,
           $CALLEE,
           $PROGRAM,
           $HANDLER,
           $VENEER,
           $RETURN,
           $STACK,
           $STATIC,
           $FRAME,
           $GLOBAL,
           $LOCAL,
           $WIRED,
           $ZERO,
           $ONE)
EOT
}

print<<"EOT";
#endif/*Convention*/
#undef Convention\n
EOT

# vim: set ts=4 sw=4 et:
