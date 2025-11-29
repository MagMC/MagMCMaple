#!/bin/bash
set -e

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB in background
mysqld --user=mysql &
MYSQL_PID=$!

# Wait for MariaDB to start
echo "Waiting for MariaDB to start..."
for i in {1..30}; do
    if mysqladmin ping &>/dev/null; then
        echo "MariaDB is up!"
        break
    fi
    sleep 1
done

# Set root password and create database
mysql -u root <<-EOSQL
    SET @@SESSION.SQL_LOG_BIN=0;
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOSQL

echo "Database initialized successfully!"

# Stop background MariaDB
kill $MYSQL_PID
wait $MYSQL_PID

# Start MariaDB in foreground
exec mysqld --user=mysql