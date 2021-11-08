# Linux

本文是本人从零开始的学习Linux的记录，目的是方便查阅记忆。

本文内容，一部分来自生产实践，一部分来自网络和《Linux命令行与shell脚本编程大全》，学习Linux基础，推荐这本书，结构清晰，语言精简，实用性强。

## 什么是Linux

Linus Torvalds在上学时 就开发了第一版Linux内核。起初他只是想仿造一款Unix系统而已，因为当时Unix操作系统在很多大学都很流行。

Linux可以划分为以下四个部分：

- Linux内核
- GNU工具
- 图形化桌面环境
- 应用软件

### Linux内核

内核主要负责以下四种功能：

- 系统内存管理
- 软件程序管理
- 硬件设备管理
- 文件系统管理

#### 系统内存管理

内核不仅管理服务器上的可用物理内存，还可以创建和管理虚拟内存。

内核通过**硬件上的存储空间**来实现虚拟内存，这块区域成为交换空间（swap space）。内核不断地在交换空间和实际的物理内存之间反复交换虚拟内存中的内容。这使得系统以为它拥有比物理内存更多的可用内存。

内存存储单元按组划分成很多块，这些块称作页面（page）。内核将每个内存页面放在物理内存或交换空间。然后，内核会维护一个内存页面表，指明哪些页面位于物理内存内，哪些页面被换到了磁盘上。

内核会记录哪些内存页面正在使用中，**并自动把一段时间未访问的内存页面复制到交换空间区域**（称为换出，swapping out）—— 即使还有可用内存。当程序要访问一个已被换出的内存页面时，内核必须从物理内存换出另外一个内存页面给它让出空间，然后从交换空间换入请求的内存页面。显然，这个过程要花费时间，拖慢运行中的进程。只要Linux系统在运行，为运行中的程序换出内存页面的过程就不会停歇。

#### 软件程序管理

Linux操作系统将运行中的程序称为进程。

内核启动了第一个进程（称为init进程）来启动任何其他进程当内核启动时，它会将init进程加载到虚拟内存中。内核在启动任何其他进程时，都会在虚拟内存中给新进程分配一块专有区域来存储该进程用到的数据和代码。

一些Linux采用/etc/init.d目录，将开机时启动或停止某个应用的脚本放在这个目录下。

```
ll /etc/init.d/
总用量 60
-rwxr-xr-x 1 root root 10867 5月  23 2020 clickhouse-server
-rw-r--r-- 1 root root 18281 5月  22 2020 functions
-rwxr-xr-x 1 root root  4569 5月  22 2020 netconsole
-rwxr-xr-x 1 root root  7928 5月  22 2020 network
-rw-r--r-- 1 root root  1160 2月   3 2021 README
-rwxr-xr-x 1 root root  5840 8月  11 13:59 srepagent
```

#### 硬件设备管理

内核的另一职责是管理硬件设备。任何Linux系统需要与之通信的设备，都需要在内核代码中加入其驱动程序代码。驱动程序代码相当于应用程序和硬件设备的中间人，允许内核与设备之间交换数据。在Linux内核中有两种方法用于插入设备驱动代码:

- 编译进内核的设备驱动代码
- 可插入内核的设备驱动模块

开发人员提出了内核模块的概念。它允许将驱动代码插入到运行中的内核而无需重新编译内核。同时，当设备不再使用时也可将内核模块从内核中移走。这种方式极大地简化和扩展了硬件设备在Linux上的使用。

Linux系统将硬件设备当成特殊的文件，称为设备文件。设备文件有3种分类: 

- 字符型设备文件

  字符型设备文件是指处理数据时每次只能处理一个字符的设备。大多数类型的调制解调器和终端都是作为字符型设备文件创建的。

- 块设备文件

  块设备文件是指处理数据时每次能处理大块数据的设备， 比如硬盘。

- 网络设备文件

  网络设备文件是指采用数据包发送和接收数据的设备，包括各种网卡和一个特殊的回环设备。这个回环设备允许Linux系统使用常见的网络编程协议同自身通信。

Linux为系统上的每个设备都创建一种称为节点的特殊文件。与设备的所有通信都通过设备节点完成。每个节点都有唯一的数值对供Linux内核标识它。数值对包括一个主设备号和一 个次设备号。类似的设备被划分到同样的主设备号下。次设备号用于标识主设备组下的某个特定设备。

### GNU工具

除了由内核控制硬件设备外，操作系统还需要工具来执行一些标准功能，比如控制文件和程序。Linus在创建Linux系统内核时，并没有可用的系统工具。然而他很幸运，就在开发Linux内核的同时，有一群人正在互联网上共同努力，模仿Unix操作系统开发一系列标准的计算机系统工具。

GNU(GNU是GNU’s Not Unix的缩写)项目的主旨在于为Unix系统管理员设计出一套类似于Unix的环境。GNU组织开发了一套完整的Unix工具，但没有可以运行它们的内核系统。将Linus的Linux内核和GNU操作系统工具 整合起来，就产生了一款完整的、功能丰富的免费操作系统。你也会在互联网上看到一些Linux纯粹主义者将其称为GNU/Linux系统，藉此向GNU组织所作的贡献致意。

供Linux系统使用的这组核心工具被称为coreutils(core utilities)软件包。

GNU/Linux shell是一种特殊的交互式工具。它为用户提供了启动程序、管理文件系统中的文件以及运行在Linux系统上的进程的途径。

在Linux系统上，通常有好几种Linux shell可用。不同的shell有不同的特性，有些更利于创建脚本，有些则更利于管理进程。所有Linux发行版默认的shell都是bash shell。bash shell由GNU项目开发，被当作标准Unix shell——Bourne shell(以创建者的名字命名)的替代品。bash shell的名称就是针对Bourne shell的拼写所玩的一个文字游戏，称为Bourne again shell。

## Linux 发行版

我们将完整的Linux系统包称为发行版，例如Red Hat的CentOS和Ubuntu等。

## 包管理

各种包管理器都利用一个数据库来记录各种相关内容：

- Linux系统上已安装了什么软件包
- 每个包安装了什么文件
- 每个已安装软件包的版本

软件包存储在服务器上，可以利用本地Linux系统上的PMS工具通过互联网访问。这些服务器称为仓库(repository)。

软件包通常会依赖其他的包，为了前者能够正常运行，被依赖的包必须提前安装在系统中，包管理工具将会检测这些依赖关系，并在安装需要的包之前先安装好所有额外的软件包。

### RPM

RPM (redhat package manager) 是Red Hat Linux推出的包管理器，能轻松的实现软件的安装，软件包管理器内部有一个数据库，其中记载着程序的基本信息，校验信息，程序路径信息等。

但是rpm的缺点就是无法解决软件直接复杂的依赖关系。

包命名

- 源程序的命名规范：`name-version.tar.{gz|bz2|xz}`

  例：`bash-4.3.1.tar.xz`

- RPM包的命名规范：`name-version-release.os.arch.rpm`

  例：`bash-4.3.2-5.el6.x86_64.rpm`

参数：

- `-i`

  表示安装

- `-q`

  查询指定包名

- `-a`

  查询所有

- `-h`

  以`#`号显示安装进度（hash）

- `-v`

  显示输出（verbosea）

- `-U`

  如果没有安装，则会安装

- `-e`

  移除（erase）一个安装包

举例：

- 安装rpm包

  ```
  rpm -ivh *.rpm
  ```

- 列出当前系统所有已安装的包

  ```
  rpm -qa
  ```

  配合grep

  ```
  rpm -qa | grep clickhouse
  ```

- 查询包安装生成的文件清单

  ```
  rpm -ql 包名
  ```

  注意，可以通过上面的grep命令获取包名完整名字，也可以通过tab键进行左匹配

- 查询某文件是哪个RPM包生成的

  ```
  rpm -qf
  ```

### yum

yum (Yellow dog Updater, Modified) ，是一个在Fedora和RedHat以及SUSE中的Shell前端软件包管理器。

yum使用Python语言写成，基于RPM包进行管理，可以通过HTTP服务器下载、FTP服务器下载、本地软件池的等方式获得软件包，可以从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系。

我们通常使用 `yum install` 命令来在线安装 **linux系统的软件**， 这种方式基于RPM包管理，能够从指定的服务器自动下载RPM包并且安装，可以自动处理依赖性关系，并且一次安装所有依赖的软件包。

用yum安装，实质上是用RPM安装，所以RPM查询信息的指令都可用。

参数：

- `-y`

  当询问`[y/d/N]`，自动选择`y`

安装软件：

- 查看已安装的软件包

  ```
  $ yum list installed
  ```

- 查看可用的epel源

  ```
  $ yum list | grep epel-release
  ```

- 安装 epel

  ```
  $ yum install -y epel-release
  ```

- 本地安装

  我们可以手动下载rpm安装文件并用yum安装

  ```
  $ yum -y localinstall clickhouse-*.rpm
  ```

卸载软件

