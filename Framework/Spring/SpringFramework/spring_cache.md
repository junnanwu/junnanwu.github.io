# Spring Cache

Spring 3.1引入了类似@Transactional的缓存支持，Spring Cache可以在对代码改动很小的情况下实现缓存。

这里只测试基于注解的实现。

## 基本使用

### @EnableCaching 

就像Spring的其他功能一样，Spring Cache也需要显式开启，需要在你的某一个`@Configuration`类上加上`@EnableCaching`

```java
@Configuration
@EnableCaching
public class AppConfig {
}
```

### @Cacheable

重要：

Spring Cache的结构类似`Map<cacheName, Map<key, value>>`

知道了这个，下面的就很好理解了。

@Cacheable注解的结构：

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Inherited
@Documented
public @interface Cacheable {
    @AliasFor("cacheNames")
    String[] value() default {};

    @AliasFor("value")
    String[] cacheNames() default {};

    String key() default "";

    String keyGenerator() default "";

    String cacheManager() default "";

    String cacheResolver() default "";

    String condition() default "";

    String unless() default "";

    boolean sync() default false;
}
```

#### Case1

简单缓存

```java
@Service
public class CacheServer {
    @Cacheable("user")
    public User getUser(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }
}
```

当我们以`name=wujunnan`为参数第一次访问此接口的时候，Spring即会创建：

`Map<user, Map<wujunnan,User(id=1, name=wujunnan, password=123456)>>`

缓存，第二次再以同样的参数访问的时候，Spring就不会再次执行方法，而是直接取出缓存返回。

#### Case2

创建多个缓存

```java
@Service
public class CacheServer {
    @Cacheable({"user", "staff"})
    public User getUser(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }
}
```

当我们以`name=wujunnan`为参数第一次访问此接口的时候，Spring即会创建：

- `Map<user, Map<wujunnan,User(id=1, name=wujunnan, password=123456)>>`
- `Map<staff, Map<wujunnan,User(id=1, name=wujunnan, password=123456)>>`

这两条缓存。

默认Key生成策略是将参数作为Key。

#### Case3

当然，也会有一些没有用的参数，我们可以自己指定key，使用的是[SpringEL](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions)。

```java
@Cacheable(cacheNames = "user", key = "#user.id")
public User handleUser(User user, boolean isPrintLog) {
    if(isPrintLog){
        log.info("获取用户!");
    }
    return handle(user);
}
```

#### Case4

我们也可以添加一些条件

```java
@Cacheable(value = "user", condition = "#user.name.length()>4", unless = "#result.age>30")
public User getUser2(User user) {
    return user;
}
```

上述的含义是只缓存username长度大于4的，并且返回结果的age<=30的，`unless`是对返回结果进行判断。



### @CacheEvict

这个注解与@Cacheable正好相反，是清空相关缓存。

#### Case6

```java
@CacheEvict(cacheNames = "user", allEntries = true)
public void evictCache(){
    log.info("清除所有user缓存");
}
```

上述的含义是清空所有`user`相关的缓存，当然也可以定义条件清楚部分，还可以通过`beforeInvocation`定义是在调用方法前清空还是调用方法后清空。

### @Caching

由于有时候需要一个方法上面加多个缓存，即多个`@Cacheable`，这时候可以使用`@Caching`，它允许组合多个`@Cacheable`、`@CacheEvict`或`@CachePut`。

#### Case7

```Java
@Caching(evict = { @CacheEvict("primary"), @CacheEvict(cacheNames="secondary", key="#p0") })
public Book importBooks(String deposit, Date date)
```

注意`p0`即Spring EL中的元数据，代表方法的第一个参数。

### @CacheConfig

如果一个类中的方法都有相同的配置，那么可以使用`@CacheConfig`提取到类名上。

#### Case8

```java
@CacheConfig(cacheNames = "user")
public class CacheServer {

    @Cacheable()
    public User getUser(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }

    @Cacheable()
    public User getStaff(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }
}
```

如上所述，将cacheNames提取到`@CacheConfig`。

当然，方法级别的会覆盖类级别的。

### 自定义注解

我们也可以自定义注解：

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
@Cacheable(cacheNames="user")
public @interface SlowService {
}
```

### 注意

方法内部调用并不会触发缓存：

