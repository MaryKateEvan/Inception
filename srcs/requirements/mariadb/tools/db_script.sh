#!/bin/sh

mkdir -p /var/lib/mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Preparing the db_init.sql file:
echo "FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;" > /etc/mysql/db_init.sql

# Checks if data base exists
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "Database already exists."
    mysqld_safe
    # Uses `mysqld_safe` only if the database is already initialized
else
    echo "Initializing new MariaDB database..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    mysqld
fi