- 删除软件包而保留其配置文件和数据文件

  ```
  $ yum remove package_name
  ```

- 删除软件和其他所有文件

  ```
  $ yum erase package_name
  ```

yum仓库

- 查看正在使用的仓库

  ```
  $ yum repolist
  ```

- 配置阿里镜像提供的epel源

  ```
  $ wget -O /etc/yum.repos.d/epel-7.repo  http://mirrors.aliyun.com/repo/epel-7.repo
  ```

- 查看所有的yum源

  ```
  $ yum repolist all
  ```

- 查看可用的yum源

  ```
  $ yum repolist enabled
  ```

**yum安装的软件位置**

一般来说，RPM默认安装路径如下

| Directory      | **Contents of Directory**                 |
| -------------- | ----------------------------------------- |
| /etc           | 一些配置文件的目录，例如/etc/init.d/mysql |
| /usr/bin       | 一些可执行文件                            |
| /usr/lib       | 一些程序使用的动态函数库                  |
| /usr/share/doc | 一些基本的软件使用手册与帮助文档          |
| /usr/share/man | 一些man page文件                          |

## wget

wget是Linux中的一个下载文件的工具，是GNU项目的之一，名字取自"World Wide Web" 和"get"

参数：

- `-O`

  指定下载文件名

- `-b`

  后台下载

举例：

- 下载文件

  ```
  $ wget http://cn.wordpress.org/wordpress-4.9.4-zh_CN.tar.gz
  ```

## man

**man (Manual) 命令用来访问存储在Linux系统上的手册页面。**在想要查找的工具的名称前面输入man命令，就可以找到那个工具相应的手册条目。

举例：

- 查看cp命令详解

  ```
  $ man cp
  ```

注意：

要想查看某个命令的用法，此种方式要优先于上网搜索网友总结的博客。

因为man给出了**权威**的解释、**语法结构**（如本文命令下对应的格式）以及简写选项对应的详细选项（例如：`-l --login`），很多博客忽略了命令的语法结构，尤其是复杂命令，这会让命令的记忆非常困难，要尽早习惯man讲解命令的方式，越早后续学习Linux命令就越轻松。

## 文件目录列表

### cd

举例：

- 回到上次打开的目录

  ```
  $ cd -
  ```
  
- 回到用户目录

  ```
  $ cd
  ```

### pwd

pwd (print work directory) 显示当前目录。

### mkdir

参数：

- `-p` 

  `--parents` 创建多个目录和子目录

- `-v`

  `--verbose` 每次创建新目录都显示信息

### ls

参数：

- `-a` 显示所有文件及目录 (`.` 开头的隐藏文件也会列出)
- `-l`  以列表方式显示
- `-h`  件大小单位显示，默认是字节

举例：

- 文件太多想查看想看的文件

  ```
  $ ls -l |grep data
  ```

注意：

1. 关于`ls -l`的排序方式

   - 无视字母之外的顺序（也就是说，就当数字和字母之外的字符，如中文、符号不存在）

   - 数字优先于字母，同位数字之间从小到大

     ```
     a1 > a1b > a2 > aa >aA
     ```

2. 关于`ls -l`中的total是什么？

   ```
   int total = （physical_blocks_in_use) * physical_block_size / ls_block_size
   ```

3. 关于`ls -l`每一列

   ```
   -rw-r--r--  1 root root 20110 2月   5 2021 config.xml
   ```

   - 文件类型，目录`d`、文件`-`
   - 文件的权限
   - 文件的硬链接总数
   - 文件属主
   - 文件属组
   - 文件大小
   - 文件上次修改时间
   - 文件名

### echo

举例：

- 使用`>`指令覆盖文件原内容并重新输入内容，若文件不存在则创建文件

  ```
  $ echo "Raspberry" > test.txt
  ```

- 使用>>指令向文件追加内容，原内容将保存

  ```
  $ echo "Intel Galileo" >> test.txt  
  ```

问题：

执行下面命令，提示权限不足：

```
$ sudo echo 你好 > test
-bash: test: 权限不够
```

解决办法：

```
sudo tee version.txt <<< 你好
```

### tree

用于生成目录的树形层级结构。

举例：

- 便利层级

  ```
  $ tree -L 2
  ```

- 只显示文件夹

  ```
  $ tree -d
  ```

## 操作文件

### touch

创建文件。

### cp

cp (copy file) ，用于复制文件或目录。

参数：

- `-i` 覆盖前询问（建议加此参数）
- `-R` 递归的复制整个目录

注意：

1. 在目标目录名尾部加上`/`，这表明destination是目录而不是文件，如果没有加`/`，而destination目录又不存在，那么反而会创建一个名为destination的文件，而且不会有任何提示。

   ```
   $ cp -i test_one Documents/
   ```

### ln

给一个物理文件的虚拟副本就是链接，链接是指向文件真实位置的占位符。

根据Linux文件系统：

- 每个文件都独自占用一个 inode，文件内容由 inode 的记录来指向
- 文件名记录在文件所在目录的 block 中
- 如果想要读取文件内容，就必须借助目录中记录的文件名找到该文件的 inode，才能成功找到文件内容所在的 block 块

ln 命令用于给文件创建链接，分为下面两种：

- 符号链接（symbolic link，软链接）

  类似于 Windows 系统中给文件创建快捷方式，即产生一个实实在在的文件，该文件用来指向另一个文件，此链接方式同样适用于目录。

  符号链接和原文件是两个完全不同的文件，可以看到俩个文件的inode编号和大小是不一样的。

  ```
  $ sudo ln -s test test_sym
  $ ls -li
  29360135 -rw-r--r-- 1 jinp jinp   16 10月 30 17:09 test
  29360136 lrwxrwxrwx 1 root root    4 10月 30 17:08 test_sym -> test
  ```

- 硬链接

  硬链接指的就是给一个文件的 inode 分配多个文件名，通过任何一个文件名，都可以找到此文件的 inode，从而读取该文件的数据信息。

  两个文件进行硬链接，会共享inode编号，并且这两个文件的链接计数（`ls -l`的第三项）都显示2。
  
  ```
  $ sudo ln test test_hard
  $ ls -li
  29360135 -rw-r--r-- 2 jinp jinp   16 10月 30 17:09 test
  29360135 -rw-r--r-- 2 jinp jinp   16 10月 30 17:09 test_hard
  ```

命令格式：

```
ln [OPTIONS] FILE LINK
```

如果LINK参数没有写，那么就会在本文件夹内创建一个同名链接。

参数：

- `-s` 

  建立符号链接文件。如果不加此选项，则建立硬链接文件

- `-f` 

- 强制，如果目标文件已经存在，则删除目标文件后再建立链接文件

举例：

- 删除软连接

  ```
  # 注意结尾不能加/
  $ rm redis
  ```

**注意**：

1. 只能对处于同一存储媒体的文件创建硬链接，要想在不同的存储媒介的文件之间创建链接，只能用符号链接。

2. 符号链接文件的源文件必须写成绝对路径，而不能写成相对路径（硬链接没有这样的要求）

3. **删除软链接的时候，后面不能加`/`，不然删除的就是原目录了**

4. 权限问题，发现当修改符号链接的属主的时候，修改的实际上是原文件

   ```
   $ ll
   -rw-r--r-- 1 root root   16 10月 30 17:09 test
   lrwxrwxrwx 1 root root    4 10月 30 17:08 test_sym -> test
   
   $ sudo chown jinp:jinp test_sym
   
   $ ll
   -rw-r--r-- 1 jinp jinp   16 10月 30 17:09 test
   lrwxrwxrwx 1 root root    4 10月 30 17:08 test_sym -> test
   ```

### mv

参数：

- `-i` 

  同cp命令，覆盖前询问

- `-t` 

  `--target-directory` 一次移动多个文件

举例：

移动：

- 将root文件夹下的所有文件都移动到当前文件夹

  ```
  $ mv /root/* .
  ```

  注意：用户使用该指令复制目录时，必须使用参数 **-r** 或者 **-R** 。

- 移动多个文件，将a，b移动到c中

  - ```
    $ mv a b c_dir
    ```

  - ```
    $ mv a b -t c_dir
    ```

  - ```
    $ mv -t c_dir a b
    ```

    `-t`后面必须紧接着要移动的目录

重命名：

- 将文件 aaa 改名为 bbb

  ```
  $ mv aaa bbb
  ```

  目标目录与原目录一致，则指定了新文件名，效果仅仅是重命名。

  ```
  $ mv /home/ffxhd/a.txt /home/ffxhd/b.txt    
  ```

- 目标目录与原目录不一致，没有指定新文件名，效果就是仅仅移动。

  ```
  $ mv  /home/ffxhd/a.txt /home/ffxhd/test/ 
  或者
  $ mv  /home/ffxhd/a.txt /home/ffxhd/test 
  ```

- 目标目录与原目录一致, 指定了新文件名，效果就是：移动 + 重命名。

  ```
  $ mv  /home/ffxhd/a.txt /home/ffxhd/test/c.txt
  ```

