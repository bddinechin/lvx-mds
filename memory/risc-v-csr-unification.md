---
name: risc-v-csr-unification
description: LVX SFR is being unified with RISC-V CSRs (FP first); CSRRW/CSRRS/CSRRC + csrnumber give RISC-V fcsr access to CS as a SLICE view, RSWAP-shaped
metadata:
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-22T17:50:55.007Z
---

**Goal (user, the architect):** the final evolution of LVX SFR is unification with
RISC-V CSRs, **starting with floating-point and machine-mode registers**. Enabled by
the SFR-onto-SRS foundation (all SFRs now backed by SRS) — see [[behavior-slice-plan]].

**FP CSR — first step DONE + pushed (lvx-mds `ab7552d`, super `65020a6`).**

Mapping LVX `CS` (=SRS[4]) → RISC-V `fcsr` (verified):
- `fflags[4:0]` = **bit-reverse** of `CS[1:5]`: NX←CS_IN(5), UF←CS_UN(4), OF←CS_OV(3),
  DZ←CS_DZ(2), NV←CS_IO(1). (Not a relocation — a permutation; needs per-bit SLICEs.)
- `frm[7:5]` = `CS_RM[18:16]`, **encoding already RISC-V-compatible** (RNE/RTZ/RDN/RUP/RMM
  = enc 0..4; LVX adds Round-to-Odd at 6 where RISC-V reserves; both use 7=dynamic).
- Also removed the unused CS extension flags CS_XIO/XDZ/XOV/XUN/XIN (bits 9-13, RegField
  metadata only, 0 behavior refs) so fflags is main-only (lvx-mds `55720dc`).

**Mechanism finding (important):** a *computed cross-register view* (fcsr ← CS) canNOT
ride the generic SFR path — `<!ELEMENT Register EMPTY>` (registers carry no behavior), and
`get`/`set` are opaque helpers keyed on a register's *own* number+storage value. So there
is no per-register view hook. The clean path (user chose it) is a **dedicated instruction
whose hand-authored behavior does the SLICE shuffle** — no separate fcsr register/storage,
no runtime-helper hiding.

**Access = RSWAP-shaped** (RSWAP is exactly RISC-V `csrrw`: read-old/write-new; LVX even has an
`onlyswapReg` class for swap-only regs). **First cut was `FCSRSW`, then replaced (user) by the
three RISC-V primitives `CSRRW`/`CSRRS`/`CSRRC`** (lvx-mds `e48da08`, super `0df5c1a`).

- New 12-bit immediate **`csrnumber`** in `Immediate.yml` (`_ZX_12` like `sysnumber`), occupying
  the format's old reserved bcucode8+systemS4 bits. Shared format **`BCU_CSR`** (Format.yml):
  operands `{ singleReg registerZ, csrnumber }`, bcucode3 RANGE `[CSRRW,CSRRS,CSRRC]:10011..10101`
  (three instrs share one format, like RET/RFE share BCU_RTS). One register file → rd==rs1 (atomic
  self-swap): CSRRW CS←$r; CSRRS CS←old|$r; CSRRC CS←old&~$r; rd←old CSR in all three.
