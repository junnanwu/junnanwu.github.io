# Linux软件安装

本文基于CentOS 7。

## RPM

RPM误删除了怎么办？

当误执行了`rpm -e rpm-xxx --nodeps`，RPM就被卸载了，这个时候，我们可以在一台正常的Linux机器上面执行：

```
$ whereis rpm
rpm: /usr/bin/rpm /usr/lib/rpm /etc/rpm /usr/share/man/man8/rpm.8.gz
```

然后再在RPM被卸载的机器上执行该命令，将每个目录及文件scp复制过来补全。

## Yum

Yum是Python写的，一般都是Python2，当时我们平时又会安装Python3，经常就会导致Python不可用。

当提示`no module named yum`的时候，可以先查看Python的Path，也就是说Python会从PythonPath中寻找import模块，可以在Python命令行中输入如下命令：

```
>>> import sys
>>> print(sys.path)
```

查看是否是启动的是Python2，但是Path中确是Python3的路径的情况。

如果还是不行，则可以选择卸载重新安装Python和Yum。

参考：[Centos 重装Python2.7](https://www.cnblogs.com/fan-yuan/p/15005647.html)

阿里云镜像：https://mirrors.aliyun.com/centos/7/os/x86_64/Packages

## Docker

1. 卸载旧的安装包

   ```
   # yum remove docker \
                     docker-client \
                     docker-client-latest \
                     docker-common \
                     docker-latest \
                     docker-latest-logrotate \
                     docker-logrotate \
                     docker-engine
   ```

2. 从下面链接下载安装包，然后安装

   （由于网络问题，只能采取本地下载好安装包的来安装）

   ```
   https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
   ```

3. 上传服务器

4. 安装

   ```
   # yum install -y docker-ce-18.03.1.ce-1.el7.centos.x86_64.rpm
   ```

5. 设置国内镜像源，并修改默认目录

   ```
   # vim /etc/docker/daemon.json
   {
     "graph": "/data/docker",
     "registry-mirrors": ["https://719wavvz.mirror.aliyuncs.com"]
   }
   ```

6. 启动Docker，并设置开机自启

   ```
   # systemctl start docker.service
   # systemctl enable docker.service
   ```

7. 查看安装情况

   ```
   # docker version
   ```

## Java

1. [官网](https://www.oracle.com/java/technologies/downloads/#java8)下载安装包`jdk-8u341-linux-x64.tar.gz`

2. scp上传到服务器

   ```
   $ scp jdk-8u341-linux-x64.tar.gz root@43.138.x.xx:
   ```

3. 移动到指定目录并解压

   ```
   # mv ~/jdk-8u341-linux-x64.tar.gz /data/java/
   # tar xvzf jdk-8u341-linux-x64.tar.gz
   ```

4. 设置环境变量

   ```
   # vim /etc/profile
   ```

   添加如下：

   ```
   export JAVA_HOME=/data/java/jdk1.8.0_341
   export JRE_HOME=${JAVA_HOME}/jre
   export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib:$CLASSPATH
   export JAVA_PATH=${JAVA_HOME}/bin:${JRE_HOME}/bin
   export PATH=$PATH:${JAVA_PATH}
   ```

5. 使环境变量生效

   ```
   # source /etc/profile
   ```

6. 测试

   ```
   # java -version
   java version "1.8.0_341"
   ```

## Git

1. 下载安装包

   ```
   $ wget https://www.kernel.org/pub/software/scm/git/git-2.3.0.tar.xz
   ```

2. 解压、编译

   ```
   $ tar -vxf git-2.3.0.tar.xz
   $ cd git-2.3.0
   $ make prefix=/usr/local/git all
   $ make prefix=/usr/local/git install
   ```

3. 加入PATH

   ```
   $ echo "export PATH=$PATH:/usr/local/git/bin" >> /etc/profile
   $ source /etc/profile
   ```

4. 查看git版本

   ```
   $ git --version
   ```

   

## Nginx

1. 安装EPEL仓库

   (EPEL是由Fedora社区打造，为RHEL及其衍生发行版如CentOS等提供高质量软件包，相当于添加了一个第三方源)

   ```
   # yum install epel-release
   ```

2. 安装Nginx

   ```
   # yum install nginx
   ```

3. 检查版本

   ```
   # nginx -v
   ```

## cnpm

1. 需要先安装node.js

2. npm安装

   ```
   $ npm install -g cnpm --registry=https://registry.npm.taobao.org
   node-v8.11.4/bin/cnpm -> /node-v8.11.4/lib/node_modules/cnpm
   ```

3. 建立软连接

   ```
   $ ln  -s /node-v8.11.4/bin/cnpm /usr/bin/cnpm
   ```

## node

升级node

使用n模块

1. 安装n模块

   ```
   $ npm install -g n
   ```

2. 升级node.js

   - 升级到最新稳定版

     ` /usr/local/node/bin/n`

     ```
     $ n stable
     ```

   - 升级到最新版

     ```
     $ n latest
     ```

   - 升级到指定版本

     ```
     n v7.10.0
     ```

## Maven

1. 下载压缩包

   http://maven.apache.org/download.cgi

   下载bin.tar.gz后缀的

2. scp上传

3. 解压并移到目标目录

   ```
   $ tar -zxvf apache-maven-3.8.3-bin.tar
   ```

4. 设置环境变量

   ```
   $ vi /etc/profile
   
   export MAVEN_HOME=/usr/local/apache-maven-3.6.1
   export PATH=$MAVEN_HOME/bin:$PATH 
   ```

5. 使环境变量生效

   ```
   $ source /etc/profile
   ```

6. 检查版本

   ```
   $ mvn -v 
   ```

## Gradle

[官网下载](https://gradle.org/releases/)对应版本，上传即可

## MySQL

1. [官网](https://downloads.mysql.com/archives/community/)下载安装包，并上传到服务器，解压

2. 移动并重命名

   ```
   # mv mysql-5.7.38-linux-glibc2.12-x86_64 /usr/local/mysql
   ```

3. 创建mysql用户和用户组

   ```
   # groupadd mysql
   # useradd -r -g mysql mysql
   ```

4. 创建mysql数据文件夹并修改数据文件夹权限

   ```
   # mkdir -p /data/mysql
   # chown mysql:mysql -R /data/mysql
   ```

5. 添加配置文件

   ```
   # vim /etc/my.cnf
   ```

   添加如下内容：

   ```
   [mysqld]
   basedir=/usr/local/mysql
   datadir=/data/mysql
   log_error=/data/mysql/mysql.err
   pid-file=/data/mysql/mysql.pid
   
   #binlog
   log_bin=bin.log
   server_id=1
   
   #log
   log_timestamps=SYSTEM
   
   #character config
   character_set_server=utf8mb4
   ```

6. MySQL初始化

   ```
   # cd /usr/local/mysql/bin/
   # ./mysqld --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql/ --datadir=/data/mysql/ --user=mysql --initialize
   ```

   初始化操作包括：

   - 生成一个默认的密码
   - 初始化数据目录

   注意如果此步骤报错：

   ```
   ./mysqld: error while loading shared libraries: libnuma.so.1: cannot open shared object file: No suc
   ```

   则安装：

   ```
   # yum -y install numactl
   ```

7. 查看默认密码

   ```
   # cat /data/mysql/mysql.err
   ```

8. 复制文件

   ```
   # cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
   ```

9. 启动MySQL

   ```
   # service mysql start
   ```

10. 登录并修改密码

    ```
    $ ./mysql -u root -p
    > SET PASSWORD = PASSWORD('123456');
    > ALTER USER 'root'@'localhost' PASSWORD EXPIRE NEVER;
    > use mysql
    > update user set host = '%' where user = 'root';
    > FLUSH PRIVILEGES; 
    ```

11. 创建软链接

    ```
    $ ln -s /usr/local/mysql/bin/mysql /usr/bin
    ```

## ClickHouse

[ClickHouse的安装](../../Database/ClickHouse/ClickHouse)

## Elasticsearch

[Elasticsearch/Kibana的安装](../../Database/Elasticsearch/elasticsearch_install_config)

## References

1. Nginx官方文档：[Installing NGINX Open Source](https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/)
3. Docker官方文档：[Install Docker Engine on CentOS](https://docs.docker.com/engine/install/centos/)
3. 博客：[Centos 重装Python2.7](https://www.cnblogs.com/fan-yuan/p/15005647.html)

