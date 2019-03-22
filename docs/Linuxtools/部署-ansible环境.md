Ansible环境

http://www.linuxe.cn/sort/ansible  
https://www.cnblogs.com/Dev0ps/p/7803294.html  
http://www.ansible.com.cn/

Ansible是一个开源产品，用于自动执行资源的配置管理和应用程序部署。在阿里云上，使用Ansible可创建虚拟机、容器和网络等基础设施。
此外，您还可以使用Ansible在环境中自动配置资源和部署应用。

基本概念

在使用Ansible前，您需要了解以下核心概念：

Ansible playbook

Ansible
playbook是Ansible的配置、部署和编排语言。它们可以通过YAML的格式描述您希望远程系统执行的一套运维实施策略或一般IT流程中的一系列步骤。

Ansible模块

Ansible
模块是Ansible执行任务的核心。这些模块是独立的代码，可以通过命令行或者Playbook执行。Ansible模块应该具有幂等性。

操作步骤

执行以下命令安装Ansible。

yum install ansible

或者pip3 install ansible==2.7 \# 使用pip安装指定版本Ansible

查看安装的Ansible版本。

ansible -version

/etc/ansible/ansible.cfg \# ansible服务主配置文件  
/etc/ansible/hosts \# 主机列表配置文件

主机清单  
/etc/ansible/hosts  
插件目录  
/usr/share/ansible/plugins  
ansible -h  
[root\@centos7 \~]\# ansible -h  
Usage: ansible \<host-pattern\> [options]  
  
-v,-verbose 详细模式，如果命令执行成功，输出详细的结果(-vv -vvv -vvvv)  
-i PATH,-inventory=PATH
指定host文件的路径，默认是在/etc/ansible/hosts(生产环境经常用到)  
-f NUM,-forks=NU NUM 指定一个整数，默认是5，指定fork开启同步进程的个数。  
-m NAME,-module-name=NAME 指定使用的module名称，默认是command  
-m DIRECTORY,-module-path=DIRECTORY
指定module的目录来加载module，默认是/usr/share/ansible,  
-a,MODULE_ARGS 指定module模块的参数  
-k,-ask-pass 提示输入ssh的密码，而不是使用基于ssh的密钥认证  
-sudo 指定使用sudo获得root权限(生产环境经常用到)  
-K,-ask-sudo-pass 提示输入sudo密码，与-sudo一起使用 (生产环境经常用到)  
-u USERNAME,-user=USERNAME 指定移动端的执行用户  
-C,-check 测试此命令执行会改变什么内容，不会真正的去执行  
  
ansible的基本语法：  
ansible \<host-pattern\> [-f forks] [-m module_name] [-a args] [options]  
\<host-pattern\>：该选项指定ansible命令对哪些主机生效，可以使用主机列表中的地址或者组名，all代表所有主机  
[-f forks]：并发数，可以理解为ansible一次性要让多少个主机执行任务  
[-m module_name]：指定模块名  
[-a args]：指定动作 每个模块特有的参数，可以用ansible-doc -s
模块名来查看模块对应参数  
  
**输出内容显示绿色：表示执行成功，当没有任何改变**  
**输出内容显示黄色：表示执行成功，但对被管理主机进行了改变**  
**输出内容显示红色：表示执行失败！！！**  
  
配置主机清单  
/etc/ansible/hosts  
添加  
[backup]  
10.1.2.61 ansible_ssh_user=root ansible_ssh_pass=123  
10.1.2.62  
  
ansible-doc -l \# 列出所有模块  
ansible-doc -h \# 查看帮助  
ansible-doc -s [模块名] \# 获取模块帮助

Ansible常用模块用法介绍：

**ping模块** \# 等同于win的ping  
ansible all -m ping  
  
**command模块** \#
让远端主机执行命令，当没有用-m选项指定参数时，默认使用command模块  
ansible all -m command -a "netstat -ntlp \| grep 22" \# 对所有主机执行 ifconfig
command 对远程主机执行命令 不能识别管道符“\|”  
  
**shell模块** \#
和command模块一样是用来运行命令，当命令中有变量或者管道符的时候要用shell模块  
ansible all -m shell -a "netstat -ntlp \| grep 22" \# 能够解释复杂的命令
比如管道符“\|”  
ansible all -m shell -a "echo test \| passwd --stdin user1"  
  
**copy模块** \# 实现文件复制  
src=：定义本地源文件的路径  
dset=：定义目标文件路径  
content=：用该选项直接生成内容，替代src  
backup=：如果目标路径存在同名文件，将自动备份该文件  
ansible all -m copy -a 'src=/etc/fstab dest=/etc/fstab owner=root mode=640'  
ansible all -m copy -a 'content="hello world" dest=/etc/fstab owner=root
mode=640 backup=yes'  
ansible all -m copy -a "src=/root/anaconda-ks.cfg dest=/root/an.cfg mode=640" \#
复制一个本地文件到目标 指定权限为640 权限命令：mode权限 owner用户 group组  
ansible all -m copy -a "content='heelo\\nworld\\ndksld' dest=/root/an.cfg
mode=640" \# 直接写入文件到远程主机 权限为640  
  
**file模块** \# 设置文件的属性，如所属主、文件权限等  
ansible all -m file -a "path=/root/an.cfg mode=755" \# 指定目标文件 的权限
同样可以指定用户 组  
  
