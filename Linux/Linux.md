# Linux

## yum

yum(Yellow dog Updater, Modified)，是一个前端软件包管理器。

我们通常使用 `yum install` 命令来在线安装 **linux系统的软件**， 这种方式基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包。

用yum安装，实质上是用RPM安装，所以RPM查询信息的指令都可用。

- yum -y install与yum install有什么不同？

  如果使用`yum install xxxx`，会找到安装包之后，询问你`Is this OK[y/d/N]`，需要你手动进行选择。但是如果加上参数`-y`，就会自动选择`y`，不需要你再手动选择。

### yum配置阿里云仓库

- 查看可用的epel源

  ```
  yum list | grep epel-release
  ```

- 安装 epel

  ```
  yum install -y epel-release
  ```

- 配置阿里镜像提供的epel源

  ```
  wget -O /etc/yum.repos.d/epel-7.repo  http://mirrors.aliyun.com/repo/epel-7.repo
  ```

- 清除系统所有的yum缓存

  ```
  yum clean all
  ```

- 生成yum缓存

  ```
  yum makecache
  ```

- 查看所有的yum源

  ```
  yum repolist all
  ```

- 查看可用的yum源

  ```
  yum repolist enabled
  ```

### 中止yum安装

- 中断线程

  ```
  ctrl+z 
  ```

- 查找当前yum相关进程

  ```
  ps -ef | grep yum
  ```

- 杀死线程（选择第一行的第一个）

  ```
  kill -9 进程号(pid)
  ```

### 查看yum安装的软件位置

- 一般来说，RPM默认安装路径如下

  | Directory      | **Contents of Directory**                 |
  | -------------- | ----------------------------------------- |
  | /etc           | 一些配置文件的目录，例如/etc/init.d/mysql |
  | /usr/bin       | 一些可执行文件                            |
  | /usr/lib       | 一些程序使用的动态函数库                  |
  | /usr/share/doc | 一些基本的软件使用手册与帮助文档          |
  | /usr/share/man | 一些man page文件                          |

- 以MySQL为例

  查看MySQL安装包

  ```
  [root@VM-0-7-centos ~]# rpm -qa | grep -i mysql
  mysql-community-common-5.6.50-2.el6.x86_64
  mysql-community-client-5.6.50-2.el6.x86_64
  mysql-community-server-5.6.50-2.el6.x86_64
  mysql-community-release-el6-5.noarch
  mysql-community-libs-5.6.50-2.el6.x86_64
  ```

- 查看具体路径

  ```
  [root@VM-0-7-centos ~]# rpm -ql mysql-community-client-5.6.50-2.el6.x86_64
  /usr/bin/msql2mysql
  /usr/bin/mysql
  /usr/bin/mysql_config_editor
  /usr/bin/mysql_find_rows
  /usr/bin/mysql_waitpid
  /usr/bin/mysqlaccess
  /usr/bin/mysqlaccess.conf
  /usr/bin/mysqladmin
  /usr/bin/mysqlbinlog
  /usr/bin/mysqlcheck
  /usr/bin/mysqldump
  /usr/bin/mysqlimport
  /usr/bin/mysqlshow
  /usr/bin/mysqlslap
  /usr/share/doc/mysql-community-client-5.6.50
  /usr/share/doc/mysql-community-client-5.6.50/LICENSE
  /usr/share/doc/mysql-community-client-5.6.50/README
  /usr/share/man/man1/msql2mysql.1.gz
  /usr/share/man/man1/mysql.1.gz
  /usr/share/man/man1/mysql_config_editor.1.gz
  /usr/share/man/man1/mysql_find_rows.1.gz
  /usr/share/man/man1/mysql_waitpid.1.gz
  /usr/share/man/man1/mysqlaccess.1.gz
  /usr/share/man/man1/mysqladmin.1.gz
  /usr/share/man/man1/mysqlbinlog.1.gz
  /usr/share/man/man1/mysqlcheck.1.gz
  /usr/share/man/man1/mysqldump.1.gz
  /usr/share/man/man1/mysqlimport.1.gz
  /usr/share/man/man1/mysqlshow.1.gz
  /usr/share/man/man1/mysqlslap.1.gz
  ```

