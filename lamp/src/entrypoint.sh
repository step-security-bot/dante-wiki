#!/bin/sh


### Remove certain module definitions
sed 's/LoadModule mpm_event_module modules/mod_mpm_event.so/#DELETED mpm_event by SED/g' /etc/apache2/httpd.conf
sed 's/LoadModule mpm_worker_module modules\/mod_mpm_worker.so/#DELETED mpm_worker by SED/g' /etc/apache2/httpd.conf
sed 's/LoadModule mpm_prefork_module modules\/mod_mpm_prefork.so/#DELETED mpm_prefork by SED/g' /etc/apache2/httpd.conf

### Portion we need when we want ssh access for container debugging
echo "** Generating our own, local ssh key..."
ssh-keygen -A
echo "DONE"
echo "** Starting ssh daemon in foreground"
# exec /usr/sbin/sshd -D -e "$@"

/usr/sbin/sshd -D 

echo "after sshd"

