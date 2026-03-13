#!/bin/bash
apt-get update
# Install MySQL 8 and required utilities
apt-get install -y mysql-server mysql-shell

# Allow connections from any IP
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf
echo "server_id=${server_id}" >> /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql

# Configure root password and create a database for the Go application
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${db_password}';"
mysql -u root -p"${db_password}" -e "CREATE DATABASE IF NOT EXISTS testdb;"
mysql -u root -p"${db_password}" -e "USE testdb; CREATE TABLE IF NOT EXISTS employee (id INT AUTO_INCREMENT PRIMARY KEY, firstname VARCHAR(50), lastname VARCHAR(50), position VARCHAR(50), salary INT);"

# Populate data only on the first node (Primary)
if [ "${server_id}" -eq 1 ]; then
    mysql -u root -p"${db_password}" -e "USE testdb; INSERT INTO employee (firstname, lastname, position, salary) VALUES ('John', 'Smith', 'Senior Software Engineer', 5000), ('Vladyslav', 'Kotsiuba', 'DevOps Engineer', 9999);"
fi
