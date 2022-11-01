# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# copy in a local file as entry point
COPY entrypoint.sh /

# Upgrade existing packages in the base image
RUN apk update              \  
    apk --no-cache upgrade  \
    apk add --no-cache openssh                                     \ 
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config      \
    adduser -h /home/cap -s /bin/sh -D cap                         \
    echo -n 'cap:pass' | chpasswd   \
    # remove any information which might have been cached
    rm -rf /var/cache/apk/*   \

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
EXPOSE 80
EXPOSE 443

