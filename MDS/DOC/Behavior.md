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
nowhere. Both were found by the width pass. **Both are now fixed.**

**`SHR` is an arithmetic shift, container-free.** It used to be emitted as
`Int256_shru`, so on a negative operand the result was `(x mod 2²⁵⁶) >> n` — not a
function of `x` alone. `sraw = (SHR (SX.32 x) n)` came out right only because the
sign extension ran to the top of the container and the store truncated back:
correct, but box-dependent, and the 16 `sraw`/`srad`/`srsw`/`srsd`/`avgw`/`avgrw`/
`extfs`/`sxbd`/`sxhd`/`sxwd` sites were reported `shr-negative`. Resolved by
**operand inference** (see `DOC/SHR-split.md`): `SHR` is now `floor(x/2ⁿ)`, a total
function of the value, emitted as `Int256_shr` for a signed operand and
`Int256_shru` for a non-negative one — which agree on the demanded bits, and on a
non-negative operand arithmetic *is* logical. `Width.pm`'s interval is the exact
arithmetic range for every operand, so `shr-negative` is gone and the container
width no longer enters the shift's meaning. Behaviour-preserving: the lvx_v1
differential test is 0/870 old-vs-new and boxed-vs-unboxed. A second explicit
`SHRU` operator was considered and rejected as buying only readability, not
capability (`SHR-split.md`, "Do we need `SHRU`").

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


## 5. The width analysis

`MDS/LIB/Width.pm`, run from `MDS/MDD/MDE/BIN/Opcode.pl` on each opcode's Behavior
tree immediately after `Expand` — that is, on exactly the tree that is written to
`Opcode.table` and that `BE/LAO/BIN/Behavior.pl` later hands to `CodeGen`. What the
pass sees is what becomes C.

It has two halves, which answer different questions.

**Forward: an abstract interpretation over integer intervals** (`Math::BigInt`), not
a bit-width lattice — intervals are what answer the accumulator question, and they get
the sign cases right without the off-by-one traps that plague power-of-two bounds.
This says *how big a value can be*. It is what the checks below are built on.

**Backward: a demanded-width analysis.** This says *how many of a value's low bits
anyone actually looks at*, and it is not optional — the forward intervals alone cannot
type the commonest expression in the ISA. `addw`'s `ADD` of two 64-bit registers is
`[0, 2^65-2]`, which fits no native C type, yet the store keeps only its low 32 bits,
so a 32-bit add would do. A node whose demand is *d* can be computed in any *d*-bit
type whatever its interval, because the ring operations agree with the true result on
their low *d* bits. So the usable width of a node is

```
    min(bits its interval needs, bits anyone demands)
```

and for `addw` that is `min(66, 32) = 32`. It runs over commands in reverse and
top-down within expressions, and it **crosses variables** — which the forward
truncation context deliberately does not. The load-bearing rule is one line: a `STORE`
of `I2F.w` wants exactly *w* bits of what it stores.

Helper arguments demand everything. That is sound and, measured, nearly free — §6
settles a design question there that looked much more open than it was.

Both halves are published in each Integer's `Abstract`; see §6.

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

- **`read-unknown` is a real bug, and it is worse than "nothing anywhere fails".**
  `FNARROWDWQ` reads `ziplanes`, but its format `ALU_FWQWR` declares the `ziplanes`
  encoding field and then **omits it from `operands:`**, using the `GWRF` behavior
  (which never writes it) instead of `GWRFL` (which does). Its half-word twin
  `ALU_FHQWR`/`FNARROWWHQ` does it right. Copy-paste, caught on the pass's first run.

  What was not known when that was written: **`lvx_v2`'s generated C does not compile.**
  A variable is declared from the `WRITE`s to it, so one that is only ever *read* is
  never declared at all — `ziplanes` in `FNARROWDWQ`, and `argument3` in the four
  `CMOVE*` forms, which is a second instance. 16 opcodes, 9 undeclared variables, and
  the boxed C fails exactly as the unboxed C does. It is not a latent wrong answer; it
  is a build failure the moment anyone targets `lvx_v2`'s ISS, and that nobody had hit
  it is the evidence that **the `lvx_v2` tuple has never been compiled** — `BE/GEM5`
  rides on `BE/LAO` for `lvx_v1` only. `BE/LAO/TEST/harness.c` declares both as
  file-scope zeros so the two generations can be compared at all; that is a scaffold,
  not a fix. Fixing it properly changes the opcode table, so it still waits — but it is
  a blocker for `lvx_v2`, not a curiosity.

