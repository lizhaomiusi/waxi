使用 mkpasswd 命令生成随机密码

首先需要安装 mkpasswd 包，它包含在 expect 包里，安装方式为：

yum install expect -y

安装完成之后，就可以使用 mkpasswd 命令来生成随机密码了。

mkpasswd 支持的主要参数如下（区分大小写）：

\-l 生成密码的长度，默认是 9 位，不同版本的默认长度可能是不一样的。

\-d 生成密码中包含数字的位数，默认是 2 位。

\-c 生成密码中包含小写字母的位数，默认是 2 位。

\-C 生成密码中包含大写字母的位数，默认是 2 位。

\-s 生成密码中包含特殊字符的位数，默认是 1 位。

更多相关参数说明可以参阅其 man 帮助。

\$ mkpasswd -l 20 -d 5 -c 5 -C 5 -s 2

9i'aR:iJSt03t5uU3Drl

使用 date 命令的 MD5SUM 值作为随机密码

可以通过 data 指令获取时间后，计算 md5 值，然后截取其中的一部分当做随机密码。

\$ date \| md5sum \| cut -b 10-20

464dddf2644

截取其中一部分

使用 openssl 生成强密码

可以使用 openssl 生成强密码。

\$ openssl rand -base64 8

vZfr+eeIxeE=

\# 生成 8 位随机密码
