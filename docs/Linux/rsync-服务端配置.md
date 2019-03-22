rsync服务端配置

https://www.cnblogs.com/JohnABC/p/6203524.html

rsync可以通过rsh或ssh使用，也能以daemon模式去运行，在以daemon方式运行时rsync
server会开一个873端口，等待客户端去连接。连接时rsync
server会检查口令是否相符，若通过口令查核，则可以通过进行文件传输，第一次连通完成时，会把整份文件传输一次，以后则就只需进行增量备份。

centos6下

安装方式

yum install rsync

源码编译安装

wget http://rsync.samba.org/ftp/rsync/src/rsync-3.0.9.tar.gz

tar xf rsync-3.0.9.tar.gz

cd rsync-3.0.9

./configure && make && make install

rsync服务端配置文件说明

cat/etc/rsyncd.conf

port = 873 \# 端口号

uid = nobody \# 指定当模块传输文件的守护进程UID

gid = nobody \# 指定当模块传输文件的守护进程GID

use chroot = no \# 使用chroot到文件系统中的目录中

max connections = 10 \# 设置并发连接数，0表示无限制

strict modes = yes \# 指定是否检查口令文件的权限

timeout = 300 \# 超时时间

pid file = /etc/rsyncd/rsyncd.pid \# 指定PID文件

lock file = /etc/rsyncd/rsyncd.lock \# 指定支持max
connection的锁文件，默认为/var/run/rsyncd.lock

log file = /etc/rsyncd/rsync.log \# rsync 服务器的日志

log format = %t %a %m %f %b

syslog facility = local3

[conf] \# 自定义模块名

path = /www \# 同步目录的真是路径通过path指定

comment = Nginx conf \# 定义注释说明字串，描述信息

motd file = /etc/motd.motd \# 指定消息文件，客户连接服务器时显示给用户

ignore errors \# 忽略一些IO错误

read only = no \#
是否允许客户端上传，no允许上传，yes不允许，设置为yes相当于只读，默认true

write only = no \#
是否允许客户端下载，no允许下载，yes不允许，设置为yes相当于只可写，默认false

hosts allow = 192.168.2.0/24 \#
设置哪些主机可以同步数据，多ip和网段之间使用空格分隔

hosts deny = \* \# 除了hosts allow定义的主机外，拒绝其他所有

list = false \# 客户端请求显示模块列表时，本模块名称是否显示，默认为true
\|false\|yes

auth users = backup \# 设置允许连接服务器的账户，此账户可以是系统中不存在的用户

secrets file = /etc/rsyncd/sync.pass \#
密码验证文件名，该文件权限要求为只读，建议为600，仅在设置auth users后有效

exclude = blank.png ; spinner.gif ; WEB-INF \# 同步时排除哪些文件和目录

rsync守护进程启动方式  
rsync --daemon --config=/etc/rsyncd.conf

可以把这句写到/etc/rc.local 中，开机启动。

netstat -ntlp  
pkill rsync \# 关进程 根据名称  
kill 1664 \# 进程号杀  
可以配置chkconfig init.d脚本

服务脚本必须存放在/etc/ini.d/目录下；

chkconfig rsync \# 添加到chkconfig中

chkconfig --add servicename \#
在chkconfig工具服务列表中增加此服务，此时服务会被在/etc/rc.d/rcN.d中赋予K/S入口了；

chkconfig --level 35 mysqld on \# 修改服务的默认启动等级。

也可以 centos6下

yum install xinetd -y

xinetd.d方式管理

启动rsync服务，编辑/etc/xinetd.d/rsync文件，将其中的disable=yes改为disable=no，并重启xinetd服务，如下：

[root\@nginx init.d]\# cat /etc/xinetd.d/rsync

\# default: off

\# description: The rsync server is a good addition to an ftp server, as it \\

\# allows crc checksumming etc.

service rsync

{

disable = no \# yes修改为no

flags = IPv6

socket_type = stream

wait = no

user = root

server = /usr/bin/rsync

server_args = --daemon

log_on_failure += USERID

}

[root\@nginx init.d]\# /etc/init.d/xinetd restart

chkconfig \# 查看管理的服务

服务端通配文件

cat/etc/rsyncd.conf

uid = root

gid = root

use chroot = no

max connections = 10

strict modes = yes

timeout = 300

pid file = /etc/rsyncd/rsyncd.pid

lock file = /etc/rsyncd/rsyncd.lock

log file = /etc/rsyncd/rsync.log

[www]

path = /www

comment = Nginx conf

motd file = /etc/rsyncd/motd.motd

ignore errors

read only = no

write only = no

hosts allow = 10.1.2.0/24

hosts deny = \*

list = false

auth users = www

secrets file = /etc/rsyncd/sync.pass
