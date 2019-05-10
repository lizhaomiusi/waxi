一键通配脚本
#!/bin/bash
# 一键创建用户、密码，授权sudo免密，禁用root远程登录
user1=ansible
pass1=ansible#
id $user1 >/dev/null 2>&1 || useradd $user1
# 判断用户ID是否存在
echo "$pass1" |passwd $user1 --stdin
echo "$user1    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
# 手动执行语法检查
visudo -c
# 验证好后禁用root远程登录
# 而在书写的时候为便与区分，往往会在i和a前面加一个反加一个反斜扛 。代码就变成了：
sed -i '/^#PermitRootLogin/a\PermitRootLogin no' /etc/ssh/sshd_config
# systemctl restart sshd
