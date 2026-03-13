#!/bin/bash
apt-get update
apt-get install -y mariadb-server
systemctl start mariadb
systemctl enable mariadb

mysql -e "CREATE DATABASE testdb;"
mysql -e "CREATE USER 'testuser'@'%' IDENTIFIED BY '${db_password}';"
mysql -e "GRANT ALL PRIVILEGES ON testdb.* TO 'testuser'@'%';"
mysql -e "FLUSH PRIVILEGES;"

mysql -e "USE testdb; CREATE TABLE employee (id INT AUTO_INCREMENT PRIMARY KEY, firstname VARCHAR(50), lastname VARCHAR(50), position VARCHAR(50), salary INT);"
mysql -e "USE testdb; INSERT INTO employee (firstname, lastname, position, salary) VALUES ('John', 'Smith', 'Senior Software Engineer', 5000), ('Vladyslav', 'Kot', 'DevOps Engineer', 9999);"

sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb
