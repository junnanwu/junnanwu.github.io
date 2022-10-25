# Docker遇到的问题

## 修改Docker默认目录

Docker默认的数据目录是在`/var/lib/docker`，但是有时候根目录下的分区很小，所以需要修改Docker的默认目录。

可以通过如下步骤进行修改：

1. 查看当前docker默认目录

   ```
   # docker info|grep Root
   Docker Root Dir: /var/lib/docker
   ```

2. 关闭所有容器

3. 关闭docker

   ```
   # systemctl stop docker
   ```

4. 复制docker目录

   假设复制到`/data/docker`目录下：

   ```
   # cp -rp /var/lib/docker /data/
   ```

5. 修改docker配置文件

   ```
   # vim /etc/docker/daemon.json
   ```

   加入如下配置：

   ```json
   {
     "graph": "/data/docker",
     (其他配置)...
   }
   ```

   注意：

   这里看到网上有说在docker 19.xx 版本以后使用`data-root`来代替`graph`，我用docker 20.10.10版本，使用`data-root`之后，images和container并没有加载上，使用`graph`反而可以。

6. 重启开启docker

   ```
   # systemctl start docker
   ```

7. 再次查看默认目录

   ```
   # docker info｜ grep Root
   Docker Root Dir: /data/docker
   ```

8. 发现之前的镜像、容器都还在，完成迁移

## 容器时区

问题：docker日志时间比正常时间慢8个小时

```
root@9cdee1317100:/# date
Thu Dec 17 07:32:57 UTC 2020
```

UTC为标准时间，为格林威治时间。

原因：宿主机设置了时区，但是Docker容器并未设置时区

解决：

- 运行容器时指定时区 

  ```
  $ docker run -d -p 5672:5672 -p 15672:15672 -v /etc/timezone:/etc/timezone:ro -v /etc/localtime:/etc/localtime:ro  --name rabbitmq rabbitmq:management
  ```

  之后显示时间是正常的，这时候就是中国时间CST了，即东八区

  ```
  $ date
  Thu Dec 17 15:37:31 CST 2020
  ```

- 修改Dockerfile文件，在里面设置时区

  ```
  ENV TZ=Asia/Shanghai
  ```

## Docker IPV4转发问题

WARNING: IPv4 forwarding is disabled. Networking will not work.

没有开启转发，网桥配置完后，需要开启转发，不然容器启动后，就会没有网络，配置`/etc/sysctl.conf`,添加`net.ipv4.ip_forward=1`

```
$ vim /etc/sysctl.conf

#配置转发
#检查系统设置，打开IPv4转发
net.ipv4.ip_forward=1

#重启网卡，让配置生效
systemctl restart network

#查看是否成功,如果返回为“net.ipv4.ip_forward = 1”则表示成功

sysctl net.ipv4.ip_forward
```

## References