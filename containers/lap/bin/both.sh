#!/bin/bash

# starts a data base container and a lap container
# the db container  is run on a given docker volume or on default    DB_VOLUME_NAME 
# the lap container is run on a LOCAL_DIRECTORY or on a pre-prepared LAP_VOLUME_NAME

usage() {
  echo "Usage: $0 --db DB_VOLUME_NAME  --dir DIR_NAME           (files from local directory)       "
  echo "  --db DB_VOLUME_NAME       (if missing: default)   "
  echo "  --cleandb DB_VOLUME_NAME       "
  echo " "
  echo "  --dir DIR_NAME           (files from local directory)       "
  echo "  --vol VOLUME_NAME        (files from volume as prepared)    "
  echo "  --cleanvol VOLUME_NAME   (clean the volume first, then)     "
}

##
## Parse command line
##
# region
if [ "$#" -eq 0 ]; then
  usage
  LAP_SPEC="--vol default-file-volume"
else                      ### Variant 2: We were called with parameters.
  LAP_SPEC="--vol default-file-volume"
  while (($#)); do
    case $1 in 
      (--dir) 
        LAP_SPEC="--dir $2";;
      (--vol) 
        LAP_SPEC="--vol $2";;
      (--cleanvol)
        LAP_SPEC="--cleanvol $2";;
      (--db)
        DB_SPEC="--db $2";; 
      (--cleandb)
        DB_SPEC="--cleandb $2";;
      (*) 
         echo "Error parsing options - aborting" 
         usage 
         exit 1
    esac
  shift 2
  done
fi

echo " "
echo "Spec for DB:     ${DB_SPEC}   "
echo "Spec fo LAP:     ${LAP_SPEC}  "

# endregion


#
# serves files from ${MOUNT} 
# gets these files by attaching the volume with name ${VOLUME_NAME} at ${MOUNT}
#

export NETWORK_NAME=dante-network

# get directory where this script resides wherever it is called from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"



# start the DB
echo " "
echo "_____ Part 1: Starting DB ____"
${DIR}/../../my-mysql/bin/run.sh ${DB_SPEC}
echo " "
 
# start the LAP web server stack
echo " "
echo "_____ Part 2: Starting LAP ____ ${LAP_SPEC}"
${DIR}/run.sh ${LAP_SPEC}


## we must check if we should run an initialization of the system / DB !!
#  it is possible that an initialization has already been run !!
#    (eg as part of add-wiki.sh or similar)






