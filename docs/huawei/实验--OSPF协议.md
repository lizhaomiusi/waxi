ospf协议

全网唯一  
router-ID：RID \# 推荐手动配置  
因为设备重启后会重新分配RID  
  
配置ospf RID  
[r1]router id 1.1.1.1 \# lo0：接口地址，全局配置  
[r1]ospf 1 router id 1.1.1.1 \# 对于OSPF进程下配置RID
