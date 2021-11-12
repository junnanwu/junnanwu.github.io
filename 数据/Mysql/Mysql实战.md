# Mysql实战

## 存储限制

从MySQL开始默认的表存储引擎是InnoDB，它是面向ROW存储的

- 每个page = 16KB
- 每行最大65535字节
- 每行最小2字节，那么最多就有7992行

## 数据类型

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

- 

存储的行也是有规定的，最多允许存储

在mysql中存储65535个字节

MySQL表的内部表示具有65,535字节的最大行大小限制，即使存储引擎能够支持更大的行也是如此。



### 问题一：mysql新建数据库怎么选排序规则

UTF8和UTF8MB4是常用的两种字符集，至于这两个选用哪个要根据自己业务情况而定。UTF8MB4兼容UTF8，比UTF8能表示更多的字符，Unicode编码区从编码区1-126属于UTF8区，当然UTF8MB4也兼容这个区，126行以下就是UTF8MB4扩充区，所以你要根据自己的业务进行选择，一般情况下UTF8就满足需求，当然如果考虑到以后扩展，比如考虑到以后存储emoji,就选择UTF8MB4，否则只是浪费空间。我建议还是选择UTF8MB4，毕竟对于大部分公司而言空间不是什么大问题。

utf8mb4_general_ci 和utf8mb4_unicode_ci 是我们最常使用的排序规则。utf8mb4_unicode_ci 校对速度快，但准确度稍差。utf8_unicode_ci准确度高，但校对速度稍慢，两者都不区分大小写。这两个选哪个视自己情况而定，还是那句话尽可能保持db中的字符集和排序规则的统计



当你用小数类型并且指定小数的时候 比如double(4,2) 或者 decimal(4,2) 这个时候，存储的都是两位小数，但是在navicat中这个零不会被显示，例如当你存储2，navicat显示的就是2，但是mysql实际存储的是2.00，java mybatis查询出来的也是2.00，你使用黑框口select* 查询出来的也是2.00，同理，当你存储2.1，navicat显示的就是2.1，但是mysql实际存储的是2.10，java mybatis查询出来的也是2.10，你使用黑框口select* 查询出来的也是2.10
所以，你如果想存8位小数，



小数类型

小数如何存储

单精度和双精度



## 语句

### SQl基本语句书写规范

- SELECT

  ```
  SELECT 字段名 FROM 表名
  ```

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

- GROUP BY

  ```
  SELECT Customer,OrderDate,SUM(OrderPrice) FROM Orders GROUP BY Customer,OrderDate
  ```

  注意：GROUP BY 后面多个字段不能加括号

### CASE...WHEN

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

### GROUP...BY

distint

区别：distinct要比group...by慢很多倍

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

## 函数

### IF

`IF(expr1,expr2,expr3)`

> if expr1 is TRUE (expr1 <> 0 and expr1 <=> NULL), IF() returns expr2. Otherwise, it returns expr3.

关于结果的类型：

`expr2`和`expr3`是什么类型，那么返回值就是什么类型。

举例：

```
-- 3
SELECT IF(1>2, 2, 3)

-- 'yes'
SELECT if (1<2, 'yes', 'no')
```



### NVL

Null Value Logic

`NVL(E1, E2)`

如果E1为NULL，则函数返回E2，否则返回E1本身

### 窗口函数

`OVER(PARTITION BY)`

`OVER(PARTITION BY 列名1 ORDER BY 列名2 )`

聚合函数对一组值执行计算并返回单一的值，如`sum()`，`count()`等，但是有时候一组数据只返回一个值是不能满足需求的，如我们想知道每个班级的最高分，可以使用聚合函数，但是我们想看每个班级的成绩前几名，就需要开窗函数了。

开窗函数，分析函数用于计算基于组的某种聚合值，它和聚合函数的不同之处是：每组返回多行，而聚合函数每个组只返回一行。

SQLServer, Mysql, Oracle都有窗口函数，其中mysql出的比较晚，8.0以上版本才有

