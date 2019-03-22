sed命令 \# 替换 处理行

https://www.cnblogs.com/ginvip/p/6376049.html  
https://www.cnblogs.com/DragonFire/p/6600121.html  
https://blog.oldboyedu.com/commands-sed/

语法：  
sed [参数] [动作] [file]  
选项与参数：  
-n 使用安静(silent)模式。如果加上 -n 参数后，则只有经过sed
特殊处理的那一行(或者动作)才会被列出来。  
-e 直接在命令列模式上进行 sed 的动作编辑；多重匹配  
-f 直接将 sed 的动作写在一个文件内， -f filename 则可以运行 filename 内的 sed
动作；  
-r sed
的动作支持的是延伸型正规表示法的语法。(默认是基础正规表示法语法)支持扩展正则表达式，如+、\|\\()等特殊符号  
-i 直接修改读取的文件内容，而不是输出到终端。  
-p print打印 '2p'第二行 '3p'第三行' 2,5p'2\~5行  
-d delete删除  
  
增删改查  
a \# 新增行，追加文本到指定行后  
i \# 插入行，插入文本到指定行前

示例 单行增加  
sed '2a 106,mysql,mysql' 111.txt  
sed '2i 106,mysql,mysql' 111.txt

多行增加  
cat 111.txt \|sed '2i 106,mysql,mysql\\n107,nginx,nginx'  
cat 111.txt \|sed '2i 106,mysql,mysql \\  
107,nginx,nginx'

\---

d \# 删除行，因为是删除，所以 d 后面通常不接任何参数，直接删除地址表示的行；  
sed '2,4d' shell.sh \# 删除2到4行  
sed '/sd/d' shell.sh \# 删除 正则 删除包含sd的行  
sed '/\^2/d' test.txt \# 删除以2开头的行  
sed '/wq\$/d' shell.sh \# 删除以wq结尾的行  
sed -n '1d' abc \# 什么内容也不显示, 因为经过sed处理的行, 是个删除操作,
所以不现实.  
sed '2,\$d' abc \# 删除abc中从第二行到最后一行所有的内容, 注意,
\$符号正则表达式中表示行末尾, 但是这里并没有说那行末尾, 就会指最后一行末尾,
\^开头, 如果没有指定哪行开头, 那么就是第一行开头  
sed '\$d' abc \# 只删除了最后一行, 因为并没有指定是那行末尾,
就认为是最后一行末尾  
sed '/test/d' abc \# 文件中所有带 test 的行, 全部删除  
cat 111.txt \|sed '1\~2d' \# 表示删1,3,5的行

\---

c \# 修改行，c 的后面可以接字串，这些字串可以取代n1,n2之间的行  
cat /etc/passwd -n \| sed '2,5c 1111111111111sssssssssssss'
\#2\~5行替换成了c后面的

\---

s \# 替换，可以直接进行替换的工作,通常这个 s 的动作可以搭配正规表示法，例如
1,20s\#old\#new\#g 一般是替换符合条件的字符串而不是整行  
sed软件替换模型(方框▇被替换成三角▲)  
sed -i 's/▇/▲/g' oldboy.log  
sed -i 's\#▇\#▲\#g' oldboy.log

\---

两边是引号，引号里面的两边分别为s和g，中间是三个一样的字符/或\#作为定界符。\#能在替换内容包含/有助于区别。定界符可以是任意符号如:或\|等，但当替换内容包含定界符时，需转义即:
\|。经过长期实践，建议大家使用\#作为定界符。  
定界符/或\#，第一个和第二个之间的就是被替换的内容，第二个和第三个之间的就是替换后的内容。  
s\#▇\#▲\#g，▇能用正则表达式，但▲不能用，必须是具体的。

\---

用///或\#\#\#（任意成对的符号都可以）这样的框架来引用需要替换的和替换后的内容，  
s/old/new/或s\#old\#new\# \# 把old一词替换为new，默认只替换每行第一个  
sed '1,2s/tom/TOM/g' /etc/passwd \# 把第一第二行的tom替换为TOM  
sed '5,\$s/aa/AA/g' test.txt \# 也可以是5\~文末所有行  
sed '/\^[0-9]/s/aa/AA/g' test.txt \# 匹配头是数字的行  
sed '/root/s/root/ROOT/g' /etc/passwd \# 匹配包含root的行，并把root替换ROOT  
sed '1s/aa/AA/g' test.txt \# 限定只对第一行进行替换  
sed s\#\$x\#\$y\#g test.txt \# 变量替换

\---

分组替换\\( \\)和\\1的使用说明  
sed软件的\\(
\\)的功能可以记住正则表达式的一部分，其中，\\1为第一个记住的模式即第一个小括号中的匹配内容，\\2第二记住的模式，即第二个小括号中的匹配内容，sed最多可以记住9个。  
  
