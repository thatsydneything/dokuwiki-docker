FROM ubuntu:22.10

LABEL maintainer="That Sydney Thing"
LABEL org.opencontainers.image.source=https://github.com/thatsydneything/dokuwiki-docker

ENV DEBIAN_FRONTEND noninteractive
ENV LANG EN
ENV ACL ON
ENV ACL_POLICY 2
ENV LICENSE 0
ENV ALLOW_REG OFF
ENV POP OFF
ENV TITLE DokuWiki 
ENV USERNAME WikiUser
ENV PASSWORD ""
ENV FULL_NAME "Wiki User"
ENV EMAIL test@test.com
ENV DEBUG_DISABLE_INSTALL 0

RUN apt update && apt install -y php \ 
                libapache2-mod-php \
                php-xml \
                php-mbstring \
                php-zip \
                php-intl \
                php-gd \
                wget \
                tar \
                curl \
                && apt clean \
                && rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz && tar xzvf dokuwiki-stable.tgz \
    && mv dokuwiki-*a /usr/share/dokuwiki && mv /usr/share/dokuwiki/lib /tmp && mv /usr/share/dokuwiki/conf /tmp \
    && mv /usr/share/dokuwiki/data /tmp && mkdir /usr/share/dokuwiki/lib \
    && mkdir /usr/share/dokuwiki/conf && mkdir /usr/share/dokuwiki/data && chown -R www-data:www-data /usr/share/dokuwiki/* && chown -R www-data:www-data /tmp \
    && chown -R www-data:www-data /var/log/apache2 && chown -R www-data:www-data /var/run/apache2 && chown -R www-data:www-data /etc/apache2 && chown -R www-data:www-data /var/lib/apache2 \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && sed -i 's/Listen 443/Listen 8443/' /etc/apache2/ports.conf \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/sites-enabled/000-default.conf && sed -i 's/Listen 443/Listen 8443/' /etc/apache2/sites-enabled/000-default.conf

COPY entrypoint.sh /
COPY apache.conf /etc/dokuwiki/apache.conf

RUN ln -s /etc/dokuwiki/apache.conf /etc/apache2/sites-available/dokuwiki.conf \
    && chmod +x /entrypoint.sh && chmod g+rwX /usr/share/dokuwiki

EXPOSE 8080 8443

USER www-data

ENTRYPOINT ["/entrypoint.sh"]