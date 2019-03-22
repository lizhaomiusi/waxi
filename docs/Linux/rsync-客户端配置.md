  
rsync客户端配置

参数说明  
-a：--archive
等于参数：-rtplgoD，归档模式，表示以递归方式传输文件，并保持所有文件属性，  
-v： --verbose 详细模式输出  
-r： --recursive 对子目录以递归模式处理。  
-t： --times 保持文件时间信息

\-p： --perms 保持文件权限。  
-l： --links 保留软链接。  
-g： --group 保持文件属组信息

\-o： --owner 保持文件属主信息。  
-D： --devices 保持设备文件信息

\-z： --compress 对备份的文件在传输的过程中进行压缩处理

\-H： 保留硬链结

\-S： 对稀疏文件进行特殊处理以节省DST的空间  
-e： --rsh=command 指定使用 rsh、 ssh 方式进行数据同步  
-P: 显示进度  
--exclude=PATTERN 指定排除不需要传输的文件模式。  
--exclude-from=FILE 排除 FILE 中指定模式的文件。  
--bwlimit=KBPS 限制 I/O 带宽， KBytes per second。  
--password-file=/etc/rsync.pwd \# 指定密码文件

rsync六种不同的工作模式

拷贝本地文件，将/home/coremail目录下的文件拷贝到/cmbak目录下。

rsync -avSH /home/coremail/ /cmbak/

拷贝本地机器的内容到远程机器。

rsync -av /home/coremail/ 192.168.11.12:/home/coremail/

远程复制文件类似scp

rsync -av 192.168.11.11:/home/coremail/ /home/coremail/

拷贝远程rsync服务器(daemon形式运行rsync)的文件到本地机。当DST路径信息包含”::”分隔符时启动该模式。

rsync -av root\@172.16.78.192::www /databack

显示远程机的文件列表。这类似于rsync传输，不过只要在命令中省略掉本地机信息即可。

rsync -v rsync://192.168.11.11/data

通过ssh通道  
rsync -avzP -e "ssh -p1234" /root/tmp/ root\@10.1.2.13:/root/vm1/

\# 另外一种指定密码文件方式，临时，重启失效  
export RSYNC_PASSWORD=rsync2

rsync配置本地密码文件实现无交互同步，永久生效  
echo "rsync2" \>\>/etc/rsyncd.pass  
chmod 600 /etc/rsyncd.pass  
无密码同步先配置客户端的密码文件  
rsync -avzP --password-file=/etc/rsync.pwd rsync1\@10.1.2.12::ftp /root/123.txt

几种同步方式  
累加同步 \# 源目录新建更新复制到目的目录，不管目标发生的变化  
rsync -avzP --password-file=/etc/rsync.pwd rsync1\@10.1.2.12::ftp/vm1/
/root/vm1/  
  
镜像同步 \# 删除不存在于源目录的目的地文件 去除目标发生的变化 -delete
选项，表示服务器上的数据要与客户端完全一致，如果
/tmp/david/目录中有服务器上不存在的文件，则删除。  
rsync -avzP --delete --password-file=/etc/rsync.pwd rsync1\@10.1.2.12::ftp/vm1/
/root/vm1/  
  
同步时不在目的地创建新文件
,有时我们只想对目的地已经有的文件进行同步，而不理会源目录新增的文件，此时可以使用
--existing 选项：  
rsync -avzP --existing rsync1\@10.1.2.12::ftp/vm1/ /root/vm1/  
  
rsync完成源目录到目的地的拷贝，若能查看到源目录与目的地间的差异，这对同步十分有帮助，-i
选项可以显示源目录与目的地间的差异  
rsync -avzi rsync1\@10.1.2.12::ftp/vm1/ /root/vm1/  
  
限制传输文件的大小  
使用 --max-size 选项，我们可以限制传输文件的最大大小：  
rsync -avzP --max-size='100K' --password-file=/etc/rsync.pwd
rsync1\@10.1.2.12::ftp/vm1/ /root/vm1/  
  
全拷贝 \# 默认情况下 rsync
采用增量拷贝，这样能节省带宽，在所同步文件不大的情况下，我们可以通过 -W
选项实现全拷贝：  
rsync -avzW --password-file=/etc/rsync.pwd rsync1\@10.1.2.12::ftp/vm1/
/root/vm1/

只对比需要同步的文件，而不进行实质性的同步，只需要对 rsync
命令添加额外的参数就可以了：

rsync -avzn -P 源地址 目标地址

rsync -avz -P --list-only 源地址 目标地址

额外的参数可以是 -n 也可以是 --list-only，效果相同，只是后者显示的信息更加详尽。
