grep命令 \# 检索 用于查找结果再次过滤 将符合模式的文本“行”显示出来  
语法：  
grep [参数] [动作] [文件名]  
\*核心过滤字符串过滤行，把想要的不想要的分开，  
参数 作用  
-c 计算找到 '搜寻字符串'(即 pattern) 的次数  
-i 忽略大小写  
-o 只显示匹配的内容  
-h 查询多文件时不显示文件名。  
-l 查询多文件时只输出包含匹配字符的文件名。  
-n 显示匹配行及行号。  
-v 反向选择--对匹配的结果取反  
-s 不显示不存在或无匹配文本的错误信息。  
-b 将可执行文件(binary)当作文本文件（text）来搜索  
-w 模式匹配整个单词  
  
-r 递归搜索  
-E 使用扩展正则表达式进行匹配， grep -E 或取代 egrep 命令。  
-F 使用固定字符串进行匹配， grep -F 或取代传统的fgrep命令。  
-B 除显示匹配的一行外，并显示该行之前的N行  
-A 除显示匹配的一行外，并显示该行之后的N行  
-C 除显示匹配的一行外，并该行该行之前后各N行  
  
egrep \# 启用正则表达  
egrep -v "\^\$\|\^\#" /etc/nginx/nginx.conf \# -v 反向选择 \^\$ 以空开头
\^\#以\#开头  
------------------------------  
  
grep(关键字: 截取) 文本搜集工具, 结合正则表达式非常强大  
主要参数 []  
-c : 只输出匹配的行  
-I : 不区分大小写  
-h : 查询多文件时不显示文件名  
-l : 查询多文件时, 只输出包含匹配字符的文件名  
-n : 显示匹配的行号及行  
-v : 显示不包含匹配文本的所有行(我经常用除去grep本身)  
基本工作方式: grep 要匹配的内容 文件名, 例如:  
grep 'test' d\* 显示所有以d开头的文件中包含test的行  
grep 'test' aa bb cc 显示在 aa bb cc 文件中包含test的行  
grep '[a-z]\\{5}\\' aa 显示所有包含字符串至少有5个连续小写字母的串  
------------------------------  
  
筛选a.txt里面的oldboy \# grep "oldboy" a.txt  
筛选a.txt里面的oldboy之外的内容 -v表示排除 \# grep -v "oldboy" a.txt  
\# grep "string" -B 10 a.txt -- -A除了显示匹配的一行之外，并显示该行之后的N行  
-B除了显示匹配的一行之外，并显示该行之前的N行  
-C除了显示匹配的一行之外，并显示该行之前后各N行  
------------------------------  
  
