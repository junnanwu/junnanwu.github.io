# Linux

本文是本人从零开始的学习Linux的记录，目的是方便查阅记忆。

本文内容，一部分来自生产实践，一部分来自网络和书籍。

关于书籍，刚开始快速入门Linux推荐《Linux命令行与shell脚本编程大全》，这本书讲的不是那么细，但是语言精简，能快速的让你把握Linux的脉络，而不是在网上今天学一个命令，明天看环境变量，后台再看inode是什么，不成体系，学习效率非常低。工作中使用了一段Linux，相信你也会有很多疑惑，那么再去分块的看一下《鸟哥的Linux私房菜》，这本书讲的非常细，非常全，通俗到不能再通俗，但当然内容也较多，适合慢慢把玩。

本文参考的书籍也正是这两本。

## 什么是Linux

Linus Torvalds在上学时就开发了第一版Linux内核。起初他只是想仿造一款Unix系统而已，因为当时Unix操作系统在很多大学都很流行。

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
  $ rpm -ivh *.rpm
  ```

- 列出当前系统所有已安装的包

  ```
  $ rpm -qa
  ```

  配合grep

  ```
  $ rpm -qa | grep clickhouse
  ```

- 查询包安装生成的文件清单

  ```
  $ rpm -ql 包名
  ```

  注意，可以通过上面的grep命令获取包名完整名字，也可以通过tab键进行左匹配

- 查询某文件是哪个RPM包生成的

  ```
  $ rpm -qf
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

cd (change directory)

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

参数：

- `-P`

  显示真实的目录，显示符号连接指向的（physical）地址

### mkdir

mkdir (make directory)

格式：

```
mkdir [-pv] [-m mode] directory_name ...
```

参数：

- `-p --parents` 

   创建多个目录和子目录

- `-m mode`

  设置文件的权限，mode的格式与chmod的一样

