

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





