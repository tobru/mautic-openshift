FROM mautic/mautic:latest

RUN \
  find \
    /usr/src/mautic \
    /var/www/html \
    -exec chgrp root {} + \
    -exec chmod g=rwX,g-s {} +

USER www-data
