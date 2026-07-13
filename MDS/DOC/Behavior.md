# Behavior: where it stands, and what to do next

A positioning note on the Behavior language — what it is, how it compares to the
mature alternatives, and what is worth changing. Written 2026-07 during the work
that added the static width checking pass (`MDS/LIB/Width.pm`).

The grammar is `MDS/DOC/Behavior.y`; the semantic actions, the tree passes and the
C code generator are all in `MDS/LIB/Behavior.pa`.


## 1. What Behavior is

Behavior is an S-expression IR for the operational semantics of instructions. It
is not authored directly: each instruction in `lvx-family/FE/YAML/lvx/Instruction.yml`
carries a C-like `execution:` block (parsed by `LIB/Execution.pa`) *and* the
`behavior:` S-expression it corresponds to. The `behavior:` form is what the rest
of MDS consumes.

Its value domain is **unbounded mathematical integers**. There is no bitvector
type. Width appears only at explicit coercion sites — `SX.32`, `ZX.64`, `SAT.16`,
`F2I.64`, `I2F.64`, `APPLY.32.<helper>` — and nowhere else. `ADD`, `MUL`, `SHL`
and friends are arithmetic on ℤ.

Three value types: `Integer` (ℤ), `Boolean`, and `BitField` (an opaque bit pattern
of known width, produced by `LOAD` and `I2F`, consumed by `STORE` and `F2I`).
Floating-point values live in `BitField` and in `Integer`; there are no FP
primitives (see §4).

Effects are commands, and **every state-touching command carries a pipeline stage**:
`STORE.<stage>`, `LOAD.<stage>`, `COMMIT.<stage>`, `ACCESS.<stage>`, `THROW.<stage>`,
`EFFECT.<stage>`, `PROBE.<stage>`. State is addressed through `Location` —
`(AGGL|AGGB <storage> <address> <extent>)` — an endian-explicit aggregate of
`extent` cells of the named storage (a register file or memory).

The implementation is a fixed 256-bit box: `Behavior::CodeGen` emits C over an
`Int256_` type (`Int256_add`, `Int256_sx`, `Int256_zx`, `Int256_mul`, …). The
unbounded semantics is therefore a *claim* about the description, not a property
of the implementation — see §5.

Consumers: `BE/LAO` (compiler back-end, `Behavior.tuple`), `BE/GEM5` (the ISS —
`Behavior.tuple` becomes the fetch/execute/commit bodies of the gem5 port),
`BE/AVP` (test generation), `MDD/MDE` (operand access/commit expansion).


## 2. Where it stands

