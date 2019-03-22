sshpass命令  
  
Linux命令之非交互SSH密码验证  
ssh登陆不能在命令行中指定密码。sshpass的出现，解决了这一问题。sshpass用于非交互SSH的密码验证，一般用在sh脚本中，无须再次输入密码。  
它允许你用 -p
参数指定明文密码，然后直接登录远程服务器，它支持密码从命令行、文件、环境变量中读取。  
  
yum install epel-release -y  
yum install sshpass -y  
  
其默认没有安装，需要手动安装，方法如下：  
  
sshpass下载地址：http://sourceforge.net/projects/sshpass/ 下载为一个
tar.gz的压缩包。  
tar -zxvf sshpass-1.05.tar.gz  
cd sshpass-1.05  
./configure --prefix=/opt/sshpass \#指定安装目录  
make  
make install  
cp /opt/sshpass/bin/sshpass /usr/bin/  
2.用法介绍  
  
-p password \#后跟密码  
[root\@zhu \~]\# sshpass -p 123456 ssh root\@192.168.56.102  
Last login: Wed Apr 16 15:35:22 2014 from 192.168.56.1  
[root\@jiang \~]\# exit  
logout  
Connection to 192.168.56.102 closed.  
-f filename \#后跟保存密码的文件名，密码是文件内容的第一行。  
[root\@zhu \~]\# cat 1.txt  
123456  
[root\@zhu \~]\# sshpass -f 1.txt ssh root\@192.168.56.102  
Last login: Fri Apr 18 13:48:20 2014 from 192.168.56.101  
[root\@jiang \~]\# exit  
logout  
Connection to 192.168.56.102 closed.  
-e \#将环境变量SSHPASS作为密码  
[root\@zhu \~]\# export SSHPASS=123456  
[root\@zhu \~]\# sshpass -e ssh root\@192.168.56.102  
Last login: Fri Apr 18 13:51:45 2014 from 192.168.56.101  
[root\@jiang \~]\# exit  
logout  
Connection to 192.168.56.102 closed.  
  
\#从命令行方式传递密码 -p指定密码  
\$ sshpass -p '123456' ssh user_name\@host_ip  
\$ sshpass -p '123456' scp root\@host_ip:/home/test/t ./tmp/  
  
如在多台主机执行命令：  
  
[root\@zhu \~]\# cat a.sh  
\#!/bin/bash  
for i in \$(cat /root/1.txt)  
do  
echo \$i  
sshpass -p123456 ssh root\@\$i 'ls -l'  
done
