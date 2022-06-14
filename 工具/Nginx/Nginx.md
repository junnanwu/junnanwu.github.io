# Nginx

## Nginx的用途

### 反向代理

反向代理（reverse proxy）方式是指用代理服务器来接受Internet上的连接请求，然后将请求转发给内部网络中的上游服务器，并从上游服务器上得到的结果返回给Internet上请求连接的客户端，此时Nginx对外的表现就是一个Web服务器。

Nginx很适合用作反向代理服务器，因为反向代理服务器必须能够处理大量并发请求。

正是由于Nginx强大的并发处理能力，Nginx往往也常常当作前端的服务器，直接向客户端提供静态的文件服务，但有一些复杂的业务并不适合在Nginx上处理，这个时候，可以用Tomcat等来处理，所以，Nginx通常同时用作反向代理和静态Web服务器。

## Nginx的工作特点

当客户端发来HTTP请求的时候，Nginx并不会立刻转发到上游服务器，而是先把用户的请求完整的接收到Nginx所在的服务器的硬盘或者内存中，然后再向上游发起连接。

- 优点就是将压力尽量放在Nginx上面

  因为客户端和代理服务器之间网络一般比较复杂的公网，网速平均下来比较慢，而代理服务器和上游服务器直接一般私网或者专线连接，速度较快（实际使用中腾讯云内网之间传输速度300MB/s左右）。

  Squid等反向代理服务器，在还没有接受客户端的HTTP包体的时候，就已经和上游服务器建立了连接。例如需要上传一个1G的文件，Squid接收每个TCP包就会立即向上游服务器转发，在上传的漫长过程中，上游服务器，需要始终维持这个连接，这就对上游服务器的并发能力提出了挑战。

- 缺点就是多了一个请求的处理时间。

## Nginx的结构

Nginx由少量核心框架代码和许多模块组成，每个模块都有它独特的功能。甚至可以自己定制一个模块。

## Nginx命令

- 运行nginx

  ```sh
  $ ./nginx
  ```

  运行的时候还可以指定配置文件的位置

  ```sh
  $ ./nginx -c /usr/local/openresty/nginx/conf/nginx.conf
  ```

- 检查配置

  ```sh
  $ ./nginx -t
  ```

- 重新载入配置

  ```sh
  $ ./nginx -s reload
  ```

- 重启nignx

  ```sh
  $ ./nginx -s reopen 
  ```

- 停止nignx

  需要进程完成当前工作后再停止

  ```sh
  $ ./nginx -s quit
  ```

  无论进程是否在工作，都直接停止进程

  ```sh
  $ ./nginx -s stop 
  ```

- 查看进程

  ```sh
  $ ps aux | grep nginx
  ```

## nginx.conf

nginx文件结构

```nginx
...              #全局块

events {         #events块
   ...
}

http      #http块
{
    ...   #http全局块
    server        #server块
    { 
        ...       #server全局块
        location [PATTERN]   #location块
        {
            ...
        }
        location [PATTERN] 
        {
            ...
        }
    }
    server
    {
      ...
    }
    ...     #http全局块
}
```

### 全局块

配置影响nginx全局的指令。一般有运行nginx服务器的用户组，nginx进程pid存放路径，日志存放路径，配置文件引入，允许生成worker process数等。

| 参数           | 含义                                                         |
| -------------- | ------------------------------------------------------------ |
| user           | 该参数用来配置worker进程的用户和组                           |
| work_processes | 指定worker进程启动的数量。经验是设置该参数的值与CPU的处理器核心数相同，也可以配置为auto，Nginx1.2.5版本之后，会通过CPU核数启动线程 |
| error_log      | 是错误写入的文件，该指令的第二个参数可以指定错误的级别（debug, info, notice等） |
| pid            | 设置记录主进程ID的文件                                       |

**include**

incloude可以放在配置文件的任何地方，以便增强配置文件的可读性，并且使部分配置文件可以重新使用

```nginx
include /opt/local/etc/nginx/mime.types
```

在路径中出现通配符，表示可以配置多个文件，如果没有给定全路径，那么Nginx将会根据主配置文件路径进行搜索。

