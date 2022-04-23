# 代码优化

## 关于枚举+MAP简化if...else链

### 背景

业务上有三个标签体系：

- 企业
- 企业主
- 员工

### 使用场景

- 明确知道要操作哪个标签体系，枚举的典型用法

  例如：

  ```java
  @AllArgsConstructor
  public enum TagSystemEnum {
  
      /**
       * 用户标签体系
       */
      EU_TAG_SYSTEM(1, "用户", "eu_ident_name", "eu_tag_name", "eu", "eu__", "eu_id", "eu_active_info"),
  
      /**
       * 企业标签体系
       */
      CUST_TAG_SYSTEM(2, "企业", "cust_ident_name", "cust_tag_name", "cust", "cust__", "cust_id", "cust_tag"),
  
      /**
       * 业务标签体系
       */
      STAFF_TAG_SYSTEM(3, "业务", "staff_ident_name", "staff_tag_name", "staff", "staff__", "staff_id", "staff_tag");
  
      @Getter
      private Integer id;
  
      /**
       * 对应的中文标识
       */
      @Getter
      private String chinesePrefix;
  
      /**
       * redis标识字段名对应关系
       */
      @Getter
      private String identCacheKey;
  
      /**
       * redis标签字段名对应关系
       */
      @Getter
      private String tagNameCacheKey;
  
      /**
       * 标签系统的标识
       */
      @Getter
      private String tagSysIdent;
  
      /**
       * 各标签体系对应前缀
       */
      @Getter
      private String tagSysPrefix;
  
      /**
       * 各标签体系对应主键
       */
      @Getter
      private String tagSysPrimaryKey;
  
      /**
       * 各标签体系对应的ES的索引库名
       */
      @Getter
      private String tagESIndexName;
  }
  
  ```

- 每个体系都要处理一系列固定方法，里面用到了这个体系的多个参数，多个体系就要重复执行这个方法多次，进行抽取的话涉及到的属性太多

  

- 根据标签体系的id取对应的属性

  这个需求非常常见

  

- 根据标签的标识 (ident) 取标签体系的id

  - 由于不存在ident => Enum那么我们首先可以采用if...else

    ```java
    if (TagSystemEnum.CUST_TAG_SYSTEM.getTagSysIdent().equals(tagPrefix)) {
      tagSysId = TagSystemEnum.CUST_TAG_SYSTEM.getId();
    } else if (TagSystemEnum.EU_TAG_SYSTEM.getTagSysIdent().equals(tagPrefix)) {
      tagSysId = TagSystemEnum.EU_TAG_SYSTEM.getId();
    } else {
      tagSysId = TagSystemEnum.STAFF_TAG_SYSTEM.getId();
    }
    ```

  - 可以使用Map简化上述if...else，key为ident，value为id，接下来通过map.get(key)即可获取id

  - 可以在Enum中定义如下Map，key为ident，value为Enum

    ```java
    public static final Map<String, TagSystemEnum> TAG_SYSTEM_IDENT_MAP = Stream.of(
      TagSystemEnum.values())
      .collect(Collectors.toMap(TagSystemEnum::getTagSysIdent, item -> item));
    ```

    这样以后我们就可以使用该Map通过ident取到对应体系的任何属性了，上面的if...else即可转换为:

    ```java
    Integer tagSysId = TagSystemEnum.TAG_SYSTEM_IDENT_MAP.get(tagPrefix).getId();
    ```

## 字符串如果为null就转换为空字符串

```
Optional.ofNullable(tagFilterItemDO.getAppendGroupOperator()).orElse("")
```

```
/**
 * 标签体系与MaxCompute数仓表名映射
 */
private static final Map<Integer, Tuple> TAG_SYSTEM_TO_WAREHOUSE_TABLE_MAX_COMPUTE = ImmutableMap.<Integer, Tuple>builder()
        .put(TagSystemEnum.EU_TAG_SYSTEM.getId(), Pair.with("", "eu_id"))
        .put(TagSystemEnum.CUST_TAG_SYSTEM.getId(), Pair.with("", "cust_id"))
        .put(TagSystemEnum.STAFF_TAG_SYSTEM.getId(), Pair.with("", "staff_id"))
        .build();
```