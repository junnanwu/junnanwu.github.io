# linux监测

## ps

ps (process status) 查看进程。

Linux系统中使用GUN ps命令支持三种不同类型的命令行参数：

**Unix风格参数**

（前面加`-`）

- `-e` 显示系统内的所有进程信息
- `-f` 使用完整的（full）格式显示进程信息

常用：

```
$ ps -ef
```

举例：

- 批量杀死name线程

  ```
  $ ps -ef|grep name|awk '{print $2}'|xargs kill -9
  ```

- 查看带父子关系的进程

  ```
  $ ps -ef --forest| grep davinci
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

**BSD风格参数**

（不加坡折线）

伯克利软件发行版(Berkeley software distribution)是加州大学伯克利分校开发的一个Linux版本，它和AT&T Unix系统有很多细小的不同。

参数

- `a`

  显示跟当前终端关联的所有进程

- `x`

  显示所有进程，包括未分配终端的

- `u`

  采用基于用户的格式显示

**GUN长参数**

（双破折号）

参数：

- `--forest`

  用层级关系展示进程与父进程的关系

**应用**

监测当前占用内存top10进程：

```
$ ps aux|head -1;ps aux|grep -v PID|sort -rn -k 4|head
```

监测当前占用cpu top10进程：

```
$ ps aux|head -1;ps aux|grep -v PID|sort -rn -k 3|head
```

## jps

**jps** (Java Virtual Machine Process Status Tool) 是java提供的一个显示当前所有java进程pid的命令。

## top

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

  命令输出的cpu使用率实质是按cpu个数*100%计算

- %MEM：进程使用的内存占可用内存的比例

- TIME+：自进程启动到目前为止的CPU时间总量

- COMMAND：进程所对应的命令行名称，也就是启动的程序名

## df

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

## du

du (disk usage) ，通过df命令很容易发现哪个磁盘的存储空间快没了，下一步，du命令可以显示某个特定目录（默认情况下是当前目录）的磁盘使用情况。

格式：

```
 du [-H | -L | -P] [-a | -s | -d depth] [-c] [-h | -k | -m | -g] [-x] [-I mask] [file ...]
```

参数：

- `-c` 

  显示所有已列出文件总的大小

- `-h` 

  按用户易读的格式输出大小

- `-s` 

  显示每个输出参数的总计，相当于`-d 0`

- `-d depth`

  要展示的文件的深度

举例：

- 查看当前文件夹多大

  ```
  $ du -sh
  ```

- 查看当前文件夹下所有文件夹总大小

  ```
  $ du -sh ./*
  ```

  

## free

free 命令显示系统内存的使用情况。

- `-h` 　以易读的方式显示内存使用情况

## netstat

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

## ss

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

## lsof

lsof (list open files) ，一个列出当前系统打开文件的工具。

举例：

- 查看9999对应的端口

  ```
  $ lsof -i :9999
  ```
