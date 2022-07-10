# Presto问题

## varchar隐式转换date错误

在where子句中，presto无法将varchar类型隐式转换成date类型，例如：

```sql
SELECT * 
    FROM db.table_test 
    WHERE date_colum = '2022-06-27';
```

将报如下错误：

```
[58] Query failed (#20220628_095152_02577_ggqvf): line 3:30: '=' cannot be applied to date, varchar(10) io.prestosql.spi.PrestoException: line 3:30: '=' cannot be applied to date, varchar(10)
```

需要将上述语句改造为如下语句：

```sql
SELECT *
      FROM hsz_sap.dwd_big_cust_clue_reach
      WHERE latest_hangup_time = date_parse('2022-06-27', '%Y-%m-%d');
```

或

```sql
SELECT *
      FROM hsz_sap.dwd_big_cust_clue_reach
      WHERE latest_hangup_time = date '2022-06-27';
```

## 关于大数据量取max(pt)速度过慢问题

当数据量过大时，`max(pt)`会使得查询速度非常慢。

当时如果我们选择如下语句，即昨天的日期：

```sql
SELECT date_format( current_date - interval '1' day ,'%Y%m%d');
```

又不符合最大分区的语句，因为有可能昨天分区由于某种原因并没有跑出来，那么我们可以增加一个where条件来缩小查找范围，从而提升查询速度：

```sql
SELECT max(pt) FROM hsz_crm.xxx where pt > date_format( current_date - interval '3' day ,'%Y%m%d');
```

## References

1. https://stackoverflow.com/questions/38037713/presto-static-date-and-timestamp-in-where-clause
1. https://prestodb.io/docs/current/functions/datetime.html