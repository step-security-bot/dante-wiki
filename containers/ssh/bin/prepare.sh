#!/bin/bash
#

# generate a universal public, private key pair that we shall use for logging in into EVERY container running this image

# get directory this shell is running in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/PARAMETERS.sh

rm -f ${DIR}/../login-key ${DIR}/../login-key.pub ${DIR}/../src/login-key.pub
ssh-keygen -f ${DIR}/../login-key

chmod 0400 ${DIR}/../login-key

# copy the PUBLIC key into the docker context area
cp ${DIR}/../login-key.pub ${DIR}/../src

echo "Removing entries for localhost in known_hosts, error not found is ok"
ssh-keygen -R localhost
echo "DONE"