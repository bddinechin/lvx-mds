#!/usr/bin/perl -w
# Machine Description System (MDS)
#
# Copyright (C) 2005 STMicroelectronics
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

# Jump-table generator for the recursive-descent parser with infinite
# look-ahead used by the LVX assembler (gas/config/lvx-parse.c).  This is a
# Perl port of the historical gen-parse-table.rb; it reads the same in-core MDS
# objects the other BE/GBU Perl back-ends use (@Instruction::table, ...,
# ->attribute / ->access) instead of Ruby's Mds::MdsDescription.  See
# gen-parse-table.md for the full design documentation.

use strict;
use warnings "FATAL" => "all";

use MDS;
use integer;

my $FAMILY = $ENV{FAMILY};
my @Cores  = split ' ', $ENV{CORES};

# ---------------------------------------------------------------------------
# Small helpers
# ---------------------------------------------------------------------------

# Is $x an integer (in the fixnum sense used by the original)?  Terminals are
# never numeric strings, so a /^-?\d+$/ token here is always a real rule id.
sub looks_like_int { my $x = shift; defined($x) && !ref($x) && $x =~ /^-?\d+$/ }

# Canonical, injective serialization of a scalar or (possibly nested) arrayref,
# for use as a Perl hash key that emulates Ruby's by-value Array/String keys.
sub _key {
    my ($v) = @_;
    return "A\x00" . join("\x01", map { ref $_ ? _key($_) : "s$_" } @$v)
      if ref $v eq 'ARRAY';
    return "s$v";
}

# Ruby Array#<=> : elementwise, shorter prefix sorts first.
sub cmp_arrays {
    my ($x, $y) = @_;
    my $n = @$x < @$y ? scalar(@$x) : scalar(@$y);
    for my $i (0 .. $n - 1) {
        my $c = $x->[$i] cmp $y->[$i];
        return $c if $c;
    }
    return scalar(@$x) <=> scalar(@$y);
}

# Ruby Array#each_slice(2).to_a
sub each_slice2 {
    my ($a) = @_;
    my @r;
    for (my $i = 0; $i < @$a; $i += 2) {
        my $j = $i + 1 < @$a ? $i + 1 : $i;
        push @r, [ @{$a}[$i .. $j] ];
    }
    return \@r;
}

# Deep count of scalar leaves (Ruby's arr.flatten.size).
sub flatten_count {
    my ($v) = @_;
    return 1 unless ref $v eq 'ARRAY';
    my $n = 0;
    $n += flatten_count($_) for @$v;
    return $n;
}

# Recursively replace scalar $a by $b in a nested list, matching Ruby '=='
# (a String never equals an Integer).
sub deep_replace {
    my ($a, $b, $list) = @_;
    return [ map {
        ref $_ eq 'ARRAY' ? deep_replace($a, $b, $_)
          : (looks_like_int($_) && $_ == $a ? $b : $_)
      } @$list ];
}

# Insertion-ordered hash (emulates Ruby Hash iteration order, incl. the
# delete+reinsert "move to end" used by the renumbering pass).
sub oh_new  { return { o => [], h => {} } }
sub oh_has  { my ($m, $k) = @_; exists $m->{h}{$k} }
sub oh_get  { my ($m, $k) = @_; $m->{h}{$k} }
sub oh_set  { my ($m, $k, $v) = @_; push @{$m->{o}}, $k unless exists $m->{h}{$k}; $m->{h}{$k} = $v }
sub oh_del  { my ($m, $k) = @_; return unless exists $m->{h}{$k}; delete $m->{h}{$k}; @{$m->{o}} = grep { $_ ne $k } @{$m->{o}} }
sub oh_keys { my ($m) = @_; grep { exists $m->{h}{$_} } @{$m->{o}} }
# append $v to the (arrayref) value at $k, creating [] on first use
sub oh_append { my ($m, $k, $v) = @_; oh_set($m, $k, []) unless exists $m->{h}{$k}; push @{$m->{h}{$k}}, $v }

# ---------------------------------------------------------------------------
# Terminal ordering
# ---------------------------------------------------------------------------

my %SEPS = map { $_ => 1 } ('=', ',', '[', ']', '?', '@', '(', ')');

