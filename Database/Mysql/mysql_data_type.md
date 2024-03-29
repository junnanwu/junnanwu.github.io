# MySQL数据类型

## 存储限制

从MySQL开始默认的表存储引擎是InnoDB，它是面向ROW存储的

- 每个page = 16KB
- 每行最大65535字节
- 每行最小2字节，那么最多就有7992行



### 整数类型

整数类型的存储范围

| **类型**  | **字节** | **最小值**              | **最大值**              | 长度 |
| --------- | -------- | ----------------------- | ----------------------- | ---- |
|           |          | **(带符号的/无符号的)** | **(带符号的/无符号的)** |      |
| TINYINT   | 1        | -128                    | 127                     | 3    |
|           |          | 0                       | 255                     | 3    |
| SMALLINT  | 2        | -32768                  | 32767                   | 5    |
|           |          | 0                       | 65535                   | 5    |
| MEDIUMINT | 3        | -8388608                | 8388607                 | 7    |
|           |          | 0                       | 16777215                | 8    |
| INT       | 4        | -2147483648             | 2147483647              | 10   |
|           |          | 0                       | 4294967295              | 10   |
| BIGINT    | 8        | -9223372036854775808    | 9223372036854775807     | 19   |
|           |          | 0                       | 18446744073709551615    | 20   |

int类型占用4byte，所以无符号int最大值就是32个1，即4294967295

#### int(M)

**int(5) 其实是和另一个属性 zerofill 配合使用的，表示如果该字段值的宽度小于 5 时，会自动在前面补 0 ，如果宽度大于等于 5 ，那就不需要补 0**

![image-20210330234729339](Mysql%E5%AE%9E%E6%88%98_assets/image-20210330234729339.png)

![image-20210330234729339](Mysql%E5%AE%9E%E6%88%98_assets/image-20210330234729339.png)

当我们**再次**新增的时候，注意，不会改变已有数据

![image-20210330234849288](Mysql%E5%AE%9E%E6%88%98_assets/image-20210330234849288.png)

要写的再大一点呢？

![image-20210330235559135](Mysql%E5%AE%9E%E6%88%98_assets/image-20210330235559135.png)

那这个值的最大值是多少呢？



<img src="Mysql%E5%AE%9E%E6%88%98_assets/image-20210330235251117.png" alt="image-20210330235251117" style="zoom:50%;" />



**最大为255位**。

所以，后面写几对存储基本没有区别，不影响int类型存储的最大值。

所以自增主键的话就创建int(10)吧

### 字符类型

#### varchar

##### varchar最大长度

**清楚字节和字符**

a、我、1 都是一个字符，但是a和1是一个字节

对于汉字

- GBK下，每个汉字占2个字节
- utf8下，大部分汉字是3个字节
-  utf8mb4下，汉字也是3个字节（表情符号是4个字节）

varchar (N)：中的N指的是字符的长度，即：该字段最多能存储多少个字符(characters)，不是字节数。（5.0版本以上）

varchar 最多能存储 65535 个字节的数据。

- 字符类型若为gbk，每个字符最多占2个字节，最大长度不能超过32766


- 字符类型若为utf8，每个字符最多占3个字节，最大长度不能超过21845


- 字符类型若为utf8mb4，每个字符最多占4个字节，最大长度不能超过16283


在设置varchar长度的时候，如果超出了上述长度，就会报错

```
1074 - Column length too big for column '测试varchar' (max = 21845); use BLOB or TEXT instead
```

65535 = 所有字段的长度 + 变长字符的长度标识 + NULL标识位。

变长字符的长度标识：用1到2个字节表示实际长度（长度 >255 时,需要2个字节； <255 时，需要1个字节）

虽然InnoDB内部支持 varchar 65535 字节的行大小，但是MySQL本身对所有列的合并大小施加了 65535 字节的行大小限制，也就是说，**每一行数据限制在65535个字节**。

例：

```
create table t4(c int, c2 char(30), c3 varchar(N)) charset=utf8;

则此处N的最大值为 (65535-1-2-4-30*3)/3=21812
减 1：实际行存储从第二个字节开始;
减 2：varchar 头部的2个字节表示长度
减 4：原因是int类型的c占4个字节;
减 30*3：原因是char(30)占用90个字节，编码是utf8。
```

测试：

```
经测试，mysql5.7中执行上述插入语句N的值最大确实只能为21812
如果大于21812, 则会报如下错误：
1118 - Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs
```