### events

配置影响nginx服务器或与用户的网络连接。有每个进程的最大连接数，选取哪种事件驱动模型处理连接请求，是否允许同时接受多个网路连接，开启多个网络连接序列化等。

### http

可以嵌套多个server，配置代理，缓存，日志定义等绝大多数功能和第三方模块的配置。如文件引入，mime-type定义，日志自定义，是否使用sendfile传输文件，连接超时时间，单连接请求数等。

http是全局参数，对整体产生影响

#### upstream

upstream块定义了一个上游服务器的集群，便于反向代理中的`proxy_pass`使用。

配置块：`http`

例如：

```nginx
upstream backend {
	server backend1.example.com;
	server backend1.example.com;
	server backend1.example.com;
}

server {
	location / {
		proxy_pass http://backend;
	}
}
```

- server

  server配置项指定了一台上游服务器的名字，这个名字可以是域名，IP地址端口，UNIX句柄等其后面还可以加一些参数

  - `weigth=number`

    设置这台上游转发的权重，默认为1

  - `max_fails=number`

    与`fail_timeout`配合使用，指在fail_timeout时间段内，如果向当前的上游服务器转发失败的次数超过number，则认为当前的fail_timeout时间内这台上游服务器不可用，max_fails默认为1，如果设置为0，则不检查失败次数。

  - `fail timcout = time`

    fail timcout表示该时间段内转发失败多少次后就认为上游服务器暂时不可用，用于优化反向代理功能。它与向上游服务器建立连接的超时时间、读取上游服务器的响应超时时间等完全无关。 fail timcout默认为10秒。

例如：

```nginx
upstrearn backend {
  server backend1.example.com weight=5;
  server 127.0.0.1:8080 max_fails=3 fail_timeout=30s; 
  server unix:/tmp/backend3;
}
```



### server

配置虚拟主机的相关参数，一个http中可以有多个server，一个虚拟服务器由listen和server_name指令组合定义

由于IP地址数量有限，**因此存在多个域名对应着同一个IP地址的情况**，这时在nginx.conf中就可以按照server_name（对应用户请求中的主机名）并通过server块来定义虚拟主机，每个server块就是一个虚拟主机，它只处理与之对应的主机域名请求，这样，一台服务器上的Nginx就能以不同的方式处理访问不同域名的HTTP请求了。

#### listen

listen参数决定了Nginx如何监听端口，listen的使用非常灵活，如下：

```nginx
listen 127.0.0.1:8000;
#不加端口时，默认监听80端口
listen 127.0.0.1; 
listen localhost:8080;
```

在地址和端口后，还可以加上其他参数

```nginx
listen 443 default_servcer ssl;
listen 127.0.0.1 default_server accept_filter=dataready backlog=1024;
```

- default/default_server：将所在的server块作为整个Web服务的默认server块，如果没有这个参数，那么nginx.conf中找到的第一个server块作为默认server块

  默认主机的作用就是当一个请求无法匹配文件中的所有主机域名的时候，就会选用默认的虚拟主机

- ssl：当前监听端口上所建立的连接必须是基于SSL协议

- ...

#### server_name

server_name指令默认值为`""`，默认配置意味着server部分没有server_name指定，对于没有设置Host头字段的请求，它将会匹配该server处理，一般应用于如何丢弃这种缺乏Host头的请求。

server_name后可以跟多个主机名，如

```nginx
server_name www.testweb.com、download.testweb.com;
```

server_name指令的参数可以接收通配符/正则表达式作为server_name指令的参数

```nginx
*.example.com
www.example.*
```

当一个请求来到的时候，Nginx将通过如下逻辑来判断，哪些虚拟服务器提供请求服务

1. 首先选择所有字符完全匹配的`server_name`，如`www.testweb.com`
2. 其次选择通配符在前面的`server_name`，如`*.testweb.com`
3. 其次选择通配符在后面的`server_name`，如`www.testweb.*`
4. 最后选择正则表达式匹配的`server_name`
5. 如果都不匹配，那么就找默认的server块
6. 如果没有默认的server块，就选择第一个server块

### location

