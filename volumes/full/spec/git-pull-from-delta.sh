#!/bin/bash

# Pulls all the work from clecap/dante-delta into this directory

# 1) initialize a git in here and set the .gitignore to spec/.gitignore


# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIKI=${DIR}/../content/wiki-dir


# go to main directory of wiki
cd ${WIKI}

echo ""
echo "_____________________"
echo ""

# ensuring we are starting from a clean slate
echo "*** Removing git directory"
rm -Rf .git
echo "DONE"
echo ""


# initialize a git there
echo "*** Initializing a git"
git init
git config --local core.excludesfile ${DIR}/../../spec/.gitignore
echo "DONE"
echo ""

# connect to the dante delta repository
echo "*** adding github as remote"
git remote add origin https://github.com/clecap/dante-delta.git
echo "DONE"
echo ""

git fetch origin
git reset --hard origin/main

echo "*** copy in some private credentials which we do not want to place into the repository and therefore store locally on the host"
cp ${DIR}/../../../conf/mediawiki-PRIVATE.php ${WIKI}

echo ""; echo "DONE"; echo ""

echo -e "\e[1;41m completed GIT PULL FROm DELTA \e[0m"

echo "\033[31mThis is red font.\033[0m"

echo ""