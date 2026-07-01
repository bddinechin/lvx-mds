#!/bin/bash

set -e
set -u

SRC="$1"
shift

# get line number after last #include
line=$(grep -n '^#include' "$SRC" | tail -n1 | cut -d: -f1)
line=$(($line + 1))

# put the qemu header
cat <<EOF
/*
 * KVX opcode support
 *
 * Copyright (c) 2021 Kalray SA
 *
 * This work is licensed under the terms of the GNU GPLv2 or later.
 * See the COPYING file in the top-level directory.
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

#include "kvx-compat.h"
#include "kvx.h"

/* The core of the file is extracted from binutils libopcodes. */
EOF

# put the opcodes without copyright header and #includes
tail -n "+$line" "$SRC"
