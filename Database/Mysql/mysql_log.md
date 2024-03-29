# MySQL日志

## bin log

记录了所有的DDL和DML语句

主要目的：

- 主从复制
- 数据恢复

可以借助mysql自带的mysqlbinlog工具可以查看binlog。

- `expire_logs_days`

  **查看binlog日志保留日期**

  ```mysql
  show variables like '%expire_logs_days%';
  ```

  默认值是`0`，意味着不自动删除日志。

### bin log格式

> Prior to MySQL 5.7.7, statement-based format was the default. In MySQL 5.7.7 and later, row-based format is the default.

bin log有三种格式：

- statement-based

  基于语句的记录

- row-based

  基于表的行的变化来记录

- mixed logging

  这种模式下，优先使用基于语句模式

查看binlog存储格式：

```
show variables like '%binlog_format%';
```

### 开启bin log

MySQL bin log默认是关闭的，编辑`my.conf`的`[mysqld]`部分 ，加入如下配置然后重启即可：

```
#binlog
log-bin=bin.log
server_id=1
```

### 查看bin log

格式：

```
mysqlbinlog [options] log_file ...
```

options：

- `--base64-output=value `

  value取值如下：

  - `AUTO`

    该选项的默认值

  - `NEVER`

  - `DECODE-ROWS`

- `--verbose -V`

  将行事件解释为带注释的SQL语句

- `--database=db_name -d db_name`

  > This option causes mysqlbinlog to output entries from the binary log (local log only) that occur while `db_name` is been selected as the default database by `USE`.


### 实战

#### 数据恢复

（都是泪水）

**步骤1：查看是否开启了binlog**

```
show variables like '%log_bin%';
```

变量`log_bin`如果为ON就表示开启了binlog，同时也会显示binlog的位置

**步骤2：找到binlog文件**

例如，目录如下：

```
/data/mysql/logs/my3306/binlog/mysql-bin
```

里面有多个文件，可以查看文件的更改时间，来确定文件

**步骤3：根据已知条件进行查找**

```
sudo ./mysqlbinlog --no-defaults --database=data_web --base64-output=decode-rows -v --start-datetime="2021-08-04 17:00:00" --stop-datetime="2021-08-04 18:00:00" /data/mysql/logs/my3306/binlog/mysql-bin.000029 |grep tag_sys |less
```

查看`data_web`库的`tag_sys`表，日志时间为`2021-08-04 17:00:00 - 2021-08-04 16:00:00`的语句，`--base64-output=decode-rows -v`作用是输出base64编码的语句，并将基于行的语句解码成一个SQL语句。

输出结果：

```
#210804 17:35:08 server id 1003306  end_log_pos 1041026775 CRC32 0x2fad5075 	Table_map: `data_web`.`tag_sys` mapped to number 64
413
### DELETE FROM `data_web`.`tag_sys`
```

**步骤4：精确定位**

确定了具体时间`17:35:08`，就可以缩小范围进一步搜索

命令：

```
sudo ./mysqlbinlog --no-defaults --database=data_web --base64-output=decode-rows -v --start-datetime="2021-08-04 17:34:00" --stop-datetime="2021-08-04 17:36:00" /data/mysql/logs/my3306/binlog/mysql-bin.000029 |more
```

结果：

