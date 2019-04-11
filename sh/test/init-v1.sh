#!/bin/bash

set_key(){
  if [ ! -d /root/.ssh ]; then
 	 mkdir -p /root/.ssh
  	chmod 700 /root/.ssh
  fi
for ((i=1;i<=5;i++));do
     if [ ! -f /root/.ssh/authorized_keys ];then
  	curl -f http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key > /tmp/metadata-key 2>/dev/null
  	if [ $? -eq 0 ];then
    	cat /tmp/metadata-key >> /root/.ssh/authorized_keys
    	chmod 0600 /root/.ssh/authorized_keys
    	restorecon /root/.ssh/authorized_keys
    	rm -f /tmp/metadata-key
    	echo "Successfully retrieved public key from instance metadata"
    	echo "*****************"
    	echo "AUTHORIZED KEYS"
    	echo "*****************"
    	cat /root/.ssh/authorized_keys
    	echo "*****************"
  	fi
    fi
done
}

set_hostname(){
    PRE_HOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/hostname)
    DOMAIN_NAME=$(echo $PRE_HOSTNAME | awk -F '.' '{print $1}')
    hostnamectl set-hostname `echo ${DOMAIN_NAME}.example.com`
}

set_static_ip(){
    PRE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
    NET_FILE="/etc/sysconfig/network-scripts/ifcfg-eth0"
echo  "TYPE=Ethernet" > $NET_FILE
echo  "BOOTPROTO=static" >> $NET_FILE
echo  "NAME=eth0" >> $NET_FILE
echo  "DEVICE=eth0" >> $NET_FILE
echo  "ONBOOT=yes" >> $NET_FILE
echo  "IPADDR=${PRE_IP}" >> $NET_FILE
echo  "NETMASK=255.255.255.0" >> $NET_FILE
echo  "GATEWAY=192.168.56.2" >> $NET_FILE
}

main(){
   set_key;
   set_hostname;
   set_static_ip;
   /bin/cp /tmp/rc.local /etc/rc.d/rc.local
   reboot
}

main
