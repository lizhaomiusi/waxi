crond命令 定时任务  
  
-e [UserName]: 执行文字编辑器来设定时程表，内定的文字编辑器是 vi 等价于 \# vi
/var/spool/cron/root  
-r [UserName]: 删除目前的时程表  
-l [UserName]: 列出目前的时程表 等价于 \# cat /var/spool/cron/root  
-v [UserName]:列出用户cron作业的状态  
  
crontab -l -u root \# 列出用户root的全部调度任务  
\# crontab -e配置是针对某个用户的。而编辑VI/etc/crontab是针对系统的任务  
  
/etc/crontab、/etc/cron.deny、/etc/cron.allow文件介绍  
系统调度的任务一般存放在/etc/crontab这个文件下，里面存放了一些系统运行的调度程序，  
vim /etc/crontab \# 默认的文件形式例如以下：  
SHELL=/bin/bash  
PATH=/sbin:/bin:/usr/sbin:/usr/bin  
MAILTO=root  
HOME=/  
  
\# For details see man 4 crontabs  
  
\# Example of job definition:  
\# .---------------- minute (0 - 59)  
\# \| .------------- hour (0 - 23)  
\# \| \| .---------- day of month (1 - 31)  
\# \| \| \| .------- month (1 - 12) OR jan,feb,mar,apr ...  
\# \| \| \| \| .---- day of week (0 - 6) (Sunday=0 or 7) OR
sun,mon,tue,wed,thu,fri,sat  
\# \| \| \| \| \|  
\# \* \* \* \* \* user-name command to be executed  
\# 分 时 日 月 周  
  
星号（\*）：表示任意时间都执行  
逗号（,）：能够用逗号隔开的值指定一个列表，比如"10,15,20",表示10分15分20执行  
中杠（-）：能够用整数之间的中杠表示一个列表范围，比如“2-6”表示“2,3,4,5,6”  
正斜线（/n）：能够用正斜线指定时间的间隔频率，比如“0-23/2”表示每两小时运行一次。同一时候正斜线能够和星号一起使用。比如\*/10，表示每十分钟运行一次。  
  
/etc/cron.deny 表示不能使用crontab 命令的用户  
/etc/cron.allow 表示能使用crontab的用户。  
如果两个文件同时存在，那么/etc/cron.allow 优先。  
如果两个文件都不存在，那么只有root用户可以安排作业。  
  
实例1  
  
5 \* \* \* \* ls \# 指定每小时的第5分钟  
\*/15 \* \* \* \* ls \# 每15分钟  
10,40 \* \* \* ls \# 每小时10分 40分 时ls  
30 5 \* \* \* ls \# 指定每天的5:30  
0 6 \* \* \* ls \# 每天6点  
0 \*/2 \* \* \* \# 每两小时  
0 23-7/2，8 \* \* \* \# 晚上11点到早上8点之间每两个小时和早上八点  
0 11 4 \* 1-3 \# 每个月的4号和每个礼拜的礼拜一到礼拜三的早上11点  
30 6 \* \* 0 ls \# 指定每星期日的6:30  
30 3 10,20 \* \* ls \# 每月10号及20号的3：30  
25 8-11 \* \* \* ls \# 每天8-11点的第25分钟  
30 6 \*/10 \* \* ls \# 每隔10天的第6:30  
  
\#
每天4：22以root身份运行/etc/cron.daily文件夹中的全部可运行文件，run-parts參数表示。运行后面文件夹中的全部可运行文件。  
22 4 \* \* \* root run-parts /etc/cron.daily  
  
必须指定在每一个小时的第几分钟运行。也就是说第一个\*号必须改成一个数值。  
由于\*号表示的就是每一分钟。  
另外小时位的/1和没有差别，都是每小时一次。  
假设是设置\*/2，实际上是能被2整除的小时数而不是从定时设置開始2小时后运行。比方9点设的到10点就会运行。  
  
PS:  
最后可能会遇到以下这个问题  
root用户下 输入 crontab -l 显示  
no crontab for root 比如：  
[root\@CentOS \~]\# crontab -l  
no crontab for root  
这个问题非常easy，相同在 root 用户下输入 crontab -e  
按 Esc 按： wq 回车  
在输入 crontab -l 就没有问题了  
主要原因是由于这个liunxserver第一次使用 crontab
，还没有生成对应的文件导致的，运行了 编辑（crontab -e）后 就生成了这个文件  
  
linux crontab 实现每秒执行  
方案一，简单粗暴，在crontab中直接利用sleep命令，间隔时间为10秒，直接跑  
\* \* \* \* \* /root/22.sh  
\* \* \* \* \* sleep 10; /root/22.sh  
\* \* \* \* \* sleep 20; /root/22.sh  
\* \* \* \* \* sleep 30; /root/22.sh  
\* \* \* \* \* sleep 40; /root/22.sh  
\* \* \* \* \* sleep 50; /root/22.sh

方案二，另写一个脚本，在crontba中，每分钟去跑一次，这个脚本中写一个循环，让它跑

\#!/bin/bash  
step=2 \#间隔的秒数，不能大于60  
  
for (( i = 0; i \< 60; i=(i+step) ))

do  
\$(命令绝对路径 '文件绝对路径')  
sleep \$step  
done  
exit 0  
crontab -e  
\* \* \* \* \* /bin/bash sh脚本绝对路径
