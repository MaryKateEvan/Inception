# Step 1: Alpine Linux as the base image
FROM alpine:latest

# Step 2: Install MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

# Step 3: Create necessary directories and set permissions
RUN mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

# Step 4: Set up MariaDB data directory and initialize database
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Step 5: Copy a custom MariaDB configuration file (optional)
# COPY ./my.cnf /etc/my.cnf

# Step 6: Expose MariaDB port (3306 is the default)
EXPOSE 3306

# Step 7: Set the entrypoint command to start MariaDB
CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql"]
