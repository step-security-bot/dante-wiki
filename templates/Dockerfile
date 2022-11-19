# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# copy in a local file
COPY entrypoint.sh /

# Upgrade existing packages in the base image
RUN apk --no-cache upgrade

# Install openssh
RUN apk add --update --no-cache openssh 
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/sshuser -s /bin/sh -D sshuser
RUN echo -n 'sshuser:some-password' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
EXPOSE 80
EXPOSE 443

