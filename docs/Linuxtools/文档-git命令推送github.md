github使用

https://www.cnblogs.com/sysu-blackbear/p/3463475.html  
  
git 常用命令  
git clone  
git remote  
git fetch  
git pull \# 拉  
git push \# 推

git add -u \# 提交被修改(modified)和被删除(deleted)文件，不包括新文件(new)

git add . \# 提交新文件(new)和被修改(modified)文件，不包括被删除(deleted)文件

git add -A \# 提交所有变化

git config --global user.name "muyoi"  
git config --global user.email "441505423\@qq.com"  
git remote add origin https://github.com/muyoi/muyo.git

\# 如果你想克隆  
git clone https://github.com/waxi1/waxi.github.io.git  
cd waxi.github.io  
git init \# 变成可管理仓库  
\#git add README.dm \#单个上传  
git status \# 查看  
git add -A \# 提交所有变化  
git commit -m “备注乱填2016-10-16 10:49:29” \# 添加描述信息  
git push origin master \# 提交到分支  
  
git remote 列出已经存在的远程分支  
git remote get-url origin Git远程获取URL的起源

设置用户:  
-\> git config --global user.name "shimilygood"
设置用户，方便以后不用每次上传数据都要输入用户名  
-\> git config --global user.email "1356300819\@qq.com" 邮箱  
-\> cd \~/.ssh 设置ssh  
-\> ssh-keygen -t rsa -C "441505423\@qq.com" 设置ssh-key  
-\> cd \~/.ssh  
-\> ssh -T git\@github.com

克隆数据：  
-\> git clone git\@github.com:nodejs-team/mcake-activity.git \#
从github上克隆数据到本地 (要使用ssh路径)  
-\> git remote add origin url git\@github.com:nodejs-team/mcake-activity.git  
-\> git remote get-url origin Git远程获取URL的起源

git上传操作三部曲：  
-\> git add .  
-\> git commit -m "add test-wap"  
-\> git push origin master

git log//用于查看提交日志

git删除操作三部曲：  
-\> rm -r app/test-wap/ 删除文件夹  
-\> git add . 添加所有（.表示所有）  
-\> git commit -m "delete test-wap" 添加注释  
-\> git push origin master push同步上传分支

误删 单个拉取文件

git diff //可以查看工作树，暂存区，最新提交之间的差别

git branch //显示分支一览表，同时确认当前所在的分支

git checkout -b aaa //创建名为aaa的分支，并且切换到aaa分支

git branch aaa //创建名为aaa的分支

git checkout aaa // 切换到aaa分支

能和git branch -b aaa 得到同样的效果

git checkout - //切换到上一分支

合并分支

git checkout master //切换到master分支

git merge --no--ff aaa // 加--no--ff
参数可以在历史记录中明确地记录本次分支的合并

git log --graph //以图表形式查看分支

更改提交的操作

git reset //回溯历史版本

git reset --hrad //回溯到指定状态，只要提供目标时间点的哈希值

推进历史

git reflog //查看仓库的操作日志，找到要推历史的哈希值

git checkout master

git reset --hrad ddd //ddd为要推进历史的哈希值

修改提交信息 git commit --amend

压缩历史 git rebase -i 错字漏字等失误称作typo

根据以前的步骤在GitHub上创建仓库，应于本地的仓库名相同
GitHub上面创建的仓库的路径为git\@github.com: 用户名/仓库名.git

git remote add eee git\@github.com: 用户名/仓库名.git
//添加远程仓库，并将git\@github.com: 用户名/仓库名.git远程仓库的名称改为eee

git push -u eee master //推送至远程仓库 master分支下 -u
参数可以在推送的同时，将eee仓库的master分支设置为本地仓库的当前分

支的的upstream（上游）。添加这个参数，将来运行git
pull命令从远程仓库获取内容时，本地仓库的这个分支就可以直接从eee的master

分支中获取内容

　　git checkout -b feature d eee/feature d //获取远程的feature
d分支到本地仓库，-b参数后面是本地仓库中新建的仓库的名称

　　git pull eee feature d //将本地的feature d分支更新为最新状态

　　在GitHub上面查看两个分支之间的差别，只需要在地址栏中输入http://github.com/用户名/仓库名/分支1...分支2

查看master分支在最近七天内的差别

http://github.com/用户名/仓库名/master\@{7.day.ago}...master
（同样，day，week，month，year都是可以哒）
