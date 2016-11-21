FROM php:5.6-apache

ENV MAUTIC_VERSION 2.2.1
ENV MAUTIC_SHA1 da3e142aecfa10a4ded4f139207ac554dec6bafb

RUN apt-get update && apt-get install -y libc-client-dev libicu-dev libkrb5-dev libmcrypt-dev libssl-dev unzip zip && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure imap --with-imap --with-imap-ssl --with-kerberos && \
    docker-php-ext-install imap intl mbstring mcrypt mysqli pdo pdo_mysql && \
    a2enmod rewrite && \
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/apache2.conf && \
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf

RUN curl -o mautic.zip -SL https://s3.amazonaws.com/mautic/releases/${MAUTIC_VERSION}.zip && \
	  echo "$MAUTIC_SHA1 *mautic.zip" | sha1sum -c - && \
	  unzip mautic.zip -d /var/www/html && \
	  rm mautic.zip && \
	  chown -R www-data:www-data /var/www/html && \
    find \
      /var/www/html \
      /var/lock/apache2 \
      /var/run/apache2 \
      -exec chgrp root {} + \
      -exec chmod g=rwX,g-s {} +

COPY docker-entrypoint.sh /entrypoint.sh
COPY makeconfig.php /makeconfig.php
COPY makedb.php /makedb.php
COPY php.ini /usr/local/etc/php/

#VOLUME /var/www/html
USER www-data
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
