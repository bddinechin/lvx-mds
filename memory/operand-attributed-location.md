---
name: operand-attributed-location
description: MDS Behavior gained AGGL/AGGB.storage.proxy so run-time-indexed register-file reads (XACCESSO/XALIGNO) carry operand attribution for ISS dependency/stall tracking
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T15:54:35.000Z
---

To let the gem5 LVX ISS track register dependencies (and add stall cycles) for
instructions whose read register is a **run-time** value — `XACCESSO`/`XALIGNO`
and the `xpl*` buffer family (all lvx_v2) — the direct storage path
`(LOAD (AGGL.XVR <computed> 1))` needed operand attribution it lacked. The KVX
ISS couldn't stall on these for exactly this reason (no operand → no read
Parameter → no dependency → optimistic cycle count).

**Phases 1 & 2 done & verified (2026-07-19), MDS half.** Phase 1 (attribution):
*operand-attributed* `Location` `(AGGL.<storage>.<proxy> addr ext)` (and `AGGB`).
Files: `MDS/DOC/Behavior.y` (+2 productions), `MDS/LIB/Behavior.pa` (AGGL/AGGB
builders take optional proxy in **slot 4**; 2 `#rule`s; a `pretty` special-case),
regenerated `MDS/LIB/Behavior.pm`. Phase 2 (operand-relative generation):
`blockExpand` in `MDS/MDD/MDE/BIN/Opcode.pl` (after `Normalize`) rewrites the
attributed Location's element index into `(METHOD(%k)<<log2N)+(idx&(N-1))`, with
`N = count(fine file regClass, matched by regFileName==storage) / count(%k's
regClass)` (XVR=xwordoReg 64 / buffer2Reg 32 → N=2). `Instruction.yml`'s
`behaviorXALIGN` and the six `behaviorBIA<N>` prologues in `Format.yml` lost
`buffer`/`mask`/`where_0`/`where_1`. Because `METHOD(%k)` now sits in the LOAD
Location, `proxyActions` also marks `%k` a Read. **Verified value-preserving** by
the `BE/LAO/TEST` differential harness (`extract-int256.sh` + gen{regs,bounds,stubs}):
pre-change vs phase-2 generation = **1453/1453 lvx_v2 traces identical**. Committed
& pushed.

