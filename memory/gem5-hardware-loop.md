---
name: gem5-hardware-loop
description: LOOPDO hardware looping now runs in the lvx-gem5 ISS, with Tensilica LOOPNEZ skip-if-zero; the SFR->SRS refactor also landed in the gem5 shim
metadata:
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-22T08:26:44.161Z
---

**DONE + pushed 2026-07-22 (lvx-mds `9119d6a`, lvx-gem5 `d57c5fccd6`, superproject bump
`989a883`).** Note: **`lvx-gem5` is now a submodule of `lvx-csw`** (mode 160000, in
`.gitmodules`, branch `lvx`) — the CLAUDE.md claim that it is not is stale, so a bump covers
both `lvx-mds` and `lvx-gem5` (leave the unrelated `lvx-gcc` pointer alone).
Zero-overhead hardware looping (LOOPDO) now executes in the `lvx-gem5` SE ISS, and LVX
LOOPDO now **skips the body when the trip count is 0** (Tensilica Xtensa LOOPNEZ), where
KVX LOOPDO loops forever. **LC stays the full trip count** (GCC's hw-doloop relies on it);
only the zero case changed, so counts >=1 are unaffected. Validated: `hwloop3`->exit 3
(body runs 3x), `hwloop0`->exit 0 (body skipped; KVX would hang). New tests
`lvx-gem5/tests/lvx/hwloop{0,3}.s`.

Three pieces (the loop-back engine did **not** exist before — LOOPDO only *set* LS/LE/LC):
- **Part C, architectural** (`lvx-mds/lvx-family/FE/YAML/lvx/Instruction.yml` LOOPDO): after
  storing LS/LE/LC, `IF count==0 -> STORE NPC = LE`. Writing NPC sets `npcWritten`, so the
  setup bundle counts as a branch to LE and the body is skipped. Regenerated -> `BE/LAO` ->
  `BE/GEM5 install`.
- **Part B, the fetch-engine loop-back** (`lvx-gem5/src/arch/lvx/static_inst.cc::execute`,
  **hand-written** — not expressible as per-instruction Behavior): after `next` is computed,
  if `PS.HLE && !branched && fallThrough==LE`: `if LC>1 next=LS; if LC!=0 LC--`. The `LC==0`
  guard stops a stale LE re-triggering. SFR indices LS=7/LE=8/LC=9 named in `regs/misc.hh`.
- **Part A, PS.HLE** modeled as always-set in SE mode so LOOPDO stops throwing OPCODE.

**Big side effect: the SFR->SRS refactor (see [[risc-v-csr-unification]]) reached gem5 for the
first time.** gem5's `generated/` tree was ~2 days stale (pre-refactor). The current MDS reads
system regs via `readFromStorage_SRS` (**797 sites, almost all CS/FP-status; PS=1, CS=4**),
which the shim didn't implement. Fix: **`_SRS` read/write helpers mirror `_SFR`** (SRS shares
the SFR numbering) — PS (SRS 1) ORs in PS.HLE, CS/FP-status default 0 (== old
`readFromStorage_CS`). Also added **`invalpfb`** (LOOPDO prefetch-buffer invalidate) as a no-op
shim helper + to the `BE/GEM5` `shim-helpers` manifest (was a panic stub). Reinstalled the whole
`BE/GEM5` tree into gem5 and rebuilt; the smoke tests (42/19/188/188/7) are unchanged, so the
SRS landing regressed nothing.

**Gotcha hit:** editing a source `.yml` under `lvx-family/FE/YAML/lvx/` did **not** retrigger the
FE — the generated `build_lvx/FE/YAML/lvx/*/Description.yml` was 2 days stale and make left it.
Had to `rm` `Description.yml` + `Instruction.{yml,pl,table}` + `MDD Opcode.table` to force FE
regen (the documented Description.yml staleness trap). `make refs` after, for the baseline.

Related: [[gem5-callret-blocker]] (ISS runs compiled C), [[lvx-roadmap]], [[risc-v-csr-unification]].
