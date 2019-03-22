case命令  
case行尾必须为单词 in 每个模式必须以右括号 ） 结束  
双分号 ;; 表示命令序列结束  
case语句结构特点如下：  
匹配模式中可是使用方括号表示一个连续的范围，如[0-9]；使用竖杠符号“\|”表示或。  
最后的“\*）”表示默认模式，当使用前面的各种模式均无法匹配该变量时，将执行“\*）”后的命令序列。

\---

case 变量 in  
模式1)  
动作1  
;;  
模式2)  
动作2  
;;  
... ...  
模式N)  
动作N  
;;  
\*)  
动作  
;;  
esac

\---  
  
\#case语句实例：由用户从键盘输入一个字符，并判断该字符是否为字母、数字或者其他字符，
并输出相应的提示信息。  
\#!/bin/bash  
read -p "press some key ,then press return :" KEY  
case \$KEY in  
[a-z]\|[A-Z])  
echo "It's a letter."  
;;  
[0-9])  
echo "It's a digit."  
;;  
\*)  
echo "It's function keys、Spacebar or other ksys."  
esac

\---  
  
\#!/bin/bash  
SYS1=\`uname -s\`  
case \$SYS1 in  
Linux)  
echo "My system is Linux"  
echo "Do Linux stuff here..."  
;;  
FreeBSD)  
echo "My system is FreeBSD"  
echo "Do FreeBSD stuff here..."  
;;  
\*)  
echo "Unknown system : \$SYSTEM"  
echo "I don't what to do..."  
;;  
esac
