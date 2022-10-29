#!/bin/bash

source ./global-names.sh

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1

### THIS script is needed for those tasks for which we have to build our own image
#   and store it in a repository

## TODO ?????
IMAGE_TAG="latest"


BUILD_FILE_NAME="build-file-${FAMILY_NAME}.zip"
BUILD_BUCKET_NAME="s3-build-bucket-${FAMILY_NAME}"
PROJECT_NAME="project-${FAMILY_NAME}"

echo "*** Preparing an S3 bucket to hold the source input of the build process"
rm -Rf ${FAMILY_NAME}/build/*
cp ${FAMILY_NAME}/src/*     ${FAMILY_NAME}/build
cd ${FAMILY_NAME}/build
echo We are at: `pwd`
zip -r ../${BUILD_FILE_NAME} *
cd ../..
rm -Rf ${FAMILY_NAME}/build/*
aws s3api create-bucket --bucket ${BUILD_BUCKET_NAME} --create-bucket-configuration LocationConstraint=${REGION_ID}
aws s3 rm s3://${BUILD_BUCKET_NAME} --recursive
aws s3 cp ${FAMILY_NAME}/${BUILD_FILE_NAME} s3://${BUILD_BUCKET_NAME}/${BUILD_FILE_NAME}
echo "*** ls of s3 bucket shows: "
aws s3 ls s3://${BUILD_BUCKET_NAME}/${BUILD_FILE_NAME}

# imports REPOSITORY_URI and REPOSITORY_NAME
source prepareRepository.sh ${FAMILY_NAME}


### Create a service role
BUILD_SERVICE_ROLE_NAME="build-service-role-${FAMILY_NAME}"
BUILD_POLICY_NAME="build-policy-${FAMILY_NAME}"

aws iam create-role --role-name ${BUILD_SERVICE_ROLE_NAME} --assume-role-policy-document "{
  \"Version\": \"2012-10-17\",
  \"Statement\": [{\"Effect\": \"Allow\", \"Principal\": {\"Service\": \"codebuild.amazonaws.com\"},\"Action\": \"sts:AssumeRole\"}]}
" 

BUILD_SERVICE_ROLE=`aws iam get-role --role-name ${BUILD_SERVICE_ROLE_NAME} | jq -r '.Role.Arn'`

### Attach a policy to the service role
# policy: derived from: https://docs.aws.amazon.com/codebuild/latest/userguide/sample-docker.html#sample-docker-dir
# policy: sts.AssumeRole due to complaint of build system
# policy: added logs: right needed in build process
# policy: added https://docs.aws.amazon.com/codebuild/latest/userguide/troubleshooting.html
# policy: added s3 to be able to read the build sources
# NOTE: we here allow access to all resources, we could make this more tight 
echo "*** Attaching a policy to the service role of the build process"
aws iam put-role-policy --role-name ${BUILD_SERVICE_ROLE_NAME} --policy-name ${BUILD_POLICY_NAME} --policy-document "{
  \"Statement\": [
    {
      \"Action\": [
        \"sts:AssumeRole\",
        \"ecr:BatchCheckLayerAvailability\",
        \"ecr:CompleteLayerUpload\",
        \"ecr:GetAuthorizationToken\",
        \"ecr:InitiateLayerUpload\",
        \"ecr:PutImage\",
        \"ecr:UploadLayerPart\",
        \"logs:CreateLogStream\", \"logs:CreateLogGroup\", \"logs:PutLogEvents\",
        \"ssm:GetParameters\",
        \"s3:*\"   
      ],
      \"Resource\": \"*\",
      \"Effect\": \"Allow\"
    }
  ],
  \"Version\": \"2012-10-17\"
}"





echo "*** CREATING the project"
aws codebuild create-project \
  --name ${PROJECT_NAME} \
  --source "{\"type\": \"S3\", \"location\": \"${BUILD_BUCKET_NAME}/${BUILD_FILE_NAME}\"}"    \
  --environment "{                                                            
    \"type\": \"LINUX_CONTAINER\",                                               
    \"image\": \"aws/codebuild/standard:4.0\",                                       
    \"computeType\": \"BUILD_GENERAL1_SMALL\",           
    \"environmentVariables\": [                                                   
      {\"name\": \"AWS_DEFAULT_REGION\", \"value\": \"${REGION_ID}\"},       
      {\"name\": \"AWS_ACCOUNT_ID\",     \"value\": \"${ACCOUNT_ID}\"},           
      {\"name\": \"IMAGE_REPO_NAME\",    \"value\": \"${REPOSITORY_NAME}\"},   
      {\"name\": \"IMAGE_TAG\",          \"value\": \"${IMAGE_TAG}\"}                                  
    ],
    \"privilegedMode\": true } " \
   --artifacts "{\"type\": \"NO_ARTIFACTS\"}" \
  --service-role  ${BUILD_SERVICE_ROLE}      


echo "*** Starting the build process...will email you as soon as done"
aws codebuild start-build \
    --project-name ${PROJECT_NAME} \
    --queued-timeout-in-minutes-override 5 
 