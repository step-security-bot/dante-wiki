#!/bin/bash

# This entrypoint initializes the database, generates LocalSettings.php and runs update.php

source /home/dante/dantescript/common-defs.sh

printf "${GREEN}*** THIS IS /dantescript/init.sh ***** ${RESET}"

###### send mail upon completion ????
#### favicon must be included into the thing - and at the dockerfile level ## todo
#### check if we are already initialized ##### TODO
####### crontab entries for backup and for job queue TODO


printf "\n*** init.sh: Listing of ${MOUNT}\n"
  ls -alg ${MOUNT}
  exec 1>&1 2>&2
printf "DONE\n"

printf "\n*** init.sh: Listing of ${MOUNT}/${TARGET}\n"
  ls -alg ${MOUNT}/${TARGET}
  exec 1>&1 2>&2
printf "DONE\n"

printf "\n*** init.sh: Deleting phpinfo.php..."
  rm -f ${MOUNT}/phpinfo.php
  exec 1>&1 2>&2
printf "DONE\n"

printf "\n*** init.sh: Listing of ${MOUNT}\n"
  ls -alg ${MOUNT}
  exec 1>&1 2>&2
printf "DONE\n"

printf "\n*** init.sh: Listing of ${MOUNT}/${TARGET}\n"
  ls -alg ${MOUNT}/${TARGET}
  exec 1>&1 2>&2
printf "DONE\n"


MEDIAWIKI_DB_HOST=dante-mariadb-container
MEDIAWIKI_DB_TYPE=mysql
MEDIAWIKI_DB_NAME=${MY_DB_NAME}
MEDIAWIKI_DB_PORT=3306
MEDIAWIKI_DB_USER=${MY_DB_USER}
MEDIAWIKI_DB_PASSWORD=${MY_DB_PASS}

MEDIAWIKI_RUN_UPDATE_SCRIPT=true

MEDIAWIKI_SITE_NAME="${MW_SITE_NAME}"
MEDIAWIKI_SITE_SERVER=${MW_SITE_SERVER}
MEDIAWIKI_SCRIPT_PATH="/${TARGET}"

# TODO: make language variable inputable into script
MEDIAWIKI_SITE_LANG=en
MEDIAWIKI_ADMIN_USER=${WK_ADMIN_USER}
MEDIAWIKI_ADMIN_PASS=${WK_ADMIN_PASS}

############# TODO !!
MEDIAWIKI_ENABLE_SSL=false

echo ""
echo ________________________________________________
echo "*** MEDIAWIKI INSTALLATION PARAMETERS WILL BE: "
echo ""
echo  "DATABASE Parameters are: "
echo  "   MEDIAWIKI_DB_HOST            ${MEDIAWIKI_DB_HOST}"
echo  "   MEDIAWIKI_DB_TYPE            ${MEDIAWIKI_DB_TYPE}"
echo  "   MEDIAWIKI_DB_NAME            ${MEDIAWIKI_DB_NAME}"
echo  "   MEDIAWIKI_DB_PORT            ${MEDIAWIKI_DB_PORT}" 
echo  "   MEDIAWIKI_DB_USER            ${MEDIAWIKI_DB_USER}"
echo  "   MEDIAWIKI_DB_PASSWORD        ${MEDIAWIKI_DB_PASSWORD}"
echo  "   MEDIAWIKI_RUN_UPDATE_SCRIPT  ${MEDIAWIKI_RUN_UPDATE_SCRIPT}"
echo  ""
echo "SITE Parameters are: "
echo  "   MEDIAWIKI_SITE_NAME"         ${MEDIAWIKI_SITE_NAME}
echo  "   MEDIAWIKI_SITE_SERVER        ${MEDIAWIKI_SITE_SERVER}"
echo  "   MEDIAWIKI_SCRIPT_PATH        ${MEDIAWIKI_SCRIPT_PATH}"
echo  "   MEDIAWIKI_SITE_LANG          ${MEDIAWIKI_SITE_LANG}"
echo  "   MEDIAWIKI_ADMIN_USER         ${MEDIAWIKI_ADMIN_USER}"
echo  "   MEDIAWIKI_ADMIN_PASS         ${MEDIAWIKI_ADMIN_PASS}"
echo  "   MEDIAWIKI_ENABLE_SSL         ${MEDIAWIKI_ENABLE_SSL}"
echo ""
echo "*** CALLING MEDIAWIKI INSTALL ROUTINE maintenance/install.php ------------------------- "
echo ""


