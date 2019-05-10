#!/bin/bash
name1=centos76
ip1=10.1.2.76
docker run -dit --privileged=true --name="$name1" -e "container=docker" -v /user/"$name1"/www/:/var/www/html/  centos /usr/sbin/init
dockerID=`docker ps -a |grep "$name1" |awk '{print $1}'`
pipework br0 "$dockerID" "$ip1"/24@10.1.2.2
docker exec -it "$name1" bash
yum install httpd -y
systemctl restart httpd
exit