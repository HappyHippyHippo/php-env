FROM webdevops/php-nginx-dev:5.6

RUN pecl install mongo
RUN echo "extension=mongo.so" > /usr/local/etc/php/conf.d/mongo.ini
