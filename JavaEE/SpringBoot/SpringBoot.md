# SpringBoot配置项

引用其他配置：

可以使用`${}`占位符来引用其他配置甚至嵌入到其他文本中间：

```
${spring.application.name}
```

## Server

`server.address`

指定了服务应该绑定在哪个ip上。

> For servers with more than one IP address, this attribute specifies which address will be used for listening on the specified port. By default, the connector will listen all local addresses. 

[tomcat7](http://tomcat.apache.org/tomcat-7.0-doc/config/http.html)上可以看到tomcat存在此属性，指定监听的是哪个地址的端口。

默认配置是`0.0.0.0`，允许所有地址，也可以配置成私网ip地址。

`server.servlet.session.timeout`

设置session的过期时间，默认是30分钟

`server.port`

将端口设置为0，那么服务就会任选一个可用的端口

## 日志

默认情况下，Spring Boot通过Logback配置日志，日志会以INFO级别写入到控制台中。

如果想要完全控制日志，我们可以在classpath的根目录下创建一个logback.xml文件。

也可以通过在application.yml中进行配置。

例如：

```
logging:
  file: logs/data-web.log
  level:
    root: INFO
    com.data.web.backend: DEBUG
    com.data.web.upms: DEBUG
  pattern:
    console: '%d{yyyy/MM/dd-HH:mm:ss} [%thread] %-5level %logger [%L]- %msg%n'
    file: '%d{yyyy/MM/dd-HH:mm:ss} [%thread] %-5level %logger [%L]- %msg%n'
```





## References

1. https://www.jianshu.com/p/9d91cca74082