```
/*!50530 SET @@SESSION.PSEUDO_SLAVE_MODE=1*/;
/*!50003 SET @OLD_COMPLETION_TYPE=@@COMPLETION_TYPE,COMPLETION_TYPE=0*/;
DELIMITER /*!*/;
# at 4
#210802  1:30:53 server id 1003306  end_log_pos 123 CRC32 0xecfca5ec 	Start: binlog v 4, server v 5.7.28-log created 210802  1:30
:53
# Warning: this binlog is either in use or was not closed properly.
# at 1041026464
#210804 17:35:08 server id 1003306  end_log_pos 1041026529 CRC32 0x9316ac19 	GTID	last_committed=468585	sequence_number=468
586	rbr_only=yes
/*!50718 SET TRANSACTION ISOLATION LEVEL READ COMMITTED*//*!*/;
SET @@SESSION.GTID_NEXT= 'ae315716-38f4-11eb-a09f-00163e14bc96:1443471'/*!*/;
# at 1041026529
#210804 17:35:08 server id 1003306  end_log_pos 1041026605 CRC32 0x3f39196b 	Query	thread_id=135283	exec_time=0	err
or_code=0
SET TIMESTAMP=1628069708/*!*/;
SET @@session.pseudo_thread_id=135283/*!*/;
SET @@session.foreign_key_checks=1, @@session.sql_auto_is_null=0, @@session.unique_checks=1, @@session.autocommit=1/*!*/;
SET @@session.sql_mode=1344274432/*!*/;
SET @@session.auto_increment_increment=1, @@session.auto_increment_offset=1/*!*/;
/*!\C utf8mb4 *//*!*/;
SET @@session.character_set_client=45,@@session.collation_connection=45,@@session.collation_server=33/*!*/;
SET @@session.lc_time_names=0/*!*/;
SET @@session.collation_database=DEFAULT/*!*/;
BEGIN
/*!*/;
# at 1041026605
# at 1041026678
#210804 17:35:08 server id 1003306  end_log_pos 1041026775 CRC32 0x2fad5075 	Table_map: `data_web`.`tag_sys` mapped to number 64
413
# at 1041026775
#210804 17:35:08 server id 1003306  end_log_pos 1041027001 CRC32 0x85141037 	Delete_rows: table id 64413 flags: STMT_END_F
### DELETE FROM `data_web`.`tag_sys`
### WHERE
###   @1=409
###   @2='first_sign_date'
###   @3='首次签订合同日期'
###   @4=75
###   @5=4
###   @6=1
###   @7=1
###   @8=1
###   @9='客户首次签订合同的审核通过日期'
###   @10=NULL
###   @11=NULL
###   @12='2021-07-19 10:39:54'
###   @13='jiangliping@xxx.com'
###   @14='2021-07-19 10:39:54'
###   @15='jiangliping@xxx.com'
###   @16=2
###   @17=2
###   @18=2
###   @19=1
###   @20=NULL
###   @21=2
###   @22=NULL
# at 1041027001
#210804 17:35:08 server id 1003306  end_log_pos 1041027032 CRC32 0x07e02214 	Xid = 28636201
COMMIT/*!*/;
SET @@SESSION.GTID_NEXT= 'AUTOMATIC' /* added by mysqlbinlog */ /*!*/;
DELIMITER ;
# End of log file
```

从而找到了完整的删除语句，可以使用insert语句再次插入。

### 删除binlog

非主从数据库删除所有binlog日志文件，清空索引，重新开始新的日志文件。

```
reset master;
```

不能用于有任何slave 正在运行的主从关系的主库。因为在slave 运行时刻 reset master 命令不被支持，reset master 将master 的binlog从000001 开始记录,slave 记录的master log 则是reset master 时主库的最新的binlog,从库会报错无法找的指定的binlog文件。

`PURGE`

格式：

```
PURGE { BINARY | MASTER } LOGS {
    TO 'log_name'
  | BEFORE datetime_expr
}
```

不改变索引位置。

- 删除此时间点之前的log

  ```
  purge master logs before '2022-03-17 14:03:50';
  ```

- 删除`mysql-bin.000004`之前的文件（不包括本身）

  ```
  purge master logs to 'mysql-bin.000004'
  ```




## slow query log

慢查询由查询时间超过`long_query_time` 或查询行数超出`min_examined_row_limit`的语句组成。

> The slow query log consists of SQL statements that take more than `long_query_time` seconds to execute and require at least `min_examined_row_limit` rows to be examined. 

默认情况下，slow query日志是关闭的。

- 查看slow query  log是否开启

  ```
  show variables like 'slow_query_log';
  ```

- 查看`long_query_time` 

  ```
  show variables like '%long_query_time%';
  ```

  最小值为`0`，默认值为`10`

- 查看`min_examined_row_limit`

  ```
  show variables like '%min_examined_row_limit%';
  ```

  最小值为`0`，默认值为`0`

- `log_slow_admin_statements`

  是否记录管理员语句

-  `log_queries_not_using_indexes` 

  是否将不使用索引的语句记录入slow query log

  （不会记录少于2行的表）

- `log_throttle_queries_not_using_indexes`

  开启上述变量后，可以使用该变量来控制记录不使用索引语句的速率 

### 查看slow query log

可以使用mysqldumpslow来查看slow query log

格式：

```
mysqldumpslow [options] [log_file ...]
```

选项：

- `-a`

  不要将数值展示为N，字符串展示为S

- `-r`

  输出结果反转排序

- `-g`

  输出匹配的结果

- `-s`

  输出排序后的结果

- `-t N`

  输出前N个结果

例如：

(此mysql的`long_query_time`为`0.2`)

