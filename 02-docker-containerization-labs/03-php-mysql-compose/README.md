# Task 3 - PHP, MySQL & phpMyAdmin using Docker Compose

#In this task, we created a Docker-based web application that connects a PHP server with a MySQL database and includes phpMyAdmin for database management. The main goal was to configure the `docker-compose.yml` file properly so that all three containers (PHP, MySQL, and phpMyAdmin) work together.

#We updated the `docker-compose.yml` file as follows:

version: '3.9'

services:
  db:
    image: mysql:latest
    container_name: mysql_db
    restart: always
    ports:
      - "9906:3306"
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: studentdb
      MYSQL_USER: user
      MYSQL_PASSWORD: user123
    volumes:
      - db_data:/var/lib/mysql

  php-apache-environment:
    container_name: php-apache
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    depends_on:
      - db
    ports:
      - "8000:80"
    volumes:
      - .:/var/www/html/
    environment:
      MYSQL_HOST: db
      MYSQL_USER: user
      MYSQL_PASSWORD: user123
      MYSQL_DATABASE: studentdb

  phpmyadmin:
    image: phpmyadmin:latest
    container_name: phpmyadmin_ui
    restart: always
    depends_on:
      - db
    ports:
      - "8081:80"
    environment:
      PMA_HOST: db
      PMA_USER: root
      PMA_PASSWORD: root

volumes:
  db_data:

#After saving the file, we used the following commands to build and run the containers:

docker compose up -d --build
docker ps
docker compose down
docker compose restart db

#Once the containers were running, we copied the PHP source files (`index.php` and `insert.php`) into the project folder so the web application could connect to the database.

Access details:
- PHP Application: http://localhost:8000  
- phpMyAdmin: http://localhost:8081  
  Username: root  
  Password: root  


