---
name: behavior-switch-statement
description: Behavior language gained a first-class SWITCH/CASE/DEFAULT (C-style multi-way dispatch); CSRRW/CSRRS/CSRRC now use it instead of nested IF
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-23T06:39:10.628Z
---

**SWITCH/CASE/DEFAULT added to the MDS Behavior language** (lvx-mds `a1eeb84`, super
`369cdd6`, 2026-07-23). A first-class C-style multi-way dispatch that replaced the deep
nested-`IF` cascade the RISC-V CSR instructions were built from. Requested by the architect
to make the CSR dispatch readable and reusable. See [[risc-v-csr-unification]].

**Surface syntax:** `(SWITCH <subject-Integer> (CASE.<const> <cmd>)... (DEFAULT <cmd>))`.
- Label after `CASE.` is a bare `INTNUM` (grammar `Label : INTNUM`) — **Section/SYMNUM
  excluded at the grammar level**, so there is no runtime label-type guard. Chosen over an
  `(CASE (labels) …)` Integer-list form (which needed a runtime `die`) and over multi-const
  dot-chains. Hex normalizes to decimal in `sub CASE` (`0x341`→833), like CONST.
- **DEFAULT mandatory** (a distinct trailing element of the SWITCH production). **One const
  per CASE** — a shared-body group is repeated arms (the machine-ID group of 5 csrnumbers
  became five one-label arms). **No fall-through** (CodeGen `break;` after every arm).
- Symbolic labels would need a one-line lexer tweak (`yylast eq 'CONST' || 'CASE'` at
  `Behavior.pa` ~4129, since `.` doesn't update `yylast`) — deliberately NOT done; CSR
  labels are all numeric.

**First-class node, NOT lowered to IF** (user chose this over sugar-lowering): survives to
CodeGen as a real C `switch (Int256_toUInt64(subject)) { case N: {...} break; ... }` and to
the tables via the generic `Pretty` walk. Rep `['SWITCH', subj, ['CASE', <n>, body], …,
['DEFAULT', body]]` — labels are **bare scalars**, so every `ref eq 'ARRAY'`-guarded pass
skips them.

**Touch-point map (the load-bearing knowledge).** Passes split by whether branch arms are a
*sequence* (generic recursion works) or *alternatives* (need explicit N-ary arm):
- **Explicit SWITCH arm added:** `Width::_cmd` (forward interval — MANDATORY, unknown Command
  is a fatal `internal`) + `Width::_dcmd` (backward demand union); `PruneWrite` (use union);
  `parallel` (per-arm reachingVals copy, drop arm-written vars at the join) + `if_count`
  (`+= #cases` so a big switch skips Parallel like its IF-cascade did — CSR skips at 12 arms);
  `CodeGen`; `BE/TEX/BIN/Instruction.pl` (LaTeX renderer, has its OWN node dispatch);
  `BE/LIB/Behavior.rb` (Ruby AVP evaluator, defensive — AVP not in default TOOLS).
- **Generic, NO change (verified):** `Deslice` (so SLICE inside arms lowers free), `Clone`,
  `Check`, `Expand`, `Reorder` (SEQ-only), `Simplify`, `remove_dead_writes`,
  `propagate_conditions`, `proxyActions`, and **`Pretty`** (the dot-separator logic emits
  `CASE.<n>` for free). `%Expression` gets no entry (SWITCH is a Command). `Rename` is dead
  code (no callers) — left alone.

Grammar in `DOC/Behavior.y` (+ `#rule`s and `sub SWITCH/CASE/DEFAULT` in `LIB/Behavior.pa`);
`LIB/Behavior.pm` regenerated (`make -f Maintainer`, bison 3.8.2 + yaxcc), reproduces
byte-identically. Lexer needed NO change — a word after `(` self-tokenizes.

**Validated:** 0 grammar conflicts; `#rule` pairing clean; WIDTH_CHECK fatal set clean;
BE/LAO/TEST differential **0/870 (lvx_v1) + 0/1453 (lvx_v2)** boxed-vs-unboxed; `refs/BE/GBU`
byte-identical (behavior-only, **encoding untouched → binutils not rebuilt**); gem5 ISS
csr_fcsr=255 csr_pseudo=255 csr_machine=0 csr_trap=153, unknown csrnumber → OPCODE throw
(rc=132), hwloop/compute/exit unchanged. See [[gem5-hardware-loop]] for the ISS substrate.

**lvx-gem5 needs NO commit for MDS behavior changes:** everything in
`lvx-gem5/src/arch/lvx/generated/` is gitignored (only `.gitignore`/`regen.sh` tracked). A
behavior-only MDS change = commit lvx-mds + bump superproject's lvx-mds pointer; gem5's
pointer moves only when its hand-written shim/tdep/static_inst source changes.
