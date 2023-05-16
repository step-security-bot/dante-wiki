echo ""
echo "" PASSWORD PROBLEM
echo "YOU DID NOT CONFIGURE THIS CORRECTLY - READ DOCU"
echo ""

MYSQL_ROOT_PASSWORD=password

# User entitled to do a dump of the entire mysql installation
MYSQL_DUMP_USER=username
MYSQL_DUMP_PASSWORD=otherpassword

DEFAULT_DB_VOLUME_NAME=my-mysql-data-volume

MW_SITE_SERVER=https://heinrich:4443

MW_SITE_NAME="MatheWiki"


exit 1