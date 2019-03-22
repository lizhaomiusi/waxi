linux下SSH远程连接服务慢解决方案  
  
1、适用命令及方案如下：  
【远程连接及执行命令】  
ssh -p22 root\@10.0.0.19  
ssh -p22 root\@10.0.0.19 /sbin/ifconfig  
【远程拷贝：推送及拉取】  
scp -P22 -r -p /etc root\@10.0.0.19:/tmp/  
scp -P22 -r -p root\@10.0.0.19:/tmp/ /etc  
【安全的FTP功能】  
sftp -oPort=22 root\@10.0.0.19  
【无密码验证方案】  
例如利用sshkey批量分发文件，执行部署操作。  
  
2、连接慢的主要原因是DNS解析导致  
解决方法：  
  
1、在ssh服务端上更改/etc/ssh/sshd_config文件中的配置为如下内容：  
UseDNS no  
\# GSSAPI options  
GSSAPIAuthentication no  
然后，执行/etc/init.d/sshd
restart重启sshd进程使上述配置生效，在连接一般就不慢了。  
  
2、如果还慢的话，检查ssh服务端上/etc/hosts文件中，127.0.0.1对应的主机名是否和  
uname -n的结果一样，或者把本机ip和hostname(uname -n结果)加入到/etc/hosts里。  
  
[root\@C64 \~]\# uname -n  
C64  
[root\@C64 \~]\# cat /etc/hosts  
\#modi by oldboy 11:12 2013/9/24  
127.0.0.1 C64 localhost localhost.localdomain localhost4 localhost4.localdomain4  
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6  
10.0.0.18 C64  
  
3、利用ssh-v的调试功能查找慢的原因  
其实可以用下面的命令调试为什么慢的细节（学习这个思路很重要）。  
ssh -v root\@10.0.0.19  
关闭ssh的gssapi认证  
用ssh -v user\@server 可以看到登录时有如下信息：  
debug1: Next authentication method: gssapi-with-mic  
debug1: Unspecified GSS failure. Minor code may provide more information  
注：ssh -vvv user\@server 可以看到更细的debug信息  
  
解决办法：  
在客户端上修改ssh客户端配置(注意不是sshd_conf）  
vi /etc/ssh/ssh_config，设置GSSAPIAuthentication no 并重启sshd  
可以使用  
ssh -A -o StrictHostKeyChecking=no -o GSSAPIAuthentication=no -p 32200
username\@server_ip  
GSSAPI ( Generic Security Services Application Programming Interface)
是一套类似Kerberos 5
的通用网络安全系统接口。该接口是对各种不同的客户端服务器安全机制的封装，以消除安全接口的不同，降低编程难度。但该接口在目标机器无域名解析时会有问题  
使用strace查看后发现，ssh在验证完key之后，进行authentication
gssapi-with-mic，此时先去连接DNS服务器，在这之后会进行其他操作。