- **`read-partial`** is mostly benign: `product` in every `mul`/`madd` is written
  under three guards (`widemult == 0/1/2`) that are exhaustive over the legal
  modifier values, which the analysis cannot know. Worth knowing, not worth fixing.


## 6. The abstract values, and unboxing the ISS

The grammar attaches an **`Abstract`** to every Integer — `(*key:value,...*)`, parsed
straight back into that node's attribute hash — and it was designed to hold exactly
what §5 computes. It now does:

```
(WRITE.result1
  (ADD
    (READ.argument3(*dm:32,hi:18446744073709551615,lo:0*))
    (READ.argument2(*dm:32,hi:18446744073709551615,lo:0*))(*dm:32,hi:36893488147419103230,lo:0*)))
```

`addw`'s sum can reach 2⁶⁵−2, and only 32 bits of it are ever looked at. Both facts
are now *stated* in the description instead of implied.

This is not decoration. The analysis runs in `MDD/MDE`, but `CodeGen` runs later in
`BE/LAO` — **in a separate process, which re-parses the tree from `Opcode.table`** — so
the abstract values either travel through the table or every back-end recomputes them.
`Pretty`'s `$print_attributes` is therefore a key *filter* (a HASH ref publishes only
the named keys): the attribute hash also carries the internal `TYPE`/`WIDTH`/`REPR`, and
emitting those on every node would bloat the tables for nothing. A demand of 256 is
suppressed (it says every bit is looked at, which is the default) and `CONST` carries
no interval, its value being right there.

### The type map

With both halves of §5, and with `METHOD` bounded — an operand's *encoded* value, which
for a register operand is an index into its file, `[0, 63]` for a GPR, something
`Behavior::yyinit` already knew:

| | forward only | + backward demand | genuinely needs `Int256_` |
|---|---|---|---|
| `lvx_v1` | 89.1% | **92.8%** | 7.2% |
| `lvx_v2` | 81.1% | **83.3%** | 16.7% |

So **93% of `lvx_v1`'s Integer nodes could be computed in a native C type.** Today
every one of them is an `Int256_` — which in Kalray's implementation (`kvx-lao`,
`LAO/CDT/BSL/Int256.c`) is a **32-byte union passed by value**, whose `Int256_add` is a
four-limb `do`/`while` with branchy carry propagation, while `Int256_toUInt64` is just
the low limb. Unboxing a 64-bit add replaces a branchy loop with one instruction and
pays almost nothing at the boundary. That is where an ISS's speed lives.

### Helper argument widths were not the missing piece

It looked as though the backward analysis needed to know how many bits of each
`APPLY`/`EFFECT` argument a helper actually uses — whether by annotating call sites with
`Section` (`(READ.64[0].x)`) or by declaring helper signatures. Measured, it needs
neither: **86% of helper arguments are already bounded by the coercion that produced
them**, and the 290 that are not are genuinely 256-bit (XVR octuples, 128-bit products),
which no declared width could narrow either. Treating every helper argument as ⊤ is
sound and costs almost nothing.

Do **not** overload `Section` for this. It means "lane *i* of a vector" — a fact about
data layout, not about the consumer. It cannot express signedness. It must be repeated
at all 705 call sites and is checkable at none. And, decisively, `(READ.64[0].x)` does
not *annotate* a demand — it **truncates**, changing the value. Using it as an
optimisation hint would smuggle implicit truncation back into the description, right
after §3 got it out.

**Helper signatures are worth having — for the calling convention, not the analysis.**
Every helper takes and returns `Int256_`, and there are ~5000 helper calls in `lvx_v1`
alone. Declared argument widths would let the generator emit

```c
uint32_t HELPER(f32_add)(void *this, uint8_t rm, uint32_t a, uint32_t b);
```