开窗函数也叫分析函数，有两类，一类是聚合开窗函数，一类是排序开窗函数。

查询每个班的第一名的成绩

```sql
SELECT * FROM 
(select t.name,t.class,t.sroce,rank() over(partition by t.class order by t.sroce desc) mm from T2_TEMP t) 
where
mm = 1;
```

### 排序函数

- `ROW_NUMBER() OVER`

  (对相等的值不进行区分)

  将select查询到的数据进行排序，每一个数据加一个序号

  其基本原理是先使用over子句中的排序语句对记录进行排序，然后按照这个顺序生成序号。

  语法：

  ```sql
  ROW_NUMBER() OVER(PARTITION BY COLUMN ORDER BY COLUMN)
  ```

  ```sql
  SELECT *, Row_Number() OVER (partition by deptid ORDER BY salary desc) rank FROM employee
  ```

  表示根据部门进行分组，显示每个部门的工资等级，即新增了一列rank，里面为排名

  对学生成绩进行排序

  ```sql
  SELECT ROW_NUMBER() over(order by studentScore desc) number,* FROM studentScore
  ```

  获取第二个同学的成绩信息

  ```sql
  SELECT * FROM (
  SELECT ROW_NUMBER() over(order by studentScore desc) number,* FROM studentScore
  ) t
  WHERE
  t.number=2
  ```

- `RANK()`

  排名函数，这里遇到排名相同的学生的时候，`RANK()`会给他们相同的序号

- `DENSE_RANK()`

  与上面`RANK()`的区别就是排序的连续性，`DENSE_RANK()`排名是连续的

- `NTILE()`

  把有序的数据集合平均分配到指定的数量n的桶中

## 索引

建立的唯一索引A、B，如果有两行都为null、1，那么唯一索引如何处理，是否会有冲突，怎么个失效法



实战：

原语句：

```sql
SELECT name, staff_email FROM dim_ftsp_staff_info WHERE staff_email LIKE "wangming%" LIMIT 10;
```

Explain：

```
id	select_type	table 	             partitions	type possible_keys	key	key_len	ref	rows	filtered	Extra
1	  SIMPLE	    dim_ftsp_staff_info		          ALL			                            68390	 11.11	  Using where
```

用时：0.032000s

给staff_email列创建索引

```
id	select_type	  table      	     partitions	type	possible_keys	key	key_len	ref	rows	filtered	Extra
1	  SIMPLE	   dim_ftsp_staff_info	         	 ALL					                        68390	 11.11	 Using where
```





## 场景与分析

### 分组排序（Mysql实现窗口函数）

例如：

有一个如下成绩表，需要按照性别分组对成绩进行排序：

```
+----+--------+-------+
| id | gender | grade |
+----+--------+-------+
|  1 | 男     |    70 |
|  2 | 女     |    80 |
|  3 | 男     |    90 |
|  4 | 女     |   100 |
|  5 | 男     |    30 |
|  6 | 女     |    60 |
+----+--------+-------+
```

结果如下：

```
+----+--------+-------+---------+
| id | gender | grade | ranking |
+----+--------+-------+---------+
|  4 | 女     |   100 |       0 |
|  2 | 女     |    80 |       1 |
|  6 | 女     |    60 |       2 |
|  3 | 男     |    90 |       0 |
|  1 | 男     |    70 |       1 |
|  5 | 男     |    30 |       2 |
+----+--------+-------+---------+
```

语句如下：

```mysql
SELECT
	t1.*,
	COUNT( t2.id ) AS ranking
FROM
	student_grade t1
	LEFT JOIN student_grade t2 ON t1.gender = t2.gender AND t1.grade < t2.grade 
GROUP BY
	t1.id,
	t1.gender,
	t1.grade 
ORDER BY
	t1.grade,
	t1.grade ASC;
```

用窗口函数实现：

```sql
SELECT *, Row_Number() OVER (partition by gender ORDER BY grade desc) rank FROM student_grade
```