- Behavior (Instruction.yml CSRRW/CSRRS/CSRRC): `WRITE.result1 = IOR of 6 SLICE reads` (assemble
  old fcsr), then `(IF (EQ (READ.argument2) (CONST.3)) (SEQ WRITE.newval=<op> ; 6 STORE-to-SLICE
  RMWs distribute newval ; COMMIT.E1.%1 result1) (THROW.ID.OPCODE))`. **Only csrnumber 0x003 (fcsr)
  accepted; else THROW.ID.OPCODE.** fflags 0x001 / frm 0x002 left as easy extra dispatch arms.
  `newval` is a behavior variable → must be declared `new newval=…` in execution (WRITE requires
  `$Symbol{name}` predeclared, from execution's `new`; symbol table is flat, not scoped).
- **fflags 0x001 / frm 0x002 arms DONE + pushed (lvx-mds `86fd726`, super `72b2924`, 2026-07-22).**
  Each is a narrowing of the same shuffle, appended as `else-if` arms to the dispatch (fcsr stays
  0x003; anything else still THROWs). fflags = the 5 flag bits only (fcsr[4:0], CS_RM untouched);
  frm = rounding mode only, **right-aligned in bits 0..2** (RISC-V frm convention, not fcsr[7:5]) →
  CS_RM. COMMIT narrows result1 per arm: `(AND result1 31)` for fflags, `(AND (SHR result1 5) 7)` for
  frm. Validated in the gem5 ISS (`lvx-gem5/tests/lvx/csr_fcsr.s`): fflags=0x1f + frm=7 read back as
  fcsr 0xff. See [[gem5-hardware-loop]] for the SRS-in-gem5 substrate this runs on.
- Deslice lowers all SLICEs (Opcode.table 0 SLICE), width clean, GBU roundtrip passes all 11.

**bcucode3 renumbering (user: no binary-compat requirement):** block now — CSRRW 10011, CSRRS
10100, CSRRC 10101, IGET 10110, RET/RFE 10111..11000, IGOTO/ICALL 11001..11010, SCALL(SCI) 11011,
SCALL(SCR) 11100, BREAK 11101. Free bcucode3 left: **11110-11111**.

**Operand/format facts learned:** `%1`=operands[0], `%2`=operands[1] (1-indexed); `%0` is a
mnemonic-modifier slot. Format wrapper reads operands + `MACRO.Instruction`; the Instruction
does the COMMIT (behavior) while the wrapper execution assigns `%1 = result1` (RSWAP asymmetry).
`(F2I.w (LOAD (SLICE.w (AGGL.SRS (CONST.4)(CONST.1)) (CONST.<CSfield>))))` reads a CS field;
`(STORE (SLICE.w …) (I2F.w <val>))` writes one (Deslice RMW preserves the rest).

- **frcsr/fscsr/frflags/fsflags/frrm/fsrm pseudo-ops DONE + pushed (lvx-mds `ab1459c`, super
  `1c1dcfd`, 2026-07-22).** User chose **assembler pseudo-ops** over dedicated read-only/write-only
  arms. Added as **MDS Synthetic entries** (`lvx-family/FE/YAML/lvx/Synthetic.yml`): each is
  `instruction: CSRRS`/`CSRRW`, `formats: [BCU_CSR]`, `specialize: {"%2": "N"}` fixing csrnumber
  (fcsr=3/fflags=1/frm=2), `syntax: "%0 %1"`. fr*=csrrs (read), fs*=csrrw (write). Assemble-only:
  byte-identical to the raw csrrs/csrrw encodings, no new behavior; disasm round-trips them back as
  the pseudo mnemonic. Delivered to the assembler via `BE/GBU install` (→ lvx-binutils + lvx-gdb),
  and Synthetic *also* adds decode/Behavior tuple entries so `BE/GEM5 install` + gem5 rebuild is
  needed too. **Two gotchas:** (1) the FE runs `cpp` over the `*.yml`, so a `#`-first YAML comment
  is parsed as a bogus preprocessor directive — don't use `#` comments in the source YAML (only
  `#ifdef` feature guards); (2) self-swap means fr* is the RISC-V read *encoding*, not a pure read.
  See [[gem5-hardware-loop]] for the SRS-in-gem5 substrate.

- **Read-only machine ID CSRs DONE + pushed (lvx-mds `7955068`, super `a396e60`, 2026-07-22).**
  mvendorid(0xF11)/marchid(0xF12)/mimpid(0xF13)/mhartid(0xF14)/misa(0x301), **all read 0** (user
  chose all-zero: mhartid 0 = single hart SE mode, rest = not-implemented). Folded into **one**
  dispatch arm via `IORL` of five `EQ`s (logical-or is `IORL`, not ORL) → `COMMIT.E1.%1 (CONST.0)`,
  no store — read-only, **writes ignored** in the self-swap model (any of csrrw/csrrs/csrrc reads
  the value). Unknown csrnumbers still THROW (verified: 0x999 → SIGILL). Behavior-only, **no
  encoding change → binutils untouched**; `CONST.0xF11` hex is accepted (lexed to decimal 3857).
  Test `lvx-gem5/tests/lvx/csr_machine.s` → 0.

- **Machine TRAP CSRs (direct four) DONE + pushed (lvx-mds `2f738b9`, super `49139f2`, 2026-07-22).**
  User chose the direct 64-bit RW pass-throughs (deferred the field-mapped mstatus/mcause): **mepc
  0x341↔SPC(SRS128), mtval 0x343↔EA(136), mtvec 0x305↔EV(140), mscratch 0x340↔SR(144)**. Each arm:
  read old SFR → COMMIT %1=old; STORE SFR = swap(csrrw=arg1) / OR(csrrs) / AND-NOT(csrrc). Whole-SFR
  RMW, no field shuffle. Unimplemented csrnumbers (incl. mcause 0x342) still THROW. Behavior-only, no
  encoding change → binutils untouched. Uses the existing `readFromStorage_SFR` (idx<256 fits gem5's
  misc-reg space). Test `csr_trap.s` → 0x99=153.
- **CodeGen gotcha (cost a regression):** the trap arms first REUSED `result1` (the fcsr-assembly var)
  for the old-SFR value. Because `result1` was then written in two regions (top fcsr + trap arms), the
  Behavior CodeGen **dropped the top `result1 = <fcsr>` assignment**, silently zeroing fcsr/fflags/frm
  reads (csr_fcsr 255→0). Fix: give the trap arms a **dedicated `oldval`** variable. Rule: don't reuse a
  behavior variable across mutually-exclusive dispatch arms if it's also written before the dispatch.

**Next candidates (not started):** field-mapped mstatus↔PS (PS_IE@4→MIE@3, PS_PL@0-1→MPP@11-12, …)
and mcause↔ES (ES_EC exception-class → RISC-V cause codes); interrupt CSRs mie/mip↔ILE/ILL/ILR. The `$rvc` "RISC-V
configuration" SFR (SRS[40], "FIXME rename to RVC") is the hook for RISC-V config state.
Follow-up: `make -C BE/GBU install` + rebuild lvx-binutils/lvx-gdb to propagate the new opcode
encodings (they still hold the pre-renumber tables). See [[behavior-slice-plan]], [[lvx-roadmap]].