location会尝试根据用户请求中的URI来来匹配location的表达式，如果可以匹配，就选择location块中的配置来处理用户的请求

- `=` 

  开头表示精确匹配。

  ```nginx
  location = /{
    #只有用户的请求是/的时候，使用该配置
  }
  ```

- `^~`

  表示匹配URI只需要前半部分与URI匹配即可。

  ```nginx
  location ^~ /images/ {
  	# 以/images/开始的请求都会被匹配上
  }
  ```

- `~`

  表示匹配URI是字母大小写敏感的，属于正则表达式。

- `~*`表示忽略大小写问题，属于正则表达式

  ```nginx
  location ~* \.(gif|jpg|jpeg)$ {
  	# 匹配以 .gif、.jpg、.jpeg结尾的请求
  	...
  }
  ```

- `/uri`

  表示前缀匹配，不带修饰符，优先级没有正则表达式高。

- `/`

  通用匹配，默认找不到其他匹配的时候，会进行通用匹配。

- @表示Nginx内部之间的重定向

  命名空间，只能在server级别定义，不直接处理用户请求。

**注意：location是有顺序的，当location匹配成功时候，停止匹配，按当前匹配规则处理请求**

在以上的匹配方式中，都表达了，如果匹配...则...，如果需要表达如果不匹配...则...

有一种解决方法是在最后一个localtion中使用/作为参数，这样就可以表示，如果不匹配前面所有的location，则由该location处理

```nginx
location / {
	#/可以匹配所有请求
}
```

注意：uri带`/`和不带`/`有何区别？





```nginx
location / {
    # dw-web-ui
    root   D:\work\dist;
    index  index.html index.htm;
    #try_files $uri $uri/ /dw-web-ui/index.html;å
    try_files $uri $uri/ /usertag/index.html;
}
```

#### 文件路径的定义

##### root

通过root的方式设置资源的路径

```nginx
location /download/ {
	root /opt/web/html/;
}
```

在上述配置中，如果有一个请求的URI是`/download/index/test.html`

那么Web服务器就会返回服务器上的`/opt/web/html/download/index/test.html`文件的内容;

##### alias

有一个请求为`/conf/nginx.conf`而用户实际想访问的文件在 `/usr/local/nginx/conf/nginx.conf`可采用如下配置：

```nginx
location /conf {
	alias /usr/local/nginx/conf/;
}
#使用root
location /conf {
  root /usr/local/nginx/;
}
```

使用`alias`的时候，在URI向实际文件路径映射的过程中，已经把`location`后配置的`/conf`这部分丢弃掉了

因此，`/conf/nginx.conf`请求将根据`alias path`映射为`path/nginx.conf`

`root`则不然，它会根据完整的URI进行映射

因此，`/conf/nginx.conf`请求会根据`root path`映射为 `path/conf/nginx.conf`

这也正是`root`可以放在`http`、`server`、`location`中，而`alias`只能放置到`location`中

##### index

访问首页，有时，访问的站点的URI是`/`，这时候一般是返回网站的首页，这一般都会使用index实现，index后面可以跟多个文件参数，Nginx将会按照顺序来访问这些文件，例如:

```nginx
location / {
		root path;
		index /index.html /html/index.php /index/php
}
```

接收到请求之后，Nginx首先会尝试访问`path/index.php`文件，如果可以访问，就直接返回文件内容，结束访问

否则，再次试图返回`path/html/index.php`文件的内容，依此类推

##### error_page

当对于某个请求返回错误码时，如果匹配上了error_page中的code的时候，则重定向到新的URI中

```nginx
error_page 404 /404.html;
error_page 502 503 504 /50x.html;
error_page 403 http://example.com/forbidden.html;
#也可以通过 = 来更改返回的错误码
error_page 404 =200 /empty.gif;
```

##### try_files

try_files后面要跟若干路径，而且最后必须要有uri参数，意义如下：尝试照顺序访问每一个path，如果可以有效的读取，就直接向用户返回这个path的对应文件内容，否则就继续向下访问，如果所有的path都找不到有效的文件，就重定向到最后的参数uri上，因此最后的参数uri时必须存在的，而且应该是可以有效重定向的，例如

