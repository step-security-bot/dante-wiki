# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

# copy in a local file as entry point
COPY entrypoint.sh /

# Upgrade existing packages in the base image
RUN apk update;              \  
    apk --no-cache upgrade;  \
    apk add --no-cache openssh;   \                                   
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd  ; \
# remove any information which might have been cached
    rm -rf /var/cache/apk/*   \









ENV LANG=C.UTF-8 \
  LC_ALL=C.UTF-8 \ 
  # ConTeXt cache can be created on runtime and does not need to increase image size
  TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1 \ 
  # As we will not install regular documentation why would we want to install perl docs…
  NOPERLDOC=1 \ 
  # The base mirror is one of the mirrors of TUG's historic archive
  TLHISTMIRRORURL=rsync://texlive.info/historic/systems/texlive \ 
  # To get the latest packages available we always use the root mirror
  TLMIRRORURL=http://dante.ctan.org/tex-archive/systems/texlive/tlnet






RUN apk update
    apk --no-cache add wget
    apk --no-cache add rsync
    apk --no-cache add unzip
    apk --no-cache add git
    apk --no-cache add gpg
    apk --no-cache add tar
    apk --no-cache add xorriso
    apk --no-cache add make
    apk --no-cache add fontconfig
    apk --no-cache add perl
    apk --no-cache add openjdk11-jre
    apk --no-cache add ncurses-libs
# libgetopt-long-descriptive-perl  # missing
#  libdigest-perl-md5-perl libncurses5 libncurses6 \
    apk --no-cache add perl-unicode-linebreak
#   libfile-homedir-perl libyaml-tiny-perl \ 
    apk --no-cache add python3
    apk --no-cache add py3-pygments
    apk --no-cache add curl
    apk --no-cache add ghostscript
    cd /tmp
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
    zcat install-tl-unx.tar.gz | tar xf -
    cd install-tl-*
    perl ./install-tl --no-interaction





# Finally, prepend /usr/local/texlive/YYYY/bin/PLATFORM to your PATH,
# e.g., /usr/local/texlive/2022/bin/x86_64-linux




ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
EXPOSE 80
EXPOSE 443




