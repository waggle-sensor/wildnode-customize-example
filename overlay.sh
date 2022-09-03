#!/bin/bash -e

BASE_TAG=$(cat ./base_image_tag | xargs)
MD5SUM_FILE="/tmp/wildnode_rootfs.md5"
BASE_GITHUB_URL="https://github.com/waggle-sensor/wildnode-image.git"
BASE_WORKDIR="${1:-./_workdir}"
SECRET_VERSION_FILE="ROOTFS/etc/waggle_version_os_secrets"
NAME=$(cat ./project_name | xargs)

if [ -z ${BASE_TAG} ]; then
    echo "Error: no base tag found. Required to clone base code."
    exit 1
fi

# create version string
PROJ_VERSION="${NAME}-$(git describe --tags --long --dirty | cut -c2-)"

echo "Production Build Parameters:"
echo -e " Base Tag:\t${BASE_TAG}"
echo -e " Version:\t${PROJ_VERSION}"
echo

## Build an MD5sum of all files
echo "-- Build md5sum catalog of customizations --"
find ROOTFS/ -type f -exec md5sum {} \; > ${MD5SUM_FILE}

## Pull down the base source code
echo "-- Fetch the base source code --"
rm -rf ${BASE_WORKDIR}
mkdir -p ${BASE_WORKDIR}

# need latest git history, so that the base source build steps can properly verison the resulting image
if ! git clone --depth 1 --branch ${BASE_TAG} ${BASE_GITHUB_URL} ${BASE_WORKDIR}; then
    echo "Error: Unable to clone base code [${BASE_GITHUB_URL}:${BASE_TAG}]"
    exit 1
fi
# Tell `git` to ignore our changes, we don't want them to "dirty" the repo
pushd ${BASE_WORKDIR}
git update-index --assume-unchanged $(git ls-files | tr '\n' ' ')
popd

## Apply system customizations
echo "-- Apply customizations --"
# copy over our ROOTFS customizations
rsync -av ./ROOTFS/ ${BASE_WORKDIR}/ROOTFS

# Any extra work that needs to be done
## Placeholder location for any additional file system modifications

## Add our "secrets" version file
echo "-- Save project version to filesystem --"
pushd ${BASE_WORKDIR}
echo ${PROJ_VERSION} > ${SECRET_VERSION_FILE}
popd

## Validate files in base source code contain changes
echo "-- Validate customizations --"
pushd ${BASE_WORKDIR}
md5sum -c ${MD5SUM_FILE}
popd