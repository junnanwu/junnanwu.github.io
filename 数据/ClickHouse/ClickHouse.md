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

## 安装使用

可以根据[官方文档](https://clickhouse.tech/docs/zh/getting-started/install/)进行安装。

Linux推荐使用`RPM`的方式安装。

配置文件：

- `config.xml`

  这里需要开启允许其他IP连接，默认只允许本机连接。

  ```
  <listen_host>::</listen_host>
  ```

- `user.xml`

  这里需要设置用户的密码

启动：

- 启动服务

  ```
  sudo clickhouse start
  ```

- 开启客户端

  ```
  clickhouse-client
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

  执行对应的sql文件

- `--format, -f`

  使用特定的格式输出结果

- `--multiline -m`

  允许多行查询

- `--multiquery -n`

  允许多个查询使用分号分隔

## 基本语句

**数据库表结构**

- 查看建表语句

  ```sql
  SHOW CREATE [TEMPORARY] [TABLE|DICTIONARY] [db.]table [INTO OUTFILE filename] [FORMAT format]
  ```

  查看建表语句并导出

  ```sql
show create table data_web.pg_cust_staff into outfile '/home/jinp/data_web.pg_cust_staff.sql'
  ```

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

**DML**





## 数据类型

`Decimal(P, S)`

- `P` precision，有效范围为`[1,76]`，表示总位数
- `S` scale，有效范围为`[0,P]`，表示小数位

其他Decimal

- P from [ 1 : 9 ] - for Decimal32(S)
- P from [ 10 : 18 ] - for Decimal64(S)
- P from [ 19 : 38 ] - for Decimal128(S)
- P from [ 39 : 76 ] - for Decimal256(S)

小数位

- Decimal32(S) - ( -1 * 10^(9 - S), 1 * 10^(9 - S) )
- Decimal64(S) - ( -1 * 10^(18 - S), 1 * 10^(18 - S) )
- Decimal128(S) - ( -1 * 10^(38 - S), 1 * 10^(38 - S) )
- Decimal256(S) - ( -1 * 10^(76 - S), 1 * 10^(76 - S) )

For example, Decimal32(4) can contain numbers from -99999.9999 to 99999.9999 with 0.0001 step.

## 函数

- `toDecimal(32|64|128|256)`

  将一个value转换成Decimal，value可以为`number`或者`String`，S参数表示小数位数

  - `toDecimal32(value, S)`
  - `toDecimal64(value, S)`
  - `toDecimal128(value, S)`
  - `toDecimal256(value, S)`

## 数据备份

**导出结构和数据**

由于ClickHouse没有类似mysqldump的备份工具，只能通过`show table`语句来查看表结构，但是当表存在很多的时候，就需要通过脚本来实现了。

原脚本地址：

[clickhousedump](https://gist.github.com/inkrement/ea78bc8dce366866103df83ea8d36247)

对原脚本进行了小改动，如下：

```sh
#!/bin/bash
set -eu

PASSWORD="123456"

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

    # dump
    # clickhouse-client ${PASSWORD} -q "SELECT * FROM ${db}.${table} FORMAT TabSeparated" | gzip > "${OUTDIR}/${db}_${table}_data.tsv.gz"

  done < <(clickhouse-client --password=${PASSWORD} -q "SHOW TABLES FROM $db")
done < <(clickhouse-client --password=${PASSWORD} -q "SHOW DATABASES")
```

说明：

ClickHouse支持导出和导入数据的时候指定Format，默认的为TabSeparated，及将数据按照制表符的格式展示，但是当使用默认格式导出表结构的时候，会将换行符导出为`\`和`n`两个字符，导致执行的时候无法识别，这时候可以选择其他Format，例如TabSeparatedRaw；

**执行表结构语句**

同样的，由于表的数量很多，一个一个的执行建表SQL也很麻烦，可以使用下面脚本：

```sh
#! /bin/bash
set -eu
for file in `ls *sql`
do
  echo 开始执行$file
  clickhouse-client --password 123456 --queries-file '/home/jinp/sql/sql/'$file
done
```





