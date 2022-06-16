# Interview

## JavaSE

1. 【HashMap】为什么新建HashMap时最好赋予初始容量？
1. 【线程池】假如有一类cpu密集性的任务，没有IO操作，日常的时候只有1个任务，流量高峰会有50个任务，4核8G的机器上，使用的线程池，如何设置？

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
