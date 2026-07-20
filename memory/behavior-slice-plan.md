---
name: behavior-slice-plan
description: "MDS Behavior is gaining a λ-RTL SLICE location construct for sub-cell bit-field addressing, replacing the width:1-storage workaround and retiring the slot-4 proxy"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T15:52:35.494Z
---

**Decided 2026-07-19 (user: "spec SLICE").** MDS Behavior addresses bit-fields today
by declaring `Storage width:1 count:64` (PS, SPS, SPS_PL0..3, CS, …) so `AGGL/AGGB`
can aggregate N one-bit cells into an N-bit field — leaving `SFR` (width:64) backed by
a heterogeneous mix of 1-bit arrays and 64-bit cells. Root cause: MDS kept λ-RTL's
`AGG` (aggregate *up*, whole cells → wider value = our `AGGL/AGGB`) but **dropped
`SLICE`** (carve *down*, a sub-range of a cell), and fakes the down direction with the
up operator by shrinking cells to 1 bit.

Fix (chosen over the user's original "Width-on-AGG" sketch, after reading λ-RTL
Ramsey & Davidson 1999 — the paper this part descends from, `lrtl-tr.pdf`): add
λ-RTL's **SLICE as a `Location` constructor** `(SLICE Location Offset Width)`. Width
static; Offset constant (`[k]`, `[k1..k2]`) or an expression (`[k bits at e]`).
Lowered **before CodeGen/Width** by λ-RTL's two rewrites, to primitives already
present: read → `(I2F.w (SHR (F2I.W (LOAD l)) off))`; write → whole-cell RMW
`bitInsert` from ring ops (`AND/IOR/SHL/NOT`) — NOT the STORE `Mask` arg, which is an
**unfinished SIMD-lane-masking addition to be removed and re-engineered** (SLICE
supersedes it). `[k bits at e]` (static width, run-time offset) is a run-time-indexed
lane select, so it **retires the slot-4 proxy machinery** from
[[operand-attributed-location]] (XACCESSO/XALIGNO become `(SLICE buffer (e·64) 64)`;
the offset operand's READ carries the gem5 dep attribution for free).

**Phases 0 & 1 DONE (lvx-mds `e0e588e`).** Phase 0: spec as §8 of `MDS/DOC/Behavior.md`.
Phase 1: grammar `Location -> '(' SLICE '.' Width Location Offset ')'` + `Offset` in
`DOC/Behavior.y` (SLICE token; Width dotted like SX.32 so generic Pretty serialises it,
no special-case); `sub SLICE` builder in `LIB/Behavior.pa` (validates const width /
Location child / Integer offset), exported beside AGGL/AGGB; lexer needs nothing (word
after `(` auto-tokenises); factored `locationWidth()` out of LOAD/STORE so
LOAD/STORE-of-SLICE is constructible (same arithmetic for AGGL/AGGB). `Behavior.pm`
regen byte-identical (bison 3.8.2). **Proven output-neutral**: `make diff` byte-identical
rebuilt at HEAD vs with-change (48735 lines both) — the standing `make diff` delta is
PRE-EXISTING refs staleness (refs 2026-07-17 `c11f8ae` vs phase-2 YAML 2026-07-19
`ccff2a5`; nobody ran `make refs` after phase-2), NOT this change. Round-trips identical.

**Phase 2 DONE (lvx-mds `661e122`, committed not-yet-pushed as of this note).** `sub
Deslice` in `LIB/Behavior.pa` (exported), wired into `MDD/MDE/BIN/Opcode.pl` between
`Expand` and `widthCheck` (so it catches YAML-authored slices AND Phase-3 Access.pl
slices substituted by Expand). Bottom-up; slice-of-slice refused. Rewrite: read =
`I2F.w(SHR(castI(LOAD.s l), off))`; write = `STORE.s l (I2F.W(IOR(AND(castI(LOAD), NOT(SHL(m,off))), SHL(ZX.w(F2I.w field), off))))`,
m=`ZX.w(CONST(-1))`=2^w-1 (no big literal). Verified: numeric equivalence to bitfield
extract/insert over Math::BigInt (read/write × const/dyn offset × many combos);
lowered tree passes Width 0-fatal (const folds inverse mask; dyn widens but types at
W); CodeGen emits correct mask/shift/insert; **output-neutral** (Deslice no-op on all
real trees → full rebuild `make diff` byte-clean, refs unchanged); Behavior.pm regen
byte-identical.

**REVISED 2026-07-20 (user reframed the objective).** The real goal is *Storage.yml
simplification*: remove every `width:1` storage (MEN/PS/SPS/CS/…) AND the per-register
singleton storages (PM1/PM2/…), backing **all** SFR registers with the one `SRS`
(width:64 count:512) storage — heading toward RISC-V CSR unification (FP + machine mode
first). **LAO byte-identity is NOT a constraint** (LAO is scaffolding for GEM5); the gate
is **ISS/GEM5 state-equivalence**. So the old "Phase 3(A) collapse width:1→width:N c1 as
separate storages" is obsolete — go straight to SRS.

Key structural facts learned (all verified in the YAML/generators):
- The SFR `$sN` alias index == the target SRS cell (RA=$s3→[SRS,3] already; PS $s1→[SRS,1]).
  `execution:"SFR[%0]"`, so SFR[N] *is* the register; we only change its backing to SRS[N].
- **RegField is metadata only.** `Access.pl` (the LOAD/STORE behavior generator) never reads
  RegField. Consumers: `BE/LIBC/BIN/libc-registers.pl` (uses each field's computed
  `offset`/`width` — never the storage cell) and `BE/TEX`. **There is no RegField→SLICE
  path.** SLICE is only needed for hand-authored *instruction* behaviors that name a storage
  at a sub-cell offset. Behavior scan: only **CS (301 refs)** and **PS (1 ref)** do that.
- `RegField.location:[storage,bitrange]` → `Description2MDS.pl regField()` uses the storage
  only for (a) an existence check (dies if deleted) and (b) a *default* register map
  `storage2register` that an explicit `register:` overrides. `storage2register` is
  first-wins, so on SRS it resolves to RA — therefore **every RegField repointed to SRS must
  carry an explicit `register:`** (3 lacked it: SRHPC_SRHPC, TPCM_0, TPCM_1).
- Repoint recipe per register R (storage S, index N): RegFile `location:[S,…]`→`[SRS,N]`;
  RegField `location:[S,bits]`→`[SRS,bits]` (+ add `register:R` if missing); delete storage S.
  Register-name == storage-name for the singletons. Script: scratchpad `stage1.pl`.

**Stage split (the ONLY real divider): does a hand-authored behavior touch the register's
sub-cell bits, or is the register itself <64-bit?**
- **Stage 1 DONE + pushed (lvx-mds `f211e6b`, super `6c1b9a2`).** The 28 width:64 singleton
  storages: AESPC PM0-7 PMSA T0V/T1V/T0R/T1R WDV/WDR DBA0-3 DWA0-3 TPCM0 TPCM1 SRHPC FRCC.
  28 regs → [SRS,$sN], 27 RegFields → [SRS,bits] (+3 register: added), 28 storages deleted
  (Storage.yml 86→58). **Verified state-preserving: rebuild produced ZERO Opcode/Behavior
  table changes — only Register.table/Storage.table + BE/LAO Register.tuple/Storage.tuple
  moved** (storage=SRS, addresses=$sN; 28 storages gone). refs re-baselined, make diff clean.

  **KEY INSIGHT (why Stage 1 was clean, drives Stage 2):** the generic SFR read/write is
  `(LOAD/STORE (AGGL.SFR <idx> 1))` — it indexes the SFR *regfile* logically; it does NOT
  reference the per-register storage. So a register's `storage`/`location` is a *declarative*
  physical-backing fact consumed by the Register/Storage model (→ gem5 register file), and
  repointing it changes only those model tables, never a behavior. Behavior only names a
  storage for hand-authored *sub-field* access.

- **Stage 2 (mostly mechanical + focused SLICE)** — NEXT. Revised understanding: because the
  user wants each register at `location:[SRS,idx]` (a WHOLE cell), **width:32 SFRs can also go
  whole-cell** (get a full SRS cell, use the low 32 bits; width:32 stays as metadata) — NO
  register-level SLICE. So repoint ALL remaining SFRs whole-cell exactly like Stage 1
  (width:64: PCR IPE ILL ITO MO PSO TEL TEH ES ES_PL* PMC PMC2 TPCMC TPCM2 DCV2_* MEN + aliases;
  width:32: PS CSIT TCR MMC IXC SYO HTO DO MES WS ILE ILR SID* SPS* TPCC* DC). **SLICE is needed
  ONLY for the hand-authored bit-field behaviors that name a storage at a sub-cell offset —
  confirmed to be just CS (301 refs) and PS (1 ref)** (XVR/NPC/PC are not SFR-bit-field cases).
  Convert those `(AGGL.CS <field> 1)` → `(SLICE.1 (AGGL.SRS <CScell> 1) <field>)`; then CS/PS
  storages can be deleted too. Deslice (Phase 2) lowers them.

**Stage 2a DONE + pushed (lvx-mds `1af1716`, super `f656532`).** 55 remaining whole-cell SFRs
(width:32 included, as full cells) → [SRS,$sN]; 685 RegFields → SRS (+562 register:); 49
storages deleted (Storage.yml 58→9). Alias pairs sharing one storage (SYO/SYOW, HTO/HTOW,
ITO/ITOW, DO/DOW, MO/MOW, PSO/PSOW) both land on the base register's cell (min $sN over the
storage's registers) — do NOT give the W-alias its own $sN. Verified state-preserving:
model-only diff, registers.h byte-identical, ZERO Opcode/Behavior change (confirms width:32
whole-cell is behavior-neutral — the whole-cell assumption held). **Script bug that bit me:**
`my (@out,$del,$skip)=((),0,0)` — @out slurps the whole RHS, leaving scalars undef AND
prepending "0","0" to @out → corrupted `00Storage:` header → cpp/YAML parse broke →
"Unknown Storage (PC)". Init array + scalars on SEPARATE lines.

**Stage 2b DONE + pushed (lvx-mds `c342e15`, super `40e6fd5`). SFR-onto-SRS COMPLETE.**
Verified: registers.h byte-identical; Opcode.table 0 SLICE / 0 AGGL.CS/PS (Deslice lowered
all); width check clean; CS_XMF=bit24 of SRS[4] = same physical bit → semantically identical;
GDB tdep components[] 32→16 is benign (PS lost its 32-cell 1-bit span). CS→[SRS,4], PS→[SRS,1];
302 hand-authored bit-field behaviors `(AGGL.CS (CONST.<F>) (CONST.<W>))` →
`(SLICE.<W> (AGGL.SRS (CONST.4) (CONST.1)) (CONST.<F>))` (Format.yml 301 + Instruction.yml 1
PS_HLE); 35 CS/PS RegFields → SRS (+register:); CS/PS storages deleted. **Storage.yml now 7
entries** (86→7): PC SRS GRS ZERO XRS MEM NPC — the SFR unification is COMPLETE.
- CS fields: CS_XMF(bit24) CS_RM(3b) CS_DZ/IN/IO/OV/UN(1b). CS_XMF=SRS[4]<24> = same physical
  bit as old CS bit24 → semantically identical. Deslice lowered all: Opcode.table has 0 SLICE /
  0 AGGL.CS, width check passed (no fatal box/signed), IOR/SHR RMW+read present.
- **INTEGRATION GAP FOUND + FIXED:** Deslice runs ONLY in `MDD/MDE/BIN/Opcode.pl`
  (→ Opcode.table, for BE/LAO/GEM5). **BE/TEX renders the RAW behavior** (reads Format/
  Instruction tables, pre-Deslice) and its walker `BE/TEX/BIN/Instruction.pl` died on
  `unknown node type SLICE`. Fixed by adding a native SLICE case there (renders
  `location<offset:width>`, a readable bit-field — better than the lowered shift/mask for docs).
  Only BE/TEX walks raw behavior (GEM5 rides LAO's deslice'd output; GDB/GCC/LIBC/GBU don't
  touch behavior). If a future back-end walks raw behavior it needs the same SLICE case.

**STORE Mask retired via SLICE — DONE + pushed (lvx-mds `b105b57` prototype + `dbfd34c`
deletion; super `ba1a887`).** Investigation: the STORE Mask was a `(lane-width,lane-index)`
selector `(CONST.w[i])` = a contiguous run of w ones at w·i — used only by lvx_v2
`cmove{b,h,w,d}` (60 sites, all single lanes into PGR; lvx_v1 had 0). Each cmove lane is
`(IF cond (COMMIT.E1.%1 (READ.argument3) (CONST.w[i])) (SKIP))`. The old mask codegen was
incomplete (never shifted the value to the lane). Fix: at Expand's masked-COMMIT→STORE site
(Behavior.pa `sub expand`), a defined mask now wraps the location in `(SLICE.w loc (w·i))`
and makes the field w-bit, instead of `$expand->[4]=$mask`; Deslice (right after Expand)
lowers to the correct RMW. The mask CONST is a *sectioned* CONST: `$mask->[1]` is `[_,w,i]`
(width at [1], index at [2]) — same layout codegen_mask read; index must be static.
Result: lvx_v2 60 masked STOREs→0 (each now `(IF cond (STORE (AGGL.PGR..) (IOR (AND (LOAD..)
(NOT mask)) placed)))`), lvx_v1 byte-identical. Then removed the dead STORE-Mask path
(grammar production + #rule, `sub codegen_mask`, the STORE-codegen masked branch, the STORE
builder `$mask` param) — output-neutral. **KEPT:** the `Mask` nonterminal + COMMIT-with-Mask
production (cmove still authors masked COMMITs; Expand converts them). Design view recorded:
byte-vs-lane is a false choice — SLICE is width-parametric (neither), so static contiguous
sub-register writes → SLICE; a genuine runtime predicate (none exist yet) would be a
byte-granular write-enable.

**SFR-onto-SRS is fully done (Stage 2b `c342e15`).**

**XACCESSO/XALIGN `[k bits at e]` migration — INVESTIGATED, REJECTED as infeasible
(2026-07-20). Keep the slot-4 proxy.** The Phase-0 idea "XACCESSO/XALIGN become
`(SLICE.64 buffer (e·64))`" cannot work: the SLICE source would be the *whole* N-register
buffer aggregate, but each XVR register read is already `F2I.256` = **256 bits = the full
Int256 box**, so a buffer of N≥2 registers is ≥512 bits and overflows (buffers run
2/4/8/16/32/**64** → up to 16384 bits; width check fatally flags `box`). The current
`blockExpand` (Opcode.pl `sub blockExpand`) is the *correct* design: it rewrites the
attributed Location `(AGGL.XVR.%2 idx 1)` to LOAD **exactly one** 256-bit register at the
run-time index `(METHOD(%2)<<log2N)+(idx&(N-1))` — O(1) in buffer size, never materialising
the buffer — and METHOD(%2) in the Location gives the gem5 operand attribution. SLICE is for
a bounded bit-field within a box-sized location; a run-time register *index* into a large
file is a different operation and the slot-4 proxy is the right tool. No attribution benefit
either (blockExpand already attributes). Only 2 slot-4 sites exist (the XALIGN reads,
Instruction.yml ~22128). Net: the SLICE work (CS/PS, cmove) is complete; this last item is
closed as won't-do. See [[operand-attributed-location]].

**OLD RESUME NOTE (superseded above, kept for the push/acceptance mechanics):**

**FIRST, push the two committed-but-unpushed commits** (nothing else is pending):
- lvx-mds `661e122` (Phase 2 lowering) — `git -C lvx-mds push origin main`
- superproject `76e1bcb` (Phase 2 bump) — `git -C . push origin main` from lvx-csw
  (already-pushed baselines: lvx-mds `245c522`, superproject `33c050c`.) The pre-existing
  ` M lvx-gcc` in superproject status is NOT ours — leave it.

**Phase 3 = the first non-output-neutral phase (that is the point).** Two parts:

(A) **Collapse the 51 one-bit storages** in `lvx-family/FE/YAML/lvx/Storage.yml` from
`width:1 count:N` to `width:N count:1` (natural single cell; preserve bit capacity =
old count). The 51: MEN PS SPS SPS_PL0..3 CS CSIT ES ES_PL0..3 SID SID_PL0..3 IXC TEL
TEH TPCM2 TPCMC RVC DCV2_0..3 TCR PMC PMC_2 PCR SYO HTO ITO ILE ILL ILR IPE DO MO PSO
MMC MES WS TPCC TPCC_PL0..3. (Find: `grep -B4 'width: 1$' Storage.yml`.) NB some counts
≠64 (one had count:16) — new width = that count, not blindly 64.

(B) **Emit SLICE for the sub-cell accesses.** Every site that today addresses one of
those storages with a *bit offset* over 1-bit cells must become a SLICE of the single
natural cell: `(AGGL.CS CS_XMF 1)` → `(SLICE.1 (AGGL.CS (CONST.0) (CONST.1)) (CONST.CS_XMF))`,
and a range `[storage, a..b]` → `(SLICE.(b-a+1) (AGGL.storage 0 1) a)`. Two source kinds:
  - **behaviors that name the storage directly** — e.g. the `behaviorBIA<N>` Macro
    prologues already write `(STORE.E1 (AGGL.CS (CONST.CS_XMF) (CONST.1)) ...)` in
    Instruction.yml/Format.yml. These are hand-authored S-exprs → edit to SLICE form.
  - **the RegField→storage mapping for SFR registers** — `RegFile.yml` SFR entries carry
    `location:[storage, bitrange]` (e.g. `PS location:[PS,0..31]`). OPEN QUESTION: find
    where that becomes an AGGL in generated behavior (grep the MDE/Access path for how an
    SFR register access resolves its RegField location; `MDD/MDE/BIN/Access.pl` lines
    99-107 handle *register-file operands* `(AGGL regfile %0 1)`, NOT these SFR bit-fields
    — the bit-field resolver is elsewhere, locate it first). That resolver must wrap sub-
    cell fields in SLICE. Access.pl is family-agnostic → keep the change driven by the
    RegField width vs storage width, not lvx-specifics.

**Deslice already handles all of it** (Phase 2, done): it lowers any SLICE the YAML or the
resolver produces, between Expand and widthCheck. So Phase 3 is purely "produce SLICE
instead of the 1-bit-array AGGL," no new lowering.

(4) **Acceptance**: `BE/LAO/TEST` 0-diff BOTH cores (state is bit-identical, only its
declaration changed — this is the real proof) AND `refs/BE/` byte-identical after rebuild;
`refs/MDD` and `refs/FE` are expected to change (storage widths, Description.yml). Then
`make refs` + commit. Watch the width pass: a dynamic-offset slice into a 256-bit XVR is
the one place the forward interval hugs Int256 (see [[operand-attributed-location]]); SFR
fields are ≤64-bit so fine.

Follow-up (not Phase 3): remove/re-engineer the unfinished STORE `Mask` (SLICE supersedes
it, per the user); lvx_v2 XACCESSO/XALIGNO migrate from the slot-4 proxy to `[k bits at e]`.

**Pushed** (lvx-mds `245c522`, superproject `33c050c`). The overdue `make refs` was also
run and committed (lvx-mds `245c522`): it caught refs up to the FP-RM (`29631f3`),
operand-attributed (`9391975`), and phase-2 (`ccff2a5`) YAML commits that never refreshed
refs, and added the never-committed BE/GEM5 refs (lvx_stages.h/.py, reg_operands.inc). So
`make diff` is now byte-clean = a good Phase-4 baseline. Caveat: `make check`'s osx
DTD-comment XML validation fails pre-existingly (MDD.dtd, untouched by this work) — use
`make diff` not `make check` to gate the reference tree.

See [[operand-attributed-location]] (what SLICE retires), [[lvx-roadmap]].
