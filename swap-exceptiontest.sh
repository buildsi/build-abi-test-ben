#!/bin/bash

echo -n "exception swap test "
export SWAP_LIB_FILENAME=libswapfile
echo librttiexcep_v1.so librttiexcep_v2.so > $SWAP_LIB_FILENAME

LD_AUDIT=../tools/swap-libs-audit.so LD_LIBRARY_PATH=. ./use-rtti-excep 2>&1 >/dev/null |:
if [ ${PIPESTATUS[0]} == 0 ]; then
    echo PASS
else
    echo FAIL
fi

