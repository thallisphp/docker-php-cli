FROM php:7.4-cli-alpine

LABEL maintainer="ThallisPHP <thallisphp@gmail.com>"

ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev

RUN set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    wget \
    curl \
    git \
    build-base \
    libmemcached \
    libmemcached-libs \
    libmcrypt-dev \
    libxml2-dev \
    pcre-dev \
    zlib-dev \
    autoconf \
    cyrus-sasl-dev \
    libgsasl-dev \
    nano \
    shadow \
    && apk add --no-cache --update libmemcached-libs zlib \
    && set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && pecl channel-update pecl.php.net \
    && pecl install redis \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-enable redis \
    && php -m \
    && php --ini
