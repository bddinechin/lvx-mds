---
name: lvx-gcc-session-handoff
description: "Handoff for the next session focused on lvx-gcc backend bugs surfaced by the diff harness; git state, the two bugs, build/validate loop"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-24T18:17:32.162Z
---

**Next session = lvx-gcc backend work**, driven by the [[native-x86-diff-harness]] (the
new `lvx-gem5/tests/lvx/diff/` oracle). The "always exclude lvx-gcc from commits" rule
from prior sessions is **lifted** for this work — lvx-gcc is now the subject.

**lvx-gcc git state (as of 2026-07-24), the working context to preserve:**
- Branch `main`, **no upstream tracking configured** (`@{u}` unset), but `origin`
  =`git@github.com:bddinechin/lvx-gcc.git` exists; `origin/main` = `7a6d24a` (= what the
  superproject pointer records — consistent baseline).
- **2 local commits ahead of origin, UNPUSHED:** `ad6245817` "Checkpoint before removing
  64-bit SIMD support" and `60eff190dfd` "Cleanup libgcc/config/lvx."
- **Uncommitted:** `gcc/config/lvx/builtin.md` −19 lines (removes `lvx_mm212w`/`lvx_mma212w`
  SIMD matrix-mul patterns). **Untracked:** `gcc/config/lvx/FILES`.
- So there is an in-flight theme: **removing 64-bit SIMD (word-pair `*wp` / `*hq` / `*bo`)
  support** from the LVX backend. Left as-is (user's working state) — do NOT reset it.

**Two bugs the diff harness found (at `lvx-gem5/tests/lvx/diff/`, run `./run_diff.sh`):**

1. **`addx2wp` rejected by the assembler, -O2** (only `array.c` in the corpus). GCC emits
   `addx2wp $r2 = $r0, $r0`; `as` says "Unexpected token". Root cause is almost certainly
   the **64-bit-SIMD removal remnant**: `scalar.md` `*addx2<suffix>` / `*addx2<suffix>_m`
   (lines ~436/447, output `"addx2<suffix> %0 = %1, %2"`) still instantiates the `wp`
   (word-pair, 64-bit packed) variant via its mode/suffix iterator, but the LVX assembler
   no longer accepts `addx2wp`. Fix ≈ drop `wp` (and any other 64-bit-SIMD suffix) from that
   iterator, consistent with the mm212w/mma212w removal in `builtin.md`. Verify the assembler
   truth with `grep -A15 '"addx2' lvx-binutils/opcodes/lvx-opc.c` (as/objdump are the
   authoritative encoding, per [[lvx-gdb-binutils-untrusted]]) — check whether `addx2wp`
   exists at all in the LVX ISA.

2. **-O0 backend ICE `safe_as_a<rtx_insn*>` at `is-a.h:268`** in the machine reorg
   (`pass mach`), ~every program. **-O0-only** (`-O1`/`-Og`/`-O2`/`-Os` all compile). A
   custom LVX pass casts a non-insn rtx (note/label/barrier that -O0 leaves in) to
   `rtx_insn*`. Suspects: the lvx-specific passes in `gcc/config/lvx/lvx-passes.def`
   (`pass_lvx_shaker` in `lvx-shaker.c`, `pass_prologue_stack_limit` in
   `lvx-prologue-stack-limit.cc`) or the bundling reorg in `lvx.cc`. Get the exact insn/pass
   with a debug build: `-fdump-rtl-mach-all` and a gdb backtrace on the `safe_as_a` abort.

**Build/validate loop (there is NO `lvx-gcc-build/` dir — must reconfigure from scratch):**
- Reconfigure per `lvx-csw/CLAUDE.md` "GCC" recipe: `mkdir lvx-gcc-build && cd it;
  ../lvx-gcc/configure --target=lvx-mbr --prefix=/home/bd3/lvx-csw/lvx-toolchain
  --disable-werror --enable-languages=c,c++ --without-headers --disable-nls --disable-shared
  --disable-threads --disable-libssp/libgomp/libquadmath --enable-64-bit-bfd
  --with-as=.../lvx-mbr-as --with-ld=.../lvx-mbr-ld` (binutils already installed).
- Rebuild: `make -j$(nproc) && make install` (installs `lvx-mbr-gcc` to the toolchain).
  Pattern debugging: `make -C lvx-gcc-build/gcc mddump` → `tmp-mddump.md` (fully-expanded
  patterns). See CLAUDE.md "GCC Machine Description Debugging".
- **Validate a fix:** rebuild+install gcc, then `cd lvx-gem5/tests/lvx/diff && ./run_diff.sh`
  (defaults to -O2, 9/10 pass; `OPTS="-O0 -O2"` exposes the ICE). Toolchain bins at
  `/home/bd3/lvx-csw/lvx-toolchain/bin/` (not on PATH). Installed gcc: 17.0.0 20260627.

**Repo-workflow reminders:** superproject + all other submodules are level with origin
(nothing to pull). gem5's `src/arch/lvx/generated/` is gitignored — MDS behavior changes
never need a gem5 commit; gcc changes need lvx-gcc commit + superproject pointer bump.
Watch the `cd`-persists-across-`&&` trap (use `git -C <repo>`). Push remotes are
`git@github.com:bddinechin/<repo>.git`.
