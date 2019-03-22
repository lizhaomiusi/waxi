故障-启动或禁止用户或 IP 通过 SSH 登录

限制用户 SSH 登录

1.只允许指定用户进行登录（白名单）：

在 /etc/ssh/sshd_config 配置文件中设置 AllowUsers 选项，（配置完成需要重启 SSHD
服务）格式如下：

AllowUsers aliyun test\@192.168.1.1

\# 允许 aliyun 和从 192.168.1.1 登录的 test 帐户通过 SSH 登录系统。

2.只拒绝指定用户进行登录（黑名单）：

在/etc/ssh/sshd_config配置文件中设置DenyUsers选项，（配置完成需要重启SSHD服务）格式如下：

DenyUsers zhangsan aliyun

\# 拒绝 zhangsan、aliyun 帐户通过 SSH 登录系统

限制 IP SSH 登录

除了可以禁止某个用户登录，我们还可以针对固定的IP进行禁止登录，linux
服务器通过设置 /etc/hosts.allow 和 /etc/hosts.deny
这个两个文件，可以限制或者允许某个或者某段IP地址远程 SSH
登录服务器.方法比较简单，具体如下：

1. vim /etc/hosts.allow， 添加

sshd:192.168.0.1:allow \#允许 192.168.0.1 这个 IP 地址 ssh 登录

sshd:192.168.0.1/24:allow \#允许 192.168.0.1/24 这段 IP 地址的用户登录

2.vim /etc/hosts.allow，添加

sshd:ALL \# 拒绝全部的 ssh 登录

hosts.allow 和hosts.deny 两个文件同时设置规则的时候，hosts.allow
文件中的规则优先级高，按照此方法设置后服务器只允许 192.168.0.1 这个 IP 地址的
ssh 登录，其它的 IP 都会拒绝。
