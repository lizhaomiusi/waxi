实战shell打印99乘法表  
shell打印99乘法表  
\#!/bin/bash  
for i in \`seq 9\`  
do  
for j in \`seq 9\`  
do  
[ \$j -le \$i ] && echo -n "\$j\*\$i=\`echo \$((\$j\*\$i))\` "  
done  
echo ""  
done

第二种  
\#!/bin/bash  
for i in \`seq 9\`  
do  
for j in \`seq \$i\`  
do  
echo -n "\$i\*\$j=\$[i\*j] "  
done  
echo ""  
done
