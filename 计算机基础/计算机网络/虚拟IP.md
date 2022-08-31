# 虚拟IP

## ARP协议

ARP协议属于TCP/IP协议族里面一种将IP地址解析为MAC地址的协议。

通常一个主机A给另一个主机B通过网络发送一个IP数据报的时候：

- 首先会发送到A所在的路由器上，然后路由器会判断地址是否在本网络内
- 是则直接转发到本网络内的目的主机
- 否则，会继续传递到下一个路由，直到到达指定的网络路由器，指定网络的路由器会将此数据报发送到目的主机。

路由器发送到网络内某一主机的过程：

- 路由器发送一个ARP广播请求，请求IP地址为数据包目的地址的主机将他的MAC地址发送过来。
- 网内的所有主机收到这个ARP请求之后，首先会检查发送ARP请求的主机的IP地址，然后将该IP地址和其对应的MAC地址存放在缓存中，然后会检查这个ARP请求中的IP地址是否为自己的IP地址，是则发送一个ARP应答，应答包含自己的IP地址和对应的MAC地址
- 路由器得到MAC地址之后，便可以将正确的数据包正确传输到目的主机上了

ARP协议中比较重要的内容之一就是ARP缓存，主机会将IP地址和MAC地址的映射关系存放在主机的高度缓存之中。

https://blog.csdn.net/u014532901/article/details/52245138

https://blog.csdn.net/samxx8/article/details/50618110

https://www.jianshu.com/p/a910e91d43a3

https://blog.csdn.net/wexiaoword/article/details/81364488



腾讯云

https://cloud.tencent.com/document/product/215/20186	