# Shell脚本

创建shell脚本的时候，必须在第一行指定要使用的shell，除了第一行之外，可以使用`#`作为注释行。

```
#！/bin/bash
```

## 脚本构建基础

### 显示消息

echo命令后面的字符串可以使用单引号或者双引号，如果字符串中用了其中一种，那么文本需要使用另一种引号。

- ```
  echo "wu's mac"
  ```

- ```
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

```
rpm -qa > rpm.list
sort < rpm.list
```

或更常见：

```sh
command1 | command2
```

不要以为由管道串起的两个命令会依次执行。Linux系统实际上会同时运行这两个命令，在系统内部将它们连接起来。在第一个命令产生输出的同时，输出会被立即送给第二个命令。数据传输不会用到任何中间文件或缓冲区。

故上述脚本可以替换为：

```
$ rpm -qa | sort
```

可以在一条命令中使用任意多条管道。

比较实用的一个是使用more来一次显示一屏内容：

```
$ rpm -qa | sort | more
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

### 退出脚本

shell中运行的每一个命令都使用退出状态码告诉shell它已经运行完毕，退出状态是一个0~255的整数值，在命令结束运行的时候穿给shell，可以捕获这个值并在脚本中使用。

Linux提供了一个专门的变量`$?`来保存上个已执行命令的退出状态码。

```
$ date
2021年 9月19日 星期日 13时53分54秒 CST
$ echo $?
0
```

按照惯例，一个成功结束的命令的退出状态码是0，如果一个命令结束时有错误，退出状态码就是一个正值。

无效命令会返回一个退出状态码127。

```
$ wujunnan
zsh: command not found: wujunnan
$ echo $?
127
```

Linux错误退出状态没什么标准可循，但是有一些可用的参考：

| 状态码 | 描述                                       |
| ------ | ------------------------------------------ |
| 0      | 命令成功结束                               |
| 1      | 一般性未知错误（给某个命令提供了无效参数） |
| 2      | 不合适的shell命令                          |
| 126    | 命令不可执行（用户没有执行命令的正确权限） |
| 127    | 没找到命令                                 |
| 128+x  | 与Linux信号x相关的严重错误                 |
| 130    | 通过Ctrl+C终止的命令                       |
| 255    | 正常范围之外的退出状态码                   |

默认情况下，shell脚本会以脚本中最后一个命令的退出状态码退出。

你可以使用exit命令在脚本结束时指定一个退出状态码。

注意：当使用一个`exit + 变量`的形式的时候，注意变量不能超过255。

### set

当我们不做处理，当脚本执行错误的时候，它会继续向下执行，当我们想要脚本遇到执行错误的命令的时候就停止的时候，我们可以如下操作：

```sh
# 写法一
command || { echo "command failed"; exit 1; }

# 写法二
if ! command; then echo "command failed"; exit 1; fi

# 写法三
command
if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi
```

当我们想采取继承的方式的时候，即只有命令1执行成功了再执行命令2：

```sh
command1 && command2
```

但是上述方式都只能针对一个命令，如果想全局操作：那么可以采用`set -e`的方式。

`set -e`根据返回值来判断，一个命令是否运行失败。但是，某些命令的非零返回值可能不表示失败，或者开发者希望在命令失败的情况下，脚本继续执行下去。这时可以暂时关闭`set -e`，该命令执行结束后，再重新打开`set -e`。

```sh
set +e
command1
command2
set -e
```

还有一种方法是使用`command || true`，使得该命令即使执行失败，脚本也不会终止执行。

```sh
#!/bin/bash
set -e

foo || true
echo bar
```

**例外情况**

`set -e`有一个例外情况，就是不适用于管道命令。

例如：

```bash
#!/usr/bin/env bash
set -e

foo | echo a
echo bar
```

执行结果如下：

```bash
$ bash script.sh
a
script.sh:行4: foo: 未找到命令
bar
```

上面代码中，`foo`是一个不存在的命令，但是`foo | echo a`这个管道命令会执行成功，导致后面的`echo bar`会继续执行。

`set -o pipefail`用来解决这种情况，只要一个子命令失败，整个管道命令就失败，脚本就会终止执行。

**总结**

`set`命令的上面这四个参数，一般都放在一起使用。

```
# 写法一
set -euxo pipefail

# 写法二
set -eux
set -o pipefail
```

这两种写法建议放在所有 Bash 脚本的头部。

另一种办法是在执行 Bash 脚本的时候，从命令行传入这些参数。

```sh
$ bash -euxo pipefail script.sh
```

