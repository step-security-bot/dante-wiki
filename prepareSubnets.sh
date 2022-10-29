#!/bin/bash

source ./global-names.sh

export SUBNETS=`aws ec2 describe-subnets   --region ${REGION_ID} | jq  '.Subnets' | jq 'map(.SubnetId)' | jq 'join(", ")' -r ` 