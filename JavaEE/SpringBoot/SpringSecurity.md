# SpringSecurity

## 配置

关闭CSRF防护

```
http.csrf().disable();
```

指跨站请求伪造（Cross-site request forgery），是web常见的攻击之一。

从 Spring Security4 开始 CSRF 防护默认开启。默认会拦截请求。进行 CSRF 处理。CSRF 为了保证不是其他第三方网站访问，要求访问时携带参数名为_csrf 值为 token(token 在服务端产生)的内容，如果token 和服务端的 token 匹配成功，则正常访问。

## 允许跨域





## Refereces

1. https://zhuanlan.zhihu.com/p/22521378
