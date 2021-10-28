## ClickHouse

## 什么是ClickHouse

ClickHouse是俄罗斯 Yandex开发的用于联机分析(**OLAP**)的**列式**数据库管理系统。

在列式数据库系统中，来自同一列的数据被存储在一起。

**OLAP场景的关键特征**

- 绝大多数是读请求
- 数据以相当大的批次(> 1000行)更新，而不是单行更新;或者根本没有更新。
- 已添加到数据库的数据不能修改。
- 对于读取，从数据库中提取相当多的行，但只提取列的一小部分。
- 宽表，即每个表包含着大量的列
- 查询相对较少(通常每台服务器每秒查询数百次或更少)
- 对于简单查询，允许延迟大约50毫秒
- 列中的数据相对较小：数字和短字符串(例如，每个URL 60个字节)
- 处理单个查询时需要高吞吐量(每台服务器每秒可达数十亿行)
- 事务不是必须的
- 对数据一致性要求低
- 每个查询有一个大表。除了他以外，其他的都很小。
- 查询结果明显小于源数据。换句话说，数据经过过滤或聚合，因此结果适合于单个服务器的RAM中

## 安装

可以参考[官方文档](https://clickhouse.tech/docs/zh/getting-started/install/)，CentOS推荐使用`RPM`/`yum`的方式安装。

方式一：yum的方式（默认安装最新的稳定版）：

- ClickHouse的安装包并不在Linux官方yum仓库中，需要添加官方存储库

  ```
  $ sudo yum install yum-utils
  $ sudo rpm --import https://repo.clickhouse.com/CLICKHOUSE-KEY.GPG
  $ sudo yum-config-manager --add-repo https://repo.clickhouse.com/rpm/stable/x86_64
  ```

- 运行命令安装

  ```
  $ sudo yum install clickhouse-server clickhouse-client
  ```

方式二：自己下载rpm安装包进行安装，[点此下载](https://repo.yandex.ru/clickhouse/rpm/stable/x86_64/)

- 需要下载三个包，最好一样的版本

  - `clickhouse-common-static` — ClickHouse编译的二进制文件。
  - `clickhouse-server` — 创建`clickhouse-server`软连接，并安装默认配置服务
  - `clickhouse-client` — 创建`clickhouse-client`客户端工具软连接，并安装客户端配置文件。

- rpm上传服务器，分别安装

  ```
  #依赖项common-static需要先安装
  $ rpm -ivh clickhouse-common-static-20.9.3.45-2.x86_64.rpm clickhouse-client-20.9.3.45-2.noarch.rpm clickhouse-server-20.9.3.45-2.noarch.rpm
  ```

## 使用

配置文件：

- `config.xml`

  这里需要开启允许其他IP连接，默认只允许本机连接。

  ```
  <listen_host>::</listen_host>
  ```

- `user.xml`

  这里需要设置用户的密码
  
  ```
  <password>123456</password>
  ```

使用服务：

- 启动服务

  ```
  $ sudo clickhouse start
  ```

  或

  ```
  $ sudo /etc/init.d/clickhouse-server start
  ```

  ```
  $ clickhouse-server --config-file=/etc/clickhouse-server/config.xml
  ```

- 开启客户端

  ```
  $ clickhouse-client
  ```
  
- 关闭服务

  ```
  sudo /etc/init.d/clickhouse-server stop
  ```


**关于客户端**

具体请查看官方文档：

[Command-line Client](https://clickhouse.com/docs/en/interfaces/cli/#command-line-client)

参数：

- `--user, -u` 

  用户名，默认为default

- `--password` 

  密码，默认为空字符串

- `--query -q`

  使用非交互模式，指定查询语句

- `--queries_file, -qf`

  执行对应的sql文件（低版本不支持，如20.3.x）

- `--format, -f`

  使用特定的格式输出结果

- `--multiline -m`

  允许多行查询

- `--multiquery -n`

  允许多个查询使用分号分隔

## 基本语句

### SHOW语句

- 查看表

  ```sql
  SHOW TABLES FROM data_web;
  ```

- 查看建表语句

  ```sql
  SHOW CREATE [TEMPORARY] [TABLE|DICTIONARY] [db.]table [INTO OUTFILE filename] [FORMAT format]
  ```

  查看建表语句并导出

  ```sql
  SHOW CREATE TABLE data_web.pg_cust_staff INTO OUTFILE '/home/jinp/data_web.pg_cust_staff.sql'
  ```

注意：

1. 实际使用过程中发现，存在高版本（21.8.x）导出的建表语句在低版本(20.3.x)不兼容的情况

   如：

   - 高版本导出的decimal类型默认值为""

     可能是设置错误，但是高版本兼容。

   - 高版本导出的建表语句最后的coment不能识别

     解决办法：

     如果想在低版本执行，需要批量删除最后一行commant注释，参考如下命令：

     ```
     sed '/^COMMENT/d' test.sql
     ```

   

### CREATE语句

- 创建数据库

  ```sql
  CREATE DATABASE [IF NOT EXISTS] db_name [ON CLUSTER cluster] [ENGINE = engine(...)]
  ```

  默认情况下，ClickHouse使用的是原生的数据库引擎Ordinary

- 导出语句

  ```sql
  INTO OUTFILE filename [FORMAT format]
  ```

  在select语句后面加上该子语句会将select的结果输出到指定位置的文件，filename是一个字符串

  注意：filename参数中不能识别`~`，应该使用完整路径

  [ClickHouse Formats](https://clickhouse.tech/docs/en/interfaces/formats/)

  - TabSeparated (default)
  - TabSeparatedWithNames
  - CSV

### INSERT语句



### 其他语句

查看ClickHouse版本

```sql
SELECT version();
```



## 数据类型

`Decimal(P, S)`

- `P` precision，有效范围为`[1,76]`，表示总位数
- `S` scale，有效范围为`[0,P]`，表示小数位

## 函数

- `toDecimal(32|64|128|256)`

  将一个value转换成Decimal，value可以为`number`或者`String`，S参数表示小数位数

  - `toDecimal32(value, S)`
  - `toDecimal64(value, S)`
  - `toDecimal128(value, S)`
  - `toDecimal256(value, S)`

## 数据备份

### 导出结构和数据

由于ClickHouse没有类似mysqldump的备份工具，只能通过`show table`语句来查看表结构，但是当表存在很多的时候，就需要通过脚本来实现了。

原脚本地址：

[clickhousedump](https://gist.github.com/inkrement/ea78bc8dce366866103df83ea8d36247)

对原脚本进行了小改动，如下：

```sh
#!/bin/bash
set -eu

PASSWORD="xxxxxx"

OUTDIR=.

while read -r db ; do
  while read -r table ; do

  if [ "$db" == "system" ]; then
   echo "skip system db"
   continue 2;
  fi

  if [[ "$table" == ".inner."* ]]; then
     echo "skip materialized view $table ($db)"
     continue;
  fi

  echo "export table $table from database $db"

    # dump schema
    clickhouse-client --password=${PASSWORD} -q "SHOW CREATE TABLE ${db}.${table} FORMAT TabSeparatedRaw" > "${OUTDIR}/${db}_${table}_schema.sql"

    # dump data
    # clickhouse-client --password=${PASSWORD} -q "SELECT * FROM ${db}.${table} FORMAT TabSeparatedRaw" | gzip > "${OUTDIR}/${db}_${table}_data.tsv.gz"

  done < <(clickhouse-client --password=${PASSWORD} -q "SHOW TABLES FROM $db")
done < <(clickhouse-client --password=${PASSWORD} -q "SHOW DATABASES")
```

说明：

ClickHouse支持导出和导入数据的时候指定Format，默认的为TabSeparated，及将数据按照制表符的格式展示，但是当使用默认格式导出表结构的时候，会将换行符导出为`\`和`n`两个字符，导致执行的时候无法识别，这时候可以选择其他Format，例如TabSeparatedRaw；

### 执行表结构语句

同样的，由于表的数量很多，一个一个的执行建表SQL也很麻烦，可以使用下面脚本：

```sh
#! /bin/bash
set -eu
for file in `ls *sql`
do
  echo 开始执行$file
  clickhouse-client --password xxxxxx --queries-file '/home/jinp/sql/sql/'$file
done
```

注意：

20.3.10版本不支持`--queries-file`参数

改成如下：

```sh
clickhouse-client --multiquery < '/home/jinp/table/'$file
```

### 执行插入语句

注意，采用上述方式导出的数据只是像csv一样的纯数据，而不是导出的insert插入语句，需要使用insert into语句并指定FORMAT为导出时候的格式。

例如：

将导出的hxd.dwd_hxd_third_jxfp表的数据插入ClickHouse 

```
$ cat hxd_dwd_hxd_third_jxfp_data.sql | clickhouse-client --password=xxxxxx --query "insert into hxd.dwd_hxd_third_jxfp FORMAT TabSeparated"
```

## 卸载ClickHouse

1. 查看ClickHouse安装包

   ```
   $ yum list installed| grep clickhouse
   clickhouse-client.noarch               21.8.5.7-2                     @repo.clickhouse.tech_rpm_stable_x86_64
   clickhouse-common-static.x86_64        21.8.5.7-2                     @repo.clickhouse.tech_rpm_stable_x86_64
   clickhouse-server.noarch               21.8.5.7-2                     @repo.clickhouse.tech_rpm_stable_x86_64
   ```

2. 移除上面每个服务

   ```
   $ yum erase clickhouse-client.noarch
   ...
   ```

3. 卸载重新安装的时候，注意不论是使用yum还是rpm卸载，都会存在数据文件夹和配置文件所在文件夹未清理的情况，尤其是卸载新版本安装旧版本的时候，很可能出现不兼容的情况，所以最好手动将以下两个地方的目录清理掉

   - `/etc/clickhouse-*`
   - `/var/lib/clickhouse/*`



