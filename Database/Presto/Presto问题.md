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

## References

1. https://stackoverflow.com/questions/38037713/presto-static-date-and-timestamp-in-where-clause