instead of four 32-byte unions. That boundary is a bigger prize than the arithmetic,
and it is what would make the hand-written shim and soft-float code natural to write
instead of forcing every implementer through `Int256_toUInt32` — which bears directly
on the flag-returning FP operators and the exact dot product of §4. It is also the
symmetric completion of the mandatory `APPLY` result width: `APPLY.32.f32_add` declares
its result and says nothing about its operands.

### The rule is not uniform across operators, and that is the trap

`min(rep, dm)` is not sound as a blanket rule, and the operator it breaks on is the
one §3 already singles out. **`SHR` is not a ring operation.** The justification for
typing a node by its demand — that the ring operations agree with the true result on
their low *d* bits — is exactly the property `SHR` does not have: it reads the value,
not its low bits. `Width.pm`'s own `_shr` says so, giving up and returning the
interval of a logical shift of the whole container whenever the operand is not
provably non-negative.

So `sraw`'s `SHR` node carries `dm:32` over an interval of `[0, 2^256-1]`, and
`min(rep, dm)` makes it a `uint32_t`. But a `uint32_t` `>>` is a **logical** shift,
while the semantics is a logical shift of the value *sign-extended across the
container*, whose low 32 bits are an **arithmetic** shift. For `x = 0x80000000`,
`n = 4` that is `0x08000000` against the correct `0xf8000000` — which is the identity
`shru(sx(-2^31,32),4)` that building the oracle demonstrated in the first place. All
89 `shr-negative` sites (`sraw`/`srad`/`srsw`/`srsd`/`avgw`/`extfs`/`sxbd`/…) break,
silently, and only in the sign bits. It is precisely the bug the trace hash was
folded over all four limbs to catch.

The fix is not to box `SHR`. It is to **type it by its demand and emit an arithmetic
shift whenever its operand's reading is signed**, which is sound for a reason worth
stating: `_dexpr` demands `d + shift` bits of that operand, so the operand's width is
its interval's — it is *exact* — and sign-extending an exact value to any width
recovers the true value. `Int256_shr`, a true arithmetic shift, already exists in the
runtime for the boxed case.

Every other value-reading operator (`DIV`/`REM`/`MOD`, the comparisons, `MIN`/`MAX`,
`SAT`, the bit counters) gets exact operands for free, because `_dexpr` demands the
whole value from them and `min(rep, dm)` is then `rep`. `SHR` is the only one whose
operand demand is finite, and so the only one that has to be reasoned about.

### Helper arguments *are* the missing piece for the hot path

Measured against the published abstract values: **94.7%** of `lvx_v1`'s 16,993 Integer
nodes are unboxable, and the 903 that are not are not what this section predicted.
**286 are `ADD`, and roughly half of those are boxed for one reason: a helper argument
demands ⊤.** The exemplar is every branch:

```
(WRITE.address (ADD (F2I.64 (LOAD PC)) (READ.argument1)))  ; a 66-bit interval
(STORE.0 (AGGL.NPC …) (I2F.64 (READ.address)))            ; demands 64  ✓
(EFFECT.0.branch_info (CONST.1) (READ.address))           ; demands 256 ✗
```

`address` is a program counter. The `STORE` already writes the truncation down — the
emitted C says `Int256_zx(address, 64)`. Only `branch_info` wants all 256 bits, and
it plainly does not. Declaring helper argument widths takes unboxing to **96.5%** and
halves the boxed `ADD`s (286 → 144).

So the claim above — that the unbounded helper arguments "are genuinely 256-bit (XVR
octuples, 128-bit products), which no declared width could narrow either" — is wrong,
and the measurement that produced it was misread: `_swidth` is minimal *signed* width,
so an ordinary `[0, 2^64-1]` argument reports as **65 bits** and looks unbounded. Strip
that artifact and the genuinely wide set is small and specific — the `MEM_*` load and
atomic data arguments, `get`/`wfxl`/`wfxm`/`*_check_access`, and `intcomp_128`. Every
`f32_*`/`f64_*`/`intcomp_32`/`intcomp_64` argument is an ordinary 64-bit value.