[root\@oldboy \~]\# echo I am oldboy teacher. \|sed 's\#\^.\*am \\([a-z].\*\\)
tea.\*\$\#\\1\#g'  
oldboy  
[root\@oldboy \~]\# echo I am oldboy teacher. \|sed -r 's\#\^.\*am ([a-z].\*)
tea.\*\$\#\\1\#g'  
oldboy  
[root\@oldboy \~]\# echo I am oldboy teacher. \|sed -r 's\#I (.\*) (.\*)
teacher.\#\\1\\2\#g'  
amoldboy

\---

p \# 列印，亦即将某个选择的数据印出。通常 p 会与参数 sed -n 一起运行  
cat /etc/passwd -n \| sed -n '2,5p' \#-n取消默认输出 打印2-5行  
  
sed的正则中 \\(\\) 和 \\{m,n\\} 需要转义  
如 \\ \$ \* + ( )  
  
. 表示任意字符  
\* 表示零个或者多个  
\\+ 一次或多次　　  
\\? 零次或一次  
\\\| 表示或语法

\---

sed的定址与命令：  
定址决定了sed需要处理的范围，而命令决定了需要执行的动作，所以写sed语句的话可以按照“将x行到y行中带有z字符的内容做a操作”，比如从1-10行中删除root开头的行。通常把定址与命令用单引号引起来，如果需要正则匹配的话，要使用//来将正则内容囊括进去。

\---

q \# 退出, 匹配到某行退出, 提高效率  
r \# 匹配到的行读取某文件 例如: sed '1r qqq' abc , 注意,
写入的文本是写在了第1行的后边, 也就是第2行  
w \# file, 匹配到的行写入某文件 例如: sed -n '/m/w qqq' abc ,
从abc中读取带m的行写到qqq文件中, 注意, 这个写入带有覆盖性.

\---

\-r \#正则表达式  
echo 'qwe1234qwe'\|sed -r 's/[0-9]{3}//' \#删除包含数字的前3个  
-e \#多重匹配  
cat anaconda-ks.cfg \|sed -e 's/sd/sd111/g' -e 's/sd111/sd222/g'
\#和加管道替换类似

\---

q \# 退出命令  
由于sed工作模式是将文件的每一行都处理后再进行输出，那么当遇到处理巨大文件时就会耗费很多时间，这可能是不必要的，比如我们明确只需要处理该文件的前100行。这个时候就可以用上该选项了，示例：  
cat bigfile \| sed '1,100d;100q' \#处理到第100行后就退出

\---

sed的后项引用：  
括号内的部分可以在后面直接被引用，

第一个括号内的内容是\\1，依次类推，也可以使用&符号代表前面所匹配到的所有内容。后项引用可用于更换文本内容的位置或者批量添加注释等  
cat ces.txt \| sed -nr 's\#(.\*)(mysql)(.\*) \# \\1\\2\\3\#gp' \#取（）中内容
-r是开启扩展正则表达式  
ifconfig \| sed -n '2p' \|sed -nr 's\#.\*dr:(.\*) Bc.\*\#\\1\#gp'
\#也可以这样取IP  
ifconfig ens33 \| sed -n '2p'\| sed -nr 's\#.\*t (.\*) n.\*\#\\1\#gp' \#取IP地址

\# 在每行最后\|最前添加字符串

sed -r 's\#(.\*)\#\\1test\#g' /etc/passwd

sed -r 's\#(.\*)\#\\\#\\1\#g' /etc/passwd

\# 修改passwd里面/sbin/nologin为/bin/nologin

sed -r 's\#/s(bin/nologin)\#\\1\#g' /etc/passwd

\# 在文件中插入一个字符 使 quiet"变成 quiet xyz"

sed -r 's\#(quiet)\#\\1 xyz\#g' /etc/default/grub

sed -r '/GRUB_CMDLINE_LINUX/s\#(.\*)"\$\#\\1 xyz"\#g' /etc/default/grub

\---

\# &用法  
echo '123456789' \|sed -r 's\#[0-9]{3}\#[&]\#g' \#表示匹配到什么就替换什么  
[123][456][789]  
  
举例:  
sed '/test/a RRRRRRR' abc \# 将 RRRRRRR 追加到所有的带 test 行的下一行
也有可能通过行 \# sed '1,5c RRRRRRR' abc  
sed '1c hello world' test.txt \# 替换行 替换指定行的所有内容为c后面的字符串  
sed '/\^2/c hello world' test.txt \# 正则替换行 替换以2开头的行  
sed '/test/c RRR' abc \# 将 RRR 替换所有带 test 的行, 当然,
这里也可以是通过行来进行替换, 比如 sed '1,5c RRRRRRR' abc  
sed 's/\$/\#/g' \# 每行开头添加\# sed 's/\^/\#/g'也可以  
sed -r '3,5s/.\*/\#&/' ces.txt \# 把345行前面增加\#号  
sed -ir '1,10s/\^/\#/' ces.txt \# 批量增加注释的最简洁办法  
sed -r 's/(.)(.)(.\*)/\\1\\2\#\\3/' ces.txt \# 在每行第二个字母前加注释  
sed -ir 's\#(.\*)\#\\1\#g' ces.txt \# -ir -字符 ：()里面的内容可以用\\1表达出来  
cat file \| sed -nr '/=+/p' \# 打印出包含一个或多个=号的行  
cat ces.txt.bak \|sed -n 's/sha512/sha511/p' \#
由于sed默认会把所有行都输出，加上-n选项，就可以关闭输出信息，在匹配条件最后加p标签就可以只显示出我们修改过的内容，

