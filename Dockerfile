FROM php:7.4-fpm-alpine

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
    && apk add --no-cache --update \
    libmemcached-libs \
    zlib \
    libzip-dev \
    && set -xe \
    && apk add --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add --no-cache --update --virtual .memcached-deps $MEMCACHED_DEPS \
    && pecl install memcached \
    && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/20_memcached.ini \
    && pecl channel-update pecl.php.net \
    && pecl install redis \
    && pecl install xdebug \
    && docker-php-ext-install bcmath \
    pdo \
    pdo_mysql \
    zip \
    pcntl \
    opcache \
    && docker-php-ext-enable redis \
    xdebug \
    opcache \
    && php -m \
    && php --ini \
    && apk add --no-cache \
    nano \
    shadow \
    && rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && apk del .memcached-deps .phpize-deps \
    && rm -rf /tmp/*
