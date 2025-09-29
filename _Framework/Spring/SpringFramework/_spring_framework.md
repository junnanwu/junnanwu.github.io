# Spring Framework

## IoC

控制反转（Inversion of Control）。

传统的应用程序中，**控制权在程序本身**，程序的控制流程完全由开发者控制。

例如，假设有一个`BookService`，在线获取书籍：

```java
public class BookService {
    private HikariConfig config = new HikariConfig();
    private DataSource dataSource = new HikariDataSource(config);

    public Book getBook(long bookId) {
        try (Connection conn = dataSource.getConnection()) {
            ...
            return book;
        }
    }
}
```

在创建BookService的过程中，创建了config、dataSource，这种模式的缺点就是一个组件要想使用另一个组件，必须知道如何去创建它，例如BookService，要想使用DataSource，必须知道如何去创建它。

在IoC模式下，控制权发生了反转，即**从应用程序转移到了IoC容器**，所有的组件不再由应用程序自己创建和配置，而是由IoC容器负责，这样，应用程序就只需要直接使用已经创建好并配置好的组件，通过某种注入机制，即可获取组件。

例如：

```java
public class BookService {
    private DataSource dataSource;

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
```

好处： 

1. `BookService`不再关心如何创建`DataSource`，因此，不必编写读取数据库配置之类的代码；
2. `DataSource`实例被注入到`BookService`，同样也可以注入到`UserService`，因此，共享一个组件非常简单；
3. 测试`BookService`更容易，因为注入的是`DataSource`，可以使用内存数据库，而不是真实的MySQL配置。

可以通过XML方式来实现：

```xml
<beans>
    <bean id="dataSource" class="HikariDataSource" />
    <bean id="bookService" class="BookService">
        <property name="dataSource" ref="dataSource" />
    </bean>
</beans>
```

上述XML配置文件指示IoC容器创建2个JavaBean组件，并把id为`dataSource`的组件通过属性`dataSource`（即**调用`setDataSource()`方法**）注入到`bookService`中。

上述XML相当于：

```java
//简化HikariDataSource构造
HikariDataSource dataSource = new HikariDataSource();
BookService bookService = new BookService(); 
bookService.setDataSource(dataSource);
```

只不过Spring容器是通过读取XML文件后使用反射完成的。

我们从上面的代码可以看到，依赖注入可以通过`set()`方法实现。但依赖注入也可以通过构造方法实现，如下：

```java
public class BookService {
    private DataSource dataSource;

    public BookService(DataSource dataSource) {
        this.dataSource = dataSource;
    }
}
```

## 装配Bean（注解方式）

上述可见，通过`<property name="..." ref="..." />`注入了另一个Bean；

如果注入的不是Bean，而是`boolean`、`int`、`String`这样的数据类型，则通过`value`注入。

我们可以使用Annotation配置，可以完全不需要XML，让Spring自动扫描Bean并组装它们，对于Spring容器来说，当我们把一个Bean标记为`@Component`后，它就会自动为我们创建一个单例（Singleton），即在容器运行期间，我们调用`getBean(Class)`获取到的Bean总是同一个实例。

```java
@Component
public class HikariDataSource{
	...
}
```

这个`@Component`注解就相当于定义了一个Bean，它有一个可选的名称，默认是`mailService`，即小写开头的类名。

```java
@Component
public class BookService {    
    @Autowired
    private DataSource dataSource;
	...
}
```

使用`@Autowired`就相当于把**指定类型**的Bean注入到指定的字段中。

和XML配置相比，`@Autowired`大幅简化了注入，因为它不但可以写在`set()`方法上，还可以直接写在字段上，甚至可以写在构造方法中：

```java
@Component
public class BookService {    
    private DataSource dataSource;

    public BookService(@Autowired DataSource dataSource) {
        this.dataSource = dataSource;
    }
    ...
}
```

### Scope

还有一种Bean，我们每次调用`getBean(Class)`，容器都返回一个新的实例，这种Bean称为Prototype（原型），它的生命周期显然和Singleton不同。声明一个Prototype的Bean时，需要添加一个额外的`@Scope`注解：

```java
@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE) // @Scope("prototype")
public class MailSession {
    ...
}
```

