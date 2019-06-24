#!/bin/bash
# 一键创建普通用户密码，授权sudo免密
USER1=ansible
PASSWD1=ansible#1
# 判断用户ID是否存在
id $USER1 >/dev/null 2>&1 || useradd $USER1
echo "$PASSWD1" |passwd $USER1 --stdin
cp /etc/sudoers{,.bak}
echo "$USER1    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
# 手动执行语法检查
visudo -c
# 设置账户过期时间 7天后
# chage -E $(date -d '+7day' +%F) $USER1
# 设置密码过期时间 3天后，修改之后才可用
# chage -M 5 $USER1
# 设置密码失效时间 3天后
# chage -I 3 $USER1
