centos 6  
开机按esc  
按 e 键进入编辑模式  
选择Kernel /vmlinz-2.6.32-696.e16... ... 后按 e 键编辑此项  
进入该编辑模式后，在quiet后面输入 simple 或者 1 然后回车 中间有空格  
按 b 键进入单用户模式  
passwd root  
输入2次新密码  
reboot 重启  
  
centos 7  
开机按esc  
选择CentOS Linux (3.10.0-693.......) 按 e 键  
光标移动到 linux 16 开头的行，找到 ro 改为 rw init=sysroot/bin/sh  
按 Ctrl+x 执行  
进入后输 chroot /sysroot  
输入 passwd  
根据提示输入2次新密码  
完成后输入 touch /.autorelabel 更新系统信息  
exit  
reboot 重启