```nginx
try_files /system/maintenance.html $uri $uri/index.html $uri.html @other;
location @other {
		proxy_pass http://backend;
}
```

上述表示，如果前面的路径都找不到，那么就会反向代理到`http://backend`服务上

还可以用指定错误码的方式与error_page配合使用

```nginx
location /{
	try_files $uri $uri/ /error.php?c=404 =404;
}
```

**举例说明**

```nginx
location /images/ {
    root /opt/html/;
    try_files $uri   $uri/  /images/default.gif; 
}
```

比如，请求 127.0.0.1/images/test.gif 会依次查找 

- 文件/opt/html/images/test.gif 
- 文件夹 /opt/html/images/test.gif/下的index文件
- 请求127.0.0.1/images/default.gif

**实战**

```nginx
location / {
  root   /Users/wujunnan/develop/work/dist;
  index  index.html index.htm;
  #try_files $uri $uri/ /dw-web-ui/index.html;
  try_files $uri $uri/ /usertag/index.html;
}
```

含义就是先访问`/Users/wujunnan/develop/work/dist;`+uri访问的资源是否存在，存在的话就访问，不存在的话访问`/usertag/index.html`

```NGINX
location /usertag/ {
    root   D:\work\dist;
    index  index.html index.htm;
    try_files $uri $uri/ /usertag/index.html;
    add_header Cache-Control "max-age=0";
    # add_header Cache-Control "no-cache";
}
```

#### rewirte

参数可以存在的位置：`server`，`location`，`if`

```
rewrite <regex> <replacement> [flag];
```

flag：

- last

  本条规则匹配完成后，继续向下匹配新的location URI规则

- break

  本条规则匹配完成即终止，不再匹配后面的任何规则

- redirect

  返回302临时重定

- permanent

  返回301永久重定向

正则部分可以使用`^/(.*) `代表完整的路径名

应用场景：

- 网址更换域名后，可以让旧的地址跳转到新的地址上
- 根据客户端的信息，对URL进行调整

举例：

如果访问的是`www.abc.com`，重定向到`http://www.abc.com`

```nginx
server {

    listen 80;
    server_name abc.com www.abc.com;
    if ( $host != 'www.abc.com'  ) {

        rewrite ^/(.*) http://www.abc.com/$1 permanent;

    }
    location / {
        root /data/www/www;
        index index.html index.htm;

    }
    error_log    logs/error_www.abc.com.log error;
    access_log    logs/access_www.abc.com.log    main;
}
```

#### proxy_pass

语法：

```
proxy_pass URL
```

此配置项将当前请求反向代理到URL参数指定的服务器上

配置块：`location`、`if`

例如：

将URI为`/test`的请求代理到127.0.0.1上，端口为81，使用HTTP：

```nginx
location = /test {
    proxy_pass http://127.0.0.1:81;
}
```



```nginx
location /test/v1/ {
	# 将/test/v1/ 替换为 /abc/
    # 如/test/v1/xxx?a=1 到达后端后会变为 /abc/xxx?a=1
    proxy_pass http://127.0.0.1:81/abc/;
}
```

```nginx
location /aaa/ {
    # 将URL /aaa/ 替换为 /
    proxy_pass http://127.0.0.1:81/;
}
```

```nginx
location /aaa {
    # 什么都不会改变，直接传递原始的URL
    proxy_pass http://127.0.0.1:81;
}
```

在nginx中配置proxy_pass代理转发时，如果在proxy_pass后面的url加/，那么就会将匹配部分的URI用/替换，proxy_pass后面的url不加/，那么会将匹配部分的URI也给带上





```nginx
proxy_pass http://localhost:8000/uri/;

#还可以直接使用upstream块
upstream backend {
	...
}

server {
  localtion / {
    proxy_pass http://backend;
  }
}
```

默认情况下，反向代理是不会转发请求中方的Host头部的。如果需要，那么必须加上：

```nginx
proxy_set_header Host $host;
```

**proxy_method**

表示转发时的协议方法名。例如设置为：

```nginx
proxy_method POST
```

那么客户端发来的GET请求也会被转发为POST



#### proxy_set_header

