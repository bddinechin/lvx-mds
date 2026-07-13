# Machine Description System (MDS)
#
# Copyright (C) 2026 Liesme Tech
#
# Benoit Dupont de Dinechin.
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

    } elsif ($operator eq 'UNDEF' || $operator eq 'METHOD' || $operator eq 'ACCESS') {
        # An operand's encoded value: bounded by whatever coercion wraps it.
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

    return _box($lo, $hi, $operator, $trunc);
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
    unless (_nonneg($l1, $h1)) {
        # SHR generates Int256_shru, a *logical* shift on the container.  On a
        # negative value that is (x mod 2^BOX) >> n, not a function of x alone --
        # the one place the unbounded semantics leaks the box.  The ISA relies on
        # this: `sraw` is (SHR (SX.32 x) n), whose low 32 bits come out right only
        # because the sign extension runs all the way up the container and the
        # store truncates back.  Correct, but box-dependent.  See DOC/Behavior.md
        # section 3.  The result is whatever a logical shift of BOX bits gives.
        _report('shr-negative',
          "SHR on an operand not provably non-negative: Int256_shru shifts in the"
          . " sign bits of the ${BOX}-bit container, so the result depends on it");
        return _unsigned($BOX - $l2);
    }
    # brsft, not bdiv.  BitString.pm has `use bignum`, which globally sets
    # Math::BigInt->upgrade('Math::BigFloat') -- so bdiv upgrades to a float and
    # rounds to div_scale (40) significant digits, and (2^256-1) >> 0 comes back as
    # 2^256 and change.  Every other operation here is exact and stays in BigInt;
    # division is the only one that can go inexact, so it is the only one to avoid.
    # The operand is non-negative on this path, so a bit shift is the floor divide.
    return (defined $l1 ? $l1->copy()->brsft($h2) : undef,
            defined $h1 ? $h1->copy()->brsft($l2) : undef);
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
    _cmd($tree, { });
    return @Diags;
}

1;
# vim: set ts=4 sw=4 et:
