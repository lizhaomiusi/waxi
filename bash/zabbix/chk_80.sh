#!/bin/bash
# zabbix监控http服务
chk_80=$(netstat -ntlp |grep 80)
  if [ -z "$chk_80" ]
    then
      echo '0'
    else
      echo '1'
  fi