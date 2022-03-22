# 关于Spring Boot的配置文件

Spring有两种不同的配置：

- bean装配

  声明在Spring Context中创建哪些应用组件以及它们之间如何相互注入

- 属性注入

  设置Spring应用上下文中bean的值

## 消费Spring Boot的配置

### @ConfigurationProperties

```yml
conf:
  test:
    string: hello
    string-a: hello-a
    array:
      - best
      - better
      - good
```

可以通过如下代码来消费上述配置：

这样`string`属性就会访问conf.test.string属性。

```java
@Data
@RestController
@RequestMapping("configuration/propertiesTest")
@ConfigurationProperties(prefix = "conf.test")
public class ConfigurationPropertiesTest {

    private String string;
    private String stringA;
    private List<String> array;
    private Map<String,String> map;

    @GetMapping
    public void test(){
        System.out.println(string);
        System.out.println(stringA);
        System.out.println(array);
        System.out.println(map);
    }

}
```

注意：

- yml中的破折号格式能映射为属性中的驼峰模式
- 在系统环境变量中设置`CONF_TEST_STRING=hello`同样可以读取
- 也可以单独配置一个bean来持有属性

## 使用Profile进行配置

- 增加配置：

  `application-{porfile名}.yml` 或 `application-{porfile名}.properties` 

- 激活profile

  - 激活某个profile就是将profile名赋给spring.profiles.active属性

    ```
    spring:
      profiles:
        active:
          - prod
    ```

    当然，这样并没有和配置文件分离，没有意义了

  - 可以使用环境变量

    ```
    $ export SPRING_PROFILES_ACTIVE=prod
    ```

  - 通过命令行参数的形式设置激活的profile

    ```
    $ java -jar test.jar --spring.profiles.active=prod
    ```

## 使用profile条件化的创建bean

```
@Bean
@Profile("dev")
...
```

或

```
@Bean
@Profile("!prod")
...
```

同时，我们可以在带有@Configuration注解的类上使用@Profile，来选择性的加载配置。





https://juejin.cn/post/6844903574040739847

https://www.cnblogs.com/moonandstar08/p/7368292.html