#!/bin/sh
file="$1"
remotedir="$2"
. /etc/init.d/functions

if [ $# -ne 2 ]
  then
   echo "USAGE:/bin/sh $0 arg1 arg2"
   exit 1
fi

for n  in 8 9 10 11
do      
	scp -P52113 -rp $file oldgirl@10.0.0.$n:~ >/dev/null 2>&1 &&\
        ssh -p52113 -t oldgirl@10.0.0.$n sudo /bin/cp ~/$file $remotedir &>/dev/null
        if [ $? -eq 0  ]
         then
            action "scp $file to  $remotedir is ok" /bin/true
        else
            action "scp $file to  $remotedir is fail" /bin/false
        fi
done
