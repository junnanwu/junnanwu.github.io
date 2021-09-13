# SQL语句

题目1：

有两张表，部门表department，部门编号dept_id，部门名称dape_name，员工表employee，员工编号emp_id，员工姓名，部门编号，薪酬emp_wage。

要求使用一条SQL完成如下统计：

部门编号、部门名称、部门5K以下员工数、部门5K以下薪酬总额、5K-10K员工人数、5K-10K薪酬总计、10K以上员工总数、部门员工人数总数、部门薪酬合计、部门薪酬平均、部门薪酬最大值、部门薪酬最小值。

SQL类型：Mysql

数据准备：

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

目标语句：

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