### rm

参数：

- `-i` 删除前确认
- `-f` 多个文件不需要提醒，强制删除
- `-r` 同`-R` 递归删除目录

一口气删除终极大法（危）

```
$ rm -rf
```

注意：

1. bash shell中没有回收站或垃圾箱，文件一旦删除，就无法再找回。因此，在使用rm命令时，特别是通配符删除的时候，要养成总是加入`-i`参数的好习惯。

### 解压/压缩

- tar

  Unix和Linux上最广泛使用的归档工具，tar命令最开始是用来将文件写到磁带设备上归档的，然而它也能把输出写到文件里，这种用法在Linux上已经普遍用来归档数据了，这是Linux中分发开源程序源码文件所采用的普遍方法。

  参数：

  - `-x` 解压

  - `-c` 

    `-create` 创建一个新的tar归档文件

  - `-v` 处理时显示文件

  - `-f` file 输出结果到文件

  - `-z` 将输出重定向给gzip命令来压缩内容

  打包（这个不叫压缩）

  ```
  $ tar -cvf FileName.tar DirName
  ```

  解包

  ```
  $ tar -xvf FileName.tar
  ```

  打包多个文件

  ```
  $ tar -czvf bak.tar.gz users/ config.xml jobs/ plugins/
  ```

  解压`tar.gz`/`tgz`

  这些是gzip压缩过的tar文件

  ```
  $ tar -zxvf filename.tgz
  ```

  压缩

  ```
  $ tar -zcvf FileName.tar.gz DirName
  ```

- gz

  GNU压缩工具，用Lempel-Ziv编码，属于无损压缩（lossless compression）

  压缩

  ```
  $ gzip FileName
  ```

  解压

  ```
  $ gunzip FileName.gz 
  $ gzip -d FileName.gz 
  ```

  关于压缩比率

  我的实际测试如下（数据库数据文件，不同文件会有差异）：

  ```
  -rw-r--r--  1 root       root        11G 11月  2 21:48 data_pro.gz.tar
  -rw-r--r--  1 root       root        18G 11月  2 21:17 data_pro.tar
  ```

  gz压缩要比tar直接打包慢的多，需要20分钟左右，tar只需2分钟左右。

- zip

  Windows上PKZIP工具的Unix实现

  压缩：

  ```
  $ zip FileName.zip DirName 
  ```

  批量将文件解压到对应的目录

  ```
  $ unzip -d /app tomcat-all.zip
  ```

解压错怎么办？

列出该压缩文件中的文件列表，根据文件列表来删除文件

- unzip

  ```
  $ zipinfo -1 ./ShareWAF.zip(误解压文件) | xargs rm -rf
  ```

- tar

  ```
  $ tar -tf 误解压文件 | xargs rm -rf
  ```

## 查看文件

### cat

cat (concatenate，连接) ，显示文件内容。

参数：

- `-n` 加上行号

举例：

- 从键盘创建一个文件

  ```
  $ cat > filename
  ```

- 将几个文件合并为一个文件

  ```
  $ cat file1 file2 > file
  ```

### more

cat命令的缺陷就是，一旦运行，无法控制，more命令会显示文本文件的内容，但会在显示每页数据之后停下来。

### less

less (less is more) ，more命令的升级版，less在刚开始不会读取整个文件，less命令支持上下翻页键。

command：

- `g`

  跳转到文件的第1行

  `20g` 跳转到第20行

- `G`

  跳转到文件的最后一行（大文件会很慢）

- `ENTER/e/↓`

  向前跳转1行

- `y/↑`

  想后跳转1行

- `b/PageDown`

  向后跳转一个屏幕的

- `d/PageUp`

  向前跳转N行，默认是半屏幕的大小

- `p`

  跳转到`N%`

  `20p`，跳转到20%

- `NUM`

  跳转到第NUM行

- `q`

  退出

### tail

默认显示文件的后10行。

参数：

- `-n` 显示的行数
- `-f` 实时监控

### head

查看文件的前几行，默认也是10行。

- `-n` 显示的行数

### od

od (octal, decimal, hex, ASCII dump) ，用于输出文件内容，并将其内容以八进制字码呈现出来。用于检查文件中不能直接显示显示在终端的字符（换行符等）。

```
od [-A 地址进制] [-t 显示格式] 文件名
```

参数：

- `-A` 地址基数，od命令的输出最左侧的1列为偏移量。默认的偏移量使用8进制，可以使用`-A`进行修改
  - `o` 八进制（默认）
  - `d` 十进制
  - `x` 十六进制
  - `n` 不打印位移值
- `-t` 指定数据显示的格式
  - `c` ASCII字符或反斜杠序列
  - `d` 有符号十进制数

举例：

test.txt内容如下（末尾有个换行符）：

```
1\n2

```

- 以ASCII码的形式显示文件test.txt中的内容

  ```
  $ od -tc test.txt
  0000000    1   \   n   2  \n
  0000005
  ```

- 使用ASCII码进行输出

  ```
  $ od -td1 test.txt
  0000000    49  92 110  50  10
  0000005
  ```

### sorts

对数据进行排序，按照规则对文本文件中的数据行进行排序。

- `-n` 按数字排序

- `-M` 按月排序

  当日志文件按照月份在前的时候，可以使用该参数

### grep

grep (global search regular expression(RE) and print out the line) ，查找输入或者指定文件中符合匹配的字符的行。

参数：

- `-v` 

  反向搜索，输出不匹配的行

- `-n` 

  显示匹配行的行号

- `-c` 

  一共多少行匹配

- `-e` 

  指定多个匹配

- `-C NUM, -NUM, --context=NUM`

  打印匹配行的上下`NUM`行

- `-A NUM, --after-context=NUM`

  打印匹配行的后`NUM`行

- `-B NUM, --before-context=NUM`

  打印匹配行的前`NUM`行

常用：

- 搜索`/usr/src/linux/Documentation`目录下搜索带字符串`magic`的行：

  ```
  $ grep magic /usr/src/linux/Documentation/*
  ```

- 输出含有字符`t`或`f`的所有行

  ```
  $ grep -e t -e f file1
  ```
  
- 输出日志中含有`kungeek.com`字符串的上下2行

  ```
  $ tail data-web.log |grep -2 kungeek.com
  ```

### find

举例：

- 在目录下査找文件名是`yum.conf`的文件（按照文件名搜索，不区分文件名大小）

  ```
  $ find /-name yum.conf
  ```

- 指定递归深度

  ```
  $ find ./test -maxdepth 2 -name "*.php"
  ```

### locate

```

```

### stat

stat用来查看文件的详细信息

格式：

```
stat [OPTION]... FILE...
```

参数：

- `-f`

  查看文件所在的文件系统信息

例如：

- 查看指定文件的信息

  ```
  $ stat data_web
    文件："data_web"
    大小：4096      	块：8          IO 块：4096   目录
  设备：fd01h/64769d	Inode：1088035     硬链接：6
  权限：(0757/drwxr-xrwx)  Uid：(  994/clickhouse)   Gid：(  993/clickhouse)
  最近访问：2021-10-30 13:56:52.690695999 +0800
  最近更改：2021-10-30 13:56:02.770794238 +0800
  最近改动：2021-10-30 13:56:02.770794238 +0800
  创建时间：-
  ```

  - 大小：文件占用多少个字节
  - 块：文件占用了多少个block
  - IO块：每个block多大
  - 文件类型：文件/目录...
  - 设备：设备号码的十六进制和十进制
  - Inode：Inode号码
  - 硬链接：硬链接数
  - ...

- 同时可以查看目录下所有文件的信息

  ```
  $ stat *
  ```

- 查看文件所在的文件系统的信息

  ```
  $ stat -f data_web
    文件："data_web"
      ID：47d795d8889d00d3 文件名长度：255     类型：ext2/ext3
  块大小：4096       基本块大小：4096
      块：总计：12868467   空闲：9124416    可用：8575105
  Inodes: 总计：3276800    空闲：3063657
  ```

  - 块大小：该文件系统每个block的大小

## 文本处理

### seq

格式：

```
seq [选项]... 首数 增量 尾数
```

例如：

- 从1到5输出

  ```
  $ seq 5
  ```

- 从1开始，步数为2，最大到10

  ```
  $ seq 1 2 10
  ```

