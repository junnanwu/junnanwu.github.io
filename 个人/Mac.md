# Mac

## Mac快捷键

- 创建文件的快捷方式/替身

  `Command+Option+文件移动`

- 显示隐藏文件、文件夹

  `Command+Shift+. `

## Mac环境变量

Mac系统的环境变量，加载顺序为： 

```
a. /etc/profile 
b. /etc/paths 
c. ~/.bash_profile 
d. ~/.bash_login 
e. ~/.profile 
f. ~/.bashrc 
```

a. /etc/profile

```
➜  /etc cat profile
# System-wide .profile for sh(1)

if [ -x /usr/libexec/path_helper ]; then
	eval `/usr/libexec/path_helper -s`
fi

if [ "${BASH-no}" != "no" ]; then
	[ -r /etc/bashrc ] && . /etc/bashrc
fi
```

b. /etc/paths

```
➜  /etc cat paths
/usr/local/bin
/usr/bin
/bin
/usr/sbin
/sbin
```

其中a和b是系统级别的，系统启动就会加载，其余是用户接别的。c,d,e按照从前往后的顺序读取，如果c文件存在，则后面的几个文件就会被忽略不读了，以此类推。~/.bashrc没有上述规则，它是bash shell打开的时候载入的。这里建议在c中添加环境变量

 **查看所有的环境变量**

`env`

注意：

- 与DOS/Window不同，UNIX类系统环境变量中路径名用`:`分隔，不是分号。

- `$`在Linux脚本中的作用是申明变量

- Linux export 命令

  Linux export 命令用于设置或显示环境变量

  ```
  export [-fnp][变量名称]=[变量设置值]
  ```

**如何添加环境变量**



**如何查看PATH环境变量**

打开终端输入：

`echo $PATH`

```
echo命令的意思是在显示器上显示一段文字,起到提示的作用。 该命令的常规格式为:echo [-n]字符串
```

**如何将添加PATH变量**

- /etc/paths

  这个是系统级别的

  不建议修改paths文件

  可以在paths.d文件夹中添加文件

  ```
  echo "/usr/local/sbin/mypath" | sudo tee test
  ```

  执行完之后需要重启终端

## Idea

- 插入快捷键

  `alt+inster==command+n`

- 整段加注释

  `shift+control+/`

- 重写方法

  `ctrl+O`

- 添加类

  `option+enter`

- 各视图区域的切换

  `cmd + 视图区域对应的数字`

- 显示方法的参数信息

   `Command+P`

- 打开项目结构对话框

   `Command+;` 

- 基本的代码补全

   `Ctrl+Space` 

- 自动生成变量名

   `Command+Option+v`
   
- 大小写切换

   `Command+Shift+u`
   
- 看每一行的编辑者是谁

   `右键+annotate`

- 查看某个类在哪个地方被使用

   `Alt+F7`

## 终端

- 删除光标之前到行首的字符

  `Ctrl + u` 

- 删除光标到行尾的字符

  `Ctrl + k`

- 光标移动到行首(Ahead of line)，相当于通常的Home键

  `Ctrl + a`

- 光标移动到行尾(End of line)

  `Ctrl + e`

- 取消(cancel)当前行输入的命令，相当于Ctrl + Break

  `Ctrl + c `

- 清屏，相当于执行clear命令

  `Ctrl + l `

## Hombrew

Homebrew是一款Mac OS平台下的软件包管理工具，拥有安装、卸载、更新、查看、搜索等很多实用的功能。简单的一条指令，就可以实现包管理，而不用你关心各种依赖和文件路径的情况，十分方便快捷。

- 查看当前的镜像源

  ```
  brew config
  ```
  
- 查看安装的软件列表

  ```
  brew list
  ```

- 查看某个软件的列表

  ```
  brew list nginx
  ```

- 查找包中所有的文件

  ```
  brew ls nginx
  ```

  ```
  /usr/local/Cellar/nginx/1.19.8/.bottle/etc/ (15 files)
  /usr/local/Cellar/nginx/1.19.8/bin/nginx
  /usr/local/Cellar/nginx/1.19.8/homebrew.mxcl.nginx.plist
  /usr/local/Cellar/nginx/1.19.8/html -> ../../../var/www
  /usr/local/Cellar/nginx/1.19.8/share/man/man8/nginx.8
  /usr/local/Cellar/nginx/1.19.8/share/nginx/ (2 files)
  ```

- 查看已安装的信息

  ```
  brew info maven
  ```

  ```
  ➜ ~ brew info nginx
  nginx: stable 1.19.8 (bottled), HEAD
  HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server
  https://nginx.org/
  /usr/local/Cellar/nginx/1.19.8 (25 files, 2.2MB) *
    Poured from bottle on 2021-03-16 at 11:24:53
  From: https://mirrors.ustc.edu.cn/homebrew-core.git/Formula/nginx.rb
  License: BSD-2-Clause
  ==> Dependencies
  Required: openssl@1.1 ✔, pcre ✔
  ==> Options
  --HEAD
  	Install HEAD version
  ==> Caveats
  Docroot is: /usr/local/var/www
  
  The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
  nginx can run without sudo.
  
  nginx will load all files in /usr/local/etc/nginx/servers/.
  
  To have launchd start nginx now and restart at login:
    brew services start nginx
  Or, if you don't want/need a background service you can just run:
    nginx
  ```


## item2

- `command + t` 新建窗口

- `command + t` 新建窗口
- `command + d` 垂直分屏，
- `command + shift + d` 水平分屏
- `command + ]` 和 `command + [`在最近使用的分屏直接切换

## Oh My Zsh

配置命令高亮

- 安装

  ```
  brew install zsh-syntax-highlighting
  ```

- 配置

  在` ~/.zshrc`中添加下面配置

  ```
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  ```


## Sublime

- 进入列编辑模式

  `command + shift + L`

- 列编辑移动到首位

  `command + 左 右`

