FROM debian:bullseye-slim

LABEL maintainer="Lachlan Stevens"
LABEL org.opencontainers.image.source=https://github.com/thatsydneything

ENV DEBIAN_FRONTEND = noninteractive
ENV LANG = EN
ENV ACL = ON
ENV ACL_POLICY = 2
ENV LICENSE = 0
ENV ALLOW_REG = OFF
ENV POP = ON
ENV TITLE = 
ENV USERNAME =
ENV PASSWORD =
ENV FULL_NAME =
ENV EMAIL =

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

RUN wget https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz
RUN tar xzvf dokuwiki-stable.tgz
RUN mv dokuwiki-*a /usr/share/dokuwiki
RUN mv /usr/share/dokuwiki/lib /tmp && mv /usr/share/dokuwiki/conf /tmp && mv /usr/share/dokuwiki/data /tmp
RUN mkdir /usr/share/dokuwiki/lib && mkdir /usr/share/dokuwiki/conf && mkdir /usr/share/dokuwiki/data

RUN chown -R www-data:www-data /usr/share/dokuwiki

RUN echo 'Listen 8080' >> /etc/apache2/apache2.conf

COPY entrypoint.sh /
COPY apache.conf /etc/dokuwiki/apache.conf

RUN ln -s /etc/dokuwiki/apache.conf /etc/apache2/sites-available/dokuwiki.conf

RUN ["chmod", "+x", "/entrypoint.sh"]

EXPOSE 8080 8443

ENTRYPOINT ["/entrypoint.sh"]