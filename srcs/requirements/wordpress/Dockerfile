# uses Debian Bullseye as the base image, which provides a minimal OS envirnoment to start upon
FROM debian:bullseye

WORKDIR /var/www/html

# Install PHP 7.4 and necessary extensions
RUN apt-get update \
	&& apt-get install -y php7.4 php7.4-fpm php7.4-mysql wget \
	&& apt-get clean

# RUN apt-get update \
# 	&& apt install -y php php8.2-fpm php8.2-mysqli wget \
# 	&& apt-get clean \
# 	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Prepare necessary directories
RUN mkdir -p /var/www/html /run/php

# Install WP-CLI and download WordPress
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp && \
	wp core download --path=/var/www/html --version=6.5.2 --allow-root

# Copy configuration files
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./tools/init_wordpress.sh /usr/local/bin/

# Set permissions
RUN chmod +x /usr/local/bin/init_wordpress.sh \
	&& chown -R www-data:www-data /var/www/ \
	&& chown www-data:www-data /var/log/ \
	&& chown -R www-data:www-data /run/php

USER www-data

EXPOSE 9000

CMD ["/usr/local/bin/init_wordpress.sh"]