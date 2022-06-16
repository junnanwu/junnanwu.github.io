# 关于DataX Hdfs Writer

## 注意hive类型

写Hdfs Writer配置的时候，一定要和hive建表类型对照。

DataX支持Hive数据类型情况：

- 支持： 

  - 数值型：TINYINT、SMALLINT、INT、BIGINT、FLOAT、DOUBLE 
  - 字符串类型：STRING、VARCHAR、CHAR 
  - 布尔类型：BOOLEAN
  - 时间类型：DATE、TIMESTAMP 

- 不支持：

  DECIMAL、BINARY、ARRAYS、MAPS、STRUCTS、UNION类型

（可以自己改造支持DECIMAL类型）

在我们项目实际的应用中，有很多同事在配Hdfs Writer的时候，类型没有和Hive对照，例如Hive某列建表类型是`DECIMAL`，但是配置中对应列的`type`选择了`STRING`，这样底层写入的数据类型就是`STRING`，但是建表类型却是`DECIMAL。

由于Hive强大的兼容能力，Hive依然能读取，但是其他查询引擎就有可能无法去读了，例如Presto，就无法读取，只有底层类型和建表类型对照，Presto才能读取。

所以我们在写Hdfs Writer配置的时候，就按照类型一一对应，以免后续其他问题。

## Hdfs支持Decimal类型

上述提到Hdfs Writer不支持Decimal类型，我们可以稍微改造DataX来使其支持。

[详见此](https://blog.csdn.net/Shadow_Light/article/details/102593160)

## References

1. https://github.com/alibaba/DataX/blob/master/hdfswriter/doc/hdfswriter.md
2. https://blog.csdn.net/Shadow_Light/article/details/102593160