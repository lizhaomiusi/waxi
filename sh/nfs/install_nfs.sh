#!/bin/bash

# ���������Ƿ�ͨ��
ping -c 1 223.5.5.5 >/dev/null && echo #####����ok#####
# ��һ�����ر�selinux�ͷ���ǽ
setenforce 0 >/dev/null? && echo #####selinux�ѹر�#####
systemctl stop firewall >/dev/null && echo #####����ǽ�ѹر�#####

# �ڶ�����ȷ������Ƿ�װ
rpm -aq rpcbind >/dev/null
if [ $? -eq 0 ];then
?? ?echo "rpcbind����Ѱ�װ"
else 
?? ?yum install rpcbind -y >/dev/null && echo "���ڰ�װ���"
fi
echo **********����Ѱ�װ**********



# ������:�����ͷ�������Ŀ¼
read -p "��������Ҫ�����Ŀ¼��" dir
mkdir $dir -p >/dev/null
chmod 1777 $dir
read -p "��������Ҫ���������" wd
read -p "��������ʲôȨ�޷�ʽ����,����ro����rw:" qx
cat >> /etc/exports << end
$dir? $wd($qx)
end


# ���Ĳ����������񿪻�������
systemctl restart rpcbind.service
systemctl enable rpcbind.service
systemctl restart nfs.service
systemctl enable nfs.service
echo "nfs��������Ѵ��ɣ���ӭ�´�ʹ��"
