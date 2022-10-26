# MySQL配置相关

本文基于MySQL 5.7。

`[group]`

group对应了不同的程序或者组。

- `[client]`
- `[mysql]`
- `[mysqld]`
- `[mysqldump]`
- `[mysqladmin] `

## 配置项

### System

#### bind_address

选项：

- `*`

  此项为默认值，接受所有的IPv4地址，如果server支持IPv6，也支持所有IPv6地址。

- `0.0.0.0`

  代表接收所有的IPv4地址。

- `::`

  代表接受所有的IPv4和IPv6的地址。

#### basedir

安装MySQL的默认目录，如果是在默认位置就不需要特别指定。

#### datadir

MySQL的数据目录。

#### log-error

错误日志数据的位置。

#### pid-file

将进程号写入该文件。

mysqld_safe 程序会使用到该文件。

#### port

服务启动使用的端口号，默认3306。

#### socket

在Unix平台，客户端连接MySQL服务器的方式有两种，分别是TCP/IP的方式和socket套接字的方式，套接字的速度更快，通过此变量可以配置套接字文件路径及名称。默认为`/tmp/mysql.sock`。

对于某些发型版本也可能不一样，例如RPMs的为`/var/lib/mysql`。

mysqld在启动的时候，会在此变量指定位置生成socket文件，然后客户端会去指定位置寻找socket文件，所以`[client]`和`[mysqld]`指定的位置应该一样。

#### sql_mode

没在group by中出现的字段或者聚合字段不能出现在select语句中。

>In MySQL 5.7, the `ONLY_FULL_GROUP_BY` SQL mode is enabled by default because `GROUP BY` processing has become more sophisticated to include detection of functional dependencies. 

执行下面语句：

```
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
```

或者通过`ANY_VALUE(arg)`函数的方式绕开此模式。

#### max_allowed_packet

允许传输的最大sql包，默认为4MB

查看：

```
SHOW GLOBAL VARIABLES LIKE 'max_allowed_packet';
```

设置：

```
#单位为字节，下面104857600即为100M
SET GLOBAL max_allowed_packet = 100 * 1024 * 1024;
```

### binlog

#### log_bin

类型为布尔类型，如果使用了`--log-bin`，则该参数为`ON`，否则为`OFF`。

也可以指定为文件名，相当于`log_bin_basename`。

如果指定了log_bin但没有指定server_id，则服务不允许启动。

> If you specify the `--log-bin` option without also specifying the `server_id` system variable, the server is not allowed to start. (Bug #11763963, Bug #56739)

#### server_id

默认值是0，在主从复制的时候，每个主从服务必须设置一个唯一的server_id。

如果将此值设置为0，则该服务拒绝任何副本的连接，作为副本，该服务也拒绝连接master。

#### binlog_format

- MIXED
- STATEMENT
- ROW（默认选项）

#### expire_logs_days

bin log的过期天数，默认为0，即不过期，单位为天，最大值为99。

#### max_binlog_size

如果单个二进制文件达到此大小，则写入下一个文件，单位为byte，默认值为`1073741824`，即1GB，最大值也是1G。

如果一个事务写入的binlog大于此值，不会被分割为多个文件，所以binlog文件大小可能大于`max_binlog_size`。

### 错误日志

#### log_timestamps

此变量控制`error log`输出时间的时区，可选值如下：

- `UTC`，此为默认值。
- `SYSTEM`，跟随系统。

### 字符集

#### character_set_server

新建数据库的默认字符集，默认为`latin1`。

## 其他问题

### MySQL忘记root密码怎么办

1. 修改MySQL配置文件

   ```
   # vim /etc/my.cnf
   [mysqld]
   skip-grant-tables
   ```

2. 重启MySQL

3. 此时不需要密码即可登录

4. 修改root密码

   ```
   > use mysql;
   > update user set authentication_string=password('xxxxxx') where user='root';
   ```

5. 推出登录

6. 删除配置文件中的`skip-grant-tables`

7. 重启MySQL即可

## References

1. https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html
1. https://dev.mysql.com/doc/refman/5.7/en/replication-options-binary-log.htm
2. https://www.bilibili.com/read/cv15775443
2. https://blog.csdn.net/hdyebd/article/details/89153934
