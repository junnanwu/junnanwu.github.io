# 大数据基本概念

## ETL

ETL，即Extract (抽取)、Transform (清洗转换)、Load (加载) 。

也就是将不同业务不同的类型的数据源进行抽取、整合并加载到存储中。

**ETL模式**

- 触发器模式
- 增量字段
- 全表同步
- 日志对比

## ODS

ODS（Operational Data Store）即数据运营层，是接近数据源的一层，源数据经过ETL流程之后，转入本层，永久存放。

ODS数据基本特征：

- 面向主题的
- 集成的
- 可更新的
- 当前或接近当前的

数据来源：

- 业务库
- 埋点日志
- 消息队列

一般ODS格式是沿用源系统的规则。

## DW

DW（Data Warehouse）即数据仓库存储，反映了历史变数据，用于支撑管理决策。

DW数据特征：

- 面向主题的
- 集成
- 不可修改
- 与时间相关的

细分为：

- DWD (Data Warehouse Detail)

  数据明细层

- DWM (Data Warehouse Middle)

  数据中间层

- DWS (Data Warehouse Service)

  数据服务层

**DW和ODS的区别**

如果把数据仓库系统比作人的大脑，DW是深度记忆区，ODS是浅度记忆区。当人接收外界的信息后，记忆在浅度区，经过温习或者某些深刻的印象，这些信息又都被记录到深度区中。

## DIM

DIM (Dimension)，即维度层，例如行业分类，地理省市等。

## DM

DM (Data Market)，即数据集市，没个数据集市面向不同的业务线或业务部门，为不同部门提供定制化需求。

整体流程如下：

![big_data_concept](bigdata_introduce_assets/big_data_concept.jpg)

## References

1. 文章：[数据架构中的ODS层](http://www.360doc.com/content/20/1126/15/31115656_948043216.shtml)