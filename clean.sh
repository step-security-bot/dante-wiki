#!/bin/bash


source ./global-names.sh


if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi

FAMILY_NAME=$1
CLUSTER_NAME="cluster-${FAMILY_NAME}"
SECURITY_GROUP_NAME="security-group-for-network-for-${FAMILY_NAME}"
SERVICE_NAME="Service-running-${TASK_DEFINITION_NAME}"

echo "*** Stop all running tasks of cluster ${CLUSTER_NAME}"
TASK_ARNS=`aws ecs list-tasks --cluster ${CLUSTER_NAME} | jq -r '.taskArns | join(" ")'` 

echo "  Iterating over all tasks ${TASKS_ARNS} " 
echo 
for TASK_ARN in $TASK_ARNS
do 
  echo "  Stopping task with arn: " $TASK_ARN
  aws ecs stop-task --task ${TASK_ARN}
done  

# ???  or in cleanFully ???
# aws codebuild delete-project --name ${PROJECT_NAME}

echo "*** Deleting all services ${SERVICE_NAME} in cluster ${CLUSTER_NAME}"
aws ecs delete-service --cluster ${CLUSTER_NAME} --service ${SERVICE_NAME} --force

echo "*** Deleting security group: ${SECURITY_GROUP_NAME}"
aws ec2 delete-security-group --group-name ${SECURITY_GROUP_NAME}
