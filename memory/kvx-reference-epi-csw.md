---
name: kvx-reference-epi-csw
description: Use ../epi-csw (not Work2/kvx-csw) for KVX-related issues; Behavior-helper runtime is in ../epi-csw/lao/LAO
metadata: 
  node_type: memory
  type: reference
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
---

For all KVX-related reference material, look in **`/home/bd3/epi-csw/`** (i.e. `../epi-csw/` relative to `lvx-csw/`), not the older `/home/bd3/Work2/kvx-csw/` that the repo CLAUDE.md files still point at.

**Why:** the user directed this on 2026-07-18, superseding the CLAUDE.md paths for KVX lookups.

**In particular — run-time support for Behavior helpers (the ISS/LAO helper implementations, the reference for `lvx-gem5`'s shim) lives in `../epi-csw/lao/LAO`:**
- `../epi-csw/lao/LAO/kvx/Behavior.c` — the Behavior helper implementations (e.g. `Behavior_bcucond`, srhpc, guard, etc.)
- `../epi-csw/lao/LAO/kvx/Behavior_softfloat.h` — FP helper bodies
- `../epi-csw/lao/LAO/kvx/kvx/Interpreter.c`, `../epi-csw/lao/LAO/ECL/JIT/Interpreter.c`

When implementing/porting a Behavior helper into the gem5 shim (see [[gem5-callret-blocker]]), mirror `../epi-csw/lao/LAO/kvx/Behavior.c` rather than the KVX `iss_core/.../helpers_core.h`. Related: [[lvx-roadmap]].