[Reference](https://www.ruanyifeng.com/blog/2017/11/bash-set.html)

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

你可能在有些脚本中看到过if-then语句的另一种形式（看起来更像其他编程语言中的if语句）：

```sh
if command; then commands
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
| `-x file`         | 检查file是否存在并可执行                 |
| `-O file`         | 检查file是否存在并属当前用户所有         |
| `-G file`         | 检查file是否存在并且默认组与当前用户相同 |
| `file1 -nt file2` | 检查file1是否比file2新                   |
| `file1 -ot file2` | 检查file1是否比file2旧                   |

**使用双括号**

```sh
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

### read

read命令从标准输入（键盘）或另一个文件描述符中接受输入，在收到输入后，read命令会将数据放进一个变量。

参数：

- `-s`

  在输入字符时不再屏幕上显示，例如login时输入密码

- `-r`

  屏蔽`\`，如果没有该选项，则`\`作为一个转义字符，有的话` \`就是个正常的字符了

## 环境变量

| 变量 | 描述                                   |
| ---- | -------------------------------------- |
| `*`  | 含所有命令行参数（以单个文本值的形式） |
| `@`  | 含所有命令行参数（以多个文本值的形式） |
| `#`  | 命令行参数数目                         |
| `?`  | 最近使用的前台进程的退出码状态         |
| `-`  | 当前命令行选项标记                     |
| `$`  | 当前shell的进程id                      |
| `!`  | 最近执行的后台进程的PID                |
| `0`  | 命令行中使用的命令名称                 |
| `_`  | shell的绝对路径名                      |

## 操作文本

### sed

sed (stream editor)可以根据命令来处理数据流中的输入。

sed命令会做如下操作：

- 一次从输入中读取一行数据
- 根据所提供的编辑器命令匹配数据
- 按照命令修改流中的数据
- 将新的数据输出到STDOUT

在匹配完一行之后，会读取下一行并重复这个过程。

格式：

```
sed [OPTION]... {script-only-if-no-other-script} [input-file]...
```

参数：

- `-e script`

  将script中指定的命令添加到已有的命令中

  例如：

  执行多个命令：

  ```
  # -e 参数可以省略
  $ echo 你好 | sed 's/你/您/; s/好/好吗/'
  您好吗
  ```

  注意：

  - 命令之间必须用分号隔开，并且在命令末尾和分号之间不能有空格。
  - 可以用bash提供的次提示符来分隔命令（输入第一个单引号后换行，直至输入第二个单引号）

- `-f file`

  将file中指定的命令添加到已有的命令中
  
- `-i --in-place`

  直接编辑文件

SCRIPT：

script参数指定了应用于流数据上的单个命令。如果需要用多个命令，要么使用`-e`选项在命令行中指定，要么使用`-f`选项在单独的文件中指定。

- `s` 

  `s`命令会用斜线间指定的第二个文本字符串来替换第 一个文本字符串模式。

  例如：

  ```
  $ echo 你好 | sed 's/你/您/'
  您好
  ```

例如：

删除

- 删除最后一行并输出（不改变原始内容）

  ```
  $ sed '$d' test.sql
  ```

- 删除所有包含COMMANT的行

  ```
  $ sed '/COMMENT/d' test.sql
  ```

- 删除以COMMANT开头的行

  ```
  $ sed '/^COMMENT/d' test.sql
  ```

替换

- 将test.txt中的xxx替换为yyy

  ```
  $ sed s/xxx/yyy/g test.txt
  ```

  

### awk

awk程序可以：

- 定义变量来保存数据
- 使用结构化编程（if-then）语句处理数据
- 通过提取数据元素，生成报告

格式：

```
awk options program file
```

参数：

- `-f file`

  从指定的文件中读取程序

- `-F fs`

  指定一行中中的分隔符的符号

  例如：由于`/etc/passwd`文件用冒号来分隔 数字字段，因而如果要划分开每个数据元素，则必须在awk选项中将冒号指定为字段分隔符。

program：

awk脚本

- 用一对大括号来定义
- 脚本是单个文本字符串，必须放在单引号中

例如：

- awk等待从STDIN中接受数据：

  ```
  $ awk '{print "Hello World!"}'
  1
  Hello World!
  ```

- awk会自动给一行中的每个数据元素分配一个变量，awk中默认的字段分隔符是任意的空白字符（空格或制表符）

  ```
  $ echo "My name is Rich" | awk '{$4="Christine"; print $0}'
  My name is Christine
  ```

  ```
  $ cat data2.txt
  One line of test text.
  Two lines of test text.
  Three lines of test text.
  $ awk '{print $1}' data2.txt 
  One
  Two
  Three
  ```

- 从文件中读取程序

  ```
  $ cat script2.gawk
  {print $1 "'s home directory is " $6}
  $
  $ gawk -F: -f script2.awk /etc/passwd
  root's home directory is /root
  bin's home directory is /bin
  daemon's home directory is /sbin
  adm's home directory is /var/adm
  lp's home directory is /var/spool/lpd
  [...]
  Christine's home directory is /home/Christine Samantha's home directory is /home/Samantha Timothy's home directory is /home/Timothy
  ```

## 常用操作

获取路径的文件名和目录名

basename

```
$ basename /etc/sysconfig/network
network
```

dirname

```
$ dirname /etc/sysconfig/network
/etc/sysconfig
```

### 操作字符串

#### 计算字符串长度

- `${#var}`

https://blog.csdn.net/u010003835/article/details/80749220

#### 将字符串切割为数组

例如：

```
$ branch=origin/release/v2.11.2.1
```

1. `cut`

   ```
   $ echo $(echo $branch | cut -d'/' -f3)
   v2.11.2.1
   ```

2. `awk`

   ```
   $ echo $(awk -F/ '{print $3}' <<< $branch)
   v2.11.2.1
   $ echo $(awk -F/ '{print $NF}' <<< $branch)
   v2.11.2.1
   ```

   
