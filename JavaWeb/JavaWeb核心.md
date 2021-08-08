# JavaWeb核心

## 服务器

### tomcat服务器

tomcat的目录结构

![tomcat目录结构](JavaWeb%E6%A0%B8%E5%BF%83_assets/tomcat%E7%9B%AE%E5%BD%95%E7%BB%93%E6%9E%84.png)

![tomcat目录结构](JavaWeb%E6%A0%B8%E5%BF%83_assets/tomcat目录结构.png)

**开启tomcat服务器**

注意: 

1. tomcat服务器的文件夹路径不能有中文和空格, 例如Program Files文件夹下是不行的
2. 记得配置好JAVA_HOME的文件, tomcat在启动的时候, 会去找环境变量JAVA_HOME, 里面应该设置为jdk的安装路径(不要加bin路径)

配置完成后, 双击startup.bat服务器就可以启动, 默认占用电脑的8080端口

在地址栏输入http://local:8080即可访问

**改变自己的端口号**

修改conf文件夹中的sever.xml 69行的位置

### web项目

```
web项目（myweb）
||
|| ------ html css  js  JavaWeb%E6%A0%B8%E5%BF%83_assets  二级目录等等
||
|| 
|| ------ WEB-INF目录（放在该目录下的资源浏览器是不能直接访问到）
||	        可选：html css  js  JavaWeb%E6%A0%B8%E5%BF%83_assets  二级目录等等  安全数据
||	        classess目录 放的都是java代码的 .class
||	        lib目录 放入项目需要的jar
||	        web.xml配置文件（配置的是项目的内容） 是tomcat首先会去加载的配置文件
servlet如果是2.5的版本这个web.xml文件必须有
servlet如果是3.0的版本这个web.xml文件可以不要  用注解代替
```

虚拟路径的2种发布形式

1. 配置server.xml, 添加context标签

   在server.xml配置文件的最后加上如下代码

   ```
   <Context path="项目的浏览器访问别名" docBase="项目所在的硬盘位置"/>
   ```

2. 配置独立的xml文件

   在tomcat/conf目录下新建了一个Catalina目录

   在Catalina目录下创建localhost目录

   在localhost目录下创建xml配置文件, 名称为: xxx.xml

   xxx.xml中代码如下:

   ```
   <Contex docBase="项目所在的硬盘位置"/>
   ```

   好处: 使用配置文件对项目的部署和卸载不用重启tomcat了, 也不影响tomcat整体的配置文件

**集成tomcat**

tomcat服务器已经集成在idea中, 可以通过idea控制tomcat的启动和关闭

首次使用我们需要配置tomcat, 

![tomcat首次配置](JavaWeb%E6%A0%B8%E5%BF%83_assets/tomcat首次配置.png)

### 创建web项目

1. 创建一个module![image-20200805012833802](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200805012833802.png)

2. 会自动生成一个web目录

   ![image-20200805012924281](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200805012924281.png)

3. 配置访问路径

   ![配置访问路径](JavaWeb%E6%A0%B8%E5%BF%83_assets/配置访问路径.png)

### 项目路径

![项目位置](JavaWeb%E6%A0%B8%E5%BF%83_assets/项目位置.png)

# HTTP协议

## 请求(Request)

- 请求行 
- 请求头 
- 请求体

![image-20200803234442430](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200803234442430.png)

![image-20200803233810213](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200803233810213.png)

注意: 只有post提交才有请求体, 是页面表单的数据要传递给服务器的内容

### post与get区别

![image-20200810221005938](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200810221005938.png)

1. 安全方面, get提交的数据不安全, 因为所有的页面表单数据都在请求行中, 意味着资源都在地址栏暴露了, post提交的数据安全, 因为所有的页面表单数据都在请求体中, 那么资源就不会在地址栏暴露了
2. 大小方面, get提交有着大小的限制, post提交没有大小的限制, 

## 响应(Response)

- 响应行

  ```
  HTTP/1.1 		200
  固定协议版本	   状态码
  ```

- 响应头

- 响应体

![image-20200803235300906](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200803235300906.png)

响应体即为要解析显示的内容

![image-20200803235528818](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200803235528818.png)

### 状态码

HTTP的状态码由三个十进制的数字组成, 第一个十进制定义了状态码的类型

常见的响应状态码：

- 200 OK 请求已成功，响应也没问题。出现此状态码是表示正常状态
- 302 资源重定向
- 304 去找缓存数据(访问两次静态资源)
- 403 服务器拒绝执行 （文件或文件夹加了权限）
- 404 请求的资源没找到
- 405 请求的方法不存在(doGet和doPost删除)
- 500 服务器错误 （代码写的有问题）

# Servlet

servlet(Server Applet), 实际上就是一个Java接口, 只有五个方法的interface, 所有servlet接口定义的是一套处理网络请求的规范, 所有实现servlet的类, 都需要实现他的五个方法, 其中`init()`和`destroy()`, 这是两个声明周期的方法, 还有一个处理请求的`service()`, 也就是说, 所有想要处理网络请求的类, 都要回答这三个问题:

- 你初始化时要做什么
- 你销毁的时候要做什么
- 你接受到请求的时候, 要做什么

然后我们会把servlet部署到一个容器中, 最常用的就是tomcat, tomcat时直接与客户端打交道的, 他监听了端口

![image-20200804012402595](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200804012402595.png)

书写servlet一个三个步骤:

1. 创建一个class实现servlet接口

2. 重写service方法

3. 创建的类必须在web.xml文件中做配置

   为什么要做配置, 必须将请求路径与Java程序的对应关系建立起来

**创建类, 重写方法**

```java
package com.itheima.web;

import javax.servlet.*;
import java.io.IOException;

public class MyServlet implements Servlet {
    @Override
    public void init(ServletConfig servletConfig) throws ServletException {
        System.out.println("11111");
    }

    @Override
    public ServletConfig getServletConfig() {
        return null;
    }

    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        System.out.println("浏览器访问到我了..");
    }

    @Override
    public String getServletInfo() {
        return null;
    }

    @Override
    public void destroy() {
        System.out.println("2222");
    }
}
```

里面涉及到三个形参

1. ServletConfig

   即Servlet配置, 我们在web.xml中配置了Servlet, Tomcat帮我们把servlet的一些参数信息, 封装进了ServletConfig对象

2. servletRequest

   HTTP request到了Tomcat之后, Tomcat通过字符串解析, 把各个请求头, 请求地址, 请求参数, 都封装进了servletRequest对象中, 通过以下方法调用都可以得到浏览器发出的请求信息

   ```
   servletRequest.getHeader();
   servletRequest.getUrl()；
   servletRequest.getQueryString();
   ```

3. servletResponse

   Tomcat传给Servlet时，它还是空的对象。Servlet逻辑处理后得到结果，最终通过response.write()方法，将结果写入response内部的缓冲区

**配置web.xml文件**

![image-20200805021512507](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200805021512507.png)

## Servlet的生命周期

默认情况下，**浏览器第一次访问servlet的时候, 创建该servlet的对象**, 执行init初始化方法, 只创建一次, 所有人使用的都是同一个servlet对象, 线程是不安全的, 浏览器每次访问你的时候都会执行service方法, 访问一次执行一次, 当服务器关闭的时候,  会销毁servlet 执行destory方法

## Servlet的体系结构

servlet(接口)-->GenericServlet-->HttpServlet

企业开发中, 继承HttpServlet, 只需要要复写doget和dopost方法, 而开发工具已经提供好了模板, 我们直接用即可

在HttpServlet中, 重写了service()方法, 里面对各种的提交方式进行了细分, 如果是get, 就调用doGet()方法, 如果是post, 就调用doPost()方法, 此外还有head, delete, options等提交方法,更加细化 

所以我们可以用父类的方法, 只重写doPost()和doGet()方法, 当遇到其他的方法的时候, 还用父类写的其他的如doDelete()提交方式, 依然走父类的service()方法 



当我们以后写了一个表单form, method为get或者post, action为服务器的地址, 那么我们不论是get还是post提交方式, 都是处理一样的内容,如果处理方法有上百行代码, 那么就会非常麻烦, 所以我们就可以, 只写doGet(), 然后doPost()中调用doGet()



我门可以使用快捷键直接创建servlet

![快捷键创建servlet](JavaWeb%E6%A0%B8%E5%BF%83_assets/快捷键创建servlet.png)

## Servlet的配置

### 配置web.xml

```
<servlet>
  <servlet-name>helloServlet</servlet-name>
  <servlet-class>com.itheima.web.HelloServlet</servlet-class>
</servlet>
<servlet-mapping>
  <servlet-name>helloServlet</servlet-name>
  <url-pattern>/hello</url-pattern>
</servlet-mapping>
```

### url-pattern配置

**一个servlet是否可以被不同的路径映射?**

![image-20200805171817649](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200805171817649.png)

答案是可以的, 但是在一般开发中, 我们只需要, 配置一个有效路径即可

#### 路径映射的配置方式还有哪些?

1. 完全匹配

   我们上面前写的都是完全匹配的方式, **它要求以"/"开始**

   **注意: 不加/在开启tomcat的时候就会出现一堆错误**

