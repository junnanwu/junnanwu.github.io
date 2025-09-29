# Presto语法

## 日期

### 获取日期

- `current_date`

  当天日期

  ```sql
  SELECT current_date;
  -> 2022-07-08
  ```

### 日期转换

- `date_format(timestamp, format) → varchar`

  将日期转换成指定格式的字符串

  ```sql
  SELECT date_format(current_date, '%Y%m%d');
  ```

- `date_parse(string, format) → timestamp`

  将字符串转换成日期类型

  ```sql
  SELECT date_parse('20220708', '%Y%m%d');
  ```

### 日期运算

- 获取昨日日期

  ```sql
  current_date - interval '2' day;
  ```

## References

1. presto官方文档：[Date and Time Functions and Operators](https://prestodb.io/docs/current/functions/datetime.html)