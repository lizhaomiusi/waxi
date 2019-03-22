systemct管理服务命令

systemctl管理服务的启动，重启，停止，重载，查看状态的命令

Systcinit命令(红帽RHEL6系统) Systemctl命令(红帽RHEL7系统) 作用

service foo start systemctl start foo.service 启动服务

service foo restart systemctl restart foo.service 重启服务

service foo stop systemctl stop foo.service 停止服务

service foo reload systemctl reload foo.service 重新加载配置文件(不终止服务)

service foo status systemctl status foo.service 查看服务状态

systemctl设置服务的开机启动，不启动，查看各级别下服务启动状态的命令

Sysvinit命令(红帽RHEL6系统) Systemctl命令(红帽RHEL7系统) 作用

chkconfig foo on systemctk enable foo.service 开机自动启动

chkconfig foo off systemctl disable foo.service 开机不自动启动

chkconfig foo systemctl is-enabled foo.service 查看特定服务是否为开机自启动

chkconfig --list systemctl list-unit-files --type=service
查看各个级别下服务的启动与禁用情况