2. 目录匹配

   必须以"/"开始, 以"*"结束

   /*                 /aaa/*

3. 扩展名匹配

   不能以"/"开始, 以*.xx结束, xx代表的是后缀名

   *.action       *.do

注意, 只有一个servlet会执行, 执行的结果是按照优先级去执行的

优先级: 完全匹配>目录匹配>拓展名匹配

### load-on-startup配置

**load-on-startup:**

1. load-on-startup 元素标记容器是否应该在web应用程序启动的时候就加载这个servlet，(实例化并调用其init()方法)。
2. 它的值必须是一个整数，表示servlet被加载的先后顺序。
3. 如果该元素的值为负数或者**没有设置，则容器会当Servlet被请求时再加载**。
4. **如果值为正整数或者0时，表示容器在应用启动时就加载并初始化这个servlet**，值越小，servlet的优先级越高，就越先被加载。值相同时，容器就会自己选择顺序来加载。

也就是说想让一个servlet在服务器启动的时候, 就创建出来，就把它的load-on-startup的值设置为正整数，这样，一旦我们启动tomcat，就会执行init()方法

```xml
<servlet>
    <servlet-name>mySrevlet02</servlet-name>
    <servlet-class>com.ifheima.web.mySrevlet02</servlet-class>
    <load-on-startup>2</load-on-startup>
</servlet>
```

数字1被tomcat默认的servlet给占用了, 在Tomcat的web.xm中我们可以看到也使用了一个servlet

tomcat一启动就会加载2个web.xml文件, 一个是tomcat的web.xml, 一个是自己项目的web.xml

```xml
<servlet>
  <servlet-name>default</servlet-name>
  <servlet-class>org.apache.catalina.servlets.DefaultServlet</servlet-class>
  <load-on-startup>1</load-on-startup>
</servlet>
```

该servlet是tomcat帮我们创建的, 主要用来处理其他的servlet处理不了的请求, 比如当前下访问不到的资源都会走该servlet, 该servlet底层默认走的是写好的页面(404 500...)

### Servlet的路径

在我们开发的中, 经常在页面上通过表单向服务器发送请求, 如果我们访问的是一个servlet, 那么这时访问的servlet的路径应该如何书写

servlet的访问路径分为两种

**绝对路径**

带协议的绝对路径: 例如http://localhost:8080/web02/ms5  一般用于外部资源的访问

不带协议的绝对路径的访问,  把协议和端口名省略：/web02/ms5  永远只能访问到本机的资源  一般用于内部资源的访问

**相对路径**

相对比较的是地址栏的地址

相对路径指的是我们访问的servlet访问路径和我们访问的html资源的一个相对关系

![servlet的相对与绝对路径](JavaWeb%E6%A0%B8%E5%BF%83_assets/servlet的相对与绝对路径.png)

## ServletContext对象

servlet的上下文对象(全局管理者)

ServletContext中，要放必须的、重要的、所有用户需要共享的线程又是安全的一些信息

一个web项目只有一个全局管理者(myServlet01和myServlet02使用的是一个ServletContext

![image-20200805231508891](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200805231508891.png)

创建：只要tomcat服务器一启动，就会为部署在它上面的项目创建一个对象的全局管理者---ServletContext

销毁：只要tomcat服务器一关闭，该全局管理者---ServletContext就销毁了

### ServletContext作用

1. 可以作为容器, 在多个servlet之间共享数据
2. 可以获取项目的地址和项目资源流(进行IO读写)

### ServletContext API

**存取删数据API**

```
setAttribute(String key Object vlue)  存     特点：可以存多对 但是存在key值覆盖

Object getAttribute(String key)   取         特点： 如果没取到返回null       

removeAttribute(String key)  删 		
```

ServletContext本质上是一个Map集合

**读取项目资源API**

```
getRealPath(String path)    场景：上传必用的   得几天才能看到效果
	获取WEB项目的磁盘路径
	
getResourceAsStream(String path)   场景：下载必用的   今天演示
	根据WEB项目的磁盘资源获取流

getInitParameter(String name)   场景：框架要用的  只能学完框架
  	获取web.xml中<context>标签的参数内容 
```

```java
ServletContext servletContext = getServletContext();
//字符串用于拼接路径
String path = servletContext.getRealPath("/html");
System.out.println(path);
```

## Response

浏览器一次请求创建一个request, 一个response对象, 两次请求是两个不同的对象, 一次请求结束后对象即销毁

response对象是服务器用来给浏览器写内容

服务器有数据如果想给浏览器: 只能按照http协议的规定

### 操做响应行

`HTTP/1.1  200`

API方法

```
setStatus(int sc)
设置为响应的状态代码(一般用来设置 1XX 2XX 3XX)
sendError(int sc)
设置响应的状态码(一般用来设置 4xx 5xx)
```

### 操作响应头

格式: `key:value`

API方法

```
setHeader(String key,String value)
设置键值对的响应头
```

需要了解的响应头

1. `content-type`

   通知浏览器响应的内容是什么类型的, 并且用什么编码解析

   ```java
   response.setHeader("content-type","文件的类型;charset=uft-8");
   //简写
   response.setContentType("文件的类型;charset=uft-8");
   ```

   比如

   ```java
   //response.setHeader("content-type","text/html;charset=utf-8"); 注意格式,后面那个是text/html,而且后面那个引号里面是分号
   //注意一定要写在write方法之前
   response.setContentType("text/html;charset=utf-8");
   
   response.getWrite().print("中国心");
   ```

2. `location`

   重定向

   ```java
   //原始方式
   response.setStatus(302);
   response.setHeader("location","/name/demo3");
   //简写
   response.sendRedirect("/name/demo3");//重定向(redirect)
   ```

3. `refresh`

   定时刷新(不如js版本)

   ```java
   response.setContentType("text/html;charset=utf-8");
   response.getWriter().print("浏览器将在五秒后跳转百度...");
   
   response.setHeader("refresh","5;http://wwww.baidu.com");
   ```

4. `content-disposition`

   通知浏览器写回去的东西要以附件的形式打开(只用于下载)

   ```java
   response.setHeader("content-disposition","attachment;filename="+aaa.jpg);
   ```

### 操作响应体

API

`PrintWriter getWriter()`字符流

`ServletOutputSream getOutputStream()`字节流

注意:

1. 若是能写出来的内容就用字符流, 其他全用字节流
2. 不能同时出现, 只会输出第一个, 有的开发工具会直接报错
3. 服务器会自动帮我们关闭这2个流, 不用自己关闭

## 案例一: 下载文件

![image-20200807004152733](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200807004152733.png)

```java
public class DownloadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //接收下载的名字
        String fileName = request.getParameter("fileName");
        //获取web项目的磁盘路径
        ServletContext servletContext = getServletContext();
        //获取输入字节流
        InputStream inputStream = servletContext.getResourceAsStream("/download/"+fileName);//记住这里路径不要加name
        //获取输出字节流
        ServletOutputStream outputStream = response.getOutputStream();
        //定义下载方式
        response.setHeader("content-disposition","attachment;filename="+fileName);
        //来回copy
        byte[] arr = new byte[1024];
        int len = 0;
        while ((len = inputStream.read(arr))!=-1){
            outputStream.write(arr,0,len);
        }

        //IOUtils.copy(inputStream,outputStream);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

文件名中文乱码

 加上这句话

```java
response.setContentType("text/html;charset=utf-8");
```

## 案例二: 验证码

```java
package com.itheima.web;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.util.Random;

public class VerifyServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 使用java图形界面技术绘制一张图片

        int charNum = 4;
        int width = 20 * 4;
        int height = 28;

        // 1. 创建一张内存图片
        BufferedImage bufferedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);

        // 2.获得绘图对象
        Graphics graphics = bufferedImage.getGraphics();

        // 3、绘制背景颜色
        graphics.setColor(Color.YELLOW);
        graphics.fillRect(0, 0, width, height);

        // 4、绘制图片边框
        graphics.setColor(Color.GRAY);
        graphics.drawRect(0, 0, width - 1, height - 1);

        // 5、设置字体颜色和属性
        graphics.setColor(Color.RED);
        graphics.setFont(new Font("宋体", Font.BOLD, 22));

        // 随机输出4个字符
        String s = "ABCDEFGHGKLMNPQRSTUVWXYZ23456789";
        Random random = new Random();

        // session中要用到
        String msg = "";

        int x = 5;
        for (int i = 0; i < charNum; i++) {
            int index = random.nextInt(32);
            String content = String.valueOf(s.charAt(index));

            msg += content;
            graphics.setColor(new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255)));
            graphics.drawString(content, x, 22);
            x += 20;
        }

        // 6、绘制干扰线
        graphics.setColor(Color.GRAY);
        for (int i = 0; i < 5; i++) {
            int x1 = random.nextInt(width);
            int x2 = random.nextInt(width);

            int y1 = random.nextInt(height);
            int y2 = random.nextInt(height);
            graphics.drawLine(x1, y1, x2, y2);
        }

        // 释放资源
        graphics.dispose();

        // 图片输出 ImageIO
        ImageIO.write(bufferedImage, "jpg", response.getOutputStream());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

```js
<script>
    window.onload=function () {
    var elem = document.getElementById("JavaWeb%E6%A0%B8%E5%BF%83_assets");
    elem.onclick = function () {
        this.src="/name/verify?time="+new Date();
    }
}
</script>

<JavaWeb%E6%A0%B8%E5%BF%83_assets src="/name/verify" id="JavaWeb%E6%A0%B8%E5%BF%83_assets">
```

## Request

![image-20200807113009584](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200807113009584.png)

### 操作请求行

```java
System.out.println("请求方式为 "+request.getMethod());
System.out.println("访问的URI "+request.getRequestURI());
System.out.println("访问的URL "+request.getRequestURL());
System.out.println("访问的端口号 "+request.getLocalPort());
System.out.println("访问的http协议版本为 "+request.getProtocol());
//使用localhost访问本机得到的ip地址为: 0:0:0:0:0:0:0:1 ipv6的本机表现形式
//使用127.0.0.1访问得到的ip地址为; 127.0.0.1 ipv4的本机
//应用场景为投票系统
System.out.println("访问的IP地址为 "+request.getRemoteAddr());
//以后的重定向不要写死, 用下面的方式
System.out.println("当前项目的路径为 "+request.getContextPath());

/*
请求方式为 GET
访问的URI /name/demo01
访问的URL http://localhost:8080/name/demo01
访问的端口号 8080
访问的http协议版本为 HTTP/1.1
访问的IP地址为 0:0:0:0:0:0:0:1
当前项目的路径为 /name
*/
```

###  操作请求头

```
getHeader(String key) 根据请求头的key获取value

Referer可以获取到来源地址, 用于防盗链
User-Agent可以获取用户的浏览器版本信息, 下载必备

Enumeration getHeaderNames() 返回此请求头的名称
```



### 操作请求体

```
String  getParameter("name的属性名")  获取单一name对应的value值

String[]  getParameterValues("name的属性值")  获取多个name对应的多个value值

Map<String,String[]>  getParameterMap() 获取页面所有的value值
		注意：key:对应的是表单中name属性名    value对应的的是表单的name属性的value值
