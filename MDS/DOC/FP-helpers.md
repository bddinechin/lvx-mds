# Closing the helper gap: where the FP semantics belong

A design note for `Behavior.md` §7 (5), the item that section calls "the real
bottleneck for ISS retargeting". Read `Behavior.md` §4 first — this note assumes its
argument and only settles a question it left open: **if the ~57 floating-point
helpers are to stop being opaque C, does MPFR do the job?**

> **Status: analysis and recommendation. Nothing landed.** Recommendation in short:
> **MPFR belongs in `BE/LAO/TEST/` as an oracle, alongside SoftFloat and not instead
> of it — never behind an `APPLY`.** The thing worth taking from MPFR is its
> *precision parameterization*, not its API. §4's design stands unchanged; MPFR
> corroborates it rather than replacing it.

## 1. What LVX's gap actually is, measured

`Behavior.md` §7 (5) says "**start with the exact dot-product operators** — no library
can give you those". **That advice does not apply to LVX**, and this is the first thing
to know before planning the work:

- **There is no `ARITH` class and there are no dot-product operators.** `lvx_v2`'s
  classes are ALU (737), LSU (490), FPU (164), BCU (46), EXT (16). The exact-accumulation
  operators §4 builds its case on are a *KVX* feature. The 550-bit Kulisch question §4
  raises — the one that would have stress-tested the 256-bit container — **has no
  operator in this ISA to attach to.**
- **The gap is 57 IEEE-shaped operators**: `f16`/`f32`/`f64` × `add`/`sub`/`mul`/`div`/
  `sqrt`/`mulAdd`/`mulnAdd`/`min`/`max`/`minNum`/`maxNum`/`rint`/`classify`, plus the
  conversions between formats and to/from integers.
- **Four of them are not IEEE at all**: `f32_fast_rec`, `f32_fast_rsqrt`, `f64_fast_rec`,
  `f64_fast_rsqrt`. These are *architecturally approximate*. No library defines them —
  not SoftFloat, not MPFR — and their semantics exist nowhere: not in the description,
  not in a library, and `BE/GEM5`'s stub panics. **They are LVX's analogue of §7 (5)'s
  "no library can give you those"**, and they need an accuracy bound from the architects
  that is not derivable from any table here.
- **Rounding has six architectural modes.** `Modifier.yml`'s `floatmode` is
  `.RN .RZ .RD .RU .RM .R5 .RO .` — round-to-nearest-ties-even, toward zero, down, up,
  **nearest-ties-to-max-magnitude**, reserved, **round-to-odd**, and "use CS". The mode is
  decoded by `decode_riscv_float_rounding_mode`, so the encoding is RISC-V's.

That `.RO` exists in hardware is worth pausing on. Round-to-odd is *the* device for
accumulating exactly and rounding once without double-rounding error. The architecture
already cares about the problem §4 is about.

## 2. What MPFR is

Verified against the current manual (https://www.mpfr.org/mpfr-current/mpfr.html).

| | MPFR |
|---|---|
| Licence | LGPL v3+, built on GMP |
| Core guarantee | **correct rounding at arbitrary precision** |
| Precision | **per-variable** — one `mpfr_add` serves every precision |
| Exception flags | **global (or per-thread) sticky state**: underflow, overflow, div-by-zero, NaN, inexact, erange |
| Ternary value | returned per call, but encodes only *inexact + direction* |
| Exponent range | `emin`/`emax` are **global state**; callers must save and restore |
| Subnormals | **not by default** — needs `mpfr_subnormalize` after *each* operation, with a double-rounding hazard |
| Values | heap-allocated; `mpfr_init`/`mpfr_clear` per variable |
| Rounding modes | `RNDN`, `RNDZ`, `RNDD`, `RNDU`, `RNDA`, and `RNDF` (experimental) |

## 3. The case for MPFR, at its strongest

**MPFR can express non-standard arithmetic that SoftFloat cannot express at all.** This
is the decisive point in its favour and §4 concedes it in advance: *"SoftFloat rounds
every operation and exposes no accumulator. It cannot express this at all."* MPFR has an
accumulator — raise the precision, sum exactly, round once. A fully exact dot-product add
with a single rounding step is a handful of MPFR calls.

Any evaluation that does not start here is not taking MPFR seriously. It is a genuine
capability, and it is exactly the capability §4 says the problem needs.

## 4. Why it must nonetheless not be an `APPLY`

**Because MPFR's unboundedness models the wrong machine.** This is the argument that
decides it, and it is §4's own:

> The LVX operators are implementable in hardware, so they must bound the alignment
> window — and *that bound is part of the architecture and belongs in the specification*.

Hardware has a finite accumulator. MPFR has as much precision as it likes. An
`APPLY.mpfr_*` would compute the *mathematically* exact result; the machine computes the
exact result *within its alignment window*. Those two differ precisely when the window is
exceeded — which is the interesting case, the one the architecture had to make a decision
about — and putting MPFR behind an `APPLY` makes the difference invisible, because it
happens inside the opaque call. **A specification that calls MPFR describes a machine LVX
is not.**

It also defeats §5's central theorem. "Is 256 bits enough?" is answerable *only* because
the width pass can see the accumulation. Move it inside MPFR and the question stops being
askable: the honest answer becomes "MPFR never overflows", which is true, and useless,
because the machine does.

Three further reasons, each sufficient on its own:

- **MPFR has the identical defect §4 rejects SoftFloat for.** The objection was never
  "SoftFloat's flags are bad"; it is that *a global mutable accumulator cannot express
  "CS accumulates the OR of the flags raised by the **active** lanes" compositionally*.
  MPFR's flags are global sticky state too. For SIMD it is **worse**: `emin`/`emax` are
  global as well, so per-format lanes need global mutation, plus a `subnormalize` per
  operation and a heap `init`/`clear` per value. On an 8-lane `f32` XVR that is a global
  protocol dance per instruction, in the ISS inner loop.
- **It cannot express two of LVX's six rounding modes.** `.RM` (nearest, ties to max
  magnitude) and `.RO` (round to odd) have no MPFR equivalent — `RNDA` is *away from
  zero*, not *nearest-ties-away*. So MPFR covers 4 of 6.
