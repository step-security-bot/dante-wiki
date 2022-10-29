#!/bin/bash

source ./global-names.sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1


CLUSTER_NAME="cluster-${FAMILY_NAME}"

echo "*** Creating cluster ${CLUSTER_NAME}"
aws ecs create-cluster --cluster-name ${CLUSTER_NAME} 


## A service runs a certain number of instances of a task definition inside of a cluster
#  We provide the name of the task definition and the version as parameters
#  We name the service after the 


TASK_DEFINITION_NAME="task-${FAMILY_NAME}"



echo ______________________________________________________________________
#### ????????????????????????????????????????????????????????????????????
TASK_DEFINITION_VERSION=4



## Derive proper names
SERVICE_NAME="Service-running${TASK_DEFINITION_NAME}"
TASK_DEFINITION_ARN="arn:aws:ecs:${REGION_ID}:${ACCOUNT_ID}:task-definition/${TASK_DEFINITION_NAME}:${TASK_DEFINITION_VERSION}"

## Obtain resources we will need: subnets and security groups
source prepareSubnets.sh
echo "*** Using subnets: " ${SUBNETS}
source prepareSecurityGroup.sh
echo "*** Using security group: " ${SECURITY_GROUP_ID}

##### WORKS !!
#TASK_DEFINITION_ARN="arn:aws:ecs:eu-central-1:499754002549:task-definition/sample-fargate:4"

echo "*** CREATING SERVICE"
aws ecs create-service  --service-name ${SERVICE_NAME} \
  --task-definition ${TASK_DEFINITION_ARN} \
  --desired-count 1                        \
  --launch-type "FARGATE"                  \
  --network-configuration "awsvpcConfiguration={subnets=[${SUBNETS}], securityGroups=[${SECURITY_GROUP_ID}], assignPublicIp=ENABLED}" \
  --cluster ${CLUSTER_NAME}