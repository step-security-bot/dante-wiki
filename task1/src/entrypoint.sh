#!/bin/sh

ssh-keygen -A

echo "After ssh-keygen"

# exec /usr/sbin/sshd -D -e "$@"

/usr/sbin/sshd -D 

echo "after sshd"
