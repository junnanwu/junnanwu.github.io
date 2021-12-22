# 阿里数仓历史数据迁移Hive

## 背景

由于公司的数据服务从阿里云迁移到了腾讯云，迁移工作基本完成，还有剩下的xx大小的历史数据需要迁移。

## 概念

### Hive

hive常见的数据格式及存储

- `Text File`

  hive基本的存储格式，也是默认的存储格式

- `ORC Files`

  ORC（Optimized Row Columnar）不是一个单纯的列式存储格式，首先根据行组分割整个表，在每一个行组内进行按列存储。

### 腾讯云

[详见此](https://cloud.tencent.com/document/product/436/6222)

- COS

  对象存储（Cloud Object Storage，COS）是腾讯云提供的一种存储海量文件的分布式存储服务，用户可通过网络随时存储和查看数据。

- bucket：

  存储桶，是对象的载体，可理解为存放对象的“容器”。一个存储桶可容纳无数个对象。

- Object

  对象，是对象存储的基本单元，可理解为任何格式类型的数据，例如图片、文档和音视频文件等。

- Hadoop-COS 

  基于腾讯云对象存储 COS 实现了标准的 Hadoop 文件系统，可以为 Hadoop、Spark 以及 Tez 等大数据计算框架集成 COS 提供支持，使其能够跟访问 HDFS 文件系统时相同，读写存储在 COS 上的数据。

## Reference

1. https://cloud.tencent.com/document/product/436/6222
2. https://cwiki.apache.org/confluence/display/Hive/LanguageManual+ORC