FROM mautic/mautic:latest

RUN \
  find \
    /usr/src/mautic \
    /var/www/html \
    /var/lock/apache2 \
    /var/run/apache2 \
    -exec chgrp root {} + \
    -exec chmod g=rwX,g-s {} + && \
    apt-get update && apt-get -y install mysql-client && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/apache2.conf

USER www-data
EXPOSE 8080
