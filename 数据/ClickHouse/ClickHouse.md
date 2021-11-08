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

### 安装软件

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

方式二：（如果想要下载自己想要的更新或者更旧的版本）可以自己下载rpm安装包进行安装，[点此下载](https://repo.yandex.ru/clickhouse/rpm/stable/x86_64/)

- 需要下载三个包，最好一样的版本

  - `clickhouse-common-static` — ClickHouse编译的二进制文件。
  - `clickhouse-server` — 创建`clickhouse-server`软连接，并安装默认配置服务
  - `clickhouse-client` — 创建`clickhouse-client`客户端工具软连接，并安装客户端配置文件。

- rpm上传服务器，分别安装

  ```
  #依赖项common-static需要先安装
  $ rpm -ivh clickhouse-common-static-20.9.3.45-2.x86_64.rpm clickhouse-client-20.9.3.45-2.noarch.rpm clickhouse-server-20.9.3.45-2.noarch.rpm
  ```

### 修改配置文件

- `config.xml`

  - 这里需要开启允许其他IP连接，默认只允许本机连接

    ```xml
    <listen_host>::</listen_host>
    ```

- `user.xml`

  这里需要设置用户的密码
  
  ```xml
  <password>123456</password>
  ```

### 修改数据目录

我们可以看到ClickHouse使用的默认的数据文件夹如下：

```xml
<path>/var/lib/clickhouse/</path>
<tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
<user_files_path>/var/lib/clickhouse/user_files/</user_files_path>
```

由于公司的服务器默认给`/data`了很大的分区，专门用于存放数据，我在安装的时候没有将数据目录指定到`/data`下，导致其他分区inode很快用完了，所以，要将数据放在`/data`下（取决服务器的分区）

服务器分区如下：

```
$ df
文件系统           1K-块     已用      可用 已用% 挂载点
devtmpfs        16379192        0  16379192    0% /dev
tmpfs           16390100       24  16390076    1% /dev/shm
tmpfs           16390100      948  16389152    1% /run
tmpfs           16390100        0  16390100    0% /sys/fs/cgroup
/dev/vda1       51473868 12459740  36816884   26% /
/dev/vdb1      515927296 25023880 464672684    6% /data
tmpfs            3278020        0   3278020    0% /run/user/0
tmpfs            3278020        0   3278020    0% /run/user/1002
```

修改数据文件有两种方法：

方法一：修改配置文件

将上面的配置文件中的`/var/lib/clickhouse`和`var/log/clickhouse-server`修改为`/data/clickhouse/data`和`/data/clickhouse/log`，并创建对应的文件夹，修改属主为ClickHouse。

方法二：建立软连接

思路是不修改配置文件，将原系统默认位置下的数据和日志复制到/data/clickhouse下，并在原文件位置建立软连接。

- 在合理的分区创建日志和数据文件夹

- 复制数据、日志 删除原文件夹、修改属主（如果是新的ClickHouse，则不需要复制数据）

  ``` 
  $ sudo mv /var/lib/clickhouse/* /data/clickhouse/data/
  $ sudo mv /var/log/clickhouse-server/* /data/clickhouse/log/
  ```
  
- 修改属主

  ```
  $ sudo chown -R clickhouse:clickhouse /data/clickhouse/data/
  $ sudo chown -R clickhouse:clickhouse /data/clickhouse/log/
  ```
  
- 删除原文件夹、修改属主

  ```
  $ sudo rm -r /var/lib/clickhouse/
  $ sudo rm -r /var/log/clickhouse-server/
  ```
  
- 建立软连接

  ```
  $ sudo ln -s /data/clickhouse/data/ /var/lib/clickhouse
  $ sudo ln -s /data/clickhouse/log/ /var/log/clickhouse-server
  ```

建议采用第二种方式：

采用第一种方式需要改配置文件，而且数据会分别存储在`/var/lib/`文件（系统表）下和`/data/clickhouse/`下，不利于数据迁移，如下：

```
$ sudo ls -l /var/lib/clickhouse/metadata
lrwxrwxrwx 1 clickhouse clickhouse 63 11月  3 14:30 hxd -> /data/clickhouse/store/9ee/9eecb5e2-e144-48db-9cc0-729698e960e8
-rw-r----- 1 clickhouse clickhouse 78 11月  3 14:30 hxd.sql
lrwxrwxrwx 1 clickhouse clickhouse 67 11月  3 14:30 system -> /var/lib/clickhouse/store/2c0/2c0341a6-1658-4606-ac03-41a616588606/
-rw-r----- 1 clickhouse clickhouse 78 11月  3 14:30 system.sql
```

第二种方式不需要修改配置文件，而且数据都在一个文件夹下。

## 使用

- 启动服务

  ```
  # 21.8版本支持
  $ sudo clickhouse start
  ```

  或

  ```
  $ sudo /etc/init.d/clickhouse-server start
  ```

  前台启动

  ```
  $ sudo -u clickhouse clickhouse-server --config-file=/etc/clickhouse-server/config.xml
  ```

- 关闭服务

  ```
  $ sudo /etc/init.d/clickhouse-server stop
  ```
  
- 开启客户端

  ```
  $ clickhouse-client
  ```

### 客户端

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

  执行对应的sql文件（低版本不支持，如20年12月之前的）

  后面可以加绝对路径或者相对路径

- `--format, -f`

  使用特定的格式输出结果

- `--multiline -m`

  允许多行查询

- `--multiquery -n`

  允许多个查询使用分号分隔

例如：

- 非交互式一次提交多个语句：

  ```
  $ clickhouse-client --multiquery --query "show databases;show tables from system;"
  default
  system
  aggregate_function_combinators
  asynchronous_metrics
  build_options
  clusters
  collations
  ...
  ```

- 非交互式执行一个sql文件

  新版本支持：

  ```
  $ clickhouse-client --queries-file test.sql
  ```

  旧版本：

  ```
  $ cat test.sql|clickhouse-client -mn
  ```

  或

  ```
  $ clickhouse-client --multiquery < test.sql
  ```

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
     $ sed -i '/^COMMENT/d' test.sql
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

### 其他语句

查看ClickHouse版本

```sql
SELECT version();
```

## 数据类型

`Decimal(P, S)`

- `P` 

  precision，有效范围为`[1,76]`，表示总位数

- `S` 

  scale，有效范围为`[0,P]`，表示小数位

## 函数

- `toDecimal(32|64|128|256)`

  将一个value转换成Decimal，value可以为`number`或者`String`，S参数表示小数位数

  - `toDecimal32(value, S)`
  - `toDecimal64(value, S)`
  - `toDecimal128(value, S)`
  - `toDecimal256(value, S)`

## 备份/迁移

### 方式一

采用复制数据文件夹的方式

主要涉及的`var/lib/clickhouse`（若更改，则为更改后数据地址）如下文件夹：

- `metadata`

  表结构数据

- `data`

  表数据

- `store`

  前两个文件里面存放的是软连接，链接到此文件夹

这里要注意：

- 数据文件夹中的`data`目录和`metadata`目录都采用的是软链接的方式，要注意软链接的地址是否存在

  ```
  $ sudo ls -l data/data/data_web/
  总用量 20
  lrwxrwxrwx 1 clickhouse clickhouse 63 11月  3 14:30 dim_ftsp_cust_base_info -> /data/clickhouse/store/a06/a067d774-79a9-4808-b107-93a184790c83
  lrwxrwxrwx 1 clickhouse clickhouse 64 11月  3 14:30 dm_ftsp_cust_tag_ctd -> /data/clickhouse/store/ae4/ae4f7e2b-4bd9-4cad-ae4f-7e2b4bd91cad/
  ```

- 要注意文件最后的属主要改为ClickHouse

- 建议使用前台启动命令，方便查看启动日志保存信息

### 方式二

#### 导出结构和数据

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

#### 执行表结构语句

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

20.3.10版本不支持`--queries-file`参数，参考上面如何非交互式执行sql文件。

#### 执行插入语句

注意，采用上述方式导出的数据只是像csv一样的纯数据，而不是导出的insert插入语句，需要使用insert into语句并指定FORMAT为导出时候的格式。

例如：

将导出的hxd.dwd_hxd_third_jxfp表的数据插入ClickHouse 

```
$ cat hxd_dwd_hxd_third_jxfp_data.sql | clickhouse-client --password=xxxxxx --query "insert into hxd.dwd_hxd_third_jxfp FORMAT TabSeparated"
```

### 方式三

select出远程的表然后进行插入：

```
INSERT INTO ... SELECT ...
```

### 方式四

[clickhouse-copier](https://clickhouse.com/docs/en/operations/utilities/clickhouse-copier/)、[clickhouse-backup](https://github.com/AlexAkulov/clickhouse-backup)等工具

## 卸载

1. 查看ClickHouse安装包

   ```
   $ rpm -qa |grep clickhouse
   clickhouse-server-21.7.4.18-2.noarch
   clickhouse-common-static-21.7.4.18-2.x86_64
   clickhouse-client-21.7.4.18-2.noarch
   ```

2. 移除上面每个服务

   ```
   sudo rpm -e clickhouse-common-static-21.7.4.18-2.x86_64 clickhouse-client-21.7.4.18-2.noarch clickhouse-server-21.7.4.18-2.noarch
   ```
   
3. 卸载重新安装的时候，注意不论是使用yum还是rpm卸载，都会存在数据文件夹和配置文件所在文件夹未清理的情况，尤其是卸载新版本安装旧版本的时候，很可能出现不兼容的情况，所以要关注以下两个地方的目录，如果想安装一个新的ClickHouse，可以将数据文件和配置文件清除：

   - `/etc/clickhouse-*`
   - `/var/lib/clickhouse/*`

## Reference

1. https://github.com/ClickHouse/ClickHouse/issues/4491
2. https://clickhouse.com/docs/en/operations/backup/
3. https://github.com/ClickHouse/ClickHouse



