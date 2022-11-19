# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

##
## MYSQL / MARIADB Installation and Configuration
##
RUN echo ""; echo " ************ MYSQL"; echo "";      \
#   Install
  apk --no-cache add mysql mysql-client; \
#   generate /run/mysqld as pid directory for mysql
    mkdir -p /run/mysqld

#    copy in configuration files
COPY main-my.cnf                          /etc/my.cnf

## NOTE: we are not using a dockerfile VOLUME command since this works only on aws EC2 but not on Fargate

##
## COPY in the entrypoint script
##
COPY entrypoint.sh /


######
###### DEBUG BLOCK: INCLUDE AN INSTANCE OF SSH
######
#   Install openssh
RUN apk add --no-cache openssh;                                     \
#   Add user cap, pass for entry (***** INSECURE *****)  TODO: Fix this 
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd ;                                 \
# Make user cap a sudo user
    adduser -D cap;                                                 \
    mkdir -p /etc/sudoers.d ;                                       \
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ;       \
    chmod 0440 /etc/sudoers.d/cap ;                                 \
#    mkdir ~cap/.ssh ;                                               \
# Install sudo, which is not part of alpine - allows to do a sudo su for gaining root
    apk add --no-cache sudo

#COPY id_rsa.pub /tmp/id_rsa.pub                              
#RUN cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys;  \
#    rm -f /tmp/id_rsa.pub
# Expose for ssh
EXPOSE 22
######
###### END DEBUG BLOCK
######

# TODO: not yet working - does not provide a negative health check properly when not starting up correctly
# HEALTHCHECK CMD mysql mysql --user=mysql  --silent --execute "SELECT 1;"

## CLEAN UP
RUN rm -rf /var/cache/apk/*       


# Expose for nfs 4  TODO: test if this really is necessary
EXPOSE 2049


# Expose port for mysql
EXPOSE 3306


ENTRYPOINT ["/entrypoint.sh"]