# ClickHouse备份迁移

## 方式一

复制数据文件，如果是相同版本推荐此种方式，速度较快。

### 相同版本

相同版本之间迁移，直接复制数据文件夹（配置文件中的）即可，如下：

```
<!-- Path to data directory, with trailing slash. -->
<path>/data/clickhouse/data/</path>
```

经实测，20.3.18是可以的。

### 不同版本

不同版本之间的迁移，可以采用上述方式测一下，如果版本差异较大，可以采取先建表，再将data_path下的数据及data文件夹复制一下。

不推荐此种方式，不同版本推荐使用方式三。

## 方式二

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

20.3.10版本不支持`--queries-file`参数，参考上面如何非交互式执行sql文件。

### 执行插入语句

注意，采用上述方式导出的数据只是像csv一样的纯数据，而不是导出的insert插入语句，需要使用insert into语句并指定FORMAT为导出时候的格式。

例如：

将导出的hxd.dwd_hxd_third_jxfp表的数据插入ClickHouse 

```
$ cat hxd_dwd_hxd_third_jxfp_data.sql | clickhouse-client --password=xxxxxx --query "insert into hxd.dwd_hxd_third_jxfp FORMAT TabSeparated"
```

## 方式三

select出远程的表然后进行插入：

```
INSERT INTO ... SELECT ...
```

## 方式四

[clickhouse-copier](https://clickhouse.com/docs/en/operations/utilities/clickhouse-copier/)、[clickhouse-backup](https://github.com/AlexAkulov/clickhouse-backup)等工具
