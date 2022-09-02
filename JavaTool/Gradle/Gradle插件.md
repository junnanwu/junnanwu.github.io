# Gradle插件

## spring-boot-gradle-plugin

Spring Boot Gradle插件在Gradle中提供了Spring Boot支持。它支持如下功能：

1. 将项目打包为Jar包或War包
2. 运行SpringBoot应用
3. 使用spring-boot-dependecied管理依赖

此插件需要Gradle版本在6.8、6.9或7.x。

### 引入插件

```
plugins {
	id 'org.springframework.boot' version '2.7.3'
}
```

## io.spring.dependency-management

用于管理项目依赖的版本。

此插件需要Gradle版本在6.8、6.9或7.x。

## 引入插件

```
plugins {
    id "io.spring.dependency-management" version <<version>>
}
```



## References

1. https://docs.spring.io/spring-boot/docs/current/gradle-plugin/reference/htmlsingle