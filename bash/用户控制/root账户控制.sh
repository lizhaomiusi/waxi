#!/bin/bash
# 一键创建普通用户密码，授权sudo免密
USER1=ansible
PASSWD1=ansible#
# 判断用户ID是否存在
id $USER1 >/dev/null 2>&1 || useradd $USER1
echo "$PASSWD1" |passwd $USER1 --stdin
cp /etc/sudoers{,.bak}
echo "$USER1    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
# 手动执行语法检查
visudo -c


# 第一种，禁用root远程登录，只允许控制台登录，或者利用普通用户远程登录利用su -切换到root登录
# sed -i '/^#PermitRootLogin/a\PermitRootLogin no' /etc/ssh/sshd_config
# systemctl restart sshd

# 第二种，root账户密钥登录
# 公钥导入到authorized_keys
# cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
# 注意权限 私钥权限是600，公钥为644，而.ssh目录权限是700
# chmod 600 authorized_keys
# chmod 700 ~/.ssh

# 编辑 /etc/ssh/sshd_config 文件，启用密钥认证
# RSAAuthentication yes
# PubkeyAuthentication yes
# 另外，请留意 root 用户能否通过 SSH 登录：
# PermitRootLogin yes
# 当你完成全部设置，并以密钥方式登录成功后，再禁用密码登录：
# PasswordAuthentication no
# 最后，重启 SSH 服务：
# service sshd restart