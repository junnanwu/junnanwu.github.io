# Mysql语句

## DDL

Data Definition Statements

### 创建数据库

```
CREATE DATABASE database_name;
```

### 建表语句

#### 建表指定默认集

```
...
default character set 'utf8mb4';
```

#### 默认值

参考[官方文档](https://dev.mysql.com/doc/refman/5.7/en/data-type-defaults.html)

> With one exception, the default value specified in a `DEFAULT` clause must be a literal constant; it cannot be a function or an expression. This means, for example, that you cannot set the default for a date column to be the value of a function such as `NOW()` or `CURRENT_DATE`. The exception is that, for `TIMESTAMP` and `DATETIME` columns, you can specify `CURRENT_TIMESTAMP` as the default. 

> The `BLOB`, `TEXT`, `GEOMETRY`, and `JSON` data types cannot be assigned a default value.

如果没有显式的指定默认值，那么Mysql将为其指定默认值

- 如果此列可以接受NULL，那么则显式的加上 `DEFAULT NULL` 子句
- 如果此列不接受NULL，那么mysql则没有 `DEFAULT NULL` 子句

Mysql隐式默认值的定义：

- 数值类的为0（递增则为下一个值）
- `ENUM`以外的String类型，默认值为空字符串，枚举类型默认值为第一个枚举值

### 修改表结构

#### 修改索引

- 查看索引

  ```
  show index from table;
  ```

- 创建索引

  ```
  ALTER TABLE table_name ADD {INDEX | KEY} [index_name] [index_type] (key_part,...) [index_option] ...
  
  key_part:
      col_name [(length)] [ASC | DESC]
  
  index_type:
      USING {BTREE | HASH}
      
  index_option: {
      KEY_BLOCK_SIZE [=] value
    | index_type
    | WITH PARSER parser_name
    | COMMENT 'string'
  }
  ```

- 删除索引

  ```
  ALTER TABLE table_name DROP {INDEX | KEY} index_name
  ```

### 创建索引

格式：

```
CREATE [UNIQUE | FULLTEXT | SPATIAL] INDEX index_name
    [index_type]
    ON tbl_name (key_part,...)
    [index_option]
    [algorithm_option | lock_option] ...
```

```
ALTER TABLE table_name ADD INDEX index_name ( column )
```



## DML

Data Manipulation Statements

- INSERT

  ```
  INSERT INTO 表名称 VALUES (值1, 值2,....)
  ```

- UPDATE

  ```
  UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值
  ```

  **注意：UPDATE SET后面不能加括号**

- DELETE

  ```
  DELETE FROM 表名称 WHERE 列名称 = 值
  ```

- TRUNCATE

  ```
  TRUNCATE TABLE 表名; 
  ```

### SELECT语句

### DELETE和TRUNCATE的区别

1. DELETE是将表中的数据一条一条的删除
2. TRUNCATE是将整个表摧毁，重新创建了一个新的表，表的结构和原来的一模一样
3. DELETE删除的数据能够找回，TRUNCATE删除的数据找不回来了

## 复合语句

### 流程控制语句

#### CASE语句

- 有选择的UPDATE

  ```sql
  UPDATE sys_log
  SET platform_code =
  CASE
  	WHEN event_name = "analysis_登录" THEN "analysis"
  	WHEN event_name = "dap_登录" THEN "dap"
  ELSE "usertag" END;
  ```

  ```sql
  UPDATE Personnel
  SET salary =
  CASE 
    WHEN salary >= 5000  　                THEN salary * 0.9 
    WHEN salary >= 2000 AND salary < 4600  THEN salary * 1.15 
  ELSE salary END; 
  ```

  ```sql
  UPDATE tag_filter_section 
  SET tag_system_id =
  CASE
  WHEN  LOCATE('cust',tag_name)!=0 THEN 2
  WHEN  LOCATE('staff',tag_name)!=0 THEN 3
  WHEN  LOCATE('eu',tag_name)!=0 THEN 1
  ELSE 0 END;
  ```

- 有选择的SELECT

  ```sql
  SELECT
  	CASE
  	WHEN username = 'houyaqian@kungeek.com'  THEN dept+1
  	WHEN username = 'wujunnan@kungeek.com' THEN dept
  	END
  FROM
  	sys_user 
  WHERE
  	username IN ( 'houyaqian@kungeek.com', 'wujunnan@kungeek.com' );
  ```



## 数据库管理员语句

### 账户管理语句

#### 用户相关

- 查看所有用户

  ```mysql
  SELECT user FROM mysql.user;
  ```

- 查看用户密码

  ```mysql
  SELECT host,user,authentication_string FROM mysql.user;
  ```

  （密码是加密的）

- 创建用户

  ```mysql
  CREATE USER 'username'@'host' IDENTIFIED BY 'password';
  ```

  ```mysql
  CREATE USER 'data_web'@'%' identified by 'XXXXX5Njg1NWI';
  ```

- 设置用户密码

  语法：

  ```
  SET PASSWORD [FOR user] = password_option
  
  password_option: {
      PASSWORD('auth_string')
    | OLD_PASSWORD('auth_string')
    | 'hash_string'
  }
  ```

  - `hash_string`代表编码后的密码

  - 如果没有FOR语句，则代表给当前用户设置密码

    ```
    SET PASSWORD = password_option;
    ```

  例如：

  ```mysql
  SET PASSWORD FOR root@localhost = password('CGA1S9DZegVKoSxx');
  ```

  注意：如果省略`@xx`则默认为`'%'`

- 删除用户

  ```mysql
  DROP USER 'username'@'host';
  ```

#### 权限相关

- 查看用户权限

  ```mysql
  SHOW GRANTS FOR jinp;
  ```

- 给用户赋予权限

  ```mysql
  GRANT privileges ON databasename.tablename TO 'username'@'host';
  ```

  例如：

  ```mysql
  GRANT select,insert,update,delete on data_web.* to 'data_web'@'%';
  ```

  赋予用户在data-web库的除了 `GRANT OPTION` 外的所有权限

  ```mysql
  GRANT ALL PRIVILEGES ON `data_web`.* TO 'data_web'@'%';
  ```

- 想要使某个用户拥有分配权限的权限

  ```mysql
  GRANT privileges ON databasename.tablename TO 'username'@'host' WITH GRANT OPTION;
  ```

- 刷新权限

  ```mysql
  FLUSH privileges;
  ```


注意：

- `TRUNCATE TABLE`也需要`DROP`权限。

### SHOW语句

#### SHOW VARIABLES

- 查看默认字符集

  ```
  SHOW variables LIKE 'character%';
  ```

#### SHOW PROCESSLIST 

此命令展示了目前连接到服务的线程的相关操作。

查出来的内容和 `INFORMATION_SCHEMA.PROCESSLIST`表一致。

```
mysql> SHOW FULL PROCESSLIST\G
*************************** 1. row ***************************
     Id: 9580
   User: root
   Host: localhost:57288
     db: my
Command: Sleep
   Time: 3497
  State:
   Info: NULL
*************************** 2. row ***************************
     Id: 9675
   User: root
   Host: localhost
     db: NULL
Command: Query
   Time: 0
  State: starting
   Info: SHOW FULL PROCESSLIST
*************************** 3. row ***************************
     Id: 9678
   User: root
   Host: localhost:63479
     db: davinci
Command: Sleep
   Time: 39
  State:
   Info: NULL
3 rows in set (0.00 sec)
```

字段解释：

- id

  连接的id，可以通过`CONNECTION_ID()`来获取，对应`INFORMATION_SCHEMA.PROCESSLIST`表的id。

- user

  提交语句的用户

- host

  提交语句的客户端IP

- db

  线程对应的默认数据库

- Command

  客户端执行命令的类型，session如果是空闲的，则为Sleep

- Time

  线程在当前状态的秒数

- State

  线程目前的状态

  - `starting`查询一个语句的
  - `executing`正在执行语句
  - `Killed`对应线程已经执行了KILL语句，等待下次检查kill flag
  - ...

- Info

  线程正在执行的语句，如果没有执行语句，则为NULL

### 其他管理语句

#### KILL

```
KILL [CONNECTION | QUERY] processlist_id
```

- `KIll CONNECTION`和不加修饰符是一样的，终止连接
- `KIll QUERY`终止正在执行语句，但是保留连接



### 系统变量相关

想要查看当前的系统变量，可以通过：

- `SHOW [GLOBAL|SESSION] VARIABLES [like xx]`

  不指定则返回SESSION变量

- 查看performance_schema库中的相应表

系统变量包括两部分

- global variables

  服务启动时，会被初始化

  设置全局变量

  ```
  SET GLOBAL max_connections = 1000;
  SET @@GLOBAL.max_connections = 1000;
  ```

  注意：

  上述方式在服务重启后就会失效，Mysql 5.7持久化需要修改`my.cnf`，Mysql 8.0可以通过`SET PERSIST`方式持久化，[参考此](https://dev.mysql.com/doc/refman/8.0/en/persisted-system-variables.html)。

- session variables

  当客户端连接的时候，会被初始化为`global variables`，例如，`sql_mode`

  设置session变量

  ```
  SET SESSION sql_mode = 'TRADITIONAL';
  SET @@SESSION.sql_mode = 'TRADITIONAL';
  SET @@sql_mode = 'TRADITIONAL';
  ```

很多变量是动态的，可以在运行时使用set语句

注意：

- 当给变量赋值的时候，可以使用K、M、G (不区分大小写)，来表示1024、1024^2 、1024^3

  例如：

  ```
  mysqld --innodb-log-file-size=16M --max-allowed-packet=1G
  ```

- set语句中可以使用`*`表达式，但是不能使用K、M，例如

  ```
  -- illegal
  mysql> SET GLOBAL max_allowed_packet=16M;
  -- legal
  mysql> SET GLOBAL max_allowed_packet=16*1024*1024;
  ```

  命令行的方式则相反

  ```
  -- legal
  $> mysql --max_allowed_packet=16M
  -- illegal
  $> mysql --max_allowed_packet=16*1024*1024
  ```

## References

1. https://dev.mysql.com/doc/refman/5.7/en/create-index.html
