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