##### varchar如何存储

假设varchar(50)，当存入字符长度是10位

- 此时系统就只给其分配10个存储的位置（假设不考虑系统自身的开销）
- 更改后，其数据量达到了20位。由于没有超过最大50位的限制，为此数据库还是允许其存储的。只是其原先的存储位置已经无法满足其存储的需求。此时系统就需要进行额外的操作。如根据存储引擎不同，有的会采用拆分机制，而有的则会采用分页机制。
- ？？

##### varchar长度分配

使用varchar数据类型，也不能够太过于慷慨，varchar分配不同长度，但存储相同的东西时：

存储空间相同。但是对于内存的消耗是不同的。

对于varchar数据类型来说，硬盘上的存储空间虽然都是根据实际字符长度来分配存储空间的，但是对于内存来说，则不是。其实使用固定大小的内存块来保存值。简单的说，就是使用字符类型中定义的长度。

显然，这对于**排序**或者临时表(这些内容都需要通过内存来实现)作业会产生比较大的不利影响。

一般选择一个最长的字段来设置字符长度。如果为了考虑冗余，可以留10%左右的字符长度。

#### char

char(M)定义的列的长度为固定的，M的取值可以0-255之间。

- 当保存char值时，在它们的右边填充空格以达到指定的长度。
- 当检索到char值时，尾部的空格被删除掉。在存储或检索过程中不进行大小写转换。
- char存储定长数据很方便，char字段上的索引效率很高

测试：

```
char只能插入最大255个字符，超出255会报如下错误：
1074 - Column length too big for column 'c2' (max = 255); use BLOB or TEXT instead
```

https://segmentfault.com/a/1190000019179789

#### text

存储的行也是有规定的，最多允许存储

在mysql中存储65535个字节

MySQL表的内部表示具有65,535字节的最大行大小限制，即使存储引擎能够支持更大的行也是如此。



### 问题一：mysql新建数据库怎么选排序规则

UTF8和UTF8MB4是常用的两种字符集，至于这两个选用哪个要根据自己业务情况而定。UTF8MB4兼容UTF8，比UTF8能表示更多的字符，Unicode编码区从编码区1-126属于UTF8区，当然UTF8MB4也兼容这个区，126行以下就是UTF8MB4扩充区，所以你要根据自己的业务进行选择，一般情况下UTF8就满足需求，当然如果考虑到以后扩展，比如考虑到以后存储emoji,就选择UTF8MB4，否则只是浪费空间。我建议还是选择UTF8MB4，毕竟对于大部分公司而言空间不是什么大问题。

utf8mb4_general_ci 和utf8mb4_unicode_ci 是我们最常使用的排序规则。utf8mb4_unicode_ci 校对速度快，但准确度稍差。utf8_unicode_ci准确度高，但校对速度稍慢，两者都不区分大小写。这两个选哪个视自己情况而定，还是那句话尽可能保持db中的字符集和排序规则的统计



当你用小数类型并且指定小数的时候 比如double(4,2) 或者 decimal(4,2) 这个时候，存储的都是两位小数，但是在navicat中这个零不会被显示，例如当你存储2，navicat显示的就是2，但是mysql实际存储的是2.00，java mybatis查询出来的也是2.00，你使用黑框口select* 查询出来的也是2.00，同理，当你存储2.1，navicat显示的就是2.1，但是mysql实际存储的是2.10，java mybatis查询出来的也是2.10，你使用黑框口select* 查询出来的也是2.10
所以，你如果想存8位小数，





### UNION

用于合并多个SELECT的结果集

```sql
SELECT column_name(s) FROM table_name1
UNION
SELECT column_name(s) FROM table_name2
```

**默认地，UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。**

### WITH AS

公用表CTE (Common Table Expression)

注意：

- CTE后面必须紧跟**使用CTE**的语句
- CTE后面也可以使用其他CTE，但是只能有一个with，多个CTE中间使用`,`相隔开
- 如果CTE的表达式名字与某个数据表或视图重名，则紧跟在该CTE后面的SQL语句使用的仍然是CTE，当然，后面的SQL语句使用的就是数据表或视图了
- CTE 可以引用自身，也可以引用在同一 WITH 子句中预先定义的 CTE。不允许前向引用。

```sql
with t1 as
 (select * from STUDENT),
t2 as
 (select * from score)
select * from t1, t2 where t1.stuid = t2.stuid
```

