#!/bin/bash

source ./global-names.sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1

source ${FAMILY_NAME}/def/defineTask.sh ${FAMILY_NAME}