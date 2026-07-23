---
name: native-x86-diff-harness
description: The native-x86 <-> gem5-ISS differential test harness now exists (lvx-gem5/tests/lvx/diff/); baseline found two lvx-gcc bugs
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-23T08:42:57.737Z
---

**The roadmap's validation oracle is built** (lvx-gem5 `af6b9fa`, super `21e1a58`,
2026-07-23): `lvx-gem5/tests/lvx/diff/`. Compile a C program with host `cc` AND with
`lvx-mbr-gcc`, run the LVX binary under the gem5 ISS, diff the exit code against native.
Native x86 is the oracle *deliberately* — the ISS is Behavior compiled, so no
Behavior-derived model can independently validate it. See [[lvx-roadmap]].

**Freestanding path (no newlib yet), the key enabler:** the full `-mbr` runtime (crt0,
newlib, libgcc, `mppabareruntime.ld`) is **NOT installed** — that's why only hand-written
`.s` ran before. The harness sidesteps it: `crt0_mbr.S` (`call main ;; scall 1`, exit code
= main's return; gem5's `LvxProcess::initState` already sets `$r12`/SP at stack top so the
crt sets up nothing) + `libmin.c` (only `memcpy/memset/memmove/memcmp`, which GCC emits
under `-ffreestanding`). **Link with `lvx-mbr-ld` directly** — the gcc driver's default
`-mbr` link spec wants the missing linker script. Signal is the 8-bit exit code (`return X
& 0xFF`); stdout joins it once newlib lands. `run_diff.sh` (env: `LVX_TOOLCHAIN_BIN GEM5
HOSTCC OPTS LVX_CPU`), 10-program integer corpus in `c/`.

**Corpus must stay libgcc-free for now:** no `/` or `%` by non-power-of-2 (GCC lowers to
`__divsi3`/`__modsi3` at `-O0`), no floating point (FP `APPLY` helpers are still panic
stubs). Those two gaps — build/install libgcc, and the FP helpers — are what the harness
motivates next.

**Baseline at -O2: 9/10 match native x86** (arith, bits, branches, C switch, funcs,
loops, recursion, signedness, structptr) — the ISS executing real compiled C, covering
loops/switch/recursion/call-ABI/structs/bit-ops. **Two lvx-gcc bugs found (the next work,
recommendation #2):**
- **`array.c` -O2:** GCC emits `addx2wp $r2 = $r0, $r0`, assembler rejects it ("Unexpected
  token") — a gcc↔assembler mnemonic/operand mismatch on the word-pair add-shift (NOT the
  known LITE even/odd parity error, which reads differently).
- **`-O0`, ~every program:** backend ICE `safe_as_a<rtx_insn*>` at `is-a.h:268` in the
  machine reorg (`mach`) pass. **`-O0`-only** — `-O1`/`-Og`/`-O2`/`-Os` all compile. Harness
  defaults to `-O2`; `OPTS="-O0 -O2"` reproduces it.

Next after this: (a) fix those two gcc bugs; (b) build+install libgcc then newlib mbr
runtime (widens corpus + gives stdout); (c) FP/SIMD helper bodies (Behavior.md §7.5,
flag-returning convention first) to stop the ISS panicking on floating point.
