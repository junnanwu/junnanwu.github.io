# Linux网络带宽监控工具

## nload

nload可以监控**不同的网络**设备的带宽使用情况。

### 安装

（使用Cent OS）

```
$ sudo yum install epel-release
$ sudo yum install nload
```

### 使用

格式：

```
nload [options] [devices]
```

例如：

- 查看所有设备

  ```
  $ nload
  ```

  ![image-20211229215208218](Linux%E5%B8%A6%E5%AE%BD%E7%9B%91%E6%8E%A7%E5%B7%A5%E5%85%B7_assets/use_of_nload.png)

  可以使用左右键切换设备。

- 查看特定设备

  ```
  $ nload eth0
  ```

参数：

- `-m`

  一次查看多个设备

  ```
  $ nload -m
  ```

  ![image-20211229213318112](Linux%E5%B8%A6%E5%AE%BD%E7%9B%91%E6%8E%A7%E5%B7%A5%E5%85%B7_assets/use_of_nload-m.png)

## iftop

> iftop: display bandwidth usage on an interface by host.

iftop就像top命令监测CPU一样监测网络，它根据接口列出了每个主机的带宽使用情况。

### 安装

（使用Cent OS）

```
$ sudo yum install iftop
```

### 使用

例如：

```
$ sudo iftop
```

![image-20211229215945856](Linux%E5%B8%A6%E5%AE%BD%E7%9B%91%E6%8E%A7%E5%B7%A5%E5%85%B7_assets/use_of_iftop.png)

含义：

- TX：发送流量
- RX：接收流量
- TOTAL：总流量
- Cumm：运行iftop到目前时间的总流量
- peak：流量峰值
- rates：分别表示过去 2s 10s 40s 的平均流量

References

1. https://www.ex-parrot.com/pdw/iftop/