#!/bin/bash -e

BASE_TAG=$(cat ./base_image_tag | xargs)
MD5SUM_FILE="/tmp/wildnode_rootfs.md5"
BASE_GITHUB_URL="https://github.com/waggle-sensor/wildnode-image.git"
BASE_WORKDIR="${1:-./_workdir}"

if [ -z ${BASE_TAG} ]; then
    echo "Error: no base tag found. Required to clone base code."
    exit 1
fi

## Build an MD5sum of all files
echo "-- Build md5sum catalog of customizations --"
find ROOTFS/ -type f -exec md5sum {} \; > ${MD5SUM_FILE}

## Pull down the base source code
echo "-- Fetch the base source code --"
rm -rf ${BASE_WORKDIR}
mkdir -p ${BASE_WORKDIR}

# need latest git history, so that the base source build steps can properly verison the resulting image
echo "-- Clone the base repo [${BASE_GITHUB_URL}:${BASE_TAG}] --"
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

## Validate files in base source code contain changes
echo "-- Validate customizations --"
pushd ${BASE_WORKDIR}
md5sum -c ${MD5SUM_FILE}
popd