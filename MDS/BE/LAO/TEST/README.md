# Differential test for the generated Behavior C

`BE/LAO`'s `Behavior.tuple` is the operational semantics of every opcode, compiled
to C over `Int256_`. It is the ISS. When the code generator changes — and the
unboxing pass is about to change it a lot — the question that matters is not
"does it still compile" but **"does it still compute the same thing."**

This answers that, and it needs no ISS, no gem5, and no architectural model.

## How it works

Every helper the generated code calls is replaced by a **deterministic pure
function of its arguments**, and every call is folded into a running trace hash.
Storage reads and operand reads derive from a seed; storage writes, helper
arguments and helper results all go into the trace. So an opcode's trace is a
function of its inputs and of *every value the behaviour computed on the way*.

Generate `Behavior.tuple` two ways, run both, compare the traces — 870 of them for
`lvx_v1`, 1453 for `lvx_v2`. If a value changed anywhere, the trace diverges. The real `Int256_` arithmetic — Kalray's,
from `kvx-lao` — is the oracle for both sides, so the comparison is against the
arithmetic the ISS actually uses, not a model of it.

The operator-helper stubs are generated from the tuple's *own* `BehaviorDeclare(...)`
prototypes (`genstubs.py`), so they cannot drift from what the generator emits. The shim
helpers — the ISS's state interface — are hand-written in `harness.c`, but *which* register
files and storages they cover (`genregs.py`), and the range each operand may take
(`genbounds.py`), are generated too: all three are core-specific, and hardcoding them is
what tied the harness to `lvx_v1`.

## It is known to catch things

A test that cannot fail is worth nothing, so the harness is mutation-tested. Each
of these is a bug an unboxing pass could plausibly introduce:

| mutation to the generated C | lvx_v1 (870) | lvx_v2 (1453) |
|---|---|---|
| `Int256_add` → `Int256_sub` | 348 | 582 |
| the native comparisons flipped | 28 | 60 |
| a `METHOD` register index off by one | 355 | 491 |
| a coercion width off by one | 251 | 503 |
| `SHR` forced logical instead of arithmetic | 4 | — |

The last one is the whole point of the unboxing pass: it is the bug that corrupts nothing
but the sign bits of `sraw`/`srad`, and the trace is folded over all four limbs of every
`Int256_` so that it cannot hide.

## Running it on a core

Everything core-specific is generated from that core's own tables, so the harness is not
tied to `lvx_v1` any more:

```sh
./extract-int256.sh                              # fetch + build Kalray's Int256_ (needs gh)
CORE=lvx_v1                                      # or lvx_v2
B=<build>/BE/LAO/$CORE/Behavior.tuple
python3 genregs.py   $B                          # -> regs.inc, shims.inc
python3 genbounds.py <build>/MDD/lvx/$CORE/Opcode.table   # -> bounds.inc
python3 genstubs.py  $B                          # -> opstubs.inc
cc -O1 -I int256 -I. -DBEHAVIOR_TUPLE="\"$B\"" harness.c int256/rt.o -o harness
./harness > baseline.txt
# ... regenerate Behavior.tuple (BEHAVIOR_UNBOX=1), rerun genstubs.py ...
./harness > candidate.txt
diff baseline.txt candidate.txt                  # must be empty
```

`lvx_v1` is 870 opcodes, `lvx_v2` is 1453. **Run both.** `lvx_v2` is where the 256-bit XVR
octuples, the 128-bit products and the byte-lane instructions live — it has roughly twice
the boxed nodes, and it is where a mistake has somewhere to hide.

## lvx_v2's generated C does not compile

Not a harness problem, and worth knowing before you try: a variable is declared from the
WRITEs to it, so one that is only ever **read** is never declared at all. `FNARROWDWQ` reads
`ziplanes`; the four `CMOVE*` forms read `argument3`. 16 opcodes, 9 undeclared variables, and
the boxed C fails exactly as the unboxed one does.

