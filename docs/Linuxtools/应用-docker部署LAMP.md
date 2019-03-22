应用-docker部署LAMP

LAMP是目前比较流行的web框架，即Linux+Apache+Mysql+PHP的网站架构方案。docker是目前非常流行的虚拟化应用容器，可以为任何应用创建一个轻量级、可移植的容器。现在我们就来通过docker来部署LAMP环境，并且搭建wordpress博客系统来测试。

系统环境

操作系统版本：Centos 7.5 64位

Docker版本：18.06.1-ce（社区版）

ip地址：192.168.2.226

lamp网络ip地址：172.18.0.1

1、下载mysql、php-apache镜像

docker pull mysql

docker pull php:7.2-apache

创建自定义网络lamp

docker network create lamp

docker network ls

2、创建生成mysql、httpd-php容器的脚本

vim docker_lamp.sh

\#!/bin/bash

function mysql()

{

docker run --name mysql --net lamp -p 3306:3306 \\

\-v /data/docker/mysql/data:/var/lib/mysql \\

\-v /data/docker/mysql/conf:/etc/mysql/conf.d \\

\-v /data/docker/mysql/logs:/logs \\

\-e MYSQL_ROOT_PASSWORD=test123456 \\ \#设置mysql的root密码

\-d mysql:latest --character-set-server=utf8 \#使用utf8编码

}

function httpd_php()

{

docker run --name httpd-php --net lamp -p 80:80 \\

\-v /data/docker/httpd/conf:/etc/apache2/sites-enabled \\

\-v /data/docker/www:/var/www/html \\

\-v /data/docker/httpd/logs:/var/log/apache2 \\

\-d php:7.2-apache

}

\$1

3、启动mysql、httpd-php容器

sh docker_lamp.sh mysql

sh docker_lamp.sh httpd_php

4、写一个php的首页文件来进行测试

echo "\<?php phpinfo(); ?\>" \> /data/docker/www/index.php

通过浏览器访问http://192.168.2.226

5、修改mysql的密码加密方式为mysql_native_password

vim /data/docker/mysql/conf/docker_mysql.cnf

[mysqld]

default-authentication-plugin=mysql_native_password

如果不修改加密方式的话，低版本的mysql客户端登陆时会报以下错误

6、数据库操作

docker exec -it mysql /bin/bash

mysql -uroot -ptest123456

mysql\> create database wordpress;

mysql\> create user wps\@localhost identified by '123456';

mysql\> grant all privileges on wordpress.\* to wps\@localhost;

mysql\> create user wps\@172.18.0.1 identified by '123456';

mysql\> grant all privileges on wordpress.\* to wps\@172.18.0.1;

mysql\> alter user wps\@172.18.0.1 identified with mysql_native_password by
'123456';

mysql\> exit

完成
