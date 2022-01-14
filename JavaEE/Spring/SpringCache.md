# Spring Cache

Spring 3.1引入了对缓存的支持，Spring Cache可以在对代码改动很小的情况下实现缓存。

这里只测试基于注解的实现。

## @EnableCaching 

就像Spring的其他功能一样，Spring Cache也需要显式开启，需要在你的某一个`@Configuration`类上加上`@EnableCaching`

```java
@Configuration
@EnableCaching
public class AppConfig {
}
```

## @Cacheable

**Spring Cache的结构类似`Map<cacheName, Map<key, value>>`**，知道了这个，下面的就很好理解了。

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

### Case1

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

### Case2

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

### Case3

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

### Case4

我们也可以添加一些条件

```java
@Cacheable(value = "user", condition = "#user.name.length()>4", unless = "#result.age>30")
public User getUser2(User user) {
    return user;
}
```

上述的含义是只缓存username长度大于4的，并且返回结果的age<=30的，`unless`是对返回结果进行判断。

## @CacheEvict

这个注解与@Cacheable正好相关，是清空相关缓存。

### Case6

```java
@CacheEvict(cacheNames = "user", allEntries = true)
public void evictCache(){
    log.info("清除所有user缓存");
}
```

上述的含义是清空所有`user`相关的缓存，当然也可以定义条件清楚部分，还可以通过`beforeInvocation`定义是在调用方法前清空还是调用方法后清空。

## @Caching

由于有时候需要一个方法上面加多个缓存，即多个`@Cacheable`，这时候可以使用`@Caching`，它允许组合多个`@Cacheable`、`@CacheEvict`或`@CachePut`。

### Case7

```Java
@Caching(evict = { @CacheEvict("primary"), @CacheEvict(cacheNames="secondary", key="#p0") })
public Book importBooks(String deposit, Date date)
```

注意`p0`即Spring EL中的元数据，代表方法的第一个参数。

## @CacheConfig

如果一个类中的方法都有相同的配置，那么可以使用`@CacheConfig`提取到类名上。

### Case8

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

## 自定义注解

我们也可以自定义注解

```java
@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.METHOD})
@Cacheable(cacheNames="user")
public @interface SlowService {
}
```

## 注意

方法内部调用并不会出发缓存：

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

## References

1. https://docs.spring.io/spring-framework/docs/current/reference/html/integration.html#cache
2. https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#expressions