cat dashazi \|grep 'qq'\|sed -n 's\#\^qq.\#\#gp' \# 查找到qq的想 把qq.替换为空
p是打印的意思  
sed -i.bak 's\#源内容\#目标内容\#g' ces.txt \# 为避免覆盖源文件
在-i的参数后加.bak，可以自动生成一个.bak的备份文件  
sed -e 's/tom/TOM/' -e 's/tom/jerry/' /etc/passwd \#
由于第一次匹配时把tom换成了TOM，第二次就不存在tom字段，所以不会再替换为jerry

sed 's/tom/TOM/;s/tom/jerry/' /etc/passwd \# 分号也可以代替-e选项

sed -n '5,10p' anaconda-ks.cfg \# 打印5\~10行  
sed -n '5,+5p' anaconda-ks.cfg \# 同上

sed -i 's\#old\#new\#g' ces.txt \# "\#"分隔符可以用/\@=代替 s查找需要替换的内容
g获得内存缓冲区的内容，并替代当前模板块中的文本，s\# \#
\#g需要搭配使用，表示对当前行全局匹配替换,若不加g 表示修改匹配的每行第一个  
sed -nr 's\#([\^:]+)(:.\*:)(/.\*\$)\#\\3\\2\\1\#gp' /etc/passwd \#
\\1匹配不以:开头的 \\2匹配:.\*： \\3匹配/结尾的

取消C语言注释行  
cat zhushu \|sed 's/\\/\\/.\*\$//g' \|sed 's\#\\/\\\*.\*\\\*\\/\#\#g' \|sed
'/\^\\/\\\*/,/\\\*\\//d' \|grep -v '\^\$' \|sed -r '/\^[ \\t]+\$/d'

\# 取消三种注释过滤 //注释 的行 过滤 /\*---\*/的行 过滤 包含换行的注释
过滤空行-v取反 过滤有空格和tab的行 -r 开启正则  
cat zhushu  
\#include\<stdio.h\>  
/\*  
made by dashazi  
\*/  
int main()  
// echo hello  
print("hello world\\n"); /\*-----------------------\*/  
  
---

cat ssd \|sed -r 's/[\^ ]+[[:space:]]//2' \# 把第二列替换掉 [\^
]+[[:space:]]匹配第二列  
cat ssd \|sed -r 's/[\^ ]+[[ ]+//2' \# 等于上面 好像也可以  
cat ssd \|sed -r 's/\^[ ]+//g' \# 删除每行开头的所有空格  
  
将大写都用（）起来  
cat ssd \|tr 'd' 'D' \|sed -r 's/([A-Z])/(\\1)/g'  
cat ssd \|tr 'd' 'D' \|sed -r 's/[A-Z]/(&)/g'  
cat ssd \|sed -r '/\^[\#]\|\^\$/d' \# 过滤\#开头和空行 \|是或者  
  
linux sed批量替换多个文件内容  
sed -i 's/lgside/main/g' \`grep -rl lgside /home/zn/work/project-template\`  
  
按字符串查询  
[root\@oldboy \~]\# sed -n '/CTO/p' person.txt  
102,zhangyao,CTO  
[root\@oldboy \~]\# sed -n '/CTO/,/CFO/p' person.txt  
102,zhangyao,CTO  
103,Alex,COO  
104,yy,CFO  
  
混合查询  
[root\@oldboy \~]\# sed -n '2,/CFO/p' person.txt  
102,zhangyao,CTO  
103,Alex,COO  
104,yy,CFO  
[root\@oldboy \~]\# sed -n '/feixue/,2p' person.txt  
105,feixue,CIO  
\#→特殊情况，前两行没有匹配到feixue，就向后匹配，如果匹配到feixue就打印此行。

在每行的头添加字符，比如"HEAD"，命令如下：

sed 's/\^/HEAD&/g' test.file

在每行的行尾添加字符，比如“TAIL”，命令如下：

sed 's/\$/&TAIL/g' test.file

说明
's/\$/&TAIL/g'中的字符g代表每行出现的字符全部替换，如果想在特定字符处添加，g就有用了，否则只会替换每行第一个，而不继续往后找了
