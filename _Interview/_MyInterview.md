# Interview

## JavaSE

1. 为什么新建HashMap时最好赋予初始容量？

## MyBatis

1. MyBatis中`#{}`可以像如下所示使用吗？

   ```java
   @Mapper
   public interface CommonMapper {
   	@Select("SELECT * FROM ${table} LIMIT 5")
       List<Map<String, Object>> getExampleData(@Param("table") String table);
   }
   ```

## Spring

1. spring-boot-starter-parent依赖的作用是什么
