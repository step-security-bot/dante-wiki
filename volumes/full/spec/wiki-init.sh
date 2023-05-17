#!/bin/bash

# This is a set of library functions for initializing the DYNAMICAL and DATABSE parts of a mediawiki, wordpress or similar system.

# ASSUMPTIONS:  A running configuration with a DB and an LAP container
#
# The file area may be a volume or a directory.
#


# parameters:
# 
#  DB_USER    Database User          (may be standard such as user0023)
#  DB_PASS    Database Password
#  WK_USER    Wiki Admin User        (should be free choice)
#  WK_PASS    Wiki Admin Password
#

# region  DEFINING certain global constants

# mount point of the volume or directory
MOUNT="/var/www/html"

# get directory where this script resides, wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${DIR}/../../../conf/customize-PRIVATE.sh


# Names of the containers which we assume are running
LAP_CONTAINER=my-lap-container
DB_CONTAINER=my-mysql

# endregion


# region  composerPermissions ()  
#
#  We must adjust the global configuration file of composer and the loca configuration file of composer to permit the use of certain plugins.
#  The list of these plugins we must get form error messages in the composer runs
#
composerPermissions () {
  printf "\n** Configuring permissions for composer\n"

  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " composer config --no-plugins allow-plugins.wikimedia/composer-merge-plugin true       "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " composer config --no-plugins allow-plugins.composer/package-versions-deprecated true  "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " composer config --no-plugins allow-plugins.composer/installers true  "  

  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=${MOUNT}/${VOLUME_PATH}/composer.local.json composer config --no-plugins allow-plugins.wikimedia/composer-merge-plugin true       "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=${MOUNT}/${VOLUME_PATH}/composer.local.json composer config --no-plugins allow-plugins.composer/package-versions-deprecated true  "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=${MOUNT}/${VOLUME_PATH}/composer.local.json composer config --no-plugins allow-plugins.composer/installers true  "  

  printf "\nDONE configuring permissions for composer\n"
}
# endregion



composerUpdate () {
  printf "\n*** Do a composer update on the global file\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " composer update --no-dev -o  --no-interaction "
  printf "DONE with the composer update on the global file\n"

  printf "\n*** Do a composer update on the local file\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=composer.local.json composer update --no-dev -o  --no-interaction "
  printf "DONE with local composer update\n"
}

# region installExtensionGithub ()   
# INSTALL an extension which is hosted on github
# EXAMPLE:   installExtensionGithub  https://github.com/kuenzign/WikiMarkdown  WikiMarkdown  main
installExtensionGithub () {
  URL=$1
  NAME=$2
  BRANCH=$3
  echo ""; echo "*** INSTALLING EXTENSION ${NAME} from ${URL} using branch ${BRANCH}"
  docker exec -w /${MOUNT}/${VOLUME_PATH}/extensions ${LAP_CONTAINER}          sh -c " git clone ${URL} --branch ${BRANCH} ${NAME} "
  docker exec -w /${MOUNT}/${VOLUME_PATH}/extensions/${NAME} ${LAP_CONTAINER}  sh -c "rm -Rf .git "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sh -c "echo \"wfLoadExtension( '${NAME}' );\" >> DanteDynamicInstalls.php "
  echo ""; echo "*** COMPLETED INSTALLING EXTENSION ${NAME} from ${URL} using branch ${BRANCH}"
}
# endregion

# region installExtensionGerrit ()   
# INSTALL an extension which is hosted on gerrit
installExtensionGerrit () {
  NAME=$1
  RELEASE=$2
  docker exec -w /${MOUNT}/${VOLUME_PATH}/extensions ${LAP_CONTAINER}   sh -c " git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/${NAME} --branch ${RELEASE} ${NAME} "
  docker exec -w /${MOUNT}/${VOLUME_PATH}/extensions/${NAME} sh -c "rm -Rf .git "
}
# endregion


