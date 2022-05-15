# Mysql函数和运算符

## 函数

### LOCATE

- 格式一

  ```
  LOCATE(substr, str);
  ```

  返回`substr`在`str`中第一次出现的位置

- 格式二

  ```
  LOCATE(substr, str, pos);
  ```

  返回`substr`在`str`的pos位置起第一次出现的位置

例如：

```
-- 2
SELECT LOCATE('b','abc');

-- 4
SELECT LOCATE('b','abcbc',3);
```

### IF

`IF(expr1,expr2,expr3)`

> if expr1 is TRUE (expr1 <> 0 and expr1 <=> NULL), IF() returns expr2. Otherwise, it returns expr3.

关于结果的类型：

`expr2`和`expr3`是什么类型，那么返回值就是什么类型。

例如：

- SELECT语句中使用

  ```
  -- 3
  SELECT IF(1>2, 2, 3)
  
  -- 'yes'
  SELECT IF (1<2, 'yes', 'no')
  ```

- WHERE语句中使用

  判断

  ```
  SELECT *
  FROM table
  WHERE IF(a IS NULL, b >= 100, a >= 100);
  ```

  

### 日期函数

[详见官方文档](https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_curtime)

#### CURDATE

选择当天日期

示例：

```
mysql> SELECT CURDATE();
2022-04-09
```

#### CURTIME

选择当前时间

示例：

```
mysql> SELECT CURTIME();
23:50:26
```

#### DATE_ADD/DATE_SUB

格式：

```
DATE_ADD(date,INTERVAL expr unit), DATE_SUB(date,INTERVAL expr unit)
```

示例：

- 选择指定日期后一天

  ```
  mysql> SELECT DATE_ADD('2018-05-01',INTERVAL 1 DAY);
  2018-05-02
  ```

- 选择指定日期前一年

  ```
  mysql> SELECT DATE_SUB('2018-05-01',INTERVAL 1 YEAR);
  2017-05-01
  ```

- 选择昨天0点

  ```
  mysql> SELECT DATE_FORMAT( DATE_SUB(CURDATE(), INTERVAL 1 DAY), '%Y-%m-%d 00:00:00')
  2022-04-08 00:00:00
  ```

#### DATE_FORMAT

按照指从的格式对日期进行格式化。

```
DATE_FORMAT(date,format)
```

例如：

- 指定为时间格式：

  ```
  mysql> SELECT DATE_FORMAT('2007-10-04 22:23:00', '%H:%i:%s');
  22:23:00
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

## 运算符

### GROUP...BY

distint

区别：distinct要比group...by慢很多倍

### 赋值运算符

- `:=`

  赋值运算符

  ```
  mysql> SELECT @var1, @var2;
          -> NULL, NULL
  mysql> SELECT @var1 := 1, @var2;
          -> 1, NULL
  ```

- `=`

  用作赋值运算符或比较运算符

  在set语句或者update的set子句中，`=`用来赋值，其他时候用于比较。

## References

1. https://dev.mysql.com/doc/refman/5.6/en/assignment-operators.html