# Push separator characters past the alphanumerics so instruction mnemonics and
# class names sort before punctuation.  The resulting order defines the 1-based
# terminal indices, which must match the Method/Instruction enum gbu.pl emits
# into include/opcode/lvx.h (the lexer compares steering ids against them).
sub overweight_seps {
    my ($word) = @_;
    return join '', map { $SEPS{$_} ? chr(ord($_) + 150) : $_ } split //, $word;
}

sub sort_terminals {
    my @t = @_;
    my @sorted = sort { overweight_seps($a) cmp overweight_seps($b) } @t;
    my %seen;
    return grep { !$seen{$_}++ } @sorted;
}

# ---------------------------------------------------------------------------
# extract_insns_from_mds -- every instruction/synthetic as a token list
# ---------------------------------------------------------------------------

sub tokenize_syntax {
    my ($stx, $ops, $anchored) = @_;
    my $suffix = ($stx =~ /(\..[^ ]*)/) ? $1 : "";
    $stx =~ s/\..[^ ]*//g;
    my @syntax = map {
        ($anchored ? /^\d+/ : /\d+/) ? $ops->[$_] : $_
      } split /([% ?,()\[\]])/, $stx;
    $syntax[0] .= $suffix if @syntax;
    return [ map { (my $s = $_) =~ s/-/_/g; $s }
             grep { !(/[% ]/ || $_ eq '') } @syntax ];
}

sub extract_insns_from_mds {
    my @insns;

    for my $insn (@Instruction::table) {
        my $syn = $insn->attribute("synthetic");
        next if defined($syn) && $syn ne '';
        my $mnemonic = $insn->attribute("mnemonic");
        for my $fmt ($insn->access("formats")) {
            my @ops = ($mnemonic, map { $_->attribute("method") } $fmt->access("operands"));
            push @insns, tokenize_syntax($fmt->attribute("syntax"), \@ops, 1);
        }
    }

    for my $insn (@Synthetic::table) {
        my $mnemonic = $insn->attribute("mnemonic");
        my $forced   = $insn->attribute("forced");
        for my $fmt ($insn->access("formats")) {
            my @ops = ($mnemonic, map { $_->attribute("method") } $fmt->access("operands"));
            # Synthetics are specialized instructions: prefer the synthetic's
            # own syntax when it forces operands, else the format's.
            my $stx = defined($forced) ? $insn->attribute("syntax") : $fmt->attribute("syntax");
            push @insns, tokenize_syntax($stx, \@ops, 0);
        }
    }

    return \@insns;
}

# ---------------------------------------------------------------------------
# Prefix tree (compacted) -- array of [key, subtree] pairs, order preserved
# ---------------------------------------------------------------------------

sub _pt_find { my ($pt, $k) = @_; for my $p (@$pt) { return $p if $p->[0] eq $k } undef }

sub _pt_insert {
    my ($insn, $ptree) = @_;
    return unless @$insn;
    my ($hd, @tl) = @$insn;
    my $pair = _pt_find($ptree, $hd);
    unless ($pair) { $pair = [ $hd, [] ]; push @$ptree, $pair; }
    _pt_insert(\@tl, $pair->[1]);
}

sub _pt_simplify {
    my ($ptree) = @_;
    my $new = [];
    for my $p (@$ptree) {
        my ($key, $val) = @$p;
        if (@$val == 1) {
            my $h = _pt_simplify($val);
            my ($hk, $hv) = @{ $h->[0] };
            push @$new, [ [ $key, @$hk ], $hv ];
        } else {
            push @$new, [ [ $key ], _pt_simplify($val) ];
        }
    }
    return $new;
}

sub insns_to_ptree {
    my ($insns) = @_;
    my $ptree = [];
    _pt_insert($_, $ptree) for @$insns;
    return _pt_simplify($ptree);
}

sub extract_sub_exprs {
    my ($ptree) = @_;
    my @exprs = map { $_->[0] } @$ptree;
    push @exprs, @{ extract_sub_exprs($_->[1]) } for @$ptree;
    my @sorted = sort { cmp_arrays($a, $b) } @exprs;
    my (@uniq, $last);
    for my $e (@sorted) {
        my $s = _key($e);
        if (!defined($last) || $s ne $last) { push @uniq, $e; $last = $s; }
    }
    return \@uniq;
}

