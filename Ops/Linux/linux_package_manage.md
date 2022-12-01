# Linux包管理

## 包管理

各种包管理器都利用一个数据库来记录各种相关内容：

- Linux系统上已安装了什么软件包
- 每个包安装了什么文件
- 每个已安装软件包的版本

软件包存储在服务器上，可以利用本地Linux系统上的PMS工具通过互联网访问。这些服务器称为仓库(repository)。

软件包通常会依赖其他的包，为了前者能够正常运行，被依赖的包必须提前安装在系统中，包管理工具将会检测这些依赖关系，并在安装需要的包之前先安装好所有额外的软件包。

### RPM

RPM (redhat package manager) 是Red Hat Linux推出的包管理器，能轻松的实现软件的安装，软件包管理器内部有一个数据库，其中记载着程序的基本信息，校验信息，程序路径信息等。

但是RPM的缺点就是无法解决软件直接复杂的依赖关系。

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
