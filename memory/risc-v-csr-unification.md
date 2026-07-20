---
name: risc-v-csr-unification
description: LVX SFR is being unified with RISC-V CSRs (FP first); FCSRSW gives RISC-V fcsr access to CS as a SLICE view, RSWAP-shaped
metadata:
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T17:07:09.144Z
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

**`FCSRSW` = RSWAP-shaped atomic swap** (RSWAP is exactly RISC-V `csrrw`: read-old/write-new;
LVX even has an `onlyswapReg` class for swap-only regs). `fcsrsw $r`: `$r ← fcsr(CS)` while
`CS ← unshuffle(old $r)`, atomic. Behavior in `Instruction.yml` (ID FCSRSW): result1 = IOR of
six SLICE reads of CS (5 flags reversed + RM<<5); six STORE-to-SLICE RMWs distribute old $r
back (preserving CS_IC/XMF/CC); `COMMIT.E1.%1 result1`. Format `BCU_FCSRSW` in `Format.yml`:
reuses BCU_RSWAP steering (steering 00, bcucode1 01, bcucode2 1111), one `singleReg`
operand (%1; CS implicit), 9-bit systemS4 slot reserved. Deslice lowers all SLICEs (Opcode.table
0 SLICE, 18 AGGL.SRS cell-4 accesses), width clean, GBU roundtrip passes both cores.

**bcucode3 renumbering (user: no binary-compat requirement):** rotated the BCU block so FCSRSW
leads — FCSRSW 10011, IGET 10100, RET/RFE 10101..10110, IGOTO/ICALL 10111..11000, SCALL(SCI)
11001, SCALL(SCR) 11010, BREAK 11011. Free bcucode3 remaining in this group: 11100-11111.

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
