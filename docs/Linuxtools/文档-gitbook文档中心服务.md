搭建gitbook文档中心服务（Linux环境）

https://nodejs.org/en/download/  
https://www.cnblogs.com/baby123/p/6955396.html \# 淘宝镜像  
https://www.jianshu.com/p/ec1e7d2c76c6  
http://www.chengweiyang.cn/gitbook/basic-usage/README.html  
https://www.cnblogs.com/adolfmc/p/9007171.html  
http://blog.51cto.com/xiaoxiaozhou/1904147 \# GitBook Editor 软件使用
配合直接生成静态页面  
  
搭建gitbook文档中心服务（Linux环境）  
搭建过程  
搭建基本环境  
安装Git  
安装Node.js和NPM  
安装Gitbook工具  
配置Gitbook与Jenkins自动部署  
搭建基本环境  
  
安装Git  
安装Node.js和NPM  
  
相关的包在官网下载速度慢，可在国内的镜像网站下载，如淘宝NPM镜像  
  
\# 下载安装，安装包位置随意  
wget https://npm.taobao.org/mirrors/node/v7.2.1/node-v7.2.1-linux-x64.tar.gz  
\# wget https://nodejs.org/dist/v10.9.0/node-v10.9.0-linux-x64.tar.xz

tar -zxvf node-v7.2.1-linux-x64.tar.gz  
cd node-v7.2.1-linux-x64  
\# 命令设置全局，因为安装node自带npm，所以不需要安装  
ln -s /root/node-v7.2.1-linux-x64/bin/node /usr/local/bin/node  
ln -s /root/node-v7.2.1-linux-x64/bin/npm /usr/local/bin/npm  
\# 查看安装版本  
node -v  
\# 查看npm版本  
npm -v  
除了以上安装方式，还可以使用编译好的安装包或yum安装，不过yum安装的版本比较低，可参考：Linux下Nodejs安装（完整详细）  
  
安装Gitbook工具  
  
\# 利用npm安装gitbook  
npm install gitbook-cli -g  
ln -s /root/node-v7.2.1-linux-x64/bin/gitbook /usr/local/bin/gitbook

\# 安装后查看版本  
gitbook -V  
以上的安装方式由于墙的原因，安装非常慢，所以推荐使用国内镜像方式安装，[淘宝NPM镜像][1]  
  
\# 安装淘宝定制的cnpm来替代npm  
npm install -g cnpm --registry=https://registry.npm.taobao.org  
ln -s /root/node-v7.2.1-linux-x64/bin/cnpm /usr/local/bin/cnpm

\# 安装gitbook和以上方式一样，只需把npm修改为cnpm  
cnpm install gitbook-cli -g  
ln -s /root/node-v7.2.1-linux-x64/bin/gitbook /usr/local/bin/gitbook

\#
安装后查看版本，第一次查看时会进行初始化处理，需要等一段时间（挺久点，去干点其他事情吧）  
gitbook -V  
安装完成后，可使用gitbook搭建一个demo-web站点  
  
cd /root/gitbook  
mkdir demo  
cd demo

\# 初始化之后会看到两个文件，README.md ，SUMMARY.md  
gitbook init

\# 生成静态站点，当前目录会生成_book目录，即web静态站点  
gitbook build ./  
gitbook serve ./

\# 启动web站点，默认浏览地址：http://localhost:4000  
gitbook使用

3.1 生成目录和图书结构

gitbook只提供了如下四个命令

gitbook -h

Usage: gitbook [options] [command]

Commands:

build [options] [source_dir] 编译指定目录，输出Web格式(_book文件夹中)

serve [options] [source_dir]
监听文件变化并编译指定目录，同时会创建一个服务器用于预览Web

pdf [options] [source_dir] 编译指定目录，输出PDF

epub [options] [source_dir] 编译指定目录，输出epub

mobi [options] [source_dir] 编译指定目录，输出mobi

init [source_dir] 通过SUMMARY.md生成作品目录

源文件目录一般是这样的.

mkdir book  
cd ./book  
gitbook init \# 生成结构  
warn: no summary file in this book  
info: create README.md  
info: create SUMMARY.md  
info: initialization is finished

编辑SUMMARY.md，输入：  
\* [简介](README.md)  
\* [1.Docker入门](doc1/README.md)  
- [1.1 什么是Docker](doc1/doc1.md)  
- [1.2 Docker基本概念](doc1/doc2.md)  
\* [2.使用Docker部署web应用](doc2/README.md)  
- [2.1 编写DockerFile](doc2/doc1.md)  
- [2.2 编写web应用](doc2/doc2.md)  
\* [结束](end/README1.md)  
再次执行：  
  
gitbook init \#生成目录  
info: create doc1/README.md  
info: create doc1/doc1.md  
info: create doc1/doc2.md  
info: create doc2/README.md  
info: create doc2/doc1.md  
info: create doc2/doc2.md  
info: create end/README.md  
info: create SUMMARY.md  
info: initialization is finished

3.2 生成图书  
使用：  
gitbook serve ./ \# 预览 http://ip:4000 访问

gitbook build ./ \# 生成静态文件可移植部署github
