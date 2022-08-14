#!/bin/bash

SCRIPT_DIR=$(dirname "$(readlink -f "$BASH_SOURCE")")
ROOT_DIR=${SCRIPT_DIR%/*}
CLIENT_BUILD_DIR=$ROOT_DIR/dist/static

clientBuildFile=$ROOT_DIR/dist/client-app.zip

export $(grep -v '^#' $ROOT_DIR/.env | xargs -d '\n')

if [ -e "$clientBuildFile" ]; then
    rm "$clientBuildFile"
    echo "$clientBuildFile was removed."
fi

cd $ROOT_DIR/client && npm install && ng build --configuration=$ENV_CONFIGURATION --output-path=$CLIENT_BUILD_DIR
7z a -tzip $clientBuildFile $CLIENT_BUILD_DIR/*
