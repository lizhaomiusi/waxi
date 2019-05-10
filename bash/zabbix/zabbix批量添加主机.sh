#!/bin/bash

#login
jsson=`curl -s -X POST -H 'Content-Type:application/json' -d ' {    "jsonrpc": "2.0",    "method": "user.login",    "params":{        "user": "Admin",        "password": "zabbix"    },    "id": 1}' http://10.1.21.20/zabbix/api_jsonrpc.php | python -mjson.tool |grep "result" |awk -F '"' '{print $4}'`
#create hosts
for ip in `cat ip.txt`
do
curl -s -X POST -H 'Content-Type:application/json' -d '
{
    "jsonrpc": "2.0",
    "method": "host.create",
    "params": {
        "host": '\"$ip\"',
        "interfaces": [
            {
                "type": 1,
                "main": 1,
                "useip": 1,
                "ip": '\"$ip\"',
                "dns": "",
                "port": "10050"
            }
        ],
        "groups": [
            {
                "groupid": "15"
            }
        ],
        "templates": [
            {
                "templateid": "10093"
            }
        ]
    },
    "auth": '\"$jsson\"',
    "id": 1
}' http://10.1.21.20/zabbix/api_jsonrpc.php | python -mjson.tool
done
