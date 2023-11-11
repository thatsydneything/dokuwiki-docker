FROM ubuntu:23.10

LABEL maintainer="That Sydney Thing"
LABEL org.opencontainers.image.source=https://github.com/thatsydneything/dokuwiki-docker
LABEL org.opencontainers.image.ref.name=dokuwiki
LABEL org.opencontainers.image.version=2023-04-04a

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
ENV REWRITE_URLS 1

COPY entrypoint.sh apache.conf /

RUN apt update && apt install -y --no-install-recommends \ 
                apache2 \
                libapache2-mod-php \
                php-xml \
                wget \
                tar \
                curl \
                ca-certificates \
    && mkdir /usr/share/dokuwiki && wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz && tar xzvf dokuwiki-stable.tgz -C /usr/share/dokuwiki --strip 1 \
    && rm dokuwiki-stable.tgz \
    && mv /usr/share/dokuwiki/lib /tmp && mv /usr/share/dokuwiki/conf /tmp \
    && mv /usr/share/dokuwiki/data /tmp && mkdir /usr/share/dokuwiki/lib \
    && mkdir /usr/share/dokuwiki/conf && mkdir /usr/share/dokuwiki/data && chown -R www-data:www-data /usr/share/dokuwiki/* && chown -R www-data:www-data /tmp \
    && chown -R www-data:www-data /var/log/apache2 && chown -R www-data:www-data /var/run/apache2 && chown -R www-data:www-data /etc/apache2 && chown -R www-data:www-data /var/lib/apache2 \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && sed -i 's/Listen 443/Listen 8443/' /etc/apache2/ports.conf \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/sites-enabled/000-default.conf && sed -i 's/Listen 443/Listen 8443/' /etc/apache2/sites-enabled/000-default.conf \
    && mkdir /etc/dokuwiki && mv apache.conf /etc/dokuwiki/ \
    && apt remove -y wget curl \
    && apt clean \
    && rm -rf /var/lib/apt/lists /var/cache/apt/archives \
    && ln -s /etc/dokuwiki/apache.conf /etc/apache2/sites-available/dokuwiki.conf \
    && chmod +x /entrypoint.sh && chmod g+rwX /usr/share/dokuwiki

EXPOSE 8080 8443

USER www-data

ENTRYPOINT ["/entrypoint.sh"]