```java
@Slf4j
@Service
public class CacheServer {
    @Cacheable(cacheNames = "user")
    public User getUser0(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }

    public User getUser(String name) {
        return getUser0(name);
    }
}
```

上述内部调用不会触发缓存。

## Cache API及默认实现

### Cache

Spring提供核心Cache接口：

```java
package org.springframework.cache;

public interface Cache {

    //获取缓存名字
	String getName();

	//获取底层使用的缓存
	Object getNativeCache();

	//根据key得到一个ValueWrapper，然后调用其get方法获取值  
	ValueWrapper get(Object key);

	//根据key，和value的类型直接获取value
	<T> T get(Object key, Class<T> type);

	//往缓存放数据
	void put(Object key, Object value);

	//从缓存中移除key对应的缓存
	void evict(Object key);

	//清空缓存
	void clear();

	//缓存值的Wrapper
	@FunctionalInterface
	interface ValueWrapper {
		Object get();
	}
}
```

提供了如下默认实现：

- ConcurrentMapCache：使用java.util.concurrent.ConcurrentHashMap实现的Cache
- EhCacheCache：使用Ehcache实现（EhCache 是一个纯Java的进程内缓存框架，是Hibernate中默认的CacheProvider）
- CaffeineCache

### CacheManager

由于一个应用存储在多个Cache，所有还有一个管理Cache的CacheManager。

接口定义如下：

```java
package org.springframework.cache;

public interface CacheManager {

	//根据Cache名字获取Cache
	Cache getCache(String name);

	//获取所有Cache名字
	Collection<String> getCacheNames();

}
```

提供了如下默认实现：

- ConcurrentMapCacheManager
- EhCacheCacheManager
- CaffeineCacheManager
- CompositeCacheManager：用于组合多个CacheManager，从多个CacheManager中轮询得到相应的Cache

另外还有Spring-data-redis和Guava都对这两个接口进行了实现。

## RedisCacheManager

Ehcache、Caffeine、Guava Cache都属于堆内存缓存，只适用于单点应用，分布式应用就需要Redis了。

**导入依赖**

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
    <version>${spring-boot.version}</version>
</dependency>
```

### 实现缓存过期

**原生的实现并不支持设置缓存过期时间**，而Redis的实现是支持设置过期时间的。

先了解一下RedisCacheConfiguration的构造参数：

```java
private RedisCacheConfiguration(Duration ttl, Boolean cacheNullValues, Boolean usePrefix,
                                CacheKeyPrefix keyPrefix, SerializationPair<String> keySerializationPair,
                                SerializationPair<?> valueSerializationPair, ConversionService conversionService) {
    ...
}
```

#### 思路一

提供多个RedisCacheManager，分别设置不同的过期时间，@Cacheable中指定不同的cacheManager即可

配置：

```java
@Configuration
@EnableCaching
public class RedisCacheConfig {
    @Bean
    @Primary
    public RedisCacheManager cacheManager1m(RedisConnectionFactory redisConnectionFactory) {
        RedisCacheWriter redisCacheWriter = RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory);
        return new RedisCacheManager(redisCacheWriter, getConfigInstance(60L));
    }

    @Bean
    public RedisCacheManager cacheManager5m(RedisConnectionFactory redisConnectionFactory) {
        RedisCacheWriter redisCacheWriter = RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory);
        return new RedisCacheManager(redisCacheWriter, getConfigInstance(60 * 5L));
    }

    private RedisCacheConfiguration getConfigInstance(Long ttl) {
        ObjectMapper objectMapper = new ObjectMapper();
        //使Localdate能够正常反序列化
        objectMapper.registerModule(new JavaTimeModule());
        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer(objectMapper);
        return RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(ttl))
                .disableCachingNullValues()
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(serializer));
    }
}
```

使用：

```java
@Service
public class CacheServer {
    @Cacheable(cacheNames = "user", cacheManager = "cacheManager5m")
    public User getUser(String name) {
        return User.builder().id(1).name(name).password("123456").build();
    }