关于新建目录的默认权限，参考[umask](#umask)

### ls

ls (list directory contents)

参数：

- `-a` 

  显示所有文件及目录 (`.` 开头的隐藏文件也会列出)

- `-l`  

  以列表方式显示

- `-h`  

  将文件大小以易读的方式显示，默认是字节

- `-i`

  列出文件的inode号码

- `-t`

  文件按照修改时间排序

- `-r`

  将排序结果反向输出

关于`ls -l`每一列：

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

### echo

举例：

- 使用`>`指令覆盖文件原内容并重新输入内容，若文件不存在则创建文件

  ```
  $ echo "Raspberry" > test.txt
  ```

- 使用`>>`指令向文件追加内容，原内容将保存

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

格式：

```
cp [-R [-H | -L | -P]] [-fi | -n] [-apvX] source_file target_file
cp [-R [-H | -L | -P]] [-fi | -n] [-apvX] source_file ... target_directory
```

形式一表示将source_file文件复制为target_file，形式二表示为，将多个文件source_file，复制到target_directory，名字不会改变。

参数：

- `-a`

  相当于`-dR --preserve=all`的意思

- `-d`

  若原文件为链接文件的属性，则复制链接文件属性而非文件本身

- `-i` 

  覆盖前询问（建议加此参数）

- `-R` 

  递归的复制整个目录

- `--preserve=all`

  除了`-p`的权限相关参数外，还加入 SELinux 的属性, links, xattr 等也复制了

- `-p`

  连同文件的属性一起复制过去，而非使用默认属性（备份常用）

注意：

1. 在目标目录名尾部加上`/`，这表明destination是目录而不是文件，如果没有加`/`，而destination目录又不存在，那么反而会创建一个名为destination的文件，而且不会有任何提示

   ```
   $ cp -i test_one Documents/
   ```
   
2. 我们复制别人的数据，总是希望数据是我们的，所以在默认的情况下，`cp`命令的目的文件通常是操作者本身，所以当我们备份文件的时候，需要加上`-a`或`-p`来复制文件的权限

3. 如果你没有目标文件的权限，加了`-a`选项，即使可以复制文件的权限时间等属性，但是拥有者和群组相关的依然是无法复制的

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
  $ sudo ln -s t
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

格式：

```
mv [-f | -i | -n] [-v] source target
mv [-f | -i | -n] [-v] source ... directory
```

如果有多个源文件或目录，则最后一个目录文件一定是目录

参数：

- `-i` 

  同cp命令，覆盖前询问

- `-f`

  若目标文件已经存在，直接覆盖
  
- `-u`

  若目标文件已经存在，且source比较新，才会更新
  
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

举例：

- 删除除了`a.txt`以外的其他文件

  ```
  $ rm -f !(a.txt)
  ```

  或

  ```
  $ ls | grep -v a.txt | xargs rm
  ```

- 删除除了`a.txt`和`b.txt`以外的文件

  ```
  $ rm -f !(a.txt|b.txt)
  ```

  

### 解压/压缩

[详见此](关于Linux 的解压和压缩)

### 查看文件

### cat

cat (concatenate，连接) ，显示文件内容。

格式：

```
cat [-benstuv] [file ...]
```

参数：

- `A`

  相当于`-vET`，显示一些特殊字符

- `-b`

  列出行号，仅针对非空白行号显示，空白行不标行号

- `-E`

  将结尾的断行字符显示出来

- `-n` 

  加上行号，包括空白行

- `-T`

  将tab键显示出来

- `-v`

  显示一些看不出的特殊字符

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

less (less is more) ，more命令的升级版（可以向前翻页），less在刚开始不会读取整个文件，less命令支持上下翻页键。

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

- `-M` 按月排序

  当日志文件按照月份在前的时候，可以使用该参数

### sort

格式：

- `sort [选项]... [文件]...`
- `sort [选项]... --files0-from=F`

选项：

- `-k, --key=KEYDEF`          

  指定排序字段

- `-n, --numeric-sort`	

  根据字符串数值比较，即将数字识成数字，而不是字符串

- `-M`

   按月排序

- `-r, --reverse`			

  逆序输出排序结果

- `-t --field-separator=SEP`

  指定分隔符

  

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

### rename

修改文件名

格式：

```
rename [options] expression replacement file...
```

>rename  will  rename the specified files by replacing the first occurrence of expression in their name by replacement.

例如：

- 将文件名中的prod-data替换为prod_data

  ```
  $ rename prod-data prod_data *
  ```

- 将`.prog`后缀的文件重命名为`.prg`后缀的文件

  ```
  $ rename 's/.prog/.prg/' *.prog
  ```

  `s`意味着substitute，替代，替换

- 删除所有`.c`结尾的文件的`sl_`前缀

  ```
  $ rename 's/sl_//' *.c
  ```

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

### wc

wc (word command)，输出目标文件的行数/字符数/单词数，其中单词是以空格分割

参数：

- `-l --lines`

  打印行数

- `-w --words`

  打印单词数

举例：

- 查看文件数

  ```
  $ ls | wc -w
  ```

  注意：`ll`有一行总用量，会导致数量+1

### sed

详见文档[Shell脚本](Shell脚本)

### awk

详见文档[Shell脚本](Shell脚本)

### tee

tee读取STDIN然后将其输出到STDOUT和指定的文件中。

### tr

tr (translate characters) 工具从标准输入读取，将其替换或者删除然后输出到标准输出

格式1：

```
tr [-Ccsu] string1 string2
```

>In the first synopsis form, the characters in string1 are translated into the characters in string2 where the first character in string1 is translated into the first character in string2 and so on.  If
>string1 is longer than string2, the last character found in string2 is duplicated until string1 is exhausted.

string1将被替换为string2

格式2：

```
tr [-Ccu] -d string1
```

删除string1

### Vim

[详见此](Vim)

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

  [查看此](https://www.ssh.com/academy/ssh/keygen)

  - `rsa`

  - `dsa`

  - `ecdsa`

    支持三种长度， 256, 384, and 521 

  - `ed25519`

- `-C` 添加注释

- `-f` 指定用来保存密钥的文件名

**不同密钥类型举例：**

```
$ ssh-keygen -t rsa -b 4096
$ ssh-keygen -t dsa 
$ ssh-keygen -t ecdsa -b 521
$ ssh-keygen -t ed25519
```

**配置SSH免密步骤：**

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

**注意：**

1. 私钥默认放在`.ssh`下才会生效

2. 如果是想通过ssh免密git操作，将上述的步骤二换成将公钥保存到相关git远程仓库即可

3. GitHub没有我的私钥，他是怎么解密我加密过的数据呢

   你用私钥加密的东西，GitHub用公钥可以解开，能解开说明你有对应的私钥，就是上传公钥那个人
   
3. GitHub已不支持RSA-1，但是OpenSSH 7.2以下版本只支持RSA-1，所以7.2以下版本要么升级版本，使用RSA-2，要么使用ECDSA算法，如下：

   ```
   $ ssh-keygen -t ecdsa -C "wujunnan-ECDSA"
   ```



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

## 理解输入输出

### 标准文件描述符

Linux系统将每个对象当作文件处理。这包括输入和输出进程。

| 文件描述符 | 缩写   | 描述     |
| ---------- | ------ | -------- |
| 0          | STDIN  | 标准输入 |
| 1          | STDOUT | 标准输入 |
| 2          | STDERR | 标准错误 |

**标准输入**

STDIN文件描述符代表shell的标准输入。对终端界面来说，标准输入是键盘。

当在命令行上只输入cat命令时，它会从STDIN接受输入。输入一行，cat命令就会显示出一行。

但你也可以通过STDIN重定向符号`<`强制cat命令接受来自另一个非STDIN文件的输入。

**标准输出**

代表shell的标准输出。在终端界面上，标准输出就是终端显示器。

默认情况下，大多数命令的输出导向STDOUT文件，同样可以使用输出重定向`>`来改变，同时，也就可以通过`>>`追加。

注意：

- shell对于错误消息的处理是跟普通输出分开的，将输出重定向的时候，只会将标准输出重定向

  ```
  ls -al badfile > file
  ls: badfile: No such file or directory
  ```

**标准错误**

shell或shell中运行的程序和脚本出错时生成的错误消息都会发送到标准错误这个位置，默认情况下，STDERR文件描述符会和STDOUT文件描述符指向同样的地方(尽管分配给它们的文件描述符值不同)。也就是说，默认情况下，错误消息也会输出到显示器输出中。

**重定向错误**

- 只重定向错误

  ```
  #注意2和>之间不能有空格
  $ ls -al badfile 2> test4
  $ cat test4
  ls: cannot access badfile: No such file or directory
  ```

- 重定向错误和数据

  如果想重定向错误和正常输出，必须用两个重定向符号。

  ```
  ls -al test test2 test3 badtest 2> test6 1> test7
  ```

  shell利用`1>`符号将ls命令的正常输出重定向到了test7文件，而这些输出本该是进入STDOUT 的。所有本该输出到STDERR的错误消息通过`2>`符号被重定向到了test6文件。

  也可以将STDERR和STDOUT的输出重定向到同一个输出文件。为此bash shell 提供了特殊的重定向符号&>

  ```
  $ ls -al test test2 test4 badtest &> test7
  $ cat test7
  ls: badtest: No such file or directory
  ls: test: No such file or directory
  ls: test2: No such file or directory
  -rw-r--r--  1 wujunnan  staff  39 11 13 22:26 test4
  ```
  
- 重定向文件描述符

  将标准错误重定向到标准输出

  ```
  2>&1 
  ```

#### 阻止命令输出

Linux系统上null文件的标准位置是/dev/null。你重定向到该位置的任何数据都会被丢掉：

```
$ ls -al > /dev/null
$ cat /dev/null
$ 
```

也可以利用来/dev/null清空文件，而不用删除再重建：

```
$ cat /dev/null > testfile
$ cat testfile
$
```

这是清除日志文件的一个常用方法，因为日志文件必须时刻准备等待应用程序操作。

## Shell

系统启动什么样的shell程序取决于你个人的用户ID配置。在/etc/passwd文件中，在用户ID记录的第7个字段中列出了默认的shell程序。

不过由于bash shell广为流传，大都使用bash作为默认shell。

```
$ cat /etc/passwd | grep wujn
wujn:x:1003:1004::/home/wujn:/bin/bash
```

### Shell的父子关系

用于登录某个终端或GUI中启动终端时所启动的默认的交互shell，是一个父shell。

在提示符后输入`bin/bash`命令或其他等效的bash命令的时候，会创建一个新的shell程序，这个shell程序被称为子shell。

在生成子shell进程时，只有部分父进程的环境被复制到子shell环境中，下面的环境变量将讲解。

要想知道是否生成了子shell，得借助一个使用了环境变量的命令。

这个命令就是`echo $BASH_SUBSHELL`。如果该命令返回0，就表明没有子shell。如果返回1或者其他更大的数字，就表明存在子shell。

实际演示：

```
$ ps -f --forest
UID        PID  PPID  C STIME TTY          TIME CMD
wujn     22102 22101  0 19:59 pts/1    00:00:00 -bash
wujn     22181 22102  0 19:59 pts/1    00:00:00  \_ ps -f --forest

$ bash

$ ps -f --forest
UID        PID  PPID  C STIME TTY          TIME CMD
wujn     22102 22101  0 19:59 pts/1    00:00:00 -bash
wujn     22505 22102  0 20:00 pts/1    00:00:00  \_ bash
wujn     22555 22505  0 20:00 pts/1    00:00:00      \_ ps -f --forest

bash
```

后台模式、进程列表、协程和管道都用到了子shell。

**注意：子shell只会继承父shell的全局环境变量**

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

在交互式shell中，一个高效的子shell用法就是使用后台模式，在后台模式中， 进程运行时不会和终端会话上的STDIN、STDOUT以及STDERR关联。

在后台模式中运行命令可以在处理命令的同时让出CLI，以供他用，想要命令置入后台模式，可以在命令末尾上加上字符`&`。

```
$ sleep 5&
[2] 38871
```

第一条信息时显示在方括号中的后台作业号（即有几个后台作业），第二条是后台作业的进程ID。

一旦系统显示了这些内容，新的命令提示符就会出现，而你所执行的命令正在已后台模式安全运行，这时，你可以在提示符输入新的命令，在后台进程结束的时候，它会在终端显示出一条信息：

```
[2]  + 38871 done       sleep 5
```

注意：

- 当后台进程运行时，它仍然会使用终端显示器来显示STDOUT和STDERR消息。最好是将后台运行的脚本的STDOUT和STDERR进行重定向，避免这种杂乱的输出
- 如果终端会话退出，那么后台进程也会随之退出

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

    这个意思是把标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。 至于为什么需要将stderr重定向到stdout的原因，那就归结为stderr没有缓冲区，而stdout有。这就会导致 >output 2>output 文件output被两次打开，而stdout和stderr将会竞争覆盖，这肯定不是我门想要的

补充：

标准文件描述符：

| 文件描述符 | 缩写   | 描述     |
| ---------- | ------ | -------- |
| 0          | STDIN  | 标准输入 |
| 1          | STDOUT | 标准输入 |
| 2          | STDERR | 标准错误 |

### 命令分组

#### 小括号（进程列表）

你可以使用小括号会让命令列表变成一个进程列表，进程列表会生成一个子shell来执行命令

例如：

```
$ (pwd ; ls ; cd /etc ; pwd ; cd ; pwd ; ls)
/home/wujn
data  data-backend-execute.sh  nohup.out
/etc
/home/wujn
data  data-backend-execute.sh  nohup.out
```

#### 花括号

命令分组的另一种方式是花括号，这种方式不会创建子进程。

```
{ pwd; ls; cd /etc; pwd; cd; pwd; ls; }
/home/wujn
data  data-backend-execute.sh  nohup.out
/etc
/home/wujn
data  data-backend-execute.sh  nohup.out
```



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

sh (Bourne shell) 是UNIX最初使用的shell，另外还有bash (Bourne Again shell)，它是Bourne shell的扩展，简称Bash。

sh可以解释来自命令行，标准输入，或者一个指定文件的命令。

有的发行版本使用软连接将默认的系统shell设置为bash shell

```
$ ls -l /bin/sh
lrwxrwxrwx 1 root root 4 7月  23 2020 /bin/sh -> bash
```

格式：

```
sh [-acefhikmnprstuvx] [arg] ...
```

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

[Reference](https://blog.51cto.com/u_10706198/1788573)

## 环境变量

[详见此](Linux环境变量)

## 信号

| 信号 | 值      | 信号值 | 描述                           |
| ---- | ------- | ------ | ------------------------------ |
| 1    | SIGHUP  | HUP    | 挂起进程                       |
| 2    | SIGINT  | INT    | 终止进程                       |
| 3    | SIGQUIT | QUIT   | 停止进程                       |
| 9    | SIGKILL | KILL   | 无条件终止进程                 |
| 15   | SIGTERM | TERM   | 尽可能终止进程                 |
| 17   | SIGSTOP | STOP   | 无条件停止进程，但不是终止进程 |
| 18   | SIGTSTP | TSTP   | 停止或暂停进程，但不终止进程   |
| 19   | SIGCONT | CONT   | 继续运行停止的进程             |

默认情况下，bash shell会忽略收到的任何SIGQUIT (3)和SIGTERM (5)信号(正因为这样， 交互式shell才不会被意外终止)，但是bash shell会处理收到的SIGHUP (1)和SIGINT (2)信号。 如果bash shell收到了SIGHUP信号，比如当你要离开一个交互式shell，它就会退出，但在退出之前，它会将SIGHUP信号传给所有由该shell所启动的进程(包括正在运行的shell脚本)。 

通过SIGINT信号，可以中断shell。Linux内核会停止为shell分配CPU处理时间。这种情况发生时，shell会将SIGINT信号传给所有由它所启动的进程，以此告知出现的状况。

shell会将这些信号传给shell脚本程序来处理。而shell脚本的默认行为是忽略这些信号。它们可能会不利于脚本的运行。要避免这种情况，可以脚本中加入识别信号的代码，并执行命令来处理信号。

bash shell允许用键盘上的组合键生成两种基本的Linux信号。

- Ctrl+C组合键会生成SIGINT信号中断进程

  例如，执行`sleep 100`命令，当你使用Ctrl+C，就可以提前终止sleep命令

- Ctrl+Z组合键会生成一个SIGTSTP信号，暂停，停止进程，停止（stopping）进程和终止（terminating）进程不一样，停止进程会让程序继续保留在内存中，并能从上次停止的位置继续运行。

  如果你的shell会话中有一个已停止的作业，在退出shell时，bash会提醒你。

  ```
  $ sleep 100
  ^Z
  [1]+          Stopped          sleep 100
  ```


可以用ps命令来查看已停止的作业。

在S列中(进程状态)，ps命令将已停止作业的状态为显示为T。这说明命令要么被跟踪，要么被停止了。

如果在有已停止作业存在的情况下，你仍旧想退出shell，只要再输入一遍exit命令就行了。 shell会退出，终止已停止作业。或者，既然你已经知道了已停止作业的PID，就可以用kill命令来发送一个SIGKILL信号来终止它。

```
$ kill -9 2456
[1]+       Killed          sleep 100
```

在终止作业时，最开始你不会得到任何回应。但下次如果你做了能够产生shell提示符的操作 (比如按回车键)，你就会看到一条消息，显示作业已经被终止了。每当shell产生一个提示符时， 它就会显示shell中状态发生改变的作业的状态。在你终止一个作业后，下次强制shell生成一个提示符时，shell会显示一条消息，说明作业在运行时被终止了。

### kill

> The  command  kill  sends  the specified signal to the specified process or process group.  If no signal is specified, the TERM signal is sent

向线程发一个信号，[信号详见](#Linux信号)

格式：

```
kill [-s signal_name] pid ...
kill -signal_name pid ...
kill -signal_number pid ...
```

注意：

- kill Java进程最好使用kill，如果使用` kill -9`，则不会调用钩子函数，`kill -15`则会调用钩子函数。

## 其他

### !!

输入`!!`，唤出刚刚用过的那条命令。

### $和#

终端中的`$`和`#`什么含义

- `$`代表普通用户
- `#`代表root用户

### except

except是一个自动化交互的软件。

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

**设置变量**

except里面不能像平时一样设置变量，参考如下：

```
set TODAY [exec date +%Y-%m-%d]
send "tail -f /data/davinci/logs/sys/davinci.$TODAY.log\r"
```

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

## 用户权限

[详见此](Linux用户权限)

## 日志

 [详见此](https://support.hpe.com/hpesc/public/docDisplay?docId=c02947726)

- `/var/log/messages`

  这里记录了全局系统消息。

  > This file has all the global system messages located inside, including the messages that are logged during system startup. Depending on how the syslog config file is sent up, there are several things that are logged in this file including mail, cron, daemon, kern, auth, etc

  当程序因为系统OOM被杀死的时候，可以来这里看日志信息。

## References

1. https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/
1. https://support.hpe.com/hpesc/public/docDisplay?docId=c02947726
1. https://www.ssh.com/academy/ssh/keygen
