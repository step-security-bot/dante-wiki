#!/bin/bash

# copies the contents of directory volumes/${DIR_NAME}/content to the volume ${VOLUME_NAME} and there at path ${VOLUME_PATH}
# additionally executes shell commands in volumes/${DIR_NAME}/spec/cmd.sh

# DIR_NAME      we are copying from  volumes/${DIR_NAME}/
# VOLUME_NAME   we are copying to VOLUME_NAME
# VOLUME_PATH   we are copying to VOLUME_PATH in VOLUME_NAME


# Parse the command line
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 DIR_NAME VOLUME_NAME  VOLUME_PATH " >&2
  echo "Adds contents of directory DIR_NAME to volume VOLUME_NAME at VOLUME_PATH " >&2
  exit 1
else
  export DIR_NAME=$1
  export VOLUME_NAME=$2
  export VOLUME_PATH=$3
fi



## two temporary symbols
#  TEMP: Name of the temporary busybox container which does the copying
export TEMP=temporary-busybox
#  MOUNT: where the volume is mounted to the temporary copying container
export MOUNT=/mnt

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# source directory on host
SRC=${DIR}/../../../volumes/${DIR_NAME}/content/.

echo ""

##
## STARTING service job running the alpine OS
##
echo "Starting a temporary container ${TEMP} for ${VOLUME_NAME} "

docker run --name ${TEMP} -d -t --volume ${VOLUME_NAME}:/${MOUNT} alpine

echo
echo _____
echo "Will now copy from volumes/${VOLUME_NAME}/content/. into  ${TEMP}:/${MOUNT}/${VOLUME_PATH}"
# NOTE: we copy into the mount point at the container, not into the volume
docker cp ${SRC} ${TEMP}:/${MOUNT}/${VOLUME_PATH}
echo

echo "now doing: docker exec ${TEMP} ${SRC}/../spec/cmd.sh "
echo ""

echo ""
${SRC}/../spec/cmd.sh

#/Users/cap/DOCKER/continuous-deployment-test/volumes/minimal/spec/cmd.sh


echo "Stopping and removing temporary container"
echo
docker stop ${TEMP}
docker rm ${TEMP}
echo