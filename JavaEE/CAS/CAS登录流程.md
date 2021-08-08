# CAS登陆流程

以工作中的用户分析平台项目（analysis）为例，分析CAS-Shiro的登陆

1. 访问 `http://localhost/analysis`

   请求会被ngixn如下配置拦截

   ```nginx
   location /analysis/ {
       root   D:\work\dist;
       index  index.html index.htm;
       try_files $uri $uri/ /analysis/index.html;
       add_header Cache-Control "max-age=0";
       # add_header Cache-Control "no-cache";
   }
   ```

   最后会定位到 `/analysis/index.html`

   接着会请求一系列静态资源，也走nginx的该配置

2. 其中的一个js会首先发起异步调用

   `/data-web/user/detail?dataplatformCode=analysis`

   ![image-20210301160533112](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301160533112.png)

   这个时候，会被nginx的如下配置拦截

   ```nginx
   location /data-web/ {
       proxy_pass http://localhost:9010;
   }
   ```

   请求会被ngixn转发到后端，会被后端的认证拦截器拦截

   ```java
   filterChainDefinitionMap.put("/**", "formAuthenticationRewriteFilter");
   ```

   该过滤器父类中有如下方法

   ```java
   //AccessControlFilter
   public boolean onPreHandle(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
       return isAccessAllowed(request, response, mappedValue) || onAccessDenied(request, response, mappedValue);
   }
   ```

   ```java
   //查看当前用户是否是已登录状态
   protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
       Subject subject = getSubject(request, response);
       return subject.isAuthenticated();
   }
   ```

   ```java
   //不是登录状态则执行下面的方法
   onAccessDenied()
   ```

   ```java
   //访问的不是登录的URL的情况下，重定向到对应的登录URL
   redirectToLogin(ServletRequest request, ServletResponse response)
   ```

   我们重写了`redirectToLogin()`方法，里面会判断来自哪个平台，然后重定向到对应的平台

   例如我们访问的是user/detail请求头携带的有form参数，就判断出是analysis平台，然后这里重定向到

   `http://localhost/cas/login?service=http://localhost/data-web/shiro-cas/analysis`

   ![image-20210301191436301](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301191436301.png)

3. 输入账号密码进行登录

   - 如果密码错误，那么CAS服务端直接会返回错误界面

     ![image-20210301213358648](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301213358648.png)

   - 输入正确密码

     登录成功就CAS server就会重定向到之前URL中的service参数

     ![image-20210301214014086](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301214014086.png)