例如  
cat /etc/httpd/conf/httpd.conf \| grep "\#" \# 过滤出\#号的文件显示出来  
cat /etc/httpd/conf/httpd.conf \| grep -v "\#" \# 过滤不包含\#的行  
cat /etc/httpd/conf/httpd.conf \| grep -o "\#" \# 只显示\#号  
grep str /tmp/test \# 在文件 '/tmp/test' 中查找 "str"  
grep \^str /tmp/test \# 在文件 '/tmp/test' 中查找以 "str" 开始的行  
grep 'com\$' dashazi \# 以com结尾  
grep str -r /tmp/\* \# 在目录 '/tmp' 及其子目录中查找 "str"  
grep '\^\$' dashazi \# 表示过滤空行的意思 加 -c 表示有多少空行  
grep -v '\^\$' dashazi \# -v 取反 表示除了空行 其他的显示出来  
grep [0-9] /tmp/test \# 查找 '/tmp/test' 文件中所有包含数字的行  
cat dashazi \|grep '\^[Dd]' \# 过滤开头是Dd的行  
cat dashazi \|grep '[0-9]' \# 过滤0\~9的行  
cat dashazi \|grep '[\^Dd]' \# 非的意思 类似-v 过滤不包含D和d的字符  
cat dashazi \|grep '\^[\^Dd]' \# 类似-v 过滤不包含头是D和d的行  
cat dashazi \|grep 'q.' \# 匹配q和q后面任意一个字符的行  
cat dashazi \|grep '.q' \# 匹配q和q前面任意一个字符的行  
cat dashazi \|grep '\^....\$' \# 匹配有七个字符的行  
cat dashazi \|grep 'ass[\^w]' \# 匹配匹配ass和后一位不带w的行  
cat dashazi \|grep '\^email.\*com\$' \# 匹配包含开头和结尾的行  
cat dashazi \|grep -E 'ass?d' \# 匹配包含0和1个的行  
cat dashazi \|grep -E 'ass+d' \# 匹配包含1个和多个的行  
cat dashazi \|grep -E 'qq\|email' \# 匹配包含qq或email的行  
cat dashazi \|grep -E '\\.\|\\\$' \# 匹配包含.和\$的行  
cat dashazi \|grep -E '[ ]\|\$' \# 匹配空格和空行  
cat dashazi \|grep -E 'b{1}' \# 匹配只有一个b的行如果是{2}则是匹配bb的行  
cat /etc/passwd \| grep -E '\\\<[0-9]\\\>\|\\\<[0-9][0-9]\\\>'
\#匹配包含1个和2个的数字  
cat anaconda-ks.cfg \|egrep '\^[ ]+' \#匹配至少一个和多个空格开头的行  
cat anaconda-ks.cfg \|egrep '\^\#[ ]+[\^ ]+' \#匹配以 \#空格非空格 开头的行  
cat /etc/passwd \| egrep '\^root\|\^bin' \| awk -F ':' '{print \$1"\\t"\$7}' \#  
grep -5 'parttern' inputfile 打印匹配行的前后5行  
grep -C 5 'parttern' inputfile 打印匹配行的前后5行  
grep -A 5 'parttern' inputfile 打印匹配行的后5行  
grep -B 5 'parttern' inputfile 打印匹配行的前5行  
------------------------------  
  
查找当前目录下所有文件中包含的某个特定字符。  
grep -rn "\<p\>\<strong\>Index\</strong\>\</p\>" ./\*  
  
匹配任意字符  
如果抽取以K开头，以D结尾的所有代码，可使用下述方法  
已知代码长度为5个字符：  
grep 'K...D' data.f  
  
  
日期查询  
一个常用的查询模式是日期查询。  
先查询所有以5开始以1996或1998结尾的所有记录。使用模式5..199[6,8]。  
\#第一个字符为5，后跟两个点，接着是199，剩余两个数字是6或8  
grep '5..199[6,8]' data.f  
  
范围组合  
必须学会使用[ ]抽取信息。假定要取得城市代码，  
\#第一个字符为0-9，第二个字符在0到5之间，第三个字符在0到6之间  
grep '[0-9][0-5][0-6]' data.f  
\#取以[0-9]开头的行  
grep '\^[0-9][0-5][0-6]' data.f  
  
模式出现机率  
\#抽取包含数字4至少重复出现两次的所有行  
grep '4\\{2,\\}' data.f  
抽取记录使之包含数字999（三个9）  
grep '9\\{3,\\}' data.f  
如果要查询重复出现次数一定的所有行，数字9重复出现两次或三次  
grep '9\\{3\\}' data.f  
grep '9\\{2\\}' data.f  
匹配数字8重复出现2到6次，并以3结尾  
grep '8\\{2,6\\}3' myfile  
  
使用grep匹配“与”或者“或”模式  
要抽取城市代码为219或216  
grep -E '219\|216' data.f  
  
空行  
结合使用\^和\$可查询空行。使用-c参数显示总行数  
grep -c '\^\$' myfile  
-n参数显示实际在哪一行  
grep -n '\^\$' myfile  
  
查询格式化文件名  
使用正则表达式可匹配任意文件名。系统中对文本文件有其标准的命名格式。一般最多六个小写字符，后跟句点，接着是两个大写字符。  
grep '\^[a-z]\\{1,6\\}\\.[A-Z]\\{1,2\\}' filename
