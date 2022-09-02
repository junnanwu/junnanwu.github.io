# Spring Boot Test

## 单元测试

一个单元测试不应该包含外部依赖的逻辑，反之就是集成测试了，可以借助Mock技术摆脱外部依赖。

### 单元测试的原则和建议

- 单元测试每个方法必须可以**独立运行**，单元测试用例之间决不能相互调用，**不能依赖执行的先后顺序**
- 单元测试是可重复执行的，不能受外界环境的影响 
- 单元测试至多是类级别，最多是方法级
- 单元测试最好包括正常值，边界值，异常值
- 为了更方便的进行单元测试，业务代码应避免出现以下情况
  - 构造方法中做的事情过多
  - 存在过多的全局变量和静态方法
  - 存在过多的外部依赖
  - 存在过多的条件语句

- 测试类一般使用 Test 作为类名的后缀

### Junit4与Junit5

JUnit 5 = JUnit Platform + JUnit Jupiter + JUnit Vintage

| JUnit4       | JUnit5      | 说明                                                         |
| ------------ | ----------- | ------------------------------------------------------------ |
| @Test        | @Test       | 该方法表示一个测试方法                                       |
| @BeforeClass | @BeforeAll  | 针对**所有测试**，只执行一次                                 |
| @AfterClass  | @AfterAll   | 针对所有测试，只执行一次                                     |
| @Before      | @BeforeEach | 执行当前测试类的**每个**测试方法前执行                       |
| @After       | @AfterEach  | 执行当前测试类的**每个**测试方法后执行                       |
| @Ignore      | @Disabled   | 该方法表示不执行(关闭)该测试方法                             |
| @RunWith     | @ExtendWith | @Runwith就是放在测试类名之前，用来确定这个类怎么运行的       |
| @Rule        | @ExtendWith | Rule是一组实现了TestRule接口的共享类，提供了验证、监视TestCase和外部资源管理等能力 |
| @ClassRule   | @ExtendWith | @ClassRule用于测试类中的静态变量，必须是TestRule接口的实例，且访问修饰符必须为public。 |

- `@Test`  测试方法，在这里可以测试期望异常和超时时间

  - 参数1：`@Test(excepted = xx.class)` 当测试的方法抛出此异常的时候才认为此测试沟通过

  - 参数2：`@Test(timeout = 毫秒数)` 测试方法执行的时间是否符合预期

    ```java
    //Junit5 @Test导包
    import org.junit.jupiter.api.Test;
    //Junit4 @Test导包
    import org.junit.Test;
    ```

### Assert

#### 传统Assert

断言

可以使用JUnit的Assert

`import static org.junit.Assert.*`

- `assertTrue` `assertFalse`
- `assertNull` `assertNotNull`
- `assertSame` `assertNotSame`

#### Hamcrest

由于传统JUnit API的可读性不好，而且不方便比较对象，集合，Map等数据结构。

JUnit4引入了Hamcrest框架，它提供了一套匹配符Matcher，这些通配符更接近自然语言，可读性更高，Hamcrest是一款用于校验的Java的单元测试框架，可以组合创建灵活的表达的匹配器进行断言。

配合`assertThat`使用

核心API

- `is` `not`

- `containsString` `startsWith` `endsWith`

- `allOf` `anyOf`

  且/或

Number匹配器

- `greaterThan` `greaterThanOrEqualTo` `lessThan` `lessThanOrEqualTo`

Text匹配器

- `isEmptyString` `isEmptyOrNullString` `equalToIgnoringWhiteSpace` `equalToIgnoringCase`

集合匹配器

- `hasItem` `not(hasItem())` `hasItems("a","b")` `empty()` `emptyArray()` `equalTo(Collections.EMPTY_MAP)`

- ` hasSize` `everyItem(equalTo("ab"))`

  检查数目

Bean匹配器

- `hasProperty("state")`
- `hasProperty("state", equalTo("CA"))`

