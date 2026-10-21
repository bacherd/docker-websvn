FROM alpine:3.24
ARG WEBSVN=2.8.7

RUN apk add --no-cache bash &&\
    apk add --no-cache apache2 apache2-utils apache2-webdav mod_dav_svn apache2-ctl &&\
    apk add --no-cache subversion &&\
    apk add --no-cache wget unzip php83 php83-apache2 php83-xml php83-session &&\
    mkdir -p /run/apache2/ 

ADD ./src/dav_svn.conf /etc/apache2/conf.d/dav_svn.conf
ADD ./src/entrypoint.sh /entrypoint.sh

ADD ./src/index.html /var/www/localhost/htdocs/index.html
ADD https://github.com/websvnphp/websvn/archive/${WEBSVN}.zip /var/www/localhost/htdocs/
RUN cd /var/www/localhost/htdocs/; unzip ${WEBSVN}.zip; mv websvn-${WEBSVN} websvn; rm ${WEBSVN}.zip
ADD ./src/websvn.php /var/www/localhost/htdocs/websvn/include/config.php

ADD ./src/svn-backup /etc/periodic/daily/svn-backup

RUN mkdir -p /run/apache2; \
    chmod +x /entrypoint.sh; \
    chmod +x /etc/periodic/daily/svn-backup; 

VOLUME ["/opt/repositories"]
VOLUME ["/opt/backups"]
VOLUME ["/opt/imports"]
VOLUME ["/opt/config"]

ENV BACKUP=true
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
