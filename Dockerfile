FROM mautic/mautic:latest

RUN \
  find \
    /usr/src/mautic \
    -exec chgrp root {} + \
    -exec chmod g=rwX,g-s {} +

USER www-data
