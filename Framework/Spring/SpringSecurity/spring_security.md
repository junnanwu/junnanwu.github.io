# SpringSecurity



优秀文章：

1. https://www.cnblogs.com/zongmin/category/1859813.html







`WebSecurityConﬁgurerAdapter`抽象类

```
/**
 * 定制用户认证管理器来实现用户认证
 *  1. 提供用户认证所需信息（用户名、密码、当前用户的资源权）
 *  2. 可采用内存存储方式，也可能采用数据库方式
 */
void configure(AuthenticationManagerBuilder auth);

/**
 * 定制基于 HTTP 请求的用户访问控制
 *  1. 配置拦截的哪一些资源
 *  2. 配置资源所对应的角色权限
 *  3. 定义认证方式：HttpBasic、HttpForm
 *  4. 定制登录页面、登录请求地址、错误处理方式
 *  5. 自定义 Spring Security 过滤器等
 */
void configure(HttpSecurity http);

/**
 * 定制一些全局性的安全配置，例如：不拦截静态资源的访问
 */
void configure(WebSecurity web);
```



## 配置

关闭CSRF防护

```
http.csrf().disable();
```

指跨站请求伪造（Cross-site request forgery），是web常见的攻击之一。

从 Spring Security4 开始 CSRF 防护默认开启。默认会拦截请求。进行 CSRF 处理。CSRF 为了保证不是其他第三方网站访问，要求访问时携带参数名为_csrf 值为 token(token 在服务端产生)的内容，如果token 和服务端的 token 匹配成功，则正常访问。

## Session

中提供了session配置管理，包括session无效处理，session并发控制，session过期处理等。

### Session过期时间

默认半个小时，最小60秒

```
server.servlet.session.timeout=1m
```

### SessionManagementFilter

此处的核心类为SessionManagementFilter

```java
private void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
      throws IOException, ServletException {
   //避免重复执行
   if (request.getAttribute(FILTER_APPLIED) != null) {
      chain.doFilter(request, response);
      return;
   }
   request.setAttribute(FILTER_APPLIED, Boolean.TRUE);
   //判断repo中是否未存储过同一session id请求，存过的话，则跳过
   if (!this.securityContextRepository.containsContext(request)) {
      Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
       //身份非空，且不是匿名认证
      if (authentication != null && !this.trustResolver.isAnonymous(authentication)) {
         try {
            //session认证策略，修改session的id，并进行Session的校验，例如，是否超过最大限制数
            this.sessionAuthenticationStrategy.onAuthentication(authentication, request, response);
         }
         catch (SessionAuthenticationException ex) {
            SecurityContextHolder.clearContext();
            this.failureHandler.onAuthenticationFailure(request, response, ex);
            return;
         }
         //将身份信息存储到session
         this.securityContextRepository.saveContext(SecurityContextHolder.getContext(), request, response);
      }
      // 用户未登录
      else {
         // cookie中sessionId不为空，且失效，则走session失效策略
         if (request.getRequestedSessionId() != null && !request.isRequestedSessionIdValid()) {
            if (this.invalidSessionStrategy != null) {
               this.invalidSessionStrategy.onInvalidSessionDetected(request, response);
               return;
            }
         }
         // sessionId为空或session未失效，则走下一个过滤器
      }
   }
   chain.doFilter(request, response);
}
```

### Session策略

- Session无效处理


Spring Security在Session无效可以采用两种策略

- 重定向
- 自定义策略

#### 重定向

**SecurityConfig**

```java
http.authorizeRequests()
	.antMatchers("/api/user/session/timeout").permitAll()
	.sessionManagement().invalidSessionUrl("/api/user/session/timeout").and();
```

默认实现为`SimpleRedirectInvalidSessionStrategy`。

**Controller**

```java
@RestController
@RequestMapping("/api/user")
public class UserController {
    @GetMapping("/session/timeout")
    public Object sessionTimeout() {
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        HttpSession session = request.getSession();
        System.out.println("session: " + session.getMaxInactiveInterval());
        return new ApiResult(ErrorCode.SESSION_TIMEOUT, "session过期");
    }
}
```

**效果**

当session失效后访问后端需认证链接，会302重定向到`/api/user/session/timeout`。

#### 自定义策略

**SecurityConfig**

```java
http.authorizeRequests()
	.sessionManagement().invalidSessionStrategy(new MyInvalidSessionStrategy()).and();
```

**MyInvalidSessionStrategy**

```java
public class MyInvalidSessionStrategy implements InvalidSessionStrategy {

    @Override
    public void onInvalidSessionDetected(HttpServletRequest request, HttpServletResponse response) throws IOException {
        //清空前端的cookie,避免后续的请求跳转到这里
        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath());
        response.addCookie(cookie);
        response.setContentType("application/json;charset=utf-8");
        ApiResult resultVO = new ApiResult(ErrorCode.SESSION_TIMEOUT, "session过期！");
        response.getWriter().write(new JSONObject(resultVO).toString());
    }

}
```

**效果**

当session失效后访问后端需认证链接，会直接返回上述JSON。

## 允许跨域







## Refereces

1. https://zhuanlan.zhihu.com/p/22521378
