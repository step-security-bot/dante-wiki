#!/bin/bash

# install a working / editin version of parsifal branch dante


# 1) initialize a git in here and set the .gitignore to spec/.gitignore


# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WIKI=${DIR}/../content/wiki-dir

echo ""
echo "_____________________"
echo ""

# go to main directory of wiki
cd ${WIKI}/extensions

# remove Parsifal if still there
rm -Rf Parsifal

git clone --branch dante https://github.com/clecap/Parsifal


