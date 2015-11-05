FROM elend80/docker-debian-nginx-php-fpm:latest
MAINTAINER "Youngho Byun (echoes)" <elend80@gmail.com>

ENV TERM xterm

RUN echo Asia/Seoul | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update
RUN apt-get install -y php5-mysql

ADD nginx.conf /etc/nginx/nginx.conf

ADD default.conf /etc/nginx/conf.d/default.conf

RUN adduser www-data www-data

RUN mkdir /var/www
RUN cp /usr/share/nginx/html/50x.html /var/www/50x.html
RUN rm -rf /usr/share/nginx/html

# Wordpress

ADD https://wordpress.org/latest.tar.gz /tmp/latest.tar.gz
RUN cd tmp && tar xvf latest.tar.gz && \
    mv /tmp/wordpress/* /var/www && \
    rm -rf wordpress/* && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www

ADD wp-config-sample.php /var/www/wp-config-sample.php

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord"]