- 一次性创建5个名为dir001，dir002 ... dir010这10个目录

  ```
  mkdir $(seq -f 'dir%03g' 1 10)
  ```

  或

  ```
  seq -f 'dir%03g' 1 10 | xargs mkdir
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

### sed

详见文档[Shell脚本](Shell脚本)

### awk

详见文档[Shell脚本](Shell脚本)

### tee

tee读取STDIN然后将其输出到STDOUT和指定的文件中。

##  vim

vim编辑器有两种操作模式：

- 普通模式

  在普通模式下，vim会将按键解释为命令。

  普通模式下有个特别的功能叫做命令行模式，提供一个交互式命令行，可以输入额外的命令来控制vim的行为。

  要进入命令行模式，在普通模式下按下`:`

- 插入模式

**vim基础**

移动光标 ：

- 整页翻页

  `Ctrl+F`  (F就是forword) 或 `PageDown`

  `Ctrl-B`  (B就是backward) 或 `PageUp`

- 翻半页

  `ctrl-d`  d就是down

  `ctlr-u`  u就是up

- 移到缓冲区的最后一行

  `G`

- 移到缓冲区的第num行

  `num G`

- 移到缓冲区的第一行

  `gg`

- H (high) 光标移到屏幕顶端

  `H`

- M (middle) 光标移动道屏幕中央

  `M`

- L (low) 光标移动到屏幕底端

  `L`

保存文件：

- 放弃所有修改

  `:e!`

- 如果未修改缓冲区数据，退出

  `:q`

- 放弃所有修改并推出

  `:q!`

**编辑数据**

vim如何删除一行或者多行内容

- 删除当前光标所在位置的字符

  `x`

  删除光标当前位置开始的两个字符

  `2x`

- 删除当前光标所在位置的单词

  `dw`

- 删除当前光标所在位置至行尾的内容

  `d$`

- 删除单行

  `dd`

  删除从光标当前所在行开始的5行

  `5dd`

- 撤销前一编辑命令

  `u`

- 删除所有

  `:1,$d`

- 删除以#开头的注释内容 

  `:g/^#/d`

- 删除所有空行

  `:g/^$/d`

**复制和粘贴**

- 允许粘贴

  `:set paste`

- 剪切粘贴

  可以使用`dd`命令来删除一行文本，然后把光标移动到要粘贴的位置，然后用`p`将文本插入到当前行之后。

- 复制粘贴

  `yw` 复制一个单词，`y$`表示复制到行尾，复制以后，使用`p`进行粘贴。

- 可视复制

  - 先将光标移到想复制的开始位置
  - 按下`v`键，然后移动光标
  - 按下`y`，激活复制命令，现在寄存器中已经有了要复制的文本
  - 光标移到到你想放置的位置，按下`p`

**查找和替换**

- 查找

  输入`/+要搜索的词`，然后使用`n`键选取下一个

- 替换

  - `:s/old/new/`

    vim编辑器会跳到old第一次出现的地方，并用new来替换。

  - `:s/old/new/g:`

    替换所有old。

**其他**

- 开启行号

  ` :set nu`

## 监测

### ps

ps (process status) 查看进程。

参数：

- `-e` 显示系统内的所有进程信息
- `-f` 使用完整的（full）格式显示进程信息

举例：

- 批量杀死name线程

  ```
  $ ps -ef|grep name|awk '{print $2}'|xargs kill -9
  ```

列表说明：

```
$ ps -ef| grep test
jinp      1577 11751  0 23:05 pts/0    00:00:00 grep --color=auto test
```

- UID：启动该进程的用户
- PID：进程的进程ID
- PPID：父进程的进程号
- C：进程生命周期中的CPU利用率
- STIME：进程启动时的系统时间
- TTY：进程启动时的终端设备
- TIME：运行进程需要的累积CPU时间
- CMD：启动的程序名称

### jps

**jps** (Java Virtual Machine Process Status Tool) 是java提供的一个显示当前所有java进程pid的命令。

### top

ps不足之处就是只能显示某个特定时间点的信息，如果想观察那些频繁换进换出的内存的进程趋势，可以使用top，实时显示。

默认情况下，top命令在启动时会按照%CPU值对进程排序。

在top命令运行时键入可改变top的行为。键入f允 许你选择对输出进行排序的字段，键入d允许你修改轮询间隔。键入q可以退出top。

例如：

```
 PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 9524 clickho+  20   0   30.4g 438964 214568 S   1.3  1.4   1677:19 clickhouse-serv
16585 jinp      20   0   11.7g   2.9g  12020 S   0.7  9.5  22:34.80 java
18046 jinp      20   0   11.6g   3.1g  11900 S   0.7 10.1  18:35.71 java
```

- PR：进程的优先级
- NI：进程的谦让度值
- VIRT：进程占用的虚拟内存总量
- RES：进程占用的物理内存总量
- SHR：进程和其他进程共享的内存总量
- S：进程的状态
  - D：代表可中断的休眠状态
  - R：代表在运行状态
  - S：代表休眠状态
  - T：代表跟踪状态或停止状态
  - Z：代表僵化状态
- %CPU：进程使用的CPU时间比例
- %MEM：进程使用的内存占可用内存的比例
- TIME+：自进程启动到目前为止的CPU时间总量
- COMMAND：进程所对应的命令行名称，也就是启动的程序名

### kill

停止一个线程。

信号：

- 1：挂起
- 2：中断
- 3：结束运行
- 9：无条件终止

### df

df (disk free) ，用来检查Linux文件系统的占用情况。

- `-h` 方便阅读方式显示（以较易阅读的格式显示）

```
$ df -h
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

### du

du (disk usage) ，通过df命令很容易发现哪个磁盘的存储空间快没了，下一步，du命令可以显示某个特定目录（默认情况下是当前目录）的磁盘使用情况。

- `-c` 显示所有已列出文件总的大小
- `-h` 按用户易读的格式输出大小
- `-s`  显示每个输出参数的总计

举例：

- 查看当前文件夹多大

  ```
  $ du -hs
  ```

### free

free 命令显示系统内存的使用情况。

- `-h` 　以易读的方式显示内存使用情况

### netstat

它跟 netstat 差不多，但有着比 netstat 更强大的统计功能

```
$ netstat -anp|grep 8005
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

查看端口占用

```
$ netstat -tunlp |grep 9200
```

### ss

ss (Socket Statistics)

