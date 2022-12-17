FROM ssh

# We are starting with our own, small ssh on alpine image

LABEL "vendor"="Clemens H. Cap"
LABEL "maintainer"="clemens.cap@uni-rostock.de"

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

# Upgrade existing packages in the base image
RUN apk --no-cache update;              \  
    apk --no-cache upgrade;    \
    apk --no-cache add wget &&  \
    apk --no-cache add rsync && \
    apk --no-cache add unzip && \
    apk --no-cache add git &&   \
    apk --no-cache add gpg && \
    apk --no-cache add tar && \
    apk --no-cache add xorriso && \
    apk --no-cache add make && \
    apk --no-cache add fontconfig && \
    apk --no-cache add perl && \
    apk --no-cache add openjdk11-jre && \
    apk --no-cache add ncurses-libs && \
# libgetopt-long-descriptive-perl  # missing
#  libdigest-perl-md5-perl  \
    apk --no-cache add perl-unicode-linebreak && \
#   libfile-homedir-perl libyaml-tiny-perl \ 
    apk --no-cache add python3 && \
    apk --no-cache add py3-pygments && \
    apk --no-cache add curl &&  \
    apk --no-cache add ghostscript && \
    # gnuplot
    apk --no-cache add gnuplot && \
    # graphviz
    apk --no-cache add graphviz && \
    # inkscape
    apk --no-cache add inkscape && \
    # pandoc ######### LOOKS like this package is not found
    # apk --no-cache add pandoc && \
    # mupdf
    apk --no-cache add mupdf && \
    # mupdf-tools
    apk --no-cache add mupdf-tools && \
    cd /tmp && \
    wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && \
    zcat install-tl-unx.tar.gz | tar xf - && \
    cd install-tl-* && \
    # select full installation
    echo "selected_scheme scheme-full" > install.profile && \
    # do not install doc files
    echo "tlpdbopt_install_docfiles 0" >> install.profile && \
    # do not install src files
    echo "tlpdbopt_install_srcfiles 0" >> install.profile && \
    # do not know what this does but everybody does so (shitty approach, I know)
    echo "tlpdbopt_autobackup 0" >> install.profile && \
    # furthermore we want our symlinks in the system binary folder to avoid
    echo "tlpdbopt_sys_bin /usr/bin" >> install.profile && \
    # actually install TeX Live
    ./install-tl -profile install.profile && \
    # cleanup
    cd /tmp && \
    rm -Rf /tmp/* 


# Finally, prepend /usr/local/texlive/YYYY/bin/PLATFORM to your PATH,
# e.g., /usr/local/texlive/2022/bin/x86_64-linux

# copy in a local file as entry point
# COPY entrypoint.sh /

# ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 22
# EXPOSE 80
# EXPOSE 443




