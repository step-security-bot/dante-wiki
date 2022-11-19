#!/bin/bash

# generate a local docker image for the docker context in containers/${CONTAINER_NAME}/src

CONTAINER_NAME=lap

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## clean up existing old stuff
echo ""
echo "CLEANING UP EXISTING CONTAINERS...this may cause error messages"
echo ""

# -t 0 as the LAP can be shot down quickly
docker container stop ${CONTAINER_NAME} -t 0
docker container rm   ${CONTAINER_NAME}
echo ""
echo "CLEAN!"

echo ""
echo "BUILDING container with name ${CONTAINER_NAME} from docker context at ${DIR}/../src"
echo ""

docker build -t ${CONTAINER_NAME} ${DIR}/../src
