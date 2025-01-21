#!/bin/sh

mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Checks if the database is already initialized
if [ "$(ls -A /var/lib/mysql/mysql)" ]; then
    echo "Database directory is not empty; skipping initialization."
else
	echo "Initializing MariaDB database..."
# if [ -d "/var/lib/mysql/mysql" ]; then
# 	echo "Database already exists."
# else
# 	echo "Initializing MariaDB database..."

	# initializes the system database structure that MariaDB requires:
	# mysql_install_db --user=mysql --datadir=/var/lib/mysql

	# Preparing the db_init.sql file:
	echo "FLUSH PRIVILEGES;
	CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
	CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
	GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
	FLUSH PRIVILEGES;" > /etc/mysql/db_init.sql

	# runs MariaDB temporarily, in the background, without network connections:
	# mysqld_safe --skip-networking & 

	# # waits for MariaDB to be ready to accept connections
	# while ! mysqladmin ping --silent; do
	# 	echo "Waiting for MariaDB to be ready..."
	# 	sleep 1
	# done

	# runs the SQL init script using the MariaDB client (mysql)
	# mysql < /tmp/db_init.sql

	# shuts down the MariaDB server after initialization
	# mysqladmin shutdown

	# clean-up of the used now, file we created above
	# rm -f /tmp/db_init.sql
fi

echo "\033[0;32mMariaDB is ready for use!\033[0m"

mysql_install_db
mysqld

# sleep 1000

# Starts the properly initialized MariaDB server
# exec mysqld --user=mysql








# # Checks if the database is already initialized
# # if [ ! -d "/var/lib/mysql/mysql" ]; then
# # 	mkdir -p /var/lib/mysql
# # 	chown -R mysql:mysql /var/lib/mysql
# # 	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
# # 	echo "Database already exists."
# # fi

# 	echo "Initializing MariaDB database..."

# 	# initializes the system database structure that MariaDB requires:
# 	# mysql_install_db --user=mysql --datadir=/var/lib/mysql

# 	# Preparing the db_init.sql file:
# 	echo "FLUSH PRIVILEGES;
# 	CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
# 	CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
# 	GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
# 	FLUSH PRIVILEGES;" > /tmp/db_init.sql

# 	# runs MariaDB temporarily, in the background, without network connections:
# 	mysqld_safe --skip-networking & 

# 	# waits for MariaDB to be ready to accept connections
# 	while ! mysqladmin ping --silent; do
# 		echo "Waiting for MariaDB to be ready..."
# 		sleep 1
# 	done

# 	# runs the SQL init script using the MariaDB client (mysql)
# 	mysql < /tmp/db_init.sql

# 	# shuts down the MariaDB server after initialization
# 	mysqladmin shutdown

# 	# clean-up of the used now, file we created above
# 	rm -f /tmp/db_init.sql
# # fi

# echo "\033[0;32mMariaDB is ready for use!\033[0m"

# # Starts the properly initialized MariaDB server
# exec mysqld_safe --user=mysql
