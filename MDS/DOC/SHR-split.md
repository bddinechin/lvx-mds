# Splitting `SHR` into arithmetic `SHR` and logical `SHRU`

A design note for retiring the one place `DOC/Behavior.md §3` still calls the
256-bit container "part of the architecture": the `SHR` operator. Read
`Behavior.md §3` and §6 first.

> **Status (landed): the operand-inference option below, not the two-operator
> split.** `Width.pm`'s `_shr` now computes the exact arithmetic interval and no
> longer reports `shr-negative`; `Behavior.pa`'s boxed emission picks `Int256_shr`
> (signed operand) vs `Int256_shru` (non-negative), mirroring the native path. The
> container width no longer enters any shift's meaning. Behaviour-preserving:
> lvx_v1 differential test 0/870 (old-vs-new and boxed-vs-unboxed); only the
> `Opcode.table` intervals and `Behavior.tuple` shift emission moved in `lvx-refs/`.
> A second `SHRU` operator was **not** added — see "Do we need `SHRU`" below.

## The problem

`SHR` is emitted as a **logical** shift (boxed: `Int256_shru`), but it is *used*
as arithmetic. `sraw = (SHR (SX.32 x) n)` works only because `SX.32` fills the
sign to bit 255 and `Int256_shru` shifts those container bits in. The codegen
already patches this per site:

- **Unboxed path** (`Behavior.pa`, the `SHR` arm of `codegen`): emits
  `(int${M}_t)op >> n` — arithmetic **iff the operand's reading is signed**
  (`$value{S}`). Container-free.
- **Boxed path**: `Int256_shru(...)` — a logical shift *of the 256-bit
  container*. This is where the container dependence lives.
- **`Width.pm _shr`**: on an operand not provably non-negative, reports
  `shr-negative` and returns the interval of a logical shift *of the whole
  `BOX`* — the box leaking into the analysis.

So one operator carries two meanings, and the arithmetic one is glued to the
container width. All 89 `shr-negative` sites (`sraw`/`srad`/`srsw`/`srsd`/
`avgw`/`avgrw`/`extfs`/`sxbd`/`sxhd`/`sxwd` + packed) depend on `BOX == 256`.

## Why two operators, and why each is container-free

On Behavior's **unbounded** integers:

- **Arithmetic shift** `SHR(x,n) = floor(x / 2ⁿ)` is a *total* function of
  `(x, n)` — defined for every integer, no width. For `x < 0` it rounds toward
  −∞, i.e. sign bits shift in.
- **Logical shift** is *not* a function of the integer alone. It is
  `SHRU_W(x,n) = floor((x mod 2^W) / 2ⁿ)` — a function of `(x, n, W)`. On an
  unbounded integer there is no top bit to zero-fill until you name `W`.

They **coincide on non-negative operands** (`x mod 2^W = x`, so `SHRU = SHR`) and
**diverge on negatives**, where `SHR` is still `floor(x/2ⁿ)` and `SHRU` needs a
`W`. That `W` is exactly what the container is silently supplying today.

The split removes the leak by routing on the sign, so neither operator ever
needs `W`:

| op | meaning | boxed | native | container-dependence |
|---|---|---|---|---|
| **`SHR`** (arithmetic) | `floor(x / 2ⁿ)` | `Int256_shr` *(already in the runtime)* | `(intM_t)op >> n` | **none** — floor-div is exact for any `x` |
| **`SHRU`** (logical) | `floor((x mod 2^W)/2ⁿ)`, `x ≥ 0` | `Int256_shru` | `(uintM_t)op >> n` | **none, by invariant** — operand is `ZX`'d, so `mod 2²⁵⁶` is identity |

`SHRU` on a possibly-negative operand becomes a **fatal** width error (an
unbounded logical shift with no width), not a `shr-negative` warning.

## Do we need `SHRU` at all?

Short answer: **for correctness, and for decoupling the container, no.** A second
operator buys *explicitness*, not capability.

