#!/bin/bash

echo -n "use exception test "
LD_LIBRARY_PATH=. ./use-rtti-excep >/dev/null
if [ $? == 0 ]; then
    echo PASS
else
    echo FAIL
fi
