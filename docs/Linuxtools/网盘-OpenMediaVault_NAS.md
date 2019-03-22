使用OpenMediaVault构建您自己的NAS

http://www.openmediavault.org/ \# 官网  
https://www.openmediavault.cn/ \# 论坛  
http://omv-extras.org/debian/pool/main/o/ \# 插件  
http://www.songming.me/openmediavault-plugin-install.html \# 插件说明  
http://omv-extras.org/debian/pool/main/o/openmediavault-omvextrasorg/ \# 更新源  
https://github.com/openmediavault/openmediavault/ \# github  
  
OpenMediaVault是一个基于Debian的专用Linux发行版，用于构建网络连接存储（NAS）系统。它提供了一个易于使用的web-  
OpenMediaVault是一个基于Debian的专用Linux发行版，用于构建网络连接存储（NAS）系统。
它提供了一个易于使用的基于Web的界面，多语言支持，卷管理，监控和插件系统，以通过LDAP，Bittorrent和iSCSI功能进行扩展。
本教程介绍OpenMediaVault的安装和配置。  
  
本教程的先决条件  
• PC与32或64位英特尔处理器。  
• 最小 1GB RAM。  
• 2个硬盘（或2个硬盘分区）。
openmediavault需要单独的磁盘或分区用于操作系统安装和单独的磁盘或数据分区。  
  
1）下载OpenMediaVault  
第一步是从Sourceforge下载OpenMediaVailt ISO文件。  
https://sourceforge.net/projects/openmediavault/files/  
该软件存在32位和64位Intel / AMD处理器以及其他一些平台，如Raspberry
PI，Odroid和Cubox i。 我将选择64Bit处理器（amd64）的版本。
目前2.1版本的直接下载链接是：  
http://downloads.sourceforge.net/project/openmediavault/2.1/openmediavault_2.1_amd64.iso?r=&ts=1438327317&use_mirror=netcologne  
  
2）准备启动介质  
ISO映像可用于直接将OpenMediaVault安装到VMWare或Virtualbox等虚拟机中。
要在真实硬件上安装软件，您需要一个启动媒体，如CD / DVD或可引导的U盘。  
将下载的ISO文件刻录到CD或DVD上或将其装载到U盘上。  
  
2.1）在Linux上创建可启动的USB Stick  
以下命令可用于在Linux上的USB Stick上写入ISO文件  
sudo dd if=openmediavault_2.1_amd64.iso of=/dev/sdX bs=4096将/ dev /
sdX替换为USB驱动器的设备名称。
请注意，如果选择错误的驱动器作为目标，dd命令可能会导致严重的损坏。  
  
2.2）在Windows上创建可启动的USB Stick  
当您将OpenMediaVault下载到Windows桌面上时，您可以使用例如unetbootin来准备USB棒。  
http://unetbootin.github.io/  
  
3）OpenMediaVault安装  
将准备安装的引导介质插入PC或服务器时，应安装OpenMediaVault并启动或重新启动系统。
可能需要在BIOS中选择正确的引导介质设备。  
  
系统引导成功后，您将看到OpenMediaVault安装程序的以下屏幕。
选择“安装”选项，然后按enter键或等待直到安装开始自动。  
  
选择安装过程的语言。  
  
和你的位置。 该位置将用于在下一步骤之一中定义时区，并预先选择键盘布局。  
现在选择键盘布局。 在我的情况下，我将选择“德语”作为布局，然后按\<Enter\>。  
安装程序开始从安装介质加载一些额外的包。  
输入您的服务器的主机名。
在下一个屏幕中请求域名，因此这里的主机名是完全限定域名的第一部分。
当服务器具有fqdn“server1.example.com”时，主机名为“server1”。  
输入服务器的域名。  
输入root密码。 该密码用于shell登录，它不是OpenMediaVault Web界面的密码。
请求时，在下一个屏幕中再次输入密码来确认密码。  
选择服务器时区，然后按\<Enter\>。
时区对于日志文件中的日期/时间以及已保存文件的时间戳很重要。  
安装程序开始将系统文件复制到磁盘。  
配置apt包管理器加载软件包的位置。 选择靠近你的位置。  
然后选择镜像服务器。
如果没有列出的镜像来自您的Internet访问提供商，您可以选择第一个。  
当您使用http代理访问互联网时，请在此输入详细信息。 否则按\<Enter\>键。  
apt现在将下载包。  
安装完成。 按\<Enter\>重新启动服务器。  
出现Grub启动屏幕。 按\<Enter\>或等待直到它自动启动。  
  
