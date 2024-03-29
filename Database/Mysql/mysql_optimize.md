# MySQL调优

## in子句包含子查询

### 背景

买的腾讯云Mysql服务收到了CPU使用率达到100%告警，进一步排查，观察到slow query log有一条语句，每当这个语句执行就会触发CPU告警，语句如下所示（已简化）：

```sql
-- 3 s 117 ms
select * from resources where type = 0 and id in (select resources_id from resources_user where user_id = 3 union select id as resources_id from resources where user_id = 3);
```

此语句是我们使用的dolphinscheduler开源分布式任务调度平台提交到其元信息数据库的语句，其中：

- `resources`表为资源表，共3000左右条记录，此表有仅有主键列，`id`
- `resources_user`表为资源用户关系表，共计6000左右条记录，此表的索引同样只有主键列，`id`

上述语句，单独执行，需要3秒钟左右，仅两张几千条记录的表，对这样的执行时间感觉非常困惑。

### 测试

执行任何上述语句的子语句，速度都非常快：

```sql
-- 5ms
select resources_id from resources_user where user_id = 3 union select id as resources_id from resources where user_id = 3;

-- 7 ms
select * from resources where type = 0 and id in (select id as resources_id from resources where user_id = 3);

-- 5 ms
select * from resources where type = 0 and id in (select resources_id from resources_user where user_id = 3);
```

改为子语句，速度非常快：

```sql
-- 6 ms
select * from resources where type = 0 and id in (select * from (select resources_id from resources_user where user_id = 3 union select id as resources_id from resources where user_id = 3) as temp);
```

改用join速度，速度非常快：

```sql
-- 43ms
select * from resources where user_id = 6 and type = 0 union select t2.* from resources_user t1 join resources t2 on t1.resources_id = t2.id where t1.user_id = 6 and t2.type = 0;
```

增加索引后执行原语句，速度很快：

- `user_id`列普通索引

  ```sql
  -- 60 ms
  alter table resources_user add index resources_user_id_index (user_id);
  ```

  explain：

  ![explain_with_index_resources_user_id_index](mysql_optimize_assets/explain_with_index_resources_user_id_index.png)

- `resources_id`列普通索引

  ```sql
  -- 37 ms
  alter table resources_user add index resources_resources_id_index (resources_id);
  ```

  ![explain_with_index_resources_resources_id_index](mysql_optimize_assets/explain_with_index_resources_resources_id_index.png)

### 分析

原语句explain（无索引）

![explain_without_index](mysql_optimize_assets/explain_without_index.png)在某些in子查询的情况下，会扫描大量行，从而查询速度变慢。

### 结论

上述测试，还有很多疑问没有解决，涉及到mysql对语句的优化了，查看了优化后的语句，发现也是比较复杂，没有明确的得出结论，哪种in的子查询能否导致这种情况。

[官方文档](https://dev.mysql.com/doc/refman/5.7/en/rewriting-subqueries.html)推荐用join语句替换in子查询：

> A `LEFT [OUTER] JOIN` can be faster than an equivalent subquery because the server might be able to optimize it better

故在生产中，慎重在mysql in中使用子查询，可能会扫描大量行，从而导致速度非常慢，最好通过改写成join语句的方式来改写。

## References

1. 官方文档：[Optimizing Subqueries with the EXISTS Strategy](https://dev.mysql.com/doc/refman/5.7/en/subquery-optimization-with-exists.html)
1. 官方文档：[Rewriting Subqueries as Joins](https://dev.mysql.com/doc/refman/5.7/en/rewriting-subqueries.html)
