#!/bin/sh
[ $# -ne 2 ]&&{
 echo "$0 ip port"
 exit
}
export oldboy=key
export wwwServerIp=$1
export wwwServerPort=$2
cmd="nc $wwwServerIp $wwwServerPort"
printf "delete $oldboy\r\n" | $cmd >/dev/null 2>&1
sleep 1
printf "set $oldboy 0 0 6\r\noldboy\r\n"|$cmd >/dev/null 2>&1
if [ `printf "get $oldboy\r\n"|$cmd|grep oldboy|wc -l` -eq 1 ]
  then
      echo "mc is alive."
      exit 0
else
      echo "mc is dead."
      exit 2
fi

