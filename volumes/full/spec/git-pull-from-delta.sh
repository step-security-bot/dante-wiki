#!/bin/bash

# Pulls all the work from clecap/dante-delta into this directory

# 1) initialize a git in here and set the .gitignore to spec/.gitignore


# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIKI=${DIR}/../content/wiki-dir


# go to main directory of wiki
cd ${WIKI}

printf "\n_____________________\n"

# ensuring we are starting from a clean slate
printf "*** Removing git directory..."
rm -Rf .git
printf "DONE removing git directory\n\n"

# initialize a git there
printf "*** Initializing a git..."
git init
git config --local core.excludesfile ${DIR}/../../spec/.gitignore
printf "DONE initializing a git\n\n"

# connect to the dante delta repository
printf "*** adding github as remote..."
git remote add origin https://github.com/clecap/dante-delta.git
printf "DONE adding github as remote\n"

printf "***fetching origin..."
git fetch origin
printf "DONE fetching origin\n"

printf "***hard reset on local git..."
git reset --hard origin/main
printf "DONE hard reset"

echo "*** copy in some private credentials which we do not want to place into the repository and therefore store locally on the host"
cp ${DIR}/../../../conf/mediawiki-PRIVATE.php ${WIKI}

echo ""; echo "DONE"; echo ""

# echo -e "\e[1;41m completed GIT PULL FROm DELTA \e[0m"

printf "\033[31m completed GIT PULL FROm DELTA \033[0m"

printf "\033[31mThis is red font.\033[0m"


echo ""