#!/bin/bash

source ./global-names.sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1


CLUSTER_NAME="cluster-${FAMILY_NAME}"

# aws ecs list-tasks --cluster ${CLUSTER_NAME}
# echo "TASK_ARNS: " ${TASK_ARNS}

TASK_ARNS=`aws ecs list-tasks --cluster ${CLUSTER_NAME} | jq -r '.taskArns | join(" ")'` 

echo "Iterating over all tasks: " 
echo 
for TASK_ARN in $TASK_ARNS
do 
#  echo "got " $TASK_ARN
  NETWORK_INTERFACE_ID=`\
  aws ecs describe-tasks --task ${TASK_ARN} --cluster ${CLUSTER_NAME} | jq '.tasks[0].attachments[0].details' | jq -r 'from_entries.networkInterfaceId'`
#  echo Network: ${NETWORK_INTERFACE_ID}
  PUBLIC_IP=`aws ec2 describe-network-interfaces --network-interface-ids ${NETWORK_INTERFACE_ID} | jq -r '.NetworkInterfaces[0].Association.PublicIp' `
#  echo ${PUBLIC_IP} "   for " ${NETWORK_INTERFACE_ID} " at task " ${TASK_ARN}
  printf '  %-15s' ${PUBLIC_IP}
  printf '%-6s%-20s%-10s%-20s\n' " for " ${NETWORK_INTERFACE_ID} " at task " ${TASK_ARN}
done  

# aws ecs describe-tasks --task ${TASK_ARN} --cluster ${CLUSTER_NAME}