**Behavior is not outdated.** Its central design choice — unbounded mathematical
integers with width only at explicit coercions — is the same choice **Sail**
(Cambridge) and **ASL** (Arm's Architecture Specification Language) both made,
independently and after considerable experience. Sail's `int` is a mathematical
integer; its C back-end holds it in a GMP `mpz_t` and runs a range-analysis pass
to unbox to `int64_t` where it can prove the bound. Behavior made the same call
and chose a cheaper representation for the job: a fixed 256-bit box, no allocator,
no boxing, adequate because a datapath is bounded.

So the question is not whether Behavior is behind the state of the art. It is what
the state of the art has that Behavior does not, and whether that is worth a switch.

### What Sail and ASL have that Behavior does not

- **Static width checking.** Sail's `bits('n)` is length-indexed: a width mismatch
  is a type error before anything runs. Behavior has no bitvector type and, until
  now, no width analysis at all — the two bounds checks in the code generator
  (`Behavior.pa`, `codegen_read`/`codegen_write`) were commented out. Width bugs
  surfaced as wrong simulation or not at all. *This is the gap §5 closes.*

- **Formal semantics.** Sail emits Isabelle/HOL4/Coq/Lem definitions and SMT (via
  Isla) alongside its C emulator, which buys symbolic execution, ISA-Formal-style
  bounded model checking of RTL against the spec, and memory-model reasoning.
  Behavior is a code-generation IR: there is nothing to prove *about*, only C to run.

- **Ecosystem and standing.** The Sail RISC-V model *is* the ratified RISC-V
  specification. Arm's ASL *is* the Arm ARM. Sail additionally hosts Armv8/v9
  (machine-translated from Arm's internal ASL), CHERI, Morello, MIPS and x86.

- **Floating point in-language.** Sail specifies IEEE 754 in Sail. Behavior does
  not specify it at all (§4).

- **A memory model.** Sail + Isla + RMEM give concurrency semantics. Behavior's
  memory is the `MEM_load`/`MEM_store` helpers.

### What Behavior has that Sail and ASL structurally do not

- **Stage-annotated, bundle-parallel semantics.** Every state access carries a
  stage, and `CodeGen` splits each instruction into `fetch`/`execute`/`commit`
  phases. That is precisely what a VLIW needs: every instruction in a bundle reads
  architectural state before *any* of them writes it, and different instructions
  commit at different pipeline stages. **Sail and ASL are sequential-ISA languages.**
  No bundle, no stage-indexed state, no read-all-then-write-all discipline. LVX can
  be encoded in Sail, but the bundle sequencer and the shadow register file become
  hand-written scaffolding around it — automating the easy half and hand-rolling
  the part Behavior already provides.

- **Integration with the rest of MDS.** Behavior shares `Proxy`, `RegClass`,
  `Stage` and `Storage` with the encoding and scheduling descriptions. One source
  drives GAS, GCC, GDB, LAO's reservation tables, the LaTeX manual *and* the ISS.
  Sail describes semantics and nothing else: no encoding tables for an assembler,
  no reservation tables for a scheduler. Replacing Behavior with Sail does not swap
  a component — it amputates one and orphans it from the other five back-ends.

### The rest of the field

The true peers of **MDS as a whole** (not of Behavior the language) are the
commercial ADLs: **Synopsys ASIP Designer** (nML) and **Codasip CodAL**, which
generate ISS, compiler and RTL from one description. **LISA** (CoWare → Synopsys
Processor Designer) and **ArchC** are the academic ancestors and are effectively
dead. **SLEIGH/P-code** (Ghidra) is retargetable but its semantics are
decompiler-grade approximations with no exception or system model, so it is not a
candidate. Against that field MDS is a credible member of the category, and
Behavior is the most defensible part of it.

### Conclusion

**Do not migrate to Sail.** Instead, **add a Sail emitter as another MDS back-end**,
next to GEM5 and LAO. MDS stays the single source of truth and gains a formal
reference model, symbolic execution via Isla, differential testing of the gem5 ISS
against a Sail-generated C emulator, and a publishable machine-readable LVX spec.
The Behavior → Sail translation is close to mechanical for the arithmetic core;
the stage/bundle model becomes an explicitly *generated* bundle sequencer in Sail.


## 3. Where the Int256 box was load-bearing

Two places where the unbounded-integer semantics was not actually unbounded — the
description's meaning depended on the container being exactly 256 bits, and said so
nowhere. Both were found by the width pass. **The second is now fixed; the first is
not.**

**`SHR` is a logical shift, and this is still true.** It generates `Int256_shru`,
so on a negative operand the result is `(x mod 2²⁵⁶) >> n` — not a function of `x`
alone. The ISA *relies* on this: `sraw` is `(SHR (SX.32 x) n)`, and its low 32 bits
come out right only because the sign extension runs all the way to the top of the
container and the store truncates back. Correct, and box-dependent. 25 instruction
families do it (`sraw`/`srad`/`srsw`/`srsd`/`avgw`/`avgrw`/`extfs`/`sxbd`/`sxhd`/
`sxwd` and the packed forms), and `Width.pm` reports each as `shr-negative`. Worth
either renaming the operator to say what it is (`SHRU`) or defining `SHR` as
arithmetic and adding a separate logical form. **Until then, the container width is
part of the architecture.**

**Byte-lane placement overflowed the box on purpose — now it says so.** The `lvx_v2`
extension preloads (`xplb`/`xplh`/`xplw`/`xpld`/`xplq`/`xplo`) and
`xaccesso`/`xaligno` place a byte mask at a variable offset inside a 256-bit `XVR`:

```
new shift = (target & 31) * 8;                    /* 0 .. 248 */
new targetbytes = bits2bytes(bytemask) << shift;  /* up to 2^504! */
result1 = ((result1 << shift) & targetbytes) | (argument1 & ~targetbytes);
```

`bits2bytes` is declared `APPLY.256`, so shifting it left by up to 248 needs 504
bits. `Int256_shl` dropped them, which is what made the instruction behave
correctly — the bytes that fall off the top of the register are *meant* to fall off.
**The truncation was the semantics, and the description did not mention it.**

Every one of those sites now carries an explicit `ZX.256` (and `_ZX_256` on the
`execution:` side), so the description states the truncation it depends on instead
of leaving it to the container:

```
new targetbytes = _ZX_256(bits2bytes(bytemask) << shift);
result1 = (_ZX_256(result1 << shift) & targetbytes) | (argument1 & _ZX_256(~targetbytes));
```

The generated ISS C is unchanged in meaning — `Int256_zx(x, 256)` is the identity
on the container, and width-256 coercions were already being emitted (323 of them),
so this asks nothing new of the runtime. What changed is that the *description* is
now true on its own terms, which is what makes a Sail export (§2) possible at all.

Note `~targetbytes` needed the same treatment, for a subtler reason: on a value
that uses all 256 bits, the mathematical `~x = -x-1` is not representable
(`~(2²⁵⁶-1) = -2²⁵⁶`), because a bitwise complement of an unbounded integer has no
meaning without a width. `ZX.256(NOT x)` supplies the width.


## 4. Floating point: why the helpers are the real gap

`APPLY.32.f32_add`, `APPLY.64.f64_mul`, and ~100 other named operators are **opaque
calls to hand-written C**. `BE/GEM5`'s template says it plainly: *"For now every
helper is a panic stub"* — 137 of them, the SIMD/float/atomic operators.

This is where the ISS-retargeting automation leaks. The arithmetic core retargets
beautifully; the floating-point, SIMD and atomic semantics — the hard, error-prone
part — are not in the description at all, so every new ISS target re-implements
them by hand. Automating the retarget and then hand-writing 137 helpers per target
is most of the work one was trying to avoid.

### Why an off-the-shelf soft-float library cannot be dropped in

Two reasons, and both are specific to this ISA:

1. **Per-lane IEEE flags under SIMD lane masking.** Berkeley SoftFloat raises
   exceptions by setting `softfloat_exceptionFlags`, a **global**. The architectural
   rule is *"CS accumulates the OR of the flags raised by the **active** lanes"* —
   a global mutable accumulator cannot express that compositionally, and saving and
   restoring it around every lane is both slow and a semantic mismatch. This gets
   worse, not better, with the 128-bit SIMD instructions planned for `lvx_v2`.

2. **Non-standard arithmetic in the machine-learning operators.** The exact
   dot-product add operators (ARITH) form the products exactly, align them, sum
   with no intermediate rounding, and round **once** at the end. SoftFloat rounds
   every operation and exposes no accumulator. It cannot express this at all.

### Both of these argue *for* putting FP into Behavior, not against it

**The flag problem is an artifact of SoftFloat's API, not of the semantics.** The
fix is to make FP operators **flag-returning rather than flag-mutating**: an
operator yields *(result, flags)* as a value, and masked accumulation becomes
ordinary data flow. This is exactly what Sail's RISC-V model does — its soft-float
interface returns `(fflags, value)` pairs rather than touching a global — and Arm's
answer for SVE predicated FP is the same in spirit: FPSR is only updated from
active elements.

**And Behavior needs no grammar change to do it.** Because the value domain is
unbounded integers and `Section` slicing already exists, a flag-returning operator
is just an operator that returns a *wider* integer, with the caller extracting
fields:

```
(FOR.I (RANGE.4)
  (SEQ
    (WRITE.T (APPLY.64.f32_add                    ; 32[0] = result, 32[1] = flags
      (READ.RM)
      (READ.32[(INDEX.I)].argument2)
      (READ.32[(INDEX.I)].argument3)))
    (WRITE.32[(INDEX.I)].result1 (READ.32[0].T))
    (WRITE.CS (IOR (READ.CS)
      (SELECT (TEST.lane_active (INDEX.I))
        (READ.32[1].T)
        (CONST.0))))))