# region  composer:  Doing COMPOSER based installations
##
##
composer () {

  echo "______________________________________________"
  echo "*** Doing COMPOSER based installations "
  echo ""

  # ensure we start with a clean DanteDynamicInstalls.php file"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sh -c "rm -f DanteDynamicInstalls.php "
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sh -c " echo \"<?php \" >> DanteDynamicInstalls.php "



## the following is braindamaged composer construction
## to find out, we must
## 1) run the below composer install commands interactively in a shell
## 2) wait for security confirmations and answer yes
## 3) look at config.allow-plugins in the composer.json file, which gets modified in consequence of this
## 4) add the elements added to composer.json into this shell file

  composerPermissions

# TODO: do we need to make this ourselves ??? really
# TODO: do we need to configure permissions locally AND globally ??? as above
# TODO: do we really need that --no-interaction here ??
# TODO: do we really need to mka ethe directory for bootstrap ourselves ??
# TODO:
# The skins autoregister in the installation routine, however Bootstrap does not. But then, Bootstrap must be loaded before some skins.
# Therefore we must FIRST do the installation THEN install Bootstrap and inject that into the settings and only then install the skins and inject them (as they will now no longer autoregister)

  # INSTALLING extensions
  echo "*** Installing some extension requirements"

  # Install markdown parser https://github.com/erusev/parsedown
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=composer.local.json  composer require erusev/parsedown"

  # Install markdown-extra https://michelf.ca/projects/php-markdown/extra/
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=composer.local.json  composer require erusev/parsedown-extra"

  # Install markdown-extended https://github.com/BenjaminHoegh/ParsedownExtended
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " COMPOSER=composer.local.json  composer require benjaminhoegh/parsedown-extended"

  installExtensionGithub  https://github.com/kuenzign/WikiMarkdown  WikiMarkdown  main

  installExtensionGithub  https://github.com/wikimedia/mediawiki-extensions-MobileFrontend  MobileFrontend REL1_38



### currently to be done manually 
###  installExtensionGithub  https://github.com/clecap/Parsifal  Parsifal  dante


  echo "DONE installing extensions"
  echo ""


  echo ""
  echo "*** Do a composer update on the global file"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}   sh -c " composer update"
  echo "DONE with final composer update"
  echo ""

}
# endregion


