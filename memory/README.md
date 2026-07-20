# Project memory (mirror)

This directory is a **versioned mirror** of the assistant's file-based memory store for
the `lvx-csw` / `lvx-mds` work. The canonical, live copy lives at:

    /home/bd3/.claude/projects/-home-bd3-lvx-csw/memory/

The notes here (roadmap, gem5 ISS status, KVX reference, operand-attributed Location /
slot-4 proxy, named-constants feedback, the Behavior SLICE plan, …) are kept under git so
the design rationale is versioned alongside the code it describes. `MEMORY.md` is the index.

## Refresh before committing

The mirror is a snapshot and drifts as the canonical store is edited. **Before committing
any change under `memory/`, resync from the store:**

    cp /home/bd3/.claude/projects/-home-bd3-lvx-csw/memory/*.md lvx-mds/memory/

That copies `MEMORY.md` and every note; it does **not** touch this `README.md`, which is a
mirror-only file with no counterpart in the store. Then `git add memory/ && git commit`.
