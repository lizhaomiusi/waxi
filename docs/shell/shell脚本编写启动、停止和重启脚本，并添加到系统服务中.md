shell脚本编写启动、停止和重启脚本，并添加到系统服务中  
脚本中必须添加这两行，如果不添加会提示“service nginx does not support chkconfig”  
\# chkconfig: - 85 15  
\# description: nginx is a World Wide Web server. It is used to serve  
然后把脚本放到/etc/init.d/下，执行chkconfig --add
nginx添加到服务中，然后设置启动级别chkconfig --level 35 nginx on。  
列出nginx系统服务chkconfig --list nginx

nginx 0:off 1:0ff 2:0ff 3:on 4:off 5:on 6:off  
  
以下为脚本信息：  
  
\#!/bin/bash  
\# chkconfig: - 85 15  
\# description: nginx is a World Wide Web server. It is used to serve  
program=/usr/local/nginx/sbin/nginx  
pid=/usr/local/nginx/logs/nginx.pid  
  
start(){  
if [ -f \$pid ];then  
echo "nginx running"  
else  
\$program  
fi  
}  
  
stop(){  
if [ ! -f \$pid ];then  
echo "nginx stop"  
else  
\$program -s stop  
echo "nginx stop"  
fi  
}  
  
reload(){  
\$program -s reload  
echo "nginx reloading complete"  
}  
  
status(){  
if [ -f \$pid ];then  
echo "nginx running"  
else  
echo "nginx stop"  
fi  
}  
case \$1 in  
start)  
start;;  
stop)  
stop;;  
reload)  
reload;;  
status)  
status;;  
\*)  
echo "your input error"  
esac
