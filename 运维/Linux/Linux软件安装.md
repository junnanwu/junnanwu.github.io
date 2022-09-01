# Linux软件安装

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

## maven

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

[ClickHouse的安装](../数据/ClickHouse/ClickHouse)

## Elasticsearch

[Elasticsearch/Kibana的安装](../数据/Elasticsearch/Elasticsearch的安装和配置)

## References

1. https://docs.nginx.com/nginx/admin-guide/installing-nginx/installing-nginx-open-source/
2. https://www.cnblogs.com/AlanLee/p/12650223.html
3. https://docs.docker.com/engine/install/centos/

