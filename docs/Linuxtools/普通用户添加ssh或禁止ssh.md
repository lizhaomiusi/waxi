linux 普通用户添加ssh或禁止ssh  
  
1、添加用户，首先用adduser命令添加一个普通用户，命令如下：  
  
\#adduser tommy  
//添加一个名为tommy的用户  
\#passwd tommy //修改密码  
Changing password for user tommy.  
New UNIX password: //在这里输入新密码  
Retype new UNIX password: //再次输入新密码  
passwd: all authentication tokens updated successfully.

2、赋予root权限  
方法一： 修改 /etc/sudoers 文件，找到下面一行，把前面的注释（\#）去掉  
\#\# Allows people in group wheel to run all commands  
%wheel ALL=(ALL) ALL  
然后修改用户，使其属于root组（wheel），命令如下：  
\#usermod -g root tommy  
修改完毕，现在可以用tommy帐号登录，然后用命令 su - ，即可获得root权限进行操作。  
  
方法二： 修改 /etc/sudoers 文件，找到下面一行，在root下面添加一行，如下所示：  
\#\# Allow root to run any commands anywhere  
root ALL=(ALL) ALL  
tommy ALL=(ALL) ALL  
修改完毕，现在可以用tommy帐号登录，然后用命令 su - ，即可获得root权限进行操作。  
  
方法三： 修改 /etc/passwd 文件，找到如下行，把用户ID修改为 0 ，如下所示：  
tommy:x:500:500:tommy:/home/tommy:/bin/bash  
修改后如下  
tommy:x:0:500:tommy:/home/tommy:/bin/bash  
保存，用tommy账户登录后，直接获取的就是root帐号的权限。  
若需要禁止普通用户ssh登录：  
修改后如下  
tommy:x:500:500:tommy:/home/tommy:/sbin/nologin  
或  
tommy:x:500:500:tommy:/home/tommy:/usr/bin/tommy-shell
