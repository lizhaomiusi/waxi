Linux下批量管理工具pssh使用记录

https://www.cnblogs.com/kevingrace/p/6378719.html  
https://www.linuxidc.com/Linux/2017-04/142726.htm

pssh是一款开源的软件，使用python实现，用于批量ssh操作大批量机器；pssh是一个可以在多台服务器上执行命令的工具，同时支持拷贝文件，是同类工具中很出色的；比起for循环的做法，我更推荐使用pssh！使用pssh的前提是：必须在本机与其他服务器上配置好密钥认证访问（即ssh信任关系）。  
下面就说下使用pssh进行批量操作的记录：  
  
1）安装pssh  
可以yum直接安装：  
[root\@bastion-IDC \~]\# yum install -y pssh  
  
2）pssh用法  
[root\@bastion-IDC \~]\# pssh --help  
-h 执行命令的远程主机列表文件  
-H user\@ip:port 文件内容格式[user\@]host[:port]  
-l 远程机器的用户名  
-P 一次最大允许多少连接  
-o 输出内容重定向到一个文件  
-e 执行错误重定向到一个文件  
-t 设置命令执行的超时时间  
-A
提示输入密码并且把密码传递给ssh（注意这个参数添加后只是提示作用，随便输入或者不输入直接回车都可以）  
-O 设置ssh参数的具体配置，参照ssh_config配置文件  
-x 传递多个SSH 命令，多个命令用空格分开，用引号括起来  
-X 同-x 但是一次只能传递一个命令  
-i 显示标准输出和标准错误在每台host执行完毕后  
-I 读取每个输入命令，并传递给ssh进程 允许命令脚本传送到标准输入  
  
3）pssh实例说明  
[root\@bastion-IDC \~]\# cat hosts.txt
//列表文件内的信息格式是“ip:端口”，如果本机和远程机器使用的ssh端口一致，则可以省去端口，直接用ip就行。不过建议还是将端口都带上为好。  
192.168.1.101:22  
192.168.1.109:22  
192.168.1.118:25791  
192.168.1.105:25791  
如上四台机器放在一个列表文件hosts.txt内，本机已经和这四台机器做了ssh无密码登陆的信任关系  
注意：列表文件内的机器必须提前和本机做好ssh信任关系，如果没有做的话，那么pssh批量执行时，轮到这台没有做信任关系的机器时就不会执行。  
  
a）批量执行命令  
[root\@bastion-IDC \~]\# pssh -h hosts.txt -l root -i 'uptime'  
[1] 16:05:48 [SUCCESS] 192.168.1.105  
03:03:25 up 79 days, 13:44, 0 users, load average: 0.04, 0.01, 0.00  
[2] 16:05:48 [SUCCESS] 192.168.1.118  
03:03:32 up 75 days, 15:27, 4 users, load average: 0.96, 0.74, 0.45  
Stderr: Address 192.168.1.118 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[3] 16:05:48 [SUCCESS] 192.168.1.109  
03:03:25 up 61 days, 21:56, 2 users, load average: 0.02, 0.06, 0.18  
Stderr: Address 192.168.1.102 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[4] 16:05:48 [SUCCESS] 192.168.1.101  
16:03:17 up 35 days, 23:45, 1 user, load average: 0.03, 0.04, 0.01  
Stderr: Address 192.168.1.101 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
  
如果添加-A参数，那么即使提前做了ssh信任关系，还是会提示输入密码！  
[root\@bastion-IDC \~]\# pssh -h hosts.txt -l root -i -A 'uptime'  
Warning: do not enter your password if anyone else has superuser  
privileges or access to your account.  
Password:
//注意这个参数添加后只是提示作用，可以在此随便输入或者不输入直接回车都可以  
[1] 16:08:25 [SUCCESS] 192.168.1.105  
03:06:03 up 79 days, 13:46, 0 users, load average: 0.00, 0.00, 0.00  
[2] 16:08:25 [SUCCESS] 192.168.1.109  
03:06:03 up 61 days, 21:59, 2 users, load average: 0.00, 0.04, 0.15  
Stderr: Address 192.168.1.102 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[3] 16:08:25 [SUCCESS] 192.168.1.101  
16:05:54 up 35 days, 23:47, 1 user, load average: 0.00, 0.02, 0.00  
Stderr: Address 192.168.1.101 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[4] 16:08:25 [SUCCESS] 192.168.1.118  
03:06:10 up 75 days, 15:29, 4 users, load average: 0.85, 0.78, 0.51  
Stderr: Address 192.168.1.118 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
  
