FROM alpine:3.6


RUN apk update && \
    apk add bash supervisor python python-dev py-pip apache2-proxy \
    ca-certificates certbot && \
    mkdir -p /var/log/supervisor && \
    mkdir -p /etc/letsencrypt/webrootauth && \
    rm -Rf /var/www/* && \
    mkdir -p /var/www/html/ && \
    ln -s /usr/lib/apache2 /usr/lib/modules && \
    mkdir -p /run/apache2
#    ln -s /usr/bin/php7 /usr/bin/php
COPY conf/httpd.conf /etc/apache2/httpd.conf
ADD conf/supervisord.conf /etc/supervisord.conf

# Add Scripts
ADD scripts/start.sh /start.sh
ADD scripts/pull /usr/bin/pull
ADD scripts/push /usr/bin/push
ADD scripts/letsencrypt-setup /usr/bin/letsencrypt-setup
ADD scripts/letsencrypt-renew /usr/bin/letsencrypt-renew
COPY scripts/httpd-foreground /usr/local/bin/
RUN chmod 755 /usr/bin/pull && chmod 755 /usr/bin/push && chmod 755 /usr/bin/letsencrypt-setup && chmod 755 /usr/bin/letsencrypt-renew && chmod 755 /start.sh && chmod 755 /usr/local/bin/httpd-foreground

# copy in code
ADD src/ /var/www/html/
ADD errors/ /var/www/errors


EXPOSE 443 80

CMD ["/start.sh"]