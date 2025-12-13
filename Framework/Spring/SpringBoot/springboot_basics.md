# Spring Boot基础

## 依赖

### Parent

**Maven**

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.1.6.RELEASE</version>
</parent>
```

意味着我么要以spring-boot-starter-parent作为我们项目的父POM，这个父POM为Spring项目常用的一些库提供了依赖管理，你在生命的时候不需要再指定它们的版本。

### Starter

Spring Boot starter依赖本身不包含库代码，而是传递其他库，从而使得构建文件更小、添加依赖更加方便、版本统一。

**Spring总览**

- Spring核心依赖

  提供了核心容器和依赖注入，包括Spring MVC，对JDBC的支持。

- Spring Boot

  - Stater依赖、自动配置
  - Actuator监控
  - 对测试的额外支持

- Spring Data

  Spring Data能够处理多种不同类型的数据库

- Spring Security

- Spring Integration和Spring Batch

  提供了应用程序集成模式的实现。

- Spring Cloud

## @SpringBootApplication

这是一个组合注解：

- @SpringBootConfiguration

  将该类声明为配置类，是@Configuration的特殊形式

- @EableAutoConfigutation

  启动Spring Boot的自动配置，告诉Spring Boot自动配置一些组件

- @ComponentScan

  启用组件扫描，这样Spring会发现@Component等注解声明的类，并将其注册为Spring Application Context中的组件

对于简单的应用，可以在引导类中配置一两个组件，但是对于大多数应用，还是应该为没有自动配置的功能创建一个单独的配置类。

## 测试

@RunWith(SpringRunner.class)是JUnit的注解，它会提供一个测试运行器来指导JUnit如何运行测试，这里为JUnit提供的是SpringRunner，这是一个Spring提供的测试运行器，它会创建测试运行所需的Spring Application Context，SpringRunner是SpringJUnit4ClassRunner的别名。









