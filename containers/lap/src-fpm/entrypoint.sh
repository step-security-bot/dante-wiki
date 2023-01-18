#!/bin/sh



## 
## Fix permissions
##
chmod 400 /etc/ssl/apache2/server.key
chmod 444 /etc/ssl/apache2/server.pem




###
### SSH: Portion we need when we want ssh access for container debugging
###
echo -n "** Generating our own, local ssh key..."
ssh-keygen -A
echo "DONE"

echo -n "** Starting sshd in background..."
# -e: sends output to standard error instead of syslog
# -d: debug
# -D: NO daemonization
/usr/sbin/sshd
echo "DONE with sshd"
echo 
##
## END SSH
##

echo -n "** Generating our php.ini file..."
rm -f /etc/php7/php-new.ini
cat /etc/php7/php.ini /etc/php7/mediawiki-alpine-lamp-php.ini > /etc/php7/php-new.ini
echo "DONE with generating php.ini file"

##
## PHP-FPM7: Start PHP-FPM7
##
echo -n "** Starting php-fpm7 in background..."
/usr/sbin/php-fpm7 --php-ini /etc/php7/php-new.ini
echo "DONE with php-fpm7"
echo
##
## END PHP-FPM7
##

##
## APACHE: Start apache  TODO: ev exec einbauen 
##
echo -n "** Starting apache..."
/usr/sbin/httpd -D FOREGROUND 
echo "DONE with apache"
echo
##
## END Apache
##

sleep infinity
  