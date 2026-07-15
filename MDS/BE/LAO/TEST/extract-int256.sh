#!/bin/sh
# Copyright (C) 2026 Liesme Tech.
# Benoît Dupont de Dinechin (benoit.dinechin@gmail.com).
# Distributed under the GNU General Public License, version 2 or later.
#
# Build a compilable Int256_/Int128_ out of kvx-lao.
#
# The generated Behavior C computes everything in Int256_, Kalray's 256-bit integer
# arithmetic, which lives in kvx-lao (LAO/CDT/BSL/Int256.c) and is not part of this
# repo.  It is written in the XCC literate style: header and body share one file,
# the header being the "#ifdef $XCC_h" blocks.  XCC splits them; so does this, so
# that a plain cc can build it.
#
# Nothing here is vendored -- it is fetched, so the oracle stays whatever kvx-lao
# says it is.  Needs `gh` authenticated against the repo.
set -eu

REPO=${INT256_REPO:-bddinechin/kvx-lao}
REF=${INT256_REF:-main}
OUT=${1:-int256}

mkdir -p "$OUT/BSL"
cd "$OUT"

for f in Int128 Int256; do
    gh api "repos/$REPO/contents/LAO/CDT/BSL/$f.c?ref=$REF" --jq .content | base64 -d > "$f.c"
done

python3 - <<'EOF'
for name in ('Int128', 'Int256'):
    hdr, body, mode = [], [], None
    for line in open(f'{name}.c'):
        s = line.strip()
        if s.startswith('#ifdef $XCC_h'):          mode = 'h';    continue
        if s.startswith('#ifdef $XCC'):            mode = 'skip'; continue
        if s.startswith('#endif') and '$XCC' in s: mode = None;   continue
        if   mode == 'h':  hdr.append(line.rstrip('\n'))
        elif mode is None: body.append(line.rstrip('\n'))
    open(f'{name}.h', 'w').write('\n'.join(hdr) + '\n')
    # The bodies #include the BSL headers XCC would have generated; we have them already.
    open(f'{name}_body.c', 'w').write(
        '\n'.join(l for l in body if not l.startswith('#include "BSL/')) + '\n')
EOF

# softfloat_types.h is only needed for the float views of the Int256_ union; the
# integer arithmetic never touches them, so opaque types are enough.
cat > softfloat_types.h <<'EOF'
#pragma once
#include <stdint.h>
typedef struct { uint16_t v; } float16_t;
typedef struct { uint32_t v; } float32_t;
typedef struct { uint64_t v; } float64_t;
EOF

: > BSL/BSL_.h

cat > int256rt.h <<'EOF'
#pragma once
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <stdarg.h>
#define LITTLEENDIAN 1
#include "softfloat_types.h"
#define BSL_Test(cond, msg) do { if (!(cond)) { fprintf(stderr, "FAIL %s\n", msg); abort(); } } while (0)
#include "Int128.h"
#include "Int256.h"
EOF

cat > rt.c <<'EOF'
#include "int256rt.h"
#include "Int128_body.c"
#include "Int256_body.c"
EOF

cc -O2 -I. -c rt.c -o rt.o
echo "int256 runtime built in $(pwd): rt.o, int256rt.h"
