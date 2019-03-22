MySQL的增删改查  
http://www.cnblogs.com/heyangblog/p/7624591.html  
https://www.toutiao.com/i6622900644921475591/  
https://www.cnblogs.com/zhuyongzhe/p/7686105.html  
https://www.toutiao.com/i6609814266142786052/  
  
快速查看以下内容：

|                            |                                                                     |
|----------------------------|---------------------------------------------------------------------|
| 操作                       | 命令                                                                |
| 创建数据库                 | CREATE DATABASE 数据库名；                                          |
| 指定要操作的数据库         | USE 数据库名；                                                      |
| 创建数据表                 | CREATE TABLE 数据表名；                                             |
| 查看数据表                 | SHOW CREATE TABLE 数据表名；                                        |
| 使用DESCRIBE语句查看数据表 | DESCRIBE 数据表名；                                                 |
| 为数据表重命名             | ALTER TABLE 数据表名 RENAME 新表名；                                |
| 修改字段名                 | ALTER TABLE 数据表名 CHANGE 旧字段名 新字段名 新数据类型；          |
| 修改字段数据类型           | ALTER TABLE 数据表名 MODIFY 字段名 数据类型；                       |
| 添加字段                   | ALTER TABLE 数据表名 ADD 字段名 数据类型；                          |
| 删除字段                   | ALTER TABLE 表名 DROP 字段名；                                      |
| 修改字段的排列位置         | ALTER TABLE 数据表名 MODIFY 字段名1 数据类型 FIRST \| AFTER 字段名2 |
| 删除数据表                 | DROP TABLE 数据表名；                                               |

\# 刷新数据库  
flush privileges;  
  
\# 新建用户test1  
insert into mysql.user(Host,User,Password)
values("localhost","test1",password("test1"));  
CREATE USER \`test1\`\@\`10.1.2.12\`;  
SET PASSWORD FOR \`test1\`\@\`10.1.2.12\`=PASSWORD('test1');  
  
\# 创建一个数据库test1  
create database \`test1\` charset utf8;  
CREATE DATABASE \`test1\` CHARACTER SET utf8 COLLATE utf8_general_ci;  
  
\# 为用户授权  
\#授权格式：grant 权限 on 数据库.\* to 用户名\@登录主机 identified by "密码";  
  
\# 授权test用户拥有test1数据库的所有权限（某个数据库的所有权限）：  
grant all privileges on \`ceshi\`.\* to 'test1'\@'%' identified by 'passwd';  
  
\# 如果想指定部分权限给用户，  
grant select,update on \`ceshi\`.\* to 'test1'\@'%' identified by 'passwd';  
GRANT SELECT,UPDATE,DELETE,CREATE,DROP ON \`ceshi\`.\* TO \`test1\`\@\`%\`;

\# 修改用户权限  
REVOKE DELETE,DROP ON \`test\`.\* FROM \`ceshi1\`\@\`%\`;  
  
\# 授权test1用户拥有所有数据库的某些权限： 　  
grant select,delete,update,create,drop on \*.\* to test\@"%" identified by
"passwd";  
GRANT INSERT,SELECT,UPDATE,DELETE,CREATE,DROP ON \*.\* TO \`test1\`\@\`%\`;  
  
\# 创建ceshi表  
CREATE TABLE \`test\`.\`ceshi\` (  
\`Id\` int(11) NOT NULL AUTO_INCREMENT,  
\`name\` varchar(20) NULL DEFAULT NULL,  
\`age\` int(2) NULL DEFAULT NULL,  
PRIMARY KEY (\`Id\`)  
) DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;  
  
\# 新增表字段内容  
ALTER TABLE \`test\`.\`ceshi\`  
ADD COLUMN \`dizhi\` varchar(255) NULL DEFAULT NULL;  
SHOW CREATE TABLE \`test\`.\`ceshi\`;  
  
\# 插入数据表内容  
insert into \`ceshi\` values(null,'aa','男','1988-10-2','......');  
INSERT INTO \`ceshi\` (\`Id\`, \`name\`, \`age\`) VALUES ('2', '名字', '12');  
INSERT INTO \`test\`.\`ceshi\` SET \`Id\`=3,\`name\`='小明',\`age\`=18;  
  
\# 删除用户  
delete from user where user='test1' and host='10.1.2.12';  
DROP USER \`test1\`\@\`10.1.2.12\`;  
  
\# 删除数据库  
DROP DATABASE \`test1\`;

\# 清空数据库  
TRUNCATE TABLE \`test\`.\`ceshi\`;  
  
\# 删除表  
DROP TABLE \`test\`.\`ceshi\`;

\# 清空表数据  
turncate ceshi; \#删除整表数据，自增长id从头再来，快速，从磁盘直接删除，不可恢复  
delete from ceshi; \#删除整个表的数据，自增长继续

\# 删除表内容  
DELETE FROM \`test\`.\`ceshi\` WHERE \`Id\`=5;  
  
\# 修改指定用户名或密码或主机  
update mysql.user set password=password('newpasswd') where User="test1" and
Host="localhost";  
RENAME USER \`test2\`\@\`10.1.2.12\` TO \`test1\`\@\`%\`;  
SET PASSWORD FOR \`test1\`\@\`%\`=PASSWORD('test1');  
  
\# 修改数据库字符集  
ALTER DATABASE \`test\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;  
  
\# 修改表名  
RENAME TABLE \`test\`.\`ceshi1\` TO \`test\`.\`ceshi\`;  
alter table student rename to xs；  
  
\# 修改表字段内容  
ALTER TABLE \`test\`.\`ceshi\`  
CHANGE COLUMN \`dizhi\` \`dizhi\` varchar(255) NULL DEFAULT '';  
SHOW CREATE TABLE \`test\`.\`ceshi\`;  
  
\# 修改表内容  
UPDATE \`test\`.\`ceshi\` SET \`name\`='xiaohong',\`age\`=12 WHERE \`Id\`=4;  
  
\# 查询表  
use mysql;  
show tables ceshi;  
SELECT \* FROM \`test\`.\`ceshi\`;  
  
\# 查询新建表语句  
SHOW CREATE TABLE CESHI;  
SHOW CREATE TABLE \`test\`.\`ceshi\`;  
  
\# 查询数据库表内容  
SHOW COLUMNS FROM \`test1\`.\`ceshi\`;  
  
\# 备份数据库  
backup database '数据库名称' to disk='备份路径及名称'  
eg. backup database 'MyDB' to disk='C:MyDB.BAK'
