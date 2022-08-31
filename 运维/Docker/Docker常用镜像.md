# Docker常用镜像

## MySQL

1. 拉取镜像

   最新版本（8.0.27）

   ```
   $ docker pull mysql
   ```

   指定版本（5.7）

   ```
   $ docker pull mysql:5.7
   ```

2. 启动容器

   ```
   $ docker run --name mysql -v mysql_volume:/var/lib/mysql -p 3307:3306 -e MYSQL_ROOT_PASSWORD=123456 -d mysql
   86f4e3e0964da9336ab7b4df7eb8f5ffdf805ae620a290b58793996ae2a9b1ea
   ```

   默认创建`/var/lib/docker/volumes/mysql_volume/`数据卷。

3. 进入容器

   ```
   $ docker exec -it mysql /bin/bash
   ```

   