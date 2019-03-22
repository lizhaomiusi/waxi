rsync-故障

[备忘][转]rsync使用时的常见问题

sync使用时的常见问题：

错误1: rsync: read error: Connection reset by peer (104)

rsync error: error in rsync protocol data stream (code 12) at io.c(794)
[receiver=3.0.2]

解决：很大可能是服务器端没有开启 rsync 服务。开启服务。
或者开启了防火墙指定的端口无法访问。

错误2：\@ERROR: chdir failed

rsync error: error starting client-server protocol (code 5) at main.c(1495)
[receiver=3.0.2]

解决：服务器端同步目录没有权限，cwrsync默认用户是Svcwrsync。为同步目录添加用户Svcwrsync权限。

错误3：\@ERROR: failed to open lock file

rsync error: error starting client-server protocol (code 5) at main.c(1495)
[receiver=3.0.2]

解决：服务器端配置文件 rsyncd.conf中添加 lock file = rsyncd.lock 即可解决。

错误4：\@ERROR: invalid uid nobody

rsync error: error starting client-server protocol (code 5) at main.c(1506)
[Receiver=3.0.2]

解决：在rsyncd.conf文件中添加下面两行即可解决问题

UID = 0

GID = 0

错误5：\@ERROR: auth failed on module test2

rsync error: error starting client-server protocol (code 5) at main.c(1296)
[receiver=3.0.2]

解决：服务端没有指定正确的secrets file，请在 [test2]配置段添加如下配置行：

auth users = coldstar \#同步使用的帐号

secrets file = rsyncd.secrets \#密码文件

错误6：password file must not be other-accessible

解决：客户端的pass文件要求权限为600, chmod 600 /etc/rsync.pass 即可。

错误7：rsync: chdir /cygdrive/c/work failed

: No such file or directory (2)

解决：服务器端同步文件夹路径或名称写错了，检查path。

===============================================================

rsyncserver
服务启动时报错“rsyncserver服务启动后又停止了。一些服务自动停止，如果它们没有什么可做的，例如“性能日志和警报”服务。”

解决方法：将安装目录下的rsyncd.pid文件删除，再重新启动RsyncServer服务。一般是异常关机导致的。