自定义请求头

语法格式：

```
proxy_set_header Field Value;
```

Value值可以是包含文本、变量或者它们的组合。

**注意：**在nginx的配置文件中，如果当前模块中没有proxy_set_header的设置，则会从上级别继承配置。继承顺序为：http, server, location。

**应用**

IP地址

当我们需要获取用户的IP地址的时候，如果我们使用了nginx的反向代理，那么我们后端拿到的就是ngxin的IP地址

1. 这个时候，由于nginx的`$remote_addr`变量可以拿到用户的真实IP地址，这个时候就可以使用如下语句

   ```
   proxy_set_header X-Real-IP $remote_addr;
   ```

2. 默认的`X-Forwarded-For`是空值，

#### proxy_cookie_domain

```
proxy_cookie_domain domain replacement
```

转换response的set-cookie header中的domain选项，由后端设置的域名domain转换成你的域名replacement，来保证cookie顺利写入到当前页面中。（只负责处理domain属性）

与此类似的还有proxy_cookie_path。

**应用**

**给应用cookie加Secure属性**

```
proxy_cookie_path / "/; Secure";
```

### Cache-Control

Cache-Control：no-cache，强制每次请求直接发送给源服务器，而不经过本地缓存版本的校验。这对于需要确认认证应用很有用（可以和public结合使用），或者严格要求使用最新数据 的应用（不惜牺牲使用缓存的所有好处）. 通俗解释：浏览器通知服务器，本地没有缓存数据

cache-control :
    max-age>0时 直接从游览器缓存中提取;
    max-age<=0 时向server发送http请求确认 ,该资源是否有修改, 有的话 返回200 , 无的话 返回304。

### vhost

vhost配置文件的作用是为了将更多的server配置文件的信息，单独存放，不至于集中在nginx.conf配置中，这样有助于查找问题

http块中添加`include vhosts/*.conf`，然后在nginx目录下的vhosts目录中新增xxx.conf

### ngx_http_core_module模块提供的变量

| 参数名           | 意义                                                         |
| ---------------- | ------------------------------------------------------------ |
| `$arg_PARAMETER` | HTTP请求中某个参数的值，如`/index.html?size=100`可以用$arg_size取得100这个值 |
| `$args`          | HTTP请求中完整的参数，例如，`index.html?_w=120&_h=120`中，$args表示字符串`_w=120&_h=120` |
| `$is_args`       | 表示请求中的URI是否带参数，如果带，其值为`?`，如果不带参数，则为空字符串 |
| `$uri`           | 表示当前请求的URI，不带任何参数（可能是内部重定向后的URI）   |
| `request_uri`    | 表示客户端发来的原始请求URI，带完整的参数                    |
| `$host`          | 表示客户端请求头中的Host字段，如果Host字段不存在，则以实际处理的server名称代替 |
| `$content_type`  | 表示客户端请求头中的Content-Type字段                         |
| `$scheme`        | 表示http或者https，常用于将http转换为https                   |

## 访问流程

```nginx
server {
    listen       80;
    server_name  localhost;

    #charset koi8-r;

    #access_log  logs/host.access.log  main;

    location / {
        # dw-web-ui
        root   D:\work\dist;
        index  index.html index.htm;
        #try_files $uri $uri/ /dw-web-ui/index.html;
        try_files $uri $uri/ /usertag/index.html;
    }

    location /usertag/ {
        root   D:\work\dist;
        index  index.html index.htm;
        try_files $uri $uri/ /usertag/index.html;
        add_header Cache-Control "max-age=0";
        # add_header Cache-Control "no-cache";
    }

    location /analysis/ {
        root   D:\work\dist;
        index  index.html index.htm;
        try_files $uri $uri/ /analysis/index.html;
        add_header Cache-Control "max-age=0";
        # add_header Cache-Control "no-cache";
    }


    location /data-web/ {
        proxy_pass http://localhost:9010;
    }

    location /cas/ {
        proxy_pass http://localhost:8080;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   html;
    }
}
```

输入localhost/analysis后nginx中的请求日志

```
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/ HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/css/chunk-vendors.0eaad782.css HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/css/index.ceee3654.css HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-vendors.7b2a99f3.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/index.7113c2e4.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/css/chunk-23a86bb0.0832fe77.css HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/css/chunk-8caa4b5a.312d4a24.css HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/css/chunk-da90a3d0.0028ddf8.css HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-23a86bb0.81554dc6.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-2d0db2a8.100e037d.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-2d22d366.ba278505.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-8caa4b5a.16aab16a.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
127.0.0.1 - - [01/Mar/2021:15:42:50 +0800] "GET /analysis/static/js/chunk-da90a3d0.eef2ab5a.js HTTP/1.1" 304 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"

127.0.0.1 - - [01/Mar/2021:15:42:57 +0800] "GET /data-web/user/detail?dataplatformCode=analysis HTTP/1.1" 302 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"

127.0.0.1 - - [01/Mar/2021:15:42:57 +0800] "GET /cas/login?service=http://localhost/data-web/shiro-cas/analysis HTTP/1.1" 200 6636 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"

127.0.0.1 - - [01/Mar/2021:15:42:58 +0800] "GET /data-web/index/analysis HTTP/1.1" 302 0 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"

127.0.0.1 - - [01/Mar/2021:15:42:58 +0800] "GET /cas/login?service=http://localhost/data-web/shiro-cas/analysis HTTP/1.1" 200 6636 "http://localhost/analysis/" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.190 Safari/537.36"
```

## 生产应用

### 设置IP白名单

```nginx
location /dap {
            allow 223.70.137.137;
            allow 223.70.137.130;
            allow 49.7.65.2;
            allow 49.7.65.3;
            allow 49.7.65.4;
            allow 49.7.65.14;
            allow 49.7.65.254;
            deny all;
            root    /data;
            try_files $uri $uri/ /dap/index.html;
            add_header Cache-Control max-age=0;
        }
```

### nginx更改默认403页面

1. 制作`403.html`

   ```html
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" " http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
   <meta http-equiv="content-type" content="text/html;charset=utf-8">
   <title>Error 403 Forbidden</title>
   <style>
   <!--
   	body {font-family: arial,sans-serif}
   	img { border:none; }
   //-->
   </style>
   </head>
   <body>
   <blockquote>
   	<h2>Error 403 Forbidden</h2>
   	<p>对不起，您的访问被拒绝，有可能是您的IP不被允许访问，请联系管理员!
   </blockquote>
   </body>
   </html>
   ```

2. 放在`nginx/html`下

3. 修改配置

   ```nginx
   server{
       listen	443;
       server_name	hxduat.kg.com;
       error_page  403  /403.html;
       ...
   }
   ```

   有时候会报找不到/403.html

   那么就加上如下：

   ```nginx
   location /403.html {
       root /data/nginx/html;
   }
   ```

### 访问客户端的真实IP

### 安装SSH证书

https://cloud.tencent.com/document/product/400/4143

### 客户端超时问题

背景：

业务方反馈，页面发生504 Gateway Time-out

处理：

Nginx默认后端1分钟未响应，则返回504超时。

增加如下配置：

```
proxy_connect_timeout  180s;
proxy_send_timeout  180s;
proxy_read_timeout  180s;
```

[详见此](http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout)

## Reference

本文大量参考了 陶辉的《深入理解Nginx-模块开发于架构解析-第二版》



```java
/**
 * 获取request中的ip地址
 *
 * @param request
 * @return
 */
private String getIpAddr(HttpServletRequest request) {

    String ip = request.getHeader("x-forwarded-for");
    try {
        if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || UNKNOWN.equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
            if ("127.0.0.1".equals(ip)) {
                //根据网卡取本机配置的IP
                InetAddress inet = InetAddress.getLocalHost();
                ip = inet.getHostAddress();
            }
        }
        // 多个代理的情况，第一个IP为客户端真实IP,多个IP按照','分割
        if (ip != null && ip.length() > 15 && ip.indexOf(',') >= 0) {
            ip = ip.substring(0, ip.indexOf(','));
        }
    } catch (Exception e) {
        log.error(e.getMessage(), e);
    }
    return ip;
}
```



