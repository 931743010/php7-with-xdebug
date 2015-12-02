FROM ubuntu:latest

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ /etc/timezone && \
	apt-get update -y -qq && \
	apt-get upgrade -y -qq && \
	apt-get install -y -qq software-properties-common && \
        add-apt-repository -y ppa:ondrej/php-7.0 && \
        add-apt-repository ppa:nginx/development && \
        apt-get update -y -qq && \
        apt-get install -y -qq php7.0-cli \
                php7.0-common \
                php7.0-fpm \
                php7.0-dev \
                php7.0-curl \
                php7.0-mysql \
                php7.0-gd \
                php7.0-imap \
                php7.0-mysql \
                php7.0-pgsql \
                php7.0-sqlite3 \
                nginx \
                git \
                wget

RUN mkdir -p /run/php && \
	sed -i "s/;date.timezone =.*/date.timezone = Asia\/Shanghai/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 500M/" /etc/php/7.0/fpm/php.ini && \
    sed -i "s/post_max_size = 8M/post_max_size = 500M/" /etc/php/7.0/fpm/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf

ENV XDEBUG_PKG=xdebug-2.4.0rc1.tgz
RUN cd /tmp && \
	wget http://xdebug.org/files/$XDEBUG_PKG && \
	tar xvzf $XDEBUG_PKG && \
	cd xdebug-2.4.0RC1 && \
	phpize7.0 && \
	./configure --enable-xdebug && \
	make && \
	make install && \
	ln -snf /etc/php/mods-available/xdebug.ini /etc/php/7.0/cli/conf.d/20-xdebug.ini && \
	ln -snf /etc/php/mods-available/xdebug.ini /etc/php/7.0/fpm/conf.d/20-xdebug.ini

COPY xdebug/xdebug.ini  /etc/php/mods-available/xdebug.ini

RUN mkdir -p /var/www/php7.app && \
	chown -R www-data:www-data /var/www/php7.app

COPY nginx/php7.app /etc/nginx/sites-available/php7.app
COPY nginx/index.php /var/www/php7.app/index.php

RUN ln -snf /etc/nginx/sites-available/php7.app /etc/nginx/sites-enabled/php7.app

COPY nginx/startup.sh /usr/local/bin

EXPOSE 80
EXPOSE 9000
CMD ["startup.sh"]

