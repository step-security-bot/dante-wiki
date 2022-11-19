#!/bin/sh

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

##
## PHP-FPM7: Start PHP-FPM7
##
echo -n "** Starting php-fpm7 in background..."
/usr/sbin/php-fpm7
echo "DONE with php-fpm7"
echo
##
## END PHP-FPM7
##

##
## APACHE: Start apache
##
echo -n "** Starting apache as httpd in background..."
/usr/sbin/httpd -D FOREGROUND 
echo "DONE with apache"
echo
##
## END Apache
##


##
## Start Database  TODO: really in this LAP entry point????
##
#
# We do this with an exec. This ensures that 
#
###  IMPORTANT:    https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts

exec /usr/bin/mysqld --user=root --console



##
## keep docker alive for entry via ssh and log cheking, even if one of the above processes
## fail to start or crash on startup
##
sleep infinity
  