#!/bin/sh

echo "** Generating our own, local ssh key..."
ssh-keygen -A
echo "DONE"

echo "** Starting ssh daemon in foreground"
# exec /usr/sbin/sshd -D -e "$@"

/usr/sbin/sshd -D
# -d is debug mode


echo "after sshd"
