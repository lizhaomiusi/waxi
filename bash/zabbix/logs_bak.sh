#!/bin/bash
# 文件备份，检查，校验
# hostIP,bakdir
bak_ip=$(ip addr |grep 'global eth0' |awk -F '[ /]+' '{print $3}')
bak_dir=/data/backup/"$bak_ip"
[ ! -d $bak_dir ] && mkdir -p "$bak_dir"
#
# 需要备份dir
bak_logs=/home/nginx2
bak_messages=/var/log/messages
#
# tar to backupdir
tar -zcf "$bak_dir"/$(date +%F)_logs.tar.gz "$bak_logs" && \
tar -zcf "$bak_dir"/$(date +%F)_messages.tar.gz "$bak_messages" && \
#
# 上面执行完并添加MD5值
find "$bak_dir" -type f -name "$(date +%F)*.tar.gz" |xargs md5sum > "$bak_dir"/flag_$(date +%F)
#
# 删除30天前的备份
# find "$bak_dir" -type f -mtime +30 -exec rm -f {} \;
#
# 推送到或者拉取备份文件
rsync -avz "$bak_dir" root@10.1.2.71:/data/backup/
#
#!/bin/bash
# 备份服务器上验证md5值，否则报警
# find "$bak_dir" -type f -name "flag_$(date +%F)" |xargs md5sum -c "$bak_dir"/flag_$(date +%F)
# if [ $? -eq 0 ] ;then
#    echo "备份成功"
# else
#    echo "备份失败，请check，可加入报警"
# fi
