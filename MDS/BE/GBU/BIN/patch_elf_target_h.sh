#!/bin/bash

set -e
set -u

ACTION=$1
shift

FAMILY=$1
START_PAT_ARG=$2
INPUT=$3

OUTPUT=$4

## look for start pattern in header. If not there, most likely an error.
start_pat=$(head -n10 ${INPUT} | grep ${START_PAT_ARG} | sed -e "s/.*\<\([^[:space:]]*${START_PAT_ARG}[^[:space:]]*\)\>.*/\1/g")
start_pat=$(echo -e "${start_pat}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

tgt_start=$(grep -n "${start_pat}" ${OUTPUT} | cut -d: -f1)

stop_pat=$(echo "${start_pat}"| sed -e s/START/END/g)
tgt_stop=$(grep -n ${stop_pat} ${OUTPUT} | cut -d: -f1)

##last_line=$(sed "$((${tgt_stop} + 1))q;d" ${OUTPUT})

if [[ "$ACTION" == "EXTRACT" ]]; then
    sed -n "${tgt_start},$((${tgt_stop}))p;${tgt_stop}q" ${OUTPUT}
else
    head -n $((${tgt_start} - 1)) ${OUTPUT} > ${OUTPUT}.swap
    cat ${INPUT} >> ${OUTPUT}.swap
    sed -n "$((${tgt_stop} + 1 )),\$p;" ${OUTPUT} >> ${OUTPUT}.swap
    mv ${OUTPUT}.swap ${OUTPUT}
fi
