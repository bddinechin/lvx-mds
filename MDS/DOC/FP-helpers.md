# Closing the helper gap: where the FP semantics belong

A design note for `Behavior.md` §7 (5), the item that section calls "the real
bottleneck for ISS retargeting". Read `Behavior.md` §4 first — this note assumes its
argument and only settles a question it left open: **if the ~57 floating-point
helpers are to stop being opaque C, does MPFR do the job?**

> **Status: the flags have landed; the bodies have not.** Steps 0–4 of §7 are in — the
> tuple grammar, the checked `result`, the 22+1 FP macros, and all 60 flag-raising helpers
> — so an FP instruction's IEEE flags now reach CS, which no LVX instruction had ever
> done. What is still opaque C is the *arithmetic*: `f32_add` returns its flags as data
> and computes its sum in a helper. That is §7 (5), and it is the rest of the job.
>
> On MPFR, which this note set out to answer: **it belongs in `BE/LAO/TEST/` as an oracle,
> alongside SoftFloat and not instead of it — never behind an `APPLY`.** The thing worth
> taking from it is its *precision parameterization*, not its API. §4's design stands
> unchanged; MPFR corroborates it rather than replacing it.

## 1. What LVX's gap actually is, measured

> **This section is the diagnosis, and it is now history: the flags landed** (§6b). It is
> kept in the past tense of its own findings because the reasoning is what justifies the
> shape of the fix — and because "86 instructions claim an effect that no behavior has" is
> worth remembering as a thing that was true of a description in active use.

**The arithmetic flags were not modelled.** 86 instructions say in their `description:`
that "This instruction may raise exception bits in the CS register", and **no behavior
wrote `CS_IO`, `CS_DZ`, `CS_OV`, `CS_UN` or `CS_IN`.** Those semantics lived in exactly
two places, neither of them the description: English prose, and a global mutated inside
the opaque C. So §4's "not in the description at all" was literal *for the flags*.

Be precise about the scope, because the obvious grep gets it wrong. **CS is written 49
times**, all from `Format.yml`'s `Macro:` wrappers and all of them `CS_XMF`. So the
register, the idiom, and the plumbing are in use already — it is the five IEEE flag bits
specifically that nobody sets. The gap is narrower than "CS is unmodelled", and that
makes it smaller: step (1) does not invent a way to reach CS, it reuses one.

`RegField.yml` gives the layout: `CS_IO`(1) invalid operation, `CS_DZ`(2) divide by zero,
`CS_OV`(3) overflow, `CS_UN`(4) underflow, `CS_IN`(5) inexact, plus an Extension set
`CS_XIO`..`CS_XIN` at 9..13.

**KVX models them, so this was lost in the port rather than never written.** Its
description has 298 CS accesses against LVX's 49, including the five arithmetic flags as
per-flag variables (`CS_dz`, `CS_in`, `CS_io`, `CS_ov`), and the idiom is one LVX can use
verbatim — address each flag by its `RegField` name, no bit arithmetic:

```
(WRITE.CS_dz (F2I.1 (LOAD.E4 (AGGL.CS (CONST.CS_DZ) (CONST.1)))))
(STORE.E4 (AGGL.CS (CONST.CS_DZ) (CONST.1))
  (I2F.1 (IOR (APPLY.fdivbyzero) (READ.CS_dz))))
```

That settles the encoding question §6a would otherwise have to invent an answer to: **the
flags need no bit order and no shifting**, because each is addressed by name. It also
confirms stage **E4** independently — which is where `faddw`'s Write parameter already
puts its result.

**What KVX cannot lend is the flag *source*, and that is the whole point.** It gets them
from `APPLY.finexact`/`finvalid`/`foverflow`/`fdivbyzero`/`funderflow` — zero-argument
helpers querying SoftFloat's global — and its SIMD calls *vectorized* helpers
(`f32_add_x2`) with the flags OR'd once per instruction. That is precisely §4's global
mutable accumulator, and it works for KVX only because kv3's FP SIMD is **unmasked**. It
cannot express "CS accumulates the OR of the flags raised by the active lanes". So: keep
KVX's CS idiom, replace its flag source with the tuple.

