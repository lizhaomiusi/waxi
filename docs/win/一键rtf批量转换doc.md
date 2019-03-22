Windows下rtf 批量转换doc，Windows 下写个批处理。

\@echo off

echo 开始更改文件名……

set extension=.doc

set/a sum=0

for %%m in (\*) do (

if /i not "%%\~nxm"=="%\~nx0" (

if /i not "%%\~xm"=="%extension%" (

ren "%%m" "%%\~nm%extension%"

set /a sum=sum+1

)

)

)

echo 文件改名完毕，一共有%sum%个文件被改名！

set sum=

set extension
