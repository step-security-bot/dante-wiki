# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# copy in a local file as entry point
COPY entrypoint.sh /

# Upgrade existing packages in the base image
RUN apk update;                   \  
    apk --no-cache upgrade;       \
    apk add --no-cache openssh;   \                                       
    rm -rf /var/cache/apk/*   

# Add user cap, pass for entry (***** INSECURE *****)
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd                                 

# Make user cap a sudo user
RUN adduser -D cap;                                           \
    mkdir -p /etc/sudoers.d ;                                 \
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ; \
    chmod 0440 /etc/sudoers.d/cap

# Install sudo, which is not part of alpine - allows to do a sudo su for gaining root
RUN apk update;               \
    apk --no-cache upgrade;   \
    apk add --no-cache sudo;  \
    rm -rf /var/cache/apk/*       

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
EXPOSE 80
EXPOSE 443

