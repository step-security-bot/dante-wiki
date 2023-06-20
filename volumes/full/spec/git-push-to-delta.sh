#!/bin/bash

# pushes all the work done locally inside of the volume to github.com/clecap/dante-delta

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIKI=${DIR}/../content/wiki-dir

source ${DIR}/git-files-EDIT-THIS-FILE.sh

##
## Define what we have under git control - EDIT THIS BLOCK -
##

echo ""
echo "________________________________________________"
echo ""

cd ${WIKI}
for name in ${MY_FILES[@]}
do
  echo "*** Adding file to git: ${name}"
  git add ${name}
done

echo ""

echo "____________________-"
echo "${MY_DIRECTORIES}"
echo "____________________-"


# need to cd and do an add . since this is the git way to do it
for name in ${MY_DIRECTORIES[@]}
do
  echo "*** Adding complete directory to git: ${name}"
  cd ${WIKI}/${name}
  git add .
done

echo ""


# ncom is the non comment commit which I use in my system 
echo "*** Commit"
git ncom
echo ""


echo "*** Push to upstream"
git push --set-upstream origin master
echo ""




##
##
##