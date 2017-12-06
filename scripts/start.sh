#!/bin/sh

# Set custom webroot
if [ ! -z "$WEBROOT" ]; then
 sed -i "s#"/var/www/html"#"${WEBROOT}"#g" /etc/apache2/httpd.conf
 sed -i "s#/var/www/html/$1#${WEBROOT}/$1#g" /etc/apache2/httpd.conf
else
 webroot=/var/www/html
fi

if [ ! -z "$DOMAIN" ]; then
 sed -i "s#ServerName localhost:80#ServerName $DOMAIN:80#g" /etc/apache2/httpd.conf
fi

exec /usr/local/bin/httpd-foreground