4. 后端ticket校验

   访问`http://localhost/data-web/shiro-cas/analysis?ticket=ST-43-5KuHFd0qfMrn5EDdK1NH-cas01.example.org` 即刚刚登录时携带的service参数，到后端进行ticket校验

   - 当后端接受到该请求，请求都会到达AccessControllerFilterd的`onPreHandle()`方法，判断现在是否是登录状态（所有请求都会到达这个地方）

     ```java
     public boolean onPreHandle(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
         return isAccessAllowed(request, response, mappedValue) || onAccessDenied(request, response, mappedValue);
     }
     ```

   - 现在是未登录状态，那么就执行DataWebTicketFilter.java的

     ```java
     @Override
     protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
         return executeLogin(request, response);
     }
     ```

   - **AuthenticatingFilter的executeLogin()**

     ```java
     protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
         //封装token
         AuthenticationToken token = createToken(request, response);
         if (token == null) {
             String msg = "createToken method implementation returned null. A valid non-null AuthenticationToken " +
                 "must be created in order to execute a login attempt.";
             throw new IllegalStateException(msg);
         }
         try {
             Subject subject = getSubject(request, response);
             subject.login(token);
             return onLoginSuccess(token, subject, request, response);
         } catch (AuthenticationException e) {
             return onLoginFailure(token, e, request, response);
         }
     }
     ```

     封装token

     到DataWebTicketFilter的`createToken()`

     ```java
     @Override
     protected AuthenticationToken createToken(ServletRequest request, ServletResponse response) throws Exception {
         HttpServletRequest httpRequest = (HttpServletRequest) request;
         String uri = httpRequest.getRequestURI();
         String ticket = httpRequest.getParameter(TICKET_PARAMETER);
         if (uri.contains(DataplatformCodeEnum.USERTAG)) {
             return new DataWebCasToken(ticket, DataplatformCodeEnum.USERTAG);
         } else {
             return new DataWebCasToken(ticket, DataplatformCodeEnum.USERANALYSIS);
         }
     }
     ```

     最后得到token，这是我们封装的token，里面有ticket和from参数

     ![image-20210301225701497](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301225701497.png)

     - 校验ticket

       `subject.login(token);`

       最后会到达我们重写的CasShiroRealm的`doGetAuthenticationInfo()`，内有如下方法：

       `AuthenticationInfo authc = validTicket(token);`

       - `ticketValidator.validate(ticket, service)`

         ```java
         private AuthenticationInfo validTicket(AuthenticationToken token) throws AuthenticationException {
             //转换为我们自己写的DataWebCasToken，封装了from参数
             DataWebCasToken casToken = (DataWebCasToken) token;
             //校验ticket省略
             TicketValidator ticketValidator = ensureTicketValidator();
             // 根据token来源不同，选择不同的cas server ticket验证路径
             String service;
             if (DataplatformCodeEnum.USERTAG.equals(casToken.getFrom())){
                 service = ShiroConfiguration.USERTAG_TICKET_SERVICE;
             }else if (DataplatformCodeEnum.USERANALYSIS.equals(casToken.getFrom())){
                 service = ShiroConfiguration.ANALYSIS_TICKET_SERVICE;
             }else {
                 service = ShiroConfiguration.DAP_TICKET_SERVICE;
             }
             try {
                 // contact CAS server to validate service ticket
                 Assertion casAssertion = ticketValidator.validate(ticket,service);
                 // get principal, user id and attributes
                 AttributePrincipal casPrincipal = casAssertion.getPrincipal();
                 String userId = casPrincipal.getName();
                 Map<String, Object> attributes = casPrincipal.getAttributes();
                 // 设置token的ID
                 casToken.setUserId(userId);
         		//remberme省略
                 // create simple authentication info
                 List<Object> principals = CollectionUtils.asList(userId, attributes);
                 PrincipalCollection principalCollection = new SimplePrincipalCollection(principals, getName());
                 return new SimpleAuthenticationInfo(principalCollection, ticket);
             } catch (TicketValidationException e) {
                 throw new CasAuthenticationException("Unable to validate ticket [" + ticket + "]", e);
             }
         }
         ```

         - `validate(ticket,service);`

           ```java
           //ticket:  ST-3-ZzB45QmLdgYCSmlAsfrR-cas01.example.org
           //service: http://localhost/data-web/shiro-cas/analysis
           public Assertion validate(final String ticket, final String service) throws TicketValidationException {
               //这里通过service构造出了CAS Server的校验URL(casServerUrlPrefix)
               //validationUrl: http://localhost/cas/serviceValidate?ticket=ST-4-G2ZgSKO1RRB6PNmjdCx9-cas01.example.org&service=http%3A%2F%2Flocalhost%2Fdata-web%2Fshiro-cas%2Fanalysis
               final String validationUrl = constructValidationUrl(ticket, service);
           	//...
               try {
                   log.debug("Retrieving response from server.");
                   //这里发请求进行ticket校验
                   final String serverResponse = retrieveResponseFromServer(new URL(validationUrl), ticket);
           
                   if (serverResponse == null) {
                       throw new TicketValidationException("The CAS server returned no response.");
                   }
                   //可以拿到用户的唯一标识
                   return parseResponseFromServer(serverResponse);
               } catch (final MalformedURLException e) {
                   throw new TicketValidationException(e);
               }
           }
           ```

           其中Assertion parseResponseFromServer(serverResponse);

           最后得到assertion,里面的principal为用户的唯一标识

           ![image-20210301233850964](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301233850964.png)

       - `new SimpleAuthenticationInfo(principalCollection, ticket)`

         ![image-20210301235441974](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210301235441974.png)

       - 执行完doGetAuthenticationInfo的AuthenticationInfo authc = validTicket(token);

       - 接下来是将用户初始化session中：

         ```java
         //根据唯一标识插入或者获取用户
         User sysUser = userService.initSessionUser(account, from);
         //将用户存储到session中
         SecurityUtils.getSubject().getSession().setAttribute("user", sysUser);
         ```

         ![image-20210302000057561](https://gitee.com/mrwujunnan/cloudimage/raw/master/img/image-20210302000057561.png)

5. token校验成功后进行重定向

   ```java
   protected void issueSuccessRedirect(ServletRequest request, ServletResponse response, String from) throws Exception {
       WebUtils.redirectToSavedRequest(request, response, "/index/" + from);
   }
   ```

6. 然后进入EntryController，进行匹配

   ```java
   @GetMapping(value = "/index/analysis")
   public void analysisPage(HttpServletResponse response) throws Exception {
       // /usertag/
       response.sendRedirect(ShiroConfiguration.ANALYSIS_INDEX);
   }
   
   @GetMapping(value = "/index/usertag")
   public void usertagPage(HttpServletResponse response) throws Exception {
       response.sendRedirect(ShiroConfiguration.USERTAG_INDEX);
   }
   
   @GetMapping(value = "/index/dap")
   public void dapPage(HttpServletResponse response) throws Exception {
       response.sendRedirect(ShiroConfiguration.DAP_INDEX);
   }
   ```

7. 重定向后相当于再次访问 `localhost/analysis/`，再向后端发起请求通过JsessionID即可被验证为登录状态