```
$ ss -antp | grep java | column -t
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

lsof (list open files) ，一个列出当前系统打开文件的工具。

举例：

- 查看9999对应的端口

  ```
  $ lsof -i :9999
  ```

### 查看Linux的配置

#### 核心数

- 查看物理CPU数

  ```
  $ cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l
  ```

- 查看每个物理CPU中core的个数(即核数)

  ```
  $ cat /proc/cpuinfo| grep "cpu cores"| uniq
  ```

  总核数 = 物理CPU个数 X 每颗物理CPU的核数

#### 查看CPU信息

```
$ cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
```

#### 查看操作系统版本

```
$ cat /etc/centos-release
```

## 网络

### 测试远程端口

#### telnet

```
$ telnet ip port
```

telnet之后如何退出？

先按`ctrl+]`然后输入`quit`

#### nmap

```
$ nmap ip -p port
```

#### nc

```
$ nc -v ip port
```

### ssh

SSH  (Secure Shell)，专为远程登录会话和其他网络服务提供安全性的协议，如果一个用户从本地计算机，使用SSH协议登录另一台远程计算机，我们就可以认为，这种登录是安全的，即使被中途截获，密码也不会泄露，目前已经成为Linux系统的标准配置。

```
ssh <username>@<hostname or IP address>
```

参数：

- `-p` ssh默认端口为22，指定端口

举例：

- 使用2222端口登陆

  ```
  $ ssh -p 2222 user@host
  ```

### 配置ssh免密登陆

### ssh-keygen

ssh-keygen命令用于为ssh生成、管理和转换认证密钥，它支持RSA和DSA两种认证密钥。

参数：

- `-b` 指定密钥长度
- `-t` 指定要创建的密钥类型
- `-C` 添加注释
- `-f` 指定用来保存密钥的文件名

配置步骤：

1. 生成RSA类型私钥公钥

   ```
   ssh-keygen -t rsa -C "wujunnan@kungeek.com"
   ```

   注意，一般接下来的两个都回车处理即可，即使用默认名字（`id_rsa`），默认位置（`./ssh`），不使用密钥密码，会默认生成`id_rsa`和`id_rsa.pub`

2. 将生成的公钥上传到目标服务器上

   - 方法一：将上步骤生成的`id_rsa.pub`复制到目标服务器的`~/.ssh/authorized_keys`

   - 方法二：使用ssh-copy-id工具

     ```
     $ ssh-copy-id username@remote-server
     ```

     举例：

     ```
     $ ssh-copy-id -i id_rsa.pub jinp@172.27.0.8
     ```

注意：

1. 私钥默认放在`.ssh`下才会生效

2. 如果是想通过ssh免密git操作，将上述的步骤二换成将公钥保存到相关git远程仓库即可

3. github没有我的私钥，他是怎么解密我加密过的数据呢

   你用私钥加密的东西，GitHub用公钥可以解开，能解开说明你有对应的私钥，就是上传公钥那个人

### scp

scp是secure copy的简写，用于在Linux下进行远程拷贝文件的命令

**上传命令**

```
$ scp local_file remote_ip:remote_folder 
```

**多文件传输**

- 多个文件用空格分割

  ```
  $ scp execute.sh jenkins.war jinp@172.27.0.8:
  ```

- 从本地文件复制整个文件夹到远程主机上（文件夹假如是diff）
  先进入本地目录下，然后运行如下命令：

  ```
  $ scp -v -r diff root@192.168.1.104:/usr/local/nginx/html/webs
  
  $ scp -r /Users/wujunnan/develop/WWW/zookeeper-3.4.6 root@wujunnan.net:/usr/local/zookeeper
  ```

- 使用压缩来加快传输
  在文件传输的过程中，我们可以使用压缩文件来加快文件传输，我们可以使用 C选项来启用压缩功能，该文件在传输过程中被压缩，
  在目的主机上被解压缩。

  ```
  $ scp -vrC diff root@192.168.1.104:/usr/local/nginx/html/webs
  ```

**从远程主机复制到本机**

从远程主机复制文件到本地主机(下载)的命令如下：（假如远程文件是about.zip）
先进入本地目录下，然后运行如下命令：

```
$ scp root@192.168.1.104:/usr/local/nginx/html/webs/about.zip .
```

注意：

1. zsh中scp命令的通配符`*`不能，`scp ip:/home/tommy/* .`命令在bash下可以执行，但是zsh下却不能识别通配符

   shell不会按照远程地址上的文件去扩展参数，当你使用`ip:/home/tommy/`，因为本地当前目录中，不存在`ip:/home/tommy/*`，所以匹配失败。默认情况下，bash在匹配失败时就使用原来的内容，zsh则报告一个错误。在zsh中执行`setopt nonomatch` 则告诉它不要报告`no matches`的错误，而是当匹配失败时直接使用原来的内容。

   实际上，不管是 bash 还是 zsh，不管设置了什么选项，只要把`ip:/home/tommy/*`加上引号，就可解决问题。

   [reference](https://forum.ubuntu.org.cn/viewtopic.php?t=284253)

### 防火墙

- 查看防火墙状态

  ```
  $ systemctl status firewalld
  #下面表示未开启防火墙
Active: inactive (dead)
  ```

- 开启防火墙

  ```
  $ systemctl start firewalld
  ```

- 开启端口

  ```
  $ firewall-cmd --permanent --zone=public --add-port=8080/tcp
  ```

  没有 --perman此参数重启后失效

- 查看端口

  ```
  $ firewall-cmd --permanent --query-port=8080/tcp
  ```

  提示yes，即查询成功

- 重启防火墙

  ```
  $ firewall-cmd --reload
  ```

- 查看已经开放的端口

  ```
  $ firewall-cmd --list-ports 
  ```

- 关闭防火墙端口

  ```
  $ firewall-cmd --zone=public --remove-port=3338/tcp --permanent
  ```

- 设置防火墙开机自动启动

  ```
  $ systemctl enable firewalld
  ```

- 开机禁用防火墙

  ```
  $ systemctl disable firewalld
  ```

```
$ service iptables status
```

### curl

curl来自client的URL工具，用于请求Web服务器

参数：

- `-X`

  `--request`

  指定要使用的请求动作，默认为get

  例如：

  ```
  $ curl -X POST www.example.com
  ```

  POST请求携带表单：

  ```
  $ curl -X POST --data "data=xxx" example.com/form.cgi
  ```

- `-L`

  `--location` 

  参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向。

- `-H`

  `--header`

  添加请求头

  例如：

  ```
  $ curl 'https://hxduat.kungeek.com/openapi/event/tracking' --header 'Authorization: xxxxxx'
  ```

- `-b`

  `--cookie`

  携带cookie

  例如：

  ```
  $ curl --cookie "name=xxx" www.example.com
  ```

- `-O`

  参数将服务器回应保存成文件，并将 URL 的最后部分当作文件名。

## Shell

系统启动什么样的shell程序取决于你个人的用户ID配置。在/etc/passwd文件中，在用户ID记录的第7个字段中列出了默认的shell程序。

### Shell的父子关系

用于登录某个终端或GUI中启动终端时所启动的默认的交互shell，是一个父shell。

在提示符后输入`bin/bash`命令或其他等效的bash命令的时候，会创建一个新的shell程序，这个shell程序被称为子shell。

在生成子shell进程时，只有部分父进程的环境被复制到子shell环境中，下面的环境变量将讲解。

要想知道是否生成了子shell，得借助一个使用了环境变量的命令。

这个命令就是`echo $BASH_SUBSHELL`。如果该命令返回0，就表明没有子shell。如果返回1或者其他更大的数字，就表明存在子shell。

#### exit

exit命令用于退出子shell，当在父shell中输入exit的时候，就是退出CLI了。

#### jobs

也可以使用jobs命令来显示当前运行在后台模式中的所有用户的进程。

```
$ jobs
[1]+  运行中               sleep 300 &
```

参数：

- `-l`

  查看更多信息

  ```
  jobs -l
  [1]+  4770 运行中               sleep 300 &
  ```

#### 后台模式

在交互式shell中，一个高效的子shell用法就是使用后台模式。

在后台模式中运行命令可以在处理命令的同时让出CLI，以供他用，想要命令置入后台模式，可以在命令末尾上加上字符`&`。

第一条信息时显示在方括号中的后台作业号，第二条是后台作业的进程ID。

```
$ sleep 300&
[1] 4770
```

ps查看进程：

```
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
jinp      4770 14033  0 19:05 pts/1    00:00:00 sleep 300
jinp      4778 14033  0 19:05 pts/1    00:00:00 ps -f
jinp     14033 14032  0 13:17 pts/1    00:00:00 -bash
```

注意，当后台进程运行时，它仍然会使用终端显示器来显示STDOUT和STDERR消息。最好是将后台运行的脚本的STDOUT和STDERR进行重定向，避免这种杂乱的输出。

##### nohup

nohup (no hang up) 不挂断的运行命令

nohup命令运行了另外一个命令来阻断所有发送给该进程的SIGHUP信号。这会在退出终端会话时阻止进程退出。

```
$ nohup ./test1.sh &
[1] 3856
$ nohup: ignoring input and appending output to 'nohup.out'
```

和普通后台进程一样，shell会给命令分配一个作业号，Linux系统会为其分配一个PID号。区别在于，当你使用nohup命令时，如果关闭该会话，脚本会忽略终端会话发过来的SIGHUP信号。

nohup命令会自动将STDOUT和STDERR的消息重定向到一个名为nohup.out的文件中。

三种运行方式的区别：

- `nohup /opt/jdk1.8.0_131/bin/java -jar ggg.jar` 

  回车之后，将日志文件输出到nohup.out文件中，若执行control+c或者关闭终端，进程将终止

- `nohup /opt/jdk1.8.0_131/bin/java -jar ggg.jar &`

  回车之后，会输出进程号，以及提示日志输出在nohup.out文件中，若执行control+c或者关闭终端，进程仍在运行

- `nohup command > myout.file 2>&1 &`

  在上面的例子中，输出被重定向到myout.file文件中。

- `nohup ./filebeat  -e -c filebeat.yml -d "publish" >/dev/null  2>&1 &`

  - 2>&1的意思 

    这个意思是把标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。 至于为什么需要将标准错误重定向到标准输出的原因，那就归结为标准错误没有缓冲区，而stdout有。这就会导致 >output 2>output 文件output被两次打开，而stdout和stderr将会竞争覆盖，这肯定不是我门想要的

  - /dev/null文件的作用，这是一个无底洞，任何东西都可以定向到这里，但是却无法打开。 所以一般很大的stdou和stderr当你不关心的时候可以利用stdout和stderr定向到这里>./command.sh >/dev/null 2>&1 

### 外部命令

外部命令，有时候也被称为文件系统命令，是存在于bash shell之外的程序。它们并不是shell 程序的一部分。外部命令程序通常位于`/bin`、`/usr/bin`、`/sbin`或`/usr/sbin`中

例如`ps`就是一个外部命令，可以通过which命令来查找它

当外部命令执行时，会创建出一个子进程。这种操作被称为衍生(forking)。外部命令ps很方便显示出它的父进程以及自己所对应的衍生子进程。

```
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
jinp      9423 11751  0 00:14 pts/0    00:00:00 ps -f
jinp     11751 11750  0 9月04 pts/0    00:00:00 -bash
```

可以看到，`ps -ef`的父进程为`-bash`

```
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
jinp       851 14033  0 18:50 pts/1    00:00:00 ps -f
jinp     14033 14032  0 13:17 pts/1    00:00:00 -bash

$ bash

$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
jinp       883 14033  1 18:50 pts/1    00:00:00 bash
jinp       924   883  0 18:50 pts/1    00:00:00 ps -f
jinp     14033 14032  0 13:17 pts/1    00:00:00 -bash
```

#### which

which指令会在环境变量`$PATH`设置的目录里查找符合条件的文件。

外部命令，也就是存在于bash shell之外的程序，可以通过which命令查找

举例：

- 查找java命令的位置

  ```
  $ which java 
  /data/jdk1.8.0_151/bin/java
  ```

#### type

解某个命令是否是内建的

```
$ type cd
cd is a shell builtin
```

### 内建命令

内建命令和外部命令的区别在于前者不需要使用子进程来执行。它们已经和shell编译成了一体，作为shell工具的组成部分存在。

cd和exit命令都内建于bash shell。可以利用上面type命令来了解某个命令是否是内建的。

内建命令的执行速度要更快，效率也更高。

注意：

有些命令有多种实现，例如echo和pwd即有内建命令又有外部命令，可以使用如下命令查看：

```
$ type -a pwd
pwd 是 shell 内嵌
pwd 是 /usr/bin/pwd
```

如果想要外部命令实现，直接输入`/usr/bin/pwd`

一些有用的内建命令：

#### history

显示最近输入的命令。

默认显示1000条，修改环境变量`HISTSIZE`可以更改这个设置。

#### alias

为命令起别名

参数：

- `-p`

  查看可用的别名

创建命令别名

```
alias li='ls -li'
```

### sh

参数：

- `-e`

  指示shell在命令行返回非0的结果的时候停止

- `-u`

  shell在遇到未定义的变量的时候，会报错

- `-x`

  打印所执行的命令行

- `-v`

  显示shell所读取的输入值

- `+`

  取消某个set设置的参数

### eval

在bash中，反引号和`$()`都是用来做命令替换的，命令替换就是重组命令，先完成引号里面的命令，然后将其结果替换出来，再重组成新的命令行。

也就是说，在执行一条命令的时候，会先将其中的反引号或者`$()`中的语句当成命令执行一遍，再将结果加到原命令中重新执行。

例如：

```
$ echo ls
ls
$ echo `ls`
X11 X11R6 bin lib libexec local sbin share standalone
```

eval命令适用于那些一次扫描无法实现其功能的变量。该命令对变量进行两次扫描

例如：

```
$  ls
file
$  cat file
hello world
$ myfile="cat file"
$ echo $myfile
cat file
$ eval $myfile
hello world
```

[reference](https://blog.51cto.com/u_10706198/1788573)

### Linux信号

| 信号 | 值      | 描述                           |
| ---- | ------- | ------------------------------ |
| 1    | SIGHUP  | 挂起进程                       |
| 2    | SIGINT  | 终止进程                       |
| 3    | SIGQUIT | 停止进程                       |
| 9    | SIGKILL | 无条件终止进程                 |
| 15   | SIGTERM | 尽可能终止进程                 |
| 17   | SIGSTOP | 无条件停止进程，但不是终止进程 |
| 18   | SIGTSTP | 停止或暂停进程，但不终止进程   |
| 19   | SIGCONT | 继续运行停止的进程             |

默认情况下，bash shell会忽略收到的任何SIGQUIT (3)和SIGTERM (5)信号(正因为这样， 交互式shell才不会被意外终止)。

但是bash shell会处理收到的SIGHUP (1)和SIGINT (2)信号。 如果bash shell收到了SIGHUP信号，比如当你要离开一个交互式shell，它就会退出。

但在退出之前，它会将SIGHUP信号传给所有由该shell所启动的进程(包括正在运行的shell脚本)。 

通过SIGINT信号，可以中断shell。Linux内核会停止为shell分配CPU处理时间。这种情况发生时，shell会将SIGINT信号传给所有由它所启动的进程，以此告知出现的状况。

bash shell允许用键盘上的组合键生成两种基本的Linux信号。

- Ctrl+C组合键会生成SIGINT信号

  例如，执行`sleep 100`命令，当你使用Ctrl+C，就可以提前终止sleep命令

- Ctrl+Z组合键会生成一个SIGTSTP信号，停止shell中运行的任何进程

  如果你的shell会话中有一个已停止的作业，在退出shell时，bash会提醒你。

  ```
  $ sleep 100
  ^Z
  [1]+          Stopped          sleep 100
  ```

  方括号中的数字是shell分配的作业号(job number)。shell将shell中运行的每个进程称为作业， 并为每个作业分配唯一的作业号。它会给第一个作业分配作业号1，第二个作业号2，以此类推。

可以用ps命令来查看已停止的作业。

在S列中(进程状态)，ps命令将已停止作业的状态为显示为T。这说明命令要么被跟踪，要 么被停止了。

如果在有已停止作业存在的情况下，你仍旧想退出shell，只要再输入一遍exit命令就行了。 shell会退出，终止已停止作业。或者，既然你已经知道了已停止作业的PID，就可以用kill命令来发送一个SIGKILL信号来终止它。

```
$ kill -9 2456
[1]+       Killed          sleep 100
```

在终止作业时，最开始你不会得到任何回应。但下次如果你做了能够产生shell提示符的操作 (比如按回车键)，你就会看到一条消息，显示作业已经被终止了。每当shell产生一个提示符时， 它就会显示shell中状态发生改变的作业的状态。在你终止一个作业后，下次强制shell生成一个提 示符时，shell会显示一条消息，说明作业在运行时被终止了。

## 环境变量

在 Linux 系统中，环境变量是用来定义系统运行环境的一些参数，比如每个用户不同的家目录（HOME）、邮件存放位置（MAIL）等，这也是存储持久数据的一种简便方法。

环境变量分为两类：

- 局部环境变量

  局部变量则只对创建它们的shell可见。

  Linux系统也默认定义了标准的局部环境变量。不过你也可以定义自 己的局部变量，这些变量被称为用户定义局部变量

- 全局环境变量

  全局环境变量对于shell会话和所有生成的子shell都是可见的。

### set

我们知道，Bash执行脚本的时候，会新建一个shell，`set`就是用来修改这个环境的

`set`在没有任何参数的时候表示：显示所有环境变量，同下`env`的区别就是它会按照字母顺序对结果进行排序

### env

命令用于显示系统中已存在的环境变量

要显示个别环境变量的值，可以使用printenv命令

```
$ printenv HOME
```

或者

```
$ echo $HOME
```

### 定义局部环境变量

一旦启动了bash shell(或者执行一个shell脚本)，就能创建在这个shell进程内可见的局部变量了。可以通过等号给环境变量赋值，值可以是数值或字符串。

```
my_variable=Hello
echo $my_variable 

Hello
```

注意：

- 如果要给变量赋一个含有空格的字符串值，必须用单引号来界定字符串的首和尾
- 没有单引号的话，bash shell会以为下一个词是另一个要执行的命令。注意，**你定义的局部环境变量用的小写字母**，而到目前为止你所看到的**系统环境变量都是大写字母**，这是标准惯例
- **变量名、等号和值之间没有空格**，如果在赋值表达式中加上了空格，bash shell就会把值当成一个单独的命令。

### 定义全局环境变量

在设定全局环境变量进程的子进程中，该变量都是可见的。

创建全局环境变量的方法是先创建一个局部环境变量，然后再把它导出到全局环境中。

这个过程通过export命令来完成，变量名前面不需要加`$`。

#### export

作用就是设置或显示环境变量

```
export [-fnp][变量名称]=[变量设置值]
```

设置全局环境变量：

```
$ my_variable='Hello World!'
$ export my_variable
$ echo $my_variable
Hello World!
#子进程依然可以访问
$ bash
$ echo $my_variable
Hello World!
```

但是这种改变仅在子shell中有效，并不会反应到父shell中，子shell无法使用export命令改变父shell中全局环境变量的值。

```
$ my_variable2='Hello World!'
$ export my_variable2
$ echo my_variable2
my_variable2
$ exit
exit
$ echo $my_variable2
(空白)
```

**删除环境变量**

```
$ unset my_variable
```

在处理全局环境变量时，如果你是在子进程中删除了一个全局环境变量， 这只对子进程有效。该全局环境变量在父进程中依然可用。

注意：

- **如果要用到变量，使用`$`，如果要操作变量，不使用`$`**。这条规则的一个例外就是printenv显示某个变量的值。

### PATH环境变量

当你在shell命令行界面中输入一个外部命令时，shell必须搜索系统来找到对应的程序。PATH环境变量定义了用于进行命令和程序查找的目录。PATH中的目录使用冒号分隔。

添加新PATH环境变量

```
PATH=$PATH:/home/christine/Scripts
```

将本目录也添加进PATH环境变零

```
PATH=$PATH:.
```

### 环境变量持久化

在你登入Linux系统启动一个bash shell时，默认情况下bash会在几个文件中查找命令。这些文件叫作启动文件或环境文件。

启动bash shell有3种方式：

- 登录时作为默认的shell
- 作为非登录shell的交互式shell
- 作为运行脚本的非交互shell

bash检查的启动文件取决于你启动bash shell的是上面三种的何种方式。

#### **登录shell**

当你登录Linux系统时，bash shell会作为登录shell启动。登录shell会从5个不同的启动文件里读取命令:

- `/etc/profile`
- `$HOME/.bash_profile`
- `$HOME/.bashrc`
- `$HOME/.bash_login`
- `$HOME/.profile`

`/etc/profile`文件是bash shell默认的的主启动文件。只要你登录了Linux系统，bash就会执行。

剩下的4个是针对用户的，每个用户都可以编辑自己的环境变量，这些环境变量会在每次启动bash shell会话时生效。

shell会按照按照下列顺序，运行第一个被找到的文件，余下的则被忽略:

- `$HOME/.bash_profile`
- `$HOME/.bash_login`
- `$HOME/.profile`

注意，这个列表中并没有`$HOME/.bashrc`文件。这是因为该文件通常通过其他文件运行的，`.bash_profile`启动文件会先去检查HOME目录中是不是还有一个叫`.bashrc`的启动文件。如果有 的话，会先执行启动文件里面的命令。

**/etc/profile文件**