    @Cacheable(cacheNames = "user", cacheManager = "cacheManager1m")
    public User getStaff(String name) {
        return User.builder().id(2).name(name).password("12345").build();
    }
}
```

#### 思路二

我们可以看RedisCache内部关于`put`的实现：

```java
public class RedisCache extends AbstractValueAdaptingCache {
    //...
    @Override
    public void put(Object key, @Nullable Object value) {

        Object cacheValue = preProcessCacheValue(value);

        if (!isAllowNullValues() && cacheValue == null) {

            throw new IllegalArgumentException(String.format(
                "Cache '%s' does not allow 'null' values. Avoid storing null via '@Cacheable(unless=\"#result == null\")' or configure RedisCache to allow 'null' via RedisCacheConfiguration.",
                name));
        }

        cacheWriter.put(name, createAndConvertCacheKey(key), serializeCacheValue(cacheValue), cacheConfig.getTtl());
    }
    //...
}
```

内部`cacheConfig.getTtl()`即为指定的过期时间，我们可以重写此方法，在`@Cacheable`传入key时加上后缀，即`key$ddl`，在`put`方法中解析出过期时间填入即可，注意存取key的时候还要将后缀去掉。

#### 思路三

通过RedisCacheManager()的initialCacheConfigurations参数，来对不同的key提前进行配置初始化。

配置：

```java
@Configuration
@EnableCaching
public class RedisCacheConfig {

    @Bean
    @Primary
    public RedisCacheManager cacheManager(RedisConnectionFactory redisConnectionFactory) {
        return new RedisCacheManager(RedisCacheWriter.nonLockingRedisCacheWriter(redisConnectionFactory), getConfigInstance(60 * 2L), getRedisCacheConfigurationMap());
    }

    private Map<String, RedisCacheConfiguration> getRedisCacheConfigurationMap() {
        Map<String, RedisCacheConfiguration> configs = new HashMap<>();
        configs.put("user", getConfigInstance(60 * 5L));
        configs.put("staff", getConfigInstance(60 * 10L));
        return configs;
    }

    private RedisCacheConfiguration getConfigInstance(Long ttl) {
        ObjectMapper objectMapper = new ObjectMapper();
        //使Localdate能够正常反序列化
        objectMapper.registerModule(new JavaTimeModule());
        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer(objectMapper);
        return RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(Duration.ofSeconds(ttl))
                .disableCachingNullValues()
                .serializeValuesWith(RedisSerializationContext.SerializationPair.fromSerializer(serializer));
    }

}
```

上述配置，即：

- key为user，缓存过期时间为60*5秒
- key为staff，缓存过期时间为60*10秒
- key为其他，缓存过期时间为60*2秒

使用：

```java
@Service
public class CacheServer {

    @Cacheable(cacheNames = "user")
    public User getUser(String name) {
        return User.builder().id(1).name(name).password("111111").build();
    }

    @Cacheable(cacheNames = "staff")
    public User getStaff(String name) {
        return User.builder().id(2).name(name).password("222222").build();
    }

    @Cacheable(cacheNames = "human")
    public User getHuman(String name) {
        return User.builder().id(3).name(name).password("33333").build();
    }
}
```

## 现存问题

1. 上述RedisCacheManager方案依赖Redis服务，Redis服务异常则接口无法正常访问。
2. 是否存在缓存击穿问题，缓存过期瞬间接收到很多请求的情况

## References

1. Spring官方文档：[Cache Abstraction](https://docs.spring.io/spring-framework/docs/current/reference/html/integration.html#cache)
2. Spring官方文档：[Spring Expression Language (SpEL)](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions)
2. 博客：[Spring Cache抽象详解](https://www.iteye.com/blog/jinnianshilongnian-2001040)
4. 博客：[Spring集成Spring-data-redis RedisCacheManager缓存源码分析](https://blog.csdn.net/pengdandezhi/article/details/78921792)
5. 博客：[Spring Cache 实现失效时间设置](https://my.oschina.net/iamgpj/blog/3070914)
6. 博客：[Spring Cache扩展：注解失效时间+主动刷新缓存](https://www.cnblogs.com/ASPNET2008/p/6511500.html)
7. 博客：[Springboot中的缓存Cache和CacheManager原理介绍](https://www.cnblogs.com/top-housekeeper/p/11865399.html)
7. 博客：[springboot(25)自定义缓存读写机制CachingConfigurerSupport](https://blog.csdn.net/sz85850597/article/details/89301331)
7. 博客：[caffeine vs ehcache](https://zhuanlan.zhihu.com/p/39639130)
