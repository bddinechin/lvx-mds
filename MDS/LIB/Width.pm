# Machine Description System (MDS)
#
# Copyright (C) 2026 Liesme Tech.
#
# Benoît Dupont de Dinechin (benoit.dinechin@gmail.com).
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

#
# Static width checking for Behavior trees.  See DOC/Behavior.md.
#
# Behavior's value domain is the unbounded mathematical integers; the
# implementation (Behavior::CodeGen) is a fixed 256-bit signed container,
# Int256_.  "256 bits suffice" is therefore a claim about every operator in
# the description, and this is the pass that checks it.
#
# The analysis is an abstract interpretation over integer intervals, held in
# Math::BigInt because the whole point is to reason about values wider than a
# machine word.  An interval bound of undef means unbounded on that side.
# Intervals rather than a bit-width lattice: they answer the accumulator
# question that motivated the pass ("does an exact dot product fit in the
# box?"), and they get the sign cases right without the off-by-one traps that
# come with power-of-two bounds -- (-2^31)*(-2^31) = 2^62 needs 64 signed bits,
# not 63, and a width lattice has to remember that.
#
# The rules below are conservative: where an operator's result cannot be bounded
# soundly, the interval widens to unbounded rather than guessing.  Unboundedness
# is not by itself reported, because the coercions (SX/ZX/SAT/SATU/F2I/I2F, and
# APPLY with a declared width) re-bound their operand, so it does not propagate
# far.  It is reported only where it is a genuine hole in the description: an
# APPLY with no declared result width, a READ of a variable with no reaching
# WRITE, and a shift by an unbounded amount.
#
# What is deliberately NOT checked: truncation into a narrower container.  I2F.64
# of a 65-bit sum is how addw is *defined* -- wraparound at the destination width
# is the architecture, not a bug -- so flagging it would be pure noise.
#

package Width;
use warnings;
use strict;

use Carp qw(confess);
use Math::BigInt;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(check text);

#
# The implementation container: BOX bits, holding a two's-complement pattern.
#
# Two distinct properties have to hold of it, and conflating them is a mistake --
# it is the one this pass made first, and it produced 22 false alarms on lo/so/
# copyo/acswapq:
#
#   representable  The BOX bits are all there, so the mathematical value can be
#                  recovered.  Values are identified modulo 2^BOX, so this needs
#                  the interval to span fewer than 2^BOX values AND to sit inside
#                  [-2^(BOX-1), 2^BOX - 1] -- the union of the signed and the
#                  unsigned readings of the same bits.  A full-width unsigned
#                  datum (F2I.256 of a 256-bit LOAD, which is how `lo` and `copyo`
#                  move an octuple) is representable: nothing is lost, it is just
#                  not a signed number.  Violating this is truncation, and is an
#                  error -- the generated C does not implement the description.
#
#   signed         The value can additionally be *read* as signed, which the
#                  operators that inspect the sign require (Int256_cmp orders
#                  sign-extended values; Int256_div, Int256_sx, Int256_cls, abs,
#                  neg all read the top bit).  A value above 2^(BOX-1)-1 fed to
#                  one of those is misinterpreted, not truncated.  Also an error,
#                  but a different one, and only at the operators that care.
#
our $BOX = 256;

our @Diags;
our $Context;

#
# When set, each Integer node's interval is stamped onto its Abstract -- the
# attribute hash the grammar already attaches to every Integer, which Pretty can
# emit as "(*lo:0,hi:255*)" and the parser reads straight back into the same slot.
# That is what carries the abstract values across a process boundary: the analysis
# runs here, in MDD/MDE, but CodeGen runs later in BE/LAO, which re-parses the tree
# from Opcode.table.  Without this the intervals would have to be recomputed by
# every back-end that wants them.
#
# The interval is stored as a decimal string: a Math::BigInt is a blessed ref, and
# Pretty only emits scalars (rightly -- a ref cannot be spelled in the syntax).
#
# Annotation JOINS rather than overwrites.  A node can be visited more than once --
# the FOR fixpoint re-walks its body, and Expand shares the METHOD/CONST leaves of
# its replace table across every site that uses them -- so the annotation has to be
# sound for all the contexts a node is reached in, not just the last.  In practice
# the two agree: those leaves are context-independent, and the fixpoint's last visit
# is its widest.
#
our $Annotate = 0;

# Which nodes this check() has already stamped.  Needed because an unbounded side
# is spelled by *deleting* the key, so the hash alone cannot tell "never visited"
# from "visited, and unbounded" -- and joining a bounded value onto the latter
# would narrow it, which is exactly the unsound direction.  Reset per check().
my %Annotated;

sub _annotate {
    my ($this, $lo, $hi) = @_;
    return unless $Annotate;
    # Not CONST: its interval is [v, v], which the consumer can read off the node,
    # and it is the commonest leaf in the tree -- annotating it is pure bloat.  It
    # would not survive a round trip anyway: sub CONST builds a fresh attribute hash
    # and discards the parsed one.
    return if $this->[0] eq 'CONST';
    my $attributes = $this->[-1];
    return unless ref $attributes eq 'HASH';
    if ($Annotated{"$this"}++) {
        ($lo, $hi) = _join($lo, $hi,
          (defined $attributes->{lo} ? _big($attributes->{lo}) : undef),
          (defined $attributes->{hi} ? _big($attributes->{hi}) : undef));
    }
    defined $lo ? ($attributes->{lo} = "$lo") : delete $attributes->{lo};
    defined $hi ? ($attributes->{hi} = "$hi") : delete $attributes->{hi};
}

#
# Memoized powers of two.  Everything here is a Math::BigInt.
#
my @Pow2;
sub _pow2 {
    my ($n) = @_;
    confess "negative power of two" if $n < 0;
    $Pow2[$n] = Math::BigInt->new(2)->bpow($n) unless defined $Pow2[$n];
    return $Pow2[$n]->copy();
}

sub _big { return Math::BigInt->new($_[0]); }

sub _report {
    my ($kind, $message) = @_;
    push @Diags, { kind=>$kind, context=>$Context, message=>$message };
}

