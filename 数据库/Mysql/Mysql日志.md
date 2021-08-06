## binlog

记录了所有的DDL和DML语句

主要目的：

- 主从复制
- 数据恢复

可以借助mysql自带的mysqlbinlog工具可以查看binlog

### 实战

#### 数据恢复

（都是泪水）

**步骤1：查看是否开启了binlog**

```
show variables like '%log_bin%';
```

变量`log_bin`如果为ON就表示开启了binlog

**步骤2：找到binlog文件**

目录如下：

```
/data/mysql/logs/my3306/binlog/mysql-bin
```

里面有多个文件，可以通过`ll`命令找到最新更新的那个

**步骤3：根据已知条件进行查找**

```
sudo ./mysqlbinlog --no-defaults --database=data_web --base64-output=decode-rows -v --start-datetime="2021-08-04 17:00:00" --stop-datetime="2021-08-04 18:00:00" /data/mysql/logs/my3306/binlog/mysql-bin.000029 |grep tag_sys |more
```

参数：

- 查看库：`data_web`

- 表：`tag_sys`

-  时间为`2021-08-04 17:00:00 - 2021-08-04 16:00:00`的语句

- `--base64-output=decode-rows -v`

  输出base64编码的语句，并将基于行的语句解码成一个SQL语句

输出结果：

```
#210804 17:35:08 server id 1003306  end_log_pos 1041026775 CRC32 0x2fad5075 	Table_map: `data_web`.`tag_sys` mapped to number 64
413
### DELETE FROM `data_web`.`tag_sys`
```

**步骤4：精确定位**

确定了具体时间17:35:08，就可以缩小范围进一步搜索

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
###   @13='jiangliping@kungeek.com'
###   @14='2021-07-19 10:39:54'
###   @15='jiangliping@kungeek.com'
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

