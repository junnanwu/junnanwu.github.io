# ClickHouse

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
  
  参数：
  
  - `--user, -u` – The username. Default value: default
  - `--password` – The password. Default value: empty string

## 基本语句

- 导出语句

  ```
  INTO OUTFILE filename [FORMAT format]
  ```

  在select语句后面加上该子语句会将select的结果输出到指定位置的文件，filename是一个字符串

  注意：filename参数中不能识别`~`，应该使用完整路径

  [ClickHouse支持的Format](https://clickhouse.tech/docs/en/interfaces/formats/)

  - TabSeparated (default)
  - TabSeparatedWithNames
  - CSV

- 查看建表语句

  ```
  SHOW CREATE [TEMPORARY] [TABLE|DICTIONARY] [db.]table [INTO OUTFILE filename] [FORMAT format]
  ```

  查看建表语句并导出

  ```sql
  show create table data_web.pg_cust_staff into outfile '/home/jinp/data_web.pg_cust_staff.sql'
  ```
















数据类型：

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



toDecimal(32|64|128|256)

将一个value转换成Decimal，value可以为number或者String，S参数表示小数位数

- `toDecimal32(value, S)`
- `toDecimal64(value, S)`
- `toDecimal128(value, S)`
- `toDecimal256(value, S)`