Helper signatures are therefore not only for the calling convention. On the hot path —
branches and addresses — they are load-bearing for the arithmetic too. The code
generator consults a helper-argument width table for this reason; it defaults to ⊤, so
declaring the widths later is a data change rather than another rewrite.

### How the codegen change is to be verified

`MDS/BE/LAO/TEST/`. Every helper is replaced by a deterministic pure function of its
arguments and every call folded into a trace hash, so an opcode's trace is a function
of its inputs *and of every value the behaviour computed on the way*. Generate
`Behavior.tuple` two ways, run all 870 opcodes, compare the traces. The oracle is
Kalray's real `Int256_` arithmetic, fetched from `kvx-lao` and built by
`extract-int256.sh`. No ISS, no gem5, no architectural model needed.

It is mutation-tested, because a test that cannot fail is worth nothing: `Int256_add` →
`Int256_sub` changes 347 of the 870 traces; a coercion width of 64 → 63 changes 666;
8 → 7 changes 48. Wrong arithmetic and wrong width both show up, and the trace folds all
four limbs of every `Int256_`, so a bug that corrupts only the high 192 bits — precisely
what a careless unboxing does — cannot hide.

Building the oracle also *demonstrated* two things §3 and §5 had only argued.
`Int256_add(2^64-1, 2)` has `toUInt64 == 1`, exactly what a `uint64_t` add gives — the
ring operations really do commute with truncation. And `shru(sx(-2^31,32),4)` has low 32
bits `0xf8000000 == ((int32_t)0x80000000) >> 4`, which is the `sraw` idiom of §3.

One incidental find: **`Int256_shr` — a true arithmetic shift — already exists in the
runtime.** The `SHR` fix of §3 needs no new runtime support.


## 7. What to do, in order

**Done.**

0. **The width analysis** (§5), forward and backward. It *verifies* that the 256-bit
   implementation is sound for every operator — including the ML operators not yet
   written — and it is the prerequisite for everything below. Sail's type checker will
   reject width-sloppy code too, so the work has to be done regardless, and doing it
   inside Behavior first means finding the bugs on home ground.

1. **`APPLY`'s width is mandatory** (§5). A helper that does not say how wide its
   result is cannot be bounded, and nothing downstream of it can be checked.

2. **The byte-lane truncation is written down** (§3). `ZX.256` where the `lvx_v2`
   extension instructions used to rely on `Int256_shl` dropping what overflowed.

3. **The abstract values are published** (§6), and there is a differential test for
   the generated C, with Kalray's real `Int256_` as its oracle.

**Next.**