# region dropDatabase  DB_NAME  
# drops a database. could be helpful before an addDatabase
dropDatabase () {
  local MY_DB_NAME=$1
  
  printf "\n * dropDatabase: Dropping database ${MY_DB_NAME} \n"

# TODO: Adapt the permissions granted to the specific environment and run-time conditions.
docker exec -i ${DB_CONTAINER} mysql -u root --password=${MYSQL_ROOT_PASSWORD} <<MYSQLSTUFF
DROP DATABASE ${MY_DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;
MYSQLSTUFF

EXIT_CODE=$?
printf "DONE: Exit code of dropDatabase generated database call: ${EXIT_CODE}"
}
#endregion


# region  addDatabase:  add a username and a database to the database engine
##        addDatabase  database-name   db-user-name   db-userpassword
addDatabase () {
  local MY_DB_NAME=$1
  local MY_DB_USER=$2
  local MY_DB_PASS=$3
 
  printf "\n * addDatabase: Making a database ${MY_DB_NAME} with user ${MY_DB_USER} and password ${MY_DB_PASS} \n"

# TODO: Adapt the permissions granted to the specific environment and run-time conditions.
# TODO: CURRENTLY We ARE NOT USING A MYSQL_ROOT_PASSWORD (the empty passowrd works !!!)
docker exec -i ${DB_CONTAINER} mysql -u root --password=${MYSQL_ROOT_PASSWORD} <<MYSQLSTUFF
CREATE DATABASE IF NOT EXISTS ${MY_DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;
CREATE USER IF NOT EXISTS ${MY_DB_USER}@'%' IDENTIFIED BY '${MY_DB_PASS}';
CREATE USER IF NOT EXISTS ${MY_DB_USER}@localhost IDENTIFIED BY '${MY_DB_PASS}';
-- CREATE USER IF NOT EXISTS ${MY_DB_USER}@'0.0.0.0/0.0.0.0' IDENTIFIED BY '${MY_DB_PASS}';
GRANT ALL PRIVILEGES ON ${MY_DB_NAME}.* TO '${MY_DB_USER}'@'%';
GRANT ALL PRIVILEGES ON ${MY_DB_NAME}.* TO '${MY_DB_USER}'@'localhost';
-- GRANT ALL PRIVILEGES ON ${MY_DB_NAME}.* TO '${MY_DB_USER}'@'0.0.0.0/0.0.0.0';
FLUSH PRIVILEGES;
MYSQLSTUFF

EXIT_CODE=$?
printf "DONE: Exit code of addDatabase generated database call: ${EXIT_CODE}"
}
# endregion


# region runMWInstallScript ()   run the mediawiki install script and generate a LocalSettings.php
#
runMWInstallScript () {
  MEDIAWIKI_DB_HOST=my-mysql
  MEDIAWIKI_DB_TYPE=mysql
  MEDIAWIKI_DB_NAME=${DB_NAME}
  MEDIAWIKI_DB_PORT=3306
  MEDIAWIKI_DB_USER=${DB_USER}
  MEDIAWIKI_DB_PASSWORD=${DB_PASS}
  MEDIAWIKI_RUN_UPDATE_SCRIPT=true

  MEDIAWIKI_SITE_NAME=${MW_SITE_NAME}
  # MEDIAWIKI_SITE_SERVER="https://${LAP_CONTAINER}"
  # TODO: problem: LAP_CONTAINER name is not resolved in the docker host
################################################################# TODO: ADJUST 
######
###### This should rather be a name, maybe localhost TODO: because other wise the different https things do not match
######
#  MEDIAWIKI_SITE_SERVER="https://localhost"
  MEDIAWIKI_SITE_SERVER=${MW_SITE_SERVER}
  MEDIAWIKI_SCRIPT_PATH="${VOLUME_PATH}"
  # TODO: make language variable inputable into script
  MEDIAWIKI_SITE_LANG=en
  MEDIAWIKI_ADMIN_USER=${WK_USER}
  MEDIAWIKI_ADMIN_PASS=${WK_PASS}
  MEDIAWIKI_ENABLE_SSL=true

echo ________________
echo "*** MEDIAWIKI INSTALLATION PARAMETERS WILL BE: "
echo ""
echo  "DATABASE Parameters are: "
echo  "   MEDIAWIKI_DB_HOST            ${MEDIAWIKI_DB_HOST}"
echo  "   MEDIAWIKI_DB_TYPE            ${MEDIAWIKI_DB_TYPE}"
echo  "   MEDIAWIKI_DB_NAME            ${MEDIAWIKI_DB_NAME}"
echo  "   MEDIAWIKI_DB_PORT            ${MEDIAWIKI_DB_PORT}" 
echo  "   MEDIAWIKI_DB_USER            ${MEDIAWIKI_DB_USER}"
echo  "   MEDIAWIKI_DB_PASSWORD        ${MEDIAWIKI_DB_PASSWORD}"
echo  "...MEDIAWIKI_RUN_UPDATE_SCRIPT  ${MEDIAWIKI_RUN_UPDATE_SCRIPT}"
echo  ""

echo "SITE Parameters are: "
echo  "   MEDIAWIKI_SITE_NAME"   ${MEDIAWIKI_SITE_NAME}
echo  "   MEDIAWIKI_SITE_SERVER  ${MEDIAWIKI_SITE_SERVER}"
echo  "   MEDIAWIKI_SCRIPT_PATH  ${MEDIAWIKI_SCRIPT_PATH}"
echo  "   MEDIAWIKI_SITE_LANG    ${MEDIAWIKI_SITE_LANG}"
echo  "   MEDIAWIKI_ADMIN_USER   ${MEDIAWIKI_ADMIN_USER}"
echo  "   MEDIAWIKI_ADMIN_PASS   ${MEDIAWIKI_ADMIN_PASS}"
echo  "   MEDIAWIKI_ENABLE_SSL   ${MEDIAWIKI_ENABLE_SSL}"
echo ""

echo "*** CALLING MEDIAWIKI INSTALL ROUTINE"
echo ""
docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} php maintenance/install.php \
    --confpath        ${MOUNT}/${VOLUME_PATH} \
    --dbname         "$MEDIAWIKI_DB_NAME" \
    --dbport         "$MEDIAWIKI_DB_PORT" \
    --dbserver       "$MEDIAWIKI_DB_HOST" \
    --dbtype         "$MEDIAWIKI_DB_TYPE" \
    --dbuser         "$MEDIAWIKI_DB_USER" \
    --dbpass         "$MEDIAWIKI_DB_PASSWORD" \
    --installdbuser  "$MEDIAWIKI_DB_USER" \
    --installdbpass  "$MEDIAWIKI_DB_PASSWORD" \
    --server         "$MEDIAWIKI_SITE_SERVER" \
    --scriptpath     "$MEDIAWIKI_SCRIPT_PATH" \
    --lang           "$MEDIAWIKI_SITE_LANG" \
    --pass           "$MEDIAWIKI_ADMIN_PASS" \
    "$MEDIAWIKI_SITE_NAME" \
    "$MEDIAWIKI_ADMIN_USER"


  echo "_______________________________________"
  echo ""

# check if we succeeded to generate LocalSettings.php
docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER}  [ -f "${MOUNT}/${VOLUME_PATH}/LocalSettings.php" ]
EXIT_VALUE=$?
echo "shell result $EXIT_VALUE"
if [ "$EXIT_VALUE" == "0" ]; then
  printf "\e[1;31m* SUCCESS:  ${MOUNT}/${VOLUME_PATH}/LocalSettings.php  generated \e[0m"
else
  printf "\e[1;41m* ERROR:  Could not generate ${MOUNT}/${VOLUME_PATH}/LocalSettings.php - *** ABORTING \e[0m \n"
fi

}
# endregion


