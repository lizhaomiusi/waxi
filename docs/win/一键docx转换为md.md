一键将docx转换为md

这表明 pandoc 已经可以正常使用了。例如，下面的命令，即可将文档从 md 格式转换成
html 格式。

pandoc -i /d/ProgramFiles/pandoc/机器学习基础.md -o
/d/ProgramFiles/pandoc/machine_learning_base.html

\-i，指定文件输入路径

\-o，指定文件输出路径

将 Markdown 格式转换为 Html。下面这条命令将 input.md 转为html并且输出为
output.html

pandoc -o output.html input.md

Pandoc 会自动根据文件扩展名判断文件格式，也可指定输入和输出文件格式

pandoc -f markdown -t html -o output.html input.md

除了文件，还可以转换一个网页

pandoc -f html -t markdown -o index.md http://miu.im

指定 css 样式，用到 -c 选项

pandoc -c style.css -o output.html input.md

生成独立的文件 (Standalone 模式)

pandoc -s -o output.html input.md

生成目录，--toc 可以自动提取 h1 - h6 并生成目录，使用--toc-depth
控制输出的目录级别，默认值是3，就是说会自动提取h1 - h3 作为输出文件的目录。

pandoc -c style.css -o output.html --toc --toc-depth=3 input.md

将 html 转换为 markdown

pandoc -f html -t markdown -o file.md file.html

\-f html： 指定我们要从什么文件（from）转换

\-t markdown： 指定我们要转为 markdown 格式（to）

\-o file.md： 表示输出（output）的文件名为 file.md

file.html： 表示要转换的文件为 file.html

直接将markdown转换为word

pandoc -f markdown -t docx ./test.md -o test.docx

pandoc -f docx -t markdown ./test.docx -o test.md

rm -rf ./\*.doc

for i in \`ls \|awk -F '[.][d][o]' '{print \$1}'\`;

do

pandoc -f docx -t markdown ./\$i.docx -o \$i.md;

echo "\* [\$i](\$i.md)" \>\> SUMMARY.md

done

rm -rf ./\*.docx

jieshao=\`pwd \|awk -F / '{print \$4}'\`

sed -i '1i\\\* [Introduction](README.md)' SUMMARY.md

sed -i '1i\\\# Summary\\n' SUMMARY.md

echo -e '\# Introduction\\n' \>\> README.md

echo \$jieshao \>\> README.md

for i in \`ls \|awk -F '[.][m]' '{print \$1}'\`

do

echo "\* [\$i](\$i.md)" \>\> SUMMARY.md

done
