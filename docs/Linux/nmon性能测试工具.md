下载nmon。  
  
根据CPU的类型选择下载相应的版本：  
http://nmon.sourceforge.net/pmwiki.php?n=Site.Download  
wget http://liquidtelecom.dl.sourceforge.net/project/nmon/nmon16e_x86_rhel65  
  
二.初始化nmon工具。  
  
根据不同的平台，初始化对应平台的nmon工具：  
chmod +x nmon_x86_ubuntu810  
mv nmon_x86_ubuntu810 /usr/local/bin/nmon  
  
对于 Debian 还要做以下操作（不做也同样能运行）：  
apt-get install lsb-release  
lsb_release -d \| sed 's/Description:\\t//' \> /etc/debian_release  
  
然后直接运行 nmon
即可，直接运行nmon可以实时监控系统资源的使用情况，执行下面的步骤可以展现一段时间系统资源消耗的报告。  
下面是直接执行nmon命令实时监控系统资源消耗情况的截图：  
  
CPU、内存、磁盘和网络的消耗情况都被很直观的展现出来。  
三.生成nmon报告。  
  
1).采集数据：  
\#nmon -s2 -c120 -f -m /home/oracle  
参数解释：  
-s10 每 10 秒采集一次数据。  
-c60 采集 60 次，即为采集十分钟的数据。  
-f 生成的数据文件名中包含文件创建的时间。  
-m 生成的数据文件的存放目录。  
这样就会生成一个 nmon 文件，并每十秒更新一次，直到十分钟后。  
生成的文件名如： \_090824_1306.nmon ，"" 是这台主机的主机名。  
nmon -h查看更多帮助信息。  
  
2).生成报表：  
下载 nmon analyser (生成性能报告的免费工具)：  
https://www.ibm.com/developerworks/community/wikis/home?lang=en\#!/wiki/Power%20Systems/page/nmon_analyser  
  
将之前生成的 nmon 数据文件传到 Windows 机器上，用 Excel 打开分析工具 nmon
analyser v33C.xls 。点击 Excel 文件中的 "Analyze nmon data" 按钮，选择 nmon
数据文件，这样就会生成一个分析后的结果文件： hostname_090824_1306.nmon.xls ，用
Excel 打开生成的文件就可以看到结果了。  
如果宏不能运行，需要做以下操作：  
工具 -\> 宏 -\> 安全性 -\> 中，然后再打开文件并允许运行宏。  
  
下面是在测试环境中生成的NMON报告截图：  
  
红色区域为不同指标的分析报告。  
  
3).自动按天采集数据：  
在 crontab 中增加一条记录：  
0 0 \* \* \* root nmon -s300 -c288 -f -m /home/ \> /dev/null 2\>&1  
300\*288=86400 秒，正好是一天的数据。  
  
参考文章：

nmon 性能：分析 AIX 和 Linux 性能的免费工具：  
http://www.ibm.com/developerworks/cn/aix/library/analyze_aix/index.html

nmon analyser -- 生成 AIX 性能报告的免费工具：  
http://www.ibm.com/developerworks/cn/aix/library/nmon_analyser/index.html
