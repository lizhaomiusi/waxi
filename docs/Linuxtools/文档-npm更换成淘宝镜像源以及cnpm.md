npm更换成淘宝镜像源以及cnpm

http://npm.taobao.org/

https://link.jianshu.com/?t=http://npm.taobao.org/

1、需求由来  
由于node安装插件是从国外服务器下载，受网络影响大，速度慢且可能出现异常。

所以如果npm的服务器在中国就好了，所以我们乐于分享的淘宝团队（阿里巴巴

来自官网：“这是一个完整 npmjs.org
镜像，你可以用此代替官方版本(只读)，同步频率目前为 10分钟
一次以保证尽量与官方服务同步。  
也就是说我们可以使用阿里布置在国内的服务器来进行node安装。

### 2、使用方法

使用阿里定制的 cnpm 命令行工具代替默认的 npm，输入下面代码进行安装：  
\$ npm install -g cnpm --registry=https://registry.npm.taobao.org

或者你直接通过添加 npm 参数 alias 一个新命令:

alias cnpm="npm --registry=https://registry.npm.taobao.org \\

\--cache=\$HOME/.npm/.cache/cnpm \\

\--disturl=https://npm.taobao.org/dist \\

\--userconfig=\$HOME/.cnpmrc"

\# Or alias it in .bashrc or .zshrc

\$ echo '\\n\#alias for cnpm\\nalias cnpm="npm
--registry=https://registry.npm.taobao.org \\

\--cache=\$HOME/.npm/.cache/cnpm \\

\--disturl=https://npm.taobao.org/dist \\

\--userconfig=\$HOME/.cnpmrc"' \>\> \~/.zshrc && source \~/.zshrc

检测cnpm版本，如果安装成功可以看到cnpm的基本信息。  
cnpm -v

3、以后安装插件只需要使用cnpm intall即可

假如我已经习惯了npm
install的安装方式，我不想去下载阿里的cnpm命令工具将命令变成cnpm怎么办？

很容易我们想到，我直接将node的仓库地址改成淘宝镜像的仓库地址不就好了吗？

单次使用  
npm install --registry=https://registry.npm.taobao.org

4、永久使用  
设置成全局的下载镜像站点，这样每次install的时候就不用加--registry，默认会从淘宝镜像下载，设置方法如下  
打开.npmrc文件（nodejs\\node_modules\\npm\\npmrc

没有的话可以使用git命令行建一个( touch .npmrc)，用cmd命令建会报错  
增加 registry = https://registry.npm.taobao.org

也可以按如下方式直接在命令行设置  
npm config set registry https://registry.npm.taobao.org

检测是否成功  
npm config get registry

安装模块

从 registry.npm.taobao.org 安装所有模块.
当安装的时候发现安装的模块还没有同步过来, 淘宝 NPM 会自动在后台进行同步,
并且会让你从官方 NPM registry.npmjs.org 进行安装. 下次你再安装这个模块的时候,
就会直接从 淘宝 NPM 安装了.

\$ cnpm install [name]

npm info express
