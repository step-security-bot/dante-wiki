#!/bin/bash

source ./global-names.sh
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 FAMILYNAME TASK_REVISION" >&2
  exit 1
fi

FAMILY_NAME=$1
TASK_REVISION=$2


CLUSTER_NAME="cluster-${FAMILY_NAME}"

echo __________________________________
echo "*** Creating cluster ${CLUSTER_NAME}"
aws ecs create-cluster --cluster-name ${CLUSTER_NAME} > /dev/null


TASK_DEFINITION_NAME="task-${FAMILY_NAME}"

SERVICE_NAME="Service-running-${TASK_DEFINITION_NAME}"
## TASK_DEFINITION_ARN="arn:aws:ecs:${REGION_ID}:${ACCOUNT_ID}:task-definition/${TASK_DEFINITION_NAME}:${TASK_DEFINITION_VERSION}"

TASK_DEFINITION_SPEC="${FAMILY_NAME}:${TASK_REVISION}"


## Obtain resources we will need: subnets and security groups
source prepareSubnets.sh
echo "*** Using subnets: " ${SUBNETS}
source prepareSecurityGroup.sh ${FAMILY_NAME}
echo "*** Using security group: " ${SECURITY_GROUP_ID}

##### WORKS !!
#TASK_DEFINITION_ARN="arn:aws:ecs:eu-central-1:499754002549:task-definition/sample-fargate:4"

echo "*** CREATING SERVICE for Task ${TASK_DEFINITION_SPEC}"
aws ecs create-service  --service-name ${SERVICE_NAME} \
  --task-definition ${TASK_DEFINITION_SPEC} \
  --desired-count 1                        \
  --launch-type "FARGATE"                  \
  --network-configuration "awsvpcConfiguration={subnets=[${SUBNETS}], securityGroups=[${SECURITY_GROUP_ID}], assignPublicIp=ENABLED}" \
  --cluster ${CLUSTER_NAME}  > /dev/null