### 第三方Bean

但是，有的bean是第三方提供的，没办法在类上面加`@Component`等，那么我们就需要在`@Configuration`类中编写一个Java方法创建并返回它，注意给方法标记一个`@Bean`注解：

```java
@Bean(name = "dataSource")
public DataSource getDataSource(){
    Properties props = new Properties();    
    props.setProperty("jdbcUrl","jdbc:mysql://localhost:3306/test");    
    props.setProperty("username","xxx");    
    props.setProperty("password","xxx");    
    HikariConfig config = new HikariConfig(props);    
    HikariDataSource dataSource = new HikariDataSource(config);    
    return dataSource;
}
```

`@Configuration`注解告诉Spring这是一个配置类，会为Spring Appcation Context提供bean，bean的名称为方法名。

这个配置类的方法使用`@Bean`注解进行标记，表明这些方法所返回的对象会以bean的形式添加到Spring Appcation Context中，Spring对标记为`@Bean`的方法只调用一次，因此返回的Bean仍然是单例。

**@Bean修饰方法的注入方式**

方法参数默认注入类型为@Autowired，即先根据类型，若有多个再根据名称进行匹配。



### 一个类型多个Bean

**指定别名**

可以用`@Bean("name")`指定别名，也可以用`@Bean`+`@Qualifier("name")`指定别名。

当一个类型有多个bean的时候，按类型注入的时候也需要通过`@Qualifier("name") `指定bean的名字。

**@Primary**

还有一种方法是把其中某个Bean指定为`@Primary`

这样，在注入时，如果没有指出Bean的名字，Spring会注入标记有`@Primary`的Bean。这种方式也很常用。例如，对于主从两个数据源，通常将主数据源定义为`@Primary`。

### 初始化和销毁

有些时候，一个Bean在注入必要的依赖后，需要进行初始化（监听消息等）。在容器关闭时，有时候还需要清理资源（关闭连接池等）。我们通常会定义一个`init()`方法进行初始化，定义一个`shutdown()`方法进行清理，然后，引入JSR-250定义的Annotation：

```xml
<dependency>
    <groupId>javax.annotation</groupId>
    <artifactId>javax.annotation-api</artifactId>
    <version>1.3.2</version>
</dependency>
```

在Bean的初始化和清理方法上标记`@PostConstruct`和`@PreDestroy`：

```java
@Component
public class MailService {
    @Autowired(required = false)
    ZoneId zoneId = ZoneId.systemDefault();

    @PostConstruct
    public void init() {
        System.out.println("Init mail service with zoneId = " + this.zoneId);
    }

    @PreDestroy
    public void shutdown() {
        System.out.println("Shutdown mail service");
    }
}
```

Spring容器会对上述Bean做如下初始化流程：

- 调用构造方法创建`MailService`实例；
- 根据`@Autowired`进行注入；
- 调用标记有`@PostConstruct`的`init()`方法进行初始化。

而销毁时，容器会首先调用标记有`@PreDestroy`的`shutdown()`方法。

Spring只根据Annotation查找无参数方法，对方法名不作要求。

## 注入配置

Spring容器提供了一个简单的`@PropertySource`来自动读取配置文件。我们只需要在`@Configuration`配置类上再添加一个注解：

```java
@Configuration
@ComponentScan
@PropertySource("app.properties") // 表示读取classpath的app.properties
public class AppConfig {
    //默认为Z
    @Value("${app.zone:Z}")
    String zoneId;

    @Bean
    ZoneId createZoneId() {
        return ZoneId.of(zoneId);
    }
}
```

## 条件装配

Spring为应用程序准备了Profile这一概念，用来表示不同的环境。

```java
@Configuration
@ComponentScan
public class AppConfig {
    @Bean
    @Profile("!test")
    ZoneId createZoneId() {
        return ZoneId.systemDefault();
    }

    @Bean
    @Profile("test")
    ZoneId createZoneIdForTest() {
        return ZoneId.of("America/New_York");
    }
}
```

## References

1. 《Spring实战》
2. https://www.liaoxuefeng.com/wiki/1252599548343744/1266263217140032
2. https://my.oschina.net/HeliosFly/blog/203902