### 将聚合指标填充到某一列（跨表更新）

需求：还以上述例子为背景，新增一列为性别平均成绩，即avg，请填充该列。

结果为：

```
+----+--------+-------+-------+
| id | gender | grade | avg   |
+----+--------+-------+-------+
|  1 | 男     |    70 | 63.33 |
|  2 | 女     |    80 | 80.00 |
|  3 | 男     |    90 | 63.33 |
|  4 | 女     |   100 | 80.00 |
|  5 | 男     |    30 | 63.33 |
|  6 | 女     |    60 | 80.00 |
+----+--------+-------+-------+
```

类似需求还有夸表更新，比如将上述子表换成另一张表，有两个字段为性别和性别平均年纪，更新到此表中。

```sql
UPDATE student_grade t1
LEFT JOIN ( SELECT gender, avg( grade ) AS avg FROM student_grade GROUP BY gender ) t2 ON t1.gender = t2.gender 
SET t1.avg = t2.avg;
```

这种语法为UPDATE JOIN语法：

```sql
UPDATE T1, T2,
[INNER JOIN | LEFT JOIN] T1 ON T1.C1 = T2. C1
SET T1.C2 = T2.C2, 
    T2.C3 = expr
WHERE condition
```

等效于下面的写法：

```sql
UPDATE student_grade t1 , (SELECT gender, avg(grade) AS avg FROM student_grade GROUP BY gender) t2
SET  t1.avg = t2.avg WHERE  t1.gender = t2.gender;
```

这个UPDATE语句与具有INNER JOIN子句的UPDATE JOIN工作相同：

```sql
UPDATE T1, T2
SET T1.c2 = T2.c2,
      T2.c3 = expr
WHERE T1.c1 = T2.c1 AND condition
```

## 全局设置

### `global.sql_mode`

报如下异常：

```
SELECT list is not in GROUP BY clause and contains nonaggregated column .... incompatible with sql_mode=only_full_group_by
```

即，没在group by中出现的字段或者聚合字段不能出现在select语句中。

>In MySQL 5.7, the `ONLY_FULL_GROUP_BY` SQL mode is enabled by default because `GROUP BY` processing has become more sophisticated to include detection of functional dependencies. 

执行下面语句：

```
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
```

## 其他

### null值与`!= `、`not like`

当执行下面语句的时候，name为`null`的是否被筛选出来？

```sql
SELECT * FROM table WHERE name!='abc';
```

答案是：不会。

> The `WHERE` clause, if given, indicates the condition or conditions that rows must satisfy to be selected. *`where_condition`* is an expression that evaluates to true for each row to be selected. The statement selects all rows if there is no `WHERE` clause.

WHERE子句后面时跟的一个`where_condition`的表达式，并且会筛选出值为`true`的行，也就是说，**当该行WHERE子句的结果为`FALSE`或`NULL`，那么这一行都不会被筛选出来**。

1. 对于`LIKE`运算符：

   `expr LIKE pat`

   > Pattern matching using an SQL pattern. Returns `1` (`TRUE`) or `0` (`FALSE`). If either *`expr`* or *`pat`* is `NULL`, the result is `NULL`.

2. 对于`NOT LIKE`运算符：

   > This is because `NULL NOT LIKE expr` always returns `NULL`, regardless of the value of *`expr`*.

3. 对于`=`、`!=`运算符：

   当输入值 存在`NULL`的时候，结果也为`NULL`。

   例如：

   ```sql
   -- 结果为NULL
   SELECT 1 = NULL;
   
   -- 结果为NULL
   SELECT 1 != NULL
   ```

其实，在关系型数据库中，大部分的函数或者运算符当输入值为`NULL`的时候，输出都为`NULL`，导致也就不会被WHERE子语句过滤出来。

如果你需要选择上`NULL`，那么你可以写如下语句：

```sql
SELECT * FROM table WHERE name!='abc' or name IS NULL;
```