```sh
# /etc/profile

# System wide environment and startup programs, for login setup
# Functions and aliases go in /etc/bashrc

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

pathmunge () {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}


if [ -x /usr/bin/id ]; then
    if [ -z "$EUID" ]; then
        # ksh workaround
        EUID=`/usr/bin/id -u`
        UID=`/usr/bin/id -ru`
    fi
    USER="`/usr/bin/id -un`"
    LOGNAME=$USER
    MAIL="/var/spool/mail/$USER"
fi

# Path manipulation
if [ "$EUID" = "0" ]; then
    pathmunge /usr/sbin
    pathmunge /usr/local/sbin
else
    pathmunge /usr/local/sbin after
    pathmunge /usr/sbin after
fi

HOSTNAME=`/usr/bin/hostname 2>/dev/null`
if [ "$HISTCONTROL" = "ignorespace" ] ; then
    export HISTCONTROL=ignoreboth
else
    export HISTCONTROL=ignoredups
fi

export PATH USER LOGNAME MAIL HOSTNAME HISTSIZE HISTCONTROL

# By default, we want umask to get set. This sets it for login shell
# Current threshold for system reserved uid/gids is 200
# You could check uidgid reservation validity in
# /usr/share/doc/setup-*/uidgid file
if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
    umask 002
else
    umask 022
fi

for i in /etc/profile.d/*.sh /etc/profile.d/sh.local ; do
    if [ -r "$i" ]; then
        if [ "${-#*i}" != "$-" ]; then
            . "$i"
        else
            . "$i" >/dev/null
        fi
    fi
done

unset i
unset -f pathmunge
PATH=$PATH:/data/sre/scripts/bin
export PATH
```

