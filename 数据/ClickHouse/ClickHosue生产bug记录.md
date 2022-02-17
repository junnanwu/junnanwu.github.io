

# ClickHosue生产bug记录

在实际生产中，发现ClickHouse相比一些老牌数据库，还是存在较多明显的bug或不完善的点，导致生产中出错，本文做一下记录。

## Decimal and Float32/Float64类型之间不能进行运算

版本：`21.6.6.51`

发现运行下面语句会报错（简化语句），a列的类型为`Decimal(38,4)`

```sql
-- 报错 No operation greater between Decimal(38, 4) and Float64
SELECT a FROM tableA WHERE a > 1.1 limit 10;
```

经测试：

- Decimal类型可以和整形做运算

  ```sql
  -- 正常运行
  SELECT a FROM tableA WHERE a > 1 limit 10;
  ```

- 使用`toDecimal`方法对比较值进行转换之后可以正常运行

  ```sql
  -- 正常运行
  SELECT a FROM tableA WHERE a > toDecimal32(1.1, 1) limit 10;
  ```

- 新建列b，类型为float64，是可以支持如下运算的

  ```sql
  SELECT b FROM tableA WHERE b > 1.1;
  ```

- `toDecimal`方法

  ```sql
  -- 测试toDecimal32 
  
  -- 结果 2.4
  SELECT toDecimal32(2.434,1);
  
  -- 结果为2.9
  SELECT toDecimal32(2.984,1);
  ```

- Mysql和阿里云数仓都支持上述所有运算

经查阅官方文档：

>Operations between Decimal and Float32/Float64 are not defined. If you need them, you can explicitly cast one of argument using toDecimal32, toDecimal64, toDecimal128 or toFloat32, toFloat64 builtins. Keep in mind that the result will lose precision and type conversion is a computationally expensive operation.

经过上述测试，可以有两种改进方式：

- 重新建列为float64类型
- 使用decimal，查询的时候加上`toDecimal32`函数对比较数值进行转换

我们最终采用了第二种方法。

[ClickHouse Decimal Type](https://clickhouse.tech/docs/en/sql-reference/data-types/decimal/)

## 21.x版本ClickHouse复杂语句无法解析数字开头的字段

生产语句报错：

```sql
SELECT
	t1.2_q_cash_rate cust__2_q_cash_rate,
	t1.cust_id cust__cust_id,
	t2.eu_id eu__eu_id
FROM
	(
	select
		cust_id,
		eu_id
	from
		dim_ftsp_cust_base_info) t_2
INNER JOIN dm_ftsp_cust_tag_ctd t1 on
	(t1.cust_id = t_2.cust_id)
INNER JOIN dm_zz_eu_active_info_ct t2 on
	(t2.eu_id = t_2.eu_id)
WHERE
	(1 = 1)
	and (t1.2_q_cash_rate IS NOT NULL)
limit 20;
```

报错信息：

```
SQL 错误 [47]: ClickHouse exception, code: 47, host: 82.157.52.137, port: 8123; Code: 47, e.displayText() = DB::Exception: Missing columns: '2_q_cash_rate' while processing query: 'SELECT eu_id AS `--t_2.eu_id`, cust_id AS `--t_2.cust_id`, `2_q_cash_rate`, t1.cust_id AS `--t1.cust_id` FROM (SELECT cust_id, eu_id FROM dim_ftsp_cust_base_info) AS t_2 ALL INNER JOIN dm_ftsp_cust_tag_ctd AS t1 ON `--t1.cust_id` = `--t_2.cust_id`', required columns: 'eu_id' 't1.cust_id' 'cust_id' '2_q_cash_rate' 'eu_id' 't1.cust_id' 'cust_id' '2_q_cash_rate', joined columns: 't1.cust_id' 'name' 'industry' 'established_duration_time' 'province' 'city' 'nsrlx' 'type_acting_accounting' 'grade_cust' 'service_status' 'illegal_time' 'contact_person_num' 'already_payed_ht_num' 'already_payed_ht_money' 'unpayed_ht_num' ...
```

大意就是`2_q_cash_rate`字段找不到，但是经查找`t1`表即`dm_ftsp_cust_tag_ctd`是存在这个字段的，经分析：

1. 带有此字段的简单语句没有问题，如下语句可以正常执行

   ```sql
   SELECT
   	t1.cust_id cust__cust_id,
   	t1.2_q_cash_rate cust__2_q_cash_rate
   FROM
   	dm_ftsp_cust_tag_ctd t1
   WHERE
   	(1 = 1)
   	and (t1.2_q_cash_rate is not null)
   limit 20;
   ```

2. 确定是此字段有问题，去掉此字段，执行没有问题

   ```sql
   SELECT
   	t1.cust_id cust__cust_id,
   	t2.eu_id eu__eu_id
   FROM
   	(
   	select
   		cust_id,
   		eu_id
   	from
   		dim_ftsp_cust_base_info) t_2
   INNER JOIN dm_ftsp_cust_tag_ctd t1 on
   	(t1.cust_id = t_2.cust_id)
   INNER JOIN dm_zz_eu_active_info_ct t2 on
   	(t2.eu_id = t_2.eu_id)
   WHERE
   	(1 = 1)
   limit 20;
   ```

3. 跟别名没有关系，去掉别名依然报同样错误

   ```sql
   SELECT
   	t1.2_q_cash_rate,
   	t1.cust_id,
   	t2.eu_id
   FROM
   	(
   	select
   		cust_id,
   		eu_id
   	from
   		dim_ftsp_cust_base_info) t_2
   INNER JOIN dm_ftsp_cust_tag_ctd t1 on
   	(t1.cust_id = t_2.cust_id)
   INNER JOIN dm_zz_eu_active_info_ct t2 on
   	(t2.eu_id = t_2.eu_id)
   WHERE
   	(1 = 1)
   	and (t1.2_q_cash_rate IS NOT NULL)
   limit 20;
   ```

4. 换做其他已存在数字开头的字段

   换成`1_q_yycb`、`3q_hbzj`、`3_q_zcfz_rate`，都报同样的错误，Missing columns...

   ```
   SELECT
   	t1.1_q_yycb,
   	t1.cust_id,
   	t2.eu_id eu__eu_id
   FROM
   	(
   	select
   		cust_id,
   		eu_id
   	from
   		dim_ftsp_cust_base_info) t_2
   INNER JOIN dm_ftsp_cust_tag_ctd t1 on
   	(t1.cust_id = t_2.cust_id)
   INNER JOIN dm_zz_eu_active_info_ct t2 on
   	(t2.eu_id = t_2.eu_id)
   WHERE
   	(1 = 1)
   	and (t1.1_q_yycb IS NOT NULL)
   limit 20;
   ```

   基本确定是复杂语句且数字开头的字段解析出现错误...

   鉴于最近迁移了腾讯云，而且之前没有出现过这个问题，那么看看是不是版本不同。

5. 查看当前版本

   ```sql
   SELECT version();
   21.8.5.7
   ```

6. 之前的版本是20.xx版本是没有问题的，所以应该是20.3.x版本的bug

   在ClickHouse GitHub中也有人提出了同样的issue，我也添加了我本次问题的描述。

   - https://github.com/ClickHouse/ClickHouse/issues/30721
   - https://github.com/ClickHouse/ClickHouse/issues/28019

7. 解决方案就是回退到之前的20.3.x版本，经测试可行

