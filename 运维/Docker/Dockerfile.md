# Dockerfile

制作镜像的两种方式，一种是将容器提交为镜像，一种是手动编写Dockerfile。

## Dockerfile基本格式

Dockerfile里面包括配置指令和操作指令。

配置指令：

- `ARG`

  定义创建镜像过程中使用到的变量。

  在`docker build`命令中以`--build-arg name=value`的形式赋值

- `FROM`

  基础镜像。

- `LABEL`

  为生成的镜像添加元数据标签信息。

- `WORKDIR`

  登录容器进入的默认目录，为后续的`RUN`、`CMD`、`ENTRYPOINT`指令配置工作目录。

- `EXPOSE`

  声明镜像内服务监听的端口。

- `ENV`

  指定环境变量。

- `VOLUME`

  创建一个数据挂载点。

- `USER`

  指定运行容器时的用户名。

操作指令：

- `RUN`

  当前镜像的顶部执行命令，并创建新的镜像层。

  每个RUN命令都会创建一层镜像，多个命令可以使用`&&`连接起来，这样就只生成一层镜像。

  格式为：
  
- `RUN <command>`
  
  - `RUN ["executable", "param1", "param2"]`
  
- `CMD`

  容器启动后默认执行的命令。

  `CMD`能被`docker run`后面的命令行参数替换。

- `COPY`

  复制内容到镜像。

  `COPY <src> <dest>`

  将复制指定的`<src>`路径下内容到容器中的`<dest>`路径下。

- `ADD`

  ADD是增强版的COPY，将宿主机文件复制到镜像。

  格式如下：

  ```
  ADD [--chown=<user>:<group>]  <src> <dest>
  ```

  注意：

  - `<dest>`应该是一个绝对路径，或者相对于`WORKDIR`的相对路径
  - 默认新文件或者新目录的属主和属组是UID和GID为0用户和用户组，可以通过`--chown`来修改	
  - 如果`<src>`是个文件，且目标也是个文件，类似`mv`命令
  - 如果`<src>`是一个压缩文件（`gzip`、`xz`等），那么将会被自动解压（不包括`<src>`是一个URL的情况）
  - ADD命令还支持`<src>`参数是一个URL，即从目标地址下载文件复制到指定目录

- `ENTRYPOINT`

  每次启动Docker容器，都会执行ENTRYPOINT指定的脚本（和CMD不同的是，ENTRYPOINT不会被忽略，即使docker run指定了其他命令）。

## 创建镜像

编写完Dockerfile之后，可以通过如下命令来创建镜像：

```
docker build [OPTIONS] PATH|URL|-
```

该命令将读取指定路径下的Dockerfile，并将该路径下的所有数据作为上下文发送给Docker服务，Docker在校验Dockerfile格式通过之后，逐条执行其中定义的指令，碰到ADD，COPY和RUN指令都会生成一层新的镜像，最终如果创建成功，则返回镜像的ID。

OPTIONS：

- `-f`

  指定Dockerfile。

- `--tag`

  镜像的标签。

## Dockerfile技巧

### 基础系统镜像

#### Debian

Debian镜像核心非常小，稳定，占用硬盘、内存小。经常被用作基础系统镜像，如需用到软件，可以通过apt-getl来安装，有时候会提示如下：

```
# apt-get install curl
Reading package lists... Done
Building dependency tree
Reading state information... Done
```

这并非意味着系统不支持apt-get命令，Docker镜像在制作时为了精简清除了apt仓库信息，因此需要先执行`apt-get update`命令来更新仓库信息。更新信息后即可成功通过apt-get命令来安装软件。

```
#安装ps命令
$ apt-get install procps
```

想要安装的快，需要替换镜像。

```
RUN sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list
```

使用非交互模式：

```
DEBIAN_FRONTEND=noninteractive apt-get update -q
```

### 关于用户

#### 非登录shell

有时候我们都会给某个用户分配一个`/sbin/nologin`的shell，这个用户不允许登录系统（ssh或su），但是可以操作资源，例如打印作业通过ip用户，www服务通过apache这个用户，这样分配安全性更高。

## 官方Dockerfile

### Nginx的Dockerfile

