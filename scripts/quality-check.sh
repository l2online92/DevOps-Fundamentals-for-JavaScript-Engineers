#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=${SCRIPT_DIR%/*}
CLIENT_BUILD_DIR=$ROOT_DIR/dist/static

cd $ROOT_DIR/client && npm run lint && npm run test && npm audit

if [ $? -eq 0 ]; then
    echo "SUCCESS"
else
    echo "FAIL"
fi
