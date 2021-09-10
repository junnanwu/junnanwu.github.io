# Shell脚本

创建shell脚本的时候，必须在第一行指定要使用的shell，除了第一行之外，可以使用`#`作为注释行。

```sh
#！/bin/bash
```

## 脚本构建基础

### 显示消息

echo命令后面的字符串可以使用单引号或者双引号，如果字符串中用了其中一种，那么文本需要使用另一种引号。

- ```sh
  echo "wu's mac"
  ```

- ```sh
  'wu says "Hello"'
  ```

### 变量

**环境变量**

可以使用`$`来直接使用这些变量

只要脚本中出现`$`，它就会以为你在引用一个变量，如果想单纯输出`$`，那么可以使用`\`进行转义。

**用户变量**

- 使用等号将值赋给用户变量，用户变量的生命周期从脚本开始开始运行到结束
- 在变量，等号，值之间不能出现空格

### 命令替换

有两种方法可以将命令输出赋给变量：

- 反引号

  ```sh
  testing=`date`
  ```

- `$()`

  ```sh
  testing=$(date)
  ```

shell会运行命令替换符号中的命令，并将其输出赋给变量testing。

```sh
#!/bin/bash
testing=$(date)
echo "The date and time are: " $testing
```

注意：命令替换就创建一个子shell

### 重定向输入和输出

**输出重定向**

命令的输出会被保存到指定的输出文件中

```
command > outputfile
```

如果输出文件已经存在了，重定向操作符会用新的文件数据覆盖已有文件，如果你不想替换，可以使用`>>`来追加数据。

**输入重定向**

输入重定向将文件的内容重定向到命令

```sh
wc < test6
2 11 60
```

- 文本的行数
- 文本的词数
- 文本的字节数

### 管道

将一个命令的输出作为另一个命令的输入

```sh
rpm -qa > rpm.list
sort < rpm.list
```

或更常见：

```sh
command1 | command2
```

不要以为由管道串起的两个命令会依次执行。Linux系统实际上会同时运行这两个命令，在系统内部将它们连接起来。在第一个命令产生输出的同时，输出会被立即送给第二个命令。数据传输不会用到任何中间文件或缓冲区。

故上述脚本可以替换为：

```sh
rpm -qa | sort
```

可以在一条命令中使用任意多条管道。

比较实用的一个是使用more来一次显示一屏内容：

```sh
rpm -qa | sort | more
```

### 执行数学运算

**expr命令**

**方括号**

```sh
var1=$[1 + 5]
echo $var1
```

但是bash shell数学运算符只支持整数运算，而zsh提供了完整的浮点数算术操作。

或者脚本中使用`bc`命令：

这里就可以使用命令替换了：

```sh
variable=$(echo "options; expression" | bc)
```

- options允许你设置变量。如果你需要不止一个变量，可以用分号将其分开。
- expression参数定义了通过bc执行的数学表达式

```sh
#!/bin/bash
var1=100
var2=45
var3=$(echo "scale=4; $var1 / $var2" | bc)
echo The answer for this is $var3
```

## 机构化命令

### if语句

```sh
if command 
then
	commands
fi
```

在其他编程语言中，if语句后面是boolean值，但是在shell中，if语句后面是一个命令，如果该命令的状态码是0，位于then的命令就会执行，如果状态码是其他值，那么then后面的就无法执行。

所以，下面then后面的语句也会执行：

```sh
#!/bin/bash
# testing the if statement if pwd
then
	echo "It worked"
fi
```

**elif语句**

```sh
if command1 
then
	commands 
elif command2 
then
	more commands 
else
	more commands
fi
```

### test命令

```sh
test condition
```

或者

方括号定义了测试条件。注意**，第一个方括号之后和第二个方括号之前必须加上一个空格：**

```sh
if [ condition ]
```

if-then语句允许你使用布尔逻辑来组合测试。有两种布尔运算符可用：

- `[ condition1 ] && [ condition2 ]`
- `[ condition1 ] || [ condition2 ]`

**数值比较**

| 比较        | 描述                   |
| ----------- | ---------------------- |
| `n1 -eq n2` | 检查n1是否与n2相等     |
| `n1 -ge n2` | 检查n1是否大于或等于n2 |
| `n1 -gt n2` | 检查n1是否大于n2       |
| `n1 -le n2` | 检查n1是否小于或等于n2 |
| `n1 -lt n2` | 检查n1是否小于n2       |
| `n1 -ne n2` | 检查n1是否不等于n2     |

```sh
if [ $value1 -gt 5 ]
```

**字符串比较**

| 比较           | 描述                   |
| -------------- | ---------------------- |
| `str1 = str2`  | 检查str1是否和str2相同 |
| `str1 != str2` | 检查str1是否和str2不同 |
| `str1 < str2`  | 检查str1是否比str2小   |
| `str1 > str2`  | 检查str1是否比str2大   |
| `-n str1`      | 检查str1的长度是否非0  |
| `-z str1`      | 检查str1的长度是否为0  |

在比较字符串的相等性时，比较测试会将所有的标点和大小写情况都考虑在内。

**文件比较**

| 比较              | 描述                                     |
| ----------------- | ---------------------------------------- |
| `-d file`         | 检查file是否存在并是一个目录             |
| `-e file`         | 检查file是否存在                         |
| `-f file`         | 检查file是否存在并是一个文件             |
| `-r file`         | 检查file是否存在并可读                   |
| `-s file`         | 检查file是否存在并非空                   |
| `-w file`         | 检查file是否存在并可写                   |
| ` -x file`        | 检查file是否存在并可执行                 |
| `-O file`         | 检查file是否存在并属当前用户所有         |
| `-G file`         | 检查file是否存在并且默认组与当前用户相同 |
| `file1 -nt file2` | 检查file1是否比file2新                   |
| `file1 -ot file2` | 检查file1是否比file2旧                   |

**使用双括号**

```
(( expression ))
```

双括号提供更多的更多的数学符号，expression可以是任意的数学赋值或比较表达式。

可以在if语句中用双括号命令

```sh
if (( $val1 ** 2 > 90 )) 
then
	(( val2 = $val1 ** 2 ))