#### **交互式shell进程**

如果你的bash shell不是登录系统时启动的(比如是在命令行提示符下敲入bash时启动)，那么你启动的shell叫作交互式shell。

如果bash是作为交互式shell启动的，它就不会访问`/etc/profile`文件，只会检查用户HOME目录中的`.bashrc`文件。

`.bashrc`文件有两个作用:一是查看`/etc`目录下通用的`bashrc`文件，二是为用户提供一个定制自己的命令别名。

#### **非交互式shell**

系统执行shell脚本的时候用的就是这种shell。

在启动非交互式shell后，它会检查`BASH_ENV`环境变量中指定的启动文件，默认这个环境变量是空的。

如果没有设置，那么shell脚本去哪里获取环境变量呢？

有些shell脚本是通过启动某些子shell来执行的，子shell可以继承父shell导出过的变量。

如果父shell是登录shell，在`/etc/profile`、`/etc/profile.d/*.sh`和`$HOME/.bashrc`文件中设置并导出了变量，用于执行脚本的子shell就能够继承这些变量。

对于那些不启动子shell的脚本，变量已经存在于当前shell中了。所以就算没有设置`BASH_ENV`，也可以使用当前shell的局部变量和全局变量。

#### 设置技巧

对全局环境变量来说，可能更倾向于将新的或修改过的变量设置放在`/etc/profile`文件中，但如果升级了所用的发行版， 这个文件也会跟着更新，那你所有定制过的变量设置可就都没有了。 

最好是在`/etc/profile.d`目录中创建一个以`.sh`结尾的文件。把所有新的或修改过的全局环境变量设置放在这个文件中。

在大多数发行版中，存储个人用户永久性bash shell变量的地方是`$HOME/.bashrc`文件。你还可以把自己的alias设置放在`$HOME/.bashrc`启动文件中，使其效果永久化。

### source

source命令也称为"点命令"，也就是一个点符号`.`，是bash的内部命令，修改环境变量后，需要source使其生效。

功能：使Shell读入指定的Shell程序文件并依次执行文件中的所有语句。

```
source filename 
或 
. filename
```

`source filename` 与 `sh filename` 及`./filename`执行脚本的区别在那里呢？

`sh filename` sh是外部命令，**会重新建立一个子shell**，在子shell中执行脚本里面的语句，该子shell继承父shell的环境变量，但子shell新建的、改变的变量不会被带回父shell，除非使用export。

```
type sh

sh 是 /usr/bin/sh
```

## 其他

### !!

输入`!!`，唤出刚刚用过的那条命令。

### $和#

终端中的`$`和`#`什么含义

- `$`代表普通用户
- `#`代表root用户

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

```sh
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

### reboot

```
reboot  用于用来重新启动计算机
```

### bc

进行一些简单的计算

- 进行浮点型运算

  ```
  scale=2;48.41*26.5/(16.91+26.5)+49.5*30/(26.5+30)
  
  echo "scale=2;3/8" | bc
  .37
  ```

### 查看IP地址

查看公网ip

```
curl cip.cc
```

## 文件权限

### 用户信息

Linux系统使用一个专门的文件来将用户的登录名匹配到对应的UID值。这个文件就是`/etc/passwd`文件，它包含了一些与用户有关的信息。

文件的一行代表一个单独的用户。该文件将用户的信息分为 3 个部分。

-  第一部分是 root 账户，这代表管理员账户，对系统的每个方面都有完全的权力。
-  第二部分是系统定义的群组和账户，这些群组和账号是正确安装和更新系统软件所必需的。
-  第三部分在最后，代表一个使用系统的真实用户。

在创建用户的时候同时修改了下面几个文件

```
* /etc/passwd： 用户账户的详细信息在此文件中更新。
* /etc/shadow： 用户账户密码在此文件中更新。
* /etc/group： 新用户群组的详细信息在此文件中更新。
* /etc/gshadow： 新用户群组密码在此文件中更新。
```

#### **/etc/passwd**

文件将每个用户的详细信息写为一行，其中包含七个字段，每个字段之间用冒号 : 分隔：

```
cat passwd

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

- 用户名： 已创建用户的用户名

  字符长度 1 个到 12 个字符

- 密码：用户密码

  `/etc/passwd`文件中的密码字段都被设置成了x，在早起的Linux中，`/etc/passwd`文件中保存的有用户加密后的密码，但是鉴于很多程序都要访问`/etc/passwd`文件获取用户信息，这就成为了一个安全隐患，所以，现在的绝大多数Linux系统都将用户密码保存在另一个单独的文件中，只有特定的程序才能访问，例如登录程序。

- 用户 UID：代表用户的 ID 号

  每个用户都要有一个唯一的 ID 。UID 号为 0 的是为 root 用户保留的，UID 号 1 到 99 是为系统用户保留的，UID 号 100-999 是为系统账户和群组保留的

- 群组 ID ：代表群组的 ID 号

  每个群组都要有一个唯一的 GID ，保存在 /etc/group文件中

- 用户信息：用户账户的文本描述

- 家目录：代表用户的Home目录

- Shell：用户默认的shell

你可以直接编辑`/etc/passwd`文件，但是这样非常危险，如果/etc/passwd文件出现损坏，系统就无法读取它的内容了，这样会导致用户无法正常登录(即便是root用户)。用标准的Linux用户管理工具去执行这些用户管理功能就会安全许多。

**`/etc/shadow`**

`/etc/shadow`文件对Linux系统密码管理提供了更多的控制。只有root用户才能访问`/etc/shadow` 文件，这让它比起`/etc/passwd`安全许多。

`/etc/shadow`文件为系统上的每个用户账户都保存了一条记录。记录就像下面这样:

```
root:$1$Bg1H/4mz$X89TqH7tpi9dX1B9j5YsF.:14838:0:99999:7:::
```

其格式为：

- 用户名
- 加密后的口令密码
- 自上次修改密码后过去的天数密码
- 多少天后才能更改密码
- 多少天后必须更改密码
- 密码过期前提前多少天提醒用户更改密码
- 密码过期多少天禁用用户账户
- 用户账户被禁用的天数
- 保留字段

**/etc/sudoers**

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

**adduser和useradd的区别**

- 使用`useradd`时，后面可以通过添加参数来创建用户
- 使用`adduser`时，创建用户的过程更像是一种人机对话，系统会提示你输入各种信息，然后会根据这些信息帮你创建新用户。

#### adduser

参数：

- `-c`：加上备注文字，备注文字保存在passwd的备注栏中

- `-d`：指定用户登入时的主目录，替换系统默认值`/home/<用户名>`