[Reference](https://www.cnblogs.com/kerrycode/p/6924153.html)

### rpm

```
rpm（英文全拼：redhat package manager） 原本是 Red Hat Linux 发行版专门用来管理 Linux 各项套件的程序
```

常用参数

```
-i, --install                     install package(s)
-v, --verbose                     provide more detailed output
-h, --hash                        print hash marks as package installs (good with -v)
-e, --erase                       erase (uninstall) package
-U, --upgrade=<packagefile>+      upgrade package(s)
－-replacepkge                    无论软件包是否已被安装，都强行安装软件包
--test                            安装测试，并不实际安装
--nodeps                          忽略软件包的依赖关系强行安装
--force                           忽略软件包及文件的冲突
Query options (with -q or --query):
-a, --all                         query/verify all packages
-p, --package                     query/verify a package file
-l, --list                        list files in package
-d, --docfiles                    list all documentation files
-f, --file                        query/verify package(s) owning file
```



## 文件目录

### rm

删除文件夹

```
rm -rf
```

### mv

移动：

- 将root文件夹下的所有文件都移动到当前文件夹

  ```
  mv /root/* .
  ```

  注意：用户使用该指令复制目录时，必须使用参数 **-r** 或者 **-R** 。

重命名：

- 将文件 aaa 改名为 bbb

  ```
  mv aaa bbb
  ```

  目标目录与原目录一致，则指定了新文件名，效果仅仅是重命名。

  ```
  mv  /home/ffxhd/a.txt   /home/ffxhd/b.txt    
  ```

- 目标目录与原目录不一致，没有指定新文件名，效果就是仅仅移动。

  ```
  mv  /home/ffxhd/a.txt   /home/ffxhd/test/ 
  或者
  mv  /home/ffxhd/a.txt   /home/ffxhd/test 
  ```

- 目标目录与原目录一致, 指定了新文件名，效果就是：移动 + 重命名。

  ```
  mv  /home/ffxhd/a.txt   /home/ffxhd/test/c.txt
  ```

### ls

`ls -a` 显示包括隐藏文件

- -a 显示所有文件及目录 (**.** 开头的隐藏文件也会列出)
- -l  以列表方式显示
- -h  件大小单位显示，默认是字节

注意：

关于`ls -l`的排序方式

- 无视字母之外的顺序（也就是说，就当数字和字母之外的字符，如中文、符号不存在）

- 数字优先于字母，同位数字之间从小到大

  ```
  a1 > a1b > a2 > aa >aA
  ```

关于`ls -l`中的total是什么

```
int total = （physical_blocks_in_use) * physical_block_size / ls_block_size
```





### cp

```
cp(copy file)
```

用于复制文件或目录

使用指令 **cp** 将当前目录 **test/** 下的所有文件复制到新目录 **newtest** 下，输入如下命令

```
cp –r test/ newtest
```

### pwd

```
pwd（print work directory） 命令用于显示工作目录
```

### sed

替换文本中的`/r`

```
sed -i 's/\r$//' build.sh
```

### grep

查找文件里符合条件的字符串

```
grep （global search regular expression(RE) and print out the line）全面搜索正则表达式并把行打印出来
```

搜索`/usr/src/linux/Documentation`目录下搜索带字符串`magic`的文件：

```
$ grep magic /usr/src/linux/Documentation/*
sysrq.txt:* How do I enable the magic SysRQ key?
sysrq.txt:* How do I use the magic SysRQ key?
```

```
-a 或 --text : 不要忽略二进制的数据。
```

### cat

cat命令的用途是连接文件或标准输入并打印。这个命令常用来显示文件内容，或者将几个文件连接起来显示，或者从标准输入读取内容并显示，它常与重定向符号配合使用

cat主要有三大功能：

- 一次显示整个文件:cat filename
- 从键盘创建一个文件:cat > filename 只能创建新文件,不能编辑已有文件
- 将几个文件合并为一个文件:cat file1 file2 > file

[cat命令](https://www.cnblogs.com/peida/archive/2012/10/30/2746968.html)

### echo

使用`>`指令覆盖文件原内容并重新输入内容，若文件不存在则创建文件

```
echo "Raspberry" > test.txt
```

使用>>指令向文件追加内容，原内容将保存

```
echo "Intel Galileo" >> test.txt  
```

### tree

用于生成目录的树形层级结构

便利层级

```
tree -L 2
```

只显示文件夹

```
tree -d
```



## 操作文件

### find

```
find  [指定查找目录]  [查找规则]  [查找完后执行的action]
#在目录下査找文件名是yum.conf的文件
find /-name yum.conf
-iname: 按照文件名搜索，不区分文件名大小；
指定递归深度
find ./test -maxdepth 2 -name "*.php"
```

例如：

```
[wujn@zlfzb mysql]$ sudo find / -name nginx
[sudo] wujn 的密码：
/usr/local/nginx
/usr/local/nginx/sbin/nginx
/data/sre/setup/nginx-1.14.2/objs/nginx
/data/nginx
/data/nginx/sbin/nginx
/data/filebeat/module/nginx
```

[Linux中find命令的用法汇总](https://www.jb51.net/article/108198.htm)

### locate

```

```

### which

which指令会在环境变量$PATH设置的目录里查找符合条件的文件。

```
which bash
```

### 解压

- tar

  ```
  解包：tar xvf FileName.tar 
  打包：tar cvf FileName.tar DirName //这个不叫压缩
  ```

- gz

  ```
  解压1：gunzip FileName.gz 
  解压2：gzip -d FileName.gz 
  压缩：gzip FileName
  ```

- tar.gz 和 tgz 

  ```
  解压：tar zxvf FileName.tar.gz 
  解压到指定文件夹：tar -zxvf FileName.tar.gz -C aaa 这个目录必须存在
  
  压缩：tar zcvf FileName.tar.gz DirName 
  ```

- zip

  ```
  解压：unzip FileName.zip 
  压缩：zip FileName.zip DirName 
  ```

  ```
  unzip -d /app tomcat-all.zip 批量将文件解压到对应的目录需要用到-d参数
  ```

解压错怎么办

- unzip误解压使用以下命令补救

  ```
  zipinfo -1 ./ShareWAF.zip(误解压文件) | xargs rm -rf
  ```

- tar误解则压使用以下命令补救

  ```
  tar -tf 误解压文件 | xargs rm -rf
  ```

  tar -tf 是列出该压缩文件中的文件列表，xargs rm -rf 则是根据前面的文件列表来删除文件

## 文本处理

### awk

AWK 是一种处理文本文件的语言

### seq

(squeue)

```
seq [选项]... 首数 增量 尾数
```

例：

```
➜  ~ seq 5
1
2
3
4
5
```

从1连续输出到5

```
➜  ~ seq 1 5
1
2
3
4
5
```

从1开始，步数为2，最大到10

```
➜ ~ seq 1 2 10
1
3
5
7
9
```

参数：

- `-f`

  ```
  ➜  ~ seq -f 'str%3g' 9 11
  str  9
  str 10
  str 11
  ```

  ```
  ➜  ~ seq -f "str%03g" 9 11
  str009
  str010
  str011
  ```

  - `%`后面指定数字的位数，`%3g`表示位宽三位，`%03g`表示位宽为3位，且位宽不足三的时候，用0补齐
  - `%`前面可以指定字符串，不能和`-w`一起使用

- `-w`

  输出等宽

  ```
  ➜  ~ seq -w -f"str%03g" 9 11
  str009
  str010
  str011
  ```

- `-s`

  指定分隔符，默认是回车

  ```
  ➜  ~ seq -s + 1 10
  1+2+3+4+5+6+7+8+9+10+%
  ```

应用：

一次性创建5个名为dir001，dir002 ... dir010这10个目录的时候，就可以使用如下命令：

```
mkdir $(seq -f 'dir%03g' 1 10)
```

或者

```
seq -f 'dir%03g' 1 10 | xargs mkdir
```

### sed

利用脚本来处理文件

**动作说明**：

- a：新增
- c：取代
- d：删除
- i：插入
- p：打印
- s：取代，后面可以搭配正则表达式

### 计算字符串长度

- `${#var}`



判断字符串是否包含

- 

### tee

tee显示输出结果并且保存到文件中



## 网络

### 测试远程端口

#### telnet

```
telnet ip port
```

telnet之后如何退出？

先按`ctrl+]`然后输入`quit`

#### nmap

```
nmap ip -p port
```

#### nc

```
nc -v ip port
```

### 远程连接

#### ssh

- **SSH是什么？**

  SSH 为 (Secure Shell)，专为远程登录会话和其他网络服务提供安全性的协议，如果一个用户从本地计算机，使用SSH协议登录另一台远程计算机，我们就可以认为，这种登录是安全的，即使被中途截获，密码也不会泄露，目前已经成为Linux系统的标准配置。

- **使用SSH账号密码连接远程主机**

  - 登录命令

    ```
    ssh <username>@<hostname or IP address>
    ```

    user为默认的用户名，host为上面腾讯云提供给你的公网IP，SSH的默认端口是22，所以上述命令的默认连接端口为22，可以使用如下命令修改端口

    ```
    $ ssh -p 2222 user@host
    ```

    如图命令表示，ssh直接连接远程主机的2222端口

    - 问题：密码输错三场后，提示如下错误

      ```
      user@49.232.68.5's password: 
      user@49.232.68.5: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).
      ```

      解决：

      去腾讯云控制台改一下密码

  - 登出命令

    - ```
      logout
      ```

    - ```
      exit
      ```

    - 直接关闭终端

  - 示例

    ```
    wujunnan@wujunnandeMacBook-Pro ~ %  ssh root@wujunnan.net
    root@wujunnan.net's password: 
    Last login: Tue Nov 24 22:16:27 2020 from 120.244.160.103
    ```

- **使用SSH密钥登录远程主机**

  - 先去控制台获取密钥

  - 执行以下命令，赋予私钥文件仅本人可读权限

    ```
    chmod 400 <下载的与云服务器关联的私钥的绝对路径>
    ```

  - 执行以下命令，进行远程登录（第一次会让输入密码）

    ```
    ssh -i <下载的与云服务器关联的私钥的绝对路径> <username>@<hostname or IP address>
    ```

  - 示例

    ```
    wujunnan@wujunnandeMacBook-Pro ~ % ssh -i /Users/wujunnan/develop/important/wujunnan.pem root@wujunnan.net
    Last login: Fri Nov 20 23:52:28 2020 from 120.244.160.103
    ```

### 文件传输

#### scp

scp是secure copy的简写，用于在Linux下进行远程拷贝文件的命令

**上传命令**

```
scp local_file remote_ip:remote_folder 
```

默认使用22端口

**上传到哪里**

本地安装的软件和其他文件一般放在这里

```
/usr/local
```

**实际使用**

- 上传Tomcat压缩包(不写目的目录会默认放在root下)

  ```
  wujunnan@wujunnandeMacBook-Pro ~ % scp /Users/wujunnan/软件/Tomcat/apache-tomcat-8.5.60.tar.gz root@wujunnan.net:/usr/local/tomcat
  ```

- 上传zookeeper**文件夹**

  ```
  wujunnan@wujunnandeMacBook-Pro ~ % scp -r /Users/wujunnan/develop/WWW/zookeeper-3.4.6 root@wujunnan.net:/usr/local/zookeeper
  ```

  `-r`为递归上传文件夹

### 防火墙

- 查看防火墙状态

  ```
  systemctl status firewalld
  ```

  下面表示未开启防火墙

  ```
  Active: inactive (dead)
  ```

- 开启防火墙

  ```
  systemctl start firewalld
  ```

- 开启端口

  ```
  firewall-cmd --permanent --zone=public --add-port=8080/tcp
  ```

  没有 --perman此参数重启后失效

- 查看端口

  ```
  firewall-cmd --permanent --query-port=8080/tcp
  ```

  提示yes，即查询成功

- 重启防火墙

  ```
  firewall-cmd --reload
  ```

- 查看已经开放的端口

  ```
  firewall-cmd --list-ports 
  ```

- 关闭防火墙端口

  ```
  firewall-cmd --zone=public --remove-port=3338/tcp --permanent
  ```

- 设置防火墙开机自动启动

  ```
  systemctl enable firewalld
  ```

- 开机禁用防火墙

  ```
  systemctl disable firewalld
  ```

## 命令相关

### eval

在bash中，反引号和$()都是用来做命令替换的，命令替换就是重组命令，先完成引号里面的命令，然后将其结果替换出来，再重组成新的命令行。

也就是说，在执行一条命令的时候，会先将其中的反引号或者$()中的语句当成命令执行一遍，再将结果加到原命令中重新执行。

例如：

```
➜  /usr echo ls
ls
➜  /usr echo `ls`
X11 X11R6 bin lib libexec local sbin share standalone
```

eval命令适用于那些一次扫描无法实现其功能的变量。该命令对变量进行两次扫描

例如：

```
➜  test ls
file
➜  test cat file
hello world
➜  test myfile="cat file"
➜  test echo $myfile
cat file
➜  test eval $myfile
hello world
```

[reference](https://blog.51cto.com/u_10706198/1788573)

## 监控

### netstat

它跟 netstat 差不多，但有着比 netstat 更强大的统计功能

```
netstat -anp|grep 8005
```

```
-a (all) 显示所有选项，默认不显示LISTEN相关。
-t (tcp) 仅显示tcp相关选项。
-u (udp) 仅显示udp相关选项。
-n 拒绝显示别名，能显示数字的全部转化成数字。
-l 仅列出有在 Listen (监听) 的服务状态。

-p 显示建立相关链接的程序名
-r 显示路由信息，路由表
-e 显示扩展信息，例如uid等
-s 按各个协议进行统计
-c 每隔一个固定时间，执行该netstat命令。
```

### ss

ss 是 Socket Statistics

```
ss -antp | grep java | column -t
```

```
-h, --help 帮助
-V, --version 显示版本号
-t, --tcp 显示 TCP 协议的 sockets
-u, --udp 显示 UDP 协议的 sockets
-x, --unix 显示 unix domain sockets，与 -f 选项相同
-n, --numeric 不解析服务的名称，如 "22" 端口不会显示成 "ssh"
-l, --listening 只显示处于监听状态的端口
-p, --processes 显示监听端口的进程(Ubuntu 上需要 sudo)
-a, --all 对 TCP 协议来说，既包含监听的端口，也包含建立的连接
-r, --resolve 把 IP 解释为域名，把端口号解释为协议名称
```

### lsof

lsof(list open files)是一个列出当前系统打开文件的工具。

[Reference](https://www.cnblogs.com/sparkbj/p/7161669.html)

### free

```
free [-bkmotV][-s <间隔秒数>]
```

free 命令显示系统内存的使用情况，包括物理内存、交换内存(swap)和内核缓冲区内存。

- -b 　以Byte为单位显示内存使用情况。
- -k 　以KB为单位显示内存使用情况。
- -m 　以MB为单位显示内存使用情况。
- -h 　以合适的单位显示内存使用情况，最大为三位数，自动计算对应的单位值。单位有：

[Reference1](https://www.cnblogs.com/ultranms/p/9254160.html)

[Reference2](https://www.runoob.com/linux/linux-comm-free.html)

### df

linux中的df(disk free)命令的功能是用来检查Linux服务器的文件系统的占用情况

- -h 方便阅读方式显示（以人们较易阅读的 GBytes, MBytes, KBytes 等格式自行显示）

```
➜  ~ df -h
Filesystem       Size   Used  Avail Capacity iused      ifree %iused  Mounted on
/dev/disk1s1s1  466Gi   14Gi  386Gi     4%  559993 4881892887    0%   /
devfs           191Ki  191Ki    0Bi   100%     661          0  100%   /dev
/dev/disk1s4    466Gi  6.0Gi  386Gi     2%       6 4882452874    0%   /System/Volumes/VM
/dev/disk1s2    466Gi  348Mi  386Gi     1%    1248 4882451632    0%   /System/Volumes/Preboot
/dev/disk1s7    466Gi  3.3Mi  386Gi     1%      19 4882452861    0%   /System/Volumes/Update
/dev/disk1s8    466Gi   58Gi  386Gi    14%  692901 4881759979    0%   /System/Volumes/Data
map auto_home     0Bi    0Bi    0Bi   100%       0          0  100%   /System/Volumes/Data/home
```

- Filesystem：代表该文件系统是在哪个partition ，所以列出设备名称
- Mounted on：就是磁盘挂载的目录所在

### 查看Linux的配置

#### 内存

- `cat /proc/meminfo`
- `free -m`

#### 核心数

- 查看物理CPU数

  `cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l`

- 查看每个物理CPU中core的个数(即核数)

  `cat /proc/cpuinfo| grep "cpu cores"| uniq`

总核数 = 物理CPU个数 X 每颗物理CPU的核数

#### 查看CPU信息

`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c`

#### 查看操作系统版本

`cat /etc/centos-release`

## 进程

### ps

- 查看ppid为30726的进程相关信息

  ```
  ps -ef|grep 30726
  ```

- 查看在运行的Tomcat

  ```
  ps -ef |grep tomcat
  ```

  注意，最后一行进程将会是grep自己，如下命令可以将grep进程剔除

  ```
  ps -aux|grep chat.js| grep -v grep
  ```

- 相关参数

  ```
  -e：显示系统内的所有进程信息。与-A选项功能相同
  -f：使用完整的（full）格式显示进程信息。还会打印命令参数，当与-L一起使用时，将添加NLWP（线程数）和LWP（线程ID）列
  -F：在-f选项基础上显示额外的完整格式的进程信息。包含SZ、RSS和PSR这三个字段
  -a：显示所有程序
  -u：以用户为主的格式来显示
  -x：显示所以程序，不以终端机来区分
  ```

- 批量杀死Tomcat

  - 查看Tomcat服务

    ```
    ps -aux|grep tomcat
    ```

  - 筛选出第二项pid

    ```
    ps -aux|grep tomcat|awk '{print $2}'
    ```

  - 批量杀死这些线程

    ```
    ps -aux|grep name|awk '{print $2}'|xargs kill -9
    ```

### kill

停止一个线程

```
kill -9 [线程号]
```

 停止多个线程

```
kill -9 [线程号1] [线程号2]
```



### jps

**jps**(Java Virtual Machine Process Status Tool)

是java提供的一个显示当前所有java进程pid的命令，适合在linux/unix平台上简单察看当前java进程的一些简单情况。

## 运行

### nohup

不挂断的运行命令（no hang up）

三种运行方式的区别：

- `nohup /opt/jdk1.8.0_131/bin/java -jar ggg.jar` 

  正常的运行方式，回车之后输出执行日志，若执行ontrol+c或者关闭终端，进程将终止

- `nohup /opt/jdk1.8.0_131/bin/java -jar ggg.jar` 

  回车之后，将日志文件输出到nohup.out文件中，若执行control+c或者关闭终端，进程将终止

- `nohup /opt/jdk1.8.0_131/bin/java -jar ggg.jar &`

  回车之后，会输出进程号，以及提示日志输出在nohup.out文件中，若执行control+c或者关闭终端，进程仍在运行

- `nohup command > myout.file 2>&1 &`

  在上面的例子中，输出被重定向到myout.file文件中。

-  `nohup ./filebeat  -e -c filebeat.yml -d "publish" >/dev/null  2>&1 &`

  - 操作系统中有三个常用的流：

    0：标准输入流 stdin

    1：标准输出流 stdout

    2：标准错误流 stderr

  - 2>&1的意思 

    这个意思是把标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。 至于为什么需要将标准错误重定向到标准输出的原因，那就归结为标准错误没有缓冲区，而stdout有。这就会导致 >output 2>output 文件output被两次打开，而stdout和stderr将会竞争覆盖，这肯定不是我门想要的

  - /dev/null文件的作用，这是一个无底洞，任何东西都可以定向到这里，但是却无法打开。 所以一般很大的stdou和stderr当你不关心的时候可以利用stdout和stderr定向到这里>./command.sh >/dev/null 2>&1 

## 用户权限

### 用户信息

Linux系统中用户信息存放在`/etc/passwd`文件中

文件的一行代表一个单独的用户。该文件将用户的信息分为 3 个部分。

-  第一部分是 root 账户，这代表管理员账户，对系统的每个方面都有完全的权力。
- 第二部分是系统定义的群组和账户，这些群组和账号是正确安装和更新系统软件所必需的。
- 第三部分在最后，代表一个使用系统的真实用户。

在创建用户的时候同时修改了下面几个文件

```
* /etc/passwd： 用户账户的详细信息在此文件中更新。
* /etc/shadow： 用户账户密码在此文件中更新。
* /etc/group： 新用户群组的详细信息在此文件中更新。
* /etc/gshadow： 新用户群组密码在此文件中更新。
```

#### /etc/passwd

文件将每个用户的详细信息写为一行，其中包含七个字段，每个字段之间用冒号 : 分隔：

```
[root@VM-0-7-centos etc]# cat passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
libstoragemgmt:x:998:997:daemon account for libstoragemgmt:/var/run/lsm:/sbin/nologin
rpc:x:32:32:Rpcbind Daemon:/var/lib/rpcbind:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
abrt:x:173:173::/etc/abrt:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
chrony:x:997:995::/var/lib/chrony:/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
syslog:x:996:994::/home/syslog:/bin/false
mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash
dockerroot:x:995:992:Docker User:/var/lib/docker:/sbin/nologin
elastic:x:1000:1000::/home/elastic:/bin/bash
```

```
elastic  :x	   :1000    :1000    :          :/home/elastic  :/bin/bash
用户名		:密码  :用户id  :群组id  :用户信息   :家目录          :Shell
```

字段详解：

- 用户名： 已创建用户的用户名，字符长度 1 个到 12 个字符。
- 密码（x）：代表加密密码保存在`/etc/shadow`文件中。
- 用户 ID（506）：代表用户的 ID 号，每个用户都要有一个唯一的 ID 。UID 号为 0 的是为 root 用户保留的，UID 号 1 到 99 是为系统用户保留的，UID 号 100-999 是为系统账户和群组保留的。
- 群组 ID （507）：代表群组的 ID 号，每个群组都要有一个唯一的 GID ，保存在 /etc/group文件中。
- 用户信息（2g Admin - Magesh M）：代表描述字段，可以用来描述用户的信息
- 家目录（/home/mageshm）：代表用户的家目录。
- Shell（/bin/bash）：代表用户使用的 shell 类型。

[Reference](https://linux.cn/article-9888-1.html)

#### /etc/shadow

```
root:$1$Bg1H/4mz$X89TqH7tpi9dX1B9j5YsF.:14838:0:99999:7:::
```

其格式为：

```
{用户名}:{加密后的口令密码}:{口令最后修改时间距原点(1970-1-1)的天数}:{口令最小修改间隔(防止修改口令，如果时限未到，将恢复至旧口令):{口令最大修改间隔}:{口令失效前的警告天数}:{账户不活动天数}:{账号失效天数}:{保留}
```

加密算法就是明文密码和salt

#### /etc/sudoers

```
## (Sudoers文件允许特定的用户不使用密码就可以像root用户一样运行各种各样的命令)
## Sudoers allows particular users to run various commands as
## the root user, without needing the root password.
##
## (文件的底部提供了一系列命令供选择，这些实例都可以被特定用户或用户组所使用)
## Examples are provided at the bottom of the file for collections
## of related commands, which can then be delegated out to particular
## users or groups.
##
## 该文件必须使用visudo命令来编辑
## This file must be edited with the 'visudo' command.

## 主机别名
## Host Aliases
## 
## Groups of machines. You may prefer to use hostnames (perhaps using
## wildcards for entire domains) or IP addresses instead.
# Host_Alias     FILESERVERS = fs1, fs2
# Host_Alias     MAILSERVERS = smtp, smtp2

## User Aliases
## 用户别名 但是并不是很常用 因为你可以使用组来代替用户别名
## These aren't often necessary, as you can use regular groups
## (ie, from files, LDAP, NIS, etc) in this file - just use %groupname
## rather than USERALIAS
# User_Alias ADMINS = jsmith, mikem


## Command Aliases
## These are groups of related commands...

## Networking
## 网络操作的相关别名
# Cmnd_Alias NETWORKING = /sbin/route, /sbin/ifconfig, /bin/ping, /sbin/dhclient, /usr/bin/net, /sbin/iptables, /usr/bin/rfcomm, /usr/bin/wvdial, /sbin/iwconfig, /sbin/mii-tool

## Installation and management of software
## 软件管理管理相关的别名
# Cmnd_Alias SOFTWARE = /bin/rpm, /usr/bin/up2date, /usr/bin/yum

## Services
# Cmnd_Alias SERVICES = /sbin/service, /sbin/chkconfig, /usr/bin/systemctl start, /usr/bin/systemctl stop, /usr/bin/systemctl reload, /usr/bin/systemctl restart, /usr/bin/systemctl status, /usr/bin/systemctl enable, /usr/bin/systemctl disable

## Updating the locate database
# Cmnd_Alias LOCATE = /usr/bin/updatedb

## Storage
# Cmnd_Alias STORAGE = /sbin/fdisk, /sbin/sfdisk, /sbin/parted, /sbin/partprobe, /bin/mount, /bin/umount

## Delegating permissions
# Cmnd_Alias DELEGATING = /usr/sbin/visudo, /bin/chown, /bin/chmod, /bin/chgrp

## Processes
# Cmnd_Alias PROCESSES = /bin/nice, /bin/kill, /usr/bin/kill, /usr/bin/killall

## Drivers
# Cmnd_Alias DRIVERS = /sbin/modprobe

# Defaults specification

#
# Refuse to run if unable to disable echo on the tty.
#
Defaults   !visiblepw

#
# Preserving HOME has security implications since many programs
# use it when searching for configuration files. Note that HOME
# is already set when the the env_reset option is enabled, so
# this option is only effective for configurations where either
# env_reset is disabled or HOME is present in the env_keep list.
#
Defaults    always_set_home

Defaults    env_reset
Defaults    env_keep =  "COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS"
Defaults    env_keep += "MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE"
Defaults    env_keep += "LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES"
Defaults    env_keep += "LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE"
Defaults    env_keep += "LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY"

#
# Adding HOME to env_keep may enable a user to run unrestricted
# commands via sudo.
#
# Defaults   env_keep += "HOME"

Defaults    secure_path = /sbin:/bin:/usr/sbin:/usr/bin

## 下面是配置规则，哪些用户可以使用哪些软件跑在哪些机器上
## Next comes the main part: which users can run what software on
## which machines (the sudoers file can be shared between multiple
## systems).
## Syntax:
##
## 	user	MACHINE=COMMANDS
##  用户 可以登录的主机 = 可以执行的命令
##
## The COMMANDS section may have other options added to it.
##
## 允许root用户使用任何命令在任何机器上跑
## Allow root to run any commands anywhere
root	ALL=(ALL) 	ALL

## 允许sys组运行一些命令
## Allows members of the 'sys' group to run networking, software,
## service management apps and more.
# %sys ALL = NETWORKING, SOFTWARE, SERVICES, STORAGE, DELEGATING, PROCESSES, LOCATE, DRIVERS

## 允许wheel组的用户运行任何机器的任何命令 
## Allows people in group wheel to run all commands
%wheel	ALL=(ALL)	ALL

## 不需要输入密码
## Same thing without a password
# %wheel	ALL=(ALL)	NOPASSWD: ALL

## 允许users用户组中的用户像root用户一样使用mount、unmount、chrom命令
## Allows members of the users group to mount and unmount the
## cdrom as root
# %users  ALL=/sbin/mount /mnt/cdrom, /sbin/umount /mnt/cdrom

## Allows members of the users group to shutdown this system
# %users  localhost=/sbin/shutdown -h now

## sudo 总是服从所有匹配到最后一行，也就是说，如果匹配条目有冲突，总是后面的其作用
## Read drop-in files from /etc/sudoers.d (the # here does not mean a comment)
#includedir /etc/sudoers.d
```

sudoers 配置很复杂，但一般只要把管理员账号添加到 wheel 组就好了，配置都不用改就能满足大多数要求。

### 用户组

Linux操作系统对多用户的管理，是非常繁琐的，所以用组的概念来管理用户就变得简单，每个用户可以在一个独立的组，每个组也可以有零个用户或者多个用户。

[Reference](https://www.cnblogs.com/fengdejiyixx/p/10773731.html)

### 新建用户

出于安全考虑，一般都给自己创建一个普通用户，而不直接使用root用户，因为权限大了，误操作就容易带来无法弥补的损失。Linux系统中，只有root用户有创建其他用户的权限。

#### 用户管理相关的命令

useradd、passwd、userdel、usermod、groupadd、groupdel、chown、chgrp

#### adduser和useradd的区别

- 使用`useradd`时，后面可以通过添加参数来创建用户
- 使用`adduser`时，创建用户的过程更像是一种人机对话，系统会提示你输入各种信息，然后会根据这些信息帮你创建新用户。

#### 使用adduser创建用户

主要参数：

- c：加上备注文字，备注文字保存在passwd的备注栏中
- d：指定用户登入时的主目录，替换系统默认值/home/<用户名>
- D：变更预设值。
- e：指定账号的失效日期，日期格式为MM/DD/YY，例如06/30/12。缺省表示永久有效。
- f：指定在密码过期后多少天即关闭该账号。如果为0账号立即被停用；如果为-1则账号一直可用。默认值为-1.
- g：指定用户所属的群组。值可以使组名也可以是GID。用户组必须已经存在的，期默认值为100，即users。
- G：指定用户所属的附加群组。
- m：自动建立用户的登入目录。
- M：不要自动建立用户的登入目录。
- n：取消建立以用户名称为名的群组。
- r：建立系统账号。
- s：指定用户登入后所使用的shell。默认值为/bin/bash。
- u：指定用户ID号。该值在系统中必须是唯一的。0~499默认是保留给系统用户账号使用的，所以该值必须大于499。

实战：

- 添加用户

  `useradd wujunnan`

- 给该用户设置密码

  `passwd wujunnan`

- 将该用户添加为超级管理员

### 用户的切换

- 注销当前用户

  ```
  gnome-session-quit --force
  ```

- 切换用户

  ```
  su - user
  ```

  `-`表示在切换用户时，同时切换掉当前用户的环境

  在执行 su - 指令时，高级用户向低级用户切换不需要密码，如root用户切换至student用户；而低级用户切换至高级用户以及平级用户之间的切换均需要输入密码

- 用户的查看

  ```
  whoami
  ```

  ```
  [root@VM-0-7-centos etc]# whoami
  root
  ```

  id指令

  ```
  [root@VM-0-7-centos etc]# id root
  uid=0(root) gid=0(root) 组=0(root)
  [root@VM-0-7-centos etc]# id elastic
  uid=1000(elastic) gid=1000(elastic) 组=1000(elastic)
  ```

- 用户授权

  给普通用户下放权力配置文件`/etc/sudoers`

[Reference](https://blog.csdn.net/panqidong95/article/details/95517278?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-1.control)

### wheel组

如果普通用户也能通过`su`来转换为root用户，那么将非常危险，所以我们希望剥夺被加入到wheel组用户以外的普通用户通过`su`登录为root的权利

所以我们找到` /etc/pam.d/su` 文件，找到`#auth required /lib/security/$ISA/pam_wheel.so use_uid `这一行，将行首的“#”去掉。

然后，再将用户添加到wheel组中。

这样以来，一个不属于wheel组的用户时，执行了su命令后，即使输入了正确的root密码，也无法登录为root用户

- 疑问：如果用户知道了root的密码，那么可以通过ssh登录root账户，那么上述问题就不成立

  所以一般都会限制root用户通过ssh登录

### sudo

sudo命令用来以其他身份来执行命令，预设的身份为root。在/etc/sudoers中设置了可执行sudo指令的用户。若其未经授权的用户企图使用sudo，则会发出警告的邮件给管理员。用户使用sudo时，必须先输入密码，之后有5分钟的有效期限，超过期限则必须重新输入密码。 



赋予普通用户root权限：

修改 /etc/sudoers 文件，找到下面一行

```
Allows people in group wheel to run all commands
root ALL=(ALL) ALL
```

然后添加一行，获取root权限aaa

```
aaa  ALL=(ALL)  ALL
```

修改完毕，现在可以用aaa帐号登录，然后用命令 sudo(选项)(参数) ，即可获得临时root权限进行操作。

ps:这里说下你可以sudoers添加下面四行中任意一条

```
  aaa       ALL=(ALL)         ALL
  %aaa      ALL=(ALL)         ALL
  aaa       ALL=(ALL)         NOPASSWD: ALL
  %aaa      ALL=(ALL)         NOPASSWD: ALL
```

- 第一行:允许用户qie执行sudo命令(需要输入密码)
- 第二行:允许用户组qie里面的用户执行sudo命令(需要输入密码)
- 第三行:允许用户qie执行sudo命令,并且在执行的时候不输入密码
- 第四行:允许用户组qie里面的用户执行sudo命令,并且在执行的时候不输入密码

现在让我们来看一下那三个ALL到底是什么意思。

- 第一个ALL是指网络中的主机，可以将它改成localhost=，它指明foobar可以在此主机上执行后面的命令。

- 第二个括号里的ALL是指目标用户，也就是以谁的身份去执行命令。

- 最后一个ALL是指命令名。例如，我们想让Danielr用户在linux主机上以jimmy或rene的身份执行kill命令

  ```
  Daniel   linux=(jimmy,rene)    /bin/kill
  ```

但这还有个问题，Daniel到底以jimmy还是rene的身份执行？这时我们应该想到了sudo -u了，它正是用在这种时候。 Daniel可以使用sudo -u jimmy kill PID或者sudo -u rene kill PID，但这样挺麻烦，其实我们可以不必每次加-u，把rene或jimmy设为默认的目标用户即可。再在上面加一行：

```
Defaults:foobar    runas_default=rene
```

Defaults后面如果有冒号，是对后面用户的默认，如果没有，则是对所有用户的默认。就像配置文件中自带的一行：

```
Defaults  env_reset
```

[Reference1](https://blog.csdn.net/q290994/article/details/77448626)

[Reference2](https://www.cnblogs.com/wazy/p/8352369.html)

### chmod

```
chmod（英文全拼：change mode）命令是控制用户对文件的权限的命令
```

```
[ugoa...][[+-=][rwxX]...][,...]
```

- u(uer)表示该文件的拥有者，g(group)表示与该文件的拥有者属于同一个群体(group)者，o(other)表示其他以外的人，a 表示这三者皆是。
- \+ 表示增加权限、- 表示取消权限、= 表示唯一设定权限。

Linux的文件调用分为三级：文件所有者、用户组、其他用户，只有文件所有者和超级用户可以修改文件或者目录的权限。

八进制语法：

历史上，文件权限被放在一个比特掩码中

rwx 

100 --- 4 --- 读

010 --- 2 --- 写

001 --- 1 --- 可执行

示例：

将文件 file1.txt 与 file2.txt 设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入 :

```
chmod ug+w,o-w file1.txt file2.txt
```

将目前目录下的所有文件与子目录皆设为任何人可读取 :

```
chmod -R a+r *
```

### umask

```
-S 　以文字的方式来表示权限掩码。
```

Linux umask命令指定在建立文件时预设的权限掩码。

umask可用来设定[权限掩码]。[权限掩码]是由3个八进制的数字所组成，将现有的存取权限减掉权限掩码后，即可产生建立文件时预设的权限。

```
➜  ~ umask
022
➜  ~ umask -S
u=rwx,g=rx,o=rx  #755  777-022即为755（创建文件夹）即rwxr-xr-x
# 创建文件默认权限为 666-022 = 644 即rw-r--r--
```

#### 关于默认权限

mac创建了一个文件和文件夹，默认如下：

```
-rw-r--r--   1 wujunnan  staff     0B  3 27 23:25 11.txt
drwxr-xr-x   2 wujunnan  staff    64B  3 27 23:26 111
```

在UNIX/Linux操作系统中，文件的创建者默认为文件属主，其默认权限为可读可写。

## 环境变量

在 Linux 系统中，环境变量是用来定义系统运行环境的一些参数，比如每个用户不同的家目录（HOME）、邮件存放位置（MAIL）等，值得一提的是，Linux 系统中环境变量的名称一般都是大写的，这是一种约定俗成的规范。

Linux export 命令

Linux export 命令用于设置或显示环境变量

```
export [-fnp][变量名称]=[变量设置值]
```

列出当前的环境变量

```
export -p
```

env命令用于显示系统中已存在的环境变量

```
env
```

[Reference](http://c.biancheng.net/view/5970.html)



## 其他

### except

sexcept是一个自动化交互的软件。

该脚本能够正常执行的分前提是安装了except

```
yum install -y expect
```

expect常用命令总结:

```
spawn               交互程序开始, 后面跟命令或者指定程序, 启动新的进程
expect              获取匹配信息匹配成功则执行expect后面的程序动作
send                用于发送指定的字符串
interact            退出自动话，进行人工交互
exp_continue        在expect中多次匹配就需要用到
send_user           用来打印输出 相当于shell中的echo
exit                退出expect脚本
eof                 expect执行结束 退出
set                 定义变量
puts                输出变量
set timeout         设置超时时间
```

示例：

ssh登录远程主机执行命令

```
#!/usr/tcl/bin/expect

#设置超时时间，默认为10秒
set timeout 30
#设置变量
set host "101.200.241.109"
set username "root"
set password "123456"
spawn ssh $username@$host
#判断上次的输出结果中是否包含指定字符串，如果有则立即返回，否则就等待一段时间后返回，即前面的30秒
expect "*password*" 
#执行交互动作
send "$password\r"
#执行完成后保持交互状态，将控制权交给控制台
interact
```

指定多条命令可以：

```
send "df -Th\r"
send "exit\r"
```



**模式动作**

即上述例子中的`expect "*password*" {send "$password\r"}`

简单的说就是匹配到一个模式，就执行对应的动作



### 管道符

管道“|”可将命令的结果输出给另一个命令作为输入之用





### reboot

```
reboot  用于用来重新启动计算机
```

### bc

在Mac终端进行一些简单的计算，可以使用bc命令

## shell

运行shell的两种方法

1. 作为可执行程序，

   要想运行一个`.sh`文件，要输入`./test.sh`而不是`test.sh`，运行其他二进制的程序也一样，直接写`test.sh`系统会进入PATH里面寻找有没有叫`test.sh`的，而只有 `/bin, /sbin, /usr/bin，/usr/sbin `等在 PATH 里，你的当前目录通常不在 PATH 里，所以写成 `test.sh` 是会找不到命令的，要用` ./test.sh` 告诉系统说，就在当前目录找，`.`代表当前目录

2. 作为解释器参数

### Shell中的$0的含义

简单来说 **$0** 就是你写的shell脚本本身的名字，**$1** 是你给你写的shell脚本传的第一个参数，**$2** 是你给你写的shell脚本传的第二个参数

例如：

创建一个脚本：

```shell
#!/bin/sh
echo "shell脚本本身的名字: $0"
echo "传给shell的第一个参数: $1"
echo "传给shell的第二个参数: $2"
```

在Test.sh所在的目录下输入 `bash Test.sh 1 2`

运行结果为：

```
shell脚本本身的名字: Test.sh
传给shell的第一个参数: 1
传给shell的第二个参数:  2  
```

### shell中的括号

括号一般在命令替换的时候使用

#### `()`

和``一样，用来做命令替换用

#### `(())`

- 双小括号在shell中的作用是进行基本的加减乘除，还有大于、小于、等于、或非与等运算
- $的作用是获取`(())`的结果
- 在`(())`中使用变量可以不用加`$`直接使用即可

#### `[]`

方括号定义来了测试条件，第一个方括号后和第二个方括号前都要加一个空格，否则会报错

用于条件的测试，可以用test命令来代替

方括号主要用于四类判断：

- 数值比较
- 字符串比较

- 文件比较

  | 比较            | 描述                                     |
  | --------------- | ---------------------------------------- |
  | -d file         | 检查file是否存在并是一个目录             |
  | -e file         | 检查file是否存在                         |
  | -f file         | 检查file是否存在并是一个文件             |
  | -r file         | 检查file是否存在并可读                   |
  | -s file         | 检查file是否存在并非空                   |
  | -w file         | 检查file是否存在并可写                   |
  | -x file         | 检查file是否存在并可执行                 |
  | -O file         | 检查file是否存在并属当前用户所有         |
  | -G file         | 检查file是否存在并且默认组与当前用户相同 |
  | file1 -nt file2 | 检查file1是否比file2新                   |
  | file1 -ot file2 | 检查file1是否比file2旧                   |

- 符合条件比较

#### `[[]]`

提供了字符串比较的高级特性，可以定义一些正则表达式来匹配字符串

#### `{}`

- 

- 获取子字符串

  比如str=”123″ 我要取23,正向取就是 echo ${str:1:2} 意思是从第一位往后开始不包括第一位，取两位。

##  vim

![image-20210711221111175](Linux_assets/image-20210711221111175.png)

Vim是从 vi 发展出来的一个文本编辑器。代码补完、编译及错误跳转等方便编程的功能特别丰富，在程序员中被广泛使用

- 快速查找

  在命令模式下，输入`/+要搜索的词`

  然后使用`n`键选取下一个
  
- vim如何删除一行或者多行内容

  - 删除单行：按ESC退出编辑模式，然后按两次d即可
  - 删除所有：退出编辑模式 `:1,$d`
  - 删除以#开头的注释内容 `:g/^#/d`
  - 删除所有空行 `:g/^$/d`
  
- 翻页

  - 整页翻页：

    `ctrl-f`  f就是forword

    `ctrl-b`  b就是backward

  - 翻半页：

    `ctrl-d`  d就是down

    `ctlr-u`  u就是up

- **i** 切换到输入模式，以输入字符
- 按下 ESC 按钮回到命令模式
- 在命令模式下按下:（英文冒号）就进入了底线命令模式
- 输入 **:wq** 即可保存离开

- 放弃所有修改

  `:e!`

  

IP地址

查看公网ip

- 通过终端

  ```
  curl ifconfig.me
  ```

- 通过网页

  [查看IP地址](https://www.ip138.com/)

## 软件安装

### RabbitMQ

[linux中RabbitMQ安装教程](https://www.cnblogs.com/jimlau/p/12029985.html)

rabbitMQ的安装位置

- rabbitMQ的日志位置

  ```
  /var/log/rabbitmq/rabbit@VM-0-7-centos.log
  ```

- rabbitMQ后台启动

  ```
  ./rabbitmq-server -detached
  ```


## Linux磁盘与文件管理系统

Linux的**EXT2**文件系统(inode)

操作系统的文件数据除了文件实际内容外， 通常含有非常多的属性，例如 Linux 操作系统的文件权限(rwx)与文件属性(拥有者、群组、时间参数等)。文件系统通常会将这两部份的数据分别存放在不同 的区块，权限与属性放置到inode中，至于实际数据则放置到data block区块中。 另外，还有一个超级区块 (superblock) 会记录整个文件系统的整体信息，包括inode与block的总量、使用量、剩余量等。

如果我的文件系统高达数百GB时， 那么将所有的 inode 与 block 通通放置在一起将是很不智的决定，因为 inode 与 block 的数量太庞大，不容易管理

#### Block

| **Block** 大小     | 1KB  | 2KB   | 4KB  |
| ------------------ | ---- | ----- | ---- |
| 最大单一文件限制   | 16GB | 256GB | 2TB  |
| 最大文件系统总容量 | 2TB  | 8TB   | 16TB |

Block的大小，大的话会造成浪费，小的话，大型文件会占用更多的block，inode也要记录更多的block，会导致文件系统读写性能下降。

基本限制如下:

- 原则上，block 的大小与数量在格式化完就不能够再改变了(除非重新格式化); 
- 每个 block 内最多只能够放置一个文件的数据;
- 承上，如果文件大于 block 的大小，则一个文件会占用多个 block 数量; 
- 承上，若文件小于 block ，则该 block 的剩余容量就不能够再被使用了(磁盘空间会浪费)。

基本上，inode 记录的文件数据至少有下面这些:

- 该文件的存取模式(read/write/excute); 
- 该文件的拥有者与群组(owner/group); 
- 该文件的容量; 该文件创建或状态改变的时间(ctime); 
- 最近一次的读取时间(atime); 
- 最近修改的时间(mtime); 
- 定义文件特性的旗标(flag)，如 SetUID...; 
- 该文件真正内容的指向 (pointer);

#### inode

inode要记录的数据非常多，但偏偏又只有128Bytes而已，而inode记录一个block号码要花掉4Byte，假设我一个文件有400MB且每个block为4K时，那么至少也要十万笔block号码的记录，为此我们的系统很聪明的将inode记录block号码的区域定 义为12个直接，一个间接, 一个双间接与一个三间接记录区。这样以来，当文件系统将block格式化为1K大小时，能够容纳的最大文件为16GB。

#### Superblock

他记录的信息主要有:

- block 与 inode 的总量;
- 未使用与已使用的inode/block数量;
- block与inode的大小 (block 为1, 2, 4K，inode为128Bytes或256Bytes); 
- filesystem 的挂载时间、最近一次写入数据的时间、最近一次检验磁盘 (fsck) 的时间等文件系统的相关信息;
- 一个valid bit数值，若此文件系统已被挂载，则valid bit为 0 ，若未被挂载，则valid bit为1。

一般来说，superblock的大小为1024Bytes。

#### 与目录树的关系

当我们在 Linux下的文件系统创建一个目录时，文件系统会分配一个 inode与至少一块block给该目录。其中，inode记录该目录的相关权限与属性，并可记录分配到的那块 block号码; 而block则是记录在这个目录下的文件名与该文件名占用的inode号码数据。

当我们在Linux下的ext2创建一个一般文件时，ext2会分配一个inode与相对于该文件大小的block 数量给该文件。例如:假设我的一个block为4 KBytes ，而我要创建一个100KBytes的文件，那么linux将分配一个inode与25个block来储存该文件! 

文件名的记录是在目录的block当中。 因此在第五章文件与目录的权限说明中， 我们才会提到“新增/删除/更名文件名与目录的 w 权限有关”的特色! 那么因为文件名是记录在目录的block当中， 因此，当我们要读取某个文件时，就务必会经过目录的inode与block，然后才能够找到那个待读取文件的 inode号码，最终才会读到正确的文件的block内的数据。

#### Linux文件系统的运行

如果你常常编辑一个好大的文件， 在编辑的过程中又频繁的要系统来写入到磁盘中，由于磁盘写入的速度要比内存慢很多， 因此你会常常耗在等待磁盘的写入/读取上。

为了解决这个效率的问题，因此我们的 Linux 使用的方式是通过一个称为异步处理 (asynchronously) 的方式。

能够将常用的文件放置到内存当中，这不就会增加系统性能吗? 没错!是有这样的想法!因此我们Linux 系统上面文件系统与内存有非常大的关系:

- 系统会将常用的文件数据放置到内存的缓冲区，以加速文件系统的读/写;
- 承上，因此 Linux 的实体内存最后都会被用光!这是正常的情况!可加速系统性能;
- 你可以手动使用 sync 来强迫内存中设置为 Dirty 的文件回写到磁盘中; 
- 若正常关机时，关机指令会主动调用 sync 来将内存的数据回写入磁盘内; 
- 但若不正常关机(如跳电、死机或其他不明原因)，由于数据尚未回写到磁盘内， 因此重新开机后可能会花很多时间在进行磁盘检验，甚至可能导致文件系统的损毁(非磁盘损毁)。

#### 挂载(mount)

挂载就是利用一个目录当进入点，将磁盘分区的数据放在该目录下，也就是说，进入该目录就读取该分区的意思。

例如，partition 1是挂载到根目录，至于partition 2则是挂载 到/home这个目录。 这也就是说，当我的数据放置在/home内的各次目录时，数据是放置到 partition 2的，如果不是放在/home下面的目录， 那么数据就会被放置到partition 1了。

每个filesystem都有独立的 inode/block/superblock等信息，这个文件系统要能够链接到目录树才能被我们使用。 将文件系统与目录树结合的动作我们称为“挂载”。

例如在，Windows下，插入一个U盘，电脑上显示F盘，这个设备与磁盘分区的关系，就是挂载。

其实判断某个文件在那个partition下面是很简单的，通过反向追踪即可。以上图来说， 当我想要知道/home/vbird/test这个文件在哪个partition时，由test --> vbird --> home --> /，看那 个“进入点”先被查到那就是使用的进入点了。 所以test使用的是/home这个进入点而不是/。

重点是: 挂载点一定是目录，该目录为进入该文件系统的入口。 因此并不是你有任何文件系统都能使用，必须要“挂载”到目录树的某个目录后，才能够使用该文件系统的。

从 CentOS 7.x 开始， 文件系统已经由默认的 Ext4 变成了xfs这一个较适合大容量磁盘与巨型文件性能较佳的文件系统了。



#### 链接

在 Linux下面的链接文件有两种，一种是类似Windows的捷径功能的文件，可以让你快速的链接到目标文件(或目录); 另一种则是通过文件系统的inode链接来产生新文件名，而不是产生新文件!这种称为实体链接 (hard link)。 

`ll`中的第三列数据其实就是，有多少个文件名链接到这个inode号码的意思

一般来说，使用hard link设置链接文件时，磁盘的空间与inode的数目都不会改变!

 hard link 是有 限制的:

- 不能跨 Filesystem; 
- 不能 link 目录。

相对于hard link ， Symbolic link 可就好理解多了，基本上，Symbolic link 就是在创建一个独立的文件，而这个文件会让数据的读取指向他 link 的那个文件的文件名!