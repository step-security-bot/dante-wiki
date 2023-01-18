



This readme documents the differences - how we got from apache with fpm php to apache with normal php

We needed this for testing purposes when all of a sudden the fpm php version crashed regularly on Parsifal.





Comment in Dockerfile:

##################    apk --no-cache add php7-fpm; \



Comment in httpd.conf:

### Activate PHP
#
# according to https://wiki.alpinelinux.org/wiki/Apache_with_php-fpm
#
#<FilesMatch \.php$>
#    SetHandler "proxy:fcgi://127.0.0.1:9000"
#</FilesMatch>



Added in httpd.conf:

LoadModule php7_module modules/libphp7.so

<FilesMatch \.php$>
    SetHandler application/x-httpd-php
</FilesMatch>





Uncomment starting fpm in entrypoint.sh


echo -n "** Starting php-fpm7 in background..."
/usr/sbin/php-fpm7 --php-ini /etc/php7/php-new.ini
echo "DONE with php-fpm7"
echo