```

#### 乱码问题

在提交表单的过程中, 如果有中文get提交方式是没有问题的, 但是火狐浏览器post提交就会出问题

![image-20200809133309130](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200809133309130.png)

浏览器和服务器交互发生乱码的原因:

1. 浏览器获取中文数据, 然后进行utf-8编码, 然后将utf-8编码给了服务器

2. web服务器会对接收到的数据进行解码

   用的是ISO8859-1解码方式, 所有就导致了乱码

3. 处理方案

   - 修改tomcat底层, 让tomcat用UTF-8码自动解码
   - 通过代码的形式告诉tomcat, 让tomcat用utf-8自动解码

```
request.setCharacterEncoding("utf-8");
```

乱码问题, 一般加上, 这两行

```
//解决请求中文乱码
request.setCharacterEncoding("utf-8");
//解决响应中文乱码
response.setContentType("text/html;charset=utf-8")
```

Mac版get提交方式也会出现问题

原因跟上面一样

浏览器编码采用的是UTF-8，但是tomcat解码采用的是ISO8859-1

~~~
String username = new String(request.getParameter("username").getBytes("ISO-8859-1"),"utf-8");
System.out.println(username);
response.getWriter().print("收到了~");
~~~

或者编码后再发送，接到后再转码

因为get请求的参数在请求行上,我们不能像解决post请求那样使用 request.setCharacterEncoding("UTF-8");这种方式是修改方法体的编码方式

~~~
来自页面的一个get请求：
window.location.href = getContextPath()+"/manage/user/detail?name="+encodeURI(encodeURI("小明"));

服务器端：
String name = request.getParameter("name");
orgname = URLDecoder.decode(name,"UTF-8");
~~~



### Request作为容器

作为容器数据存取删的方法

```
void setAttribute(String name, Object o) 存储数据
Object getAttribute(String name) 获取数据
void removeAttribute(String name) 移除数据
```

当我们用浏览器想要使用一个request, 访问两个不同的servlet的时候, 可以用Request作为容器

使用的是请求转发的方式

```java
request.getRequestDispatcher("/servlet的地址").forward(request,response);
```

**注意, 只需要当前项目下的资源名即可**

```
request.getRequestDispatcher("/demo03").forward(request,response);
```

#### 重定向和请求转发的区别

1. 重定向多次请求, 请求转发一个请求
2. 重定向是浏览器发送访问, 请求转发是服务器内部资源相互访问
3. 重定向是response对象的API, 请求转发是request对象的API
4. 重定向访问自己的项目也可以访问别的项目, 请求转发只能访问自己的项目



## BeanUtils工具包的使用

在开发的过程中, 我们经常会有需求将map的数据转给对象属性, 如果自己来做转换实现的话过于麻烦, 我们可以借助第三方的工具, 操作简单方便

```
//使用API 
BeanUtils.populate(对象,map)
```

```java
request.setCharacterEncoding("utf-8");
Map<String, String[]> parameterMap = request.getParameterMap();
Set<String> nameSet = parameterMap.keySet();
for (String name : nameSet) {
    String[] values = parameterMap.get(name);
    for (String value : values) {
        System.out.println(name+" "+value);
    }
}

User user = new User();
try {
    BeanUtils.populate(user,parameterMap);
} catch (IllegalAccessException e) {
    e.printStackTrace();
} catch (InvocationTargetException e) {
    e.printStackTrace();
}
System.out.println(user);
```

# 会话技术

会话(session)技术的作用, 是用来储存会话过程, 浏览器和服务器交互产生的N多数据的

打开浏览器意味着会话开始了, 关闭浏览器意味着会话结束了

## cookie

客户端的会话技术

1. 服务器如何创建cookie

   ```
   Cookie cookie=new Cookie(String,String); 
   //Cookie 只能存字符串
   ```

2. 服务器如何把cookie传递给客户端

   ```
   response.addCookie(cookie); 
   ```

   - 创建一个cookie
   - 给浏览器响应cookie

   ```java
   Cookie cookie1=new Cookie("A1","AAAAA");
   response.addCookie(cookie1);
   ```

   注意:

   - cookie中不能出现特殊符号 例如：空格 分号 逗号 
   - cookie存入的数据有大小限制 4kb 

3. 服务器端如何获取到浏览器传递的cookie信息

   ```
   Cookie[] request.getCookies();
   ```

   然后可以对Cookie[ ] 进行遍历,

   ```
   getName();   返回值String，返回的是cookie的key
   getValue();  返回值String，返回的是cookie的value
   ```

   用到这两个方法

   ```java
   Cookie[] cookies = request.getCookies();
   for (Cookie cookie : cookies) {
       System.out.println(cookie.getName()+":"+cookie.getValue());
   }
   ```

4. cookie的生命周期

   - 会话级别的cookie

     浏览器关闭当前会话会默认把保存的cookie全部销毁

   - 持久化级别的cookie

     ```java
     Cookie cookie = new Cookie("msg", "abcd/1234");
     cookie.setMaxAge(60*60*24*7);
     response.addCookie(cookie);
     ```

5. cookie的有效路径

   为当前cookie设置有效路径（告诉浏览器在访问哪些资源的时候，才携带当前创建的这个cookie）

   ```
   setPath("路径")
   /day10/cs5   只在访问/day10/cs5资源才带
   /day10      访问整个day10项目下的资源都带（企业）
   /	         访问整个服务器上的项目资源都带	
   默认	       当前servlet访问路径的上一级
   			访问到当前servlet的上一级路径才带
   			例如：Servlet: /demo/sd1==访问/demo下的资源才携带	
   ```

   ```java
   Cookie cookie = new Cookie("AAAAA", "aaaaa");
   cookie.setPath("/web05/sd5");   指定资源下有效
   cookie.setPath("/web05"); 
   //request.getContextPath() ---"/web05"   企业开发版本  在当前项目下有效
   cookie.setPath("/");  //tomcat上部署的N个项目有效
   // 通过响应头写回给浏览器保存
   response.addCookie(cookie);
   ```

### 案例:  记录用户最新访问时间

```java
@WebServlet(name = "LastTimeServlet",urlPatterns = "/lastTime")
public class LastTimeServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

            //处理响应的中文乱码
            response.setContentType("text/html;charset=utf-8");

            //  获取用户访问的最新时间
            Date date = new Date();
            SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String dateValue = format.format(date);
                 //对时间的特殊符号进行编码
            dateValue=URLEncoder.encode(dateValue,"utf-8");
            // 将最新时间放入cookie中
           Cookie cookie = new Cookie("time",dateValue); //当前编码后的时间
                //指定cookie的有效路径
           cookie.setPath(request.getContextPath()); //当前项目下都有效果
                //设置cookie的有效时间
           cookie.setMaxAge(60*60*24);

           // 将cookie响应给访问者的浏览器保存
           response.addCookie(cookie);

            // 获取用户有没有传递cookie
                        //没有：代表第一次访问
                        //有：输出时间
            Cookie[] cookies = request.getCookies();
            //A1 A2  A3
            if(cookies!=null){
                for (Cookie ck : cookies) {

                    if("time".equals(ck.getName())){
                        String value = ck.getValue();
                        value=URLDecoder.decode(value,"utf-8");
                        response.getWriter().print("该用户的上次访问时间是："+value);
                        return;
                    }
                }
            }

            response.getWriter().print("该用户是第一次访问");

    }
```

## session

服务器端的会话技术

特点:

1. 保存在session中的数据在服务器端。由服务器创建的
2. session其实就是一个域对象  xxxAttribute()存储数据的方法(域对象怎么用, 这个就怎么用)

session获取

```
request.getSession()
```

**getSession()发生了什么**

当程序执行到request.getSession方法的时候, 首先会判断用户的浏览器是否携带了jsessionid

用户浏览器没携带,

tomcat会在服务器上开启一块空间, 这块空间就是session, 用来存入数据, 然后会创建一个cookie 将这块空间的地址记录给cookie(key:JSESSIONID)

![image-20200811093323877](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200811093323877.png)

然后将这个cookie写回给了浏览者的浏览器(会话级别)

用户浏览器携带了,

tomcat就不会再去开启空间, 创建session , 而是根据浏览器带来的jsessionid找到session地址, 从该session取出数据

所以当你使用setSession()之后, session不会为null, 但是, cookie第一次访问可以为null

```
setAttribute(String name, Object value) 

getAttribute(String name) 
```

session的作用范围

**在一次会话中, 多个sevlet中涉及的多个servlet获取到的session是同一个session**

![image-20200811105908875](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200811105908875.png)

因为当你创建这个session的时候, 服务器返回了一个cookie, 这个cookie的作用范围是这个项目, 所以下次浏览器再访问这个项目的另一个servlet的时候, 浏览器就会把这个cookie发送给服务器, 服务器会按照地址找到这个session

根本原因: cookie默认是会话级别的

**cookie和session的区别**

1. 储存位置, session存储在服务器, cookie存储在客户端
2. 储存大小, session对储存的大小没有限制, cookie只能存储4kb的内容
3. 安全性, session存储的数据安全, cookie存储的数据不安全

**session的销毁**

被动销毁, 默认当前session30分钟不使用会被销毁

主动销毁,  session.invalidate()

服务器关闭了, 再开启, 还会在, 因为session在服务器关闭的时候, session会序列化到磁盘上, 再次开启, session又会回到服务器, 同时浏览器里面有id

购物车数据存在session中30分钟后会被销毁,  后期会使用redis

### 案例: 购物车

核心: 购物车数据就是一个map, key是cart, value是这个map

```java
package com.itheima.web;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class ServletCart extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");
        //先接收选了哪一个
        String name = request.getParameter("name");
        HttpSession session = request.getSession();
        Map<String,Integer> cart  = (Map)session.getAttribute("cart");
        //判断是否有购物车
        if(cart==null){
            //写回一个购物车
            cart = new HashMap();
            cart.put(name,1);
        }else{
            //有购物车
            Integer count = cart.get(name);
            if(count!=null){
                count++;
            }else {
                count=1;
            }
            cart.put(name,count);
        }
        session.setAttribute("cart",cart);

        response.getWriter().print("添加成功, <a href='/name04/woman.html'>继续</a>");

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

```java
package com.itheima.web;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;
import java.util.Set;

public class ServletShowCart extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=utf-8");// 获取session
        HttpSession session = request.getSession();
        // 如果没有, 那么显示您的购物车为空, 继续添加
        Map<String,Integer> cart  = (Map)session.getAttribute("cart");
        //判断是否有购物车
        if(cart==null){
            //返回添加
            response.getWriter().print("购物车里面什么都没有, <a href='/name04/woman.html'>返回继续添加</a>");
        }else{
            Set<String> names = cart.keySet();
            response.getWriter().print("您已选的服务有: ");
            for (String name : names) {
                response.getWriter().print(name+" "+cart.get(name)+"夜 ");
            }
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}

```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>alibaba</title>
    <style>
        div{
            width: 500px;
            height: 400px;
            position: absolute;
            left: 40%;
            top: 20%;

        }
        table{
            width: 500px;
            height: 300px;
            border: 1px black solid;
            text-align: left;
        }
    </style>
