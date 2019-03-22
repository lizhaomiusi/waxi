read命令

用于从标准输入中读取输入单行，并将读取的单行根据IFS变量分裂成多个字段，并将分割后的字段分别赋值给指定的变量列表var_name。第一个字段分配给第一个变量var_name1，第二个字段分配给第二个变量var_name2，依次到结束。如果指定的变量名少于字段数量，则多出的字段数量也同样分配给最后一个var_name，如果指定的变量命令多于字段数量，则多出的变量赋值为空。  
如果没有指定任何var_name，则分割后的所有字段都存储在特定变量REPLY中  
  
常用参数  
-p：给出提示符。默认不支持"\\n"换行  
-s：静默模式。输入的内容不会回显在屏幕上  
-t：给出超时时间，在达到超时时间时，read退出并返回错误  
-n：限制读取N个字符就自动结束读取，如果没有读满N个字符就按下回车或遇到换行符，则也会结束读取  
-N：严格要求读满N个字符才自动结束读取，即使中途按下了回车或遇到了换行符也不结束。其中换行符或回车算一个字符  
-a：将分裂后的字段依次存储到指定的数组中，存储的起始位置从数组的index=0开始  
回到顶部  
---  
  
-p 简短示例  
\#!/bin/bash  
read -p "print a number: " num  
if [ \$num -eq 5 ]; then  
echo "input right" && echo \$num  
else  
echo "input error"  
fi  
exit  
---  
  
如果没有指定变量，read会把传入的值传给\$REPLY,只要调用\$REPLY就可以引用  
\#!/bin/bash  
read -p "print a number: "  
if [ \$REPLY -eq 5 ]; then  
echo "input right" && echo \$REPLY  
else  
echo "input error"  
fi  
exit  
---  
  
-t：给出超时时间，在达到超时时间时，read退出并返回错误  
\#!/bin/bash  
\#\#  
if read -t 5 -p "input a number: " num  
then  
echo "\$num inputed"  
else  
echo "timeout"  
fi  
exit  
---  
  
-a：将分裂后的字段依次存储到指定的数组中，存储的起始位置从数组的index=0开始  
[root\@localhost testsh]\#read -a value  
1 2 3 4  
[root\@localhost testsh]\#echo \${value[0]}  
1  
[root\@localhost testsh]\#echo \${value[1]}  
2  
[root\@localhost testsh]\#echo \${value[2]}  
3  
[root\@localhost testsh]\#echo \${value[3]}  
4  
  
read读取文件内容  
\#!/bin/bash  
\#\#  
\#read file ip.txt  
cat /mnt/ip.txt \| while read IP  
do  
echo "the ip : \$IP"  
done  
echo "finsh"  
exit  
执行读取ip.txt内容结果  
the ip : 192.168.11.10  
the ip : 192.168.11.11  
the ip : 192.168.11.12  
the ip : 192.168.11.13  
the ip : 192.168.11.14  
the ip : 192.168.11.15  
the ip : 192.168.11.16  
the ip : 192.168.11.17  
the ip : 192.168.11.18  
the ip : 192.168.11.19  
finsh  
或者使用for循环读取  
for IP in \`cat /mnt/ip.txt\`  
do  
echo \$IP  
done  
---  
  
read指令还可以将接收的值作为case语句判断的条件值，使用如下  
\#!/bin/bash  
read -t 30 -p "Do you want exit script[Y/N]?" char  
case "\$char" in  
"Y" \| "y")  
echo "bye"  
;;  
"N" \| "n")  
echo "stay"  
;;  
\*)  
echo "output error,please input N,n/Y.y"  
;;  
esac  
[root\@localhost testsh]\#./bak.sh  
Do you want exit script[Y/N]?n  
stay
