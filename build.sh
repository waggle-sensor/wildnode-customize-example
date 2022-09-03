#!/bin/bash -e

BASE_WORKDIR="./_workdir"
BASE_BUILD_CMD="./build.sh"

# sync the base code & overlay our changes on top
./overlay.sh $BASE_WORKDIR

## Execute build command
echo "-- Execute build command [${BASE_BUILD_CMD} ${@}] --"
pushd ${BASE_WORKDIR}
${BASE_BUILD_CMD} ${@}
popd
