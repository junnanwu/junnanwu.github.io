# Redis集群

## 节点

一个节点就是一个服务器，Redis服务器在启动的时候会通过`cluster-enabled`配置来选择是否开启服务器的集群模式。

节点与单机服务器在数据库方面的一个区别就是，节点只能使用0号服务器，而单机Redis则没有这一限制。

**主节点与从节点**

Redis集群的节点分为主节点（master）和从节点（slave），其中主节点用于储存分片，而从节点用于复制某个主节点，并在对应主节点下线时，代替下线的主节点继续处理命令请求。

例如，对于7000、7001、7002、7003四个主节点的集群来说，我们可以将7004和7005两个节点添加到集群，并设置为7000的从节点。

那么四个主节点则负责分片存储数据，7004节点和7005节点则复制7000节点。

如果7000节点进入下线状态，那么仍在 运行的几个主节点将在7004和7005中选出一个节点作为主节点，这个新的节点将接管原来7000负责处理的槽，并继续处理客户端发送的命令请求。

在故障转移完成后，下线的节点7000重新上线，它将成为7004的从节点。

## 槽位（slot）

集群的整个数据库被分为16384个槽（slot），数据库中的每个键都属于这16384个槽中的一个。

每个节点有个16284bit的数组，如果slots数组在索引i上的二进制为1，那么表示节点负责处理槽位。

当客户端向节点发送与数据库键相关的命令的时候，接收命令的节点会通过下面命令计算出命令要处理的数据库数据哪个槽：

```
CRC16(key) & 16383
```

通过CRC16计算出散列值，然后取模16383，即可算出槽位，算出槽位之后，检查这个槽是否指派给了自己，如果指派给了自己，则该节点就执行此命令，如果没有指派给自己，那么节点会向客户端返回一个`MOVED`错误，客户端会重定向到正确的节点。

## 增加节点

新加节点时，只需要向新节点A发送如下命令：

```
CLUSTER MEET ip port
```

`ip`和`host`是任意一个 节点的地址和端口号，A接收到命令之后，会与该地址和 端口的节点进行握手，即加入集群。

新加的节点有两种选择：

- 使用`CLUSTER REPLICATE`成为从数据库

- 向集群申请槽位来以主数据库来运行

  可以通过Redis-trib.rb来实现插槽的迁移。

## 故障检测

集群中的每个节点都会定期向集群中的其他节点发送`PING`消息，以此来检测对方是否在线，如果未在规定的时间内收到`PONG`，那么这个节点被标记为疑似下线。

集群中的各个节点会通过相互发送消息来交换集群中各个节点的状态信息。

当一个集群中，半数以上主节点都将某个主节点报告为疑似下线，那么这个主节点将被标记为已下线状态，并向集群广播，所有收到消息的节点都会把该节点标记为下线状态。

## 故障转移

当一个从节点发现自己正在复制的主节点进人了已下线状态时，从节点将开始对下线主节点进行故障转移，以下是故障转移的执行步骤:

- 复制下线主节点的所有从节点里面，会有一个从节点被选中

- 新的主节点会撤销所有对已下线主节点的槽指派，并将这些槽全部指派给自己

- 新的主节点向集群广播一条PONG消息

  这条PONG消息可以让集群中的其他节点立即知道这个节点已经由从节点变成了主节点，并且这个主节点已经接管了原本由已下线节点负 责处理的槽。

- 新的主节点开始接收和自己负责处理的槽有关的命令请求，故障转移完成

## References

1. 《Redis设计与实现》—— 黄健宏
1. 《Redis入门指南》——李子骅