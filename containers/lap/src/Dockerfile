# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

# PHP_INI_DIR to be symmetrical with official php docker image  TODO: needed ??
ENV PHP_INI_DIR /etc/php/7.4

RUN apk update;   \
    apk --no-cache upgrade;  \
#   *** PHP    
    apk --no-cache add php7; \
#   *** PHP extensions as required for Mediawiki       
    apk --no-cache add php7-session php7-openssl php7-json  php7-mbstring  php7-fileinfo php7-intl php7-calendar php7-ctype php7-xml php7-xmlreader;\
    apk --no-cache add php7-curl; \
#   *** Some more PHP extensions as they may seem useful
    apk --no-cache add  php7-bcmath php7-exif php7-ftp php7-dom php7-tokenizer php7-posix php7-iconv; \
#   MYSQL integration for php
    apk --no-cache add php7-mysqli;\
#   *** apcu, igbinary and opcache as needed as suggested by mediawiki optimization    
    apk --no-cache add php7-apcu php7-igbinary php7-opcache;\
#   APACHE integration for php
    apk --no-cache add php7-fpm; \
#   PEAR will temporarily need a c compiler and a make utility
    apk --no-cache add g++ make; \
#   * PHP UTILITIES:  pear and pecl are needed for installing the DS data type, which we need in Parsifal for cleaning up
    apk --no-cache add php7-dev php-pear; \
#   * honor an explicit request by pecl
    pecl channel-update pecl.php.net;\
#   * install ds
    pecl install ds; \
#   * utilities we need at different places    
    apk --no-cache add wget curl;\
#   * enable proper https resolution for apache
    apk --no-cache add ca-certificates;\ 
#   Needed for syntax highlighting mechanisms    
    apk --no-cache add python3; \
#   * APACHE
    apk --no-cache add apache2; \
#   * APACHE MODULES     
    apk --no-cache add nghttp2 apache2-proxy;\
#   * diff utils needed for text differences
    apk --no-cache add diffutils; \
#   git needed to get proper hashes in Special:Version and in other places
    apk --no-cache add git;\         
#   THUMBNAIL support in mediawiki
    apk --no-cache add imagemagick php7-gd ; \
#   DJVU support in mediawiki                                     TODO: Looks like these things are still missing here
#    apk --no-cache add djvulibre-bin netpbm ; \       
#   No xpdf in Alpine - using poppler-utils as replacement
    apk --no-cache add poppler-utils; \
#   SVG support in mediawiki
    apk --no-cache add librsvg

## NOTE: We move some of the files which might change once in a while to the end of the docker file
#        as this allows the build system to cache the earlier (time consuming) layers f the build process


##
## APACHE / PHP configuration
##
RUN  echo " CONFIGURE APACHE ";                     \
#   /run/apache2 is pid directory for apache
    mkdir -p /run/apache2;                          \
#   /var/www/html is the html mount point
    mkdir -p /var/www/html;                         \
#   remove remaining alpine container mount point
    rm -Rf /var/www/localhost


COPY httpd.conf                             /etc/apache2/httpd.conf

COPY mediawiki-alpine-lamp-apache2.conf     /etc/apache2/conf.d
COPY mediawiki-alpine-lamp-php.ini          /etc/php7/php-fpm.d/mediawiki-alpine-lamp-php.ini
##
## END: Apache / PHP configuration
##

##
## COPY in the entrypoint script
##
COPY entrypoint.sh /






######
###### DEBUG BLOCK: INCLUDE AN INSTANCE OF SSH
######
#   Install openssh
RUN apk add --no-cache openssh;                                     \
#   Add user cap, pass for entry (***** INSECURE *****)  TODO: Fix this 
    echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd ;                                 \
# Make user cap a sudo user
    adduser -D cap;                                                 \
    mkdir -p /etc/sudoers.d ;                                       \
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ;       \
    chmod 0440 /etc/sudoers.d/cap ;                                 \
#    mkdir ~cap/.ssh ;                                               \
# Install sudo, which is not part of alpine - allows to do a sudo su for gaining root
    apk add --no-cache sudo

#COPY id_rsa.pub /tmp/id_rsa.pub                              
#RUN cat /tmp/id_rsa.pub >> ~/.ssh/authorized_keys;  \
#    rm -f /tmp/id_rsa.pub
# Expose for ssh
EXPOSE 22
######
###### END DEBUG BLOCK
######


## CLEAN UP
RUN apk del g++ make php7-dev; \ 
    rm -rf /var/cache/apk/*       

# Expose for http and https
EXPOSE 80
EXPOSE 443

# Expose for nfs 4  TODO: test if this really is necessary
EXPOSE 2049

ENTRYPOINT ["/entrypoint.sh"]