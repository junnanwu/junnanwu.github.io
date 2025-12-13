# 环境变量

在 Linux 系统中，环境变量是用来定义系统运行环境的一些参数，比如每个用户不同的家目录（HOME）、邮件存放位置（MAIL）等，这也是存储持久数据的一种简便方法。

环境变量分为两类：

- 局部环境变量

  **局部变量则只对创建它们的shell可见。**

  Linux系统也默认定义了标准的局部环境变量。不过你也可以定义自己的局部变量，这些变量被称为用户定义局部变量

- 全局环境变量

  **全局环境变量对于shell会话和所有生成的子shell都是可见的。**

（用户定义变量包括用户定义局部变量和用户定义全局变量）

## set

我们知道，Bash执行脚本的时候，会新建一个shell，`set`就是用来修改这个环境的

`set`在没有任何参数的时候表示：显示所有环境变量，**包括全局变量和局部变量以及用户定义变量**，同下`env`的区别就是它会按照字母顺序对结果进行排序

## env

**显示全局变量**

要显示个别环境变量的值，可以使用printenv命令

```
$ printenv HOME
```

或者

```
$ echo $HOME
```

## 定义局部环境变量

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

## 定义全局环境变量

在设定全局环境变量进程的子进程中，该变量都是可见的。

创建全局环境变量的方法是先创建一个局部环境变量，然后再把它导出到全局环境中。

这个过程通过export命令来完成，变量名前面不需要加`$`。

### export

作用就是设置或显示全局环境变量

格式：

```
export [-fnp][变量名称]=[变量设置值]
```

### unset

**删除环境变量**

```
$ unset my_variable
```

在处理全局环境变量时，如果你是在子进程中删除了一个全局环境变量， 这只对子进程有效。该全局环境变量在父进程中依然可用。

注意：

- **如果要用到变量，使用`$`，如果要操作变量，不使用`$`**。这条规则的一个例外就是printenv显示某个变量的值。

## PATH环境变量

当你在shell命令行界面中输入一个外部命令时，shell必须搜索系统来找到对应的程序。PATH环境变量定义了用于进行命令和程序查找的目录。PATH中的目录使用冒号分隔。

添加新PATH环境变量

```
PATH=$PATH:/home/christine/Scripts
```

**不建议将本目录`.`添加到PATH中**

因为工作目录经常变动，如果别用用心者在`/tmp`目录下添加了一个自定义的`ls`命令，如果你此时使用的是root权限，那么将非常危险。

## 环境变量持久化

在你登入Linux系统启动一个bash shell时，默认情况下bash会在几个文件中查找命令。这些文件叫作启动文件或环境文件

启动bash shell有3种方式：

- 登录时作为默认的shell
- 作为非登录shell的交互式shell
- 作为运行脚本的非交互shell

**bash检查的启动文件取决于你启动bash shell的是上面三种的何种方式**

## 启动文件

### 登录shell

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

### 交互式shell进程

如果你的bash shell不是登录系统时启动的(比如是在命令行提示符下敲入bash时启动)，那么你启动的shell叫作交互式shell。

如果bash是作为交互式shell启动的，它就不会访问`/etc/profile`文件，只会检查用户HOME目录中的`.bashrc`文件。

`.bashrc`文件有两个作用：一是查看`/etc`目录下通用的`bashrc`文件，二是为用户提供一个定制自己的命令别名。

### 非交互式shell

系统执行shell脚本的时候用的就是这种shell。

在启动非交互式shell后，它会检查`BASH_ENV`环境变量中指定的启动文件，默认这个环境变量是空的。

如果没有设置，那么shell脚本去哪里获取环境变量呢？

有些shell脚本是通过启动某些子shell来执行的，子shell可以继承父shell导出过的变量。

如果父shell是登录shell，在`/etc/profile`、`/etc/profile.d/*.sh`和`$HOME/.bashrc`文件中设置并导出了变量，用于执行脚本的子shell就能够继承这些变量。

对于那些不启动子shell的脚本，变量已经存在于当前shell中了。所以就算没有设置`BASH_ENV`，也可以使用当前shell的局部变量和全局变量。

## 设置技巧

对全局环境变量来说，可能更倾向于将新的或修改过的变量设置放在`/etc/profile`文件中，但如果升级了所用的发行版， 这个文件也会跟着更新，那你所有定制过的变量设置可就都没有了。 

最好是在`/etc/profile.d`目录中创建一个以`.sh`结尾的文件。把所有新的或修改过的全局环境变量设置放在这个文件中。

在大多数发行版中，存储个人用户永久性bash shell变量的地方是`$HOME/.bashrc`文件。你还可以把自己的alias设置放在`$HOME/.bashrc`启动文件中，使其效果永久化。

## source

格式：

```
.  filename [arguments]
source filename [arguments]
```

source命令也称为"点命令"，也就是一个点符号`.`，是bash的内部命令，修改环境变量后，需要source使其生效。

功能：使读入指定的Shell程序文件并依次执行文件中的所有语句。

```
$ source filename 
或 
$ . filename
```

`source filename` 与 `sh filename` 及`./filename`执行脚本的区别在哪里呢？

`sh filename` sh是外部命令，**会重新建立一个子shell**，在子shell中执行脚本里面的语句，该子shell继承父shell的环境变量，但子shell新建的、改变的变量不会被带回父shell。