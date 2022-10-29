FROM alpine

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# Upgrade existing packages in the base image
RUN apk --no-cache upgrade

# Install openssh
RUN apk add --update --no-cache openssh 
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/sshuser -s /bin/sh -D sshuser
RUN echo -n 'sshuser:some-password' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
COPY entrypoint.sh /


EXPOSE 80
EXPOSE 443