#
# Render one diagnostic.  Not "$context: $kind: $message" joined by the caller,
# because an instruction ID is itself full of colons (Instruction-lvx-ALU:ADDW):
# the kind has to travel as its own field, not be parsed back out of a string.
#
sub text {
    my ($diagnostic) = @_;
    return "$diagnostic->{context}: $diagnostic->{kind}: $diagnostic->{message}";
}

#
# Interval helpers.  An interval is the pair ($lo, $hi); undef on either side
# means unbounded there.  _lo/_hi combine bounds so that unbounded is absorbing,
# which is the conservative direction for every rule below.
#
sub _lo {			# min, with undef = -infinity
    my $min;
    foreach my $v (@_) {
        return undef unless defined $v;
        $min = $v if !defined $min || $v < $min;
    }
    return $min;
}

sub _hi {			# max, with undef = +infinity
    my $max;
    foreach my $v (@_) {
        return undef unless defined $v;
        $max = $v if !defined $max || $v > $max;
    }
    return $max;
}

sub _join {			# union of two intervals
    my ($lo1, $hi1, $lo2, $hi2) = @_;
    my $lo = (defined $lo1 && defined $lo2) ? ($lo1 < $lo2 ? $lo1 : $lo2) : undef;
    my $hi = (defined $hi1 && defined $hi2) ? ($hi1 > $hi2 ? $hi1 : $hi2) : undef;
    return ($lo, $hi);
}

sub _signed {			# the interval of a signed $width-bit value
    my ($width) = @_;
    return (undef, undef) unless $width && $width > 0;
    return (-_pow2($width - 1), _pow2($width - 1) - 1);
}

sub _unsigned {			# the interval of an unsigned $width-bit value
    my ($width) = @_;
    return (undef, undef) unless $width && $width > 0;
    return (_big(0), _pow2($width) - 1);
}

sub _nonneg {			# is the interval provably >= 0?
    my ($lo, $hi) = @_;
    return defined $lo && $lo >= 0;
}

sub _swidth {			# minimal signed width holding the interval, undef past the box
    my ($lo, $hi) = @_;
    return undef unless defined $lo && defined $hi;
    my $width = 1;
    while ($width <= $BOX + 1) {
        return $width if $lo >= -_pow2($width - 1) && $hi <= _pow2($width - 1) - 1;
        $width++;
    }
    return undef;
}

#
# The representability check, applied to every Integer node as it is evaluated.
# This is the one that answers "is 256 bits enough".
#
# $trunc is the truncation context: the width this node's value is about to be cut
# down to, or undef if nothing cuts it.  An overflow that is then truncated to no
# more than BOX bits is harmless, and must not be reported -- the ring operations
# (+ - * << & | ^ ~) all commute with truncation, exactly as C's unsigned
# arithmetic does, so the low w bits of the true result and of the truncated one
# agree.  ZX.256(SHL(x, n)) is therefore *exactly* what Int256_shl computes, even
# though the mathematical x << n needs 504 bits; the description is right and the
# generated C implements it.  Only _trunc() (below) sets this, and only the ring
# operations pass it down -- SHR, DIV, comparisons and the counting operators all
# read the value rather than its low bits, so an overflow that reaches one of them
# is real and is reported.
#
sub _box {
    my ($lo, $hi, $what, $trunc) = @_;
    return ($lo, $hi) unless defined $lo && defined $hi;
    if ($lo < -_pow2($BOX - 1) || $hi > _pow2($BOX) - 1 || $hi - $lo >= _pow2($BOX)) {
        unless (defined $trunc && $trunc <= $BOX) {
            my $width = _swidth($lo, $hi);
            _report('box', "$what does not fit the $BOX-bit container"
              . ' (' . (defined $width ? "$width signed bits" : "over $BOX bits")
              . "), so Int256_ truncates it: [$lo, $hi]");
        }
        # Keep the intervals of a truncated computation from running away: nothing
        # past a couple of container widths tells us anything the coercion above
        # will not overwrite anyway.
        return (undef, undef) if $lo < -_pow2(2 * $BOX) || $hi > _pow2(2 * $BOX);
    }
    return ($lo, $hi);
}

#
# The signedness check, applied only where an operator reads the sign bit.
#
sub _needsigned {
    my ($lo, $hi, $what) = @_;
    return unless defined $lo && defined $hi;
    my ($min, $max) = _signed($BOX);
    return unless $lo < $min || $hi > $max;
    _report('signed', "$what reads the sign of a value outside the signed"
      . " $BOX-bit range, so Int256_ misreads it: [$lo, $hi]");
}

#
# The value of a Section index, and the bounds check the code generator used to
# carry (commented out in codegen_read/codegen_write): a section w[i] reaches bit
# w*(i+1), which must stay inside the container.
#
sub _section {
    my ($section, $env, $what) = @_;
    return (0, undef) unless ref $section eq 'ARRAY' && $section->[0] eq 'SECTION';
    my $width = $section->[1];
    my $index = $section->[2];
    my ($lo, $hi);
    if (ref $index eq 'ARRAY') {
        ($lo, $hi) = _int($index, $env);
    } else {
        $lo = $hi = _big($index || 0);
    }
    if (!defined $hi) {
        _report('section', "$what: index of ${width}[..] cannot be bounded");
    } elsif ($width * ($hi + 1) > $BOX) {
        _report('section', "$what: ${width}[$hi] reaches bit "
          . ($width * ($hi + 1)) . ", past the $BOX-bit container");
    }
    return ($width, $hi);
}

#
# The width in bits of a Location: extent cells of the named Storage.
#
sub _location {
    my ($location, $env, $what) = @_;
    return undef unless ref $location eq 'ARRAY';
    my ($storage, $address, $extent) = @{$location}[1, 2, 3];
    _int($address, $env) if ref $address eq 'ARRAY';
    my $entry = &Behavior::Storage($storage);
    my $width = (ref $entry eq 'HASH') ? $entry->{WIDTH} : undef;
    my ($lo, $hi) = _int($extent, $env);
    return undef unless defined $width && defined $lo && defined $hi && $lo == $hi;
    return $width * $lo;
}

