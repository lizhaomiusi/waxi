pdsh [options] ... command

方括号中用来指定目标主机及其它参数，command 用来指定在目标主机上所要执行的命令。  
值得注意的是，使用pdsh
时，master该机必须用所要连接目标主机的用户具有无密码访问的权限，且连接时亦不询问yes
或no才可以对目标主机操作成功，具体无密码访问方法可以查阅其它资料。  
  
所有的参数可以通过pdsh --help来查看，下面简要介绍一下其中的常用参数:  
  
-w TARGET, .....  
TARGET用来指示目标主机或目标的过滤条件，该参数不可和-a,-g同时使用，TARGET可以直接使用主机名或主机名列表，如:  
pdsh -w node1,node2,node3
date（命令中不含引号，此处只是用来和文字加以隔离，下同）  
此命令用来查看node1,node2,node3上的时间。  
  
可以对目标主机指定范围，如:  
pdsh -w node[1-10] date  
在node1到node10上执行date命令。  
  
如果目标主机名前有“-”，则表示将此主机从目标中排除，如:  
pdsh -w node[1-10] -node5 date  
此命令的目标主机为node1至node4,node6至node10。  
  
如果目标前为“\^”，则用来指示包含目标主机的文件，文件中每行一个该机名。如:  
pdsh -w /home/oralce/namelist date  
  
如果以“-”开始，后跟“/”，则表示用来选择目标主机的正则表达式，如  
pdsh -w host[0-20],/0\$/ ...  
表示host0-host20中选择以0结尾的主机名。  
  
此外，目标主机前还可以加连接模块名及连接的用户名。如:  
pdsh -w ssh:oracle\@node[1-10] date  
表示使用ssh连接目标该机的oracle用户。  
  
-x host,host,....  
用来将主机排除在目标主机之外，一般和-a,-g连用。“\^”,“/”,“-”用法与上相同，不再说明。  
-l user  
这个选项用来指定以user连接到目标主机上。  
-t seconds  
用来设置连接的超时时间，以秒为单位。默认为10秒。  
-u seconds  
用来设置远程命令执行的超时时间，以秒为单位，以ssh 连接 时，默认时间为无限。  
-f number  
用来设置同时连接的目标主机的个数，  
-N  
用来关闭目标主机所返回值前的主机名显示。  
-g groupname  
指定目标主机的组名  
-X groupname  
用来将组名内的主机从目标主机中排除。  
-V  
用来显示当前pdsh的版本信息及所加载的模块信息。  
-L  
用来显示当块所有加载的模块信息。  
-R  
交互  
III. 安装和示例  
安装很简单，和其他Linux下的软件安装一样，三个步骤：  
  
wget
http://cdnetworks-kr-2.dl.sourceforge.net/project/pdsh/pdsh/pdsh-2.26/pdsh-2.26.tar.bz2  
tar jxvf pdsh-2.26.tar.bz2  
cd pdsh-2.26  
./configure --prefix=[path]  
make  
make install  
复制代码  
  
IV. 补充  
pdsh安装后，在bin目录下还有其他几个工具，如pdcp，pdcp可以用来将某结点上的文件复制到其它目标结点上，此命令对于大规模系统上程序的发布很有用。  
pdsh的帮助页：http://linux.die.net/man/1/pdsh  
  
Mussh和ClusterSSH的下载地址也提供下：ClusterSSH、Mussh  
  
2、查看当前所有加载的模块信息  
[root\@masterpdsh-2.29]\# pdsh -L

3、利用pdsh统计主机信息，-w参数后可接多个主机  
[fieldyang\@master\~]\$ pdsh -w ssh:192.168.56.103 "uname -r"  
192.168.56.103:2.6.32-642.1.1.el6.x86_64  
[fieldyang\@master\~]\$ pdsh -w ssh:192.168.56.103 "uname -n"  
192.168.56.103:slave.field.com  
[fieldyang\@master\~]\$ pdsh -w ssh:192.168.56.103 "uptime"  
192.168.56.103: 11:03:17 up 1:33, 2 users, load average: 0.85, 0.89, 0.87  
[fieldyang\@master\~]\$ pdsh
-wssh:slave.field.com,ssh:slave.field.com,ssh:slave.field.com "date"  
slave:2017年03月30日星期四11:21:02 CST  
slave:2017年03月30日星期四11:21:02 CST  
slave:2017年03月30日星期四11:21:02 CST

