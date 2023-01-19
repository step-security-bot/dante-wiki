#!/bin/bash

# run a lap image in a container serving files from a local directory or from a docker volume
#
# serves files from ${MOUNT} 
# gets these files by attaching the volume with name ${VOLUME_NAME} at ${MOUNT}
#
# PARAMETERS:
#   Variant 1: Interactive read from stdin
#   Variant 2: Called with parameters
#     run.sh --dir NAME
#     run.sh --vol NAME
#

MODE=PHP
export MODE


IMAGE_NAME=lap
## COULD be: lap    or    tex

usage() {
  echo "Usage: $0 --dir DIR_NAME          - OR - "
  echo "Usage: $0 --vol VOLUME_NAME       - OR -preserves volume as it is "
  echo "Usage: $0 --cleanvol VOLUME_NAME - deletes volume before use "
  echo "Serving files from a DOCKER VOLUME or from a LOCAL DIRECTORY "
}

if [ "$#" -eq 0 ]; then    ### Variant 1: We were called without parameters: Do an interactive read from stdin
  read -p "Enter name of DOCKER VOLUME or PRESS RETURN for local directory: " VOLUME_NAME
  if [ -z "$VOLUME_NAME" ]; then 
    echo ""
    read -p "Enter LOCAL DIRECTORY (name, no path, top level at project): " DIR_NAME
  else 
    DIR_NAME="" 
  fi
else                      ### Variant 2: We were called with parameters.
  case $1 in 
    (--dir) 
      DIR_NAME=$2;;
    (--vol) 
      VOLUME_NAME=$2;;
    (--cleanvol)
      MUST_CLEAN=doit
      VOLUME_NAME=$2;;
    (*) 
       echo "Error parsing options - aborting" 
       usage 
       exit 1
  esac
fi

# mount starting point in the case when we are using a directory
MOUNT_DIR=/var/www/html

# mount starting point in the case when we are using a volume
MOUNT_VOL=/var/www/html

# NETWORK_NAME is imported and set by calling shell both.sh  # TODO: hm???

NETWORK_NAME=dante-network

# name of the generated container
CONTAINER_NAME=my-lap-container

# name of the host 
HOST_NAME=my-lap-container

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "*** Cleaning up existing ressources"
echo -n "* Stopping container: "
# -t 0 since the LAP can be shot down quickly
docker container stop ${CONTAINER_NAME} -t 0

echo -n "*    Removing container: "
docker container rm   ${CONTAINER_NAME}
echo "" 


if [ "$MUST_CLEAN" == "doit" ]; then
  echo ""
  echo "*** REMOVING volume ${VOLUME_NAME}"
  docker volume rm ${VOLUME_NAME}
fi

echo "*** Running docker image ${IMAGE_NAME} as container ${CONTAINER_NAME}"

if [ -z "$NETWORK_NAME" ]; then NET_SPEC=""; else NET_SPEC="--network ${NETWORK_NAME}"; fi

if [ -z "$DIR_NAME" ]; then  
  VOL_SPEC="--volume ${VOLUME_NAME}:/${MOUNT_VOL}" 
else 
  VOL_SPEC="--volume ${DIR}/../../../volumes/${DIR_NAME}/content:${MOUNT_DIR} "
fi

echo "NET specification: ${NET_SPEC}"
echo "VOL specification: ${VOL_SPEC}"
echo ""

echo "*** Creating LAP container and got id= " `
docker run -d --name ${CONTAINER_NAME} \
  -p  80:80 \
  -p 443:443 \
  ${NET_SPEC} \
  ${VOL_SPEC} \
  -h ${HOST_NAME}                 \
  --env MODE=${MODE}  \
  ${IMAGE_NAME}  `


# DIR_NAME is empty and we are working on a volume
if [ -z "$DIR_NAME" ]; then
  open -a "Google Chrome"  http://localhost/index.html
fi

if [ -z "$VOLUME_NAME" ]; then
  open -a "Google Chrome"  http://localhost/index.html
fi

