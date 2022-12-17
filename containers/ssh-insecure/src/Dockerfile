FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# copy in a local file as entry point
COPY entrypoint.sh /

    # Upgrade existing packages in the base image
RUN apk update;                   \  
    apk --no-cache upgrade;       \
    apk add --no-cache openssh;   \                                      
    # Add user cap, pass for entry (***** INSECURE *****)
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd;    \       
    ## Install sudo, which is not part of alpine, to allow a sudo su for gaining root
    apk add --no-cache sudo;  \
    # add user cap
    adduser -D cap;                                           \
    # make cap a sudoer
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ; \
    chmod 0440 /etc/sudoers.d/cap;                     \
    # clean up any remaining stuff which might be cached 
    rm -rf /var/cache/apk/*   

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22