4、将主机名写入文件中，利用pdsh批量执行  
[root\@master\~]\# mkdir /etc/pdsh/  
[root\@master\~]\# vim /etc/pdsh/machines  
[root\@master\~]\# chmod 777 /etc/pdsh/machines  
[fieldyang\@master\~]\$ more /etc/pdsh/machines  
slave.field.com  
slave.field.com  
slave.field.com  
[fieldyang\@master\~]\$ pdsh -R ssh -a uptime  
slave: 11:09:32 up 1:40, 2 users, load average: 0.62, 0.71, 0.80  
slave: 11:09:32 up 1:40, 2 users, load average: 0.62, 0.71, 0.80  
slave: 11:09:32 up 1:40, 2 users, load average: 0.62, 0.71, 0.80  
\#该例中，演示将所有远程主机主机名都写入到本地主机的/etc/pdsh/machines文件中，  
这个路径是在编译pdsh时通过“--with-machines”参数指定的。只需利用-a参数即可在所有主机上执行

5、利用pdsh实现远程主机分组管理  
[root\@master\~]\# mkdir /etc/dsh/group  
[root\@master\~]\# vim /etc/dsh/group/userhosts  
[root\@master\~]\# chmod 777 /etc/dsh/group/userhosts  
[fieldyang\@master\~]\$ more /etc/dsh/group/userhosts  
slave.field.com  
slave.field.com  
[fieldyang\@master\~]\$ pdsh -R ssh -g userhosts uptime  
slave: 11:13:19 up 1:44, 2 users, load average: 0.55, 0.64, 0.76  
\#该例中，将某些服务器主机名写入userhosts文件中，利用-g参数调用即可在相关远程主机上执行。  
大规模运维环境中，可以分别分为web服务器组，数据库服务器组等。  
\#要实现远程主机的分组管理，需要激活pdsh的dshgroup模块，也就是在编译的pdsh的时候指定“--with-dshgroups”参数，  
激活这个参数后，就可以将不同用途的服务器进行分组，可以不同组主机列表写入不同文件中，  
并放到本地主机的\~/.dsh/group或/etc/dsh/group目录下。  
[fieldyang\@master\~]\$ pdsh -R ssh -a -X userhosts uptime  
slave: 11:13:39 up 1:44, 2 users, load average: 0.81, 0.69, 0.77  
slave: 11:13:39 up 1:44, 2 users, load average: 0.81, 0.69, 0.77  
\#-a参数指定所有主机，-X排除某些主机，-R指定ssh模块

6、pdsh在远程主机上执行命令  
[fieldyang\@master\~]\$ pdsh -R ssh -g userhosts "rm -rf
/home/fieldyang/index.html"  
[fieldyang\@slave\~]\$ ll \| grep index  
\#利用pdsh在远程主机上执行删除命令  
[fieldyang\@master \~]\$pdsh -R ssh -g userhosts "sudo /etc/init.d/httpd start"  
slave:正在启动httpd：[确定]  
\#利用pdsh在远程主机上启动某系服务，注意sudo命令需要远程用户启用sudo权限  
[fieldyang\@master\~]\$ pdsh -R ssh -g userhosts "sudo mkdir /mnt/test"  
[fieldyang\@slavemnt]\$ ll \| grep test  
drwxr-xr-x 2 root root 4096 3月3011:18 test  
\#利用pdsh在远程主机上创建目录

7、pdsh交互模式：  
pdsh交互模式和pdsh命令区别不大，只是把在远程执行的命令放到pdsh命令行下执行  
[fieldyang\@master\~]\$ pdsh -R ssh -w slave.field.com  
pdsh\>pwd  
  
四、pdcp应用实例  
1、将本地主机/home/fieldyang/pssh-2.3.1.tar.gz复制到远程主机的/home/fieldyang目录下  
[fieldyang\@master\~]\$ pdcp -R ssh -g userhosts
/home/fieldyang/pssh-2.3.1.tar.gz/home/fieldyang  
2、将本地主机/home/fieldyang/test下的所有文件和子目录递归复制到远程主机的/home/fieldyang目录下  
[fieldyang\@master\~]\$ pdcp -R ssh -g userhosts -r /home/fieldyang/test
/home/fieldyang
