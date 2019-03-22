ESXi 强制4G内存解决（VMware ESXi 6.0.0.update02 ）

https://www.cnblogs.com/otherside/p/5605497.html

手上有个性能不太好的机器，想着装一个系统有点浪费，但是4G内存实际识别只有3.7G，到达不了EXSi的最低4G限制，无法安装。最终找到一个解决方法，  
经过验证适用于ESXi 6.0。  
源自于：ESXi 5.x 版本提示内存不够的解决方法（5.5强制4G以上内存）

http://blog.163.com/bingo246\@yeah/blog/static/9436881320151544433727/

放入光盘或U盘，开始安装，一直普通流程到Welcome画面，按ALT+F1

登陆界面账号：root 密码为空  
cd /usr/lib/vmware/weasel/util  
rm upgrade_precheck .pyc  
mv upgrade_precheck .py upgrade_precheck .py.old  
cp upgrade_precheck .py.old upgrade_precheck .py \# 如果直接把这个文件备份.old  
chmod 666 upgrade_precheck .py \# 增加权限后在原文件修改提示权限不允许

vi upgrade_precheck .py  
查找 MEM_MIN  
MEM_MIN_SIZE= (4\*1024) 修改为 MEM_MIN_SIZE= (2\*1024)  
wq! 强制保存退出  
ps -c \|grep weasel \#不结束进程，直接适用ALT+F2貌似无效  
kill -9 进程ID  
此时正常情况下会跳回欢迎界面，如不跳回按ALT+F2返回继续安装
