# ClickHouse物化视图

## 创建物化视图

ClickHouse物化视图意味着当你向指定的表插入数据的时候，SELECT语句会在插入数据中执行后，插入到目标物化视图中。

语句：

```
CREATE MATERIALIZED VIEW [IF NOT EXISTS] [db.]table_name [ON CLUSTER] [TO[db.]name] [ENGINE = engine] [POPULATE] AS SELECT ...
```

- 如果使用了`POPULATE`，那么在创建物化视图的时候，历史的数据也会被插入到物化视图中

  （不建议使用此关键词，因为如果使用了，那么在创建表的过程中插入的数据则不会被插入物化视图）

实际语句：

```sql
CREATE MATERIALIZED VIEW user_log.ods_log_event_deduplicat_ct_view
ENGINE = MergeTree
ORDER BY (apply_code, phone_number, distinct_id, event_time)
AS SELECT
JSONExtractString(properties, 'apply_code') as apply_code,
JSONExtractString(properties, 'phone_number') as phone_number,
JSONExtractString(properties, 'hxd_khxx_id') as khxx_id,
JSONExtractString(properties, '$ip') as ip,
distinct_id,
JSONExtractRaw(properties, 'current_progress') as apply_sub_stage,
user_id,
JSONExtractString(properties, '$country') as country,
JSONExtractString(properties, '$province') as province,
JSONExtractString(properties, '$city') as city,
-- 浏览器
JSONExtractString(properties, '$browser') as browser,
-- 浏览器版本
JSONExtractString(properties, '$browser_version') as browser_version,
-- 前往地址域名
JSONExtractString(properties, '$referrer_host') as referrer_host
FROM user_log.ods_log_event_deduplicat_ct
WHERE event_project = 'hdz' AND environment = 'prod'
AND toDateTime64(event_time, 3) > toDateTime64('2022-07-29 19:15:00.000', 3);
```

注意：

- 我们写的SELTCT语句只对插入部分的数据生效
- 原表数据的改变不会影响物化视图
- POPULATE关键字，不建议使用，会把原始表中的已存在数据全部物化一遍，老数据的同步，建议直接insert到物化视图中

## 删除物化视图

```
DROP VIEW [IF EXISTS] [db.]name [ON CLUSTER cluster]
```

## References

1. https://clickhouse.com/docs/en/sql-reference/statements/create/view#materialized