#
# The width in bits of a BitField.  Only LOAD and I2F produce one.
#
sub _field {
    my ($this, $env) = @_;
    return undef unless ref $this eq 'ARRAY';
    my $operator = $this->[0];
    if ($operator eq 'LOAD') {
        return _location($this->[2], $env, 'LOAD');
    } elsif ($operator eq 'I2F') {
        _int($this->[2], $env, $this->[1]);	# I2F truncates to its width by design
        return $this->[1];
    }
    _report('internal', "unexpected BitField operator $operator");
    return undef;
}

#
# The interval of an Integer node.
#
sub _int {
    my ($this, $env, $trunc) = @_;
    confess "not a node" unless ref $this eq 'ARRAY';
    my $operator = $this->[0];
    my ($lo, $hi) = (undef, undef);

    if ($operator eq 'CONST') {
        my $value = &Behavior::constant($this);
        ($lo, $hi) = defined $value ? (_big($value), _big($value)) : (undef, undef);

    } elsif ($operator eq 'METHOD') {
        # An operand's encoded value.  MDE stamps a bound on the proxy's Symbol when
        # it can (a register operand's value is an index into its register file); an
        # Immediate or Modifier gets none, but its Access read wraps the METHOD in an
        # SX/ZX of the field's width, so the coercion bounds it anyway.
        my $symbol = &Behavior::Symbol($this->[1]);
        if (ref $symbol eq 'HASH' && defined $symbol->{LO} && defined $symbol->{HI}) {
            ($lo, $hi) = (_big($symbol->{LO}), _big($symbol->{HI}));
        }

    } elsif ($operator eq 'UNDEF' || $operator eq 'ACCESS') {
        ($lo, $hi) = (undef, undef);

    } elsif ($operator eq 'READ') {
        my ($section, $name) = @{$this}[1, 2];
        if (ref $section eq 'ARRAY') {
            my ($width) = _section($section, $env, "READ $name");
            ($lo, $hi) = _unsigned($width);	# a section read is an unsigned lane
        } elsif (exists $env->{$name}) {
            ($lo, $hi) = @{$env->{$name}}{qw(lo hi)};
            _report('read-partial', "READ $name is not written on every path")
              if $env->{$name}{partial};
        } else {
            _report('read-unknown', "READ $name has no reaching WRITE");
        }

    } elsif ($operator eq 'INDEX') {
        my $name = $this->[1];
        if (exists $env->{$name}) {
            ($lo, $hi) = @{$env->{$name}}{qw(lo hi)};
        } else {
            _report('read-unknown', "INDEX $name is not a loop variable in scope");
        }

    } elsif ($operator eq 'APPLY') {
        my ($width, $name) = @{$this}[1, 2];
        foreach my $argument (@{$this}[3 .. $#{$this} - 1]) {
            _value($argument, $env);
        }
        if ($width) {
            # A helper's declared width is the width of the bit pattern it returns,
            # and the caller decides how to read it: lwz is ZX.32 of MEM_load and
            # lws is SX.32 of the very same APPLY.32.  So it is unsigned here, like
            # F2I -- an octuple load is APPLY.256, and [0, 2^256-1] is exactly what
            # the container holds.
            ($lo, $hi) = _unsigned($width);
        } else {
            _report('apply-nowidth',
              "APPLY.$name declares no result width, so its value cannot be bounded");
        }

    } elsif ($operator eq 'F2I') {
        my ($width, $field) = @{$this}[1, 2];
        my $bits = _field($field, $env);
        if (defined $bits && $bits != $width) {
            _report('extent', "F2I.$width reads a ${bits}-bit BitField");
        }
        ($lo, $hi) = _unsigned($width);		# codegen: Int256_zx

    } elsif ($operator eq 'SX') {
        # SX reinterprets bit width-1 as the sign; it does not read the container's
        # own sign, so a wide unsigned value is not misread here -- only truncated,
        # which is what SX is for.  Hence it truncates its operand.
        _int($this->[2], $env, _trunc($this->[1], $trunc));
        ($lo, $hi) = _signed($this->[1]);

    } elsif ($operator eq 'ZX') {
        _int($this->[2], $env, _trunc($this->[1], $trunc));
        ($lo, $hi) = _unsigned($this->[1]);

    } elsif ($operator eq 'SAT') {
        # SAT clamps against the signed width-bit range, so it does compare the
        # whole value: it reads the container's sign and does NOT truncate.
        _needsigned(_int($this->[2], $env), $operator);
        ($lo, $hi) = _signed($this->[1]);

    } elsif ($operator eq 'SATU' || $operator eq 'SWAP') {
        _int($this->[2], $env);
        ($lo, $hi) = _unsigned($this->[1]);

    } elsif ($operator =~ /^(CLZ|CLS|CTZ|CBS)$/) {
        my ($l, $h) = _int($this->[2], $env);
        _needsigned($l, $h, $operator) if $operator eq 'CLS';	# counts sign bits
        ($lo, $hi) = (_big(0), _big($this->[1]));	# a bit count, at most the width

    } elsif ($operator eq 'ROR' || $operator eq 'ROL') {
        _int($this->[2], $env);
        _int($this->[3], $env);
        ($lo, $hi) = _unsigned($this->[1]);

    } elsif ($operator eq 'B2I') {
        _value($this->[1], $env);
        ($lo, $hi) = (_big(0), _big(1));

    } elsif ($operator eq 'SELECT') {
        _value($this->[1], $env);		# the condition is not truncated
        my ($lo1, $hi1) = _int($this->[2], $env, $trunc);
        my ($lo2, $hi2) = _int($this->[3], $env, $trunc);
        ($lo, $hi) = _join($lo1, $hi1, $lo2, $hi2);

    } elsif ($operator eq 'NEG') {
        my ($l, $h) = _int($this->[1], $env, $trunc);
        _needsigned($l, $h, $operator) unless defined $trunc;
        ($lo, $hi) = (defined $h ? -$h : undef, defined $l ? -$l : undef);

    } elsif ($operator eq 'NOT') {			# two's complement: ~x = -x-1
        my ($l, $h) = _int($this->[1], $env, $trunc);
        ($lo, $hi) = (defined $h ? -$h - 1 : undef, defined $l ? -$l - 1 : undef);

    } elsif ($operator eq 'ABS') {
        my ($l, $h) = _int($this->[1], $env);
        _needsigned($l, $h, $operator);
        if (defined $l && defined $h) {
            my ($al, $ah) = (abs($l), abs($h));
            $lo = ($l <= 0 && $h >= 0) ? _big(0) : _lo($al, $ah);
            $hi = _hi($al, $ah);
        }

    } else {
        ($lo, $hi) = _binary($this, $env, $trunc);
    }

    ($lo, $hi) = _box($lo, $hi, $operator, $trunc);
    _annotate($this, $lo, $hi);
    return ($lo, $hi);
}

#
# Narrow a truncation context to $width.  A coercion to $width discards everything
# above bit $width-1, so its operand is truncated to $width regardless of whatever
# wider truncation was already in force.
#
sub _trunc {
    my ($width, $trunc) = @_;
    return $trunc unless $width;
    return (defined $trunc && $trunc < $width) ? $trunc : $width;
}

#
# The binary arithmetic and bitwise operators.
#
my %Ring = map { $_ => 1 } qw(ADD SUB MUL AND IOR XOR);

sub _binary {
    my ($this, $env, $trunc) = @_;
    my $operator = $this->[0];

    # A ring operation commutes with truncation, so its operands inherit the
    # context.  SHL does too, but only in its value -- the shift amount has to be
    # exact.  Everything else (SHR, DIV, REM, MOD, MIN, MAX) reads the value rather
    # than its low bits, so an overflow reaching it is real: no context passes down.
    my $inner = $Ring{$operator} ? $trunc : undef;
    my ($l1, $h1) = _int($this->[1], $env, $operator eq 'SHL' ? $trunc : $inner);
    my ($l2, $h2) = _int($this->[2], $env, $inner);

    if ($operator eq 'ADD') {
        return (_add($l1, $l2), _add($h1, $h2));

    } elsif ($operator eq 'SUB') {
        return (_add($l1, _neg($h2)), _add($h1, _neg($l2)));

    } elsif ($operator eq 'MUL') {
        return _products($l1, $h1, $l2, $h2);

    } elsif ($operator eq 'MIN' || $operator eq 'MAX') {
        _needsigned($l1, $h1, $operator);		# Int256_cmp, a signed compare
        _needsigned($l2, $h2, $operator);
        return (_lo($l1, $l2), (defined $h1 && defined $h2)
          ? ($h1 < $h2 ? $h1 : $h2) : _hi($h1, $h2)) if $operator eq 'MIN';
        return ((defined $l1 && defined $l2)
          ? ($l1 > $l2 ? $l1 : $l2) : _lo($l1, $l2), _hi($h1, $h2));

    } elsif ($operator eq 'DIV' || $operator eq 'REM') {
        # Neither ever exceeds the magnitude of its left operand: |a/b| <= |a| and
        # |a%b| <= |a| for every b, including b = -1 (where a/-1 = -a).
        _needsigned($l1, $h1, $operator);
        _needsigned($l2, $h2, $operator);
        my $magnitude = _magnitude($l1, $h1);
        return defined $magnitude ? (-$magnitude, $magnitude) : (undef, undef);

    } elsif ($operator eq 'MOD') {
        # |a mod b| < |b|, and it is NOT bounded by |a| (-1 mod 5 = 4).
        _needsigned($l1, $h1, $operator);
        _needsigned($l2, $h2, $operator);
        my $magnitude = _magnitude($l2, $h2);
        return defined $magnitude ? (-$magnitude, $magnitude) : (undef, undef);

    } elsif ($operator eq 'SHL') {
        return _shl($l1, $h1, $l2, $h2, $trunc);

    } elsif ($operator eq 'SHR') {
        return _shr($l1, $h1, $l2, $h2);

    } elsif ($operator =~ /^(AND|IOR|XOR)$/) {
        return _bitwise($operator, $l1, $h1, $l2, $h2);
    }

    _report('internal', "unknown Integer operator $operator");
    return (undef, undef);
}

sub _add { my ($a, $b) = @_; return (defined $a && defined $b) ? $a + $b : undef; }
sub _neg { my ($a) = @_; return defined $a ? -$a : undef; }

sub _magnitude {		# max |v| over the interval
    my ($lo, $hi) = @_;
    return undef unless defined $lo && defined $hi;
    return _hi(abs($lo), abs($hi));
}

sub _products {
    my ($l1, $h1, $l2, $h2) = @_;
    return (undef, undef)
      unless defined $l1 && defined $h1 && defined $l2 && defined $h2;
    my @products = ($l1 * $l2, $l1 * $h2, $h1 * $l2, $h1 * $h2);
    return (_lo(@products), _hi(@products));
}

sub _shl {
    my ($l1, $h1, $l2, $h2, $trunc) = @_;
    if (!defined $l2 || $l2 < 0) {
        _report('shift', 'SHL by an amount that may be negative');
        return (undef, undef);
    }
    if (!defined $h2) {
        _report('shift', 'SHL by an unbounded amount');
        return (undef, undef);
    }
    if ($h2 > $BOX) {
        # Never evaluate 2^h2 for an h2 that is merely *bounded* -- a shift by a
        # 64-bit register is bounded by 2^64-1, and _pow2 of that eats the machine.
        # Anything shifted that far leaves the container; under a truncation that is
        # fine (the bits were going to be discarded), otherwise it is an overflow.
        _report('box', "SHL by up to $h2 leaves the $BOX-bit container")
          unless defined $trunc && $trunc <= $BOX;
        return (undef, undef);
    }
    ($l2, $h2) = ($l2->numify(), $h2->numify());
    # Shifting left is monotone in the amount, in the direction of the operand's
    # sign: the extreme negative comes from the largest shift, the extreme
    # positive too, but a negative bound shifted least is the largest it gets.
    my $lo = defined $l1 ? ($l1 >= 0 ? $l1 * _pow2($l2) : $l1 * _pow2($h2)) : undef;
    my $hi = defined $h1 ? ($h1 >= 0 ? $h1 * _pow2($h2) : $h1 * _pow2($l2)) : undef;
    return ($lo, $hi);
}

# floor($x / 2**$n).  Integer even under the bignum float-upgrade that BitString
# installs process-wide: `brsft` (like bdiv) upgrades to a Math::BigFloat and
# rounds on an inexact shift -- (2^32-1) >> 1 comes back 2147483647.5 -- while
# `bmod` outright dies on a negative operand under that upgrade.  So take the low
# bits with `band` (bitwise, always exact) and only ever brsft an exact multiple
# of 2**n, working on magnitudes so the arithmetic stays non-negative.  floor
# rounds toward -inf, so a negative is the negated ceiling of its magnitude.
sub _floor_shr {
    my ($x, $n) = @_;
    return $x->copy() unless $n;
    my $mask = _pow2($n)->bsub(1);			# 2**n - 1
    if ($x >= 0) {
        return $x->copy()->bsub($x->copy()->band($mask))->brsft($n);
    }
    my $m = $x->copy()->bneg();				# |x| > 0
    my $t = $m->badd($mask);				# ceil(|x|/2^n) = (|x|+2^n-1) >> n
    return $t->copy()->bsub($t->copy()->band($mask))->brsft($n)->bneg();
}

sub _shr {
    my ($l1, $h1, $l2, $h2) = @_;
    if (!defined $l2 || $l2 < 0) {
        _report('shift', 'SHR by an amount that may be negative');
        return (undef, undef);
    }
    if (!defined $h2) {
        _report('shift', 'SHR by an unbounded amount');
        return (undef, undef);
    }
    ($l2, $h2) = ($l2 > $BOX ? $BOX : $l2->numify(),
                  $h2 > $BOX ? $BOX : $h2->numify());	# shifting further changes nothing
    # SHR is an ARITHMETIC shift: floor(x / 2^n), a total function of the value and
    # independent of the container.  It is emitted as Int256_shr for a signed
    # operand and Int256_shru for a non-negative one (see Behavior.pa); the two
    # agree on the demanded bits, and on a non-negative operand arithmetic *is*
    # logical.  So the interval is exact for every operand -- negatives included --
    # and no longer leaks the box, which retires the old `shr-negative` diagnostic.
    # See DOC/Behavior.md section 3 and DOC/SHR-split.md.  floor(x/2^n) is monotone
    # non-decreasing in x and monotone in n, so the extremes are at the corners:
    # the minimum uses l1, the maximum uses h1, each at whichever shift amount is
    # extremal for that sign.
    my ($lo, $hi);
    if (defined $l1) {
        my ($a, $b) = (_floor_shr($l1, $l2), _floor_shr($l1, $h2));
        $lo = $a < $b ? $a : $b;
    }
    if (defined $h1) {
        my ($a, $b) = (_floor_shr($h1, $l2), _floor_shr($h1, $h2));
        $hi = $a > $b ? $a : $b;
    }
    return ($lo, $hi);
}

sub _bitwise {
    my ($operator, $l1, $h1, $l2, $h2) = @_;
    my $nonneg1 = _nonneg($l1, $h1);
    my $nonneg2 = _nonneg($l2, $h2);

    if ($operator eq 'AND') {
        # For x >= 0, the bits of (x & y) are a subset of the bits of x, whatever
        # y is -- so the result is in [0, x] even when y is negative.
        return (_big(0), $h1) if $nonneg1 && (!$nonneg2 || $h1 <= $h2);
        return (_big(0), $h2) if $nonneg2;
    } elsif ($nonneg1 && $nonneg2) {			# IOR, XOR
        my $bits = _hi(_bits($h1), _bits($h2));
        return _unsigned($bits) if defined $bits && $bits > 0;
        return (_big(0), _big(0));
    }

    # Something may be negative: fall back to the widest signed operand.  In two's
    # complement a bitwise operator never needs more bits than its widest operand,
    # because the sign extension is idempotent.
    my $w1 = _swidth($l1, $h1);
    my $w2 = _swidth($l2, $h2);
    return (undef, undef) unless defined $w1 && defined $w2;
    return _signed(_hi($w1, $w2));
}

sub _bits {			# number of bits of a non-negative value
    my ($value) = @_;
    return undef unless defined $value && $value >= 0;
    return length($value->copy()->as_bin()) - 2;	# as_bin() is "0b..."
}

#
# Evaluate a node of any type, for the side effect of its own checks.  Booleans
# carry no value, but their Integer children still have to be walked.
#
my %Boolean = map { $_ => 1 } qw(
  TRUE FALSE TEST NE EQ GT LE GE LT ANDL IORL XORL NOTL I2B PROBE
  );

sub _value {
    my ($this, $env) = @_;
    return unless ref $this eq 'ARRAY';
    my $operator = $this->[0];
    if ($Boolean{$operator}) {
        _boolean($this, $env);
    } else {
        _int($this, $env);
    }
}

sub _boolean {
    my ($this, $env) = @_;
    my $operator = $this->[0];
    if ($operator eq 'PROBE') {
        _location($this->[2], $env, 'PROBE');
    } elsif ($operator =~ /^(GT|LE|GE|LT)$/) {	# ordered: Int256_cmp is signed
        _needsigned(_int($this->[1], $env), $operator);
        _needsigned(_int($this->[2], $env), $operator);
    } else {
        foreach my $child (@{$this}) {
            _value($child, $env) if ref $child eq 'ARRAY';
        }
    }
}

#
# Commands.  The environment maps a variable to its interval; sequences thread it,
# IF joins the two branches, FOR iterates its body to a fixpoint.
#
sub _cmd {
    my ($this, $env) = @_;
    return unless ref $this eq 'ARRAY';
    my $operator = $this->[0];

    if ($operator eq 'SEQ') {
        foreach my $command (@{$this}[1 .. $#{$this}]) {
            _cmd($command, $env);
        }

    } elsif ($operator eq 'IF') {
        _boolean($this->[1], $env);
        my $then = _clone($env);
        my $else = _clone($env);
        _cmd($this->[2], $then);
        _cmd($this->[3], $else);
        %{$env} = %{_merge($then, $else)};

    } elsif ($operator eq 'FOR') {
        _for($this, $env);

    } elsif ($operator eq 'WRITE') {
        _write($this, $env);

    } elsif ($operator eq 'STORE') {
        _store($this, $env);

    } elsif ($operator eq 'COMMIT') {
        _int($this->[3], $env);
        _int($this->[4], $env) if ref $this->[4] eq 'ARRAY';	# the mask

    } elsif ($operator eq 'EFFECT' || $operator eq 'THROW') {
        foreach my $argument (@{$this}[3 .. $#{$this}]) {
            _value($argument, $env) if ref $argument eq 'ARRAY';
        }

    } elsif ($operator =~ /^(MACRO|SKIP|CANCEL)$/) {
        # No value, no state.

    } else {
        _report('internal', "unknown Command $operator");
    }
}

sub _write {
    my ($this, $env) = @_;
    my ($section, $name, $expression) = @{$this}[1, 2, 3];
    my ($lo, $hi) = _int($expression, $env);
    if (ref $section eq 'ARRAY') {
        # A sectioned write fills lane i of a container; the lanes written so far
        # bound the container, and the rest of it keeps whatever it held.
        my ($width, $index) = _section($section, $env, "WRITE $name");
        my $bits = (defined $index) ? $width * ($index + 1) : undef;
        my $entry = $env->{$name};
        $bits = _hi($bits, $entry->{bits}) if ref $entry eq 'HASH';
        my ($clo, $chi) = _unsigned($bits);
        if (ref $entry eq 'HASH' && !defined $entry->{bits}) {
            # It held a plain value before; that value survives above the lanes.
            ($clo, $chi) = _join($clo, $chi, $entry->{lo}, $entry->{hi});
        }
        $env->{$name} = { lo=>$clo, hi=>$chi, bits=>$bits };
    } else {
        $env->{$name} = { lo=>$lo, hi=>$hi, bits=>undef };
    }
}

sub _unset {
    my ($entry) = @_;
    return { lo=>undef, hi=>undef, bits=>undef, partial=>$entry->{partial} };
}

sub _store {
    my ($this, $env) = @_;
    my ($location, $field) = @{$this}[2, 3];
    my $into = _location($location, $env, 'STORE');
    my $bits = _field($field, $env);
    if (defined $into && defined $bits && $into != $bits) {
        _report('extent', "STORE of a ${bits}-bit BitField into a ${into}-bit location");
    }
    _int($this->[4], $env) if ref $this->[4] eq 'ARRAY';		# the mask
}

sub _for {
    my ($this, $env) = @_;
    my ($name, $range) = @{$this}[1, 2];
    my @commands = @{$this}[3 .. $#{$this}];
    my ($begin, $end, $step) = @{$range}[1, 2, 3];
    my $last = $end - $step;			# RANGE's end is exclusive
    my ($lo, $hi) = ($begin < $last) ? ($begin, $last) : ($last, $begin);

    # The body sees the induction variable over its whole range at once, which is
    # sound for every rule here: none of them is sensitive to a *particular*
    # iteration (a section index is checked against its upper bound).  $state is
    # the environment at the top of an iteration; iterate until it settles, so a
    # variable carried across iterations reaches its fixpoint.  It only ever
    # widens, so this terminates; give up to unbounded if it somehow does not.
    #
    # The environment on exit is the *body's*, not a join with the environment on
    # entry: RANGE is never empty, so the body has run at least once and anything
    # it writes unconditionally is defined afterwards.  Joining with the entry
    # environment instead would mark every packed-SIMD result1 -- written only
    # inside the FOR -- as never written.
    my $state = _clone($env);
    my $body = $state;
    my $rounds = 0;
    while (1) {
        $body = _clone($state);
        $body->{$name} = { lo=>_big($lo), hi=>_big($hi), bits=>undef };
        foreach my $command (@commands) {
            _cmd($command, $body);
        }
        delete $body->{$name};
        my $next = _merge($state, $body);
        last if _same($state, $next);
        $state = $next;
        if (++$rounds > 4) {
            foreach my $variable (keys %{$body}) {
                $body->{$variable} = _unset($body->{$variable});
            }
            last;
        }
    }
    %{$env} = %{$body};
}

sub _clone {
    my ($env) = @_;
    my %clone;
    while (my ($name, $entry) = each %{$env}) {
        $clone{$name} = { %{$entry} };
    }
    return \%clone;
}

#
# Join two environments.  A variable present in only one of them keeps its
# interval -- dropping it would lose the very bound the pass exists to compute
# (product = SX.64(a) * SX.64(b) is written under a guard in every mul/madd, and
# result1 is created inside the FOR in every packed-SIMD operation) -- but it is
# marked 'partial', because on the other path it holds whatever it held before.
#
sub _merge {
    my ($one, $two) = @_;
    my %merged;
    foreach my $name (keys %{$one}, keys %{$two}) {
        next if exists $merged{$name};
        my ($a, $b) = ($one->{$name}, $two->{$name});
        if (!defined $a || !defined $b) {
            my $only = $a || $b;
            $merged{$name} = { %{$only}, partial=>1 };
        } else {
            my ($lo, $hi) = _join($a->{lo}, $a->{hi}, $b->{lo}, $b->{hi});
            $merged{$name} = { lo=>$lo, hi=>$hi, bits=>_hi($a->{bits}, $b->{bits}),
                               partial=>($a->{partial} || $b->{partial}) };
        }
    }
    return \%merged;
}

sub _same {
    my ($one, $two) = @_;
    return 0 unless keys %{$one} == keys %{$two};
    foreach my $name (keys %{$one}) {
        return 0 unless exists $two->{$name};
        my ($a, $b) = ($one->{$name}, $two->{$name});
        foreach my $key (qw(lo hi bits partial)) {
            return 0 if defined $a->{$key} != defined $b->{$key};
            return 0 if defined $a->{$key} && $a->{$key} != $b->{$key};
        }
    }
    return 1;
}

################################################################################
#
# The backward pass: demanded width.
#
# The forward intervals say how big a value CAN be.  They are not enough to type it,
# because the commonest expression in the whole ISA does not fit anything: addw's
# ADD of two 64-bit registers is [0, 2^65-2], which is no native C type -- even
# though the store keeps only its low 32 bits and a uint32_t add would do.
#
# So this computes the other half: how many of a value's low bits anyone actually
# LOOKS at.  A node whose demand is d can be computed in any d-bit type, whatever its
# interval, because the ring operations (+ - * << & | ^ ~) agree with the true result
# on their low d bits.  The type of a node is then decided by
#
#     min(bits its interval needs, bits anyone demands)
#
# and for addw that is min(65, 32) = 32.
#
# It runs backward -- over commands in reverse, and top-down within an expression --
# and it crosses variables, which the forward truncation context deliberately does
# not: %Demand maps a variable to the most bits any later READ wants of it.  A plain
# WRITE kills that demand (it overwrites the value); a WRITE under an IF does not,
# because the other path still sees the old one.
#
# A helper argument demands what the helper's Helper element declares, and the whole
# container if it declares nothing.  Assuming ⊤ for all of them -- which is what this did
# before there was such an element -- is sound, but it is not free, and the measurement
# that said it was nearly free was misread.  It counted an argument as unbounded whenever
# _swidth could not fit it, and _swidth is the minimal *signed* width, so an ordinary
# [0, 2^64-1] argument needs 65 bits and looks unbounded.  Strip that artifact and the
# genuinely wide arguments are few and specific -- the MEM_* data, get/wfxl/wfxm,
# intcomp_128 -- and the rest are plain 64-bit values.
#
# It matters most where it is least visible.  `branch_info` takes a program counter, so
# demanding all 256 bits of it boxes the branch-target ADD -- PC plus a signed offset, a
# 66-bit interval -- in every branch instruction in the ISA, while the STORE right beside
# it already writes the truncation down.  See DOC/MDD.dtd's Helper element.
#
our %Demand;

# name => [ width of each argument, in order ], from the Helper elements.  A helper that
# is not in here, or an argument the entry does not reach, demands the whole container --
# so a description that declares nothing behaves exactly as it did before.
our %Signature;

sub _dwant {			# a variable is read: it wants $bits of its low end
    my ($name, $bits) = @_;
    $bits = $BOX if !defined $bits || $bits > $BOX;
    $Demand{$name} = $bits
      if !defined $Demand{$name} || $bits > $Demand{$name};
}

sub _dbound {			# a node's interval bound, as a small integer, or undef
    my ($this, $which) = @_;
    return undef unless ref $this eq 'ARRAY';
    my $attributes = $this->[-1];
    return undef unless ref $attributes eq 'HASH' && defined $attributes->{$which};
    my $value = _big($attributes->{$which});
    return $BOX if $value > $BOX;		# a shift that far shifts everything out
    return $value < 0 ? 0 : $value->numify();
}

sub _dmark {			# record the demand on a node, keeping the largest
    my ($this, $d) = @_;
    return unless $Annotate;
    # A demand of BOX is no demand at all -- it says every bit is looked at, which is
    # the default -- and a CONST's demand tells nobody anything, since its value is
    # right there.  Emitting either would be most of the nodes in the tree for nothing.
    return if $d >= $BOX || $this->[0] eq 'CONST';
    my $attributes = $this->[-1];
    return unless ref $attributes eq 'HASH';
    $attributes->{dm} = $d
      if !defined $attributes->{dm} || $d > $attributes->{dm};
}

sub _dexpr {
    my ($this, $d) = @_;
    return unless ref $this eq 'ARRAY';
    my $operator = $this->[0];
    return if $operator eq 'SECTION';		# handled by its READ/WRITE
    $d = $BOX if !defined $d || $d > $BOX;
    $d = 0 if $d < 0;
    _dmark($this, $d);

    if ($operator eq 'READ') {
        my ($section, $name) = @{$this}[1, 2];
        if (ref $section eq 'ARRAY') {
            # Lane i of width w: the variable is wanted up to bit w*(i+1).
            my $width = $section->[1];
            my $index = ref $section->[2] eq 'ARRAY'
              ? _dbound($section->[2], 'hi') : $section->[2];
            _dexpr($section->[2], $BOX) if ref $section->[2] eq 'ARRAY';
            _dwant($name, defined $index ? $width * ($index + 1) : $BOX);
        } else {
            _dwant($name, $d);
        }

    } elsif ($operator eq 'ZX' || $operator eq 'SX') {
        # Only the low width bits of the operand survive the coercion.
        my $width = $this->[1];
        _dexpr($this->[2], $d < $width ? $d : $width);

    } elsif ($operator =~ /^(ADD|SUB|MUL|AND|IOR|XOR)$/) {
        _dexpr($this->[1], $d);
        _dexpr($this->[2], $d);

    } elsif ($operator eq 'NOT' || $operator eq 'NEG') {
        _dexpr($this->[1], $d);

    } elsif ($operator eq 'SHL') {
        # (x << n) mod 2^d depends on x mod 2^(d - n): the smallest shift needs the
        # most bits of x.
        my $shift = _dbound($this->[2], 'lo');
        _dexpr($this->[1], defined $shift ? $d - $shift : $d);
        _dexpr($this->[2], $BOX);

    } elsif ($operator eq 'SHR') {
        # (x >> n) mod 2^d depends on bits [n, n+d) of x: the largest shift reaches
        # highest.
        my $shift = _dbound($this->[2], 'hi');
        _dexpr($this->[1], defined $shift ? $d + $shift : $BOX);
        _dexpr($this->[2], $BOX);

    } elsif ($operator eq 'SELECT') {
        _dexpr($this->[1], $BOX);		# the condition
        _dexpr($this->[2], $d);
        _dexpr($this->[3], $d);

    } elsif ($operator eq 'F2I') {
        _dfield($this->[2]);

    } elsif ($operator =~ /^(APPLY|EFFECT|TEST|THROW)$/) {
        # A helper argument demands what the helper's signature says it does, and the
        # whole container if the helper has no signature -- which is what every helper
        # used to do, and is why the branch-target ADD of every branch instruction stayed
        # in a 256-bit box: `branch_info` takes a program counter, and until there was a
        # Helper element the description had no way to say so.  See DOC/MDD.dtd.
        my $name = $operator eq 'TEST' ? $this->[1] : $this->[2];
        my $first = $operator eq 'TEST' ? 2 : 3;
        my $widths = $Signature{$name};
        my $argument = 0;
        for (my $i = $first; $i < @{$this}; $i++) {
            my $child = $this->[$i];
            # Count the arguments the way CodeGen's signature() counts them -- only the
            # ARRAY children, so the trailing attribute hash does not shift the numbering.
            # The two have to agree on which argument is which or a declared width lands on
            # the wrong one, which is not a subtle failure but it is a silent one.
            next unless ref $child eq 'ARRAY';
            $argument++;
            my $want = (ref $widths eq 'ARRAY') ? $widths->[$argument - 1] : undef;
            # A declared width of BOX is the container, which is the same as declaring
            # nothing -- it narrows nothing and it truncates nothing.
            $want = undef if defined $want && $want >= $BOX;
            if (defined $want) {
                # A declared width narrower than the value is a TRUNCATION, and the point
                # of declaring it is to say so: `branch_info` takes a program counter, and
                # PC + a signed offset needs 66 bits while the architecture keeps 64.  It
                # is not an error -- but it is the description asserting something, so it
                # is reported rather than left to be discovered.
                my $attributes = $child->[-1];
                if (ref $attributes eq 'HASH') {
                    my $needs = _swidth($attributes->{lo}, $attributes->{hi});
                    _report('helper-truncates',
                      "$name argument $argument is declared $want bits wide, but the value"
                      . " needs " . (defined $needs ? $needs : "over $BOX")
                      . " signed bits: the low $want are what the helper is given")
                      if !defined $needs || $needs > $want + 1;
                }
            }
            _dexpr($child, defined $want ? $want : $BOX);
        }

    } else {
        # Everything else reads the whole value: SHR's amount, the comparisons,
        # DIV/REM/MOD, MIN/MAX, SAT and the bit counters.
        foreach my $child (@{$this}) {
            _dexpr($child, $BOX) if ref $child eq 'ARRAY';
        }
    }
}

sub _dfield {
    my ($this) = @_;
    return unless ref $this eq 'ARRAY';
    if ($this->[0] eq 'I2F') {
        # THE rule: a store of I2F.w wants exactly w bits of what it stores.
        _dexpr($this->[2], $this->[1]);
    } elsif ($this->[0] eq 'LOAD') {
        _dexpr($this->[2], $BOX);		# the location
    }
}

sub _dsame {
    my ($one, $two) = @_;
    return 0 unless keys %{$one} == keys %{$two};
    foreach my $name (keys %{$one}) {
        return 0 unless defined $two->{$name} && $two->{$name} == $one->{$name};
    }
    return 1;
}

sub _dcmd {
    my ($this) = @_;
    return unless ref $this eq 'ARRAY';
    my $operator = $this->[0];

    if ($operator eq 'SEQ') {
        foreach my $command (reverse @{$this}[1 .. $#{$this}]) {
            _dcmd($command);
        }

    } elsif ($operator eq 'IF') {
        my %after = %Demand;
        _dcmd($this->[2]);
        my %then = %Demand;
        %Demand = %after;
        _dcmd($this->[3]);
        foreach my $name (keys %then) {		# union of the two paths
            _dwant($name, $then{$name});
        }
        _dexpr($this->[1], $BOX);

    } elsif ($operator eq 'FOR') {
        my @commands = @{$this}[3 .. $#{$this}];
        for (my $round = 0; $round < 5; $round++) {
            my %before = %Demand;
            foreach my $command (reverse @commands) {
                _dcmd($command);
            }
            last if _dsame(\%before, \%Demand);
        }

    } elsif ($operator eq 'WRITE') {
        my ($section, $name, $expression) = @{$this}[1, 2, 3];
        if (ref $section eq 'ARRAY') {
            # A lane write leaves the rest of the variable alone, so it kills nothing.
            _dexpr($section->[2], $BOX) if ref $section->[2] eq 'ARRAY';
            _dexpr($expression, $section->[1]);
        } else {
            my $demand = $Demand{$name} || 0;
            delete $Demand{$name};		# this write overwrites the old value
            _dexpr($expression, $demand);
        }

    } elsif ($operator eq 'STORE') {
        _dfield($this->[3]);
        _dexpr($this->[2], $BOX);		# the location
        _dexpr($this->[4], $BOX) if ref $this->[4] eq 'ARRAY';

    } elsif ($operator eq 'COMMIT') {
        _dexpr($this->[3], $BOX);
        _dexpr($this->[4], $BOX) if ref $this->[4] eq 'ARRAY';

    } elsif ($operator eq 'EFFECT' || $operator eq 'THROW') {
        foreach my $argument (@{$this}[3 .. $#{$this}]) {
            _dexpr($argument, $BOX) if ref $argument eq 'ARRAY';
        }
    }
    # MACRO, SKIP, CANCEL: no value, no state.
}

#
# Check one Behavior tree.  $context names it in the diagnostics (an opcode ID).
# Returns the list of diagnostics, empty if the tree is clean.  Each is a hash
# with a 'kind' (the table in DOC/Behavior.md), a 'context' and a 'message';
# &text() renders one.
#
sub check {
    my ($tree, $context) = @_;
    local @Diags = ();
    local $Context = $context || 'Behavior';
    %Annotated = ();

    # BitString.pm has `use bignum`, which globally sets
    # Math::BigInt->upgrade('Math::BigFloat') -- so any operation that goes inexact
    # silently returns a float, rounded to div_scale (40) significant digits.  This
    # domain is the integers: (2^64-1) >> 48 has to be 65535, not
    # 65535.99999999999999644728632119949907064, which is what a right shift produced
    # before this guard (and which does not even lex when emitted into an Abstract).
    # Upgrading is never right here, so switch it off for the duration.  Doing it at
    # the boundary rather than at each division is the point: it covers the operations
    # I did not think of too.
    my $upgrade = Math::BigInt->upgrade();
    Math::BigInt->upgrade(undef);
    eval {
        _cmd($tree, { });		# forward: what a value can be
        if ($Annotate) {
            %Demand = ();
            _dcmd($tree);		# backward: how much of it anyone looks at
        }
        1;
    } or do {
        my $error = $@;
        Math::BigInt->upgrade($upgrade);
        die $error;
    };
    Math::BigInt->upgrade($upgrade);

    return @Diags;
}

1;
# vim: set ts=4 sw=4 et:
