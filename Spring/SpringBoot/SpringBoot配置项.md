# SpringBoot配置项

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

## References

1. http://tomcat.apache.org/tomcat-7.0-doc/config/http.html
