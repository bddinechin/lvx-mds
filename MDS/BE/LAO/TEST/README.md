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

Generate `Behavior.tuple` two ways, run both, compare the 870 traces. If a value
changed anywhere, the trace diverges. The real `Int256_` arithmetic — Kalray's,
from `kvx-lao` — is the oracle for both sides, so the comparison is against the
arithmetic the ISS actually uses, not a model of it.

The 137 operator-helper stubs are generated from the tuple's *own*
`BehaviorDeclare(...)` prototypes (`genstubs.py`), so they cannot drift from what
the generator emits. The 17 shim helpers — the ISS's state interface — are
hand-written in `harness.c`.

## Running it

```sh
./extract-int256.sh                     # fetch + build Kalray's Int256_ (needs gh)
python3 genstubs.py <build>/BE/LAO/lvx_v1/Behavior.tuple      # -> opstubs.inc
cc -O1 -I int256 -I. -DBEHAVIOR_TUPLE='"<...>/Behavior.tuple"' \
   harness.c int256/rt.o -o harness
./harness > baseline.txt
# ... regenerate Behavior.tuple ...
./harness > candidate.txt
diff baseline.txt candidate.txt          # must be empty
```

`regs.inc` (the `Register_lvx_v1_*` constants and the two LAO accessors the bodies
use) is derived from the tuple; regenerate it if the register set changes.

## It is known to catch things

A test that cannot fail is worth nothing, so the harness is mutation-tested. Each
of these is a bug an unboxing pass could plausibly introduce:

| mutation to the generated C | call sites | opcode traces changed |
|---|---|---|
| `Int256_add` → `Int256_sub` | 362 | 347 / 870 |
| coercion width 64 → 63 | 2363 | 666 / 870 |
| coercion width 32 → 31 | 742 | 230 / 870 |
| coercion width 8 → 7 | 48 | 48 / 870 |

A wrong width and wrong arithmetic both show up. Note the trace is deliberately
folded over all four limbs of every `Int256_`, so a bug that only corrupts the
high 192 bits — precisely what a careless unboxing would do — cannot hide.

## What it does not check

Timing, the stage/bundle model, and the helper bodies themselves (they are stubs
here — that is the point; their *real* implementations are the ISS's business).
It checks that two generations of the same description agree, which is exactly
what a code-generator change has to prove.