```
FROM debian:bullseye-slim

LABEL maintainer="NGINX Docker Maintainers <docker-maint@nginx.com>"

ENV NGINX_VERSION   1.20.2
ENV NJS_VERSION     0.7.0
ENV PKG_RELEASE     1~bullseye

RUN set -x \  #节省篇幅，主要是学习Dcokerfile语法，这里省略了若干行linux的shell脚本

COPY docker-entrypoint.sh /
COPY 10-listen-on-ipv6-by-default.sh /docker-entrypoint.d
COPY 20-envsubst-on-templates.sh /docker-entrypoint.d
COPY 30-tune-worker-processes.sh /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
```

注意：

`nginx -g "daemon off;"`，该命令的作用是使得Nginx在前台运行。

## 自写Dockerfile

### VUE Dockerfile

Dockerfile文件如下：

```
FROM nginx
ENV TZ=Asia/Shanghai
COPY ci/default.conf /etc/nginx/conf.d/default.conf
COPY dist/ /usr/share/nginx/html/
```

### Java Dockerfile

Dockerfile文件如下：

```
FROM openjdk:8-jdk-alpine

ENV TZ=Asia/Shanghai
ADD backend/build/libs/*-SNAPSHOT.jar /app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
```

### PHP Dockerfile

#### 背景

PHP-FPM

CGI（Common Gateway Interface），通用网关接口，是外部应用程序与WEB服务器之间的接口标准。在Java Servlet出现之前，HTTP后端动态内容是通过 CGI来实现的，由于每次CGI请求都会创建一个线程，资源消耗很大，后续出现了FastCGI，FastCGI使用持续的进程来处理一连串的Web请求，减少资源消耗。

PHP-FPM（FastCGI Process Manager）就是PHP对应FastCGI的实现。

**PHP扩展**

PHP扩展是使用C/C++开发的第三方插件，扩展是对PHP底层的补充。

