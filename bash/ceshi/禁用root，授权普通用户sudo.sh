һ��ͨ��ű�
#!/bin/bash
# һ�������û������룬��Ȩsudo���ܣ�����rootԶ�̵�¼
user1=ansible
pass1=ansible#
id $user1 >/dev/null 2>&1 || useradd $user1
# �ж��û�ID�Ƿ����
echo "$pass1" |passwd $user1 --stdin
echo "$user1    ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
# �ֶ�ִ���﷨���
visudo -c
# ��֤�ú����rootԶ�̵�¼
# ������д��ʱ��Ϊ�������֣���������i��aǰ���һ������һ����б�� ������ͱ���ˣ�
sed -i '/^#PermitRootLogin/a\PermitRootLogin no' /etc/ssh/sshd_config
# systemctl restart sshd
