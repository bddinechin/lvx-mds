---
name: lvx-roadmap
description: "LVX project overall goal, validation strategy, and near/medium/long sequencing"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
---

Overall goal: build the LVX toolchain, eventually an LVX CPU. **Near-term priority: a working LVX ISS (the gem5 port `lvx-gem5`) to validate the GCC, LLVM, and MLIR-to-machine-code back-ends** (each started in separate sessions). The ISS is the shared validation substrate for all three compilers.

Key architectural constraint: `Behavior` (S-expr IR in `lvx-mds`) is the single source of truth, and the gem5 ISS **is Behavior compiled** (`BE/LAO` tuple + `Decode.c` verbatim). So any Behavior-derived model shares source with gem5 and can't independently validate it — the validation oracle must be **independent of Behavior**, namely **native-x86 differential execution** (compile same C to x86 + LVX, diff stdout/exit). All three compilers share this one oracle.

Sequencing: (Now) finish gem5 coverage + native-x86 diff harness + newlib runtime, fix blocking `lvx-gcc` codegen bugs. (Then) KVX-ISS/SoftFloat helper-level oracle for opaque FP/SIMD `APPLY` bodies. (Medium) `Behavior → Sail` emitter for formal spec / Isla / Sail typecheck-as-CI. (Long) `Sail → SystemVerilog` as a formal per-instruction reference for RTL verification (silicon). Orthogonal/deferrable: `Execution → Behavior` single-source authoring — NOT on the ISS critical path since the ISS consumes Behavior directly.

`Behavior → Sail` is explicitly NOT a gem5 oracle (shared source; can't model the VLIW bundle front-end) — it's for the formal/silicon payoffs only.

Full write-up in the repo at `lvx-csw/ROADMAP.md`. See also [[gem5-is-behavior-compiled]] once written.
