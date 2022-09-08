#!/bin/bash -e

BASE_WORKDIR="./_workdir"
BASE_BUILD_CMD="./build.sh"

# create version string
PROJ_VERSION="$(cat ./project_name | xargs)-$(git describe --tags --long --dirty | cut -c2-)"

# sync the base code & overlay our changes on top
./overlay.sh $BASE_WORKDIR

## Execute build command
echo "-- Execute build command [${BASE_BUILD_CMD} ${@} -e ${PROJ_VERSION}] --"
pushd ${BASE_WORKDIR}
${BASE_BUILD_CMD} ${@} -e ${PROJ_VERSION}
popd