</head>
<body>

<div>
    <table border="1px" cellspacing="0px">
        <tr>
            <th>&nbsp;服务名称</th>
            <th>&nbsp;操作</th>
        </tr>
        <tr>

            <td>&nbsp;佟丽娅</td>
            <td>&nbsp;<a href="/name04/cart?name=佟丽娅">睡觉</a></td>
        </tr>
        <tr>

            <td>&nbsp;梁缘</td>
            <td>&nbsp;<a href="/name04/cart?name=梁缘">睡觉</a></td>
        </tr>
        <tr>
            <td>&nbsp;一只蘑菇酱</td>
            <td>&nbsp;<a href="/name04/cart?name=一只蘑菇酱">睡觉</a></td>
        </tr>
        <tr>
            <td>&nbsp;柳岩</td>
            <td>&nbsp;<a href="/name04/cart?name=柳岩">睡觉</a></td>
        </tr>
    </table>
    <br/>
    <hr/>
    <a href="/name04/showcart">查看服务</a>
</div>
</body>
</html>
```

## cookie/session总结

```
1. 当你浏览器正常访问一个servlet的时候
由于没有任何cookie，所以也不会携带任何cookie，所以servlet也不会收到任何cookie
2. 当你demo1servlet给客户端发送了一个cookie，那么这个浏览器就会接收到这个cookie，关于这个cookie存活多长时间，默认情况下是会话级别，关闭浏览器之后便会消失，你也可以设置时间将其持久化
cookie.setMaxAge(int 秒)
3. 关于有效路径
关于默认有效路径（测试失败）
这个失败是因为我对虚拟路径理解的巨大错误，虚拟路径而不是别名，虚拟路径跟事实的包没有区别
cookie的默认路径为当前servlet访问路径的上一级
访问到当前servlet的上一级路径才带
例如：Servlet: /demo/sd1==访问/demo下的资源才携带	
注意并不是整个项目的文件目录
4. getSession()发生了什么
当你的浏览器使用了request.getSession()，首先会判断浏览器携带的是否有jsessionid，如果没有，那么服务器就会创建一个Session对象，同时会给浏览器发送一个独一无二的jsessionid，下次再次使用request.getSession()方法的时候，就会根据这个jsessionid去寻找对应的session
5. session的作用范围
你要是访问其他项目，还能得到原来项目的session吗，原理还是上面的request.getSession()，你浏览器访问其他模块的时候，由于不是有效路径，jsessionid这个cookie不会携带过去，所以执行的是没有jsessionid这个流程，会创建一个新的session，包括其他浏览器访问也是相同的道理，主要取决于cookie的有效访问路径和生命周期，可以说只要访问在cookie的一个有效路径下的servlet，那么这个servlet获取的都是一个session
6. session的生命周期
session的销毁，默认情况下session30分钟不使用就会被销毁，也就是说你最后加入了一个购物车，30分钟没动，购物车就没了
浏览器关闭了，服务器关闭了，session还在吗？
当浏览器关闭的时候，你的默认会话级别的cookie没有了，jsessionid就没有了，相当于用来取钱的银行卡没有了，原来的session找不到了，但是不意味着session被销毁了
服务器关闭，session会序列化到硬盘上，再次开启服务器还是会加载到服务器，所以在jsessionid还存在的情况下是还是可以获取到原来的sessionid（测试失败）  
原因，我们的本机服务器跟上述服务器有差别，无法还原上述情况
```

# 域对象总结

java后台的域对象有三个, servletContext, requst, session

|          | servletContext                                               | session                                                      | requst                                                       | cookie                                                       |
| :------- | :----------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 创建     | 服务器只要启动就创建,而且一个项目下只能创建一个，属于servlet里面的方法 | Java认为当浏览器首次执行到了                                 | 请求一次就创建一次                                           | 自己new 一个cookie然后通过response.add方法传入               |
| 销毁     | 服务器只要关闭就销毁                                         | 1. 被动销毁(默认30分钟不使用就销毁) 2. 主动销毁 3. 服务器正常关闭不会销毁, 会序列化到硬盘上, 服务器非正常关闭, session会销毁 | 响应即销毁                                                   | 1. 会话级别: 关闭浏会话(浏览器) 2. 持久级别, 可以通过自己设置时间cookie.setMaxAge(int); |
| 作用范围 | 整个项目的sevlet都共享                                       | 在一次会话中, 多个sevlet可以共享数据, 因为一次会话中多个sevlet获取的session都是同一个 | 一次请求转发中的涉及到的多个servlet使用的是一个request       | 可以为cookie设置有效路径, 1.   默认的, 是访问当前项目的按上级目录下面的文件的时候, 会发送cookie2. 整个服务器 3. 整个项目的多个servlet(企业) |
| 存数据   | setAttribute(String key Object vlue)                         | setAttribute(String name, Object value)                      | setAttribute(String name, Object o)                          | response.addCookie(cookie);                                  |
| 取数据   | Object getAttribute(String key)                              | getAttribute(String name)                                    | getAttribute(String name)                                    | Cookie[] request.getCookies();                               |
| 获取     | GenericServlet.getServletContext()，req.getSession().getServletContext()，this.getServletConfig().getServletContext(); | request.getSession()                                         | request.getRequestDispatcher("/servlet的地址").forward(request,response) 转移即可 | Cookie cookie=new Cookie(String,String);                     |
| 注意     |                                                              |                                                              | Object里面可以存储Map类型的                                  | 1. cookie里面只能存String类型的 2. 不要出现空格, 中文, 会出现乱码 3. 最大只能存储4kb |

# JSP

jsp全称Java Server Pages, Java服务器页面, JSP是一种基于文本的程序, 其特点就是HTML和Java代码共同存在, 他出现的原因就是Servlet输出HTML非常困难, JSP就是代替Servlet输出HTML的, JSP本身就是一种Servlet, JSP在第一次被访问的时候, 会被编译为HttpJspPage类, 是HttpServlet的一个子类

## jsp简介

### jsp的执行原理

![image-20200812104241101](JavaWeb%E6%A0%B8%E5%BF%83_assets/image-20200812104241101.png)

1. 根据请求的页面去当前项目下找到指定的jsp

2. 找到对应的jsp文件后, 会将jsp文件编译成java文件, 并调用编译器编译生成class文件, 最终放在work目录下(idea的虚拟路径的work->Catalina->localhost目录下 **访问的时候才会编译**)

3. 编译后的class文件会被服务器当作Servlet执行, 并生成动态内容, 将动态的内容返回给服务器

4. 服务器拿到生成的内容, 组装成响应信息, 返回给浏览器, 浏览器收到响应, 展示内容

   (jsp本质上是一个Servlet)

### jsp的注释

```
<%-- jsp注释 --%>
(ctrl+shift+/即可)
```

###  jsp的脚本语法

1. 脚本片段

   ```
   <% %> ：java程序片段
   ```

   ```jsp
   <%@ page contentType="text/html;charset=UTF-8" language="java" %>
   <html>
       <head>
           <title>书写java代码的三种方式</title>
       </head>
       <body>
           <%-- 脚本片段 --%>
           <% for(int j = 0 ; j < 5 ;j++){%>
           	Hello World!!!<br>
           <%}%>
       </body>
   </html>
   
   <%--这段代码将在页面输出5次 HelloWorld!!! --%>
   ```

2. 脚本声明

   当我们需要在当前jsp中定义一些成员方法或者变量的时候，就需要一个新的技术，脚本声明

   ```
   <%!  书写Java代码  %>
   
   <%! int i = 0; %> 
   <%! int a, b, c; %> 
   <%! Circle a = new Circle(2.0); %> 
   ```

3. 脚本表达式

   ```
   <%= %> : 页面输出表达式
   里面的内容会直接输出,相当于直接在引号里面写 
   out.print("XXX");
   ```

   

### jsp的指令配置

一共有三种配置指令, 可以出现多次, 可以出现在任意地方

#### page指令

给当前jsp页面声明一些属性

```
格式: <%@page 属性名1=属性值1 属性名2=属性值2 属性名3=属性值3 %>
language：当前页面支持的语言 固定只支持java
contentType：底层response.setContentType("text/html;charset=utf-8"); 解决输出中文乱码问题
pageEncoding：当前jsp页面支持不支持写中文
contentType和pageEncoding之间有一些联系：
							如果2个都出现，各自使用各自的
							如果2个只出现一个,另一个就是用出现的那一个
							如果2个都不出现，使用iso-8859-1
import：导包 快捷键：alt+回车
errorPage:当前页面发生了错误，要跳转的地址

isErrorPage:默认是false true:代表当前页面是错误页面
				好处：可以获取错误信息 条件：必须使用内置对象（exception）
					exception：要想被使用，当前必须是错误页面

session:支持不支持当前的jsp页面使用session这个内置对象
			默认是true 支持   false:不支持
```

```
<%--指定当前页面为错误页面, 就可以使用exception对象的getMessage()方法来获取错误信息--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>

<%=exception.getMessage() %>
```

#### include指令

```
静态包含
作用：用来包含其它jsp页面内容的,将被包含页面的内容全都整合到一个页面中
特点：最终只编译生成一个文件  xxx.class
```

#### taglib指令

```
作用：引入外部jsp不支持的各种标签  引入之后就可以在jsp中使用该标签了
```

**JSP**

```jsp
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: 1
  Date: 2020-08-11
  Time: 19:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--错误的时候要跳转的页面--%>
<%@ page errorPage="demo01.html" %>
<html>
<head>
    <title>Title</title>
</head>

<body>
<%--JSP的注释--%>
<%
    for (int i = 0; i < 10; i++) {
        System.out.println(i);
    }
    response.getWriter().print(1234);
    /*页面会跳转到demo01*/
    /*int a= 1/0;*/
%>

<%
    /*在底层可以这样获取session*/
    request.getSession().setAttribute("mes","abcd");
    /*也可以利用内置对象session*/
    /*几大内置对象*/
    session.setAttribute("mes","abcd");
    request.setAttribute("mes","abcd");
    response.getWriter().print(1111);
    application.setAttribute("mes","abcd");
    out.print("111");

    String[] arr = {"aaa","bbb","ccc","ddd"};
    session.setAttribute("mesArr",arr);

    ArrayList list = new ArrayList();
    list.add("AAA");
    list.add("BBB");
    list.add("CCC");
    list.add("DDD");
    session.setAttribute("list",list);

    HashMap map = new HashMap();
    map.put("key1","aaa");
    map.put("key2","bbb");
    map.put("key3","ccc");
    application.setAttribute("map",map);

    
