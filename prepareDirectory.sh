#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1

mkdir ${FAMILY_NAME}
mkdir ${FAMILY_NAME}/build
mkdir ${FAMILY_NAME}/src
mkdir ${FAMILY_NAME}/def

# copy but do not overwrite a possibly existing file
cp -n defineTask-template ${FAMILY_NAME}/def/defineTask.sh
chmod 700 ${FAMILY_NAME}/def/defineTask.sh
rm    ${FAMILY_NAME}/build/*