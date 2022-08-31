# docker-compose

docker-compose是docker官方的开源项目，使用python编写，用来定义和运行多个Docker容器。

docker-compose使用YAML文件对容器进行管理。

对于docker-compose有两个基本的概念：

- 服务（service）：一个docker容器
- 项目（project）：由一组关联的应用容器组成的一个完整的业务单元

## 配置文件

```yml
# 指定 compose 文件的版本，必写
version: '2'
# 定义所有的 service 信息, 必写
# 镜像名称或镜像ID。如果镜像在本地不存在，Compose 将会尝试拉取这个镜像。
services:
    image         
    restart: always # 容器总是重新启动。
    container_name # 容器名
    volumes       # 挂载，可用于挂载配置文件，data等
    command       # 容器内执行什么命令
    ports         # 对外暴露的端口
    environment   # 添加环境变量
    network_mode  # 设置网络连接模式
    
volumes:

```

- image

  指定启动容器的镜像，可以是镜像仓库/标签或者镜像id。

  如果镜像不存在，Compose将尝试从官方镜像仓库将其pull下来。

- container_name

  自定义容器的名称。

- volumes

  卷挂载地址

  如果要跨多个服务并重用挂载卷，需要在顶级volumes关键字中命名挂载卷。

- command

  覆盖容器启动后默认执行的命令，类似dockerfile

- ports

  暴露端口信息

  ```yml
  ports:
   - "3000"
   - "3000-3005"
   - "8000:8000"
   - "9090-9091:8080-8081"
   - "49100:22"
   - "127.0.0.1:8001:8001"
   - "127.0.0.1:5000-5010:5000-5010"
  ```

  

## 常用命令

- 构建启动容器

  ```
  docker-compose up [options] [--scale SERVICE=NUM...] [SERVICE...]
  ```

  参数：

  - `-d --detach`

    以后台的形式运行。

  - `--no-recreate`

    如果容器存在，则不再重复创建。

  - `--force-recreate`

    重新创建容器

  默认当容器的配置或者镜像发生变化的时候，会停止并删除之前的容器重新创建，之前容器的数据卷还会保存。



## References

1. https://zhuanlan.zhihu.com/p/51055141