## addingReferenceToDante:  Injects into LocalSettings.php a line loading our own configuration for Dante
# region
addingReferenceToDante () {

  echo ""
  echo "*** Adding reference to DanteSettings.php"

# NOTE: Doing this with include does not produce an error if the file goes missing

  docker exec -w /${MOUNT}/${VOLUME_PATH}  ${LAP_CONTAINER}   sh -c "echo ' ' >> LocalSettings.php"
  docker exec -w /${MOUNT}/${VOLUME_PATH}   ${LAP_CONTAINER}  sh -c " echo '###' >> LocalSettings.php"
  docker exec -w /${MOUNT}/${VOLUME_PATH}   ${LAP_CONTAINER}  sh -c "echo '### Automagically injected by volume cmd.sh ' >> LocalSettings.php"
  docker exec -w /${MOUNT}/${VOLUME_PATH}   ${LAP_CONTAINER}  sh -c "echo '###' >> LocalSettings.php  "
  docker exec -w /${MOUNT}/${VOLUME_PATH}   ${LAP_CONTAINER}  sh -c "echo 'include (\"DanteSettings.php\"); ' >> LocalSettings.php "
  echo "DONE adding a reference to DanteSettings.php"
  echo ""
}
# endregion


# region patchingForChameleon: Chameleon skin patch
# Chameleon skin is autodetected in the install script, but extensions are not autodetected. However, chameleon
# requires the Bootstrap extension. Thus, in case we have chameleon autodetected we must pathc in loading Bootstrap
# beforehand, or the automagic install process does not run through.
# This patching must be done IF chameleon is installed and it must be done after the wiki installer produced LocalSettings.php
patchingForChameleon () {

#  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sed -i "s/wfLoadSkin( 'chameleon' );/wfLoadExtension( 'Bootstrap' ); wfLoadSkin( 'chameleon' ); ### patched by dante installer in wiki-init.sh /g" ${MOUNT}/${VOLUME_PATH}/LocalSettings.php
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sh -c "sed \"s/wfLoadSkin( 'chameleon' );/wfLoadExtension( 'Bootstrap' ); wfLoadSkin( 'chameleon' ); ### patched by dante installer in wiki-init.sh /g\" LocalSettings.php > NEWLocalSettings.php"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} sh -c "cp ${MOUNT}/${VOLUME_PATH}/NEWLocalSettings.php ${MOUNT}/${VOLUME_PATH}/LocalSettings.php"



}
# endregion




