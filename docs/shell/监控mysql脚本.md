\#监控mysql脚本  
\#判断四个选项来看mysql是否开启  
status=\`/etc/init.d/mysqld status \|grep running \|wc -l\`  
jincheng=\`ps -ef \|grep mysql \|grep -v grep \|wc -l\`  
port=\`lsof -i:3306 \|grep -i listen \|wc -l\`  
mysql -uroot -p'123123' -e "show databses;" \>/dev/null 2\>&1  
a=\$?  
  
\#echo \$a \$status \$jincheng \$port  
  
[ \$a -eq 0 ] && \\  
[ \$port -ne 0 ] && \\  
[ \$jincheng -ne 0 ] && \\  
[ \$status -ne 0 ] && \\  
echo "mysql is running" \|\| echo "mysql is not running"
