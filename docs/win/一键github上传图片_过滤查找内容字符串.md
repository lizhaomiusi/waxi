\#!/bin/bash

\#github一键上传图片 替换图片字符串 并提交

\#

cp -r /d/phpStudy/WWW/waxi/Public/Uploads /d/git/waxi

old1=http://127.0.0.1/waxi/server/../Public

new2=https://raw.githubusercontent.com/waxi-i/waxi/master

grep -rl "\$old1" /d/git/waxi

sleep 5

sed -i "s\#\$old1\#\$new2\#g" \`grep -rl "\$old1" /d/git/waxi\`

sleep 2

cd /d/git/waxi

shij=\`date +%Y%m%d\`

git add -A

git commit -m "update\$shij"

git push

echo "OK\~!"

\---

old='.wmf'

new='.bmp'

grep -r "\$old" ./

sed -i "s\#\$old\#\$new\#g" \`grep -rl "\$old" ./\`

git config --global user.email "waxi\@qq.com"

git config --global user.name "waxi"