```
./mysqldumpslow -a /data/mysql/logs/my3306/slowlog/mysql-slow.log-2022041510

Reading mysql slow query log from /data/mysql/logs/my3306/slowlog/mysql-slow.log-2022041510
Count: 1  Time=0.44s (0s)  Lock=0.00s (0s)  Rows=1431.0 (1431), data_web[data_web]@[127.0.0.1]
  SELECT action_content ->> '$.properties.tag_id' AS tagId FROM sys_log WHERE action_content ->> '$.properties.tag_id' != '' AND log_time >= '2022-01-15 10:45:21.257'

Count: 1  Time=0.42s (0s)  Lock=0.00s (0s)  Rows=21.0 (21), data_web[data_web]@[127.0.0.1]
  SELECT id,column_guid,table_guid,table_name,column_name,column_type,has_parent,column_comment,column_business_logic,column_calculation_logic,column_data_standard,is_primary_key,is_foreign_key,process_rule,create_time,update_time,create_user,update_user,is_sync,sensitive_type  FROM warehouse_table_column_info  WHERE  table_guid = 'odps.hsz_sap.ods_ftsp_kh_qy_ztxx_record_ctd'

Count: 1  Time=0.42s (0s)  Lock=0.00s (0s)  Rows=1431.0 (1431), data_web[data_web]@[127.0.0.1]
  SELECT action_content ->> '$.properties.tag_id' AS tagId FROM sys_log WHERE action_content ->> '$.properties.tag_id' != '' AND log_time >= '2022-01-15 10:01:20.789'
```

字段解释：

- Time

  查询时间

- Lock

  获取锁的时间

- Rows

  向客户端发送的条数

注意：

- 从Mysql 5.7.38开始，错误语法语句不会被记录入slow query log

### 清理slow qurey log

- 查看show query log位置

  ```
  show variables like '%slow%';
  ```

- 清除日志文件内容

  ```
  $ > mysql-slow.log
  ```

## redo log

redo log用来保证事务的持久性。

当事务提交的时候，必须先将该事务的所有日志写入到redo log进行持久化。

- redo log记录的是物理日志，记录的是页的物理操作修改
- undo log记录的是逻辑日志，根据每行记录进行记录。

为了确保每次日志都被持久化，每次将redo log缓冲写入redo log文件中之后，InnoDB都会调用一次fsync操作，即立即将页缓存刷到磁盘中，保证真正的持久化。

fsync的效率取决于磁盘的性能，因此磁盘的性能决定了事务提交的性能，也就是数据库的性能。

`innodb_flush_log_at_trx_commit`用来控制重做日志刷新到磁盘的策略：

- `1`

  默认值，表示该事务提交时必须调用一次fsync操作。

- `0`

  表示事务提交时不进行写入重做日志记录，这个操作由master thread执行，每秒执行一次。

- `2`

  表示事务提交时将redo log写入文件系统缓存中，但是不进行fsync操作，这个情况下，Mysql宕机不会导致事务丢失，操作系统宕机会导致文件系统缓存中未fsync那部分事务丢失。

针对这里的一个优化：

一次插入大量数据，开启事务后，应该在全部语句插入之后再进行COMMIT操作，而不是每条记录都进行COMMIT，这样即避免了频繁的fsync操作，还使得中间出错的时候回滚到事务最开始的确定状态。

与binlog的区别：

- binlog是Server层面的，Mysql中的任何存储引擎都会产生bin log，redo log是InnoDB存储引擎产生的
- binlog是逻辑日志，而redo log是物理日志，记录了page页的修改
- 写入的时间也不同，bin log是在事务提交后，一次写入，而redo log是在事务进行的过程中并发写入的

**LSN**

日志序列号（Log Sequence Number, LSN），其表示的含义有：

- 重做日志写入的总量
- checkpoint的位置
- 页的版本

例如当前LSN为1000，有一个事务T1写入了100字节的重做日志，那么LSN就变成了1100，若又有事务T2写入了200字节的重做日志，那么LSN就变成了1300。

每个页的头部，有一个FIL_PAGE_LSN，记录了该页的LSN。在页中，LSN代表该页最后刷新时LSN的大小。

在InnoDB启动的时候，不管上次是否正常关闭，都会尝试进行恢复操作，恢复的部分为checkpoint开始的部分。

## undo log

undo log来帮事务回滚及MVCC的功能。

在对数据库进行修改的时候，InnoDB不仅会产生redo log还会产生undo log。

**回滚**

如果用户执行的事务或语句由于某种原因失败了，又或者用户用一条ROLLBACK语句请求回滚，就可以利用这些undo log将数据回滚到修改之前的样子。

undo log做的是与之前完全相反的事情，例如每个INSERT，InnoDB都会生产一个DELETE。

**MVCC**

MVCC的版本是通过undo log来实现的。

## References

1. 《MySQL技术内幕-INNODB存储引擎》——姜承尧
1. https://dev.mysql.com/doc/refman/8.0/en/mysqlbinlog.html
1. https://dev.mysql.com/doc/refman/5.7/en/slow-query-log.html
