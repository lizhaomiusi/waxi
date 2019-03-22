\#格式化输出带颜色变量  
\#!/bin/bash  
  
ip=192.168.16.1  
netmask=255.255.255.0  
green() \#定义函数 \$1传给函数后面第一个参数  
{  
echo -e "\\033[34m\$1\\033[0m"  
}  
red()  
{  
echo -e "\\033[31m\$1\\033[0m"  
}  
cat \<\< EOF \> /root/file \#输出到文件  
IP : \`green \$ip\` \#传参数 \$ip是函数后面第一个参数  
NETMASK : \`red \$netmask\`  
EOF
