FROM alpine:3.8


RUN apk update && \
    apk add apache2-proxy && \
    rm -Rf /var/www/* && \
    mkdir -p /var/www/html/ && \
    ln -s /usr/lib/apache2 /usr/lib/modules && \
    mkdir -p /run/apache2 && \
    rm -rf /var/cache/apk/*


COPY conf/httpd.conf /etc/apache2/httpd.conf

# Add Scripts
COPY scripts/ /usr/local/bin/
RUN chmod 755 /usr/local/bin/letsencrypt-setup && \
	chmod 755 /usr/local/bin/letsencrypt-renew && \
	chmod 755 /usr/local/bin/start.sh && \
	chmod 755 /usr/local/bin/httpd-foreground

# copy in code
COPY src/ /var/www/html/
#ADD errors/ /var/www/errors


EXPOSE 443 80

CMD ["/usr/local/bin/start.sh"]