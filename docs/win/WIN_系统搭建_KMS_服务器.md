Vlmcsd:KMS 服务器 for Windows（WIN 系统搭建 KMS 服务器）  
  
KMS 这里就不再多做解释了，可以自行了解。在之前的文章《Linux 下自建 KMS 服务器 -
激活 windows》中讲过使用 linux 系统搭建。本文主要因为有同学来问到能不能用
windows 服务器来搭建 KMS，答案当然是可以的。方法和之前的几乎没有什么太大区别。

一、Vlmcsd 下载  
  
Vlmcsd 项目地址：https://github.com/Wind4/vlmcsd/  
下载地址：https://github.com/Wind4/vlmcsd/releases/download/svn1111/binaries.tar.gz  
也可以参考之前的文章《Linux 下自建 KMS 服务器 - 激活 windows》的下载地址  
Vlmcsd 安装  
  
解压 binaries.tar.gz 文件，找到 \\binaries\\Windows\\intel 下的
vlmcsd-Windows-x86.exe 或者 vlmcsd-Windows-x64.exe （根据你的系统自行选择 x86
x64）  
  
直接点击运行即可。so，就是这么简单。那是因为这是已经编译好的。作者也是有提供源码的，动手能力强的同学也可以自行编译。  
ps：同样，windows 下，防火墙也需要放行程序和 1688 端口。  
  
之前一直不知道怎么去完美的激活windows系统，直到知道了这个，网上的激活软件真的我靠激活后可能会有一大堆垃圾软件在后台下载，算了不说了windows就是这个德行，远离windows保平安。话不多说，我们搭建一个windows激活服务来激活虚拟机中的windows7
所以首先要有一台windows7虚拟机，记住该服务允许激活批量授权的windows系统包括批量授权的office，具体的你测试，终于可以在给别人装完系统不漫天百度找激活工具了  
  
软件地址  
https://github.com/Wind4/vlmcsd  
  
部署  
首先下载  
wget https://github.com/Wind4/vlmcsd/releases/download/svn1111/binaries.tar.gz  
解压  
tar -zxvf binaries.tar.gz  
之后进入这个文件夹  
cd binaries/Linux/intel/static/  
反正就是选择对应的系统平台啦  
之后运行下面这个文件  
./vlmcsd-x64-musl-static  
  
之后测试一下是不是搭建成功  
首先把下载来的压缩包放到windows下  
使用管理员权限打开cmd  
之后进入目录  
cd \\binaries\\Windows\\intel  
执行  
C:\\binaries\\Windows\\intel\>vlmcs-Windows-x64.exe -v -l 3 192.168.1.100  
  
表示搭建成功  
  
激活windows  
使用管理员权限打开cmd  
在要激活的windows中输入  
cd /d "%SystemRoot%\\system32"  
之后  
设置秘钥管理服务器  
slmgr /skms 192.168.1.100  
激活  
slmgr /ato  
查看激活时间  
slmgr /xpr  
  
激活office  
使用管理员权限打开cmd  
进入office安装目录  
64位office  
cd /d "%ProgramFiles%\\Microsoft Office\\Office15"  
32位office  
cd /d "%ProgramFiles(x86)%\\Microsoft Office\\Office15"  
输入下面命令  
cscript ospp.vbs /sethst:192.168.1.100  
cscript ospp.vbs /act  
cscript ospp.vbs /dstatus  
  
注意  
激活的有效期只有180天  
只对vl批量激活的windows和office有效  
上面所有命令都是使用管理员权限打开的cmd
