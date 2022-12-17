FROM alpine:3.15

RUN apk update;   \
    apk --no-cache upgrade;  \
    #   Install
    apk --no-cache add mysql mysql-client; \
    #   generate /run/mysqld as pid directory for mysql
    mkdir -p /run/mysqld; \
    rm -rf /var/cache/apk/*       

#    copy in configuration files
COPY main-my.cnf                       /etc/my.cnf
COPY entrypoint.sh                     /

EXPOSE 22

# TODO: not yet working - does not provide a negative health check properly when not starting up correctly
# HEALTHCHECK CMD mysql mysql --user=mysql  --silent --execute "SELECT 1;"

# Expose for nfs 4  TODO: test if this really is necessary
EXPOSE 2049

# Expose port for mysql
EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]