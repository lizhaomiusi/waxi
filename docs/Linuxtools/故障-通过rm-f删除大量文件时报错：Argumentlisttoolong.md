故障-通过 rm -f 删除大量文件时报错：Argument list too long

问题现象

Linux下通过 rm -f 删除大量的小文件时出现类似如下错误信息：

\-bash: /bin/rm: Argument list too long

问题原因

如果待删除文件中包含的小文件数量过多，通常是由于受到 shell 参数个数限制所致。

这个是Linux系统存在的限制，可以通过如下指令查看该参数值的配置：

getconf ARG_MAX

解决办法

注：

删除操作为高风险命令，请一定谨慎使用。确认通过快照等方式对数据进行了有效备份，或者明确可以删除。

如果待处理的文件数目过多，因为处理时间较长，推荐在业务低峰期进行操作，对磁盘的IO消耗较高。

对于 cp、mv 等都可以采取相同的方式实现处理。

请务必核实 dir 定义的目录中除了待删除文件外无其他类型的文件，避免误删除。

可以通过如下方式尝试删除：

结合 awk 删除

可使用 awk 一次删除一个的方式进行删除。但必须先进入该目录下。操作方法如下:

1、先进入该目标目录：

cd /var/spool/postfix/maildrop/

2、使用 awk 删除：

ls -l\| awk '{ print "rm -f ",\$9}'\|sh

3、再次使用命令 ls -l 查看,发现文件已经删除完成了

结合 xargs 删除

通过 ls 来配合 xargs 删除 test 目录下的所有文件：

ls \|xargs rm -r

结合 find 删除

通过 find 来完成，更加安全智能，支持的参数更多。

可以先使用 ls
命令列出需要删除的文件看是否正确，然后再执行删除命令。例如，通过如下指令，删除
test 目录下的 png 文件：

find /usr/local/tests/ -name "\*.png" \|xargs rm -r

在执行rm命令时提示Argument list too long，如下：

过自定义脚本删除

可以通过以下脚本通过循环实现删除，如下：

\#!/bin/bash

\# 此处通过 DIR 指定待处理文件所在的目录

DIR='/root/mysql' \#待删除目录

cd \$DIR

for I in \`ls\`

do

\#读取ls结果中的各个文件名进行强制删除

rm -f \$I

done
