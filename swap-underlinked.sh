#!/bin/bash

echo -n "underlink swap test "
export SWAP_LIB_FILENAME=libswapfile
echo libunderlink1.so libunderlink2.so > $SWAP_LIB_FILENAME

LD_AUDIT=../tools/swap-libs-audit.so LD_LIBRARY_PATH=. underlinktest 2>&1 |:
if [ ${PIPESTATUS[0]} == 0 ]; then
    echo PASS
else
    echo FAIL
fi

