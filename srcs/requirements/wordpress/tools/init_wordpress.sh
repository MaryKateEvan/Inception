#!/bin/sh

cd /var/www/html
wp core download --allow-root

chown -R www-data:www-data /var/www/
chown www-data:www-data /var/log/
chown -R www-data:www-data /run/php

# Check for required environment variables
: "${WP_URL:?Environment variable WP_URL is required}"
: "${DB_NAME:?Environment variable DB_NAME is required}"
: "${DB_USER:?Environment variable DB_USER is required}"
: "${DB_PASSWORD:?Environment variable DB_PASSWORD is required}"
: "${WP_TITLE:?Environment variable WP_TITLE is required}"
: "${WP_ADMIN_NAME:?Environment variable WP_ADMIN_NAME is required}"
: "${WP_ADMIN_PWD:?Environment variable WP_ADMIN_PWD is required}"
: "${WP_ADMIN_EMAIL:?Environment variable WP_ADMIN_EMAIL is required}"
: "${WP_USER_NAME:?Environment variable WP_USER_NAME is required}"
: "${WP_USER_EMAIL:?Environment variable WP_USER_EMAIL is required}"
: "${WP_USER_PASS:?Environment variable WP_USER_PASS is required}"

# Validate administrator username
if echo "${WP_ADMIN_NAME}" | grep -qiE "admin|administrator"; then
    echo "Error: Administrator username '${WP_ADMIN_NAME}' contains a restricted term (admin or administrator)."
    exit 1
fi

# Create wp-config.php
wp config create --force \
    --url="${WP_URL}" \
    --dbname="${DB_NAME}" \
    --dbuser="${DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --dbhost="mariadb:3306" \
    --allow-root || {
    echo "Error: Failed to create wp-config.php"
    exit 1
}

# Install WordPress core
wp core install --url="${WP_URL}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN_NAME}" \
    --admin_password="${WP_ADMIN_PWD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root || {
    echo "Error: Failed to install WordPress core"
    exit 1
}

# Check if the user exists before creating it
if ! wp user get "${WP_USER_NAME}" --allow-root; then
    wp user create "${WP_USER_NAME}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --allow-root || {
        echo "Error: Failed to create user ${WP_USER_NAME}"
        exit 1
    }
else
    echo "User ${WP_USER_NAME} already exists. Skipping user creation."
fi

# Validate the number of users in the database
user_count=$(wp user list --field=ID --allow-root | wc -l)
if [ "${user_count}" -ne 2 ]; then
    echo "Warning: Expected exactly 2 users in the WordPress database, but found ${user_count}."
    # exit 1
fi

# Update site URLs
wp option update home "${WP_URL}" --allow-root || {
    echo "Error: Failed to update home URL"
    exit 1
}
wp option update siteurl "${WP_URL}" --allow-root || {
    echo "Error: Failed to update site URL"
    exit 1
}

chown -R www-data:www-data /var/www/html/*

# Start PHP-FPM
exec php-fpm7.4 -F
