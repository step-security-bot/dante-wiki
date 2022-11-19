#!/bin/sh

# shell script which builds up directory content in /volumes/full/content

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

##
## call as  makeWiki  MAJOR  MINOR  TARGET
## example:  makeWiki 1.37.0 wiki-dir
makeWiki () {
  WIKI_VERSION_MAJOR=$1
  WIKI_VERSION_MINOR=$2
  TARGET=$3
  WIKI_NAME=mediawiki-${WIKI_VERSION_MAJOR}.${WIKI_VERSION_MINOR}
  cd ${DIR}/../content
  mkdir -p ${TARGET}
  cd ${TARGET}
  wget https://releases.wikimedia.org/mediawiki/${WIKI_VERSION_MAJOR}/${WIKI_NAME}.tar.gz;
  tar --strip-components=1 -xvzf ${WIKI_NAME}.tar.gz
  rm ./${WIKI_NAME}.tar.gz
}

makeWP () {
  WP_VERSION=$1
  TARGET=$2
  WP_NAME=wordpress-${WP_VERSION}
  cd ${DIR}/../content
  mkdir -p ${TARGET}
  cd ${TARGET}
  wget https://wordpress.org/${WP_NAME}
  tar --strip-components=1 -xvzf ${WP_NAME}.tar.gz
  rm ./${WP_NAME}.tar.gz
}

# TitleKey
# REL1_38
getMWExtension () {
  NAME=$1
  RELEASE=$2
  TARGET=$3
  SRC=$4
  cd ${DIR}/../content
  cd ${TARGET}/extensions
  case $SRC in
    gerrit)
      git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/${NAME} --branch ${RELEASE} ${NAME}
    ;;
    github)
      git clone https://github.com/wikimedia/mediawiki-extensions-${NAME} --branch ${RELEASE} ${NAME}
    ;;
    *)
      echo "" 
      echo "*** ERROR: unknown source "
  esac
  cd ${NAME}
  rm -Rf .git 
}


## get the wordpress command line interpreter
# does not work as it must run inside a container with mysql availabel
getWP-CLI () {



  wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  php wp-cli.phar --info
  chmod 755 wp-cli.phar
## ./wp-cli.phar core download
##  ./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --prompt=${DB_PASS}

}



##
## Install Mediawiki files
##

#makeWiki 1.37 0 wiki-dir
#makeWP 6.1.1 wp-dir

## getMWExtension REL1_39










# Copy in some extensions (especially DynamicPageList3, which proved a bit tricky regarding some aspects)
# mkdir -p ${DIR}/../content/wiki-dir/extensions/DynamicPageList3
# cp -r ${DIR}/../own/DynamicPageList3 ${DIR}/../content/wiki-dir/extensions/DynamicPageList3

##### define the extensions we want to use and the specific branches we will use of them and load them
# Install Mediawiki extensions (ADD LATER or rather do it via a COPY below)
#  git clone "https://gerrit.wikimedia.org/r/mediawiki/skins/MinervaNeue" skins/MinervaNeue; \
#  git clone "https://gerrit.wikimedia.org/r/mediawiki/extensions/MobileFrontend" extensions/MobileFrontend; \
# curl --remote-name https://extdist.wmflabs.org/dist/extensions/CategoryTree-REL1_32-5866bb9.tar.gz
# tar -xzf CategoryTree-REL1_32-5866bb9.tar.gz -C /var/www/html/extensions
# ENSURE directory. permissions and ownership

# copy in a favicon
# cp ${DIR}/../own/favicon.ico ${DIR}/../content/

# TODO: how initialize
