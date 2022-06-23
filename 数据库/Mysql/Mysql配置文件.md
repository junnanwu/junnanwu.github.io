# Mysql配置

`[group]`

group对应了不同的程序或者组。

- `[client]`
- `[mysql]`
- `[mysqld]`
- `[mysqldump]`
- `[mysqladmin] `

## sql_mode

报如下异常：

```
 
```

即，没在group by中出现的字段或者聚合字段不能出现在select语句中。

>In MySQL 5.7, the `ONLY_FULL_GROUP_BY` SQL mode is enabled by default because `GROUP BY` processing has become more sophisticated to include detection of functional dependencies. 

执行下面语句：

```
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
```

或者通过`ANY_VALUE(arg)`函数的方式绕开此模式。

## max_allowed_packet

允许传输的最大sql包，默认为4MB

查看：

```
SHOW GLOBAL VARIABLES LIKE 'max_allowed_packet';
```

设置：

```
#单位为字节，下面104857600即为100M
SET GLOBAL max_allowed_packet = 100 * 1024 * 1024;
```

## References

1. https://dev.mysql.com/doc/refman/5.7/en/option-files.html
2. https://www.bilibili.com/read/cv15775443
