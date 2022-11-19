#!/bin/bash

# generate a local docker image for the docker context in containers/${CONTAINER_NAME}/src
# 

CONTAINER_NAME=my-mysql

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

docker container stop ${CONTAINER_NAME}
docker container rm   ${CONTAINER_NAME}

docker build -t ${CONTAINER_NAME} ${DIR}/../src
