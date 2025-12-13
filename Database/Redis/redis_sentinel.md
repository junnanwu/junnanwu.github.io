# Redis哨兵

Redis Sentinel（哨兵）是由一个或多个Sentinel实例组成的Sentinel系统，可以监视任意多个主从服务器，在主服务下线后，自动选举出新的主服务器。

Sentinel本质上是一个特殊模式的Redis服务器，默认会十秒一次像被监视的主服务器发送`INFO`信息，主服务会回应其本身的信息和其属下所有从服务器的信息，所以Sentinel就可以去监听从服务器的信息，同样每10秒一次向从服务器发送INFO信息。

## 判断下线状态

默认情况下，Sentinel会每秒一次的向所有与它创建了连接的实例（包括主从服务器及其他Sentinel）发送`PING`命令来判断其是否在线。

如果一个实例在`down-after-millisecends`选项指定的毫秒内，连续向Sentinel返回无效回复，那么Sentinel会认为这个实例进入主观下线状态。

当Sentinel将一个主服务器判断为主观下线之后，为了确认这个主服务器是否真的下线了，它会向同样监视这一主服务器的其他Sentinel进行询问，看它们是否也认为主服务器已经进人了下线状态。

当Sentinel从其他Sentine那里接收到足够数量的已下线判断之后，Sentine!就会将从服务器判定为客观下线，并对主服务器执行故障转移操作。

## 选举头Sentinel

当一个主服务器被判断为客观下线的时候，监视这个服务器的各个Sentinel会进行协商，选举出一个领头Sentinel，并由领头Sentinel对下线服务器进行故障转移操作。

## 故障转移

当master1的下线时间超过用户设定的下线时间的时候，Sentinel系统会对server1执行故障转移操作：

1. Sentinel系统将会挑选出一个slave服务器，称为新的master2
2. Sentinel向master1下的所有slave发送新的复制指令，让他们成为master2的从服务器
3. 继续监视master1，当其重新上线后，将它设置为master2的slave

## References

1. 《Redis设计与实现》—— 黄健宏