4）登录详细信息  
Web界面  
• 用户：admin  
• 密码：openmediavault  
客户端（SSH，控制台）  
• 用户：root  
• 密码：\<您在安装期间设置的密码\>  
  
服务器已由DHCP配置。 在shell上以root用户身份登录并运行命令：  
ifconfig or ip addr  
获取当前的IP地址。 在我的情况下，IP地址是192.168.1.30。  
打开Web浏览器并输入http：//，后跟您的IP地址：http: //192.168.1.30/进入网页登录：  
  
5）OpenMediaVault中的第一步  
本章介绍了确保登录，启用FTP和SMB / CIFS共享以及如何启用SSH访问的步骤。  
  
5.1）更改Web管理员密码  
要更改Web管理员密码，请转到“常规设置”，然后切换到“Web管理员密码：  
  
输入新密码，然后按输入表单左上角的“保存”按钮。  
默认情况下禁用FTP，SMB和SSH等服务。 在下一步中，我将启用FTP和SMB（Microsoft
Windows Share）。  
  
5.1）启用FTP  
转到服务\> FTP并启用“启用”复选框。  
  
按左上角的“保存”按钮。  
  
并点击上方的黄色栏中的“应用” 的 形成。  
  
最后确认变更应该真正适用。  
  
5.2）启用SMB / CIFS  
现在去服务\> SMB / CIFS并启用这个服务，就像你用FTP一样。  
  
5.3）启用SSH  
与SSH服务相同的过程。 转到服务\> SSH并启用服务。  
  
5.4）创建文件系统作为数据存储卷  
OpenMediaVault需要单独的硬盘或分区来存储数据（存储卷）。
在我的情况下，我将使用第二个硬盘/ dev / sdb。
单击存储\>文件系统\>创建将第二个硬盘添加为存储卷。 tmy存储卷的名称是“数据”。  
  
存储设备的最终列表应如下所示。 选择列表中的“数据”卷，然后单击“安装”按钮安装卷。
共享文件夹卷列表中只显示装载卷作为选项。  
  
5.5）添加用户  
现在我们可以添加一个用户来访问你的文件共享。 点击“访问权限管理”\>“用户”\>添加：  
  
输入用户详细信息：用户名，电子邮件地址和密码。 然后确认更改。  
  
5.5）添加文件共享  
要将文件存储在NAS驱动器上，我们需要可由我们的用户访问的文件共享。
点击“访问权限管理”\>“共享文件夹”\>“添加”。  
我将在数据卷上添加一个名为“Documents”的文件夹，其中包含路径“Documents /”。  
  
下一步是授予用户“直到”的读/写权限。
单击列表中的“文档”共享，然后单击列表上方菜单中的“Priveliges”图标。
这将打开priveliges窗口，为用户启用“读/写”，然后按保存。  
  
最后添加分享到可以使用它们的服务。 要启用FTP的共享，请转到服务\>
FTP\>共享，单击“添加”，选择“文档”共享，然后按保存。 确认更改。  
  
对SMB / CIFS使用相同的步骤：转到服务\> SMB /
CIFS\>共享，单击“添加”，选择“文档”共享，然后按保存。 确认更改。  
  
现在，您有一个NAS设备，其中包含可以使用FTP和SMB /
CIFS协议的用户访问的文档文件夹。  
  
6）VMWare / Virtualbox Image  
本教程的结果设置可以随时准备使用OVF格式的虚拟机映像（与VMWare和Virtualbox兼容）for
howtoing订阅者。  
VM的登录详细信息如下：  
shell上的root密码： howtoing  
OpenMediaVault Web界面  
用户名：admin  
密码：howtoing  
不要忘记更改密码！  
  
7）链接  
OpenMediaVault http://www.openmediavault.org/
