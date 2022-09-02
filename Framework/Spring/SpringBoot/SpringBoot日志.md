# SpringBoot日志

SpringBoot默认使用Commons Logging作为日志接口层，默认提供了如下实现供选择：

- `Java Util Logging`
- `Log4J2`
- `Logback`

SpringBoot默认使用Logback作为底层日志实现。

可以通过参数来控制SpringBoot使用哪种日志系统：

 `org.springframework.boot.logging.LoggingSystem`



## 定制日志输出

### Logback

文件名可以为如下几种：

- `logback-spring.xml`、`logback-spring.groovy`
- `logback.xml`、`logback.groovy`

## References

1. https://docs.spring.io/spring-boot/docs/2.1.13.RELEASE/reference/html/boot-features-logging.html