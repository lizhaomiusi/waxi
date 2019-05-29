#!/bin/bash
# 利用ansible批量添加host文件
cat > /etc/hosts << \EOF
10.1.2.71 ansible
10.1.2.72 web2
10.1.2.73 web3
EOF
ip1=$(ifconfig |grep 'broadcast' |awk '{print $2}')
if [ -z $(cat /etc/hosts |sed -n '1,10p' |cut -d " " -f1 |grep "$ip1") ]
then
  echo 错误chk_host_ip
else
  hostnamectl set-hostname $(cat /etc/hosts |grep "$ip1" |awk '{print $2}')
fi
