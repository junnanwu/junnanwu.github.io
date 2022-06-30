# Mysql EXPLAIN

EXPLAIN语句可以展示一个语句的执行计划。

格式

```
{EXPLAIN | DESCRIBE | DESC} [EXTENDED] explainable_stmt
```

例如：

```
mysql> explain select resources_id from resources_user where user_id = 3\G;
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: resources_user
   partitions: NULL
         type: ALL
possible_keys: NULL
          key: NULL
      key_len: NULL
          ref: NULL
         rows: 6165
     filtered: 10.00
        Extra: Using where
1 row in set, 1 warning (0.00 sec)
```

## 输出格式

- `id`

  select语句对应的id

- `select_type`

  SELECT语句的类型

- `table`

  这一步查询到的表名称，可能是简称

- `type`

  连接类型

- `possible_keys`

  查询中可以用到的索引，如果是`NULL`，则意味着没有相关索引

- `key`
  查询中实际使用的索引

- `key_len`

  实际使用索引的长度

  可以通过这个值算出具体使用了索引的哪些列（联合索引）

  举例来说，film_actor的联合索引 idx_film_actor_id 由 film_id 和 actor_id 两个int列组成，并且每个int是4字节。通过结果中的key_len=4可推断出查询使用了第一个列：film_id列来执行索引查找

- `ref`

  key列记录的索引中，表查找值所用到的列

  > The `ref` column shows which columns or constants are compared to the index named in the `key` column to select rows from the table.

  如果值为func，则使用某些函数的结果来与index进行对比

- `rows`

  执行语句需要检查的行数，`InnoDB`引擎不一定准确

- `filtered`

  表示按照where条件过滤以后，剩下的百分比。没有过滤掉行，则为100%

- `Extra`

## select_type

- `SIMPLE`

  简单查询语句，没有使用UNION或子查询

- `PRIMARY`

  子查询的最外层SELECT语句

- `UNION`

  `UNION`语句中第二个或后面的SELECT语句

- `DEPENDENT UNION`

  `UNION`语句中第二个或后面的SELECT语句，依赖外部查询

- `UNION RESULT`

  `UNION`语句的结果

- `SUBQUERY`

  子查询中的第一个SELECT语句

- `DEPENDENT SUBQUERY`

  子查询中的第一个SELECT语句，依赖外部查询

- `DERIVED`

  派生表的`SELECT`, `FROM`子句的子查询

- ...

## type

下面性能从好到坏：

- `const`

  > The table has at most one matching row, which is read at the start of the query. Because there is only one row, values from the column in this row can be regarded as constants by the rest of the optimizer. `const` tables are very fast because they are read only once.

  当Mysql进行优化的时候，会将此类查询优化为一个常量。

  例如：

  ```
  mysql> explain select * from resources where id = 2300\G;
  *************************** 1. row ***************************
             id: 1
    select_type: SIMPLE
          table: resources
     partitions: NULL
           type: const
  possible_keys: PRIMARY
            key: PRIMARY
        key_len: 4
            ref: const
           rows: 1
       filtered: 100.00
          Extra: NULL
  1 row in set, 1 warning (0.00 sec)
  ```

- `eq_ref`

  类似`ref`，只是使用的索引是唯一索引。

  例如：

  ```
  SELECT * FROM ref_table,other_table WHERE ref_table.key_column=other_table.column;
  
  SELECT * FROM ref_table,other_table WHERE ref_table.key_column_part1=other_table.column AND ref_table.key_column_part2=1;
  ```

- `ref`

  与ref的区别是，不使用唯一索引，而是使用普通索引。

  例如：

  ```
  SELECT * FROM ref_table WHERE key_column=expr;
  
  SELECT * FROM ref_table,other_table WHERE ref_table.key_column=other_table.column;
  
  SELECT * FROM ref_table,other_table WHERE ref_table.key_column_part1=other_table.column AND ref_table.key_column_part2=1;
  ```

- `range`

  使用一个索引来检索给定范围的行。

  例如：

  ```
  SELECT * FROM tbl_name WHERE key_column = 10;
  SELECT * FROM tbl_name WHERE key_column BETWEEN 10 and 20;
  SELECT * FROM tbl_name WHERE key_column IN (10,20,30)
  ```

- `index`

  与`ALL`相似，但只遍历索引库

- `all`

  全表扫描

## Extra

- `Using index`

  这发生在对表的请求列都是同一索引的部分的时候，返回的列数据只使用了索引中的信息，而没有再去访问表中的行记录。是性能高的表现。

- `Using where`

  mysql服务器将在存储引擎检索行后再进行过滤。

- `Using temporary`

  mysql需要创建一张临时表来处理查询。出现这种情况一般是要进行优化的，首先是想到用索引来优化。

## SHOW WARNINGS

`SHOW WARNINGS`查看上一条语句`errors`、`warnings`、`notes`信息

可以通过`SHOW WARNINGS`查看更多`EXPLAIN`信息

## References

1. https://dev.mysql.com/doc/refman/5.7/en/explain-output.html
2. https://www.cnblogs.com/zcyNB/p/15068294.html