[root\@bastion-IDC \~]\# pssh -h hosts.txt -l root -i -t 10 -o /root/pssh.log
'uptime && date'  
[1] 17:01:02 [SUCCESS] 192.168.1.109  
03:58:33 up 79 days, 5:58, 1 user, load average: 0.00, 0.00, 0.00  
Wed Feb 8 03:58:33 EST 2017  
[2] 17:01:02 [SUCCESS] 192.168.1.105  
03:58:40 up 79 days, 14:39, 1 user, load average: 0.00, 0.00, 0.00  
Wed Feb 8 03:58:40 EST 2017  
[3] 17:01:02 [SUCCESS] 192.168.1.101  
16:58:31 up 36 days, 40 min, 1 user, load average: 0.10, 0.03, 0.01  
Wed Feb 8 16:58:31 CST 2017  
Stderr: Address 192.168.1.101 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[4] 17:01:02 [SUCCESS] 192.168.1.118  
03:58:47 up 75 days, 16:22, 3 users, load average: 0.20, 0.21, 0.31  
Wed Feb 8 03:58:47 EST 2017  
Stderr: Address 192.168.1.118 maps to localhost, but this does not map back to
the address - POSSIBLE BREAK-IN ATTEMPT!  
[root\@bastion-IDC \~]\# ll /root/pssh.log/  
total 16  
-rw-r--r--. 1 root root 100 Feb 8 17:01 192.168.1.101  
-rw-r--r--. 1 root root 99 Feb 8 17:01 192.168.1.105  
-rw-r--r--. 1 root root 99 Feb 8 17:01 192.168.1.109  
-rw-r--r--. 1 root root 100 Feb 8 17:01 192.168.1.118  
  
b）批量上传文件或目录（pscp.pssh命令）  
批量上传本地文件/mnt/test.file到远程服务器上的/tmp目录：  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt /mnt/test.file /tmp/  
[1] 16:18:05 [SUCCESS] 192.168.1.105  
[2] 16:18:05 [SUCCESS] 192.168.1.109  
[3] 16:18:05 [SUCCESS] 192.168.1.101  
[4] 16:18:05 [SUCCESS] 192.168.1.118  
  
批量上传本地文件/mnt/test.file、/mnt/aa.file、/mnt/bb.file到远程服务器上的/tmp目录：  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt /mnt/test.file
/mnt/aa.file /mnt/bb.file /tmp/  
[1] 16:22:50 [SUCCESS] 192.168.1.109  
[2] 16:22:50 [SUCCESS] 192.168.1.105  
[3] 16:22:50 [SUCCESS] 192.168.1.118  
[4] 16:22:50 [SUCCESS] 192.168.1.101  
或者：  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt
/mnt/{test.file,aa.file,bb.file} /tmp/  
[1] 16:23:44 [SUCCESS] 192.168.1.109  
[2] 16:23:44 [SUCCESS] 192.168.1.105  
[3] 16:23:44 [SUCCESS] 192.168.1.101  
[4] 16:23:44 [SUCCESS] 192.168.1.118  
  
批量上传本地目录/mnt/zhong到远程服务器上的/tmp目录（上传目录需要添加-r参数）：  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt -r /mnt/zhong /tmp/  
[1] 16:19:36 [SUCCESS] 192.168.1.109  
[2] 16:19:36 [SUCCESS] 192.168.1.105  
[3] 16:19:36 [SUCCESS] 192.168.1.101  
[4] 16:19:36 [SUCCESS] 192.168.1.118  
  
