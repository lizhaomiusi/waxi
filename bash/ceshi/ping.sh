#!/bin/bash
Auto_Connect()
{
/usr/bin/expect << EOF
set timeout 5
spawn ssh root@172.18.186.$IP_NUM hostname
expect {
 yes/no { send "yes
";exp_continue }
 password { send "redhat
" }
}
expect eof
EOF
}
for IP_NUM in {160..227}
do
 ping -c1 -w1 172.18.186.$IP_NUM &> /dev/null && {
 Host_Name=`Auto_Connect | grep -E "authenticity|fingerprint|connecting|password|spawn|Warning" -v`
 }
 echo "$Host_Name 172.18.186.$IP_NUM " | sed 's/
//g' //将全文的/r换为空。
done
# 当执行脚本host_ping.sh时，ping各个主机IP ，ping通，显示该IP的 hostname以及IP ，不能 ping 通，报错并显示 IP。