# Nginx应用

## 常用配置

### 代理后端

```nginx
location /solution {
    proxy_pass http://172.xx.xx.36:7001;
}
```

### 后端负载均衡

后端多个服务一起提供

```nginx
upstream openapi {
    server 172.xx.xx.1:9091;
    server 172.xx.xx.2:9091;
}
server{
    xxx
    location /openapi {
        proxy_pass http://openapi;
    }
}
```

此方式Nginx将随机将请求代理到这两台机器上。

### 访问本机前端文件

前后端分离式应用的前端目录一般如下所示：

```
message
├── favicon.ico
├── index.html
└── static
    ├── css
    └── js
```

一般是选择前缀匹配

```nginx
location ^~ /message {
    root /Users/wujunnan/work/project/dist/;
}
```

上述配置默认会寻找index.html，这样我们访问`http://localhost/message`即可。

若index.xml改名为618.html：

可将配置改为：

```nginx
location ^~ /message {
    root /Users/wujunnan/work/project/dist/;
    index 618.html;
}
```

继续访问`http://localhost/message`即可。

### 访问其他机器的前端文件

描述为通过机器A的Nginx访问机器B上面的前端文件。

1. 将机器B的前端文件通过Nginx暴露出来

   ```nginx
   server {
       listen       2000;
       server_name     82.157.xx.xxx;
       location / {
           root /data/message/;
       }
   }
   ```

2. 机器A将某个前缀代理到`82.157.51.xxx:2000`

   ```nginx
   location ^~ /message {
       proxy_pass http://82.157.xx.139:2000/;
   }
   ```

3. 访问`http://localhost/message`即可

注意：其他静态文件可以设置一个`massage`前缀，例如`http://localhost/message/js/xxx.js`，这样这些静态文件也可以通过`message`被代理。

## 其他应用

### 设置IP白名单

```nginx
location /dap {
    allow 223.xx.xx.137;
    allow 223.xx.xx.130;
    allow 49.xx.xx.2;
    allow 49.xx.xx.3;
    deny all;
    root    /data;
    try_files $uri $uri/ /dap/index.html;
    add_header Cache-Control max-age=0;
}
```

也可以将IP相关配置提取出来统一维护，用的时候进行引用。

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

### 客户端超时问题

**背景**

业务方反馈，页面发生504 Gateway Time-out

**处理**

Nginx默认后端1分钟未响应，则返回504超时。

增加如下配置：

```
proxy_connect_timeout  180s;
proxy_send_timeout  180s;
proxy_read_timeout  180s;
```

### Nginx403问题

当我们进行如下配置的时候：

```
location / {
  try_files $uri $uri/ index.html;
} 
```

页面会出现能Nginx403错误。

这个配置的含义是，从root目录开始，先寻找`uri`对应的文件，如果文件不存在，寻找对应的目录。

当Nginx访问目录的时候，它尝试构建这个目录的索引，然后将里面的文件列表返回，当默认的目录不允许构建索引的时候，将返回"Nginx 403 error: directory index of [folder] is forbidden"。

这个时候可以删除`$uri/`。

## References

1. http://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_connect_timeout
1. https://stackoverflow.com/questions/19285355/nginx-403-error-directory-index-of-folder-is-forbidden
