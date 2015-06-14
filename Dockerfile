FROM debian:jessie
MAINTAINER Benjamin Boit <benboit@posteo.de>

# update package-lists
RUN apt-get update

# install apache
RUN apt-get install -y apache2

# install essentials
RUN apt-get install -y \
	sudo \
	htop \
	rsync \
	vim \
	nano \
	less \
	git-core \
	curl

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get update
RUN apt-get install -y nodejs

# install ruby
RUN apt-get install -y \
	ruby

# install capistrano
RUN gem install capistrano -v 2.15.5

# install php
RUN apt-get install -y \
	php5-fpm \
	php5-cli \
	php5-curl \
	php5-intl \
	php5-mcrypt \
	php5-xsl \
	php5-gd \
	php5-imagick \
	php5-intl \
	php5-memcached \
	php5-mysql \
	php5-xdebug

# setup fpm
RUN sed -i '/daemonize /c daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

# install composer globally
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# install memcached
RUN apt-get install -y memcached

# install mariadb-client
RUN apt-get install -y mariadb-client

# install supervisord
RUN apt-get install -y supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["/usr/bin/supervisord"]