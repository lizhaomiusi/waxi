使用ssh连接远程主机时加上“-o
StrictHostKeyChecking=no”的选项，如下：（推荐！！！）  
  
在ssh/scp里加上 -o "StrictHostKeyChecking no"
即可跳过这个yes/no询问，直接进入下一步，例：

scp -o "StrictHostKeyChecking no" 1.txt user\@host:1.txt  
ssh -o "StrictHostKeyChecking no" user\@host  
  
一个彻底去掉这个提示的方法是，修改/etc/ssh/ssh_config文件（或\$HOME/.ssh/config）中的配置，添加如下两行配置：

一般为：\# StrictHostKeyChecking ask  
可改为：StrictHostKeyChecking no  
　　 UserKnownHostsFile /dev/null

修改好配置后，重新启动sshd服务即可

/etc/init.d/sshd restart

当然，这是内网中非常信任的服务器之间的ssh连接，所以不考虑安全问题，就直接去掉了主机密钥（host
key）的检查。

ssh中遇到的“Host key verification
failed.”问题，也是和“StrictHostKeyChecking”配置有关。