### SPLIT

### LATERAL VIEW EXPLODE

用与行转列，是LATERAL VIEW和EXPLODE的结合。

**EXPLODE**

这是Hive内置的函数，官方解释如下：

> Takes in an array (or a map) as an input and outputs the elements of the array (map) as separate rows. UDTFs can be used in the SELECT expression list and as a part of LATERAL VIEW.

意思是接受一个array或者map类型的作为输入，然后将array或map里面的元素按照每行的形式输出。

EXPlODE是一个UDTF，即一个输入，多个输出

> 拓展：
>
> Hive自定义函数包括三种
>
> - UDF(User-Defined-Function) 一进一出
> - UDAF(User- Defined Aggregation Funcation) 聚集函数，多进一出，如`count`/`max`/`min`
> - UDTF(User-Defined Table-Generating Functions) 一进多出，如`lateral view explore()`

用法：

- 用于`array`的语法如下：

  ```sql
  select explode(arraycol) as newcol from tablename;
  ```

- 用于`map`的语法如下：

  ```sql
  select explode(mapcol) as (keyname,valuename) from tablename;
  ```

例如：

```
hive (default)> select explode(array('A','B','C')); 
OK 
A 
B 
C 
Time taken: 4.188 seconds, Fetched: 3 row(s) 
 
hive (default)> select explode(map('a', 1, 'b', 2, 'c', 3)); 
OK 
key    value 
a    1 
b    2 
c    3 
```

**LATERAL VIEW**

>The `LATERAL VIEW` clause is used in conjunction with generator functions such as `EXPLODE`, which will generate a virtual table containing one or more rows. `LATERAL VIEW` will apply the rows to each original output row.

LATERAL VIEW是Hive中提供给UDTF的结合，它可以解决UDTF不能添加额外的select列的问题，翻译为侧视图。

>A lateral view first applies the UDTF to each row of base table and then joins resulting output rows to the input rows to form a virtual table having the supplied table alias.

LATERAL VIEW和UDTF一起使用，LATERAL VIEW首先将每个输入行应用UDTF，然后对结果行和输入行进行JOIN，将JION之后的数据插入到虚拟表中，重复此步骤直至最后一行。

用法如下：

```sql
LATERAL VIEW [ OUTER ] generator_function ( expression [ , ... ] ) [ table_alias ] AS column_alias [ , ... ]
```

- table_alias即为UDTF函数转换的虚拟表的名称
- column_alias：表示虚拟表的虚拟字段名称，如果分裂之后有一个列，则写一个即可；如果分裂之后有多个列，按照列的顺序在括号中声明所有虚拟列名，以逗号隔开

LATERAL VIEW关键字用法举例：

```
刘德华    演员,导演,制片人 
李小龙    演员,导演,制片人,幕后,武术指导 
李连杰    演员,武术指导 
刘亦菲    演员 
```

希望转换成下面：

```
刘德华 演员 
刘德华 导演 
刘德华 制片人 
李小龙 演员 
李小龙 导演 
李小龙 制片人 
李小龙 幕后 
李小龙 武术指导 
李连杰 演员
李连杰 武术指导
刘亦菲 演员
```

首先

```sql
select explode(split(userrole,',')) from  ods.ods_actor_data;
```

```
演员 
导演 
制片人 
演员 
导演 
制片人 
幕后 
武术指导 
演员
武术指导
演员
```

理论上我们把username也选出来就行了，但是UDTF函数不能和其他函数一起使用，类似UDAF(sum)，UDAF是因为聚合后行数变少了，其他字段是多个不同的值，无法聚合为一个，而UDTF是行数变多了，其他列不知道如何对应。

```sql
select 
   username,role 
from 
    ods.ods_actor_data 
LATERAL VIEW 
    explode(split(userrole,',')) tmpTable as role;
```

### CONCAT_WS

Concatenate With Separator

```
mysql> SELECT CONCAT_WS(',','First name','Second name','Last Name');
		-> 'First name,Second name,Last Name'
```

可用于列转行



注意：

需要将`my.cnf`权限改为mysql认可的664。

### 读取顺序

```
$ mysql --verbose --help | grep my.cnf
```

查看说明文档可以看到：

>Default options are read from the following files in the given order:
>/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf





## References

1. https://dev.mysql.com/doc/refman/5.7/en
1. https://stackoverflow.com/questions/20461030/current-date-curdate-not-working-as-default-date-value
