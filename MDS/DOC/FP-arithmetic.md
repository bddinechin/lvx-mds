# Implementing LVX floating point in unbounded Behavior arithmetic

A design note written to be shared outside the MDS repo — in particular with
Orégane Desrentes, who implemented the LVX/KVX correctly-rounded FP operators in
VHDL with [FloPoCo](https://flopoco.org/). It captures a design discussion about
whether the LVX ISA *description* can express those operators — including the fused
`FD2A` / `FDMDA` — in the same exact-arithmetic-then-single-rounding style the
hardware uses, rather than delegating them to opaque C.

It assumes no knowledge of the MDS internals; the companion notes for people inside
the repo are `Behavior.md` (the value model and the width analysis) and
`FP-helpers.md` (how the IEEE flags were made part of the description). Where those
go deeper this note only summarizes, and points at the section.

> **Status.** The FP *flags* are already in the description: every FP instruction now
> writes `CS_IO/DZ/OV/UN/IN` through a shared macro, and the rounding mode is computed
> in Behavior (`floatmode`, RISC-V's `frm`, with `0x7` reading the `CS_RM` CSR). What is
> still opaque C is the *arithmetic* — `f32_add` computes its sum in a hand-written
> helper. This note is about replacing that: expressing the arithmetic itself, and the
> rounding, as Behavior integer operations. A shared rounding routine, `round_once`, is
> written and verified but not yet wired into any operator. The FD2A width question below
> is the thing to settle before wiring the fused operators.

---

## 1. The bridge to the hardware view

FloPoCo's whole model is a static one: you describe an operator over exact fixed- and
floating-point values, and the tool computes the *bit widths* — guard bits, the sticky,
the internal alignment window — that make the result correctly rounded, then emits a
datapath of exactly those widths. The correctness argument is a width argument done
ahead of time.

The Behavior approach is the same idea in software clothing, and the analogy is close
enough to be useful throughout this note:

| Hardware / FloPoCo | Behavior / MDS |
|---|---|
| exact fixed-point value on a bit-heap | an **unbounded mathematical integer** (a significand with an explicit exponent) |
| datapath of statically-computed width | one fixed **256-bit container** (`Int256_`) the generated C runs over |
| you *compute* the widths that suffice | a static **width analysis** *proves* 256 bits suffice, per operator, and **fails the build** if they do not |
| guard/round/sticky, alignment window, sticky compression | the same, written explicitly as shifts, masks and a sticky OR |
| one rounding at the end of the datapath | one call to `round_once` at the end of the expression |

So "can Behavior express these operators" is, almost exactly, the question you already
answered in VHDL: *does the exact computation fit in a bounded internal width, with the
tail summarized into a sticky?* Where your answer is a datapath width, ours is an
interval the width pass reports. The two should agree, and the most useful thing this
note asks of you is in §7: whether the FloPoCo internal widths can serve as the
reference the Behavior width proof is checked against.

## 2. The value model, in one page

Behavior is the small semantic language every LVX instruction is described in. Its
values are **unbounded integers** — there is no `uint32_t` in the semantics, only ℤ.
The operators are the ones you would expect over ℤ: `ADD SUB MUL SHL SHR AND IOR XOR
NEG MIN MAX CLZ`, the comparisons, `SELECT` (a functional mux), and bit-reinterpretation
between a register's bits and that integer (`F2I`/`I2F` are *type puns*, not IEEE
conversions).

The generated ISS C, however, runs over a fixed **256-bit** representation. That two
things are true at once — the semantics is unbounded, the code is 256-bit — is a
*claim*: that 256 bits suffice for every value any operator can produce. `Behavior.md`
describes the pass that discharges the claim. It has two halves, and both matter here:

- a **forward** interval analysis — how large a value can get (`addw` of two 64-bit
  registers is `[0, 2⁶⁵−2]`);
- a **backward** demanded-width analysis — how many of its low bits anyone downstream
  actually reads.

The demanded-width half is exactly the sticky/guard reasoning of a hardware datapath:
a value can be enormous as long as only its low *k* bits are observed, and truncation
that throws away unobserved high bits above the container is sound only if it is written
down. This is what lets an "exact intermediate" be represented without materializing all
of it — the same move FloPoCo makes when it caps an alignment shift and routes the rest
to the sticky.

The pass is not advisory. A value that genuinely needs more than 256 bits, or a
truncation that is not written down, is a **fatal** diagnostic and the build stops. So
the container width is a checked precondition, not a hope.

## 3. How one FP operation decomposes

Wiring the arithmetic into Behavior means an FP instruction becomes, entirely in the
integer operators above:

1. **unpack** each operand — sign, exponent, significand — with shifts and masks;
2. **classify** — NaN / Inf / zero / subnormal / normal, as comparisons on those fields;
3. **exact op** — for add: align the significands by the exponent difference (a shift)
   and add the integers; for multiply: an integer `MUL` of the significands (exact);
4. **round** — one call to `round_once`;
5. **repack and flag** — assemble the result bits, OR the derived flags into `CS`.

The single-rounding property is *native* here, and this is the important structural
point for the fused operators: because the significands are unbounded integers, the
alignment in step 3 loses nothing and the product is exact, so "form the exact value,
round once" is literal. There is no internal intermediate rounding to avoid — you get
the correctly-rounded result by construction, the same guarantee the hardware gives.

### `round_once`

`round_once(sign, mant, expo, p, emin, emax)` is the shared final step — the software
twin of the rounding/normalization stage at the bottom of the datapath. It is
parameterized by the format `(p, emin, emax)`, so f16 `(11,−14,15)`, f32 `(24,−126,127)`
and f64 `(53,−1022,1023)` are one routine at three instantiations. Given an exact
significand as an integer and an unbiased exponent, it:

- finds the leading significant bit with `CLZ`;
- picks the rounding position
  `lsb = MAX(lead + 1 − p, emin + 1 − p)` — see §4, this `MAX` is the entire subnormal
  story;
- extracts guard/round/sticky by shift and mask;
- chooses the increment for the active mode — all six: RNE, RTZ, RDN, RUP, RMM, and
  round-to-odd (`RM==6`);
- adds the increment, handles carry-out (renormalize), and recomputes the leading bit;
- sets the flags: **inexact** if any bit was dropped, **overflow** if the rounded
  exponent exceeds `emax` (choosing ∞ or the format max per mode and sign), **underflow**
  if the result is below the normal minimum *and* inexact.

It is written, parses, and passes the width analysis with **zero diagnostics**; the
three flags come out provably 1-bit. It owns OV/UN/IN for every operator that ends in a
rounding; each operator's prologue owns IO/DZ (the input-driven flags). It is not yet
called by anything — wiring it into `f32_add` is the pilot step.

## 4. Subnormals are the easy case here

This is worth stating plainly because it inverts the usual expectation. In a fixed-width
datapath subnormals are a genuine special case — no hidden bit, a different implicit
exponent, detect-and-normalize on input, denormalize on output. In this representation
**they nearly vanish**, for one reason: the moment an operand is unpacked into
*(sign, exact significand as an integer, true unbiased exponent)*, a subnormal and a
normal are the same object. The distinction only lives in the packed encoding.

- **Output side** — gradual underflow *is* the `MAX(lead + 1 − p, emin + 1 − p)` in
  `round_once`. When the result's leading bit sits at or above `emin`, the first term
  wins and you keep `p` bits; when it falls below `emin`, the second term pins the
  rounding point to `emin + 1 − p` and you keep fewer bits anchored at the minimum
  exponent — which is exactly a subnormal. The `UN` flag and a subnormal that rounds up
  into the smallest normal both fall out of the same code, no branch.
- **Input side** — one conditional at unpack: if the exponent field is zero there is no
  hidden bit and the exponent is `emin`, else the hidden 1 is set. A `SELECT` and a
  compare per operand. After it, the arithmetic never distinguishes the two again.

The one genuine spec choice, not something that falls out, is the **tininess
convention** (detect underflow before or after rounding). If LVX follows RISC-V — no
flush-to-zero, mandatory gradual underflow, tininess after rounding — it is fixed and is
one comparison placed accordingly. Please confirm from the hardware which convention the
operators use (§7).

## 5. The fused operator: FD2A / FDMDA

This is the operator the whole question turns on: `s = round(a·b + c·d + e)`, the
correctly-rounded fused dot-product-of-two-plus-add — `FD2A` in LVX, `FDMDA` in kv3_v2 —
from *Desrentes, Dupont de Dinechin & de Dinechin, "Exact fused dot product add
operators," ARITH 2023*, and the application family in *Hubrecht et al., "Useful
applications of correctly rounded operators of the form ab+cd+e," ARITH 2024*. For all
LVX FP operators the **dot-product depth is two**, in FP32 and FP64.

Two things have to be true for this to be reasonable in Behavior. The first is easy; the
second is the one to verify.

**It fits the paradigm — better than division or sqrt do.** `ab + cd + e` is a fixed
three-term expression: two exact products, a couple of aligned adds, one rounding. There
is **no recurrence**, so it maps straight onto Behavior's straight-line tree — two
`MUL`s, exponent arithmetic, alignment shifts, one signed add, `CLZ` to renormalize,
`round_once`. And the ARITH result — *one* rounding for the whole `ab+cd+e`, not products
rounded and then summed — is precisely "exact value, round once," which this
representation expresses natively. This is, in fact, the strongest argument for the whole
approach: the ISA's headline FP feature is exact-then-round-once, which is exactly what
unbounded integers plus `round_once` are, and exactly what an opaque per-operator helper
would obscure. Complex multiply `(ac − bd) + (ad + bc)i` then falls out, each component
an `ab ± cd`.

**The width is the real question, and it is your width.** You cannot materialize the full
exact `ab+cd+e` as one integer. In FP64 the exact accumulator spans from about bit +2046
(two near-overflow operands multiplied) down to about bit −2148 (two smallest subnormals
multiplied) — on the order of **4200 bits**. The width analysis rejects that outright,
correctly. What makes it implementable — in your VHDL and here — is that correctly
rounding a *depth-2* sum needs only a **bounded window plus a sticky**: two products
cancel meaningfully only when their exponents are within ~2p of each other, so the
meaningful aligned window is bounded by the product width plus the cancellation range
plus guard bits, and everything below folds into the sticky.

Order-of-magnitude, the internal width needed:

| | p | exact product | window ≈ 4p + guards | fits `Int256_`? |
|---|---|---|---|---|
| FP32 | 24 | 48 bits | ~96 bits | comfortably, large margin |
| FP64 | 53 | 106 bits | ~210–230 bits | **within 256, but tight** |

The FP32 case is not in doubt. The FP64 case is where I would want your number: the
exact internal precision your FloPoCo datapath uses for FP64 `FDMDA` is the authoritative
answer to "does it fit in 256 bits, and with how much headroom." The reassuring part is
that we do not have to guess — the Behavior width analysis computes the real interval on
the actual expression and fails the build if any intermediate exceeds 256. So the
container is checked, not assumed; your datapath width is the cross-check that it is the
*right* container.

**What Behavior needs for it**: exact `MUL`, `ADD`/`SUB` on significands and exponents,
clamped `SHL`/`SHR` for alignment, `AND`/compare/`IOR` for the sticky, `CLZ` for
renormalization after cancellation — all existing integer operators, no new machinery. It
touches `round_once` only through the sticky: if the FD2A body sticky-jams (sets the low
retained bit whenever a dropped bit was nonzero) before calling, `round_once`'s existing
guard/round/sticky logic captures the compressed tail and the routine needs no change.

## 6. Where the decomposition stops

Not everything reduces to inline integer arithmetic, and it is worth being exact about
the boundary:

- **Division and square root.** The rounding and flags still decompose, but the exact
  quotient or root to enough bits is a digit recurrence, and Behavior has no loop — it is
  a straight-line tree. So these keep a small integer kernel: a helper that yields
  *(quotient/root bits, sticky)*, with `round_once` finishing in Behavior; or a fully
  unrolled sequence, which is impractical. A well-defined integer helper, not an opaque
  IEEE routine — but not pure inline either.
- **Estimates and transcendentals** — `fast_rec`, `fast_rsqrt`, anything table- or
  polynomial-defined — stay helpers. They are not cleanly integer-decomposable, they
  raise no flags, and (per the current plan) are getting a new hardware implementation
  anyway.

FD2A is on the good side of this line precisely because it has no recurrence.

## 7. Cost, benefit, and the questions for you

**The architecture that makes this cheap at runtime.** Expressing FP in Behavior does
*not* mean the ISS must interpret a big rounding routine per FP op. The intended shape is
three layers:

- the exact-op + `round_once` Behavior = the **specification** (authoritative,
  self-contained, checkable);
- a tuned opaque helper (SoftFloat-style, or a call into your reference) = an
  **implementation** the ISS may substitute for speed;
- a **differential test** (`BE/LAO/TEST/`, oracle = MPFR for correct rounding, plus
  SoftFloat for the IEEE subset) = a **proof** the two agree.

An ISS then calls the fast helper behind a proven equivalence; the description stays the
source of truth. This inverts today's trust relationship — the helper stops being
asserted-correct and becomes checked-correct against the description.

**On Sail.** Wiring is *not* required for a Sail backend: the upstream RISC-V Sail model
itself keeps F/D/Q as external SoftFloat calls, and our tuple-returning helpers translate
to exactly that. Wiring is required only if you want the FP semantics to be *part of* the
formal model — provable, rather than uninterpreted foreign functions. It enables native
Sail FP; it does not gate an executable Sail spec.

**On ISS speed.** The generated `round_once` path is slower than a tuned SoftFloat
routine — more integer ops, and slower still where a value stays in the 256-bit container
rather than unboxing to a native type. That is why the substitution layer above exists.
For FP-heavy kernels it matters; for everything else it is noise.

**What would help most from the hardware side**, concretely:

1. the **FP64 `FDMDA` internal precision** your FloPoCo datapath uses — the cross-check
   for the 256-bit container (§5);
2. the **tininess convention** the operators implement — underflow detected before or
   after rounding (§4);
3. confirmation there is **no flush-to-zero / denormals-are-zero** mode (RISC-V-aligned),
   so subnormal support is unconditional;
4. the **NaN canonicalization and propagation** rules the hardware uses — LVX follows
   RISC-V here, which differs from SoftFloat's defaults, and this is the part of the
   prologue most easily gotten subtly wrong;
5. whether the FloPoCo operator descriptions could double as the **reference the
   differential test targets**, so the Behavior semantics is validated against the same
   artifact the silicon was.

The immediate plan on this side is to land `f32_add` as the pilot — the whole
unpack → exact → `round_once` → repack path at the easy width — then FD2A as the second
pilot, precisely because it is the width-critical one, and read the real FP64 internal
width straight out of the width analysis to compare against (1).
