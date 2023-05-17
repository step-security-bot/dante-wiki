#!/bin/bash

# pull new stuff into reference volume on target machine
../volumes/full/spec/git-clone-dante-from-parsifal.sh


docker cp ${SRC} ${TEMP}:/${MOUNT}/${VOLUME_PATH}
printf "DONE cp\n"

printf "*** Setting permissions on ${MOUNT} to 100.101 for apache.apache  ..."
docker exec ${TEMP} /bin/ash -c "chown -R 100.100 ${MOUNT}"
printf "DONE fixing permissions\n"

