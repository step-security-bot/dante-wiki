# Using alpine, as this is the smallest Linux installation for docker available.
# Using a fixed number instead of latest in the interest of a reproducible build.
FROM alpine:3.15

# PHP_INI_DIR to be symmetrical with official php docker image
ENV PHP_INI_DIR /etc/php/7.4

RUN apk update;   \
    apk --no-cache upgrade;  \
#   *** PHP    
    apk --no-cache add php7; \
#   *** PHP extensions as required for Mediawiki       
    apk --no-cache add php7-session php7-openssl php7-json  php7-mbstring  php7-fileinfo php7-intl php7-calendar php7-xml;\
    apk --no-cache add php7-curl; \
#   *** Some more PHP extensions as they may seem useful
    apk --no-cache add  php7-bcmath php7-exif php7-ftp php7-dom php7-tokenizer php7-posix php7-iconv; \
#   MYSQL integration
    apk --no-cache add php7-mysqli;\
#   *** apcu, igbinary and opcache as needed as suggested by mediawiki optimization    
    apk --no-cache add php7-apcu php7-igbinary php7-opcache;\
#   APACHE integration for php
    apk --no-cache add php7-fpm; \
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
#   THUMBNAIL support in mediawiki
    apk --no-cache add imagemagick php7-gd ; \
#   DJVU support in mediawiki
    apk --no-cache add djvulibre-bin netpbm ; \       
#   No xpdf in Alpine - using poppler-utils as replacement
    apk --no-cache add poppler-utils; \
#   SVG support in mediawiki
   apk --no-cache add librsvg


COPY my-modules-apache.conf /etc/apache2/conf.d
RUN chmod 644 /etc/apache2/conf.d/my-modules-apache.conf

RUN set -x \
    && mkdir -p /run/apache2 \
    && ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# copy in the entrypoint script
COPY entrypoint.sh /

######
###### DEBUG BLOCK: INCLUDE AN INSTANCE OF SSH
######
RUN apk add --no-cache openssh
 
# Add user cap, pass for entry (***** INSECURE *****)
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config ;     \
    adduser -h /home/cap -s /bin/sh -D cap   ;                      \
    echo -n 'cap:pass' | chpasswd                                 

# Make user cap a sudo user
RUN adduser -D cap;                                           \
    mkdir -p /etc/sudoers.d ;                                 \
    echo "cap ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/cap ; \
    chmod 0440 /etc/sudoers.d/cap ;\
# Install sudo, which is not part of alpine - allows to do a sudo su for gaining root
    apk add --no-cache sudo

EXPOSE 22

######
###### END DEBUG BLOCK
######


## CLEAN UP
RUN apk del g++ make php7-dev; \ 
    rm -rf /var/cache/apk/*       

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