```

Note the *result*-side masking is already solved: `COMMIT.<stage>.<proxy> <int> <mask>`
and `STORE.<stage> <location> <field> <mask>` both carry a mask. The flags were the
only thing with nowhere to go, and unbounded integers give them somewhere for free.

**Exact accumulation is the argument for Behavior, not against it.** An exact
dot-product add is by definition arithmetic on integers wider than any lane. That
is the semantic domain Behavior already commits to. SoftFloat cannot express it;
Sail cannot express it natively either (its FP is IEEE-shaped and delegates to a
soft-float-derived spec, so a novel ML operator lands there as another opaque
primitive). Written in Behavior, an exact dot product is mantissa/exponent
decomposition (`AND`/`SHR`/`Section`), exact integer products, exponent alignment
(`SHL`), exact accumulation, and a single final rounding — and it is exact **by
construction in the specification**, independent of the implementation's box size.

**Which raises the question §5 exists to answer: is 256 bits provably enough?**
A full Kulisch accumulator for binary32 needs on the order of 550 bits. The LVX
operators are implementable in hardware, so they must bound the alignment window —
and *that bound is part of the architecture and belongs in the specification*. If
Behavior's integers are the mathematical ones and `Int256_` is the implementation,
then "256 suffices" is a theorem about every operator, and until now nothing
checked it.

SoftFloat still has a job, just not this one: as a **differential-test oracle** for
the IEEE-conforming subset (single lane, unmasked, standard operations) it is cheap
to wire up and will catch real bugs in the Behavior FP specifications. It is a
check on the semantics, not the semantics itself.


## 5. The static width checking pass

`MDS/LIB/Width.pm`, run from `MDS/MDD/MDE/BIN/Opcode.pl` on each opcode's Behavior
tree immediately after `Expand` — that is, on exactly the tree that is written to
`Opcode.table` and that `BE/LAO/BIN/Behavior.pl` later hands to `CodeGen`. What the
pass sees is what becomes C.

It is an abstract interpretation over **integer intervals** (`Math::BigInt`), not a
bit-width lattice: intervals are what answer the accumulator question, and they get
the sign cases right without the off-by-one traps that plague power-of-two bounds.
See the module's own header for the rules.

Two properties of the container have to be checked, and conflating them is a
mistake (this pass made it first, and it produced 22 false alarms):

- **representable** — the 256 bits are all there, so the value can be recovered.
  Values are identified mod 2²⁵⁶, so the interval must span fewer than 2²⁵⁶ values
  *and* sit inside [−2²⁵⁵, 2²⁵⁶−1], the union of the signed and unsigned readings
  of the same bits. A full-width unsigned datum — `F2I.256` of a 256-bit `LOAD`,
  which is how `lo` and `copyo` move an octuple — **is** representable. Nothing is
  lost; it is simply not a signed number.
- **signed** — the value can additionally be *read* as signed, which the operators
  that inspect the sign require (`Int256_cmp` orders sign-extended values;
  `Int256_div`, `Int256_sat`, `Int256_cls`, `abs`, `neg` all read the top bit). A
  wide unsigned value fed to one of those is *misread*, not truncated. `SX` and
  `ZX` do **not** belong here: they reinterpret bit *w−1*, not the container's.

| Diagnostic | Fatal | Meaning |
|---|---|---|
| `box` | yes | A value does not fit the 256-bit container and no coercion says it should be truncated, so `Int256_` truncates it silently. |
| `signed` | yes | A sign-reading operator is applied to a value outside the signed 256-bit range, so `Int256_` misreads it. |
| `section` | yes | A `Section` access (`w[i]`) reaches past the end of the container: `w × (i+1) > 256`. These are the two `die`s that were commented out in `codegen_read`/`codegen_write`. |
| `extent` | yes | A `STORE`'s `BitField` width disagrees with the width its `Location` implies, or an `F2I.w` disagrees with the `BitField` it reads. |
| `shr-negative` | no | `SHR` on an operand not provably non-negative — box-dependent, §3. |
| `read-partial` | no | A variable read on a path where it was not written. |
| `read-unknown` | no | A variable read with no reaching `WRITE` at all. |

**The fatal set is clean on the current ISA, so any new violation fails the build.**

An overflow that is then *truncated* is not reported, and must not be: the ring
operations (`+ - * << & | ^ ~`) commute with truncation, exactly as C's unsigned
arithmetic does, so `ZX.256(SHL(x, n))` is precisely what `Int256_shl` computes even
though the mathematical `x << n` needs 504 bits. The pass tracks a *truncation
context* down through the ring operators and stops at the ones that read the value
rather than its low bits (`SHR`, `DIV`, comparisons, the bit counters). This is what
makes an explicit `ZX.256` an actual fix rather than decoration.

Likewise it does **not** flag truncation into a narrower container (`I2F.64` of a
65-bit sum). Wraparound at the destination width is how the ISA is defined — `addw`
really does compute a 65-bit sum and keep 64 bits — so flagging it would be noise. A
lint for *unintended* truncation would need an annotation to tell the two apart.

### What it found, and what is left

| | first run | now |
|---|---|---|
| `box` | 840 (8 `lvx_v2` instructions) | **0** — the truncation is written down (§3) |
| `apply-nowidth` | 44 | **0** — the width is mandatory (below) |
| `shr-negative` | 89 | 89 — real, unfixed (§3) |
| `read-partial` | 156 | 156 — benign (below) |
| `read-unknown` | 1 | **1** — a real bug (below) |

- **`APPLY` now requires a width.** The widthless production was removed from
  `DOC/Behavior.y`, so a helper that does not declare its result width is a syntax
  error rather than a value nothing can bound. That flushed out nine helpers:
  `insert_64`/`insert_128` (256 — they return the `XVR` they insert a lane into),
  `get`/`wfxl`/`wfxm`/`waitit` (64 — an SFR), `check_float_rounding_mode_trap` (1 —
  a predicate), and, tellingly, **`f32_add` and `f32_sub` in `faddwc`/`fsbfwc`**
  (32). The FP gap of §4 was not only missing bodies: two FP operators did not
  declare how wide their result was. `lvx_v1`'s generated C is byte-identical after
  this — `APPLY`'s width never reached `CodeGen`, it only ever reached the checker.

- **`read-unknown` is a real bug, left unfixed on purpose.** `FNARROWDWQ` reads
  `ziplanes`, but its format `ALU_FWQWR` declares the `ziplanes` encoding field and
  then **omits it from `operands:`**, using the `GWRF` behavior (which never writes
  it) instead of `GWRFL` (which does). Its half-word twin `ALU_FHQWR`/`FNARROWWHQ`
  does it right. So `fnarrowdwq` reads an uninitialised variable, the encoding bit
  is not decodable as a modifier, and nothing anywhere fails. Copy-paste, caught on
  the pass's first run. Fixing it changes the opcode table, and `lvx_v2` is not
  finished, so it waits.

- **`read-partial`** is mostly benign: `product` in every `mul`/`madd` is written
  under three guards (`widemult == 0/1/2`) that are exhaustive over the legal
  modifier values, which the analysis cannot know. Worth knowing, not worth fixing.


## 6. What to do, in order

**Done.**

0. **Static width checking** (§5). The pass that *verifies* the 256-bit
   implementation is sound for every operator — including the ML operators not yet
   written. It is also the prerequisite for everything below: Sail's type checker
   will reject width-sloppy code, so the work has to be done regardless, and doing
   it inside Behavior first means finding the bugs on home ground.

1. **`APPLY`'s width is mandatory** (§5). A helper that does not say how wide its
   result is cannot be bounded, and nothing downstream of it can be checked.

2. **The byte-lane truncation is written down** (§3). `ZX.256` where the `lvx_v2`
   extension instructions used to rely on `Int256_shl` dropping what overflowed.

**Next.**

3. **Close the helper gap** (§4). Make FP operators flag-returning, and specify the
   FP and SIMD semantics in Behavior rather than in per-target C. This is the actual
   bottleneck for ISS retargeting, and it is independent of any Sail decision. Start
   with the exact dot-product operators — they are the ones no library can give you,
   and they are the ones the width pass can now prove fit, or not.

4. **Fix `SHR`** (§3) — the last place the container width leaks into the meaning of
   the description. Rename it to say it is logical, or define it as arithmetic and
   add a separate logical form.

5. **Fix `ALU_FWQWR`** (§5), once `lvx_v2` is settled enough for the opcode table to
   move.

6. **Add a Sail emitter as a back-end** (§2). Not a migration. A model whose FP is
   defined in terms of integer arithmetic exports to Sail *better* than an
   IEEE-primitive model would, because there is no primitive to map. In practice
   this is gated on (3) and (4): a box dependence does not survive translation to a
   language whose integers really are unbounded.
