# Linux输入和输出

## 标准文件描述符

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

## 阻止命令输出

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