linux - 利用vnstat进行流量统计

在Linux下，经常需要统计及分析流量，这时候就需要用到vnstat。  
centos上面需要安装epel-release，就可以使用yum安装了  
  
yum -y install epel-release  
yum -y install vnstat  
源码编译安装  
wget -c http://humdi.net/vnstat/vnstat-1.18.tar.gz  
tar zxvf vnstat-1.18  
cd vnstat-1.18  
./configure  
make && make install  
这样vnstat 就安装好了，接下来要设置vnstat(如果是yum或apt-get
安装的vnstat不需要下面的设置)。  
cp examples/init.d/centos/vnstat /etc/init.d/  
chmod +x /etc/init.d/vnstat  
chkconfig --add vnstat  
chkconfig vnstat on  
  
启动vnstat daemon：  
/etc/init.d/vnstat start  
  
编译安装vnstat的设置完成。  
使用  
vnstat --help  
vnStat 1.18 by Teemu Toivola \<tst at iki dot fi\>  
-q, --query query database \#查看数据库里面所有数据  
-h, --hours show hours \#查看最近24小时的流量情况  
-d, --days show days \#按天进行统计  
-m, --months show months \#按月进行统计  
-w, --weeks show weeks \#按周进行统计  
-t, --top10 show top 10 days \#查看top10天的流量  
-s, --short use short output  
-u, --update update database \#更新数据库  
-i, --iface select interface (default: eth0) \#指定网口  
-?, --help short help  
-v, --version show version  
-tr, --traffic calculate traffic  
-ru, --rateunit swap configured rate unit  
-l, --live show transfer rate in real time  
See also "--longhelp" for complete options list and "man vnstat".  
  
vnstate加上面几个参数就可以查到对应时间的流量及平均网速了。
