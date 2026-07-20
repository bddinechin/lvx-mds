---
name: feedback-named-constants
description: "Bd wants latencies/stages as named enums from a backend-generated header, never magic numbers scattered in code"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-19T17:43:11.440Z
---

When wiring pipeline latencies (or similar ISA-derived constants) into the gem5
LVX port, **do not scatter numerical constants** (opLat 3, threshold 15, read
stage 1, …) across `reg-operands.pl` / `static_inst.cc` / `LvxCPU.py`. Define a
**named enum with an LVX/Lvx/lvx prefix in a header the GEM5 backend generates**
(from the authoritative MDS tables), and use the names everywhere.

**Why:** the numbers are ISA facts (the pipeline stages live in
`Processor.table`: `pipeline="ID RR E1 E2 CR E3 E4 E5 WB SF SR"`,
`stages="0 1 2 3 4 4 5 6 6 16 24"`). A magic number is unverifiable and drifts;
a generated enum keeps one source of truth. Neutral **stage** names (E1, E3, SF,
SR) are better than semantic latency names (ALU/LOAD/FP) — the latter mislabel
(e.g. calling latency-3 "float arith" is wrong: FP16 FADD/FMUL/FFMA are 3 cycles
but FP32/FP64 are 4; the per-opcode latency in the generated table already gets
this right, so don't re-encode a coarse semantic label). Latency = writeStage -
LVX_STAGE_RR.

**How to apply:** BE/GEM5 emits `lvx_stages.h` (C enum `LvxStage`) + a Python
twin from `Processor.table`; `static_inst.cc` and the FU pool in `LvxCPU.py` use
`LVX_STAGE_* - LVX_STAGE_RR`, not literals. See [[operand-attributed-location]].
