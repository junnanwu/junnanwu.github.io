# Spring Security 退出登录

## 退出登录需要做什么

1. 使用session失效
2. 如果配置了rememberme, 则清除rememberme认证
3. 清除SecurityContextHolder
4. 清除cookie

## LogoutFilter

登录逻辑是由过滤器 `LogoutFilter` 来执行：

```java
public LogoutFilter(LogoutSuccessHandler logoutSuccessHandler, LogoutHandler... handlers) {
    //默认使用CompositeLogoutHandler
    this.handler = new CompositeLogoutHandler(handlers);
    Assert.notNull(logoutSuccessHandler, "logoutSuccessHandler cannot be null");
    this.logoutSuccessHandler = logoutSuccessHandler;
    //默认登出连接/logout
    setFilterProcessesUrl("/logout");
}

//处理登出
private void doFilter(HttpServletRequest request, HttpServletResponse response, FilterChain chain)
    throws IOException, ServletException {
    if (requiresLogout(request, response)) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        //1. 调用LogoutHandler 调用CompositeLogoutHandler 
        this.handler.logout(request, response, auth);
        //2. 调用LogoutSuccessHandler 进行重定向
        this.logoutSuccessHandler.onLogoutSuccess(request, response, auth);
        return;
    }
    chain.doFilter(request, response);
}
```

CompositeLogoutHandler内部有多个handler：

- CookieClearingLogoutHandler

  清除cookie

- PersistentTokenBasedRememberMeServices

  清除remember-me

- SecurityContextLogoutHandler

  使Session无效，清空SecurityContext

## 更改默认配置

可以修改默认配置：

```java
http.authorizeRequests().and().logout()
    .invalidateHttpSession(true)
    .clearAuthentication(true)
    .logoutUrl("/signout")
    .logoutSuccessUrl("/signout/success")
    .deleteCookies("JSESSIONID")
    //.logoutSuccessHandler(logOutSuccessHandler)
    .and()
```

由于前后端分离，所以我们退出登录后需要返回前端统一的JSON结果，并不进行重定向，由前端路由完成跳转登录，需要修改默认配置，定制`LogoutSuccessHandler`。

## LogoutSuccessHandler

当用户登出成功后，可以通过重写此接口来实现一些复杂的逻辑。

```java
@Component
public class MyLogOutSuccessHandler implements LogoutSuccessHandler {
    @Override
    public void onLogoutSuccess(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Authentication authentication) throws IOException, ServletException {
        httpServletResponse.setStatus(HttpStatus.UNAUTHORIZED.value());
        httpServletResponse.setContentType("application/json;charset=utf-8");
        httpServletResponse.getWriter().write("退出成功，请重新登录");
    }
}
```

需要注意，`Spring Security`默认以 POST 方式请求访问`/logout`注销登录，以 POST 方式请求的原因是为了防止 csrf（跨站请求伪造），如果想使用 GET 方式的请求，则需要关闭 csrf 防护。

## References

1. https://www.cnblogs.com/zongmin/p/13783285.html
