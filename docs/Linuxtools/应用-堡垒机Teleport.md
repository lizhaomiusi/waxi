堡垒机Teleport在Linux平台的安装设置

https://tp4a.com/ 官网  
  
下载teleport的Linux版本安装包  
https://tp4a.com/download  
http://teleport.eomsoft.net/download/get-file/teleport-server-linux-x64-3.0.1.6.tar.gz  
https://docs.tp4a.com/install/

将下载得到的安装包放到临时目录中，然后执行下列命令：  
tar -zxvf teleport-linux-x64-3.0.1.6.tar.gz  
cd teleport-linux-x64-3.0.1.6.tar.gz  
sudo ./setup.sh

仅需几秒钟，安装就已完成，并且teleport服务也成功启动运行了：  
Welcome to install Teleport Server!  
NOTICE: There are a few steps need you enter information or make choice,  
if you want to use the DEFAULT choice, just press \`Enter\` key.  
Otherwise you need enter the highlight character to make choice.  
Prepare installation...  
- check local installation ... [not exists]  
Set installation path [/usr/local/teleport]: \# 直接回车  
完成  
start services...  
starting teleport core server ... [done]  
starting teleport web ... [done]  
check services status...  
teleport core server is running.  
teleport web server is running.  
--==[ ALL DONE ]==--

现在，您的堡垒机已经准备就绪，可以访问了。

安装完成后的必要设置

请访问 http://您的堡垒机IP地址:7190 进行配置管理。默认管理员账号
admin，默认管理员密码 admin。

安装完成后，请以管理员身份登录，首次安装的系统会进行数据库的创建和初始化操作，完成之后刷新页面即可进入teleport主界面。

Teleport服务的启动与停止  
启动teleport服务：  
sudo /etc/init.d/teleport start  
停止teleport服务：  
sudo /etc/init.d/teleport stop  
重新启动teleport服务：  
sudo /etc/init.d/teleport restart  
查看Teleport服务的运行状况：  
sudo /etc/init.d/teleport status

github地址https://github.com/eomsoft/teleport

Teleport部署好之后，需要由管理员在系统中添加远程主机、运维人员账号，并进行授权，然后运维人员可以登录运维前端页面，进行远程主机连接。