# region  initialize    Initialization function for an individual WIKI
##
initialize () {
  DB_USER=$1

  DB_NAME="DB_${DB_USER}"
  DB_PASS="password-$1"
  WK_USER=$1
  WK_PASS="password-$1"
# TODO: must offer possibility to use a real password
  echo "*** Initialize sees DB_USER=${DB_USER}, DB_PASS=${DB_PASS}, WK_USER=${WK_USER}, WK_PASS=${WK_PASS}"

  # path to the wiki inside of the volume
  VOLUME_PATH="wiki-${DB_USER}"

  echo "** Are we a wiki directory?"
  docker exec ${LAP_CONTAINER} ls ${MOUNT}/${VOLUME_PATH}/index.php
  if [ "$?" == "0" ]; then
    echo "* Found index.php, probably yes, continuing"
  else 
    echo "* NO *** EXITING initializer for ${VOLUME_PATH}"
    return
  fi
  echo ""

 
  addDatabase ${DB_NAME} ${DB_USER} ${DB_PASS}
  printf "DONE adding database and user"

  # composer must run before the installscript so that the installscript has all the available extensions ready
  # this is necessary, since the installscript does an autoregistration of some components, for example the installed skins
  composer 

 ## remove to have a clean start for the install routines
  docker exec ${LAP_CONTAINER} rm ${MOUNT}/${VOLUME_PATH}/LocalSettings.php

  runMWInstallScript

# we are not using Chameleon skin any longer due to some troubles we seem to have found with flash of unstyled stuff
#  patchingForChameleon

  addingReferenceToDante

  echo ""
  echo "DONE   *** INITIALIZING WIKI *** "
  echo ""
}
##
## END of initialization function
##
# endregion




## for setting up wordpress, we start with a username 
## CAVE: wikis currently do this differently, by traversing the file system and picking up directories   ### TODO: make this uniform !!

## TODO: turn more stuff into parameter, particularly passwords and user names

initWP () {
  USERNAME=$1

  VERSION=6.1.1
  LOCALE=en_DB

  DB_NAME="WP_${USERNAME}"
  DB_USER="${USERNAME}"
  # CAVE: DB_USER must not contain a minus sign

  # TODO: This must be adjusted
  DB_PASS="password-wp"

  URL=https://localhost/wp-word

  # Wordpress Admin USer
  ADMIN_USER="wp-user"

  # This must be adjusted
  ADMIN_PASSWORD="password-admin"

  # TODO: This must be adjusted
  ADMIN_EMAIL="clemens@clemens-cap.de"

  # OS / Linux User for the file ownership
  LINUX_USER="lnx-wp-${USERNAME}"

## TODO: for security reasons we want a different user/pw on the web side than on the db side (the db side secures the data but is not open for web-side brute force attacks)

  # Name of the wp installation
  WP_TITLE="Adhuc Stat"

  # directory in which to build the Wordpress installation
  VOLUME_PATH="wp-${USERNAME}"

  # add database to DB system
  printf "\n** Generating database ${DB_NAME} and DB user ${DB_USER}\n"
  dropDatabase ${DB_NAME}
  addDatabase ${DB_NAME} ${DB_USER} ${DB_PASS}
  printf "DONE generating database\n"

  printf "\n** Generating OS User ${LINUX_USER} for Wordpress\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} adduser -D ${LINUX_USER}
  printf "DONE generating OS User\n"

  printf "\n** Downloading wordpress core version ${VERSION}\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER} ${LAP_CONTAINER} ./wp-cli.phar core download --version=${VERSION}
  printf "DONE downloading wordpress core version ${VERSION}\n"

  printf "\n** Creating client configuration\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER} ${LAP_CONTAINER} ./wp-cli.phar config create --force  --url=${URL} --dbhost=${DB_CONTAINER}  --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --locale=${LOCALE}
  printf "DONE creating client configuration\n"

  # --skip-email since we here do not have access to sendmail
  printf "\n** Installing core\n"
  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER} ${LAP_CONTAINER} ./wp-cli.phar core install --url=${URL} --title="${WP_TITLE}" --admin_name=${ADMIN_USER} --admin_password=${ADMIN_PASSWORD} --admin_email=${ADMIN_EMAIL} --skip-email
  printf "DONE installing core\n"

#  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER}  ${LAP_CONTAINER}  mkdir -p wp-content/uploads
#####  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER}  ${LAP_CONTAINER}  chgrp web uploads/
#  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER}  ${LAP_CONTAINER} chmod 775 uploads/