The arithmetic-vs-logical choice is fully determined by one bit already present
at every shift site — whether the operand is read **signed** or **unsigned**
(`SX` vs `ZX`, i.e. the operand's ctype `S` flag):

- a shift of a signed (possibly-negative) operand can only mean **arithmetic**
  — logical is undefined without a width (see above);
- a shift of a non-negative operand means **logical**, and there logical *equals*
  arithmetic (`x mod 2^W = x`), so either reading gives the same result.

The native codegen path *already* infers exactly this (`(int${M}_t)` vs
`(uint${M}_t)` from `$value{S}`). So the container leak can be closed by teaching
the **boxed** path and **`Width.pm`** the same inference — an `SX`-read operand →
`Int256_shr` + an exact arithmetic interval; a non-negative operand →
`Int256_shru` + the existing logical interval — with **one** operator, no grammar
change, no `SHRU`, and no YAML migration. That is behaviour-preserving (the
differential test stays green), retires `shr-negative`, and makes `SHR`
container-free.

Inference is never *wrong* on well-formed Behavior: the only case it could
mishandle — a logical shift of a value read as signed/negative — is exactly the
case that has no meaning on unbounded integers, so a correct description never
writes it.

So what does a second operator add? Only that the intent is **on the page**
rather than **inferred**:

- `(SHRU x n)` is unambiguously logical regardless of how `x` was produced;
  inference instead depends on `x`'s signedness having been propagated correctly.
- `sraw` reads with `SHR`, `srlw` with `SHRU` — self-documenting, and robust
  against a future operand whose interval happens to be non-negative but whose
  *intent* is signed.

**Recommendation.** Inference is a smaller, single-step, green change that
achieves the whole container goal; `SHRU` costs a grammar change, a `Behavior.pm`
regeneration, and a migration across the ~dozens of shift sites for
*explicitness only*. So prefer **operand inference** for the container fix, and
reach for the explicit `SHR`/`SHRU` split only if the readability and
can't-be-mis-inferred robustness are judged worth the migration. If they are, do
it *after* the inference change has already made the container non-architectural,
so the split is a pure readability refactor and not a correctness one.

## The changes, file by file

**Runtime** — nothing. `Int256_shr` (arithmetic) and `Int256_shru` (logical)
both already exist. `Int512_shr`/`Int512_shru` are the mechanical widening later.

**Grammar** (`DOC/Behavior.y`): add the token and one production
(`'(' SHRU Integer Integer Abstract ')'`), regenerate `LIB/Behavior.pm`
(`make -f Maintainer Behavior.pm`; `yaxcc` normalizes, byte-stable).

**`LIB/Behavior.pa`**: add `SHRU` to the token list and `%CodeGen_Native`; clone
the `SHR` arms in constant-folding and pretty-print. Make `SHR` unconditionally
arithmetic (boxed `Int256_shr`, native signed); give `SHRU` the logical arms
(boxed `Int256_shru`, native unsigned).

**`LIB/Width.pm`**: split `_shr` (dispatched from `_binary`) into arithmetic
`_shr` (exact floor for all operands, no `$BOX`, no `shr-negative`) and logical
`_shru` (non-negative path; fatal if the operand may be negative). Retire
`shr-negative`.

## Migration (step 2), mechanical and behavior-preserving

Classify each YAML `SHR` by its operand coercion — the analysis already does
this via `shr-negative`:

- `(SHR (SX.n …) …)` — the 89 `shr-negative` sites: **leave unchanged**; `SHR`
  now *means* arithmetic, which is what they always wanted.
- `(SHR (ZX.n …) …)` / other non-negative operands (`srlw`/`srld`/`extfz`/mask
  extracts): **`SHR` → `SHRU`**.

Byte-identity of behavior: `Int256_shr(sx(x,w),n) == Int256_shru(sx(x,w),n)` on
the demanded bits (both shift the same sign in), and logical sites keep
`Int256_shru` — so the differential test stays **0/870** and **0/1453**. The
`.tuple` *text* moves (`Int256_shru` → `Int256_shr` at the arithmetic sites), so
`lvx-refs/BE/LAO` must be regenerated; the *behaviour* does not move.

## Sequencing, and a coupling caveat

1. **Machinery** (this note's step 1): grammar + `Behavior.pa` + `Width.pm`.
2. **Migration**: the YAML `SHR`→`SHRU` reclassification above.
3. Rebuild; run `BE/LAO/TEST` on **both** cores (require 0/870, 0/1453);
   regenerate `lvx-refs/BE/LAO`.
4. Only after (3) is green: the `Int256→Int512` widening for lvx_v3.

**The caveat found while drafting:** steps 1 and 2 are *coupled*. Making `SHR`
unconditionally arithmetic while the YAML still routes logical shifts through
`SHR` mis-emits the logical sites (a signed native `>>` of a `ZX`'d operand whose
top bit is set is wrong). So step 1 alone is **not** differential-test-green; the
sites it breaks are exactly the step-2 migration worklist. Two ways to land it:

- **As drafted** — implement step 1, run the differential test to *expose* the
  logical sites as failures, then migrate them (step 2) to reach green. The
  failure set is the worklist.
- **Operand-inference alternative** — instead of a second operator, make `SHR`'s
  boxed path and `Width.pm` infer arithmetic-vs-logical from the operand's
  signedness (`SX` → `Int256_shr`, `ZX` → `Int256_shru`), exactly as the native
  path already does. This is single-step, behaviour-preserving (differential test
  stays green), retires `shr-negative`, and decouples the container — without a
  new operator or a migration. It keeps `SHR` "inferring" rather than explicit,
  which is the only thing the two-operator split buys over it.