4. **Unbox `CodeGen`** (§6) — *in progress*. 94.7% of `lvx_v1`'s Integer nodes could be
   a native C type; all of them are a 32-byte union today. The type map is in the table,
   the safety net is in `BE/LAO/TEST/`.

   The type model (`ctype`/`cconv`/`codegen_operand` in `LIB/Behavior.pa`) is in, behind
   `$Behavior::Unbox` (`BEHAVIOR_UNBOX=1` on `BE/LAO`). With the gate off the generator is
   byte-identical, which is the checkpoint the rest is built on. `%CodeGen_Native` names
   the operators whose native emission is implemented — it must name *exactly* those, since
   `ctype` is what consumers believe and the emission is what they get, and a name without
   a matching case is a type lie the C compiler will not catch. Anything not named there
   stays an `Int256_` and has its operands converted at the boundary, so the rest can land
   one operator at a time rather than in one leap.

   **Done: the coercions (`SX`/`ZX`/`F2I`), `CONST`, `READ` with variable typing, `SHR`, the
   ring operations, `SELECT`, `METHOD`, the comparisons, `MIN`/`MAX` and the bit counters.**
   All 870 traces identical. `SAT`/`SATU`/`ABS`/`DIV`/`MOD` are left boxed: 96 sites between
   them, and the natural native form duplicates the operand in a ternary, which would change
   the sequence of helper calls inside it for nothing.

   On `lvx_v1`, **the arithmetic goes 5957 → 1243 (−79%)**: 3646 `Int256_` variables become
   1072, `Int256_cmp` and `Int256_sx` go to 0 and 1, `Int256_shl` 424 → 6, `Int256_zx`
   3364 → 748.

   **But that is not the whole cost, and the rest of it is the point.** Unboxing moves work
   to the boundary, and the boundary grew:

   | | boxed | unboxed | |
   |---|---|---|---|
   | arithmetic (four-limb loops, 256-bit shifts, `cmp`) | 5957 | **1243** | −4714 |
   | `Int256_toUInt64` | 0 | 2861 | +2861, and free — it is the low limb |
   | `Int256_from*64` | 1767 | **3573** | +1806, and *not* free — it builds a 32-byte union |

   Taking a value out of the container costs nothing; putting one back costs four limb
   stores. There are **4438 helper call sites** and every helper still takes and returns
   `Int256_`, so every native value that reaches one is re-boxed. That is where the +1806
   live. The trade is still strongly positive — a four-limb branchy `do`/`while` add for a
   union construction — but **the unboxing is only half-cashed until helpers have narrow
   signatures**, which is (6) below.

   `Int256_add` barely moves (362 → 286) for the same reason, and it is the branch-address
   story above: those 286 are boxed because a helper argument demands ⊤. Both facts point at
   the same fix, from opposite ends — declared helper widths would unbox the branch ADD *and*
   delete the re-boxing at the call. **(6) is no longer a nicety after (4); it is what makes
   (4) pay.**

   It is **not** the mechanical change this section originally called it. Three things had
   to be reasoned about rather than transcribed:

   - **`SHR`** breaks the blanket rule (§6). The emitter takes the shift's signedness from
     its *operand*, which is sound only because that operand is exact — `ctype` boxes the
     `SHR` when it is not. Forcing the shift logical (the careless unboxing) diverges
     `SRAW`/`SRAD`, which is the check that the arithmetic-shift path is live.
   - **C's integer promotions.** `uint8_t` and `uint16_t` promote to *`int`*, and a 16×16
     `MUL` overflows it — signed overflow being undefined where the boxed code had none. A
     ring operation is therefore computed in at least 32 unsigned bits and truncated back,
     which is free: its low *W* bits depend only on its operands' low *W* bits.
   - **Shift amounts.** `x << n` is undefined in C once *n* reaches the width of `x`, where
     `Int256_shl` merely shifts everything out and gives zero. The shift is done in a type
     wide enough for the largest amount, and boxed when no native type is.

   **Verified on both cores: `lvx_v1` 0/870, `lvx_v2` 0/1453.** `lvx_v2` matters more than its
   size suggests — it is where the 256-bit `XVR` octuples, the 128-bit products and the
   byte-lane instructions of §3 live, so it has roughly twice the boxed nodes. Its arithmetic
   goes 20441 → 4783 and 4042 of its 6886 variables become native.

   Every divergence that ever appeared turned out to be a **bug in the harness, not the
   generator**, and each is worth knowing because each is a way to fool oneself:

   - it derived a read's value from the running trace hash, making it sensitive to C's
     unspecified evaluation order of `a | b` (54 false failures on `lvx_v1`);
   - it fed register operands as a plain `0..63`, which decodes to a *negative* register
     index for most register files (19 more);
   - and it fed operands outside the intervals the description proves for them — `lvx_v2`'s
     `registerGl` is bounded `hi:0`, one register, and is then shifted `<< 6`, so a single
     stray 1 overflows the `uint8_t` the analysis proved sufficient (58 on `lvx_v2`).

   The last is the general lesson, and it cuts both ways: **the operand intervals are not
   decoration, they are a precondition.** They are what licenses the narrow type, so a test
   that steps outside them is not testing the generator, it is testing undefined behaviour.
   `BE/LAO/TEST/genbounds.py` now reads them out of `Opcode.table` and draws every operand
   from its own range. None of the fixes cost the harness any sensitivity.

   The comparisons needed one idea of their own: `Int256_cmp` orders *sign-extended* values,
   so a native comparison has to reproduce the ordering of the mathematical values, not of
   their low bits. Both operands are read in the minimal type holding the **union** of their
   intervals, with the signedness that union demands (`_ctype_join`). That works even when an
   operand is still boxed — its low bits are its value, because a comparison demands the whole
   value and its width is therefore its interval's.

