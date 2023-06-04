#!/bin/bash

printf "*** Stopping lap and mysql containers and removing them - takes a while \n\n"

docker stop my-lap-container
docker rm my-lap-container
docker stop my-mysql
docker rm my-mysql

printf "\n\nDONE"

