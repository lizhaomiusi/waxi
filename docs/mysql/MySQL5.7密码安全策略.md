MySQL5.7密码安全策略

环境介绍：CentOS 6.7  
  
MySQL版本：5.7.11  
1、查看现有的密码策略  
SHOW VARIABLES LIKE 'validate_password%';  
  
参数解释：  
1).validate_password_dictionary_file 指定密码验证的文件路径;  
2).validate_password_length 密码最小长度  
3).validate_password_mixed_case_count
密码至少要包含的小写字母个数和大写字母个数;  
4).validate_password_number_count 密码至少要包含的数字个数  
5).validate_password_policy
密码强度检查等级，对应等级为：0/LOW、1/MEDIUM、2/STRONG,默认为1  
注意：  
0/LOW：只检查长度;  
1/MEDIUM：检查长度、数字、大小写、特殊字符;  
2/STRONG：检查长度、数字、大小写、特殊字符字典文件。  
6).validate_password_special_char_count密码至少要包含的特殊字符数  
  
2、创建用户时报错：  
mysql\> create user 'miner'\@'192.168.%' IDENTIFIED BY 'miner123';  
ERROR 1819 (HY000): Your password does not satisfy the current policy
requirements  
报错原因：密码强度不够。  
解决方法：(该账号为测试账号，所以采用降低密码策略强度)  
mysql\> set global validate_password_policy=0;  
Query OK, 0 rows affected (0.00 sec)  
mysql\> set global validate_password_length=4;  
Query OK, 0 rows affected (0.00 sec)  
mysql\> SHOW VARIABLES LIKE 'validate_password%';  
+--------------------------------------+-------+  
\| Variable_name \| Value \|  
+--------------------------------------+-------+  
\| validate_password_dictionary_file \| \|  
\| validate_password_length \| 4 \|  
\| validate_password_mixed_case_count \| 1 \|  
\| validate_password_number_count \| 1 \|  
\| validate_password_policy \| LOW \|  
\| validate_password_special_char_count \| 1 \|  
+--------------------------------------+-------+  
6 rows in set (0.00 sec)  
  
再次创建用户，成功
