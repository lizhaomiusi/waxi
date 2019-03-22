Windows安装OpenSSH服务  
  
最近项目在搞Jenkins持续集成，但是公司客户生产环境服务器大部分是Windows
Service，运维基本依靠远程桌面。Linux系统流行的OpenSSH并不支持Windows，网上搜索Windows安装OpenSSH大部分是比较老的教程，也试着装过MobaSSH。这种ssh是基于cygwin的，ssh连接后依然使用的linux命令，而且文档路径写法也不一样容易出错。。。  
  
经过一番寻找，终于找到了微软官方的解决方案：  
  
基于PowerShell的OpenSSH：https://github.com/PowerShell/Win32-OpenSSH/releases  
  
详细说明可以参考Github的Wiki，这里简单说下安装步骤：  
  
安装步骤：  
  
1、进入链接下载最新 OpenSSH-Win64.zip（64位系统），解压至C:\\Program
Files\\OpenSSH  
  
2、打开cmd，cd进入C:\\Program Files\\OpenSSH（安装目录），执行命令：  
  
powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1  
3、设置服务自动启动并启动服务：  
  
sc config sshd start= auto  
net start sshd  
到此服务已经安装完毕，默认端口一样是22，默认用户名密码为Window账户名和密码，当然防火墙还是要设置对应端口允许通讯  
  
修改设置：  
  
通常linux下会修改ssh_config文件来修改ssh配置，但在安装目录并没有发现这个文件，查阅官方wiki后发现，原来是在C:\\ProgramData\\ssh目录下（此目录为隐藏目录）  
  
端口号：Port 22  
  
密钥访问：PubkeyAuthentication yes  
  
密码访问：PasswordAuthentication no  
  
空密码：PermitEmptyPasswords no  
然后进入C:\\Users\\账户名\\.ssh目录，创建authorized_keys公钥文件（也可在ssh_config修改路径）  
  
设置完成后重启sshd服务，接下来就可以使用Xshell等工具使用密钥连接了\~  
  
踩过的坑：  
  
命令行不识别空格时：C:\\Program Files\\用C:\\Progra\~1\\替代  
Windows
Service2012R2即使配置了.ssh/authorized_keys公钥，连接时依然显示没有注册公钥。。。  
  
查阅了官方wiki判断可能是权限问题：Fix SSH file permissions  
  
进入C:\\Program Files\\OpenSSH（安装目录），右键
FixHostFilePermissions.ps1【使用PowerShell运行】，命令行提示全选是，重启sshd服务后密钥连接正常
