# hive



## 

hive建表语句

```
CREATE TABLE `hsz_crm.dim_cust_eu_phone_ctd`(
  `id_` string COMMENT '客户ID', 
  `qyz_user_id_` string COMMENT '企业主ID', 
  `name_` string COMMENT '企业主姓名', 
  `mobile_phone_` string COMMENT '手机号')
COMMENT '客户企业主电话信息表'
PARTITIONED BY ( 
  `pt` string)
ROW FORMAT SERDE 
  'org.apache.hadoop.hive.ql.io.orc.OrcSerde' 
WITH SERDEPROPERTIES ( 
  'field.delim'='\t', 
  'serialization.format'='\t') 
STORED AS INPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat' 
OUTPUTFORMAT 
  'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
LOCATION
  'hdfs://HDFS84138/usr/hive/warehouse/hsz_crm.db/dim_cust_eu_phone_ctd'
TBLPROPERTIES (
  'lifecycle'='-1', 
  'orc.compress'='SNAPPY', 
  'transient_lastDdlTime'='1628508280')
```

```
load data inpath '/usr/hive/warehouse/hsz_huixiaodai.db/ods_grasp_kd_invoice_in_ctd/pt=${bdp.system.bizdate}' into table hsz_huixiaodai.ods_grasp_kd_invoice_in_ctd partition(pt='${bdp.system.bizdate}')
```

```
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
```



hive建表格式

默认为：

null应该存储为`\N`



### 结构设计