%>

获取域对象<br>
获取requeset域对象中的简单数据<br>
老方式jsp脚本: <%=request.getAttribute("mes")%><br>
el获取request域中数据的方式: ${requestScope.mes}<br>
el获取session域中数据的方式: ${sessionScope.mes}<br>
el获取application域中数据的方式: ${applicationScope.mes}<br>


获取域对象中的复杂数据<br/>
获取session中的数组: ${sessionScope.mesArr[2]}<br>
获取session中的集合: ${sessionScope.list}<br>
获取session中的集合: ${sessionScope.list[2]}<br>
获取application中的映射: ${applicationScope.map}<br>
获取application中的映射: ${applicationScope.map.key2}<br>


<%--
请求转发
<%
    request.setAttribute("mes","abcd");
    /*request.getRequestDispatcher("/demo02.jsp").forward(request,response);*/
%>

&lt;%&ndash;请求转发的动作标签&ndash;%&gt;
<jsp:forward page="demo02.jsp"></jsp:forward>
--%>

<%=
    12323123
%>

<%!
    private String msg="abcd";
%>

<table>
    <tr>
        <td>1.1</td>
        <td>1.2</td>
    </tr>



    <tr>
        <td>2.1</td>
        <td>2.2</td>
    </tr>
</table>
</body>
</html>

```

```java
/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.5.57
 * Generated at: 2020-08-12 10:29:12 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.sun.xml.internal.ws.api.model.wsdl.WSDLOutput;

public final class demo01_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {


    private String msg="abcd";

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = new java.util.HashSet<>();
    _jspx_imports_classes.add("com.sun.xml.internal.ws.api.model.wsdl.WSDLOutput");
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    final java.lang.String _jspx_method = request.getMethod();
    if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSP 只允许 GET、POST 或 HEAD。Jasper 还允许 OPTIONS");
      return;
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			"demo01.html", true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<html>\r\n");
      out.write("<head>\r\n");
      out.write("    <title>Title</title>\r\n");
      out.write("</head>\r\n");
      out.write("\r\n");
      out.write("<body>\r\n");
      out.write('\r');
      out.write('\n');

    for (int i = 0; i < 10; i++) {
        System.out.println(i);
    }
    response.getWriter().print(1234);
    /*页面会跳转到demo01*/
    /*int a= 1/0;*/

      out.write("\r\n");
      out.write("\r\n");

    /*在底层可以这样获取session*/
    request.getSession().setAttribute("mes","abcd");
    /*也可以利用内置对象session*/
    /*几大内置对象*/
    session.setAttribute("mes","abcd");
    response.getWriter().print(1111);
    application.setAttribute("mes","abcd");
    out.print("aaa");


