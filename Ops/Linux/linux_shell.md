# Linux Shell

系统启动什么样的shell程序取决于你个人的用户ID配置。在/etc/passwd文件中，在用户ID记录的第7个字段中列出了默认的shell程序。

不过由于bash shell广为流传，大都使用bash作为默认shell。

```
$ cat /etc/passwd | grep wujn
wujn:x:1003:1004::/home/wujn:/bin/bash
```

## Shell的父子关系

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

### exit

exit命令用于退出子shell，当在父shell中输入exit的时候，就是退出CLI了。

### jobs

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

### 后台模式

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

#### nohup

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

## 命令分组

### 小括号（进程列表）

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

### 花括号

命令分组的另一种方式是花括号，这种方式不会创建子进程。

```
{ pwd; ls; cd /etc; pwd; cd; pwd; ls; }
/home/wujn
data  data-backend-execute.sh  nohup.out
/etc
/home/wujn
data  data-backend-execute.sh  nohup.out
```

## 外部命令

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

### which

which指令会在环境变量`$PATH`设置的目录里查找符合条件的文件。

外部命令，也就是存在于bash shell之外的程序，可以通过which命令查找

举例：

- 查找java命令的位置

  ```
  $ which java 
  /data/jdk1.8.0_151/bin/java
  ```

### type

解某个命令是否是内建的

```
$ type cd
cd is a shell builtin
```

## 内建命令

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

### history

显示最近输入的命令。

默认显示1000条，修改环境变量`HISTSIZE`可以更改这个设置。

### alias

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

## References

1. 文档：[Red Hat Enterprise Linux - What Are the Log Files That Are Located in /var/log and What Do They Do?](https://support.hpe.com/hpesc/public/docDisplay?docId=c02947726)