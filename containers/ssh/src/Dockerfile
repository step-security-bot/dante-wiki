FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"


    # Upgrade existing packages in the base image
RUN apk update;                   \  
    apk --no-cache upgrade;       \
    apk add --no-cache openssh;   \                                      
    # Add user cap
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    # set a password for user cap
    echo -n 'cap:pass' | chpasswd;    \   
    # disable password authentication for all users
    echo "PasswordAuthentication no " >> /etc/ssh/sshd_config ; \
    # Install sudo, which is not part of alpine, to allow a sudo su for gaining root
    apk add --no-cache sudo;  \
    # add user cap
    adduser -D cap;                                           \
    # make cap a sudoer
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ; \
    chmod 0440 /etc/sudoers.d/cap;                     \
    # clean up any remaining stuff which might be cached 
    rm -rf /var/cache/apk/*   

COPY ssh-container.pub /home/cap/.ssh/authorized_keys

    # proper permissions AND ownerships are a MUST for ssh to work 
RUN chmod 400 /home/cap/.ssh/authorized_keys; \
    chown cap /home/cap/.ssh/authorized_keys

# copy in a local file as entry point
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

# mkdir -p /etc/sudoers.d ;                                 \

EXPOSE 22