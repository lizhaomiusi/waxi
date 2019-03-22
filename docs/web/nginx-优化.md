nginx-优化

nginx优化

nginx优化配置集中在nginx.conf文件的main和events段.

main段中worker配置,可以通过work_cpu_affinity选项,按任务类型:CPU密集型或者IO密集型,根据实际业务情况绑定每个worker进程运行在哪个CPU核心上,(前提是系统必须为多核心CPU),例如

\# 4核心CPU中,开启4个worker,每个worker分别对应cpu0/cpu1/cpu2/cpu.

worker_processes 4;

worker_cpu_affinity 0001 0010 0100 1000;

\#
4核心CPU中,也可以只开启2个worker,第一个worker对应cpu0/cpu2，第二个worker对应cpu1/cpu3.

worker_processes 2;

worker_cpu_affinity 0101 1010;

envents段中开启集中一次性接入连接请求和串行方式接入新连接

events {

worker_connections 1024; \# 每个worker最大连接数.

multi_accept on; \#
是否集中接入监听到的连接请求，默认为off，关闭时一次只接收一个连接.

accept_mutex on \# 默认为on，表示以串行方式接入新连接，off时,将通报给所有worker

其它的,例如HTTP段优化,sendfile、keepalive_timeout、gzip是nginx中必做.
