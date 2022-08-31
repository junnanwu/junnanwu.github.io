# Docker基础操作

## 操作Docker

- 查看Docker状态

  ```
  $ systemctl status docker
  ```

- 启动Docker

  ```
  $ systemctl start docker
  ```

- 重启Docker

  ```
  $ systemctl restart docker
  ```

- 关闭docker 

  ```
  $ systemctl stop docker
  ```

- 查看Docker信息

  ```
  $ docker info
  ```

## 操作镜像

- 查看本地所有镜像

  ```
  $ docker images
  ```

- 从网络查找相关镜像

  ```
  $ docker search 镜像名称
  ```

- 拉取镜像

  ```
  $ docker pull mysql:5.7
  ```

  从Docker仓库下载镜像到本地，镜像名称格式为`名称:版本号`，如果版本号不指定则是最新的版本，默认从Docker Hub拉取镜像。

- 删除本地镜像

  ```
  $ docker rmi 镜像id   //i(image)
  ```

- 给镜像打标签，例如给Hello word镜像：

  ```
  $ docker images
  hello-world                     latest    feb5d9fea6a5   9 months ago    13.3kB
  ...
  ```

  打一个标签：

  ```
  $ docker tag hello-world uat-xxx:81/data/hello-world:v4
  ```

  结果：

  ```
  $ docker images
  hello-world                     latest    feb5d9fea6a5   9 months ago    13.3kB
  hello-world                     v1        feb5d9fea6a5   9 months ago    13.3kB
  ...
  ```

- 将本地镜像推送

  ```
  $ docker push hub.giao.com/hamburger/tomcat:v1.0
  ```


**查看镜像版本**

我们拉取镜像的时候，如果不指定版本，默认会拉取lastest版本，这时候我们就需要知道这个镜像有哪些版本。

当我们使用docker search来搜索官方镜像的时候，我们发现并不显示版本，我们可以通过访问如下链接来查看镜像的版本：

```
https://registry.hub.docker.com/v1/repositories/${docker_img}/tags
```

## 操作容器

- 查看正在运行的容器

  ```
  docker ps [OPTIONS]
  ```

  参数：

  - `-a --all`

    显示全部容器

  - `-q --quiet`

    仅展示容器ID

- 新建并启动容器

  格式：

  ```
  docker run [OPTIONS] IMAGE [COMMAND] [ARG...]
  ```

  参数：

  - `--name`

    给容器起一个名字。

  - `--interactive -i`

    即使没有附加也保持STDIN 打开。

  - `--detach -d`

    以后台模式运行。

  - `--tty -t`

    分配一个伪终端。

  - `--volume -v`

    绑定一个数据卷。

  - `--mount`

    将一个文件系统挂载到容器。

  - `--memory -m`

    内存限制。

  - `--publish -p`

    发布容器的端口，支持的格式有：

    - `IP:HostPort:ContainerPort`

      映射到指定地址的指定端口。

    - `IP::ContainerPort`

      映射到指定地址的任意地址。

      ` 127.0.0.1::5000`即绑定localhost的任意端口到容器的5000端口。

    - `HostPort:ContailerPort`

      本地的端口映射到容器的指定端口。

    例如：

    `80:80`

    前面的为宿主机的端口，后面为容器的端口。

  - `-e --env`

    设置环境变量。

  - `--rm`

    容器在终止后会立即删除。

  

  例如：

  - 新建mysql容器

    ```
    $ docker run -it --name=mysql mysql:5.7 /bin/bash
    ```

  - 挂载目录

    ```
    $ docker run -id --name=容器名 -v 宿主机的目录:容器的目录 镜像名:镜像版本
    ```

- 进入容器

  格式：

  ```
  docker exec [OPTIONS] CONTAINER COMMAND [ARG...]
  ```

  指在运行的容器中执行命令。

  参数：

  - `-t --tty`

    分配一个伪终端。

  - `-i --interactive`

    即使没有附加也保持STDIN 打开。

  - `-u --user=""`

    执行命令的用户名或ID。

  例如：

  进入MySQL：

  ```
  $ docker exec -it mysql /bin/bash 
  ```

- 启动容器

  ```
  $ docker start 容器名称
  ```

- 关闭容器

  ```
  $ docker stop 容器名称
  ```

- 删除容器

  如果容器是运行状态则删除失败，需要停止容器才能删除。

  ```
  $ docker rm 容器名称
  ```

- 查看容器信息

  ```
  $ docker inspect 容器名称
  ```

- 容器开机自启动

  ```
  $ docker update --restart=always 容器名|容器ID
  ```

- 查看docker占用的内存、CPU等情况

  ```
  $ docker stats
  CONTAINER ID   NAME      CPU %     MEM USAGE / LIMIT     MEM %     NET I/O     BLOCK I/O        PIDS
  46b94510d98a   mysql2    0.00%     347.4MiB / 31.26GiB   1.09%     656B / 0B   48.8MB / 247MB   38
  ```

- 查看容器日志

  ```
  docker [container] logs
  ```

  选项：

  - `-details`

    打印详细信息。

  - `-f -follow`

    持续输出。

  - `-since string`

    输出从某个时间点的日志。

  - `-tail string`

    输出最近若干条日志。

  - `-t -timestamps`

    显示时间戳信息。

  例如：

  ```
  $ docker logs -f --tail 10 kafka
  ```
