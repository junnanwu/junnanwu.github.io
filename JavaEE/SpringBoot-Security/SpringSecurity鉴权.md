# Spring Security鉴权

所有的Authentication实现类都保存了一个GrantedAuthority列表，其表示用户所具有的权限。

GrantedAuthority是通过AuthenticationManager设置到Authentication对象中的，然后AccessDecisionManager将从Authentication中获取用户所具有的GrantedAuthority来鉴定用户是否具有访问对应资源的权限。

## 调用前——AccessDecisionManager

基于投票的AccessDecisionManager，它在调用方法之前判断用户是否有访问该对象的权限。

![img](SpringSecurity%E9%89%B4%E6%9D%83_assets/DecisionManager-structure.png)

一系列的AccessDecisionVoter将会被AccessDecisionManager用来对Authentication是否有权访问受保护对象进行投票，然后再根据投票结果来决定是否要抛出AccessDeniedException。

```java
public interface AccessDecisionManager {
    
    /**
     * 通过传递的参数来决定用户是否有访问对应受保护对象的权限
     * @param authentication 当前正在请求受包含对象的Authentication
     * @param object 受保护对象，其可以是一个MethodInvocation、JoinPoint或FilterInvocation
     * @param configAttributes 与正在请求的受保护对象相关联的配置属性
     */
    void decide(Authentication authentication, Object object, Collection<ConfigAttribute> configAttributes)
        throws AccessDeniedException, InsufficientAuthenticationException;

    /**
     *  表示当前AccessDecisionManager是否支持对应的ConfigAttribute
     */
    boolean supports(ConfigAttribute attribute);

    /**
     *  表示当前AccessDecisionManager是否支持对应的受保护对象类型
     */
    boolean supports(Class<?> clazz);

}
```

### AccessDecisionManager实现

Spring Security内置了三个基于投票的AccessDecisionManager实现类

- AffirmativeBased（默认）

  只要有赞同的就通过

- ConsensusBased

  如果赞成票多于反对票则表示通过

- UnanimousBased

  有任意反对票则不通过

### Voter

- RoleVoter

  如果ConfigAttribute是以“ROLE_”开头的，则将使用RoleVoter进行投票

- AuthenticatedVoter

  AuthenticatedVoter可以处理的ConfigAttribute有

  - `IS_AUTHENTICATED_FULLY`

    仅当用户是通过登录入口进行登录的才会投赞成票

  - `IS_AUTHENTICATED_REMEMBERED`

    仅当用户是由Remember-Me自动登录，或者是通过登录入口进行登录认证时才会投赞成票

  - `IS_AUTHENTICATED_ANONYMOUSLY`

    不管用户是匿名的还是已经认证的都将投赞成票

## 调用后——AfterInvocationManager

略

## 注解的方式控制权限

- 配置中接口控制

  ```java
  http.authorizeRequests().antMatchers("/api/user/select/one").hasAuthority("DISTRIBUTOR")
  ```

- 方法级别控制

  需要在配置类上加上注解：

  ```java
  @EnableGlobalMethodSecurity(prePostEnabled = true)
  ```

  使用：

  ```java
  @GetMapping("/select/one")
  @PreAuthorize("hasAuthority('DISTRIBUTOR')")
  public ApiResult selectOneUser(Long id) {
      AssertUtil.assertNotNull(id, "用户id不能为空");
      return userService.selectUserById(id);
  }
  ```

  - `@PreAuthorize(SpEL表达式)`

    在方法调用前进行权限检查，表达式为true允许调用

  - `@PostAuthorize(SpEL表达式)`

    在方法调用后进行权限检查，表达式为true允许调用，`returnObject`代表方法的返回值

    （可以用在Service或Dao的方法上）



## References

1. https://www.iteye.com/blog/elim-2247057