**path模块** \# 指定要设置的文件所在路径，可使用name或dest替换  
ansible all -m file -a 'owner=mysql group=mysql mode=644 path=/tmp/test'  
  
创建文件的软连接：  
src：指明源文件  
path：指明符号连接文件路径  
state：指明文件的格式，touch=创建新的文件；absent=删除文件，link=创建软连接文件；directory=创建目录  
ansible all -m file -a 'path=/etc/passwd.link src=/etc/passwd state=link'  
  
**script模块** \#
将本地的脚本复制到远端主机并执行，需要把脚本放在当前目录中并使用相对路径来指定  
ansible test -m script -a "/sh/test.sh"  
  
**fetch模块** \# 远程获取  
dest 目标文件拿到本地  
src 指定源地址  
flat 默认为no 如果设置为yes不会拉取路径信息  
ansible all -m fetch -a "src=/root/install.log dest=/root/ces1" \#
从远程主机拉取文件  
  
**cron模块** \#
设置定时任务，其中有个state选项包含present、absent两个参数，分别代表增加和移除  
ansible webserver -m cron -a 'minute="\*/10" job="/bin/echo test" name="test
cron job" '  
ansible webserver -m cron -a 'hour="\*/1" job="/usr/sbin/ntpdate 10.254.1.10"
name="crontab from ansible" state=present'  
  
**yum模块** \# 安装程序包，远端主机需要先配置好正确的yum源  
name：指明要安装的程序包，可以带上版本号，否则默认安装最新版本，多个安装包用逗号分隔  
state：present代表安装，也是默认操作；absent是卸载；latest最新版本安装  
  
ansible -m yum -a 'name=httpd state=present' \# 安装  
ansible all -m yum -a 'name=vsftpd' \# 安装  
ansible all -m yum -a 'name=vsftpd state=absent' \#卸载  
  
**service模块** \# 控制服务运行状态  
enabled：是否开机自动启动，取值为true或者false  
name：服务名称  
state：状态，取值有started，stopped，restarted  
ansible webserver -m service -a 'enabled=true name=httpd state=started'  
  
**filesystem模块** \# 文件系统模块

**user模块** \# 管理用户，还有一个group模块用于管理组  
使用格式：  
name= : 创建的用户名  
state= : present新增，absent删除  
force= : 删除用户的时候删除家目录  
system= : 创建系统用户  
uid= : 指定UID  
shell= : 指定shell  
home= : 指定用户家目录  
ansible all -m user -a "name=ccc system=true" \# 添加一个系统用户  
ansible webserver -m user -a "name=mysql system=yes"  
  
**synchronize模块** \# rsync相关  
hostname \# 管理主机名  
ansible all -a 'hostname' 获取主机名  
ansible 192.168.128.172 -m hostname -a "name=web_01"  
  
**setup模块** \#
收集被管理主机的信息，包含系统版本、IP地址、CPU核心数。在Ansible高级操作中可以通过该模块先收集信息，然后根据不同主机的不同信息做响应操作，类似Zabbix中的低级别发现自动获取磁盘信息一样。  
  
YAML与playbook  
剧本是包含了一系列任务的Ansible配置文件，通过YAML标记语言构建，通常配置文件以.yml结尾。YAML是一个高可读性的用来表达资料序列的格式语言，和XML不同的是YAML语法结构使用了键值+缩进格式，而不是标签格式。YAML在设计时也参考了多种编程语言（包含XML、PYTHON、PERL、C语言等），YAML和脚本语言的交互性能好，并且有很高的扩展性和表达能力。  
Ansible的playbook主要有以下组成部分组成：  
Inventory：主机列表，表示剧本中的任务要应用在哪些主机上  
Modules：要调用ansible哪些模块  
Commands：在主机上要运行哪些命令  
Playbooks：  
Tasks（核心）：任务，即调用哪些模块完成操作  
Variables：变量  
Templates：模板  
Handlers：处理器，由某事件触发执行的操作  
Roles：角色，定义哪个角色做哪些任务  
  
playbook中的每一个play的目的都是为了让某个主机以指定用户的身份去执行某个任务，
hosts用于指定要执行任务的主机（该主机一定要在Inventory主机列表中定义），可以是一个或多个，由冒号分割。user或者remote_user都可用于指定执行任务的用户，可以单独给每个tasks定义，如上面示例中的：  
- hosts: webnodes  
remote_user: root  
  
playbook中常用选项：  
remote_user：指定执行任务的用户（可单独给每个task定义），通常是root用户，也可指定非root用户使用sudo方式执行任务  
hosts：指定远程主机（多个主机用逗号分隔）或主机组  
user（可省略）：指定远程主机上执行任务的用户,这里假设使用了tom这个用户  
sudo（可省略）：如果设置为yes，那么user中指定的tom用户在执行任务时会获得root权限  
sudo_user（可省略）：指定sudo时切换的用户，如sudo_user设置为jerry，那么之前设置的user
tom在sudo时就会使用jerry的权限执行任务  
connection（可省略）：通过什么方式连接到远程主机，默认为SSH  
gather_facts（可省略）：如果明确不需要通过setup模块来获取远程主机facts信息，可以使用这个选项  
- hosts: webnodes  
remote_user: root  
tasks:  
- name: test connection  
ping:  
remote_user: nobody  
sudo: yes
