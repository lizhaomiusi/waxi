应用-rsync+inotify配置

https://www.cnblogs.com/chensiqiqi/p/6542268.html

https://www.cnblogs.com/jackyyou/p/5681126.html

环境centos

[root\@nginx /]\# cat /etc/redhat-release

CentOS release 6.6 (Final)

基础配置，rsync服务端

linux内核从2.6.13版本开始提供inotify通知接口，用来监控文件系统各种变化情况

利用rsync工具与inotify机制相结合，可以实现触发式备份（实时同步），只要原始位置的文档发生变化，则立即启动增量备份操作，否则处于静态等待状态，

确认内核

[root\@nginx \~]\# uname -r

2.6.32-504.el6.x86_64

安装

\# http://sourceforge.net/projects/inotify-tools/

\# http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz

yum install inotify-tools -y

实现效果

把inotify-tools服务端10.1.2.62服务端上的/git目录实时同步到10.1.2.71上的/www目录中

环境配置

[root\@nginx \~]\# ll /proc/sys/fs/inotify/

总用量 0

\-rw-r--r-- 1 root root 0 3月 19 21:04 max_queued_events \# 监控事件队列

\-rw-r--r-- 1 root root 0 3月 19 21:04 max_user_instances \# 最多监控实例数

\-rw-r--r-- 1 root root 0 3月 19 21:04 max_user_watches \#
每个实例最多监控文件数

[root\@nginx \~]\# cat /proc/sys/fs/inotify/max_\*

16384

128

8192

编辑内核参数，直接修改/etc/sysctl.conf配置文件

cat \>\> /etc/sysctl.conf \<\< \\EOF

fs.inotify.max_queued_events = 10240

fs.inotify.max_user_instances = 1024

fs.inotify.max_user_watches = 102400

EOF

生效

sysctl -p

工具集合介绍：

一共安装了2个工具(命令)，即inotifywait和inotifywatch

inotifywait:在被监控的文件或目录上等待特定文件系统事件(open、close、delete等)发生，执行后处于阻塞状态，适合在shell脚本中使用。

inotifywatch:收集被监视的文件系统使用度统计数据，指定文件系统事件发生的次数统计。

测试监控目录发生变化，查看结果

inotifywait -h \# 帮助

常用参数：

\-e \# 用来指定要监控哪些事件；

包括create创建、move移动、delete删除、modify修改、attrib属性修改等等

\-m\|--monitor \# 始终保持事件监听状态

\-r\|--recursive \# 递归查询目录

\-q\|--quiet \# 打印很少的信息，仅仅打印监控相关的信息

\--excludei \<pattern\> \# 排除文件或目录时，不区分大小写

\--timefmt \<fmt\> --format \# 指定时间的输出格式 --timefmt '%d/%m/%y %H:%M'
--format '%T %w%f'

执行命令

inotifywait -mrq -e create,move,delete,modify /git/

在另外终端对目录进行写操作

echo aaaaaa \> /git/1.txt

查看终端事件

[root\@nginx \~]\# inotifywait -mrq -e create,move,delete,modify /git/

/git/ CREATE 1.txt

/git/ MODIFY 1.txt

利用触发式脚本实现，实时同步，web主服务器10.1.2.71发生变化实时同步到rsync服务器10.1.2.62上

前提免密，ssh或者rsync实现均可

\#!/bin/bash

\# 监听的目录

SRC1=/git/

\# 目的目录

DST1=www\@10.1.2.62::www

inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f' -e
create,move,delete,modify \${SRC1} \| while read line

do

rsync -azvP --delete \$SRC1 \$DST1 --password-file=/etc/rsync.passwd

done

实现防篡改，10.1.2.71发生变化，直接拉10.1.2.62上

\#!/bin/bash

\# 监听的目录

SRC1=/git/

\# 目的目录

DST1=www\@10.1.2.62::www

inotifywait -mrq --timefmt '%d/%m/%y %H:%M' --format '%T %w%f' -e
create,move,delete,modify \${SRC1} \| while read line

do

rsync -azvP --delete \$DST1 \$SRC1 --password-file=/etc/rsync.passwd

done

优化

\#!/bin/bash

Path=/data

backup_Server=10.1.2.62

/usr/bin/inotifywait -mrq --format '%w%f' -e create,close_write,delete /data \|
while read line

do

if [ -f \$line ];then

rsync -az \$line --delete rsync_backup\@\$backup_Server::nfsbackup
--password-file=/etc/rsync.passwd

else

cd \$Path &&\\

rsync -az ./ --delete rsync_backup\@\$backup_Server::nfsbackup
--password-file=/etc/rsync.passwd

fi

done

脚本可以加入开机启动：

echo "/bin/sh /server/scripts/inotify.sh &" \>\> /etc/rc.local
