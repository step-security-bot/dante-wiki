#!/bin/sh

# This is an idempotent script which initializes a wiki installation existing on a directory of volume
# If the wiki is already installed, it does not break anything

# It assumes a running configuration of a DB and an LAP container

# The file area may be a volume or a directory.

# parameters:
# 
#  DB_USER    Database User          (may be standard such as user0023)
#  DB_PASS    Database Password
#  WK_USER    Wiki Admin User        (should be free choice)
#  WK_PASS    Wiki Admin Password
#


# mount point of the volume or directory
MOUNT="/var/www/html"

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Names of the containers which we assume are running
LAP_CONTAINER=my-lap-container
DB_CONTAINER=my-mysql



##
## Initialization function for WIKIs
##
initialize () {
  DB_USER=$1
  DB_PASS="password-$1"
  WK_USER=$1
  WK_PASS="password-$1"
  echo "*** Initializing ${DB_USER}, ${DB_PASS}, ${WK_USER}, ${WK_PASS}"

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


###### TODO: we might be DB-iniztialized and lack LocalSettings.php and vice versa. Halfinitialized. ho do we do thois ?????


  echo "** Are we already initialized? "
  docker exec ${LAP_CONTAINER} ls ${MOUNT}/${VOLUME_PATH}/LocalSettings.php
  if [ "$?" == "0" ]; then
    echo "* Found LocalSettings.php in ${VOLUME_PATH} - already initialized *** EXITING initializer for ${VOLUME_PATH}"
    return
  else 
    echo "* Did not find LocalSettings.php, continuing"
  fi

  DB_NAME="DB_${DB_USER}"

##
## Add Wiki to Database
##
echo ________________
echo "*** Making a database ${DB_NAME} with main user ${DB_USER} and password ${DB_PASS}: "
echo ""

# TODO: tighten up the permissions granted !!
docker exec -i ${DB_CONTAINER} mysql -u root --password=${MYSQL_ROOT_PASSWORD} <<MYSQLSTUFF
CREATE DATABASE ${DB_NAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;
CREATE USER ${DB_USER}@'%' IDENTIFIED BY '${DB_PASS}';
CREATE USER ${DB_USER}@localhost IDENTIFIED BY '${DB_PASS}';
CREATE USER ${DB_USER}@'0.0.0.0/0.0.0.0' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'0.0.0.0/0.0.0.0';
GRANT ALL ON *.* TO '${DB_USER}'@'%';
GRANT ALL ON *.* TO '${DB_USER}'@'localhost';
GRANT ALL ON *.* TO '${DB_USER}'@'0.0.0.0/0.0.0.0';
FLUSH PRIVILEGES;
MYSQLSTUFF

EXIT_CODE=$?
echo "*   Exit code ${EXIT_CODE}"
echo "DONE"
##


##
## Mediawiki Installation Script
##

MEDIAWIKI_DB_HOST=my-mysql
MEDIAWIKI_DB_TYPE=mysql
MEDIAWIKI_DB_NAME=${DB_NAME}
MEDIAWIKI_DB_PORT=3306
MEDIAWIKI_DB_USER=${DB_USER}
MEDIAWIKI_DB_PASSWORD=${DB_PASS}
MEDIAWIKI_RUN_UPDATE_SCRIPT=true

MEDIAWIKI_SITE_NAME="Dummy Site Name"
# MEDIAWIKI_SITE_SERVER="http://${LAP_CONTAINER}:80"
# TODO: problem: LAP_CONTAINER name is not resolved in the docker host
MEDIAWIKI_SITE_SERVER="http://localhost:80"
MEDIAWIKI_SCRIPT_PATH="/${VOLUME_PATH}"
# TODO: make language variable inputable into script 
MEDIAWIKI_SITE_LANG=en
MEDIAWIKI_ADMIN_USER=${WK_USER}
MEDIAWIKI_ADMIN_PASS=${WK_PASS}
MEDIAWIKI_ENABLE_SSL=false

### export MEDIAWIKI_DB_TYPE MEDIAWIKI_DB_HOST MEDIAWIKI_DB_USER MEDIAWIKI_DB_PASSWORD MEDIAWIKI_DB_NAME

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

echo ""
echo "DONE"
echo ""


}
##
## END of initialization function
##




##
## NOW comes the MAIN part of the shell script
##

WIKIS="${DIR}/../content/wiki-"*

echo ""
echo "*** List of wiki subdirectories found: ${WIKIS} "
echo ""

for WIKI in ${WIKIS}
do
  echo ""
  echo "*** Initializing WIKI: ${WIKI}"
  if [[ $WIKI =~ wiki-([a-zA-Z0-9_]+)$ ]]; 
  then 
    initialize ${BASH_REMATCH[1]}
  else 
    echo "*** Skipping ${WIKI} as it is not in proper format"; 
  fi
done



exit








# If we have a mounted share volume, move the LocalSettings.php to it
# so it can be restored if this container needs to be reinitiated
#    if [ -d "$MEDIAWIKI_SHARED" ]; then
#      # Move generated LocalSettings.php to share volume
#      mv LocalSettings.php "$MEDIAWIKI_SHARED/LocalSettings.php"
#      ln -s "$MEDIAWIKI_SHARED/LocalSettings.php" LocalSettings.php
#    fi

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
echo ""
echo ________________
echo ""
echo "*** Adding ${MOUNT}/${VOLUME_PATH} mount=${MOUNT} volpath=${VOLUME_PATH}"
echo "*   Touching ${MOUNT}/index.html"
docker exec -w /${MOUNT} ${LAP_CONTAINER} touch ${MOUNT}/index.html
docker exec ${LAP_CONTAINER} /bin/sh -c "echo \"<a href='/${VOLUME_PATH}/index.php'>${MOUNT}/${VOLUME_PATH}/index.php</a><br><br>\" >> ${MOUNT}/index.html"

echo "...DONE"