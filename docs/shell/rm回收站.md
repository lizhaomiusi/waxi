\# rm 回收站  
\#!/bin/bash  
mkdir -p \~/.trash  
cat \>\> .bashrc \<\< \\EOF  
  
alias zrm='trash'  
alias zlsrm='ls \~/.trash'  
alias zunrm='untrash'  
  
trash() {  
mv \$\@ \~/.trash/  
}  
untrash() {  
mv -i \~/.trash/\$\@ ./  
}  
EOF  
source \~/.bashrc  
echo "功能完成"