#  printf "\n** Setting permissions\n"
#  docker exec -w /${MOUNT}/${VOLUME_PATH} --user ${LINUX_USER}  ${LAP_CONTAINER}  chmod 600 wp-config.php
#  printf "\nDONE setting permissions\n"

}



# region main  MAIN function of the shell script
##
main () {
WIKIS="${DIR}/../content/wiki-"*

printf "\n*** List of wiki subdirectories found: ${WIKIS} \n"

for WIKI in ${WIKIS}
do
  printf "\n*** Initializing WIKI: ${WIKI}\n"
  if [[ $WIKI =~ wiki-([a-zA-Z0-9_]+)$ ]]; 
  then 

    initialize ${BASH_REMATCH[1]}
  else 
    printf "\n*** Skipping ${WIKI} as it is not in proper format\n" 
  fi
done

printf "\n*** Fix file ownerships..."
docker exec ${LAP_CONTAINER} /bin/sh -c "chown -R apache.apache /var/www/html"

}
# endregion

main 

# initWP word







#### THIS probably partially into dockerfile
# If a composer.lock and composer.json file exist, use them to install dependencies for MediaWiki and desired extensions, skins, etc.
#if [ -e "$MEDIAWIKI_SHARED/composer.lock" -a -e "$MEDIAWIKI_SHARED/composer.json" ]; then
#  curl -sS https://getcomposer.org/installer | php
#  cp "$MEDIAWIKI_SHARED/composer.lock" composer.lock
#  cp "$MEDIAWIKI_SHARED/composer.json" composer.json
#  php composer.phar install --no-dev
#fi

# maybe restart the apache ?!?


## route 53 stuff fehlt noch  #TODO: stuff in jedem fall auch wenn lokal und intern usw.

## Run the update.php maintenance script. If already up to date, it won't do anything, otherwise it will
## migrate the database if necessary on container startup. It also will verify the database connection is working.
## only if MEDIAWIKI_RUN_UPDATE_SCRIPT is set
#if [ -e "LocalSettings.php" -a "$MEDIAWIKI_RUN_UPDATE_SCRIPT" = 'true' ]; then
#  echo >&2 'info: Running maintenance/update.php';
#  php maintenance/update.php --quick --conf ./LocalSettings.php
#fi




##
## INITIAL CONTENTS TODO: not yet active
##
# region

# copy in some initial content pages for the wiki; will be installed by initialize.sh which will be run by bin/run.sh
##echo -n "Copying initial content pages..."
##docker exec -w /${MOUNT} ${TEMP} mkdir       /${MOUNT}/initial-contents
##docker exec -w /${MOUNT} ${TEMP} chmod 755   /${MOUNT}/initial-contents
##docker exec -w /${MOUNT} ${TEMP} cp -r initial-contents/  ${TEMP}:/${MOUNT}/initial-contents

## Initialize some initial pages for the Mediawiki
#cd /opt/initial-contents
#source /opt/initial-contents/populate.sh

#MAIN_SPACE=("Main_Page" "Example_Page")

#php /var/www/html/maintenance/importTextFiles.php --overwrite Main_Page
#php /var/www/html/maintenance/importTextFiles.php --overwrite Example_Page


#PROJECT_SPACE=("Privacy_policy" "About" "General_disclaimer")
#for p in ${!PROJECT_SPACE}; do
#  docker exec -w /${MOUNT}/${VOLUME_PATH} ${LAP_CONTAINER} php maintenance/importTextFiles.php --prefix "Project:"  --overwrite $p
#done

# endregion


##
## Add entry to /${MOUNT}/index.html
##
addentry () {
echo ""
echo ________________
echo ""
echo "*** Adding ${MOUNT}/${VOLUME_PATH} mount=${MOUNT} volpath=${VOLUME_PATH}"
echo "*   Touching ${MOUNT}/index.html"
docker exec -w /${MOUNT} ${LAP_CONTAINER} touch ${MOUNT}/index.html
docker exec ${LAP_CONTAINER} /bin/sh -c "echo \"<a href='/${VOLUME_PATH}/index.php'>${MOUNT}/${VOLUME_PATH}/index.php</a><br><br>\" >> ${MOUNT}/index.html"

echo "...DONE"
}