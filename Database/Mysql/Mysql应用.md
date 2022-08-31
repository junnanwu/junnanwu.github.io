# MySQL应用

## 时间新增当前时间

参考[官方文档](https://dev.mysql.com/doc/refman/8.0/en/timestamp-initialization.html)

默认值设置为：

```
ALTER TABLE `data_web`.`tag_section` 
ADD COLUMN `update_time` datetime(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0) COMMENT '更新时间' AFTER `section_average`;
```

## 关于Null值

当执行下面语句的时候，name为`null`的是否被筛选出来？

```sql
SELECT * FROM table WHERE name != 'abc';
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

## 排序值相等导致的分页bug

现象：发现有几条数据数据库中有，但是页面分页表格不显示。

下面是全部数据（19条）：

```
mysql> SELECT id, perm, create_time FROM sys_permission WHERE ( ( dataplatform_code = 'bi' ) ) order by create_time DESC;
+-----+------------------+---------------------+
| id  | perm             | create_time         |
+-----+------------------+---------------------+
| 118 | test             | 2021-11-25 13:54:04 |
| 117 | bi:test          | 2021-11-24 21:28:15 |
| 116 | custom:report    | 2021-11-24 19:51:47 |
| 115 | biMenu:delete    | 2021-11-24 19:51:47 |
| 114 | biMenu:edit      | 2021-11-24 19:51:47 |
| 113 | biMenu:save      | 2021-11-24 19:51:47 |
| 112 | biMenu:query     | 2021-11-24 19:51:47 |
| 111 | user:runAs       | 2021-11-24 19:51:47 |
| 110 | user:update_role | 2021-11-24 19:51:47 |
| 109 | role:update_perm | 2021-11-24 19:51:47 |
| 108 | role:save        | 2021-11-24 19:51:47 |
| 107 | role:query       | 2021-11-24 19:51:47 |
| 106 | perm:del         | 2021-11-24 19:51:47 |
| 105 | perm:save        | 2021-11-24 19:51:47 |
| 104 | perm:query       | 2021-11-24 19:51:47 |
| 103 | user:edit        | 2021-11-24 19:51:47 |
| 102 | user:query       | 2021-11-24 19:51:47 |
| 101 | user:add         | 2021-11-24 19:51:47 |
| 100 | visitor          | 2021-11-24 19:51:47 |
+-----+------------------+---------------------+
```

查询第一页（简化语句）：

```
mysql> SELECT id, perm, create_time FROM sys_permission WHERE ( ( dataplatform_code = 'bi' ) ) order by create_time DESC LIMIT 10;
+-----+------------+---------------------+
| id  | perm       | create_time         |
+-----+------------+---------------------+
| 118 | test       | 2021-11-25 13:54:04 |
| 117 | bi:test    | 2021-11-24 21:28:15 |
| 100 | visitor    | 2021-11-24 19:51:47 |
| 101 | user:add   | 2021-11-24 19:51:47 |
| 102 | user:query | 2021-11-24 19:51:47 |
| 103 | user:edit  | 2021-11-24 19:51:47 |
| 104 | perm:query | 2021-11-24 19:51:47 |
| 105 | perm:save  | 2021-11-24 19:51:47 |
| 106 | perm:del   | 2021-11-24 19:51:47 |
| 107 | role:query | 2021-11-24 19:51:47 |
+-----+------------+---------------------+
```

查询第二页：

```
mysql> SELECT id, perm, create_time FROM sys_permission WHERE ( ( dataplatform_code = 'bi' ) ) order by create_time DESC LIMIT 10, 10;
+-----+------------+---------------------+
| id  | perm       | create_time         |
+-----+------------+---------------------+
| 108 | role:save  | 2021-11-24 19:51:47 |
| 107 | role:query | 2021-11-24 19:51:47 |
| 106 | perm:del   | 2021-11-24 19:51:47 |
| 105 | perm:save  | 2021-11-24 19:51:47 |
| 104 | perm:query | 2021-11-24 19:51:47 |
| 103 | user:edit  | 2021-11-24 19:51:47 |
| 102 | user:query | 2021-11-24 19:51:47 |
| 101 | user:add   | 2021-11-24 19:51:47 |
| 100 | visitor    | 2021-11-24 19:51:47 |
+-----+------------+---------------------+
```

我们发现101、100、103、104等居然重复，114，115等缺失。

初步确定原因是mysql要排序的字段`create_time`相同导致的第一次分页相同值正序排序，第二次分页相同值倒序排序，导致中间的一些值丢失。

解决的话，加上一个排序字段`id`即可，如下：

```sql
SELECT id, perm, create_time FROM sys_permission WHERE ( ( dataplatform_code = 'bi' ) ) order by create_time DESC, id LIMIT 10;
```

我们进一步查询[官方文档](https://dev.mysql.com/doc/refman/5.7/en/limit-optimization.html)发现（官方文档举的例子跟我们这个场景几乎一样）：

>If multiple rows have identical values in the `ORDER BY` columns, the server is free to return those rows in any order, and may do so differently depending on the overall execution plan. In other words, the sort order of those rows is nondeterministic with respect to the nonordered columns.

也就是说，在多行值相同的情况下，服务器会以任意顺序返回这些行。

>In each case, the rows are sorted by the `ORDER BY` column, which is all that is required by the SQL standard.

Mysql只对`order by`关键字的顺序进行保证，其他顺序没有做任何要求。

> If it is important to ensure the same row order with and without `LIMIT`, include additional columns in the `ORDER BY` clause to make the order deterministic. For example, if `id` values are unique, you can make rows for a given `category` value appear in `id` order by sorting 

所以官方也是这样推荐的：如果你想要加不加limit都返回相同的顺序，那么最好在你排序字段的后面再加一个id字段。

## 分组排序（Mysql实现窗口函数）

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

## 分组查询所有最大值

有如下表：

| name | course | sorce |
| ---- | ------ | ----- |
| 张三 | 语文   | 100   |
| 张三 | 数学   | 70    |
| 张三 | 英语   | 80    |
| 李四 | 语文   | 100   |
| 李四 | 数学   | 80    |
| 李四 | 英语   | 90    |
| 王五 | 语文   | 90    |
| 王五 | 数学   | 80    |
| 王五 | 英语   | 90    |

Mysql：

```sql
SELECT t1.course, t1.score, name
FROM score t1
         JOIN
     (SELECT course, max(score) AS score FROM score GROUP BY course) t2
     ON (t1.course = t2.course AND t1.score = t2.score) ORDER BY course;
```

窗口函数：

以PostgreSQL为例，窗口函数语法为：

```sql
window_func() OVER(PARTITION BY [字段] ORDER BY [字段])
```

语句为：

```sql
SELECT * FROM (SELECT e.*, max(e.score) OVER(PARTITION BY e.course) AS max_score FROM public.score e) t WHERE score = max_score;
```

## 将聚合指标填充到某一列（跨表更新）

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

## 根据另一张表更新本表的列

```sql
update api_call_log t1, api_token t2 set t1.caller_name = t2.department_name where t1.token = t2.token and  t1.token is not null;
```

## 一个语句多where条件

**题目：**

有两张表，部门表department，部门编号dept_id，部门名称dape_name，员工表employee，员工编号emp_id，员工姓名，部门编号，薪酬emp_wage。

要求使用一条SQL完成如下统计：

部门编号、部门名称、部门5K以下员工数、部门5K以下薪酬总额、5K-10K员工人数、5K-10K薪酬总计、10K以上员工总数、部门员工人数总数、部门薪酬合计、部门薪酬平均、部门薪酬最大值、部门薪酬最小值。

**SQL类型：**

Mysql5.7

**数据准备：**

```SQL
-- 创建部门
DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `dept_id` int(11) NOT NULL,
  `dept_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`dept_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 插入部门数据
INSERT INTO `department` VALUES (1, '人力资源部');
INSERT INTO `department` VALUES (2, '数据平台部');
-- 新建员工表
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `emp_id` int(11) NOT NULL,
  `emp_name` varchar(255) DEFAULT NULL,
  `dept_id` int(11) DEFAULT NULL,
  `emp_wage` int(11) DEFAULT NULL,
  PRIMARY KEY (`emp_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
-- 插入员工数据
INSERT INTO `employee` VALUES (1, '小贺', 1, 4000);
INSERT INTO `employee` VALUES (2, '小彪', 1, 8000);
INSERT INTO `employee` VALUES (3, '小姜', 1, 12000);
INSERT INTO `employee` VALUES (4, '小李', 2, 4000);
INSERT INTO `employee` VALUES (5, '小武', 2, 2000);
INSERT INTO `employee` VALUES (6, '小侯', 2, 9000);
INSERT INTO `employee` VALUES (7, '小博', 2, 7000);
INSERT INTO `employee` VALUES (8, '小萧', 2, 18000);
```

**目标语句：**

```sql
SELECT t.dept_id 部门编号,t.dept_name 部门名称,
SUM(IF(t.rank=1, 1, 0)) '部门5K以下员工人数' ,
SUM(IF(t.rank=1,t.emp_wage,0)) '部门5K以下薪酬小记',
SUM(IF(t.rank=2, 1, 0)) '部门5K-10K员工人数' ,
SUM(IF(t.rank=2,t.emp_wage,0)) '部门5K-10K薪酬小记',
SUM(IF(t.rank=3, 1, 0)) '部门10K以上员工人数' ,
SUM(IF(t.rank=3,t.emp_wage,0)) '部门10K以上薪酬小记',
COUNT(emp_id) '部门员工人数总计',
SUM(emp_wage) '部门薪酬合计',
MAX(emp_wage) '部门薪酬最大值',
AVG(emp_wage) '部门薪酬平均值',
MIN(emp_wage) '部门薪酬最小值'
FROM(
SELECT e.dept_id,d.dept_name,e.emp_wage,e.emp_id,
case when emp_wage < 5000 then 1
when emp_wage >= 5000 and emp_wage < 10000 then 2
when emp_wage >= 10000 then 3
end `rank`
FROM employee e LEFT JOIN department d ON e.dept_id = d.dept_id) t GROUP BY dept_id;
```

## 行转列

**题目：**

已知表grade：

| name | cource | grade |
| ---- | ------ | ----- |
| 张三 | 语文   | 75    |
| 张三 | 数学   | 80    |
| 张三 | 英语   | 90    |
| 李四 | 语文   | 95    |
| 李四 | 数学   | 55    |

请将上表已下表的形式输出：

| name | 语文 | 数学 | 英语 |
| ---- | ---- | ---- | ---- |
| 张三 | 75   | 80   | 90   |
| 李四 | 95   | 55   | 0    |

**SQL类型：**

Mysql5.7

**数据准备：**

```sql
-- 新建grade表
DROP TABLE IF EXISTS grade;
CREATE TABLE grade (
  name varchar(255) ,
  course varchar(255),
  grade integer
);

-- 插入测试数据
BEGIN;
INSERT INTO grade VALUES ('张三', '语文', 75);
INSERT INTO grade VALUES ('张三', '数学', 80);
INSERT INTO grade VALUES ('张三', '英语', 90);
INSERT INTO grade VALUES ('李四', '语文', 95);
INSERT INTO grade VALUES ('李四', '数学', 55);
COMMIT;
```

**目标语句：**

```sql
SELECT name, 
MAX(CASE course WHEN '语文' THEN grade ELSE 0 END) 语文,
MAX(CASE course WHEN '数学' THEN grade ELSE 0 END) 数学,
MAX(CASE course WHEN '英语' THEN grade ELSE 0 END) 英语
FROM grade GROUP BY name;
```

**备注：**

对应了SQLServer的[PIVOT](https://docs.microsoft.com/en-us/sql/t-sql/queries/from-using-pivot-and-unpivot?view=sql-server-ver15).

```sql
SELECT * FROM grade PIVOT(MAX(分数) FOR 课程 IN (语文,数学,英语)) a;
```

还有类似场景：

每一行是一个人周一到周日某一天的收入，转换成每一行是一个人从周一到周日每一天的总收入，只需将上述中的max改为sum即可。
