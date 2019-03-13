#��/bin/bash
#ϵͳ��������
cd /etc/yum.repos.d
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS-Base.repo CentOS-Base.repo.bak
mv CentOS6-Base-163.repo CentOS-Base.repo
yum clean all #���yum����
yum makecache #�ؽ�����
yum update  #����Linuxϵͳ
#���epel�ⲿyum��չԴ
cd /usr/local/src
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm
#��װgcc�������ļ���sysstat����
yum -y install gcc gcc-c++ vim-enhanced unzip unrar sysstat
#����ntpdate�Զ���ʱ
yum -y install ntp
echo "01 01 * * * /usr/sbin/ntpdate ntp.api.bz    >> /dev/null 2>&1" >> /etc/crontab
ntpdate ntp.api.bz
service crond restart
#�����ļ���ulimitֵulimit -SHn 65534
echo "ulimit -SHn 65534" >> /etc/rc.local
cat >> /etc/security/limits.conf << EOF
*                     soft     nofile             65534
*                     hard     nofile             65534
EOF
#����ϵͳ�ں��Ż�
cat >> /etc/sysctl.conf << EOF
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 10000 65535
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
EOF
/sbin/sysctl -p
#����control-alt-delete��ϼ��Է�ֹ�����
sed -i 's@ca��ctrlaltdel:/sbin/shutdown -t3 -r now@#ca:ctrlaltdel:/sbin/shutdown       -t3 -r now@' /etc/inittab
#�ر�SELinux
sed -i 's@SELINUX=enforcing@SELINUX=disabled@' /etc/selinux/config
#�ر�iptables
service iptables stop
chkconfig iptables off
#ssh���������Ż�,�뱣�ֻ��������ٴ���һ������sudoȨ�޵��û�����������û��ֹrootԶ�̵�¼
#sed -i 's@#PermitRootLogin yes@PermitRootLogin no@' /etc/ssh/sshd_config
#��ֹ�������¼
sed -i 's@#PermitEmptyPasswords no@PermitEmptyPasswords no@' /etc/ssh/sshd_config
#��ֹSSH�������
sed -i 's@#UseDNS yes@UseDNS no@' /etc/ssh/sshd_config /etc/ssh/sshd_config
service sshd restart
#����IPv6��ַ
echo "install ipv6 /bin/true" > /etc/modprobe.d/disable-ipv6.conf
#ÿ��ϵͳ��Ҫ����IPv6ģ��ʱ��ǿ��ִ��/bin/true������ʵ�ʼ��ص�ģ��
echo "IPV6INIT=no" >> /etc/sysconfig/network-scripts/ifcfg-eth0
#���û���IPv6���磬ʹ֮���ᱻ��������
chkconfig ip6tables off
#vim�����﷨�Ż�
cat >> /root/.vimrc << EOF
set number
set ruler
set nohlsearch
set shiftwidth=2
set tabstop=4
set expandtab
set cindent
set autoindent
set mouse=v
syntax on
EOF
#���򿪻����������񣬰�װ��С������Ļ�����ʼ����ֻ����crond|network|rsyslog|sshd��4������
for i in `chkconfig --list | grep 3:on | awk '{print $1}'`;
do
    chkconfig --level 3 $i off;
done
for CURSRV  in crond rsyslog sshd network;
do 
    chkconfig --level 3 $CURSRV on;
done
#����������
reboot
