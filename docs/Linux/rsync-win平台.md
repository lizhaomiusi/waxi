Windows下cwRsyncserver搭建步骤

https://fenglingcorp.iteye.com/blog/1285860  
http://www.cnblogs.com/xwdreamer/p/3361647.html

https://www.cnblogs.com/xwdreamer/p/3361647.html  
  
CwRsync是基于cygwin平台的rsync软件包，支持windows对windows、windows对Linux、Linux对
windows高效文件同步。

由于CwRsync已经集成了cygwin类库，因此安装的时候可以省去cygwin包。

Cwrsync还集成了 OpenSSH for windows，可以实现Linux
下Rsync一模一样的操作。详细配置步骤如下：

一、服务器端安装配置

1、下载服务端安装文件 服务端是安装在“需要被同步的数据所在的服务器”

2、安装服务端 直到让你输入用户名和密码的对话框时，输入administrator
和你系统的密码这一步很重要，可以说是cwRsync安装成功与否的关键。这一步会在当前系统下生成
SvcCWRSYNC
一个账户，用来启动RsyncServer服务。建议这个对此账户的密码进行重新设置，从新设置密码后，需要在服务中更改，否则
RsyncServer服务 不能启动

服务端  
程序自动设置程序目录可修改的权限，因为需要写日志文件。  
配置文件默认在程序的安装目录下，默认是 C:\\Program
Files\\ICW3、修改配置文件rsyncd.conf

use chroot = false \# 不使用chroot  
strict modes = false \# 使用静态模式  
hosts allow = \*  
log file = rsyncd.log  
pid file = rsyncd.pid

lock file = rsyncd.lock \# 解决文件被锁定无法复制问题  
port = 8173 \# 默认端口8173  
uid = 0 \# 解决运行后的\@ERROR: invalid uid 错误  
gid = 0 \# 解决运行后的\@ERROR: invalid gid 错误  
max connections = 10 \# 最大连接数10  
  
\# Module definitions  
\# Remember cygwin naming conventions : c:\\work becomes /cygwin/c/work  
\#  
[www] \# 这里是认证的模块名，在client端需要指定  
path = /cygdrive/d/www \# 表示文件目录  
read only = false \# 只读关  
transfer logging = yes \# 记录传输日志  
list = no \# 不允许列文件  
hosts allow = 192.168.0.113 \# 允许登录IP

hosts deny = \* \# 禁止除上面允许的IP段外的连接IP  
auth users = SvcCWRSYNC \#
认证的用户名，这里没有这行，则表明是匿名可以不是系统用户

secrets file = /cygdrive/c/pass/rsync.passwd \# 认证文件格式user:passwd

\---

客户端  
win下从远端复制到本地类似scp 需要输入密码  
rsync -avz root\@10.1.2.12:/root/111111 /cygdrive/d/111/  
-a 参数，相当于-rlptgoD：  
-r 是递归  
-l 是链接文件，意思是拷贝链接文件  
-p 表示保持文件原有权限  
-t 保持文件原有时间  
-g 保持文件原有用户组  
-o 保持文件原有属主  
-D 相当于块设备文件  
-v 详细模式输出  
-z 传输时压缩  
-P 显示传输进度  
--progress 显示备份同步过程  
--delete
删除Client中有Server没有的文件，即如果Server删除了这一文件，那么client也相应把文件删除，保持真正的一致  
  
二、客户端安装配置  
1、下载客户端安装文件  
2、安装 一直下一步，安装完成。  
3、cwRsync客户端不需要很复杂的配置,需要设置环境变量  
/cygdrive/d/ 目录文件为d盘下  
  
rsync -avzP --progress --delete --password-file=/cygdrive/c/pass/rsync.passwd
SvcCWRSYNC\@192.168.2.242::test /cygdrive/e/test  
意思是将192.168.2.242的服务端下的test模块下的e:\\bak目录同步到客户端的e:\\test下命令参数解释：  
  
rsync -avzP --password-file=/cygdrive/d/rsync.pwd rsync1\@10.1.2.12::ftp
/cygdrive/d/1112  
指定密码文件同步 rsync1为服务端虚拟账户
