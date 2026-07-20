---
name: risc-v-csr-unification
description: LVX SFR is being unified with RISC-V CSRs (FP first); CSRRW/CSRRS/CSRRC + csrnumber give RISC-V fcsr access to CS as a SLICE view, RSWAP-shaped
metadata:
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T17:48:02.403Z
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
- Deslice lowers all SLICEs (Opcode.table 0 SLICE), width clean, GBU roundtrip passes all 11.

**bcucode3 renumbering (user: no binary-compat requirement):** block now — CSRRW 10011, CSRRS
10100, CSRRC 10101, IGET 10110, RET/RFE 10111..11000, IGOTO/ICALL 11001..11010, SCALL(SCI) 11011,
SCALL(SCR) 11100, BREAK 11101. Free bcucode3 left: **11110-11111**.

**Operand/format facts learned:** `%1`=operands[0], `%2`=operands[1] (1-indexed); `%0` is a
mnemonic-modifier slot. Format wrapper reads operands + `MACRO.Instruction`; the Instruction
does the COMMIT (behavior) while the wrapper execution assigns `%1 = result1` (RSWAP asymmetry).
`(F2I.w (LOAD (SLICE.w (AGGL.SRS (CONST.4)(CONST.1)) (CONST.<CSfield>))))` reads a CS field;
`(STORE (SLICE.w …) (I2F.w <val>))` writes one (Deslice RMW preserves the rest).

**Next candidates (not started):** read-only `frcsr` / write-only `fscsr`, and `fflags`/`frm`
sub-CSRs (narrowings of the same shuffle); then machine-mode CSRs. The `$rvc` "RISC-V
configuration" SFR (SRS[40], "FIXME rename to RVC") is the hook for RISC-V config state.
Follow-up: `make -C BE/GBU install` + rebuild lvx-binutils/lvx-gdb to propagate the new opcode
encodings (they still hold the pre-renumber tables). See [[behavior-slice-plan]], [[lvx-roadmap]].
