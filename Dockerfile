FROM debian:jessie
MAINTAINER Rob Shad <robertmshad@googlemail.com>

# disable interactive functions.
ENV DEBIAN_FRONTEND noninteractive
ENV APTLIST="cron curl php5 php5-sqlite lftp libssh2-php sqlite3 apache2 libapache2-mod-php5 iftop git"

ADD crontab /etc/cron.d/locomotive-cron
RUN apt-get update -q && \
	apt-get install $APTLIST -qy && \
	apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* && \
	chmod 0644 /etc/cron.d/locomotive-cron && \
 	crontab /etc/cron.d/locomotive-cron && \
	# Install composer for PHP dependencies
	curl -o /tmp/composer-setup.php https://getcomposer.org/installer && \
	curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig && \
	php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" && \
	php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --snapshot && \ 
	rm -f /tmp/composer-setup.* && \
	mkdir /app && \
	mkdir /root/.config && \
	git clone https://github.com/stemwinder/locomotive /app && \
	git clone https://github.com/arfoll/unrarall /unrarall && \
	chmod u+x /app/locomotive && \
	cd /app && \
	composer install --no-interaction
	
CMD /usr/sbin/apache2ctl -D FOREGROUND
VOLUME ["/config", "/target", "/tmp"]
