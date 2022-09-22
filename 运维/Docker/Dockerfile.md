# Dockerfile

制作镜像的两种方式，一种是将容器提交为镜像，如下命令：

```
$ docker commit 容器ID|容器名 镜像名:镜像版本
```

一种是手动编写Dockerfile，Dockerfile的主体部分分成四部分，基础镜像信息，维护着信息，镜像操作指令和容器启动时的指令。

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


## Nginx的Dockerfile

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

**创建镜像**

编写完Dockerfile之后，可以通过如下命令来创建镜像：

```
docker build [OPTIONS] PATH|URL|-
```

该命令将读取指定路径 	下的Dockerfile，并将该路径下的所有数据作为上下文发送给Docker服务，Docker在校验Dockerfile格式通过之后，逐条执行其中定义的指令，碰到ADD，COPY和RUN指令都会生成一层新的镜像，最终如果创建成功，则返回镜像的ID。

## References

1. https://docs.docker.com/engine/reference/builder/