---
name: feedback-mirror-memory-in-lvx-mds
description: refresh the tracked lvx-mds/memory/ copy from the canonical ~/.claude store before committing memory changes there
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6afcafe0-f986-479d-b8bd-483d5bb2bfeb
  modified: 2026-07-20T16:00:52.172Z
---

The user keeps a **versioned mirror** of this session memory at
`/home/bd3/lvx-csw/lvx-mds/memory/` (committed in the lvx-mds repo), in addition to
the canonical file-based store at
`/home/bd3/.claude/projects/-home-bd3-lvx-csw/memory/`.

**Why:** the tracked copy is a snapshot and silently drifts from the canonical store
as memory is edited during a session — the two must be resynced or the versioned copy
goes stale.

**How to apply:** whenever memory files here change and a commit touching
`lvx-mds/memory/` is about to happen, first refresh the mirror, then commit:
`cp /home/bd3/.claude/projects/-home-bd3-lvx-csw/memory/*.md /home/bd3/lvx-csw/lvx-mds/memory/`
(this copies MEMORY.md + all note `.md`s; it does NOT touch `lvx-mds/memory/README.md`,
which is a mirror-only file with no counterpart in the store). The canonical store is
its own git repo too (`master`); commit both if versioning both.