- **It changes nothing (5) exists to change.** An `APPLY` is opaque whichever library is
  behind it: the semantics stay out of the description, every ISS target still links a
  library, Sail still gets an `extern`, and the width pass still cannot see in. It is the
  status quo with a heavier dependency and a licence question.

And Behavior does not need MPFR for exactness. That is the premise: unbounded integers
**are** the value domain. §4 already gives the recipe — decompose, exact integer products,
align, accumulate, round once — and notes it is exact *"by construction in the
specification, independent of the implementation's box size"*.

## 5. Why it is nonetheless the better oracle, and a bigger one than §4 imagined

§4 gives SoftFloat an oracle job and confines it to *"the IEEE-conforming subset (single
lane, unmasked, standard operations)"*. That ceiling exists **because SoftFloat cannot do
exact accumulation**. MPFR removes it.

Every defect in §4 above is harmless in a harness: an oracle runs one lane at a time, so
global flags and a global exponent range are simply set once. The heap allocation does not
matter at test speed. What is left is exactly what an oracle needs: correct rounding at
any precision, deterministic and portable.

That gives MPFR a role SoftFloat structurally cannot fill — **the mathematical ideal
against which the hardware's bound is measured.** Write the operator in Behavior with its
alignment window, run MPFR at full precision, and the diff is a direct empirical map of
where the window bites. That is how the bound §4 says "belongs in the specification" gets
*validated* rather than merely asserted, and it complements the width pass: the pass
proves 256 bits suffice for what the description says; MPFR shows what the description
gives up against exact arithmetic.

**Use both, for different jobs:**

| Oracle | Job | Why it, and not the other |
|---|---|---|
| **SoftFloat** | the IEEE-conforming subset | Format-native — it *is* a binary32/binary64 model rather than something configured into being one, so no `subnormalize` protocol and no double-rounding hazard. And it covers `.RM` (`softfloat_round_near_maxMag`) and `.RO` (`softfloat_round_odd`, where the port provides it), which MPFR cannot. |
| **MPFR** | exactness and rounding | Correct rounding at arbitrary precision. The only one that can oracle a single-rounding accumulation, or check a rounding decision at a precision no format has. |

Neither is an oracle for `fast_rec`/`fast_rsqrt`. Nothing is: they are approximate by
architecture, and the only possible reference is the bound the architects specify.

## 6. What to take from MPFR: the parameterization

**MPFR's precision is per-variable, so one `mpfr_add` serves every precision.** That is
the idea, and it is worth more here than any of its code.

Today `f16_add`, `f32_add`, `f64_add` are three separate opaque helpers, and the count
grows with the ISA — lvx_v3's 8/16/32/64-bit SIMD lanes would multiply it. If the Behavior
specification is written parameterized by (precision *p*, exponent range *emin*/*emax*) —

```
    unpack  →  exact integer arithmetic  →  round_once(p, emin, emax)  →  (result, flags)
```

— then `f16`/`f32`/`f64` are three *instantiations of one specification*, not three
specifications. That collapses a large part of the 57, it is what makes lvx_v3's lane
widths nearly free, and it is the shape MPFR demonstrates is workable at scale for real
numerics.

Note this is also the MPFR *discipline*, not just its API: exact/wide intermediate, then a
single correct rounding, with the inexactness reported as a returned value rather than a
raised global. Behavior can do all three natively. §4's flag-returning sketch is the same
shape as MPFR's ternary value, arrived at independently.

## 7. Recommendation, in order

1. **The flag-returning convention, on one operator, end to end.** This is the
   load-bearing decision and it is provable *before* any FP body is written: 57 operators
   will depend on it, and changing it afterwards is expensive. §4 shows the shape and
   notes Behavior needs no grammar change. It can be proved with the **body still an
   opaque helper** — widen `f32_add` to return (result, flags), express the CS
   accumulation as ordinary masked data flow, and the global flag leaves the
   *description's* semantics even though the C still has one. Differentially testable at
   every step.
2. **`round_once(p, emin, emax)` in Behavior**, and the unpack/pack primitives around it.
   The shared machinery of §6, and the point at which `.RM` and `.RO` stop being someone
   else's problem.
3. **The IEEE bodies**, as instantiations. SoftFloat as the oracle.
4. **`fast_rec`/`fast_rsqrt`** — blocked on an accuracy bound from the architects, not on
   engineering.
5. **MPFR in `TEST/`** when there is an exactness claim to check — which today means
   step 2's rounding, and in an lvx_v3 with ML operators, a great deal more.

## 8. What would change this

- **If lvx_v3 gains exact-accumulation ML operators**, §4's strongest argument acquires an
  LVX operator to attach to, and MPFR's oracle role grows from useful to necessary. It
  still does not become an `APPLY`, for §4's reason: the hardware's window is the
  specification, and MPFR has no window.
- **If the FP bodies prove unwritable in Behavior at acceptable size** — the honest risk
  in step 3 — the fallback is not MPFR-as-`APPLY`. It is to keep the bodies opaque *and
  keep the flag-returning convention from step 1 anyway*, since that is where the SIMD
  masking correctness lives and it is independent of who computes the arithmetic.
