---
name: gem5-callret-blocker
description: gem5 ISS now runs compiled C — call/ret helpers + onlysetReg decode both FIXED; only GCC frecw/div-mod remains
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
---

**RESOLVED 2026-07-18: the `lvx-gem5` SE ISS runs compiled C correctly.** The `lvx-csw/validation/` native-x86 differential harness shows PASS for branches/loops/shifts (matching x86); only `arith`/`calls` fail, on the GCC `frecw.rn`/`fwidenlwd` integer div/mod issue (assembler/ISA gap — `FRECW` removed — not the ISS). Both fixes below are built into `build/LVX/gem5.opt`; milestone smoke tests still pass (exit42→42, compute→19).

**Fix 1 — the panic-stub cascade** (helpers were `lvx_behavior_unimpl()`→`__builtin_trap()`→SIGILL). Implemented in `lvx-gem5/src/arch/lvx/shim.{cc,h}`, listed in `lvx-mds/lvx-family/BE/GEM5/shim-helpers`, stubs dropped from `generated/helper_stubs.inc`:
- `srhpc_update` (no-op), `bcucond` (branch cond), `intcomp_32/64` (integer compare) — mirror `../epi-csw/lao/LAO/kvx/Behavior.c`.
- `get` (returns value), `get/set/wfxl/wfxm_check_access` (SE permits all).

**Fix 2 — `onlysetReg` operand decode** (`lvx-gem5/src/arch/lvx/operands.c`). `set $ra` wrote misc reg 4 (CS) instead of 3 (RA), so the epilogue's `set $ra; ret` never restored RA → infinite epilogue loop → SP walks up until `readBlob(0x8000…)` faults. Cause: the raw operand field is the register's **file position**, but the decoder did `decoded[i] = rc_<class>[raw]` (compact-list index), which only equals the file position when the class lists the whole file in order. `onlygetReg` includes PC so it worked; `onlysetReg` omits PC (non-settable), so raw=3 ($ra=$s3) mis-indexed to CS. Fixed by decoding register operands as `filebase + raw`: added a per-class `rcfilebase_*` derived from the RegClass `REGFILE` (SFR→`Register_lvx_v1_PC`; other files keep the compact table via a -1 sentinel, no behaviour change). Verified `set $ra=123; get $ra`→123, and GET/loads/stores unaffected.

Related: [[lvx-roadmap]], [[kvx-reference-epi-csw]]. Harness + findings: `lvx-csw/validation/`.
