# Linux基础命令

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

## 查看文件

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

例如：

- 根据时间进行排序

  ```
  $ "xxx" | sort -t' ' -k1.7,1.8nr -k1.1,1.2rn -k1.4,1.5rn -k2.1,2.2rn -k2.4,2.5rn
  04/22/22 00:00:12
  04/21/22 23:42:34
  04/21/22 23:28:03
  04/21/22 21:33:18
  04/20/22 14:33:19
  04/20/22 11:16:57
  04/19/22 22:59:16
  04/19/22 22:36:27
  04/19/22 21:44:51
  04/19/22 10:30:19
  ```

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

- 输出含有字符`t`或`f`的行

  ```
  $ grep -e t -e f file1
  ```
  
- 输出不含有字符`t`或`f`的行

  - 方式一
  
    ```
    $ grep -v 't\|f' file1
    ```
  
  - 方式二
  
    ```
    $ cat file1|grep -v 't'|grep -v 'f'
    ```
  
- 输出日志中含有`xxx.com`字符串的上下2行

  ```
  $ tail data-web.log |grep -2 xxx.com
  ```

### find

格式：

```
find [-H] [-L] [-P] [-Olevel] [-D help|tree|search|stat|rates|opt|exec] [path...] [expression]
```

EXPRESSIONS：

- `-mtime`

- `-printf format`

  - `%f` 文件名
  - `%p` 路径
  - `\n` 换行
  - `%Ak`
    - `D` 日期 (mm/dd/yy)
    - `T` 时间 (hh:mm:ss)

  （Mac版）

- `-type`

  - `d` 目录
  - `f` 常规文件

举例：

- 在目录下査找文件名是`yum.conf`的文件（按照文件名搜索，不区分文件名大小）

  ```
  $ find / -name yum.conf
  ```

- 指定递归深度

  ```
  $ find ./test -maxdepth 2 -name "*.php"
  ```
  
- 按照指定的打印

  ```
  $ gfind ./ -name '*.md' -printf "\n%AD %AT %p %f"
  04/22/22 00:00:12.8367223970 ./个人/关于本站.md 关于本站.md
  04/21/22 23:42:34.5971397130 ./运维/Linux/LinuxShell.md LinuxShell.md
  04/21/22 23:28:03.8715135000 ./运维/Linux/Shell脚本.md Shell脚本.md
  04/21/22 21:33:18.4033825870 ./运维/Linux/Linux基础命令.md Linux基础命令.md
  04/20/22 14:33:19.5480778810 ./工具/Mac/IDEA.md IDEA.md
  04/20/22 11:16:57.9277421540 ./工具/Mac/Mac.md Mac.md
  04/19/22 22:59:16.8949677960 ./数据库/Mysql/Mysql调优.md Mysql调优.md
  04/19/22 22:36:27.0024769460 ./数据库/Mysql/Mysql-EXPLAIN.md Mysql-EXPLAIN.md
  04/19/22 21:44:51.4384660000 ./数据库/Mysql/Mysql语句.md Mysql语句.md
  04/19/22 10:30:19.9181743890 ./运维/Linux/Linux网络.md Linux网络.md
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

### seq

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

### xargs

命令之间经常需要参数传递，但是有的命令（`mkdir`、`rm`、`kill`等）并不接受管道符的标准输出，这时候就需要xargs对命令结果进行处理，并传递到命令的参数位置上，如果后面没有接命令符，则默认为`echo`。

参数

- `-0`

  指定使用NULL而不是`空格、Tab制表符、回车符`为分隔符和结束符。

- `-n`

  指定一次读几个参数

- `-i`

  不加参数，默认`xargs`是将处理后的结果整体传递到命令的尾部，但有时候不是要传递到尾部或者需要传递到多个位置，这个时候就需要此参数。

  `-i`默认使用`{}`为替换符号，而`-I`可以指定替换符号

例如：

- 重命名为备份文件

  ```
  $ ls logdir/
  1.log  2.log  3.log  4.log  5.log
  $ ls logdir/ | xargs -i mv ./logdir/{} ./logdir/{}.bak
  $ ls logdir/
  10.log.bak  1.log.bak  2.log.bak  3.log.bak  4.log.bak  5.log.bak
  ```

- 删除带空格的文件名

  ```
  $ find ./ -name '*.txt' -print0 | xargs -0 rm
  ```

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

### 查看shell

#### 查看有哪些shell

```
$ cat /etc/shells
```

#### 查看当前使用的shell

```
$ echo $SHELL
/bin/zsh
```



## References

1. https://www.howtogeek.com/423214/how-to-use-the-rename-command-on-linux/
1. https://www.tecmint.com/find-and-sort-files-modification-date-and-time-in-linux/
