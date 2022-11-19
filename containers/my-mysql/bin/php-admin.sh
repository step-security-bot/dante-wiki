#!/bin/bash
#
# Runs a php-myadmin container on the database
#

NAME=my-mysql
NETWORK_NAME=dante-network
PMA_HOST=my-mysql

# -d   run as daemon in background
# -e   set environment variable
#
#

# TODO: maybe add https to this for more password security

docker run --name my-phpmyadmin-${NAME} --network ${NETWORK_NAME}  -d -e PMA_HOST=${PMA_HOST}  -p 9090:80 phpmyadmin:5.0

open -a "Google Chrome" http://localhost:9090