# Basic Authotization

基本认证（Basic Authotization），是HTTP提供的一个原生的账号密码认证框架，浏览器基本都会支持。

当浏览器检测到了启用了基本认证，会弹出账号密码框让你登陆（Chrome浏览器如下）：

![basic_authotization_example](basic_authotization_assets/basic_authotization_example.png)

## 步骤

1. 用户发送没有认证的链接

   ```
   GET /family/jeff.jpg HTTP/1.0
   ```

2. 服务器检测到没有Authotization请求头返回一条401，包含`WWW-Authotization`响应头

   ```
   HTTP/1.0 401 Authorization Required
   WWW-Authenticate: Basic realm="Family"
   ```

3. 浏览器收到上述响应，弹出输入用户名密码对话框。

   用户输入账号密码后，用冒号拼接起来，后使用Base-64编码，然后将其放在Authorization首部中发送

   ```
   GET /family/jeff.jpg HTTP/1.0
   Authorization: Basic YnJpYW4tdG90dHk6T3ch
   ```

4. 服务器对用户名和密码进行解码验证

   ```
   HTTP/1.0
   200 OK
   Content-type: image/jpeg
   ...
   <image data included>
   ```

5. 浏览器缓存账号密码，下次请求自动带上

   ```
   GET /family/john.jpg HTTP/1.0
   Authorization: Basic YnJpYW4tdG90dHk6T3ch
   ```

## 安全域

`WWW-Authenticate`响应中包含了一个realm指令，Web服务器会将受保护的文档组织成一个安全域，不同安全域可以有不同的密码。

```
WWW-Authenticate: Basic realm="Corporate Financials"
```

## BASE64编码的作用

1. 打乱用户名和密码，避免明文
2. 有些用户名和密码会包括国际字符或在HTTP请求头中非法的字符，例如引号、冒号、回车，Base64可以将其转换成简单的字母表

## 注销

1. 当输入账号密码之后，客户端会缓存账号密码，退出浏览器后重新打开，则需要重新输入账号密码
2. 专门提供一个logout接口，返回401（经测试，在chrome中不好使）

## 缺陷

1. 使用Base64编码，基本等于明文传输，需要配合HTTPS使用
2. 第三方可以捕获编码后的用户名和密码，进行重放攻击

故Basic认证适合安全性要求不高的认证场景。

## Java实现

```java
@GetMapping("618")
public Object get618Data(HttpServletRequest request, HttpServletResponse response) throws IOException {
    String authorization = request.getHeader("authorization");
    if (authorization == null || "".equals(authorization)) {
        response.setStatus(401);
        response.setHeader("WWW-authenticate", "Basic realm=\"Display618\"");
        return new RestResult("000", "未授权");
    }
    String userPasswordString = new String(new BASE64Decoder().decodeBuffer(authorization.split(" ")[1]));
    String[] userPasswordArray = userPasswordString.split(":");
    if (userPasswordArray.length < 2) {
        response.setStatus(401);
        response.setHeader("WWW-authenticate", "Basic realm=\"Display618\"");
        return new RestResult("000", "格式错误");
    }
    String user = userPasswordArray[0];
    String pass = userPasswordArray[1];
    if (user.equals("111") && pass.equals("111")) {
        return new RestResult(ResCodeEnum.SUCCESS.getCode(), hszDisplayService.get618Data());
    } else {
        response.setStatus(401);
        response.setHeader("WWW-authenticate", "Basic realm=\"Display618\"");
        return new RestResult("000", "格式错误");
    }
}
```

## References

1. David Gourley等，《HTTP权威指南》，p294
2. stack overflow：[How to log out user from web site using BASIC authentication?](https://stackoverflow.com/questions/233507/how-to-log-out-user-from-web-site-using-basic-authentication)