5. **Close the helper gap** (§4). Make the FP operators flag-returning and specify the
   FP and SIMD semantics in Behavior rather than in per-target C. This is the real
   bottleneck for ISS retargeting, and it is independent of any Sail decision. Start
   with the exact dot-product operators — no library can give you those, and they are
   the ones the width analysis can now prove fit the container, or not. Doing (4) first
   is worth it: the narrow prototypes it enables (§6) are what make these helpers
   pleasant to write.

6. **Helpers have a signature** (§6) — *done*. A `Helper` element in `MDD.dtd`, declared in
   `lvx-family/FE/YAML/lvx/Helper.yml`, flowing through `Helper.table` to `Width.pm` in MDE
   (so the demand narrows) and to `CodeGen` in `BE/LAO` (so the prototypes narrow). 130
   helpers declared; a helper with no entry keeps the container, so the migration is
   incremental and a description that declares nothing is byte-identical.

   It does the two things (4) needed, and the second was the point:

   | `lvx_v1` | boxed | unboxed | + signatures |
   |---|---|---|---|
   | `Int256_add` | 362 | 286 | **144** |
   | arithmetic, total | 5957 | 1243 | **1094** |
   | `Int256_from*64` (each builds a 32-byte union) | 1767 | 3573 | **2161** |
   | `Int256_` parameters in helper prototypes | 602 | 602 | **42** |

   `Int256_add` halves, exactly as predicted, because `branch_info` can now say it takes a
   program counter. And the re-boxing that (4) had to pay at 4438 call sites is mostly gone:
   `void HELPER(branch_info)(void *this, uint8_t opnd1, uint64_t opnd2)` where it was two
   32-byte unions.

   **The declarations are of two kinds, and only one of them is a claim.** 107 of the 130 are
   *derived*: the width is the one the values already carry, so the declaration cannot
   truncate and asserts nothing — it buys the calling convention and nothing else. The other
   kind is a statement about the architecture, and there is exactly one of them here: **an
   address and a program counter are 64 bits.** Every `MEM_*` helper takes its address first
   and `branch_info` takes the PC second, and the value handed to them is base + a signed
   offset, which needs 66 bits. The low 64 are what the hardware keeps, and the declaration is
   the description finally saying so — the same unstated truncation §3 found in the byte-lane
   instructions, in the place it actually costs something.

   A declared width is therefore a truncation, and `Width.pm` reports every site where one
   bites (`helper-truncates`, listed under `WIDTH_CHECK=verbose`). On the current ISA the
   only ones are the addresses, which is the check that the claim above is the *only* claim
   being made. It caught two mistakes while this was being written: an argument-numbering
   skew between `Width.pm` and `CodeGen` that landed a declared width on the wrong argument,
   and a handful of derived widths that were silently truncating unbounded values.

   **And a declared width is a claim no test can check for you.** `BE/LAO/TEST` verifies that
   the generator does what `Helper.yml` says (0/870 and 0/1453, boxed against unboxed with the
   same signatures on both sides). It cannot verify that what `Helper.yml` says is true of the
   C the helper is implemented in. That part is review.

7. **Fix `SHR`** (§3) — the last place the container width leaks into the *meaning* of
   the description. `Int256_shr` already exists in the runtime, so this costs nothing
   but the rename and the sweep of the 89 sites.

8. **Fix `ALU_FWQWR`, and the `CMOVE*` `argument3`** (§5), once `lvx_v2` is settled enough
   for the opcode table to move. This is now a **blocker for `lvx_v2`**, not a curiosity:
   its generated C does not compile without them, so no `lvx_v2` ISS can be built at all.

9. **Add a Sail emitter as a back-end** (§2). Not a migration. A model whose FP is
   defined in terms of integer arithmetic exports to Sail *better* than an
   IEEE-primitive model would, because there is no primitive to map. In practice this
   is gated on (5) and (7): a box dependence does not survive translation into a
   language whose integers really are unbounded.
