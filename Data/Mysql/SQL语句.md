# SQL语句

## 题目1：一个语句多where条件

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

## 题目2：行转列

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