      out.write("\r\n");
      out.write("\r\n");
      out.print(
    12323123
);
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("<table>\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>1.1</td>\r\n");
      out.write("        <td>1.2</td>\r\n");
      out.write("    </tr>\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("\r\n");
      out.write("    <tr>\r\n");
      out.write("        <td>2.1</td>\r\n");
      out.write("        <td>2.2</td>\r\n");
      out.write("    </tr>\r\n");
      out.write("</table>\r\n");
      out.write("</body>\r\n");
      out.write("</html>\r\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}

```



```jsp
<%--
  Created by IntelliJ IDEA.
  User: wujunnan
  Date: 2020-09-18
  Time: 16:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--contentType底层是respond.setcontentType("text/html,charset=UTF-8")--%>
<html>
<head>
    <title>demo</title>
</head>
<body>
<%--jsp书写代码的三种方式--%>
<%--
这种方式写的代码会编译到servlet的service方法里面
脚本片段可以分开书写，最终会被合成一个完整的Java片段
--%>
<%--脚本片段--%>
<%
    for (int i = 0; i < 5; i++) {
%>
helloword!!!<br/>
<%
    }
%>
<%--脚本声明--%>
<%!
    int a = 0;
%>
<%--脚本表达式--%>
<%--这个和直接写html有啥区别--%>
<%--这个相当于out.print(),这里面还可以写函数等，但是html里面不能写函数--%>
<p>
    今天的日期是：<%=(new java.util.Date()).toLocaleString()%>
    传智播客：<%="itcast"%>
</p>


</body>
</html>
```

mac的jsp对应的java文件的路径：

`/Users/wujunnan/Library/Caches/IntelliJIdea2019.1/tomcat/Tomcat_8_5_57_MyJavaWebDemo_3/work/Catalina/localhost/demo01/org/apache/jsp`

```java
/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.5.57
 * Generated at: 2020-09-18 09:48:59 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class demo_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

//<%!int a = 0;%>
    int a = 0;

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private volatile javax.el.ExpressionFactory _el_expressionfactory;
  private volatile org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public javax.el.ExpressionFactory _jsp_getExpressionFactory() {
    if (_el_expressionfactory == null) {
      synchronized (this) {
        if (_el_expressionfactory == null) {
          _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
        }
      }
    }
    return _el_expressionfactory;
  }

  public org.apache.tomcat.InstanceManager _jsp_getInstanceManager() {
    if (_jsp_instancemanager == null) {
      synchronized (this) {
        if (_jsp_instancemanager == null) {
          _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
        }
      }
    }
    return _jsp_instancemanager;
  }

  public void _jspInit() {
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
      throws java.io.IOException, javax.servlet.ServletException {

    final java.lang.String _jspx_method = request.getMethod();
    if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
      response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSP 只允许 GET、POST 或 HEAD。Jasper 还允许 OPTIONS");
      return;
    }

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');
      out.write('\n');
      out.write("\n");
      out.write("<html>\n");
      out.write("<head>\n");
      out.write("    <title>demo</title>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write('\n');
      out.write('\n');
      out.write('\n');

    for (int i = 0; i < 5; i++) {

      out.write("\n");
      out.write("helloword!!!<br/>\n");

    }

      out.write('\n');
      out.write('\n');
      out.write('\n');
      out.write('\n');
      out.write('\n');
      out.write("\n");
      out.write("<p>\n");
      out.write("    今天的日期是：");
      out.print((new java.util.Date()).toLocaleString());
      out.write("\n");
      out.write("    传智播客：");
      out.print("itcast");
      out.write("\n");
      out.write("</p>\n");
      out.write("\n");
      out.write("\n");
      out.write("</body>\n");
      out.write("</html>\n");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
```



###  jsp的内置对象

一访问jsp的时候，jsp就会生产出9个对象 无需我们创建，直接能够在jsp页面使用即可

```
(常用)
(类型)                      (对象)
HttpServletRequest	 		request （域对象）
HttpSession		     		session （域对象）
ServletContext	     		application （域对象）
JspWriter（jsp的输出流）      out
（页面输出语句对象,并不是使用的  PrintWriter（servlet的输出流） 
							----------------------------
HttpServletResponse	     	response
Object			     	    page 代表当前页面对象 和this作用一样
ServletConfig		        config （servlet的配置对象）
Throwable		            exception （异常对象 使用条件：必须当前页面的isErrorPage="true"才能用） 
PageContext		     	    pageContext （jsp特有的域对象）
```

pageContext：jsp的域对象 但不是servlet的域对象

```
作用：也可以用来存储数据，但存储的数据只在当前页面有效，还不如一个变量好使
1 可以获取其他八大内置对象（了解）

2 可以从别的作用域中查找数据（了解）
			findAttribute("key")
		     作用：依次从作用域范围最小的开始查找 一直到最大的,如果都找不到 返回null

3 pageContext可以操作其他作用域（了解）
			request.setAttribute("msg", "aaa");
			pageContext.setAttribute("msg", "aaa",PageContext.REQUEST_SCOPE);
			参数：
				PageContext.REQUEST_SCOPE	request域
				PageContext.SESSION_SCOPE	session域
				PageContext.PAGE_SCOPE		pageContext域
				PageContext.APPLICATION_SCOPE   ServletContext域
```

### jsp的动作标签

```
<jsp:forward page="..."></jsp:forward>  请求转发

<jsp:include page="...."></jsp:include> 动态包含  会把包含的所有页面都编译了 推荐使用静态包含
```

### el标签

通过el标签在jsp页面中获取Servlet3大域中的数据

#### el对域对象中简单数据的获取

```
${requestScope||sessionScope||applicationScope.属性名}

requestScope:是el标签提供的内置对象 不是request对象 唯一作用：可以获取request域中的数据

sessionScope:是el标签提供的内置对象 不是session对象 唯一作用：可以获取session域中的数据

applicationScope：是el标签提供的内置对象 不是ServletContext对象 唯一作用：可以获取ServletContext域中的数据
```

#### el对域对象中复杂数据获取

```
数组和list集合 ${requestScope||sessionScope||applicationScope.属性名[索引]}

map集合:${requestScope||sessionScope||applicationScope.属性名.map的key名}
```

#### el对域中对象属性值的获取

```
${requestScope||sessionScope||applicationScope.属性名.对象属性名}

或${requestScope||sessionScope||applicationScope.属性名[“对象属性名”]}
```

#### el的便捷方式

```
${属性名}
依次从最小的域中开始查找，找到了直接返回 找不到继续找下一个 如果都没有 返回的是空内容
域的范围大小:pageContext<request<session<application
缺点：
1 在使用el的便捷方式的过程中，尽量保证多个域的key名不同
2 如果域的键名有一些特殊的符号_,.,+等 el的便捷方式无法使用 只能使用xxxScope["特殊key名"]
```

**通过el标签获取标签名**

```
${pageContext.request.contextPath}
```

这个还是用了el标签获取域中值的作用，key就是`pageContext.request.contextPath`

#### 通过el标签做一些运算

```
运算符： + - * / && || > < 三元运算等
特点：
在el做+ - * / 运算 不论运算符的后面是什么类型,只要能运算动的全都做运算,不能运算动的 一律报错 
没有字符出相连拼接的概念
字符型和字符串型数字可以直接相加
包括三元表达式
```

```
<%
	request.setAttribute("a",10);
	request.setAttribute("b",20);
	request.setAttribute("c","30");
	request.setAttribute("d","d");
%>

${a+b}<br/> <%--30--%>
${b+c}<br/> <%--50--%>
${c+d}<br/> <%--报错--%>
```

empty

```
作用：可以判断一个容器的长度是否为0
      可以判断一个对象是否为null

容器（list/map集合）：
	    如果集合长度为0   true
	    如果集合长度不为0 false
对象(javabean):
	    如果对象为nulL   true
	    如果对象不为null false

取反值：！或 not
```

```
<%
	List list = new ArrayList();
	list.add("aa");
	list.add("bb");
	list.add("cc");
	request.setAttribute("list",list);
	
	List list2 = new ArrayList();
	request.setAttribute("list2",list);
%>

${empty list}<%--判断list是否为空--%>
${empty list2}

${!empty list}<%--取反--%>
${not empty list2} 
```

### jstl（c）标签

jstl标签不是jsp的内置标签, 如果想要在jsp中使用这个标签, 需要先在当前的jsp中, 引入该标签库

####  jstl标签的安装

1. 导2个jar包

   ```
   javax.servlet.jsp.jstl.jar
   jstl-impl.jar
   ```

2. 在哪个jsp页面使用jstl标签，就需要在当前的jsp中通过jsp的指令tagLib引入

   固定的`<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>`

   jstl有很多个字库，我们使用的是它的核心库core

   

if判断

```
格式：<c:if test="" var="" scope=""></c:if>
test: 要判断的内容  离不开el的   例如：${1>0}
var:  判断的结果值（true false） 例如： i=true
scope: 可以将值放入指定的域中    例如：request  session .. 默认不写

<c:if test="${1>0}" scope="request" var="i">
大于的话结果为: ${i}
</c:if>
```

foreach循环

```
格式：
<c:forEach begin="开始" end="结束" step="循环的间隔数" var="每次循环的变量名" varStatus="记录循环状态">
	${变量名 }
</c:forEach>	
varStatus="记录循环状态"
count:计数当前第几个
first：判断是否是第一个
last：判断是否是最后一个

<c:forEach begin="1" end="10" var="i" step="2">
${i}
</c:forEach>
```

循环list

```
items:要遍历的数组/list集合/map集合
var:每次遍历的值
varStatus:记录循环状态的
可以记录当前循环的是第几个 ${vs.count}
可以判断当前循环的是否是第一个 ${vs.first}
可以判断当前循环的是否是最后一个 ${vs.last}
```

循环map:

```
${m.key} --->${m.value.username}--->${m.value.password
获取key(String)  获取对象 和对应的属性
```

```
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.itheoma.web.User" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: 1
  Date: 2020-08-13
  Time: 11:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>做运算</title>
</head>
<body>
    <%
        request.setAttribute("a",10);
        request.setAttribute("b",20);
        request.setAttribute("c","30");
        request.setAttribute("d","d");

        List<User> list = new ArrayList<>();
        HashMap<String,User> map = new HashMap<>();
        User user1 = new User();
        user1.setName("jack");
        user1.setPassword("111");

        User user2 = new User();
        user2.setName("rose");
        user2.setPassword("222");

        User user3 = new User();
        user3.setName("tom");
        user3.setPassword("333");

        list.add(user1);
        list.add(user2);
        list.add(user3);
        map.put("user1",user1);
        map.put("user2",user2);
        map.put("user3",user3);

        request.setAttribute("list",list);
        request.setAttribute("map",map);
    %>

    ${a+b}<br/> <%--30--%>
    ${b+c}<br/> <%--50--%>
   <%-- ${c+d}<br/> 报错--%>

    <c:if test="${1>0}" scope="request" var="i">
        大于的话结果为: ${i}
    </c:if>

    <c:forEach begin="1" end="10" var="i" step="2">
        ${i}<br/>
    </c:forEach>

    <c:forEach items="${list}" var="user" varStatus="vs">
        ${user.name}-->${user.password}-->${vs.count}-->${vs.last}<br/>
        <%--
        jack-->111-->1-->false
        rose-->222-->2-->false
        tom-->333-->3-->true
        --%>
    </c:forEach>

    <c:forEach items="${map}" varStatus="vs" var="user">
        ${user.key}-->${user.value.name}-->${user.value.password}<br/>
        <%--user1-->jack-->111
        user2-->rose-->222
        user3-->tom-->333--%>
    </c:forEach>
</body>
</html>

```

## 三层架构

三层架构就是把软件的系统分为三个层次：

1. 表现层(Presentation Layer)

   接收用户输入的数据和显示处理用户需要的数据

2. 业务逻辑层(Business Logic Lyer)

   从数据库中得到数据然后对数据进行逻辑处理

   一般写在service包中，包里面的类名以"Service"结尾，对数据访问层的方法进行组装

3. 数据访问层(Data access layer)

   对数据进行增删改查

   一般写在dao包中，包中的类名也都是以“Dao"结尾，负责增删改查

## MVC设计思想

MVC模式将项目划分为

1. 模型（Model）

   模型持有所有的数据，状态和程序逻辑，模型接收视图数据的请求，最后再转发请求

2. 视图（View）

   负责页面的展示，以及用户的交互功能

3. 控制器（Controller）

   对视图发来的请求，需要用哪一个模型来处理，以及处理完成后要跳回到哪一个视图

创建不同的包名

cn.itcast.web   servlet

cn.itcast.service  业务类

cn.itcast.dao 和数据库进行交互的

cn.itcast.domain 封装数据的实体

cn.itcast.utils 工具

dao: (Data Access Object)

## Filter过滤器

filter本质上也是一个类，这个类需要实现Java提供的filter规范，可以对浏览器访问服务器资源的时候进行拦截，可以让符合上述条件的放行，不符合条件的不放行

如何使用

1. xml配置文件的方式

   可以给自己使用，也可以给第三方提供的filter配置（重点）

2. 注解的方式

   ~~~
   在自定义的filter类上添加注解：
   @WebFilter(filterName = "MyFilter",urlPatterns = "/demo1")
   ~~~

   

### filter的执行顺序

1. 配置文件的方式，如果多个filter对同一资源进行了拦截，执行的顺序是配置文件从上到下顺序
2. 注解的方式，如果多个filter对同一资源进行了拦截， 执行的顺序是按照filter的文件名的自然顺序进行排序

### filter的执行流程

![Filter的执行流程](JavaWeb%E6%A0%B8%E5%BF%83_assets/Filter的执行流程.png)

浏览器访问demo01，先去web.xml里面去寻找有没有过滤器，会发现有两个过滤器，两个就按照配置的先后顺序进行执行，那么就先去第一个过滤器中执行，执行里面的语句，然后filterChain放行之后，就会去寻找其他过滤器，下个过滤器再执行语句，再遇到放行，结果没有下一个过滤器了，那么就执行要访问的servlet了，响应是默认放行的

filter的init方法是在项目启动的时候就会执行

### Filter的xml配置

Filter同样有三种配置路径的方式

1. 完全路径匹配

   以/开始，例如/aaa

   针对的是指定的某些资源做匹配，可以添加多个，对多个servlet进行拦截

2. 目录匹配

   以/开头，以*结尾

   针对的是整个项目的资源

3. 拓展名匹配

   不已/开始，以.结尾 

   例如：*.jpg

   针对某一类资源，只有访问图片filter才会执行

### Filter的拦截方式

默认情况是只拦截浏览器发送过来的请求，不拦截服务器内部的请求, 也就说filter只拦截重定向的内容，不拦截请求转发的内容

如果想要filter拦截服务器内部的请求，有两种方式

~~~
1. xml的方式配置:
在<filter-mapping>的标签中添加标签<dispatcher>FORWARD</dispather>
但这种配置将filter默认的拦截方式给覆盖了，只会连服务器内部的请求，不会再拦截默认的浏览器请求了
默认不写是：<dispatcher>REQUEST</dispatcher>的方式

如果想两个都拦截，那么可以将这两个都加上
<dispatcher>FORWARD</dispather>
<dispatcher>REQUEST</dispatcher>
企业的话基本就是只拦截浏览器的请求
2. 注解的方式配置
@WebFilter(dispatcherTypes = {DispatchType.REQUEST,DispatcherType.FORWARD})
该注释的配置方式，即会拦截浏览器过来的请求，又回拦截服务器内部的请求
~~~

### 案例：解决全站乱码

```Java
@WebFilter(filterName = "EnCodingFilter",urlPatterns = "/*")
public class EnCodingFilter implements Filter {
  public void destroy() {
  }

  public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
    // 在执行servlet获取数据和响应数据之前执行该代码
    req.setCharacterEncoding("utf-8");
    resp.setContentType("text/html;charset=utf-8");
    // 放行之前 处理中文乱码
    chain.doFilter(req, resp);
  }
```

### 案例：非法字符拦截

在src下新建一个properties

~~~
illegal=大傻逼,贱货,狗逼,脑瘫
~~~

**properties出现乱码**

注意是英文标点，如果idea读取properties出现乱码

![image-20200818201616526](JavaWeb%E6%A0%B8%E5%BF%83_assets/解决properties出现乱码.png)

勾选下图的设置，然后点击restart重新启动，或者尝试新建一个模块

装饰者

~~~java
public class ReqPro extends HttpServletRequestWrapper {
    //传入的需要重写的request，还有读取的list
    private List<String> list;
    public ReqPro(HttpServletRequest request, List<String> list) {
        super(request);
        this.list=list;
    }

    @Override
    public String getParameter(String name) {
        //调用原方法
        String value = super.getParameter(name);
        for (String s : list) {
                if(value.contains(s)){
                    value = value.replaceAll(s, "***");
                }
        }
        return value;
    }
}
~~~

filter

~~~java
@WebFilter(filterName = "FilterDemo",urlPatterns = "/demo")
public class FilterDemo implements Filter {
    List<String> list;
    public void destroy() {
    }

    public void init(FilterConfig config) throws ServletException {
        //读取已经存储的list
        ResourceBundle bundle = ResourceBundle.getBundle("illegal");
        String value = bundle.getString("illegal");
        String[] values = value.split(",");
        list = Arrays.asList(values);
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
      	//注意这里是分号，不是逗号
        
        resp.setContentType("text/html;charset=utf-8");
        HttpServletRequest request=(HttpServletRequest)req;
        ReqPro reqPro = new ReqPro(request,list);
        //可以重写request的getParameter,直接在方法里面完成判断和替
        String value = reqPro.getParameter("value");
        resp.getWriter().print(value);
        chain.doFilter(reqPro, resp);
    }
}
~~~

**装饰者模式**

这里用到了装饰者模式

HttpServletRequest是被装饰者，HttpServletRequestWrapper适配器是系统给定的装饰者，他需要你传入一个被装饰的对象引用，它里面会自动把这个被装饰者的其他所有方法都给用这个引用给重写了，你需要增强哪个方法，就重写那个方法，先`String value = super.getParameter(name);`调用原来的方法，再增强这个结果，然后你使用装饰者类创建对象

## Listener监听器

跟其他的一样，监听器本质上也是一个类，为了监听三大域对象的状态变化，即三个域对象的创建和销毁

我们使用这三种监听器

~~~
ServletContextListener(后期框架的配置文件在服务器启动的时候就要执行)
ServletRequestListener
HttpSessionListener
~~~

要想使用，就编写一个类，实现listener接口，然后去web.xml中配置

两种配置监听器的方法

1. web.xml

   ~~~
   <listener>
   			<listener-class>com.itheima.listener.SevletContextListenerDemo</listener-class>
   </listener>
   ~~~

2. 注解的方式

   ~~~
   @WebListener
   ~~~

### 对三个域对象的监听

1. ServletContextListener

   只要一点run，服务器就会监听到被创建，只要一点stop，就会被监听到销毁，所以servlet是在服务器启动的时候开启，在服务器关闭的时候销毁

   可以用来在服务器加载的时候，就读取框架的配置信息，进行加载

   ~~~java
   ServletContext servletContext = servletContextEvent.getServletContext();
   String value = servletContext.getInitParameter("spring");
   System.out.println("就可以正式根据获取到的配置文件名，对该文件的内容进行加载了："+value);
   System.out.println("正在加载该配置文件中....");
   ~~~

2. ServletRequest

   浏览器每次访问服务器就会创建request对象，服务器响应给浏览器的时候，就会把request对象销毁

   一个访问了请求转发的servlet的过程：

   ~~~
   request已经被建立
   已经访问到servlet1
   已经存入数据
   已经访问到servlet2
   收到的value数据是666
   request已经被销毁
   ~~~

3. Session

   session在一个会话访问的时候就会执行

   ~~~java
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     HttpSession session = request.getSession();
     //这里会创建session，一个会话访问一次就会产生一个session
     session.invalidate();
   }
   ~~~

   ~~~
   request已经被建立
   session已经建立
   session已经销毁
   request已经被销毁
   ~~~

### 案例：记录正在访问网页的人数

注意点：

1. 一个项目下多个servlet中获取的session是同一个，所以用户注销的时候，可以另外创建一个servlet来获取session来销毁

2. jsp底层就是一个servlet，所以访问jsp的时候，就会自动创建一个session

3. 还可以通过这种方式创建ServletContext

   `req.getSession().getServletContext();`

Listener

~~~java
@WebListener
public class ServletSessionListenerDemo implements HttpSessionListener {
    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        ServletContext servletContext = session.getServletContext();
        Integer num = (Integer)servletContext.getAttribute("num");
        if(num==null){
            num=1;
        }else{
            num++;
        }
        servletContext.setAttribute("num",num);

    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        HttpSession session = httpSessionEvent.getSession();
        ServletContext servletContext = session.getServletContext();
        Integer num = (Integer)servletContext.getAttribute("num");
        if(num!=null){
            servletContext.setAttribute("num",num-1);
        }
    }
}
~~~

JSP

~~~jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>正在访问的人数</title>
</head>
<body>
现在有${num}个人正在访问<br/>
<a href="/name/demo04">退出用户</a>
</body>
</html>
~~~

Servlet

~~~java
@WebServlet(name = "ServletDemo4",urlPatterns = "/demo04")
public class ServletDemo4 extends HttpServlet {
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    response.setContentType("text/html;charset=utf-8");
    HttpSession session = request.getSession();
    session.invalidate();
    response.getWriter().print("已经退出");
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    doPost(request,response);
  }
}
~~~

## 三层架构综合案例

使用三层架构实现查询用户，添加用户，删除用户，修改用户

建立所需要的包

**web包**

AddServlet

```java
@WebServlet(name = "AddServlet",urlPatterns = "/add")
public class AddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //接收表单提交的数据
        Map<String, String[]> valueMap = request.getParameterMap();
        //使用Beanutils进行封装
        User user = new User();
        try {
            //populate迁移
            BeanUtils.populate(user,valueMap);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        UserService userService = new UserService();
        userService.add(user);
        response.sendRedirect(request.getContextPath()+"/find");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

DeleteServlet

```java
@WebServlet(name = "DeleteServlet",urlPatterns = "/delete")
public class DeleteServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        UserService userService = new UserService();
        userService.delete(id);
        response.sendRedirect(request.getContextPath()+"/find");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

FindOneServlet

```java
@WebServlet(name = "FindOneServlet",urlPatterns = "/findone")
public class FindOneServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        UserService userService = new UserService();
        User user = userService.findOne(id);
        request.setAttribute("user",user);
        request.getRequestDispatcher("/update.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

FindServlet

```java
@WebServlet(name = "FindServlet",urlPatterns = "/find")
public class FindServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserService userService = new UserService();
        List<User> list = userService.findAll();
        //然后放入域中给jsp展示
        request.setAttribute("list",list);
        request.getRequestDispatcher("/list.jsp").forward(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

UpdateServlet

```java
@WebServlet(name = "UpDateServlet",urlPatterns = "/update")
public class UpDateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserService userService = new UserService();
        Map<String, String[]> parameterMap = request.getParameterMap();
        System.out.println("已经访问到了updateServlet");
        User user = new User();
        try {
            BeanUtils.populate(user,parameterMap);
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
        System.out.println(user);
        userService.update(user);
        response.sendRedirect(request.getContextPath()+"/find");
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

**service包**

```java
//用户的业务层
public class UserService {
    public List<User> findAll() {
        //这里不需要对数据进行处理
        //就直接调用dao
        UserDao userDao = new UserDao();
        List<User> list = userDao.findAll();
        return list;
    }

    public void add(User user) {
        UserDao userDao = new UserDao();
        userDao.add(user);
    }

    public void delete(String id) {
        UserDao userDao = new UserDao();
        userDao.delete(id);
    }

    public void update(User user) {
        System.out.println("访问到了web层");
        UserDao userDao = new UserDao();
        userDao.update(user);
    }

    public User findOne(String id) {
        UserDao userDao = new UserDao();
        User user = userDao.findOne(id);
        return user;
    }
}
```

**dao包**

```java
public class UserDao {
    public List<User> findAll() {
        List<User> list = UserUtils.findAll();
        return list;
    }

    public void add(User user) {
        //先查询所有数据，再将user添加到数组，最后将数组全部写入文件
        List<User> list = findAll();
        list.add(user);
        UserUtils.writeAll(list);
    }

    public void delete(String name) {
        //先查询所有数据
        List<User> list = findAll();
        for (User user : list) {
            if(user.getName().equals(name)){
                list.remove(user);
                break;
            }
        }
        UserUtils.writeAll(list);
    }

    public User findOne(String name) {
        List<User> list = findAll();
        for (User user : list) {
            if(user.getName().equals(name)){
                return user;
            }
        }
        return null;
    }

    public void update(User user) throws InvocationTargetException, IllegalAccessException {
        List<User> list = findAll();
        for (User everyUser : list) {
            if(everyUser.getId().equals(user.getId())){
                c
                System.out.println(everyUser);
                System.out.println(user);
            }
        }
        UserUtils.writeAll(list);
    }
}
```

**fiiter包**

```java
@WebFilter(filterName = "EncodingFilter",urlPatterns = "/*")
public class EncodingFilter implements Filter {
    public void destroy() {
    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws ServletException, IOException {
        req.setCharacterEncoding("utf-8");
        chain.doFilter(req, resp);
    }
    
    public void init(FilterConfig config) throws ServletException {
    }
}
```

**utils包**

```java
public class DataUtils {

    private static String realpath = "/Users/wujunnan/Desktop/wujunnan/MyProject/JavaWeb_MVCDemo/web/userdata.txt";

    //从文件中读取所有学员信息
    public static List<User> readAll() {
        //保存所有学生对象信息
       List<User> list = new ArrayList<>();
        try {
            //得到文件真实路径
            //创建字符输入流
            Reader isr = new InputStreamReader(new FileInputStream(realpath), "UTF-8");
            //创建字符缓冲流
            BufferedReader br = new BufferedReader(isr); //装饰模式

            //一次读一行
            String row = null;
            while ((row = br.readLine()) != null) {//row = "1,张三,男,20"
                String[] arr = row.split(",");
                User user = new User();
                user.setId(arr[0]);
                user.setName(arr[1]);
                user.setSex(arr[2]);
                user.setAge(Integer.parseInt(arr[3]));
                user.setAddress(arr[4]);
                user.setQq(arr[5]);
                user.setEmail(arr[6]);
                //将User对象添加到集合
                list.add(user);
            }
            br.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    //向文件中写入所有用户信息--覆盖写
    public static void writeAll(List<User> list) {
        try {
            //创建字符输出流
            Writer osw = new OutputStreamWriter(new FileOutputStream(realpath), "UTF-8");
            //创建字符缓冲流
            BufferedWriter out = new BufferedWriter(osw);
            //循环向文件中写入文本
            for (User user : list) {
                out.write(user.getId() + "," + user.getName() + "," + user.getSex() + "," + user.getAge() + "," + user.getAddress() + "," + user.getQq() + "," + user.getEmail());
                out.newLine();//创建新的一行
            }
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

**domain包**

**JSP**

list.jsp

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<!-- 网页使用的语言 -->
<html lang="zh-CN">
<head>
    <!-- 指定字符集 -->
    <meta charset="utf-8">
    <!-- 使用Edge最新的浏览器的渲染方式 -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- viewport视口：网页可以根据设置的宽度自动进行适配，在浏览器的内部虚拟一个容器，容器的宽度与设备的宽度相同。
    width: 默认宽度与设备的宽度相同
    initial-scale: 初始的缩放比，为1:1 -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <title>用户信息管理系统</title>

    <!-- 1. 导入CSS的全局样式 -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <!-- 2. jQuery导入，建议使用1.9以上的版本 -->
    <script src="js/jquery-2.1.0.min.js"></script>
    <!-- 3. 导入bootstrap的js文件 -->
    <script src="js/bootstrap.min.js"></script>
    <style type="text/css">
        td, th {
            text-align: center;
        }
    </style>
</head>
<body>
<div class="container">
    <h3 style="text-align: center">用户信息列表</h3>
    <table border="1" class="table table-bordered table-hover">
        <tr class="success">
            <th>编号</th>
            <th>姓名</th>
            <th>性别</th>
            <th>年龄</th>
            <th>籍贯</th>
            <th>QQ</th>
            <th>邮箱</th>
            <th>操作</th>
        </tr>
        <c:if test="${not empty list}">
            <c:forEach items="${list}" var="user" varStatus="vs">
                <tr>
                    <td>${vs.count}</td>
                    <td>${user.name}</td>
                    <td>${user.sex}</td>
                    <td>${user.age}</td>
                    <td>${user.address}</td>
                    <td>${user.qq}</td>
                    <td>${user.email}</td>
                    <td><a class="btn btn-default btn-sm" href="findone?id=${user.id}">修改</a>&nbsp;<a class="btn btn-default btn-sm" href="#" onclick="del('${user.id}')">删除</a></td>
                </tr>
            </c:forEach>
        </c:if>
        <tr>
            <td colspan="9" align="center">
                <a class="btn btn-primary" href="add.jsp">添加用户</a>
            </td>
        </tr>
    </table>
    <script>
        function del(id) {
            let flag=window.confirm("确定要删除用户吗")
            if(flag){
                location.href="/name/delete?id="+id;
            }
        }
    </script>
</div>
</body>
</html>
```

update.jsp

```jsp
<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- 网页使用的语言 -->
<html lang="zh-CN">
<head>
    <!-- 指定字符集 -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>修改用户</title>

    <link href="css/bootstrap.min.css" rel="stylesheet">
    <script src="js/jquery-2.1.0.min.js"></script>
    <script src="js/bootstrap.min.js"></script>

</head>
<body>
<div class="container">
    <div class="container">
        <h3 style="text-align: center;">修改用户</h3>
        <form action="/name/update" method="post">
            <div class="form-group">
                <label for="name">编号：</label>
                <input type="text" class="form-control" id="id" readonly="readonly" name="id" value="${user.id}"/>
            </div>

            <div class="form-group">
                <label for="name">姓名：</label>
                <input type="text" class="form-control" id="name" name="name" placeholder="请输入姓名" value="${user.name}"/>
            </div>

            <div class="form-group">
                <label>性别：</label>
                <input type="radio" name="sex" value="男" <c:if test="${user.sex=='男'}">checked</c:if>/>男
                <input type="radio" name="sex" value="女" <c:if test="${user.sex=='女'}">checked</c:if>/>女
            </div>

            <div class="form-group">
                <label for="age">年龄：</label>
                <input type="text" class="form-control" id="age" name="age" placeholder="请输入年龄" value="${user.age}"/>
            </div>

            <div class="form-group">
                <div class="form-group">
                    <label for="address">籍贯：</label>
                    <input type="text" class="form-control" id="address" name="address" placeholder="请输入籍贯" value="${user.address}"/>
                </div>
            </div>

            <div class="form-group">
                <label for="qq">QQ：</label>
                <input type="text" class="form-control" id="qq" name="qq" placeholder="请输入QQ号码" value="${user.qq}"/>
            </div>

            <div class="form-group">
                <label for="email">Email：</label>
                <input type="text" class="form-control" id="email" name="email" placeholder="请输入邮箱地址" value="${user.email}"/>
            </div>

            <div class="form-group" style="text-align: center">
                <input class="btn btn-primary" type="submit" value="提交"/>
                <input class="btn btn-default" type="reset" value="重置"/>
                <input class="btn btn-default" type="button" onclick="update()" value="返回"/>
            </div>
        </form>
    </div>
</div>
</body>
<script>
    function update() {
        location.href="/name/find"
    }
</script>
</html>
```

**userdate.txt**

~~~
1,刘德华,男,28,香港,123456,123456@qq.com
2,梁朝伟,女,62,香港,223456,223456@qq.com
3,冯小刚,男,48,北京,66779921,fxg@163.com
4,郭德纲,男,48,北京,1233212,guodegang@163.com
5,wujunnan,男,24,北京,1015853554,mr.wujunnan@qq.com
6,佟丽娅,女,34,北京,78462073,tongliya@gmail.com
7,德善,女,19,韩国,673984,miss.deshan.gmail.com
~~~

**注意点：**

1. js调用函数记得加上括号

2. 需要传递数据的时候，可以使用超链接的方式，将jsp中的数据，传递给sverlet

3. servlet和jsp之间需要跳转的时候，如果有数据需要传递，可以使用请求转发的方法

   `request.getRequestDispatcher("/demo03").forward(request,response);`

   而且这个不需要加项目名称，并且跳转后域名还是原来的域名不会变成转发后的域名

   如果不需要内容传递，可以使用重定向的方法

   `resposond.sendRedirect(request.getContextPath()+"/find");`

   这个需要加上项目名称

4. el标签和jstl标签一定要熟悉

5. 记住BeanUtils的这两个方法

   `BeanUtils.populate(user,map);`

   `BeanUtils.copyProperties(everyUser,user);`

6. IO的读写要熟悉

7. 注意在任何地方项目名都要使用引用，包括JSP里面

   `"${pageContext.request.contextPath}/update"`

## 文件上传

普通表单提交，已经没办法满足文件上传了，如果想要实现上传，我们就得对浏览器和服务器有一些要求

1. 表单的method必须是post

2. 表单的上传必须有name属性

3. 表单的enctype属性不能使用默认的了

   要使用指定的：`enctype="multipart/form-data"`**多部件表单**，代表当前的表单需要做上传

   默认值为：`enctype="application/x-www-form-urlencoded"`代表当前表单是**普通表单**，传递的都是字符串

问：多部件表单和普通表单的区别

普通表单，就是一直使用的表单，enctype属性使用的是默认值，所有内容请求都在请求体中，提交的内容是以URL拼接的方式给服务器的

多部件表单，enctype的属性不再使用默认值，而使用multipart/form-data，所有的内容也都在请求体中，提交的数据格式：

```
------------------------------
					一部分内容
------------------------------
					一部分内容
------------------------------
					......
							ps：标签表单项有几个，就有多少部分
```

使用多部件表单获取页面之后，之前获取页面数据的方式全部失效

```
 request.getParameter("info");
 request.getParameterValues("info");
 request.getParameterMap();
 						-------  全都无效了
 requset.getInputStream();
 通过此方式来获取请求体
```

我们可以使用Apache提供的工具包来实现（commons-fileupload-1.2.1.jar）

（ps：后期我们会用springmvc框架来实现上传代码）

![文件上传](JavaWeb%E6%A0%B8%E5%BF%83_assets/文件上传.png)

servlet

```java
@WebServlet(name = "DemoServlet",urlPatterns = "/receive")
public class DemoServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);
        List<FileItem> list = null;
        try {
            list = upload.parseRequest(request);
        } catch (FileUploadException e) {
            e.printStackTrace();
        }
        for (FileItem fileItem : list) {
            if(fileItem.isFormField()){
                String name = fileItem.getFieldName();
                String value = fileItem.getString("utf-8");
                System.out.println(name+":"+value);
            }else{
                String fileName = fileItem.getName();
                InputStream inputStream = fileItem.getInputStream();
                ServletContext servletContext = getServletContext();
                //这个从servlet中获得的真实地址即为项目部署的地址，地址名后面拼接上/upload
                String realPath = servletContext.getRealPath("/upload");
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                String date = simpleDateFormat.format(new Date());
                //再在upload里面拼接上日期的文件夹
                realPath = realPath+"/"+date;
                //结果就是/Users/wujunnan/develop/Project/MyJavaWeb/out/artifacts/JavaWeb_day11UploadAjax_war_exploded/upload/2020-08-24
                System.out.println(realPath);
                //根据路径创建一个File文件
                File file = new File(realPath);
                //如果是第一次访问不存在，那么就创建这个目录，mkdirs,意思是创建多级目录
                if(!file.exists()){
                    file.mkdirs();
                }
                //创建这个文件，outputStream
                FileOutputStream fileOutputStream = new FileOutputStream(realPath+"/"+fileName);
                //使用Apache的IOUtils来实现copy
                IOUtils.copy(inputStream,fileOutputStream);
                //需要关闭读写流吗
                fileOutputStream.close();
                inputStream.close();
                //上传成功
                response.getWriter().println("success!");

            }
        }

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

### IOUtils.copy()源码

```java
    public static int copy(InputStream input, OutputStream output) throws IOException {
        long count = copyLarge(input, output);
        return count > 2147483647L ? -1 : (int)count;
    }

    public static long copyLarge(InputStream input, OutputStream output) throws IOException {
        byte[] buffer = new byte[4096];
        long count = 0L;

        int n;
        for(boolean var5 = false; -1 != (n = input.read(buffer)); count += (long)n) {
            output.write(buffer, 0, n);
        }

        return count;
    }
```

可以看到并没有关闭流，需要我们手动关闭流

## Ajax校验用户名（三层架构）

用户在注册用户名的时候，要校验用户名是否可以被注册

事件触发jq代码，jq代码中编写ajax代码和服务器做无刷新交互，给文本框添加失去焦点事件

JSP

```java
    <script>
        //jq的页面加载
        $(function(){
            $("#name").blur(function () {
                let value = $("#name").val();
                let url = "${pageContext.request.contextPath}/check";
                //这个是
                let data = {"name":value};
                $.post(url,data,function (d) {
                    if(d==0){
                        //表示可以使用
                        $("#sp").text("该用户名可用").css("background-color","red");
                        $("#bt").prop("disabled",false);
                    }else if(d==1){
                        $("#sp").text("该用户名不可用").css("background-color","red");
                        $("#bt").prop("disabled",true);
                    }
                })
            })
        })
    </script>
```

CheckServlet

```java
@WebServlet(name = "CheckServlet",urlPatterns = "/check")
public class CheckServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        UserService userService = new UserService();
        Integer flag = userService.check(name);
        //将标示给Ajax
        response.getWriter().println(flag);

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request,response);
    }
}
```

service

```java
public Integer check(String name) {
  UserDao userDao = new UserDao();
  User user = userDao.check(name);
  if(user==null){
    return 0;
  }else{
    return 1;
  }
}
```

dao

```java
public User check(String name) {
  List<User> list = findAll();
  User user = null;
  for (User Theuser : list) {
    System.out.println(name);
    if(Theuser.getName().equals(name)){
      user = Theuser;
    }
  }
  return user;
}
```

## Meven

