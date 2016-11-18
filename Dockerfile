FROM mautic/mautic:latest

RUN \
  find \
    /usr/src/mautic \
    /var/www/html \
    -exec chgrp root {} + \
    -exec chmod g=rwX,g-s {} +

COPY ports.conf /etc/apache2/ports.conf

USER www-data
EXPOSE 8080
