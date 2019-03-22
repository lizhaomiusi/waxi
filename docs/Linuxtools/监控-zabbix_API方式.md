zabbix API监控主机  
  
https://www.cnblogs.com/liang-wei/p/5848923.html  
  
api地址  
/usr/share/zabbix/api_jsonrpc.php  
  
文档地址  
https://www.zabbix.com/documentation/3.2/manual/api/reference/user/login

1、获取API接口ID 用python处理一下结果  
curl -s -X POST -H 'Content-Type:application/json' -d '  
{  
"jsonrpc": "2.0",  
"method": "user.login",  
"params": {  
"user": "Admin",  
"password": "zabbix"  
},  
"id": 1  
}' http://10.1.21.20/zabbix/api_jsonrpc.php \| python -mjson.tool  
执行返回结果  
{  
"id": 1,  
"jsonrpc": "2.0",  
"result": "d052baaec4ee5277066cb68913fffc81"  
}  
  
https://www.zabbix.com/documentation/3.2/manual/api/reference/host/create

2、创建监控主机 里面含有接口ID  
curl -s -X POST -H 'Content-Type:application/json' -d '  
{  
"jsonrpc": "2.0",  
"method": "host.create",  
"params": {  
"host": "10.1.21.100",  
"interfaces": [  
{  
"type": 1,  
"main": 1,  
"useip": 1,  
"ip": "10.1.21.100",  
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
"auth": "d052baaec4ee5277066cb68913fffc81",  
"id": 1  
}' http://10.1.21.20/zabbix/api_jsonrpc.php \| python -mjson.tool  
  
https://www.zabbix.com/documentation/3.2/manual/api/reference/user/get

3、查询监控主机  
curl -s -X POST -H 'Content-Type:application/json' -d '  
{  
"jsonrpc": "2.0",  
"method": "host.get",  
"params": {  
"output": ["host"]  
},  
"auth": "d052baaec4ee5277066cb68913fffc81",  
"id": 2  
}' http://10.1.21.20/zabbix/api_jsonrpc.php \| python -mjson.tool  
  
4、使用监控脚本实现  
创建地址  
echo 10.1.21.{100..200} \|xargs -n1 \>ip.txt  
[root\@zabbix \~]\# ls  
ip.txt zzzzz.sh  
  
\#!/bin/bash  
\#批量添加主机  
\#login  
jsson=\`curl -s -X POST -H 'Content-Type:application/json' -d ' { "jsonrpc":
"2.0", "method": "user.login", "params":{ "user": "Admin", "password": "zabbix"
}, "id": 1}' http://10.1.21.20/zabbix/api_jsonrpc.php \| python -mjson.tool
\|grep "result" \|awk -F '"' '{print \$4}'\`  
\#create hosts  
for ip in \`cat ip.txt\`  
do  
curl -s -X POST -H 'Content-Type:application/json' -d '  
{  
"jsonrpc": "2.0",  
"method": "host.create",  
"params": {  
"host": '\\"\$ip\\"',  
"interfaces": [  
{  
"type": 1,  
"main": 1,  
"useip": 1,  
"ip": '\\"\$ip\\"',  
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
"auth": '\\"\$jsson\\"',  
"id": 1  
}' http://10.1.21.20/zabbix/api_jsonrpc.php \| python -mjson.tool  
done

\# 批量添加主机 模板需提前自定义
