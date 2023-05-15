#!/bin/bash
#

# generate a universal public, private key pair that we shall use for logging in into EVERY container running this image

# get directory this shell is running in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/PARAMETERS.sh

rm -f login-key login-key.pub src/login-key.pub
ssh-keygen -f login-key

chmod 0400 login-key

# copy the PUBLIC key into the docker context area
cp login-key.pub src

ssh-keygen -R localhost