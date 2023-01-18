#!/bin/bash

# configures the local user for 

source bin/PARAMETERS.sh

echo ""; echo "Removing possible old fingerprints for localhost"
ssh-keygen -R localhost
echo "DONE"

echo ""; echo "Copying public hostkey from container to local"
docker cp ${CONTAINER_NAME}:/etc/ssh/ssh_host_rsa_key.pub .
echo "DONE";

echo ""; echo "Adding hostkey to list of known hosts at ${HOME}"
echo "localhost " `cat ssh_host_rsa_key.pub` >>  ${HOME}/.ssh/known_hosts
echo "DONE";