利用Shell脚本检测WebURL状态

\#!/bin/bash

RETVAL=0

SCRIPTS_PATH="/root/shell/test/"

MAIL_GROUP="shikun.zhou\@bdqn.cn zhongkai.sun\@bdqn.cn"

LOG_FILE="/var/log/web_check.log"

FALSECOUNT=0

function GetUrlStatus(){

for ((i=1;i\<=3;i++))

do

wget -T 2 --tries=1 --spider http://\${1} \> /dev/null 2\>&1

\#!/bin/bash

\#author shikun.zhou

RETVAL=0

SCRIPTS_PATH="/root/shell/test/"

MAIL_GROUP="shikun.zhou\@bdqn.cn zhongkai.sun\@bdqn.cn"

LOG_FILE="/var/log/web_check.log"

FALSECOUNT=0

function GetUrlStatus(){

for ((i=1;i\<=3;i++))

do

wget -T 2 --tries=1 --spider http://\${1} \> /dev/null 2\>&1

[ \$? -ne 0 ] && let FALSECOUNT+=1;

done

if [ \$FALSECOUNT -gt 1 ];then

RETVAL=1

NowTime=\`date +%m-%d-%H:%M:%S\`

SC="http://\${URL} service is error,\${NowTime}."

for MAIL_USER in \$MAIL_GROUP

do

echo "send to :\${MAIL_USER},Title:\$SC" \> \$LOG_FILE

mail -s "\$SC" \$MAIL_USER \< \$LOG_FILE

done

else

RETVAL=0

fi

return \$RETVAL

}

\#function end.

[ ! -d "\$SCRIPTS_PATH" ] && mkdir -p \$SCRIPTS_PATH

[ ! -d "\$SCRIPTS_PATH/domain.list" ] && {

cat \> \$SCRIPTS_PATH/domain.list\<\<EOF

www.baidu.com

www.aliyun.com

EOF

}

for URL in \`cat \$SCRIPTS_PATH/domain.list\`

do

echo -n "checking \$URL: "

GetUrlStatus \$URL && echo ok \|\| echo no

done