批量上传本地目录/mnt/zhong、/mnt/aa、/mnt/vv到远程服务器上的/tmp目录  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt -r /mnt/zhong /mnt/aa
/mnt/vv /tmp/  
[1] 16:21:02 [SUCCESS] 192.168.1.105  
[2] 16:21:02 [SUCCESS] 192.168.1.109  
[3] 16:21:02 [SUCCESS] 192.168.1.101  
[4] 16:21:02 [SUCCESS] 192.168.1.118  
或者：  
[root\@bastion-IDC \~]\# pscp.pssh -l root -h hosts.txt -r /mnt/{zhong,aa,vv}
/tmp/  
[1] 16:22:00 [SUCCESS] 192.168.1.109  
[2] 16:22:00 [SUCCESS] 192.168.1.105  
[3] 16:22:00 [SUCCESS] 192.168.1.101  
[4] 16:22:00 [SUCCESS] 192.168.1.118  
  
c）批量下载文件或目录（pslurp命令）  
批量下载服务器上的某文件到本地，不用担心重名问题，因为pssh已经建立了以文件列表内的ip为名称的目录来存放下载的文件：  
[root\@bastion-IDC \~]\# pslurp -l root -h hosts.txt /etc/hosts .  
[1] 16:32:01 [SUCCESS] 192.168.1.109  
[2] 16:32:01 [SUCCESS] 192.168.1.105  
[3] 16:32:01 [SUCCESS] 192.168.1.101  
[4] 16:32:01 [SUCCESS] 192.168.1.118  
[root\@bastion-IDC \~]\# ll  
total 123  
drwxr-xr-x. 2 root root 4096 Feb 8 16:32 192.168.1.101  
drwxr-xr-x. 2 root root 4096 Feb 8 16:32 192.168.1.105  
drwxr-xr-x. 2 root root 4096 Feb 8 16:32 192.168.1.109  
drwxr-xr-x. 2 root root 4096 Feb 8 16:32 192.168.1.118  
[root\@bastion-IDC \~]\# ll 192.168.1.101  
total 4  
-rw-r--r--. 1 root root 224 Feb 8 16:32 hosts  
[root\@bastion-IDC \~]\# ll 192.168.1.109  
total 4  
-rw-r--r--. 1 root root 252 Feb 8 16:32 hosts  
[root\@bastion-IDC \~]\# ll 192.168.1.105  
total 4  
-rw-r--r--. 1 root root 252 Feb 8 16:32 hosts  
[root\@bastion-IDC \~]\# ll 192.168.1.118  
total 4  
-rw-r--r--. 1 root root 212 Feb 8 16:32 hosts  
  
另外特别注意：  
上面的批量下载操作，只能下载到本地的当前目录下，不能在命令中跟指定的路径：  
[root\@bastion-IDC \~]\# pslurp -l root -h hosts.txt /etc/hosts /mnt/  
[1] 16:34:14 [FAILURE] 192.168.1.109 Exited with error code 1  
[2] 16:34:14 [FAILURE] 192.168.1.105 Exited with error code 1  
[3] 16:34:14 [FAILURE] 192.168.1.101 Exited with error code 1  
[4] 16:34:14 [FAILURE] 192.168.1.118 Exited with error code 1  
  
要想下载到本机的/mnt目录下，正确的做法是先切换到/mnt目录下，然后再执行下载命令：（列表文件要跟全路径）  
[root\@bastion-IDC \~]\# cd /mnt/  
[root\@bastion-IDC mnt]\# pslurp -l root -h /root/hosts.txt /etc/hosts ./  
[1] 16:34:34 [SUCCESS] 192.168.1.109  
[2] 16:34:34 [SUCCESS] 192.168.1.105  
[3] 16:34:34 [SUCCESS] 192.168.1.118  
[4] 16:34:34 [SUCCESS] 192.168.1.101  
[root\@bastion-IDC mnt]\# ll  
total 16  
drwxr-xr-x. 2 root root 4096 Feb 8 16:34 192.168.1.101  
drwxr-xr-x. 2 root root 4096 Feb 8 16:34 192.168.1.105  
drwxr-xr-x. 2 root root 4096 Feb 8 16:34 192.168.1.109  
drwxr-xr-x. 2 root root 4096 Feb 8 16:34 192.168.1.118  
  
