#!/bin/bash

cd /data/wslogs
log_dir="/data/wslogs"
time=`date +%Y%m%d`
nginx_dir="/usr/local/webserver/nginx"

#日志分割，按天分类
website=`ls $log_dir/access* | xargs -n 1 | cut -f 2 -d "."`
for i in $website
do
  mkdir -p $log_dir/backup/$time/$i
  mv $log_dir/access.$i.log $log_dir/backup/$time/$i/$time.log
done
$nginx_dir/sbin/nginx -s reload

#删除所有超过7天日志。
if [ "`date +%a`" = "Sun" ]; then
  all_list=`ls $log_dir/backup | xargs -n 1`
  for del in $all_list
  do
    let results=$time-$del
    if [ $results -gt 7 ]; then
      rm -fr $log_dir/backup/$del
    fi
  done
fi
