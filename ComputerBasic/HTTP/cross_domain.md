# 跨域

**跨域请求**就是指：当前发起请求的域与该请求指向的资源所在的域不一样。这里的域指的是这样的一个概念：我们认为若**协议 + 域名 + 端口号均相同**，那么就是同域。

了解跨域的基本知识，推荐阮一峰老师的两篇文章：

- [浏览器同源政策及其规避方法](https://www.ruanyifeng.com/blog/2016/04/same-origin-policy.html)
- [跨域资源共享 CORS 详解](http://www.ruanyifeng.com/blog/2016/04/cors.html)

## Spring解决跨域问题

Spring可以在个别接口开启跨域，也可以全局开启跨域。

### 单个接口开启跨域

```java
@CrossOrigin(origins = "http://localhost:8080")
@GetMapping("/greeting")
public Greeting greeting(@RequestParam(required = false, defaultValue = "World") String name) {
    System.out.println("==== get greeting ====");
    return new Greeting(counter.incrementAndGet(), String.format(template, name));
```

#### 注解属性

- `origins`

  即`Access-Control-Allow-Origin`，该请求头在客户端返回的时候是必须携带的，表示允许哪些源访问，Spring的默认值为`*`。

- `methods`

  即`Access-Control-Allow-Methods`，该请求头表明服务器支持的请求的方法，Spring默认值为所有方法。

- `allowedHeaders`

  即`Access-Control-Allow-Headers`请求头，即除了基本的表单请求头，允许客户端携带哪些额外的请求头。

- `exposedHeaders`

- `allowCredentials`

  即`Access-Control-Allow-Credentials`响应头，默认情况下，Cookies不包括在CORS之中，设置为`true`之后，表示服务器允许客户端发送时携带cookie。

- `maxAge`

  即`Access-Control-Max-Age`响应头，指示预检请求的有效期。

既可以在单个方法上开启`@CrossOrigin`，也可以在整个Controller上面开启跨域。

### 全局开启跨域

在Application中添加如下：

```java
package com.example.restservicecors;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@SpringBootApplication
public class RestServiceCorsApplication {
	public static void main(String[] args) {
		SpringApplication.run(RestServiceCorsApplication.class, args);
	}

	@Bean
	public WebMvcConfigurer corsConfigurer() {
		return new WebMvcConfigurer() {
			@Override
			public void addCorsMappings(CorsRegistry registry) {
				registry.addMapping("/greeting-javaconfig").allowedOrigins("http://localhost:8080");
			}
		};
	}
}
```

可以全局配置和精准配置配合使用。

## References

1. 阮一峰博客：[跨域资源共享 CORS 详解](http://www.ruanyifeng.com/blog/2016/04/cors.html)
2. Spring官方文档：[Enabling Cross Origin Requests for a RESTful Web Service](https://spring.io/guides/gs/rest-service-cors/)