**gem5 half — FOUNDATION DONE & verified (2026-07-19).** `BE/GEM5` generator
`reg-operands.pl` emits `reg_operands.inc` (per-opcode src/dest reg operands,
parsed from behavior bodies' operand{From,To}RegFile / {read,write}FromStorage;
sources may be read in execute, e.g. RET's $ra=SFR3). Compiled as C in
`behavior.c` (external linkage); `LvxStaticInst` builds `_srcRegIdx`/`_destRegIdx`
via C++ `reg_operands.hh` (GPR→intRegClass[decoded-R0], SFR→miscRegClass). Verified
with a `LvxRegs` DPRINTF: make/sllw/addw/addd/ret deps exactly right; functional
harness (loops/branches/shifts) still matches x86. **Also had to resync the
hand-written gem5 shim to the current lvx-mds helper-width ABI** (unboxing narrowed
syscall/branch_info/bcucond/get/*_check_access/intcomp/MEM_load/MEM_store from
Int256_→native uints) and add missing CS storage helpers — the port was behind the
current generation. Build gem5: `/usr/bin/scons build/LVX/gem5.opt` (NOT `python3
scons`).

**`LvxMinorCPU` WIRED & verified (2026-07-19).** `LvxCPU.py` adds
`LvxMinorCPU(BaseMinorCPU, LvxCPU)`; bundle StaticInst OpClass changed
`No_OpClass`→`IntAluOp` (non-memory on purpose — shim serves mem atomically in
execute(), so no LSQ request). `tests/lvx/run_lvx.py` picks CPU via `LVX_CPU`
env (`atomic` default/fast/harness; `timing`; `minor`) + L1 caches on timing
path. Verified: loop runs identically under all three (285, code 29); Minor 317
cyc vs Atomic 27 (deps drive stalls). Run timing: `LVX_CPU=minor
build/LVX/gem5.opt tests/lvx/run_lvx.py <elf>`.

**FU latencies CALIBRATED (2026-07-19).** Only dependence latency matters
(resource hazards are bundling-guaranteed away); it is writeStage - readStage
from the Behavior stage annotations (2nd arg of operand{From,To}RegFile, indexing
the Processor pipeline `RR=1 E1=2 E2=3 E3=4 E4=5 SF=16 SR=24`). `reg-operands.pl`
emits `lat = max(writeStage) - RR` per opcode (ALU 1, load 3, div/sqrt 15, atomic
RMW 23; FP16 3 vs FP32/64 4). New generator `pipeline-stages.pl` emits
`lvx_stages.h` (C `enum LvxStage`) + `lvx_stages.py` twin from Processor.table;
`static_inst.cc`/`LvxCPU.py` use `LVX_STAGE_* - LVX_STAGE_RR`, NOT magic numbers
(user requirement, see [[feedback-named-constants]]). `LvxFUPool` = one lane per
write stage; bundle routed to the bucket by its max syllable latency. Verified:
maddd(lat2) chain ~2x addd(lat1) per-op in a cache-resident loop.

**Read stage APPROXIMATED as RR -- conservative.** True latency is
writeStage(producer) - readStage(that consumer's source); a store's stored value
and a MADD accumulator are read at E1 (not RR), so those edges are 1 cycle
shorter. gem5 CAN model it via `srcRegsRelativeLats = readStage - RR`, but ONLY
per-FU via MinorFUTiming mask/match on raw inst bits (gem5 calls it "a bit of a
hack"), not per-StaticInst -- so it needs the **micro-op split**.

**Micro-op split = the scoped big next step (user chose it).** Each sub-inst -> a
MinorCPU micro-op (own opClass/opLat/srcRegsRelativeLats). Hard part: VLIW
parallel semantics -- real -O2 bundles pack `make $r0=1 ; sw ...=$r0` (store reads
OLD r0), and parallel swaps `copy $r0=$r1 ; copy $r1=$r0` are unrepresentable
sequentially; neither Minor nor O3 handles VLIW read/write phasing natively. Needs
a bundle-entry register snapshot for reads + intra-bundle scoreboard dep
suppression. That is why the port is bundle-at-a-time. Full design in
`lvx-gem5/docs/register-buffer-deps.md`. Other follow-ups: lvx_v2 bufferNReg->N
XVR expansion; loads/stores through timing memory; scall arg reads.

Full design + as-built details + verification: `lvx-gem5/docs/register-buffer-deps.md`.
Phase 2 (optional cleanup): operand-*relative* `(AGGL.%k idx ext)` that generates
base/mask from the operand's block size — not needed for the dependency fix.
See [[gem5-callret-blocker]], [[lvx-roadmap]].

**The slot-4 proxy / `blockExpand` is the FINAL design — do NOT replace it with a
`[k bits at e]` SLICE (investigated 2026-07-20, rejected as infeasible).** The
[[behavior-slice-plan]] once proposed retiring this machinery by rewriting
`XACCESSO`/`XALIGN` to `(SLICE.256 whole-buffer (e·256))` (a run-time-offset slice,
letting the offset READ carry the attribution). It cannot work: the SLICE source must
be the *whole* N-register buffer aggregate, but **each XVR register read is already
`F2I.256` = 256 bits = the full `Int256` box**, so any buffer of N≥2 registers is
≥512 bits and overflows — and buffers run 2/4/8/16/32/**64** (up to 16384 bits). The
width pass fatally flags `box`. `blockExpand` (`MDS/MDD/MDE/BIN/Opcode.pl`) is correct
*because* it LOADs exactly ONE 256-bit register at the computed run-time index
`(METHOD(%k)<<log2N)+(idx&(N-1))` — O(1) in buffer size, never materialising the buffer,
and `METHOD(%k)` in the Location already gives the attribution (no SLICE benefit). Right
division of labour: **SLICE = a bounded bit-field inside a box-sized cell** (CS/PS
sub-fields, cmove lanes within a 128-bit paired reg — both done, see [[behavior-slice-plan]]);
**slot-4 proxy = a run-time register *index* into a large file** (XACCESSO/XALIGN). Only 2
slot-4 sites exist (the XALIGN reads, `Instruction.yml` ~22128). This item is closed
won't-do.
