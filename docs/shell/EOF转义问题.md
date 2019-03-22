当使用cat\<\<EOF不想对内容进行变量替换、命令替换、参数展开时，  
有两种方法，推荐第二种，  
  
一、对 \$\`\\ 进行转义  
cat \>\> a.sh \<\< EOF  
echo \\\`hostname\\\`  
echo \\\$HOME  
EOF  
  
二、在分界符EOF前添加反斜杠\\，或者用单引号、双引号括起来：两种用法效果相同  
cat \>\> a.sh \<\< \\EOF  
echo \`hostname\`  
echo \$HOME  
EOF  
  
cat \>\> a.sh \<\< "EOF"  
echo \`hostname\`  
echo \$HOME  
EOF  
  
cat \>\> a.sh \<\< 'EOF'  
echo \`hostname\`  
echo \$HOME  
EOF
