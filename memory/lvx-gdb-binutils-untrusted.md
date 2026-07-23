---
name: lvx-gdb-binutils-untrusted
description: "The binutils bundled inside lvx-gdb (its objdump/gas/lvx-dis.c) is NOT trustworthy — only lvx-binutils' assembler/binary-utilities are authoritative"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T20:39:11.402Z
---

The GNU Binutils components that live inside the `lvx-gdb` tree (its own `objdump`,
`gas`, and especially its hand-maintained `opcodes/lvx-dis.c`) **cannot be trusted** and
must not be used for validating LVX encodings/disassembly. **Only `lvx-binutils`'
assembler and binary utilities are authoritative.**

**Why:** `lvx-dis.c` is hand-maintained (NOT MDS-generated — GBU only generates
`lvx-opc.c`/`lvx.h`/`lvx-parse.h`/reloc headers), so `lvx-binutils` and `lvx-gdb` each
carry their *own* divergent copy. `lvx-gdb`'s copy lags: e.g. after adding the
`csrnumber` immediate, `lvx-gdb`'s objdump aborts with
`unexpected operand type (lvx_v1_csrnumber_opnd)` while `lvx-binutils`' objdump
disassembles it fine. gdb links the regenerated opcode tables only for its own
target-support code; its bundled disassembler is not a reference.

**How to apply:** validate assembly/disassembly/roundtrip exclusively with
`lvx-toolchain/bin/lvx-mbr-{as,objdump,...}` (built from `lvx-binutils`). When rebuilding
after a `BE/GBU install`, a green `lvx-gdb` *link* is enough — do not treat its
objdump/gas output as ground truth, and don't chase disasm discrepancies originating in
`lvx-gdb`'s binutils. See [[risc-v-csr-unification]].
