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
