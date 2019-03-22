win 注册服务

cmd命令

创建  
sc create ServiceName binpath= F:\\start.exe type= own start= auto displayname=
显示的Name  
删除

sc delete ServiceName  


![](media/8c5e951ec766f38465d248ab2860070e.wmf)

  
  
  
\#注册表位置  
HKEY_LOCAL_MACHINE SYSTEM CurrentControlSet Services  
HKEY_LOCAL_MACHINE SYSTEM ControlSet001 Services  
HKEY_LOCAL_MACHINE SYSTEM ControlSet002 Services