- `-D`：变更预设值

  - `-b`：更改默认的HOME目录的位置
  - `-e`：更改默认新账户的过期日期
  - `-f`：更改默认的新用户从密码过期到账户被禁用的天数
  - `-g`：更改默认的组名或GID
  - `-s`：更改默认的shell

- `-e`：用YYYY-MM-DD格式指定一个账户过期的日期

- `-f`：指定这个账户密码过期后多少天这个账户被禁用

  0表示密码一过期就立即禁用，1表示禁用这个功能

- `-g`：指定用户登录组的GID或组名

  用户组必须已经存在的，期默认值为100，即users

- `-G`：指定用户所属的附加群组

- `-m`：创建用户的HOME目录

- `-M`：不创建用户的HOME目录

- `-n`：创建一个与用户登录名同名的新组

- `-r`：创建系统账户

- `-s`：指定默认的登录shell

  默认值为`/bin/bash`

- `-u`：为账户指定唯一的UID=

  0~499默认是保留给系统用户账号使用的，所以该值必须大于499

举例：

- 查看新增用户默认配置

  `useradd -D`

  ```
  $ sudo useradd -D
  GROUP=100
  HOME=/home
  INACTIVE=-1
  EXPIRE=
  SHELL=/bin/bash
  SKEL=/etc/skel
  CREATE_MAIL_SPOOL=yes
  ```

- 更改默认值

  ```
  # useradd -D -s /bin/tsch
  # useradd -D
  
  GROUP=100
  HOME=/home
  INACTIVE=-1
  EXPIRE=
  SHELL=/bin/tsch
  SKEL=/etc/skel
  CREATE_MAIL_SPOOL=yes
  ```

- 添加用户

  `useradd wujunnan`

  会使用上面的默认配置创建新用户

  - 新用户会被添加到GID为100的公共组

  - 新用户的目录会位于`/home/wujunnan`

  - 新用户的账号密码在过期后不会被禁用

  - 新用户账户将bash shell作为默认的shell

  - 系统会将`etc/skel`目录下的内容复制到用户的HOME目录下

    管理员可以创建一份一份默认的HOME目录配置，然后把它作为创建新用户HOME目录的模板。

  - 系统会为该用户账户在mail目录下创建一个用于接收邮件的文本

- 给该用户设置密码

  `passwd wujunnan`

- 将该用户添加为超级管理员

#### userdel

从系统中删除用户

userdel命令只删除`etc/passwd`文件中的信息，而不会删除系统中属于该账户的任何文件

参数：

- `-r`

  删除用户的HOME以及邮件目录

#### usermod

修改用户账户的字段，还可以指定主要组以及附加组的所属关系。

用来修改`/etc/passwd`文件中的大部分字段，只需用与想修改的字段对应的命令行参数就可以了。参数大部分跟useradd命令的参数一样。

格式：

`usermod [选项] LOGIN`

选项：

- `-c`

  修改备注字段

- `-e`

  修改过期时间

- `-g GROUP`

  修改默认的登陆组

- `-G GROUP1[,GROUP2,...[,GROUPN]]]`

  规定用户所属的组

  如果用户不在列出的组中，那么这个用户会被那个组移除，要想仅将用户添加到列出的组中，则需要加`-a --append`

- `-l --login NEW_LOGIN`

  将用户的`LOGIN`修改为`NEW_LOGIN`

- `-L --lock`

  锁定账户，使用户无法登录

- `-p`

  修改用户账户的密码

- `-U`

  解除锁定

例如：

- 给jinp用户添加到ClickHouse组中

  ```
  sudo usermod -a -G clickhouse jinp
  ```

#### passwd

改变用户密码

```
# passwd test
Changing password for user test.
New UNIX password:
Retype new UNIX password:
passwd: all authentication tokens updated successfully.
```

如果只用passwd命令，它会改你自己的密码。系统上的任何用户都能改自己的密码，但只有root用户才有权限改别人的密码。

#### whoami

我是谁？ :smile:

### 用户组

Linux操作系统对多用户的管理，是非常繁琐的，所以用组的概念来管理用户就变得简单，每个用户可以在一个独立的组，每个组也可以有零个用户或者多个用户。

#### /etc/group

与用户账户类似，组信息也保存存在一个文件中

```
root:x:0:root
bin:x:1:root,bin,daemon
daemon:x:2:root,bin,daemon
sys:x:3:root,bin,adm
adm:x:4:root,adm,daemon
rich:x:500:
mama:x:501:
katie:x:502:
jessica:x:503:
mysql:x:27:
test:x:504:
```

格式：

- 组名
- 组密码
- GID
- 属于该组的用户列表

组密码允许非组内成员通过它临时成为该组成员。这个功能并不很普遍，但确实存在。

千万不能通过直接修改`/etc/group`文件来添加用户到一个组，要用`usermod`命令，在添加用户到不同的组之前，首先得创建组。

#### groups

查看当前用户是哪个组的

想查看某个组下有哪些用户

**查看一共有哪些组**

```
compgen -g
```

### 理解用户权限

ls命令可以查看linux系统上的文件、目录和设备的权限，其中输出的第一个字段就是描述文件和目录权限的编码，例如：

`d rwx rwx r-x`

- 对象的属主
- 对象的属组
- 系统的其他用户

### umask

umask命令指定在建立文件时预设的权限掩码

```
$ umask
0002
```

第一位代表了粘着位，后面的三位表示文件对应的umask的八进制

要把umask值从对象的全权限值中减掉。对文件来说，全权限的值是666 (八进制) (所有用户都有读和写的权限)；而对目录来说，则是777(所有用户都有读、写、执行权限)。

参数：

- `-S`

  以文字的方式来表示权限掩码（777-002 = 775）

  ```
  umask -S
  u=rwx,g=rwx,o=rx
  ```

例如：

- mac的默认权限：

  掩码：

  ```
  umask
  022
  ```

  创建文件默认权限：

  ```
  -rw-r--r--    1 wujunnan  staff     5B  9 20 00:07 test
  drwxr-xr-x    2 wujunnan  staff    64B  9 20 00:08 testdir
  ```

### 改变安全设置

### chmod

chmod (change mode) 

参数：

- `-R`

  选项可以让权限的改变递归地作用到文件和子目录
  
- `-c`

  若该文件权限确实已经更改，才显示其更改动作

符号模式：

```
[ugoa...][[+-=][rwxX]...][,...]
```

- `u`代表拥有者，`g`代表组，`o`代表其他，`a`代表上述所有
- `+` 表示增加权限，`-` 表示取消权限，`=` 表示唯一设定权限

八进制模式：

```
$ chmod 760 newfile
```

例如：

- 将文件 file1.txt 与 file2.txt 设为该文件拥有者，与其所属同一个群体者可写入，但其他以外的人则不可写入 :

  ``` 
  $ chmod ug+w,o-w file1.txt file2.txt
  ```

- 将目前目录下的所有文件与子目录皆设为任何人可读取 :

  ```
  $ chmod -R a+r *
  ```

  

### chown

修改文件拥有者，格式如下：

```
$ chown options owner[.group] file
```

可用登录名或UID来指定文件的新属主，chown命令也支持同时改变文件的属主和属组。

参数：

- `-R`

  递归修改

例如：

- 将newfile的属主设置为wujn

  ```
  $ chown wujn newfile
  ```

- 将newfile的属主设置为wujn，属组设置为shared

  ```
  $ chown wujn.shared newfile
  ```

注意：

**只有root用户能够改变文件的属主**。任何属主都可以改变文件的属组，但前提是属主必须 是原属组和目标属组的成员。

### su

切换用户

```
$ su - user
```

`-`表示在切换用户时，同时切换掉当前用户的环境

在执行 su - 指令时，高级用户向低级用户切换不需要密码，如root用户切换至student用户；而低级用户切换至高级用户以及平级用户之间的切换均需要输入密码。

**whoami**

```
$ whoami
root
```

**wheel组**

如果普通用户也能通过`su`来转换为root用户，那么将非常危险，所以我们希望剥夺被加入到wheel组用户以外的普通用户通过`su`登录为root的权利

所以我们找到` /etc/pam.d/su` 文件，找到`#auth required /lib/security/$ISA/pam_wheel.so use_uid `这一行，将行首的“#”去掉。

然后，再将用户添加到wheel组中。

这样以来，一个不属于wheel组的用户时，执行了su命令后，即使输入了正确的root密码，也无法登录为root用户。

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
Defaults env_reset
```

sudo的时候，由于有`env_reset`，所以使环境变量重置了，但是有一个`secure_path`，里面规定了可以使用的环境变量其中包括`/usr/bin`

这样我们就可以使用软链接将我们所需要的命令链接到这个文件夹下面

```
$ sudo ln -s /usr/local/jdk1.8/bin/javac /usr/bin
```

[Reference1](https://blog.csdn.net/q290994/article/details/77448626)

[Reference2](https://www.cnblogs.com/wazy/p/8352369.html)

## Reference
