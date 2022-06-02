# SpringBoot

## SpringBoot特性

- 创建独立的Spring应用
- 直接嵌入Tomcat、Jetty等Web容器
- 提供固化的Stater依赖，简化构建配置
- 当条件满足时自动装配Spring或第三方类库
- 提供运维特性，如指标信息，健康检查等
- 绝无代码生成，并且不需要XML配置

## spring-boot-starter-parent

Spring项目都会导入spring-boot-starter-parent作为其父POM

- 为Spring项目常用的一些库提供了依赖管理，你不再需要指定他们的版本

## SpringBoot stater

好处：

- 引入的依赖更少
- 见名知意
- 不必担心库版本问题，只需要关系使用的是哪个版本的Springboot就可以了，不用关心引入的Stater的版本

## spring-boot-maven-plugin

## 引导类

### @SpringBootApplication

@SpringBootApplication是一个组合注解

- @SpringBootConfiguration

  @Configuration的特殊形式

- @EnableAutoConfiguration

  启用Spring boot的自动配置

- @ConponentScan

  启用组件扫描，这样我们能使用@Conponent、@Controller、@Service这样的注解声明其他类

## References

1. 《Spring实战》
2. 《SpringBoot编程思想》

