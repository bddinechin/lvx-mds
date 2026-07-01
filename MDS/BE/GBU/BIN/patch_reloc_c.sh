#!/bin/bash

# Patch BFD's reloc.c with our set of relocations. Try to be smart,
# but can't guaranty this will always work (if START/STOP relocations
# names are changed for example).

set -e
set -u

ACTION=$1
shift

FAMILY=$1
START_PAT_ARG=$2
INPUT=$3

OUTPUT=$4

## look for start pattern in header. If not there, most likely an error.
start_pat=$(head -n10 ${INPUT} | grep ${START_PAT_ARG})
start_pat=$(echo -e "${start_pat}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

tgt_start=$(grep -n ${start_pat} ${OUTPUT} | cut -d: -f1)

# Pattern must be on second line
tgt_start=$((${tgt_start} - 1))

stop_pat=$(echo ${start_pat}| sed -e s/START/END/g)
tgt_stop=$(grep -n ${stop_pat} ${OUTPUT} | cut -d: -f1)

last_line=$(sed "$((${tgt_stop} + 1))q;d" ${OUTPUT})
if [[ $last_line =~ ENUMDOC ]]; then
    # If we have an doc string at the end, skip until next ENUM, that
    # should be the first enum for next arch.

    tgt_stop=$(sed "/${stop_pat}/,/^ENUM$/!d;/^ENUM$/=;/.*/d"  ${OUTPUT})
fi

if [[ "$ACTION" == "EXTRACT" ]]; then
    sed -n "${tgt_start},$((${tgt_stop} - 1))p;${tgt_stop}q" ${OUTPUT}
else
    head -n $((${tgt_start} - 1)) ${OUTPUT} > ${OUTPUT}.swap
    cat ${INPUT} >> ${OUTPUT}.swap
    sed -n "${tgt_stop},\$p;" ${OUTPUT} >> ${OUTPUT}.swap
    mv ${OUTPUT}.swap ${OUTPUT}
fi
