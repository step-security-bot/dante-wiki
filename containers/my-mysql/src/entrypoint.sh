#!/bin/sh



echo "This is my-mysql:entrypoint.sh" 
echo ""
echo "Directory of /var:"
ls -alg /var
echo ""
echo "Directory of /var/mysql:"
ls -alg /var/mysql
echo ""



if [ -d "/run/mysqld" ]; then
  echo "[i] /run/mysqld already present, skipping creation"
  chown -R mysql:mysql /run/mysqld
else
  echo "[i] mysqld not found, creating...."
  mkdir -p /run/mysqld
  chown -R mysql:mysql /run/mysqld
fi

mkdir -p /var/mysql/log 
chown -R mysql:mysql /var/mysql/log 

chown -R mysql:mysql /var/mysql/
chown -R mysql:mysql /var/mysql/mysql


echo "PHASE 1"

if [ -d /var/mysql/mysql ]; then
	echo "[i] MySQL directory /var/mysql/mysql already present, skipping creation"
	chown -R mysql:mysql /var/mysql/mysql
else
    echo ""
	echo "*** MySQL data directory /var/mysql/mysql not found, creating it"
	mkdir -p /var/mysql/mysql
	chown -R mysql:mysql /var/mysql/mysql
    echo "** Checking by ls: "
	ls -alg /var/mysql/
    echo ""

    echo "*** Running mysql_install_db for the FIRST time"
	mysql_install_db --user=mysql --datadir=/var/mysql/mysql --verbose
    echo "*** DONE"

	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=`pwgen 16 1`
		echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
	fi


	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

#     GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;


    echo "*** --- *** Will now set root password ${MYSQL_ROOT_PASSWORD}"

#### below had:   --skip-name-resolve TODO: fix

#   we MUST provide some passwords otherwise we cannot 
	/usr/bin/mysqld --user=mysql --bootstrap --skip-name-resolve --verbose=0  --skip-networking=0 < $tfile
	rm -f $tfile

#	for f in /docker-entrypoint-initdb.d/*; do
#		case "$f" in
#			*.sql)    echo "$0: running $f"; /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$f"; echo ;;
#			*.sql.gz) echo "$0: running $f"; gunzip -c "$f" | /usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < "$f"; echo ;;
#			*)        echo "$0: ignoring or entrypoint initdb empty $f" ;;
#		esac
#		echo
#	done

  echo
  echo 'MySQL init process done. Ready for start up.'
  echo

  echo "exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
fi


exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@