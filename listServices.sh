#!/bin/bash

source ./global-names.sh

aws ecs list-services --cluster ${CLUSTER_NAME}