FROM alpine

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




##
## mutool installation
##
RUN  mkdir /opt/mutools
COPY mupdf-1.20.3-source/ /opt/mutools

 
  # libraries we need for linking mutool with
RUN  apk add --no-cache libgl1-mesa libglu1.mesa libx11 libxi libxrandr && \
  # library headers we need for building mutool with
  apk libgl1-mesa-dev  libglu1.mesa-dev  libx11-dev  libxi-dev libxrandr-dev  && \
  apk gperf build-essential && \
  cd /opt/mutools  && \
  make && \
  make install && \
  # clean up the build process
  make clean && \
  apk del libgl1-mesa-dev libglu1.mesa-dev libx11-dev libxi-dev libxrandr-dev && \
  ### clean up 
  apk del -y gperf build-essential libgl1-mesa-dev libglu1.mesa-dev libx11-dev libxi-dev libxrandr-dev && \  


###  CLEAN UP MISSING
RUN rm -Rf /opt/mutools





EXPOSE 22
EXPOSE 80
EXPOSE 443