`Behavior.md` §5 records the `ziplanes` one as "a real bug, left unfixed on purpose" and says
nothing anywhere fails. It fails here — at compile time, the moment anyone builds `lvx_v2`'s
ISS. That nobody had noticed is itself the evidence that the `lvx_v2` tuple has never been
compiled: `BE/GEM5` rides on `BE/LAO` for `lvx_v1` only. The `CMOVE*` `argument3` is a second
instance §5 does not mention. `harness.c` declares both as file-scope zeros so the two
generations can be compared at all; that is a scaffold, not a fix.

## Operands must come from the range the description proves for them

This is the subtlest thing in the harness, and it caused 58 false failures on `lvx_v2`.

`decoded[]` is not free-form. Every `METHOD` carries the interval `Width.pm` proved for it —
for a register operand the index into its file — and **that interval is exactly what lets
`CodeGen` give the operand a narrow C type.** Feed a value outside it and the boxed and
unboxed forms disagree, correctly, on an input the architecture says cannot occur.

`lvx_v2`'s `XPL*` place a byte at a lane of a 512-bit `XVR`, and the three register classes
that select the lane are bounded `hi:3` (`registerGj`, shifted `<< 4`), `hi:1` (`registerGk`,
`<< 5`) and **`hi:0`** (`registerGl`, `<< 6`) — `registerGl` names exactly one register, so
its encoded index is *always* 0. Hand it a 1 and `index << 6` overflows the `uint8_t` the
analysis proved sufficient. So `genbounds.py` reads the real intervals out of `Opcode.table`
(they are not in the tuple — its pretty-printed tree is emitted without the abstract values)
and the harness draws each operand from its own range.

The register bases in `regs.inc` are all **0** for the same reason from the other end: a
behaviour turns a decoded operand into an index by subtracting its file's base, so a nonzero
base makes the index *negative* for any smaller decoded value. With every base 0 the decoded
value simply is the index. The cost is that a bug substituting one base register for another
would not show — not a class of bug the code generator can introduce, since it copies the
symbol through.

## Two things it must not be sensitive to, and once was

Both were found by the unboxing pass, and both made the harness fail on something that is
not a property of the generated code. Neither cost it any sensitivity — on the same mutants,
before and after, it catches 347 against 348, and 34, 18 and 30 unchanged.

**A read must not depend on the trace so far.** `operandRead` derived its value from the
running trace hash, so two reads of the *same* operand returned *different* values and the
order they happened in changed the result. But C fixes the evaluation order of neither
`a | b` nor `Int256_or(a, b)`, and the splat32 forms read one operand twice, in the two
arms of an `IOR`. Unboxing that `IOR` flipped the order gcc happened to pick, and 54 traces
moved with no value having changed. `operandRead` and `readFromStorage_*` are pure
accessors — reading operand *i* twice gives the same value — so they are now keyed on what
they read rather than on the trace. The call is still folded in, so a read that goes
missing or gains a twin is still caught. Helpers with real side effects (`MEM_load`, the
atomics) keep the trace-dependent `result()`.

**A decoded register operand is a register number, not a small integer.** The behaviours
turn it into an index into its own file by subtracting that file's base — `decoded[2] -
Register_lvx_v1_P0`. Feeding a plain `0..63` therefore produced a **negative index** for
three of the four files in play (`P0 = 7`, `PC = 14`, `Q0 = 21`, `R0 = 28`). That breaks
the bound `Width.pm` puts on `METHOD`, which is exactly what lets `CodeGen` give it a
narrow type — so `SQ`/`LQ`/`SO`/`LO`/`ACSWAPQ`, which pass `(SHL (METHOD) 1)` to
`MEM_store`, disagreed between the boxed and unboxed forms. Correctly, and on an input the
description says cannot occur. The seeds now start at the highest base.

The general point: the harness has to stay inside the domain the description assumes, or it
reports differences that are real in C and meaningless in the architecture.

## What it does not check

Timing, the stage/bundle model, and the helper bodies themselves (they are stubs
here — that is the point; their *real* implementations are the ISS's business).
It checks that two generations of the same description agree, which is exactly
what a code-generator change has to prove.