# ---------------------------------------------------------------------------
# factorize -- greedy binary common-subexpression factorization
# ---------------------------------------------------------------------------

sub factorize {
    my ($exprs, $terminals) = @_;

    my %to_id;      # serialized value -> id
    my %to_orig;    # id -> original value (arrayref or string) == Ruby rev_hash
    my %counters;
    my $next_id = 1;    # 0 is reserved for the start symbol

    my $insert_in_table = sub {
        my ($val) = @_;
        $val = [$val] if looks_like_int($val);
        if (ref $val eq 'ARRAY' && @$val == 1 && looks_like_int($val->[0])) {
            $counters{ $val->[0] }++;
            return $val->[0];
        }
        my $k = _key($val);
        unless (exists $to_id{$k}) {
            $to_id{$k} = $next_id;
            $to_orig{$next_id} = $val;
            $next_id++;
        }
        $counters{ $to_id{$k} }++;
        return $to_id{$k};
    };

    my $compute_score = sub {
        my ($l) = @_;
        my $acc = 0;
        for my $x (@$l) {
            # Ruby looks up to_id[x] with x an integer id; no integer keys
            # exist, so this is always the default 0 -- preserved verbatim.
            my $id = looks_like_int($x) ? undef : $to_id{ _key($x) };
            $acc += defined($id) ? ($counters{$id} || 0) : 0;
        }
        return $acc;
    };

    my $select_best = sub {
        my ($l) = @_;
        my @scores = map { $compute_score->($_) } @$l;
        my $bi = 0;
        for my $i (1 .. $#scores) {
            # ties resolve to the highest index (Ruby Array#max on [score,idx])
            $bi = $i if $scores[$i] >= $scores[$bi];
        }
        return $l->[$bi];
    };

    # 1. Number the terminals first (ids 1..N in terminal order): this is what
    # locks the terminal index to gbu.pl's enum values.
    my @terminal_list = map { $insert_in_table->($_) } @$terminals;
    my @ex = map { [ map { $insert_in_table->($_) } @$_ ] } @$exprs;
    %counters = ();

    # 2. Iterate the pairing until the total size is stable.
    while (1) {
        my @new_exprs = map {
            my $x = $_;
            @$x == 1
              ? [ [ @$x ] ]
              : [ each_slice2($x), [ [ $x->[0] ], @{ each_slice2([ @{$x}[1 .. $#$x] ]) } ] ];
        } @ex;
        @new_exprs = map {
            my $l = $_;
            [ map { my $ll = $_; [ map { $insert_in_table->($_) } @$ll ] } @$l ];
        } @new_exprs;
        @new_exprs = map { $select_best->($_) } @new_exprs;
        %counters = ();
        last if flatten_count(\@new_exprs) == flatten_count(\@ex);
        @ex = @new_exprs;
    }

    # 3. Drop the rules created mid-search but no longer reachable.
    my $extract_really_used;
    $extract_really_used = sub {
        my ($list) = @_;
        return [$list] unless ref $list eq 'ARRAY';
        my @used = @$list;
        push @used, @{ $extract_really_used->($to_orig{$_}) } for @$list;
        my (%seen, @u);
        for my $v (@used) { my $s = _key([$v]); push @u, $v unless $seen{$s}++; }
        return \@u;
    };

    my %factor_map;
    my $factor_order = oh_new();    # preserve insertion order of factor_map
    my @roots = ((map { @$_ } @ex), @terminal_list);
    for my $val (@{ $extract_really_used->(\@roots) }) {
        if (defined $to_orig{$val}) {
            oh_set($factor_order, $val, $to_orig{$val}) unless oh_has($factor_order, $val);
        }
    }

    my @fexprs;
    for my $val (@ex) {
        my $id = $insert_in_table->($val);
        oh_set($factor_order, $id, $val) unless oh_has($factor_order, $id);
        push @fexprs, $id;
    }

    return (\@fexprs, $factor_order);
}

# ---------------------------------------------------------------------------
# compute_rules -- final numbered grammar
# ---------------------------------------------------------------------------

sub compute_rules {
    my ($ptree, $sub_rules, $keymap) = @_;    # $sub_rules is an ordered hash

    my $next_id = 0;
    for my $k (oh_keys($sub_rules)) { $next_id = $k if looks_like_int($k) && $k > $next_id; }
    $next_id += 1;

    my %table;    # serialized subtree -> id
    my $cr_insert = sub {
        my ($val) = @_;
        my $k = _tree_key($val);
        unless (exists $table{$k}) { $table{$k} = $next_id++; }
        return $table{$k};
    };

    my $acc = oh_new();
    my $print_aux;
    $print_aux = sub {
        my ($tree) = @_;
        for my $p (@$tree) {
            my ($key, $val) = @$p;
            my $tk = _tree_key($tree);
            my $prefix = exists $table{$tk} ? $table{$tk} : 0;
            my $next_rule = @$val ? $cr_insert->($val) : undef;
            my $km = $keymap->{ _key($key) };
            oh_append($acc, $prefix, [ grep { defined } ($km, $next_rule) ]);
            $print_aux->($val);
        }
    };
    $print_aux->($ptree);

    for my $k (oh_keys($sub_rules)) {
        my $v = oh_get($sub_rules, $k);
        oh_append($acc, $k, $v) if defined $v;
    }

    # uniq the alternatives of every rule (by value, first occurrence kept).
    for my $k (oh_keys($acc)) {
        my (%seen, @u);
        for my $alt (@{ oh_get($acc, $k) }) {
            my $s = ref $alt ? _key($alt) : "s$alt";
            push @u, $alt unless $seen{$s}++;
        }
        oh_set($acc, $k, \@u);
    }

    # Renumber the keys into a gap-free 0..N set.
    my @keys = sort { $a <=> $b } oh_keys($acc);
    my $idx = 0;
    for my $key (@keys) {
        if ($idx != $key) {
            my $val_sav = oh_get($acc, $key);
            oh_del($acc, $key);
            oh_set($acc, $idx, $val_sav);
            for my $k (oh_keys($acc)) {
                oh_set($acc, $k, deep_replace($key, $idx, oh_get($acc, $k)));
            }
        }
        $idx++;
    }

    return $acc;
}

# order-insensitive canonical key of a subtree (array of [chain, sub] pairs)
sub _tree_key {
    my ($t) = @_;
    return "{" . join(";", sort map { _key($_->[0]) . "=>" . _tree_key($_->[1]) } @$t) . "}";
}

sub compute_rules_from_insns {
    my ($insns, $terminals) = @_;
    my $ptree = insns_to_ptree($insns);
    my $sexprs = extract_sub_exprs($ptree);
    my ($idx_table, $sub_rules) = factorize($sexprs, $terminals);
    my %expr_map;
    $expr_map{ _key($sexprs->[$_]) } = $idx_table->[$_] for 0 .. $#$sexprs;
    return compute_rules($ptree, $sub_rules, \%expr_map);
}

# ---------------------------------------------------------------------------
# FIRST / FOLLOW / parse table
# ---------------------------------------------------------------------------

sub compute_firsts {
    my ($nullable, $rules) = @_;    # $rules is an ordered hash
    my %nullset = map { $_ => 1 } @$nullable;
    my %memo;

    my $first_aux;
    $first_aux = sub {
        my ($rule) = @_;
        return $memo{$rule} if exists $memo{$rule};
        my $alts = oh_get($rules, $rule);
        my $res;
        if (!ref $alts->[0]) {    # terminal (a bare String / id)
            $res = $nullset{ $rule + 0 } ? [ $rule, 'eps' ] : [ $rule ];
        } else {
            my @firsts;
            for my $alt (@$alts) {
                my @fst_alt;
                for my $r (@$alt) {
                    @fst_alt = grep { $_ ne 'eps' } map { ref $_ ? @$_ : $_ } @fst_alt;
                    my @fst_r = _flatten($first_aux->($r));
                    push @fst_alt, \@fst_r;
                    last unless grep { $_ eq 'eps' } @fst_r;
                }
                push @firsts, \@fst_alt;
            }
            $res = \@firsts;
        }
        $memo{$rule} = $res;
        return $res;
    };

    my %firsts;
    for my $hd (oh_keys($rules)) {
        my (%seen, @u);
        for my $x (_flatten($first_aux->($hd))) { push @u, $x unless $seen{$x}++; }
        $firsts{$hd} = \@u;
    }
    return \%firsts;
}

sub _flatten {
    my @out;
    for my $v (@_) {
        if (ref $v eq 'ARRAY') { push @out, _flatten(@$v); }
        else { push @out, $v; }
    }
    return @out;
}

sub compute_follows {
    my ($rules, $firsts) = @_;
    my %follows;
    $follows{0} = [ -3 ];    # -3 == $ (end of input)
    for my $rule (oh_keys($rules)) {
        $follows{$rule} = [] unless defined $follows{$rule};
        for my $alt (@{ oh_get($rules, $rule) }) {
            next if !ref($alt) && $rule == $alt + 0;
            my $nb = @$alt;
            for my $i (0 .. $nb - 1) {
                $follows{ $alt->[$i] } = [] unless defined $follows{ $alt->[$i] };
                if ($i == $nb - 1) {
                    push @{ $follows{ $alt->[$i] } }, $follows{$rule};
                } else {
                    push @{ $follows{ $alt->[$i] } }, [ grep { $_ ne 'eps' } @{ $firsts->{ $alt->[$i + 1] } } ];
                    if (grep { $_ eq 'eps' } @{ $firsts->{ $alt->[$i + 1] } }) {
                        push @{ $follows{ $alt->[$i] } }, $follows{ $alt->[$i + 1] };
                    }
                }
            }
        }
    }
    my %out;
    for my $k (keys %follows) {
        my (%seen, @u);
        for my $x (_flatten(@{ $follows{$k} })) { push @u, $x unless $seen{$x}++; }
        $out{$k} = \@u;
    }
    return \%out;
}

sub compute_parse_table {
    my ($nullable, $rules) = @_;
    my $firsts  = compute_firsts($nullable, $rules);
    my $follows = compute_follows($rules, $firsts);

    my %parse_table;    # id -> ordered hash (steering -> [directions])
    for my $id (oh_keys($rules)) {
        $parse_table{$id} = oh_new() unless defined $parse_table{$id};
        my $pt = $parse_table{$id};
        for my $alt (@{ oh_get($rules, $id) }) {
            if (ref $alt) {
                for my $fst (@{ $firsts->{ $alt->[0] } }) {
                    if ($fst eq 'eps') {
                        for my $follow (@{ $follows->{ $alt->[0] } }) {
                            oh_append($pt, $follow, $alt);
                        }
                    } else {
                        oh_append($pt, $fst, $alt);
                    }
                }
            } else {
                my $a = $alt + 0;
                for my $fst (@{ $firsts->{$a} }) {
                    if ($fst eq 'eps') {
                        for my $follow (@{ $follows->{$a} }) {
                            oh_append($pt, $follow + 0, [ -2, -2 ]) if $follow + 0 != $a;
                        }
                    } else {
                        oh_set($pt, $a, []);
                    }
                }
            }
        }
    }
    return \%parse_table;
}

# ---------------------------------------------------------------------------
# Maps (registers, immediates, modifiers, pseudo-classes)
# ---------------------------------------------------------------------------

sub compute_pseudo_class {
    my ($klass) = @_;    # arrayref of [name, [members]]
    my $reverse = oh_new();
    for my $pair (@$klass) {
        my ($k, $vals) = @$pair;
        for my $v (@$vals) { oh_append($reverse, $v, $k); }
    }
    my $pseudo = oh_new();
    for my $member (oh_keys($reverse)) {
        my $classes = oh_get($reverse, $member);
        oh_append($pseudo, join("\x00", @$classes), $member);
        $pseudo->{cls}{ join("\x00", @$classes) } = $classes;
    }
    return $pseudo;
}

sub gen_maps {
    my ($terminals) = @_;
    my %maps;

    # RegClasses -> register names (drop the .0/.1 numbered sub-views), sorted.
    my @reg;
    for my $rc (@RegClass::table) {
        my $key = $rc->cName;
        next if $key =~ /_[0-9]+$/;
        my @names = map { $_->attributeList("names") } $rc->access("registers");
        push @reg, [ $key, \@names ];
    }
    @reg = sort { $a->[0] cmp $b->[0] } @reg;
    $maps{reg} = \@reg;

    # Immediates -> width, sorted by size (wrapped ones tried last).  A stable
    # sort over document order reproduces the lexicographic tie-break.
    my @imm;
    for my $imm (@Immediate::table) {
        push @imm, [ $imm->cName, $imm->attribute("width") + 0 ];
    }
    my $imm_key = sub { my $k = shift; $k =~ /wrapped32/ ? 48 : $k =~ /wrapped8/ ? 32 : $_[0] };
    @imm = sort { $imm_key->($a->[0], $a->[1]) <=> $imm_key->($b->[0], $b->[1]) } @imm;
    $maps{imm} = \@imm;

    # Modifier classes -> lower-cased members, sorted.
    my @mod;
    for my $mod (@Modifier::table) {
        my @members = map { lc } $mod->attributeList("members");
        push @mod, [ $mod->cName, \@members ];
    }
    @mod = sort { $a->[0] cmp $b->[0] } @mod;
    $maps{mod} = \@mod;

    $maps{pseudo_reg} = compute_pseudo_class($maps{reg});
    $maps{pseudo_mod} = compute_pseudo_class($maps{mod});

    return \%maps;
}

# ---------------------------------------------------------------------------
# C emission
# ---------------------------------------------------------------------------

my $header_common = <<'EOT';
/* lvx-parse.h -- Recursive decent parser tables for the LVX ISA

   Copyright (C) 2009-2024 Free Software Foundation, Inc.
   Contributed by Kalray SA.

   This file is part of GAS.

   GAS is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3 of the license, or
   (at your option) any later version.

   GAS is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING3. If not,
   see <http://www.gnu.org/licenses/>.  */

#ifndef __H_LVX_PARSER__
#define __H_LVX_PARSER__

struct token_list* parse (struct token_s tok);
void free_token_list (struct token_list* tok_list);
void setup (int version);
void cleanup (void);
EOT
$header_common .= "\n\f\n\n";    # blank, formfeed, blank (0x0C, not "\\f")

my %TR_MAP = (
    "[" => 'rsbracket', "]" => 'lsbracket',
    "(" => 'rbracket',  ")" => 'lbracket',
    "?" => 'qmark',     "." => 'dot',
    "," => 'comma',     "@" => 'abase',
    "=" => 'equal',     "\@splat32" => 'abase_splat32',
);

sub gen_c_structs {
    my ($arch, $parse_table, $terminals, $maps) = @_;

    print "/* \U$arch\E BEGIN {{{ */\n";

    print "static const char *tokens_names_$arch\[] = {\n";
    my @names = map { /^[\[\]?.=,\@]/ ? $TR_MAP{$_} : $_ } @$terminals;
    while (@names) {
        my @slice = splice(@names, 0, 3);
        print "  " . join(", ", map { "\"$_\"" } @slice) . ",\n";
    }
    print "};\n";

    print "\n\f\n";

    for my $val (@$terminals) {
        if ($val =~ /^[()\[\]?.=,\@]/) {
            print "static const char *sep_$arch\_$TR_MAP{$val}\[] = { \"$val\" };\n";
        } elsif ($val =~ /^[a-z]/) {
            (my $n = $val) =~ s/\./_/g; $n =~ s/\@/abase/g;
            print "static const char *insn_$arch\_$n\[] = { \"$val\" };\n";
        }
    }

    print "\n";
    my $reg0 = $maps->{reg}[0][0];
    print "#define _enc(x) (1ULL << ((x) - $reg0))\n";
    print "enum prc_$arch\_id_t {\n";
    _emit_pseudo_enum($arch, "prc", $maps->{pseudo_reg});
    print "};\n";
    print "#undef _enc\n";
    _emit_pseudo_arrays($arch, "prc", $maps->{pseudo_reg});

    print "\f\n";

    my $mod0 = $maps->{mod}[0][0];
    print "#define _enc(x) (1ULL << ((x) - $mod0))\n";
    print "enum pmd_$arch\_id_t {\n";
    _emit_pseudo_enum($arch, "pmd", $maps->{pseudo_mod});
    print "};\n";
    print "#undef _enc\n";
    _emit_pseudo_arrays($arch, "pmd", $maps->{pseudo_mod});

    print "\f\n";

    print "#define arr_len(arr) sizeof(arr)/(sizeof(*arr))\n";

    print "static struct token_class reg_classes_$arch\[] = {\n";
    _emit_class_rows($arch, "prc", "reg", $maps->{pseudo_reg});
    print "  { NULL, -1, -1 },\n};\n\n";

    print "static struct token_class mod_classes_$arch\[] = {\n";
    _emit_class_rows($arch, "pmd", "mod", $maps->{pseudo_mod});
    print "  { NULL, -1, -1 },\n};\n\n";

    print "static struct token_class imm_classes_$arch\[] = {\n";
    for my $pair (@{ $maps->{imm} }) {
        my ($key, $val) = @$pair;
        my $sign = $key =~ /_signed/ ? "-" : "";
        print "  { NULL, $key, $sign$val },\n";
    }
    print "  { NULL, -1, -1 },\n};\n\n";

    print "static struct token_class insn_classes_$arch\[] = {\n";
    for my $val (@$terminals) {
        next unless $val =~ /^[a-z]/;
        (my $n = $val) =~ s/\./_/g; $n =~ s/\@/abase/g;
        print "  { insn_$arch\_$n, Instruction_$arch\_$n, arr_len (insn_$arch\_$n) },\n";
    }
    print "  { NULL, -1, -1 }\n};\n\n";

    print "static struct token_class sep_classes_$arch\[] = {\n";
    for my $val (@$terminals) {
        next unless $val =~ /^[()\[\]?.=,\@]/;
        print "  { sep_$arch\_$TR_MAP{$val}, Separator_$arch\_$TR_MAP{$val}, arr_len (sep_$arch\_$TR_MAP{$val}) },\n";
    }
    print "  { NULL, -1, -1 }\n};\n\n";

    print "\n\f\n";

    print <<"EOT";
struct token_classes token_classes_$arch = {
  .reg_classes  = reg_classes_$arch,
  .mod_classes  = mod_classes_$arch,
  .imm_classes  = imm_classes_$arch,
  .insn_classes = insn_classes_$arch,
  .sep_classes  = sep_classes_$arch,
};

\f
EOT

    # Steering-rule arrays, one per parse-table rule (sorted by id).
    for my $k (sort { $a <=> $b } keys %$parse_table) {
        printf "static struct steering_rule rule_%s_%04d[] = {\n", $arch, $k;
        my $pt = $parse_table->{$k};
        for my $steering (sort { $a <=> $b } oh_keys($pt)) {
            my $directions = oh_get($pt, $steering);
            my $s = ref($steering) eq 'ARRAY' ? $steering->[0] + 0 : $steering;
            if (!@$directions) {
                printf "  { .steering = %4d, .jump_target = %4d, .stack_it = %4d },\n", $s, -1, -1;
            } else {
                for my $dir (@$directions) {
                    my ($jt, $st) = @$dir;
                    printf "  { .steering = %4d, .jump_target = %4d, .stack_it = %4d },\n",
                      $s, (defined $jt ? $jt : -1), (defined $st ? $st : -1);
                }
            }
        }
        printf "  { .steering = %4d, .jump_target = %4d, .stack_it = %4d },\n", -1, -1, -1;
        print "};\n\n";
    }

    print "static struct rule rules_$arch\[] = {\n";
    my @rk = sort { $a <=> $b } keys %$parse_table;
    while (@rk) {
        my @slice = splice(@rk, 0, 5);
        print "  " . join(", ", map { sprintf "{ rule_%s_%04d }", $arch, $_ } @slice) . ",\n";
    }
    print "};\n\n";

    # promote_immediate: each immediate token escalates to the next larger one.
    my @ikeys = map { $_->[0] } @{ $maps->{imm} };
    print <<"EOT";
static inline /* enum lvx_tokens_$arch */ int
promote_immediate_$arch (/* enum lvx_tokens_$arch */ int tok)
{
  switch (tok)
    {
EOT
    for my $i (0 .. $#ikeys) {
        my $to = $i < $#ikeys ? $ikeys[$i + 1] : $ikeys[-1];
        if ($ikeys[$i] ne $to) {
            print "      case $ikeys[$i]:\n\treturn $to;\n";
        }
    }
    print <<"EOT";
      default:
	return tok;
    }
}

EOT

    print <<"EOT";
__attribute__((unused))
static void
setup_$arch (void)
{
  env.tokens_names      = tokens_names_$arch;
  env.fst_reg           = $reg0;
  env.sys_reg           = RegClass_$arch\_systemReg;
  env.fst_mod           = $mod0;
  env.promote_immediate = promote_immediate_$arch;
  env.rules             = rules_$arch;
  env.token_classes     = &token_classes_$arch;
  env.insns             = NULL;
//  env.allow_all_sfr     = allow_all_sfr;
}

/* }}} \U$arch\E END */
EOT
}

sub _emit_pseudo_enum {
    my ($arch, $tag, $pseudo) = @_;
    my $i = 0;
    for my $key (oh_keys($pseudo)) {
        my $classes = $pseudo->{cls}{$key};
        printf "  %s_%s_id_%02d = ", $tag, $arch, $i;
        print join("\n   | ", map { "_enc ($_)" } @$classes) . ",\n";
        $i++;
    }
}

sub _emit_pseudo_arrays {
    my ($arch, $tag, $pseudo) = @_;
    my $i = 0;
    for my $key (oh_keys($pseudo)) {
        my $vals = oh_get($pseudo, $key);
        print "\n";
        printf "static const char *%s_%s_%02d[] = {\n", $tag, $arch, $i;
        my @v = @$vals;
        while (@v) {
            my @slice = splice(@v, 0, 4);
            print "  " . join(", ", map { "\"$_\"" } @slice) . ",\n";
        }
        print "};\n";
        $i++;
    }
}

sub _emit_class_rows {
    my ($arch, $tag, $kind, $pseudo) = @_;
    my $i = 0;
    for my $key (oh_keys($pseudo)) {
        my $tmp = sprintf "%s_%s_%02d", $tag, $arch, $i;
        printf "  { %s, %s_%s_id_%02d, arr_len (%s) },\n", $tmp, $tag, $arch, $i, $tmp;
        $i++;
    }
}

# ---------------------------------------------------------------------------
# gen_header / main
# ---------------------------------------------------------------------------

sub gen_header {
    my ($arch) = @_;

    my $insns = extract_insns_from_mds();
    my @terminals = sort_terminals(map { @$_ } @$insns);
    my $maps = gen_maps(\@terminals);

    @terminals = sort_terminals(
        @terminals,
        (map { $_->[0] } @{ $maps->{reg} }),
        (map { $_->[0] } @{ $maps->{mod} }),
        (map { $_->[0] } @{ $maps->{imm} }),
    );
    my %term_index;
    $term_index{ $terminals[$_] } = $_ for 0 .. $#terminals;

    my @nullable;
    for my $pair (@{ $maps->{mod} }) {
        my ($key, $vals) = @$pair;
        next unless grep { $_ eq '.' } @$vals;
        push @nullable, $term_index{$key} + 1 if defined $term_index{$key};
    }

    # Promote leaf (terminal) rules: a rule whose body is a bare terminal maps
    # to its own id as a string.
    my $acc = compute_rules_from_insns($insns, \@terminals);
    my $rules = oh_new();
    for my $hd (oh_keys($acc)) {
        my $tl = oh_get($acc, $hd);
        if (!ref $tl->[0]) {
            oh_set($rules, $hd, [ "$hd" ]);
        } else {
            oh_set($rules, $hd, $tl);
        }
    }

    my $parse_table = compute_parse_table(\@nullable, $rules);
    gen_c_structs($arch, $parse_table, \@terminals, $maps);
}

sub main {
    print $header_common;
    &MDS::forCores(\@ARGV, \@Cores, \&gen_header);
    print "#endif /* __H_LVX_PARSER__ */\n";
}

main();
# vim: set ts=4 sw=4 et:
