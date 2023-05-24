#!/bin/bash

echo "-----------------------------------------\n\n"


# pushes all the work done locally since the last 

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIKI=${DIR}/../content/wiki-dir

echo "*** Adding files:"
cd ${WIKI}/extensions/Parsifal
git add . --verbose

# ncom is the non comment commit which I use in my system 
echo "\n*** Commit"
git ncom --verbose
echo ""


echo "*** Push to upstream"
git push -u --verbose
echo ""




##
##
##