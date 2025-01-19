# uses Debian Bullseye as the base image, which provides a minimal OS envirnoment to start upon
FROM debian:bullseye

# updates the package manager and installs mariadb server package
RUN apt-get update -y && apt-get upgrade -y \
	&& apt-get install -y mariadb-server \
	&& apt-get clean && rm -rf /var/lib/apt/lists/*

# passes our modified configuration to the container
COPY ./conf/db_config.cnf /etc/mysql/mariadb.conf.d/

# passes our intialiazation script to the container
COPY ./tools/db_script.sh /usr/local/bin/
# (saving it in the /usr/local/bin/ makes the script available container-wide by just typing "script.sh")

# gives execution permission to the script
RUN chmod +x /usr/local/bin/db_script.sh

# prepares both directories' ownership to cover all MariaDB operational requirements
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
# (the `var/lib/mysql` is for data storage and the `var/run/mysqld` is for runtime files)

# exposes the default MariaDB port 
EXPOSE 3306

# specifies the script to be executed when the container starts
CMD ["db_script.sh"]