可以通过apt/yum、编译源码等方式来安装PHP扩展，也可以通过[install-php-extensions](https://github.com/mlocati/docker-php-extension-installer)这个工具来安装。通过`php -m`可以查看已经安装了哪些扩展。

**Composer**

Composer是PHP的依赖包管理工具，它的核心是一个composer.json文件，里面定义了各种依赖，当我们执行`composer install`，Composer就会将所需依赖下载到vendor目录。

#### 镜像文件

下面是PHP的Dockerfile:

```
#对应php版本为7.4
FROM php:7.4-fpm

# 指定时区
ENV TZ=Asia/Shanghai

# 安装nginx、清除默认配置、安装vim
RUN sed -i "s/deb.debian.org/mirrors.aliyun.com/g" /etc/apt/sources.list \
    && apt-get update && apt-get install nginx -y \
    && apt-get install vim -y \
    && rm -f /etc/nginx/conf.d/* \
    && cat /dev/null > /etc/nginx/sites-available/default
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# 安装composer
RUN curl -o /usr/bin/composer https://mirrors.aliyun.com/composer/composer.phar \
    && chmod +x /usr/bin/composer
# 安装php扩展
RUN install-php-extensions \
    bcmath  \
    Core  \
    ctype  \
    curl  \
    date  \
    dom  \
    fileinfo  \
    filter  \
    ftp  \
    gd  \
    gettext  \
    hash  \
    iconv  \
    intl  \
    json  \
    libxml  \
    mbstring  \
    mysqli  \
    mysqlnd  \
    openssl  \
    pcntl  \
    pcre  \
    PDO  \
    pdo_mysql  \
    pdo_sqlite  \
    Phar  \
    posix  \
    redis  \
    Reflection  \
    session  \
    shmop  \
    SimpleXML  \
    soap  \
    sockets  \
    sodium  \
    SPL  \
    sqlite3  \
    standard  \
    sysvsem  \
    tokenizer  \
    xml  \
    xmlreader  \
    xmlrpc  \
    xmlwriter  \
    zip  \
    zlib

COPY . /var/www/html/
COPY ci/nginx-php.conf /etc/nginx/conf.d/nginx-php.conf
COPY ci/run.sh /run.sh

#新建非root用户满足composer需要/指定环境文件/设置初始目录
RUN useradd composer \
    && echo production > .env  \
    && mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini  \
    && mkdir -p -m o+w storage/framework/views  storage/framework/sessions  /var/www/html/bootstrap/cache\
    && chmod o+w -R /var/www/html/storage/  \
    && chmod +x /run.sh

USER composer
RUN php -m && composer install
USER root
EXPOSE 80
ENTRYPOINT ["/run.sh"]
```

注意：

- 我采取的方式是在项目的根目录下创建一个ci包，里面是Dockerfile、run.sh以及下面的Nginx的配置，当运行`docker build`的时候，需要在根目录下运行：

  ```
  $ docker build -f ci/Dockerfile --tag php:01 .
  ```

- 此Dockerfile中，用户方面的配置也有待改进

- 该版本php没有php.ini文件，但是给了php.ini-development和php.ini-production两个建议，想使用哪个，就将哪个复制为php.ini

  参考[php.ini-development 与 php.ini-production](https://blog.csdn.net/wang740209668/article/details/73278221)。

Dockerfile中Nginx配置`www-php.conf`文件如下：

```
server {
    listen       80;
    #server_name  localhost;
    root   /var/www/html/public;
    location / {
        try_files $uri /index.php$is_args$query_string;
    }
    location ~* \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
 	}
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

这里需要注意一点，在`/`部分location，将请求路径改写后，并没有了uri，这里详见[Nginx 的基础内置变量 / Nginx 重写 url 的模式](https://segmentfault.com/a/1190000022499679)：

> 有没有注意到 `yii2` 非必须携带 `$uri` 转发？下面的 `laravel` 也是如此。因为 `yii2`/`laravel` 的路由解析的是 `$request_uri`，重写的 `url` 只是用来把 `queryString` 传递给框架，框架内部会使用 `nginx::$request_uri => php::$_SERVER['REQUEST_URI']` 中的路径信息进行路由解析。

关于PHP Nginx的配置，也可参考：https://gist.github.com/ashleydw/afd389b1e763d3c1cf1f。

run.sh如下：

```sh
#!/usr/bin/env sh
set -e

php-fpm -D
nginx -g 'daemon off;'
```

此部分参考了[制作PHP镜像](https://help.aliyun.com/document_detail/348799.html)。

#### PHP容器操作

1. 如果容器内运行失败，先进入容器内部

      ```
      $ docker exec -it container_name /bin/bash
      ```

   注意，container_name为容器名，下同。

2. 可以通过如下命令验证PHP环境是否有问题

   ```
   $ composer update
   ```

3. 查看容器日志

      ```
      $ docker logs container_name
      ```

   但是，上面的日志并没有错误信息。

4. 开启错误日志

   修改下面文件：

      ```
      # display_errors = ON
      $ vim /usr/local/etc/php/php.ini
      ```

5. 重启php-fpm

   ```
   $ kill -USR2 8
   ```

   注意：8为php-fpm线程ID，重启后即可看到错误信息。

6. 如果从日志里面看不到线程号，那么可以安装ps

   ```
   $ apt-get update
   $ apt-get install procps
   ```

## 巨坑

### 注意加注释的位置

```
RUN # DEBIAN_FRONTEND=noninteractive apt-get update -q \
    # && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
    #  curl \
    #  git  \
    #  zip unzip \
    install-php-extensions \
    bcmath  \
    Core  \
    ctype  \
    curl  \
    date
```

注释要加在行首，不然此条命令将会被空执行，造成困惑。

### 关于Dockerfile切换用户

```
RUN useradd composer
USER composer
RUN php -m && ls && composer install
```

需要通过USER的方式指定，而不能在一条RUN中使用su切换用户。

### 关于Dockerfile的基准目录

Dockerfile中通过COPY来复制上层目录是不被允许的，要想实现上述操作，需要把基准目录设置为上层目录，即docker build后面跟的目录。

### 关于CMD

个 Dockerfile 只有一个 CMD 指令，若有多个，只有最后一个CMD指令生效。基础镜像中的CMD也会被你所创建的镜像的CMD给覆盖。

此部分也可参考：[Dockerfile: ENTRYPOINT和CMD的区别](https://zhuanlan.zhihu.com/p/30555962)。

## References

1. Docker官方文档：[Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
1. 博客：[Nginx 的基础内置变量 / Nginx 重写 url 的模式](https://segmentfault.com/a/1190000022499679)
1. 博客：[制作PHP镜像](https://help.aliyun.com/document_detail/348799.html)
1. 博客：[php.ini-development 与 php.ini-production](https://blog.csdn.net/wang740209668/article/details/73278221)
1. 博客：[Dockerfile: ENTRYPOINT和CMD的区别](https://zhuanlan.zhihu.com/p/30555962)