VMware Vsphere 6.0安装部署  
https://blog.csdn.net/shengxia1999/article/details/52329945 \#总体架构  
https://blog.csdn.net/shengxia1999/article/details/52331055  
http://blog.51cto.com/wzlinux/2094598 \# vCenter  
http://blog.51cto.com/8189171/2063212 \# 重置密码  
http://blog.51cto.com/8189171/2064431 \# 磁盘满解决办法  
http://blog.51cto.com/8189171/2064438 \# 控制台进入命令行环境  
https://communities.vmware.com/message/2542507

重置vCenter控制台密码  
请先生成 vCenter Server Appliance 6.0
快照或备份，然后再继续。不要跳过该步骤，可以达到灾难恢复的目的。

重新引导 vCenter Server Appliance 6.0。

在操作系统启动后，出现 GRUB
引导加载程序后，立即按空格键/p键/e键（我试了这几个键好像都可以）禁用自动引导，  
让菜单停留在 GNU GRUB 菜单，键入 p， 输入 GRUB
密码。如下图。（一定要开机时候赶紧按，不然就会启动vcenter系统。就行windows进bios一样，别错过机会） 

会出现  
password:

备注：

（1）如果部署 vCSA 时未在 Virtual Appliance Management Interface (VAMI) 中编辑
root 密码，默认 GRUB 密码为 vmware。  
（2）如果使用 VAMI 重置了 vCSA 的 root 密码，则 GRUB 密码为在 VAMI 中为 root
帐户设置的密码。【如果这个密码忘记，请按博文上面留有一个“红帽辅助外界光盘方式破解”】

输入 GRUB 密码回车之后会进入下图界面。找到第二排以kernel 开头的行，按e进入编辑。  
  
该行的末尾加入" init=/bin/bash"有空格。键入完毕回车。  
（注：\<on nousb audit=1 vga=0x311等等的 与有的文档说的\<on usb
audit=1等，不用管它，直接再后面添加本步骤的代码即可）  
  
会自动返回第4步界面。请按b键重新引导。  
在命令提示符下，如下图。输入命令 passwd root并提供新的 root
密码。输入2遍之后，再输入reboot重启即可。  
  
vCenter 服务  
VMware vCenter Server Appliance 6.0.0  
  
Type: vCenter Server with an embedded Platform Services Controller  
  
Last login: Wed Dec 26 04:14:59 UTC 2018 from 192.168.97.17 on pts/0  
Last login: Wed Dec 26 04:16:56 2018 from 192.168.97.17  
Connected to service  
  
\* List APIs: "help api list"  
\* List Plugins: "help pi list"  
\* Enable BASH access: "shell.set --enabled True" \#启用shell  
\* Launch BASH: "shell" \#进入shell视图  
  
localhost:\~ \# service-control -h  
usage: service-control [-h] [--start] [--stop] [--all] [--status] [--list]
[--ignore]  
[--file FILE] [--dry-run]  
...  
  
positional arguments:  
services Services on which to operate  
  
optional arguments:  
-h, --help show this help message and exit \# 帮助显示此帮助消息并退出  
--start Start all VMware services (except core) \# 启动所有VMware服务(核心除外)  
--stop Stop all VMware services (except core) \#
停止停止所有VMware服务(核心除外)  
--all Start/stop all VMware services (including core) \#
启动/停止所有VMware服务(包括core)  
--status Get status of all VMware services (except core) (default) \#
获取VMware所有服务(核心除外)的状态(默认)  
--list List all controllable services \# 列出所有可控服务  
--ignore Ignore errors. Continue starting or stopping services even if errors  
occur. \# 即使出现错误，也要继续启动或停止服务  
--file FILE Service config file \# 文件文件服务配置文件  
--dry-run Print actions to be performed without actually doing them \#
在不实际执行的情况下，要执行的打印操作
