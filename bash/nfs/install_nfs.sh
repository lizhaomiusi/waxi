!#/bin/bash
# 测试网络是否通畅
ping -c 1 223.5.5.5 > /dev/null && echo #####网络ok#####
# 第一步：关闭selinux和防火墙
systemctl stop firewalld > /dev/null
systemctl disable firewalld > /dev/null
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

# 1、创建和发布共享目录
# 请输入需要共享的目录：
dir='/nfs'
# 请输入需要共享的网段,可以是单地址或者网段
wd='10.1.2.79'
# 请输入以什么权限方式共享,输入ro或者rw:
qx='rw'
mkdir $dir -p > /dev/null
chown -R nfsnobody:nfsnobody $dir
cat >> /etc/exports << EOF
$dir $wd($qx)
EOF

# 2、确认软件是否安装
rpm -q nfs-utils > /dev/null
if [[ $? -eq 0 ]];then
    echo "nfs安装成功"; 
else
    yum install -y nfs-utils /dev/null;
    if [[ $? -eq 0 ]];then
	    echo "安装成功";
    else
        echo "安装失败";
    fi;
fi
# 3、启动服务开机自启动
systemctl restart rpcbind.service 
systemctl enable rpcbind.service
systemctl restart nfs.service
systemctl enable nfs.service
echo "nfs共享服务已搭建完成，欢迎下次使用"
echo "共享目录"
showmount -e 127.0.0.1
