搭建idoc文档中心

全局安装  
\$ npm install idoc -g  
使用方法  
  
任意目录下新建 test文件夹，并进入 test文件夹 如： mkdir test && cd test。  
在你在的目录下面建立 md 文件夹专门放你的所有 md 文件。  
导航菜单是根据 md 里面的文件目录结构生成 导航菜单。  
在 test 文件夹根目录初始化运行 idoc init 命令，自动生成 package.json 文件。  
生成静态页面，运行 idoc build 命令。  
运行 idoc server 预览生成的静态页面。默认预览地址为 http://localhost:1987/。  
这个时候你可以将生成的文件上传至 github 的 gh-pages 分支中，外网预览。  
命令文档  
  
命令使用帮助。  
  
Usage: idoc [options]  
  
Simple document generation tool!  
  
Options:  
  
-h, --help output usage information  
-V, --version output the version number  
-C, --Create \<file\> Select Directory Makefile.  
-v App version information.  
-i, init Init a documentation.  
-b, build Markdown produces static pages document.  
-w, watch Listener "md" file is automatically generated pages.  
-s, server Open local static html server.  
-c, clean Clear the generate static files.  
-t, theme Choose a theme.  
-d, deploy Publish to a gh-pages branch on GitHub.  
  
Examples:  
  
\$ idoc init  
\$ idoc init [path]  
\$ idoc init [path] -C \~/idoc/  
\$ idoc watch  
\$ idoc server  
\$ idoc clean  
\$ idoc deploy  
\$ idoc theme  
\$ idoc -t \~/git/idoc-theme-slate/  
  
init  
  
初始化文档文件  
  
\#
默认生成模板和配置文件，将当前文件夹根目录的所有md文件参数生成到配置文件package.json中  
\$ idoc init  
\# 将指定的 md 文件拷贝到当前目录下，生成模板和配置文件  
\$ idoc init \~/md/JSLite.md  
\# 将指定的两个 md 文件拷贝到当前目录下  
\$ idoc init \~/git/_idc/package.md \~/git/_idc/dir/directory.md  
\# 将指定的 \_idc 目录下的所有 md 文件拷贝到当前目录下  
\$ idoc init \~/git/_idc/  
  
\# 指定生成模板和配置文件  
\# 将“JSLite.md hotkeys.md”两个 md 文件拷贝到指定目录 \`\~/idoc/\` 下面  
\# 生成模板需要的文件  
\# 第一个 md 文件是首页  
\$ idoc init JSLite.md hotkeys.md -C \~/idoc/  
  
build  
生成静态 HTML 页面到指定目录中。  
\$ idoc build  
  
watch  
监控 md 文件发生变化自动 build。  
\$ idoc watch  
  
server  
打开本地静态 html 服务器，预览你生成的页面。  
\$ idoc server  
  
clean  
清除生成的静态文件。  
\$ idoc clean  
  
theme  
\$ idoc theme 与 \$ idoc -t 相同  
选择默认主题或者第三方主题，默认两个主题 handbook 或者 default。  
  
\# 选择主题  
\# 第三方主题，克隆到当前跟目录就可以使用命令选择了  
\$ idoc theme  
\# theme 简写 －t  
\$ idoc -t  
  
\# 制作主题 需要指定制作的主题目录  
\$ idoc -t \~/git/idoc-theme-slate/  
  
deploy  
将文档部署到 git 仓库的 gh-pages 分支中。  
目前需要手动添加分支。  
\$ idoc deploy