php ${MOUNT}${TARGET}/maintenance/install.php \
    --confpath        ${MOUNT}/${TARGET} \
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

exec 1>&1 2>&2

  echo ""
  echo "________________________________  completed maintenance/install.php __________________"
  echo ""

exec 1>&1 2>&2



# check if we succeeded to generate LocalSettings.php
if [ -e "${MOUNT}/${TARGET}/LocalSettings.php" ]; then
  printf "\e[1;32m* SUCCESS:  ${MOUNT}/${TARGET}/LocalSettings.php  generated \e[0m \n"
else
  printf "\033[0;31m *ERROR:  Could not generate ${MOUNT}/${TARGET}/LocalSettings.php - *** ABORTING \033[0m\n"
fi






printf "*** Adding reference to DanteSettings.php ... "
  echo ' ' >> LocalSettings.php
  echo '###' >> LocalSettings.php
  echo '### Automagically injected by volume /home/dante/dantescript/init.sh.sh ' >> LocalSettings.php
  echo '###' >> LocalSettings.php
    # NOTE: Doing this with include does not produce an error if the file goes missing
  echo 'include ("DanteSettings.php"); ' >> LocalSettings.php
  exec 1>&1 2>&2
printf  "DONE\n"


set +e 


printf "\n*** Adding initial contents..."
  php ${MOUNT}${TARGET}/maintenance/importDump.php --namespaces '8' --debug $CONT/minimal-initial-contents.xml
  exec 1>&1 2>&2
  printf " namespace 8 done ";
  php ${MOUNT}${TARGET}/maintenance/importDump.php --namespaces '10' --debug $CONT/minimal-initial-contents.xml
  exec 1>&1 2>&2
  printf " namespace 10 done ";
  php ${MOUNT}${TARGET}/maintenance/importDump.php --uploads --debug $CONT/minimal-initial-contents.xml
  exec 1>&1 2>&2
  printf " uploads done ";
printf "DONE\n"

# main page and sidebar need a separate check in to show the proper dates
printf "\n*** Checking in sidebar..."
   php ${MOUNT}/${TARGET}/maintenance/importTextFiles.php --rc -s "Imported by wiki-init.sh" --overwrite --prefix "MediaWiki:" $CONT/Sidebar
  exec 1>&1 2>&2
printf "DONE\n"

printf "\n*** Checking in MainPage..."
  php ${MOUNT}/${TARGET}/maintenance/importTextFiles.php --rc -s "Imported by wiki-init.sh" --overwrite  "$CONT/Main Page"
  exec 1>&1 2>&2
printf "DONE\n"

# Must do an update, since we have installed all kinds of extensions earlier
printf "\n*** Doing a mediawiki maintenance update ... "
  php ${MOUNT}/${TARGET}/maintenance/update.php
  exec 1>&1 2>&2
printf "DONE update.php\n"

printf "\n\n**** init.sh: RUNNING: initSiteStats \n"
  php ${MOUNT}/${TARGET}/maintenance/initSiteStats.php --update
  exec 1>&1 2>&2
printf "DONE initSiteStats.php\n"

printf "\n\n**** init.sh: RUNNING: rebuildall \n\n"
  php ${MOUNT}/${TARGET}/maintenance/rebuildall.php 
  exec 1>&1 2>&2
printf "DONE rebuildall.php\n"

printf "\n**** init.sh: RUNNING: checkImages \n"
  php ${MOUNT}/${TARGET}/maintenance/checkImages.php
  exec 1>&1 2>&2
printf "DONE checkImages.php\n"

printf "\n**** init.sh RUNNING: refreshFileHeaders \n"
  php ${MOUNT}/${TARGET}/maintenance/refreshFileHeaders.php --verbose
  exec 1>&1 2>&2
printf "DONE refreshFileHeaders.php\n"

# touch the file LocalSettings.php to refresh the cache
printf "\n\n**** init.sh: Touching LocalSettings.php to refresh the cache..."
  touch ${MOUNT}/${TARGET}/LocalSettings.php
  exec 1>&1 2>&2
printf "DONE touching LocalSettings.php\n"


printf "\n\n*** /home/dante/dantescript/init.sh COMPLETED \n\n"