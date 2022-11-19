#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 FAMILYNAME" >&2
  exit 1
fi
FAMILY_NAME=$1

export REPOSITORY_NAME="reposi-${FAMILY_NAME}"


#region *** REPOSITORY *** 
echo ____________________________________________
echo "*** Preparing repository ${REPOSITORY_NAME}"
echo "    Checking if it already exists..."

if aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} > /dev/null; then
  echo "    Found repository: " ${REPOSITORY_NAME}
  export REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} | jq -r '.repositories[0].repositoryUri' `
  echo "    URI of repository just found is: " ${REPOSITORY_URI}
else
  echo "    Did not find repository, making repository ${REPOSITORY_NAME}"
  aws ecr create-repository --repository-name ${REPOSITORY_NAME} 
  export REPOSITORY_URI=`aws ecr describe-repositories --repository-names ${REPOSITORY_NAME} | jq -r '.repositories[0].repositoryUri' `
  echo "*** URI of repository just created is: " ${REPOSITORY_URI}
fi
echo
#endregion

#region *** LOCAL DIRECTORY ***
echo ____________________________________________
echo "*** Prepare a local directory structure"

#region ** make local file system
mkdir containers/${FAMILY_NAME}
mkdir containers/${FAMILY_NAME}/build
mkdir containers/${FAMILY_NAME}/src
mkdir containers/${FAMILY_NAME}/def
mkdir containers/${FAMILY_NAME}/efs
#endregion

#region ** copy but do not overwrite a possibly existing file
cp -n templates/*.json5       containers/${FAMILY_NAME}/def
cp -n templates/Dockerfile    containers/${FAMILY_NAME}/src/
cp -n templates/buildspec.yml containers/${FAMILY_NAME}/src/
cp -n templates/entrypoint.sh containers/${FAMILY_NAME}/src/
#endregion

#region ** remove any build artifacts which might still be there
rm    containers/${FAMILY_NAME}/build/*
#endregion
#endregion