**And the author does not write any of this per instruction.** KVX has exactly **3**
direct `WRITE.CS_dz` sites in its whole description; they are the definitions of shared
`Macro:` anchors, and every FP instruction just says `behavior: *behaviorWRSRD`, with its
own arithmetic spliced in at `(MACRO.Instruction)`. LVX's `Format.yml` is built the same
way and its 49 `CS_XMF` stores are already there. The flag accumulation belongs in the FP
macros, written once each; an instruction's own behavior changes by one line, from a
`WRITE` to a `BIND`.

**One thing LVX drops on purpose:** KVX guards every FP CS write with a `silent` modifier
(`.S`, "Silent on CS") and LVX has none. That is deliberate — it costs encoding space, and
RISC-V has no such mode either, only an explicit rounding mode, which is what LVX follows
(the `floatmode` field, RISC-V's `frm` encoding). So LVX's FP macros accumulate
unconditionally, with no `IF` guard around the CS stores.

### The hook is already there, and it is a panic stub

Step (1) does not add a place for the flags to be committed. **It replaces one.** Every FP
macro already ends:

```
  (WRITE.RM (SELECT (EQ (READ.floatmode) (CONST.7))
              (F2I.3 (LOAD.RR (AGGL.CS (CONST.CS_RM) (CONST.3))))
              (READ.floatmode)))
  (MACRO.Instruction)
  (COMMIT.E4.%1 (READ.result1))
  (EFFECT.E4.commit_float_exception_flags)      <- 57 sites, 29 macros
```

`commit_float_exception_flags` **takes no arguments**, so it can only work by reading a
global — the same shape as KVX's `finexact`/`finvalid`, and the same one §4 rejects. It has
no `Helper.yml` signature, and in gem5 it is `lvx_behavior_unimpl()`: a **panic stub**. So
the flags have a designated home, a stage, and a call site, and nothing behind them. That
is the line the per-flag CS stores replace.

### The blast radius is a macro, not an instruction

The macros are FP-specific — `GW*F` and `RV32F_*`, 29 of them, ridden by the 144 FPU-class
opcodes plus `FNARROWDWQ`/`FNARROWWHQ` (FP, ALU-classed) — so no non-FP instruction can be
caught by an edit. But **a macro is shared across helpers**: `behaviorGW4RRF` alone serves
5 formats and 10 instructions — `FADDD FADDDP FADDHO FADDW FADDWQ FSBFD FSBFDP FSBFHO
FSBFW FSBFWQ` — which is `f16/f32/f64_add` *and* `f16/f32/f64_sub`. Since the macro's CS
stores read flag variables that only a `BIND` supplies, converting `f32_add` alone would
leave `FSBFW` riding a macro that reads what it never bound.

**The fix is to zero the flags in the macro before splicing:**

```
  (WRITE.io (CONST.0)) (WRITE.dz (CONST.0)) ...
  (MACRO.Instruction)          <- BINDs them, or does not
  ... (IOR ...) each into its CS bitfield ...
```

An unconverted instruction leaves the zeros standing, the `IOR` is a no-op, and CS is
untouched — so the macro tolerates both, and the 57 helpers convert one at a time instead
of in one leap. That is the same discipline `Helper.yml`'s header already sets for
`arguments`: declare what is known, leave the rest alone.

### `Macro:` is not an MDD element

Worth knowing before looking for its table: there isn't one, and it is not in `MDD.dtd`.
`Macro:` in `Format.yml` is a **YAML anchor namespace** — `YAML::XS` expands
`*behaviorGW4RRF` inline before MDS parses anything, so `Description2MDS.pl` only registers
the IDs to reject duplicates. The splice is textual and later: `MDD/MDE/BIN/Opcode.pl`
splits a format's behavior on `(MACRO.Instruction)` and puts the instruction's between the
halves. So editing a macro means editing the anchor definition, and every format
referencing it changes with no further ceremony.

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
  **nearest-ties-to-max-magnitude**, reserved, **round-to-odd**, and "use CS". The encoding
  is RISC-V's `frm`; the `.` ("use CS", `floatmode == 7`) case reads `CS_RM` (CS bits 16..18)
  directly in Behavior — `SELECT (EQ floatmode 7) (LOAD CS_RM) floatmode` — rather than
  through a helper, which is the only form that can reach the CSR.

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

> **Re-appraised once the flags landed, and two of these three no longer bear weight.**
> The conclusion is unchanged; the reasoning for it is narrower than it looks here.
>
> - **The global-flag objection is largely gone, and we removed it ourselves.** The tuple
>   convention (§6a) is precisely what makes a global-flag library *wrappable*: a helper
>   can clear, compute, read and return `(result, flags)`, and the masking lives in the
>   description. The global becomes a local detail of one call rather than a property of
>   the semantics. That was §4's primary complaint against SoftFloat and it no longer
>   decides anything.
> - **The unbounded-precision objection is currently vacuous.** It needs an
>   exact-accumulation operator to bite on, and LVX has none (§1). It would matter to an
>   lvx_v3 with ML operators; today it is an argument about nothing.
> - **What survives carries the whole weight: an `APPLY` keeps the semantics out of the
>   description.** The width pass cannot see in, Sail gets an `extern`, and every ISS
>   relinks a library. That is the whole of §7 (5) — but note it is an argument against
>   *any* library, not against MPFR. MPFR is not specially disqualified; no library can be
>   the specification.

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
| **SoftFloat** | the IEEE-conforming subset | Format-native — it *is* a binary32/binary64 model rather than something configured into being one, so no `subnormalize` protocol and no double-rounding hazard. And it covers `.RM` (`softfloat_round_near_maxMag`) and `.RO` (`softfloat_round_odd`, where the port provides it), which MPFR cannot. **But it must be specialized to RISC-V first — see below.** |
| **MPFR** | exactness and rounding | Correct rounding at arbitrary precision. The only one that can oracle a single-rounding accumulation, or check a rounding decision at a precision no format has — which is exactly what `round_once` (§6) is. |

Neither is an oracle for `fast_rec`/`fast_rsqrt`. Nothing is: they are approximate by
architecture, and the only possible reference is the bound the architects specify.

### Stock SoftFloat is the wrong oracle for LVX, and quietly

LVX FP is **RISC-V** FP, canonical NaN generation and NaN handling included — and that is
explicitly *not* SoftFloat's. SoftFloat parameterizes exactly this, as a build-time
**specialization**, which fixes the default quiet NaN, how NaNs propagate from inputs to
output, how sNaN is distinguished, tininess timing, **and the integer result a conversion
returns when it raises invalid**.

**It ships 8086, 8086-SSE, ARM-VFPv2 and ARM-VFPv2-defaultNaN. There is no RISC-V
specialization in the stock distribution.** So an unspecialized SoftFloat disagrees with
LVX on every NaN result and on `FIXED*` of a NaN — RISC-V returns `INT_MAX`, the 8086
specialization returns `INT_MIN`. Both are silent, and both hide on exactly the inputs a
random test under-samples. Take `riscv-isa-sim`'s `specialize.h`, or write one;
`ARM-VFPv2-defaultNaN` is the closest in spirit — it generates a default NaN rather than
propagating payloads — but it is not RISC-V.

This is the second time the *general rule* (LVX FP is RISC-V FP) has outranked a
plausible-looking artifact; the first was `GWRR` and KVX's silence on `FMINW` (§6b).

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

**The architecture corroborates the parameterization from a direction MPFR knows nothing
about.** The architect's rule is that `F*H` and `F*D` raise what the corresponding `F*W`
raises — the flag sets do not vary with width (§6b), and the width rule cross-checks
itself against kv3_v1 wherever both apply. A specification whose *flags* are
width-invariant and whose *arithmetic* is not would be describing an accident. One
`round_once(p, emin, emax)` is what makes both invariant together.

**And the parameterization gives MPFR its remaining job.** With the flags landed, MPFR's
arbitrary precision has no LVX operator to serve — there are no exact-accumulation
operators here (§1). But `round_once(p, emin, emax)` is *precisely* a
precision-parameterized rounding, so MPFR is its natural oracle: set the precision and the
exponent range, compare. The idea worth taking from MPFR and the job left for MPFR turn out
to be the same idea, used twice.

## 6a. The flag encoding: tuples, not packing

**Decided: `APPLY` returns a tuple, and `Behavior` gets the grammar for it.** This
supersedes §4's sketch, which packs (result, flags) into one wider integer and notes
"Behavior needs no grammar change to do it". That was true, and it is the wrong trade.

**Why packing fails, and it fails on f64.** The rule "double the format width, low half
result, high half flags" gives:

| | `APPLY` | layout | C type | |
|---|---|---|---|---|
| FP16 | `APPLY.32.f16_add` | `16[0]`, `16[1]` | `uint32_t` | free |
| FP32 | `APPLY.64.f32_add` | `32[0]`, `32[1]` | `uint64_t` | free — the case §4 sketched |
| FP64 | `APPLY.128.f64_add` | `64[0]`, `64[1]` | **`Int256_`** | **boxes** |

`_ctype_native`'s ladder is 8/16/32/64 and `_signature_result` boxes anything above 64,
so widening f64's result crosses the container and every f64 FP operation starts
returning a 32-byte union where it now returns a native `uint64_t` — 13 helpers, 38 sites
on `lvx_v2`, and in an lvx_v3 8-lane masked FP64, eight boxed returns per instruction. It
is **not** fixable by shrinking the flag field: f64's result already fills a native 64-bit
type, so result + *any* flag bits exceeds 64. Five bits or sixty-four, same box. Packing
inherently boxes the widest format, which is the one that matters.

**A tuple dissolves it**, because the elements are typed independently: `(64, 5)` is a
`uint64_t` and a `uint8_t`, both native, nothing crossing the container. The
`unsigned __int128` escape hatch that packing would have needed is not needed.

Two further reasons, either sufficient:

- **It is what Sail does**, which §4 itself cites: *"its soft-float interface returns
  `(fflags, value)` pairs rather than touching a global."* The tuple exports to a Sail
  back-end as-is; the packed form exports as arithmetic on a 128-bit integer that Sail
  must un-pack before it means anything.
- **It puts the convention in the type rather than in folklore.** "The flags live in
  `32[1]`" is something 57 operators and every future reader must remember, and nothing
  checks. `result: [64, 5]` is checked (`helper-result`, §5).

**The shape: a scalar helper per lane; the description assembles the vectors.** The helper
stays one per format — `f64_add` is `(64, 5)`, not `f64_add_v8` — and the `FOR` body binds
its two results, writes the result lane, and writes the flag lane. The instruction's
"vector of results, vector of flags" is built by the description, and CS takes an
OR-reduction over the *active* lanes of the flag vector. The alternative — a vectorized
helper returning both vectors — was rejected: it multiplies the helper population by lane
count (format × 1/2/4/8/16), and an 8-lane FP64 result vector is 512 bits, which drags
lvx_v3's container question into the helper ABI. Keep that question in the register model
where it belongs.

**Containment is the design rule: a tuple is destructured at its binding site and is never
a first-class value.** The two results become ordinary Integer variables immediately, so
`Width.pm` still bounds one interval per variable, `ctype` needs no tuple type, and the
blast radius stays at `APPLY` + the binding command + the helper prototype. If tuples were
allowed to flow through expressions, be stored, or be passed on, the interval analysis and
the type map would both need tuple support — a far larger change for no gain here.

**The deltas.**

- `DOC/Behavior.y`: `Widths : Width | Widths ',' Width` and a binding command taking more
  than one `Variable`. `,` is already a token (`Attributes`), and both are LALR(1) — after
  an `INTNUM`, a `,` continues the list and a `.` reduces it.
- `LIB/Behavior.pa`: the matching `#rule`s and actions, then regenerate `LIB/Behavior.pm`.
  **`#rule` must start in column 0** and the regeneration must reproduce byte-identically —
  see `Behavior.md`'s "Generated files and their toolchain pins".
- **The tree shape is the decision that touches every consumer.** `WRITE` currently builds
  `[ 'WRITE', $section, $name, $expr ]` and `$name` is a scalar. A tuple bind must not
  silently turn it into an ARRAY ref: a new command node, distinguishable on `$this->[0]`,
  leaves every existing tree byte-identical and makes unported consumers fail loudly
  rather than quietly.
- `DOC/MDD.dtd`: `result NMTOKEN` becomes `NMTOKENS`, symmetric with `arguments NMTOKENS`
  — so `result: [64, 5]`. Regenerate `LIB/MDD.pm` (`make -f Maintainer MDD.pm`).
- `Width.pm`: `helper-result` generalizes from comparing two scalars to comparing two
  lists. It is worth more under tuples than it was under packing.
- `CodeGen`: a struct return, or out-parameters. `BE/LAO/TEST`'s `genstubs.py` and
  `BE/GEM5`'s `helper_stubs.inc` follow the prototype.

## 6b. Which flags each helper raises, and where that came from

**Landed.** 60 helpers declare a tuple result and their sites bind it; the table below is
read back off the description, not off intent. Much of it began as inference and it is a
specification claim either way — a reader who assumes it was copied from a document would
be wrong for most rows.

**LVX's own prose could not answer the question.** Every CS-claiming instruction said the
generic *"may raise exception bits in the CS register"* and never named which. KVX names
them in every case (zero generic), so the specificity was lost in the port along with the
CS modelling. kv3_v1 covered 28; the rest are kv4_v1 features it lacks, and kv4_v1's
`Description.yml` is not available — only its architecture chapters (`kv4-v1-*.tex`).

Three rules from the architect closed the gap:

- **`F*H` and `F*D` raise what the corresponding `F*W` raises** — width does not change
  the set.
- **LVX FP arithmetic is RISC-V FP arithmetic**, canonical NaN generation and NaN handling
  included, which is *not* SoftFloat's.
- **`FMIN`/`FMAX` are RISC-V `FMINM`/`FMAXM`; `FMINN`/`FMAXN` are RISC-V `FMIN`/`FMAX`.**
  The pairs differ in NaN *propagation* — `FMINM`/`FMAXM` return the canonical NaN — not in
  flags.

| flags | helpers | source |
|---|---|---|
| **IO IN** (26) | `f{16,32,64}_rint`, `_sqrt`; every float↔int conversion (`f*_to_{i,ui}*`, `{i,ui}*_to_f*`) | kv3_v1 for the same-width conversions; RISC-V FSQRT / IEEE roundToIntegralExact; width rule for the rest |
| **IO** (12) | `f{16,32,64}_{min,max,minNum,maxNum}` | RISC-V: invalid only, on a signalling NaN |
| **IO OV UN IN** (11) | `f{16,32,64}_mul`, `_mulAdd`, `_mulnAdd`; `f32_to_f16`, `f64_to_f32` | kv3_v1 for `mul` and the narrowings; RISC-V FMADD for the fused forms |
| **IO OV IN** (8) | `f{16,32,64}_add`, `_sub`; `ffmac_32_32`, `fmulc_32_32` | kv3_v1; width rule for f16 |
| **IO DZ OV UN IN** (3) | `f{16,32,64}_div` | RISC-V FDIV |
| **none** (5) | `f{32,64}_fast_rec`, `_fast_rsqrt`; `fconj_32_32` | architect (pending new hardware); `fconj` flips a sign bit and takes no rounding mode |

**Two rows are right where intuition is wrong**, which is the reason to trust the inferred
ones. Addition looks like it should underflow and cannot: a sum landing in the subnormal
range is *exact*, so never both tiny and inexact — hence IO OV IN, not IO OV UN IN, and
RISC-V agrees. And the width rule cross-checks itself: it predicts `f64_add` raises what
`f32_add` raises, and kv3_v1 independently documents both as IO OV IN. Anyone "fixing" add
to raise UN would be breaking it.

### The name pattern aliased one helper onto another

The first sweep silently skipped every camelCase helper, and `helper-result` could not
report it. `f32_mulAdd` truncates to `f32_mul` under a `[a-z_0-9]+` name pattern — **and
`f32_mul` is a different real helper**. So the sweep converted "f32_mul", declared
`f32_mul`, and `f32_mulAdd` was never named anywhere a check could look. Likewise
`f32_mulnAdd`/`f32_muln` and `f32_minNum`/`f32_min`. The fused multiply-adds and the
min/max forms were left unconverted, and nothing said so.

A truncating pattern is not merely incomplete: it **aliases**. This note carried an
invented helper for a while because of it — `f{16,32,64}_muln`, which does not exist and
never did; it was `_mulnAdd` seen through the same truncation.

### FMIN/FMAX needed a macro of their own: GWRRE

They rode `behaviorGWRR`, which has no flag-commit hook and never had one — and which **80
instructions ride, 68 of them integer** (`ADDD`, `ANDQ`, `SRLD`…), which have no business
touching CS. `GWRRF` does not fit either: it reads `%4` as a `floatmode` and decodes a
rounding mode, and min/max do not round. Hence **`GWRRE`** — `GWRR` plus flag accumulation
at E1, no rounding mode — with `ALU_F{D,W,H}MMWR` and `ALU_F{DP,WQ,HO}MMWR` repointed to
it. `FSIGN*` stay on `GWRR`: they are RISC-V `FSGNJ` and raise nothing.

**The old description looked authoritative and was wrong**, which is worth remembering the
next time an artifact contradicts a rule. `GWRR` genuinely has no hook; KVX genuinely makes
no CS claim for `FMINW`/`FMAXW`. Both facts are real, mutually consistent, and both are the
same loss that took the CS modelling and the flag names. The evidence was self-consistent
because it was all downstream of one omission.

## 7. Recommendation, in order

0. **Make `Helper`'s `result` checkable** — *done*. The convention in (1) works by
   *widening a helper's result* to carry (result, flags), so every one of the 57
   conversions is an edit that must change the `Helper` declaration and every `APPLY` of
   it together. `Helper.yml`'s header already said `result` "must agree with the width
   every `APPLY` of it declares" — and **nothing checked it**: `CodeGen` types the call
   from the declaration (`Behavior.pa`'s `_signature_result`), the width analysis bounds
   it from the `APPLY`, and `MDD/MDE/BIN/Opcode.pl` threaded only `arguments`, so the two
   never met. A disagreement was a type lie C would not catch, on the exact edit the whole
   plan is made of. Now `helper-result`, and fatal (§5). It earned itself immediately:
   it refused `f32_sub` half-converted, and later caught nine instructions calling a
   converted helper whose prose never claimed CS effects at all.

1. **Tuple returns in the grammar** (§6a), then **the flag-returning convention on one
   operator, end to end** — *done*. This was the load-bearing decision and it was provable
   *before* any FP body was written: 60 operators now depend on it, and changing it
   afterwards would have been expensive. It was proved with the **body still an opaque
   helper** — give `f32_add` `result: [32, 1, 1, 1]`, bind its results, express the CS
   accumulation
   as an OR-reduction over the active lanes, and the global flag leaves the
   *description's* semantics even though the C still has one.

   `f32_add` is the right first operator: its six call sites are scalar `FADDW`, 2-lane
   `FADDWP`, 4-lane `FADDWQ`, complex `FADDWC` and NaN-boxed `FADD.S`, so one conversion
   exercises the scalar, lane and reduction paths. And because `result` must agree with
   every `APPLY` (`helper-result`, step 0), the six move together or the build fails.

   **This step is not behaviour-preserving and must not be measured as if it were.** It
   adds CS writes that the description has never had, so `refs` and the differential
   traces *will* move; the safety net is review and the width analysis, not trace
   equality. That is the one place in this plan where `BE/LAO/TEST`'s usual question —
   "does it still compute the same thing?" — is the wrong question.
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