上面是批量下载文件，要是批量下载目录，只需要添加一个-r参数即可！  
[root\@bastion-IDC mnt]\# pslurp -l root -h /root/hosts.txt -r /home/ ./  
[1] 16:39:05 [SUCCESS] 192.168.1.109  
[2] 16:39:05 [SUCCESS] 192.168.1.105  
[3] 16:39:05 [SUCCESS] 192.168.1.101  
[4] 16:39:05 [SUCCESS] 192.168.1.118  
  
[root\@bastion-IDC mnt]\# ll 192.168.1.101  
total 8  
drwxr-xr-x. 6 root root 4096 Feb 8 16:39 home  
-rw-r--r--. 1 root root 224 Feb 8 16:38 hosts  
[root\@bastion-IDC mnt]\# ll 192.168.1.\*  
192.168.1.101:  
total 8  
drwxr-xr-x. 6 root root 4096 Feb 8 16:39 home  
-rw-r--r--. 1 root root 224 Feb 8 16:38 hosts  
  
192.168.1.105:  
total 8  
drwxr-xr-x. 4 root root 4096 Feb 8 16:39 home  
-rw-r--r--. 1 root root 252 Feb 8 16:38 hosts  
  
192.168.1.109:  
total 8  
drwxr-xr-x. 4 root root 4096 Feb 8 16:39 home  
-rw-r--r--. 1 root root 252 Feb 8 16:38 hosts  
  
192.168.1.118:  
total 8  
drwxr-xr-x. 3 root root 4096 Feb 8 16:39 home  
-rw-r--r--. 1 root root 212 Feb 8 16:38 hosts  
  
d）批量同步（prsync命令）  
同步本机/mnt/test目录下的文件或目录到远程机器的/mnt/test路径下  
[root\@bastion-IDC \~]\# prsync -l root -h hosts.txt -r /mnt/test/ /mnt/test/  
[1] 16:46:41 [SUCCESS] 192.168.1.109  
[2] 16:46:41 [SUCCESS] 192.168.1.105  
[3] 16:46:41 [SUCCESS] 192.168.1.118  
[4] 16:46:41 [SUCCESS] 192.168.1.101  
  
同步本机/mnt/test目录下的文件或目录到远程机器的/mnt路径下  
[root\@bastion-IDC \~]\# prsync -l root -h hosts.txt -r /mnt/test/ /mnt/  
[1] 16:47:40 [SUCCESS] 192.168.1.109  
[2] 16:47:40 [SUCCESS] 192.168.1.105  
[3] 16:47:45 [SUCCESS] 192.168.1.101  
[4] 16:47:46 [SUCCESS] 192.168.1.118  
  
注意：  
上面批量同步目录操作是将本机对应目录数据同步到远程机器上，远程机器上对于目录下多余的文件也会保留（不会删除多余文件）  
  
同理，批量同步文件操作，去掉-r参数，  
注意：同步文件的时候，其实就是完全覆盖，远程机器对应文件内的文件会被全部替换！  
如下：  
同步本机的/mnt/test/file文件内容到远程服务器/mnt/test/file文件内  
[root\@bastion-IDC \~]\# prsync -l root -h hosts.txt /mnt/test/file
/mnt/test/file  
[1] 16:53:54 [SUCCESS] 192.168.1.109  
[2] 16:53:54 [SUCCESS] 192.168.1.105  
[3] 16:53:54 [SUCCESS] 192.168.1.101  
[4] 16:53:54 [SUCCESS] 192.168.1.118  
[root\@bastion-IDC \~]\# prsync -l root -h hosts.txt /mnt/test/file /mnt/aaa  
[1] 16:54:03 [SUCCESS] 192.168.1.109  
[2] 16:54:03 [SUCCESS] 192.168.1.105  
[3] 16:54:03 [SUCCESS] 192.168.1.101  
[4] 16:54:04 [SUCCESS] 192.168.1.118  
  
e）批量kill远程机器上的进程（pnuke命令）  
比如批量kill掉远程机器上的nginx进程  
[root\@bastion-IDC \~]\# pnuke -h hosts.txt -l root nginx  
[1] 17:09:14 [SUCCESS] 192.168.1.109  
[2] 17:09:14 [SUCCESS] 192.168.1.105  
[3] 17:09:15 [SUCCESS] 192.168.1.118  
[4] 17:09:15 [SUCCESS] 192.168.1.101
