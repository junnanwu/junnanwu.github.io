# Linux软件安装

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


## ClickHouse

[ClickHouse的安装](../数据/ClickHouse/ClickHouse)

## Elasticsearch

[Elasticsearch/Kibana的安装](../数据/Elasticsearch/Elasticsearch的安装和配置)



