FROM alpine:3.15

# Upgrade existing packages in the base image
RUN apk --no-cache upgrade

##
## NODE INSTALLATION
##
     # make a build directory

##
## END NODE INSTALLATION
##



# Install openssh
RUN apk add --update --no-cache openssh 
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN adduser -h /home/sshuser -s /bin/sh -D sshuser
RUN echo -n 'sshuser:some-password' | chpasswd
ENTRYPOINT ["/entrypoint.sh"]

# copy in a local file
COPY entrypoint.sh /

EXPOSE 22
EXPOSE 80
EXPOSE 443