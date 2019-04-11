#!/bin/bash

# 测试网络是否通畅
ping -c 1 223.5.5.5 >/dev/null && echo #####网络ok#####
# 第一步：关闭selinux和防火墙
setenforce 0 >/dev/null? && echo #####selinux已关闭#####
systemctl stop firewall >/dev/null && echo #####防火墙已关闭#####

# 第二步：确认软件是否安装
rpm -aq rpcbind >/dev/null
if [ $? -eq 0 ];then
?? ?echo "rpcbind软件已安装"
else 
?? ?yum install rpcbind -y >/dev/null && echo "正在安装软件"
fi
echo **********软件已安装**********



# 第三步:创建和发布共享目录
read -p "请输入需要共享的目录：" dir
mkdir $dir -p >/dev/null
chmod 1777 $dir
read -p "请输入需要共享的网段" wd
read -p "请输入以什么权限方式共享,输入ro或者rw:" qx
cat >> /etc/exports << end
$dir? $wd($qx)
end


# 第四步：启动服务开机自启动
systemctl restart rpcbind.service
systemctl enable rpcbind.service
systemctl restart nfs.service
systemctl enable nfs.service
echo "nfs共享服务已搭建完成，欢迎下次使用"
