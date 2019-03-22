故障-通过 MD5 验证传输文件内容一致性

MD5 算法常常被用来验证网络文件传输的完整性，如果源文件的 md5 值与目的端文件的
md5 值相同，说明传输的文件是完整的，如果不同，需要重新传输。

可以通过执行 md5sum \<文件名\> 查看文件的 md5 信息，比如： md5sum typescript

也可以将 md5

md5sum typescript \> typescript.md5

信息写入文件，比如：

md5sum 重要参数

\-b 以二进制模式读入文件内容

\-t 以文本模式读入文件内容

\-c 根据已生成的md5值，对现存文件进行校验

以 -c 为例，执行 md5sum -c typescript.md5 进行验证，通过会出现 OK 的提示：

如果验证失败，则会出现类似如下信息：

typescript: FAILED

md5sum: WARNING: 1 of 1 computed checksum did NOT match
