#!/bin/bash



source bin/PARAMETERS.sh

echo ""; echo "Stopping and removing container ${CONTAINER_NAME} if one is running..."
docker container stop ${CONTAINER_NAME} -t 0
docker container rm   ${CONTAINER_NAME}
echo "DONE"

#  -d       runs detached
#  --name   provides container with a fresh name
#  -p       makes ssh port of container available at port 22 at localhost (provided this port is free)
#  --network bridge  connects to network

echo ""; echo "Starting ${CONTAINER_NAME} for docker image ${IMAGE_NAME}..."
docker run -d --name ${CONTAINER_NAME} --network bridge -p:22:22 --env USERNAME=${USERNAME} ${IMAGE_NAME} 
echo "DONE"

echo "";echo""; echo "Waiting a bit for output from entrypoint. Can repeat this manually:  docker logs ${CONTAINER_NAME}  "; echo "_______________________"; echo "";
sleep 5
docker logs ${CONTAINER_NAME}
echo "";