[Testing with Hamcrest](https://www.baeldung.com/java-junit-hamcrest-guide)

#### AssertJ

推荐使用更强大的AssertJ，一个开源的、社区驱动的测试库，支持流式断言，SpringbootTest已经包含了此库，不需要进行额外导入。

- 字符串
- 数字
- 日期
- 列表
- 对象

[AssertJ - fluent assertions java library](https://assertj.github.io/doc/)

[流式断言器AssertJ介绍](https://www.cnblogs.com/zyfd/p/9567380.html)

## Spring Boot Test

### 依赖

gradle: `testCompile 'org.springframework.boot:spring-boot-starter-test:2.1.6.RELEASE'`

`spring-boot-starter-test`，其中包含了如下库：

- **JUnit 4**

  **注意：**在Spring2.2.0.RELEASE版本开始，这里换成了JUnit5

- Spring Test & Spring Boot Test

- **AssertJ:**  提供了流式的断言方式

- Hamcrest:  提供了丰富的matcher

- Mockito: mock框架，可以按类型创建mock对象，可以根据方法参数指定特定的响应，也支持对于mock调用过程的断言

- JSONassert/JsonPath: 为JSON提供支持


### 注解

Spring Boot使用了大量的注解，这大大简化了单元测试，同时，对这些注解的理解也就非常重要了

网上有大量的Spring Boot单元测试用例，各种各样的的注解组合，要想运用自如，就要分类去看，所以按功能分类，Spring Boot注解分为以下几类：

| 类别         | 示例                   | 格式              | 说明                                                    |
| :----------- | :--------------------- | :---------------- | :------------------------------------------------------ |
| 启动测试类型 | `@SpringBootTest`      | `@\*Test`         | 以Test结尾的注解，具有加载applicationContext的能力      |
| 自动配置类型 | `@AutoConfigureJdbc`等 | `@AutoConfigure*` | 以AutoConfigure开头的注解，具有加载测试支持功能的能力。 |
| 配置类型     | `@TestConfiguration`等 |                   | 提供一些测试相关的配置入口                              |
| mock类型     | `@MockBean`等          |                   | 提供mock支持                                            |

#### 启动测试类型

对Spring Boot项目做单元测试，我们通常需要拿到Spring实例化的一些对象，例如对Service层进行测试的时候，需要用到`xxxService`对象，然后调用其方法进行校验。

通常，我们可以使用使用`@ContextConfiguration(classes=...)`将指定@Configuration注解类里面的beans加载到我们的测试类中。

当然，在Spring Boot Test中，`@...Test`注解会帮我们做这件事，如：

- `@SpringBootTest`会帮我们获取整个ApplicationContext
- 假如我们只想测试Controller层，`@WebMvcTest`会帮我们获取@Controller等而不获取 `@Component`, `@Service` 或`@Repository` beans

`@SpringBootTest`可以指定`webEnvironment`参数来指定web环境，MOCK为默认值，此类型提供一个mock环境，servlet容器并没有真正启动

`@WebMvcTest`

这个注解帮我们引入了Controller bean，如果你需要其他组件，例如Jasckson，你可以在test类上使用@Import，测试Controller层通常我们还需要Service对象，我们可以使用@MockBean会对Service层进行mock，下面将会介绍。

所有的`@...Test`注解都被`@BootstrapWith`注解，它们可以启动ApplicationContext，是测试的入口，所有的测试类必须声明一个`@...Test`注解。

**注意：**

- **Junit需要加`@RunWith(SpringRunner.class)`**

  > If you are using JUnit 4, don’t forget to also add `@RunWith(SpringRunner.class)` to your test, otherwise the annotations will be ignored. If you are using JUnit 5, there’s no need to add the equivalent `@ExtendWith(SpringExtension.class)` as `@SpringBootTest` and the other `@…Test` annotations are already annotated with it.
  >
  > ——docs.spring.io/spring-boot/docs/2.1.6.RELEASE

  注意，这个地方，Spring官方给的新的单元测试案例中就没有使用`@RunWith()`注解，就是因为在Junit5中, `@RunWith()`被换成了`@ExtendWith`，`@SpringBootTest`和其他`@..Test`注解已经包含了它。

- **多个`@...Test`不能同时使用**

  可以配合`@AutoConfigure...`导入其他切片，也可以使用`@SpringBootTest`和`@AutoConfigure...`注解来自动配置测试beans。

- 在单元测试的中，Spring测试框架会缓存ApplicationContext，所以共享相同配置的单元测试指挥只加载一次ApplicationContext。

#### 自动配置类型

这些注解可以搭配`@...Test`使用，用于开启在`@...Test`中未自动配置的功能。例如：

- `@SpringBootTest`和`@AutoConfigureMockMvc`组合后，就可以注入`org.springframework.test.web.servlet.MockMvc`。

但是`@WebMvcTest`就自动引入了该注解，自动配置类型还会被隐式添加：

- `@WebMvcTest`注解时，隐式添加了`@AutoConfigureCache`、`@AutoConfigureWebMvc`、`@AutoConfigureMockMvc`。

#### 配置类型

例如`@TestConfiguration`，用于补充额外的Bean或覆盖已存在的Bean，在不修改正式代码的前提下，使配置更加灵活，用的不多。

#### mock类型

`@MockBean`

该注解可以给ApplicationContext中的bean定义一个Mockito mock，使用了Spring Boot Test的启动测试类型注解例如@SpringBootTest，那么@MockBean功能都会自动启用。

#### 其他注解

`@Transactional`

加了此注解，每个方法执行完之后都会进行事务的回滚

### MockMvc

当我们想对Controller中的逻辑进行校验的时候，我们不想启动servlet，启动servlet会使测试变的很麻烦，比如 测试速度慢，依赖网络环境等，所以我们可以使用MockMvc。

 测试逻辑如下：

- 注入或者构造MockMvc实例
- mockMvc调用perform，执行一个RequestBuilder请求，调用controller的业务处理逻辑
-  perform返回ResultActions，返回操作结果，通过ResultActions，提供了统一的验证方式
-  使用StatusResultMatchers对请求结果进行验证
-  使用ContentResultMatchers对请求返回的内容进行验证

Demo

```java
String example= "{id:1, name:wu"}";  
mockMvc.perform(post("/user")  // 路径
                .contentType(MediaType.APPLICATION_JSON)   //表示具体请求中的媒体类型信息
                .content(example)
                .accept(MediaType.APPLICATION_JSON)) //accept指定客户端能够接收的内容类型
				.andExpect(content().contentType("application/json;charset=UTF-8"))
			    .andExpect(jsonPath("$.id").value(1)) //验证id是否为1    
```

```java
 String errorExample = "{id:1, name:wu}";  
 MvcResult result = mockMvc.perform(post("/user")  
         .contentType(MediaType.APPLICATION_JSON).content(errorExample)  
         .accept(MediaType.APPLICATION_JSON)) //执行请求  
         .andExpect(status().isBadRequest()) //400错误请求，  status().isOk() 正确  
         .andReturn();  //返回MvcResult
```

## 关于单元测试所在包







## 单元测试方案

### 常用注解组合

对controller进行测试

```java
@SpringBootTest
@AutoConfigureMockMvc
public class TestingWebApplicationTest {

   @Autowired
   private MockMvc mockMvc;

   @Test
   public void shouldReturnDefaultMessage() throws Exception {
      this.mockMvc.perform(get("/")).andDo(print()).andExpect(status().isOk())
            .andExpect(content().string(containsString("Hello, World")));
   }
}
```

```java
@RunWith(SpringRunner.class)
@WebMvcTest(GreetingController.class)
public class WebMockTest {

	@Autowired
	private MockMvc mockMvc;

	@MockBean
	private GreetingService service;

	@Test
	public void greetingShouldReturnMessageFromService() throws Exception {
		when(service.greet()).thenReturn("Hello, Mock");
		this.mockMvc.perform(get("/greeting")).andDo(print()).andExpect(status().isOk())
				.andExpect(content().string(containsString("Hello, Mock")));
	}
}
```

- 由于使用的是`import org.junit.Test`，即Junit4，所以，需要加上@RunWith
- 由于`@WebMvcTest`内置了`@AutoConfigureMockMvc`，所以可以直接注入MockMvc而不需要加`@AutoConfigureMockMvc`

### 异常测试的几种方法

## 踩坑

- 不要单独导入如下mybatis依赖，**会导致严重错误!!!**

  - mockbean注解失效
- mockMVC返回请求体乱码
  
  ```
  //testImplementation 'org.mybatis.spring.boot:mybatis-spring-boot-starter-test:2.1.3'
  ```

- 多个@Test方法的执行顺序

  对于Test函数执行顺序的设置可以通过在类名前通过`@FixMethodOrder(value)`来设置，其中

  - `MethodSorters.DEFAULT`是默认hashcode顺序
  - `MethodSorters.NAME_ASCENDING`是按照字典顺序
  - `MethodSorters.JVM`是按照JVM返回次序执行

  **但是，单元测试用例不应该依赖执行顺序，所以了解就行**

## Reference

[阿里巴巴Java开发手册(嵩山版)](https://github.com/alibaba/p3c/blob/master/Java%E5%BC%80%E5%8F%91%E6%89%8B%E5%86%8C%EF%BC%88%E5%B5%A9%E5%B1%B1%E7%89%88%EF%BC%89.pdf)

[Spring Boot features-Testing](https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-testing.html)

[Spring Boot Test (二、注解详解)](http://ypk1226.com/2018/11/20/spring-boot/spring-boot-test-2/)

[MockMvc详解——SpringMVC单元测试](https://blog.csdn.net/kqZhu/article/details/78836275?utm_medium=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.control&dist_request_id=1328642.41741.16157258723752993&depth_1-utm_source=distribute.pc_relevant.none-task-blog-BlogCommendFromMachineLearnPai2-2.control)

[JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/#writing-tests)