echo "The square of $val1 is $val2"
fi
```

注意，不需要将双括号中表达式里的大于号转义。这是双括号命令提供的另一个高级特性

| 描述    |          |
| ------- | -------- |
| `val++` |          |
| `val--` |          |
| `++val` |          |
| `--val` |          |
| `!`     | 取反     |
| `~`     | 位求反   |
| `**`    | 幂运算   |
| `<<`    | 左位移   |
| `>>`    | 右位移   |
| `&`     | 位布尔和 |
| `|`     | 位布尔或 |
| `&&`    | 逻辑和   |
| `||`    | 逻辑或   |

**使用双方括号**

双方括号命令提供了针对字符串比较的高级特性，可以使用正则表达式对一个字符串进行匹配：

```sh
if [[ $USER == r* ]]
then
	echo "Hello $USER"
else 5
	echo "Sorry, I do not know you"
fi
```

在上面的脚本中，我们使用了双等号(`==`)。双等号将右边的字符串(`r*`)视为一个模式。

## 处理用户输入

### 位置参数

bash shell会将一些称为位置参数(positional parameter)的特殊变量分配给输入到命令行中的 所有参数。

简单来说 `$0` 就是你写的shell脚本本身的名字，`$1`是你给你写的shell脚本传的第一个参数，`$2` 是你给你写的shell脚本传的第二个参数

例如：

```sh
#!/bin/bash
# testing two command line parameters #
total=$[ $1 * $2 ]
echo The first parameter is $1.
echo The second parameter is $2.
echo The total value is $total.
```

执行：

```sh
./test2.sh 2 5

The first parameter is 2.
The second parameter is 5.
The total value is 10.
```

记住，每个参数都是用空格分隔的，所以shell会将空格当成两个值的分隔符。要在参数值中包含空格，必须要用引号(单引号或双引号均可)。

表示脚本名字：

```sh
name=$(basename $0)
```

### 特殊参数变量

- `$#`

  脚本运行时携带的命令行参数的个数。

  然后配合`-ne`测试命令行参数数量。

- `$*`

  变量会将命令行上提供的所有参数当作一个单词保存

- `$@`

  变量会将命令行上提供的所有参数当作同一字符串中的多个独立的单词。

  这样 你就能够遍历所有的参数值，得到每个参数。

## 呈现数据

### 标准文件描述符

Linux系统将每个对象当作文件处理。这包括输入和输出进程。

| 文件描述符 | 缩写   | 描述     |
| ---------- | ------ | -------- |
| 0          | STDIN  | 标准输入 |
| 1          | STDOUT | 标准输入 |
| 2          | STDERR | 标准错误 |

**标准输入**

STDIN文件描述符代表shell的标准输入。对终端界面来说，标准输入是键盘。

```sh
$ cat
this is a test
this is a test
this is a second test.
this is a second test.
```

当在命令行上只输入cat命令时，它会从STDIN接受输入。输入一行，cat命令就会显示出一行。

但你也可以通过STDIN重定向符号`<`强制cat命令接受来自另一个非STDIN文件的输入。

```sh
$ cat < testfile
This is the first line.
This is the second line.
This is the third line.
```

现在cat命令会用testfile文件中的行作为输入。你可以使用这种技术将数据输入到任何能从STDIN接受数据的shell命令中。

**标准输出**

代表shell的标准输出。在终端界面上，标准输出就是终端显示器。

默认情况下，大多数命令的输出导向STDOUT文件，同样可以使用输出重定向`>`来改变

```sh
ls -l > test2
```

同时，也就可以通过`>>`追加。

**标准错误**

shell对于错误消息的处理是跟普通输出分开的。如果你创建了在后台模式下运行的shell脚本，通常你必须依赖发送到日志文件的输出消息。用这种方法的话，如果出现了错误信息，这些信息是不会出现在日志文件中的。

shell或shell中运行的程序和脚本出错时生成的错误消息都会发送到标准错误这个位置。

默认情况下，STDERR文件描述符会和STDOUT文件描述符指向同样的地方(尽管分配给它们的文件描述符值不同)。也就是说，默认情况下，错误消息也会输出到显示器输出中。

**重定向错误**

- 只重定向错误

  ```sh
  ls -al badfile 2> test4
  cat test4
  ls: cannot access badfile: No such file or directory
  ```

- 重定向错误和数据

  如果想重定向错误和正常输出，必须用两个重定向符号。

  ```sh
  ls -al test test2 test3 badtest 2> test6 1> test7
  ```

  shell利用`1>`符号将ls命令的正常输出重定向到了test7文件，而这些输出本该是进入STDOUT 的。所有本该输出到STDERR的错误消息通过`2>`符号被重定向到了test6文件。





