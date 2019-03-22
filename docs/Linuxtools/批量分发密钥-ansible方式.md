https://www.cnblogs.com/amosli/p/6122908.html  
https://www.jianshu.com/p/4b5bd1f871bb

批量分发密钥时，新机器会提示输入 (yes/no)? 创建免手工输入yes

/etc/ansible/hosts，ansible配置文件：

[nginx]

10.1.2.71

10.1.2.72

/etc/ssh/ssh_config配置文件添加：

StrictHostKeyChecking no

运行：

ansible all -m ping

配置文件修改回原来的：

StrictHostKeyChecking ask

验证：

cat .ssh/known_hosts

ssh 172.16.0.3

使用密码批量操作机器(一开始机器无公钥)

格式：【主机名】 【主机地址】 【主机密码】 默认是root用户来进行的

cat /etc/ansible/hosts

[base]  
ansible_ssh_user="tomcat" ansible_ssh_port=22 ansible_ssh_host=192.168.21.61
ansible_ssh_pass="qqq111"  
mysql_172 ansible_ssh_port=22 ansible_ssh_host=172.16.0.3
ansible_ssh_pass=123456 host_key_checking=false ansible_sudo_pass='123456'

新版的ansible(2.4) hosts有更新， 用以下方式：  
[ces1]  
192.168.21.61 ansible_user=ansible ansible_ssh_pass="qqq111"  
192.168.21.62 ansible_user=ansible ansible_ssh_pass="qqq111"

测试

ansible -i host all -m shell -a "pwd" --user user1

第一种（常用）

脚本修改配置文件批量添加公钥

chmod +x /usr/local/src/script

\#!/bin/bash

mkdir /root/.ssh

chmod 700 /root/.ssh

echo '公钥内容' \>\>/root/.ssh/authorized_keys

chmod 600 /root/.ssh/authorized_keys

ansible all -m script -a "/usr/local/src/script"

补充：如果是用普通用户来管理的，需要批量创建用户和添加sudo 权限

第二种

ansible-playbook推送ymal，这里使用到了authoried_keys模块，可以参考  
http://docs.ansible.com/authorized_key_module.html

将以下文件命名为：push.ssh.ymal \# 注意主机 用户名 目录  
cat push.ssh.ymal


执行推送命令  
ansible-playbook push.ssh.ymal  
  
如若报错,解决  
Using a SSH password instead of a key is not possible because Host Key checking
is enabled and sshpass does not support this. Please add this host's fingerprint
to your known_hosts file to manage this host.  
修改host_key_checking(默认是check的)： \#
那么为什么失败了呢？失败的原因就是初始ssh访问客户机的时候，都会有检验公钥的提示。只要配置禁用即可。  
vi /etc/ansible/ansible.cfg  
\# uncomment this to disable SSH key host checking  
host_key_checking = False \# 设置为False

配置文件去除密码

[mysql]

mysql_172 ansible_ssh_port=22 ansible_ssh_host=172.16.0.3
ansible_sudo_pass='123456'

验证：

ansible -i hosts all -m shell -a 'pwd' --user djidba
--private-key=/home/user1/.ssh/id_rsa

测试  
\# 查看各机器时间  
ansible all -a date  
\# ansible all -m command -a date \# 作用同上
