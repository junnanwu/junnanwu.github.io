# MySQL高可用方案

## MHA

Master High Availability是一种一主多从的数据库高可用方案，特点是在保障高可用的前提下，保障主从数据的一致性。

MHA由两个模块构成，Manager和Node。

Manager部署在单独的服务器上，负责检查MySQL复制状态、主库状态以及执行切换操作，Node运行在每台MySQL机器上，主要负责保存和复制master binlog，识别主机宕机时各Slave差异的中继日志并将差异的事务应用到其他Slave，同时还负责清除Slave上的relay_log。

缺点：

- 实例的增减需要重启Manager
- Manager是单点，虽然有standby节点，但是不能自动切换

## Orchestrator

go编写的Mysql高可用和复制拓扑管理工具，提供了Web页面展示MySQL复制的拓扑关系及状态，支持Master异常检测，并可以通过自动或手动恢复。通过Web也能更改MySQL实例的复制关系和部分配置信息，同时提供了命令行和API接口。

相比MHA最重要的部分就是解决了管理节点的单点问题，其通过raft协议保证了自身的高可用。

缺点：

- 没有自动补偿

## HA软件

基于HA（高可用）软件，例如keepalive，对外提供一个VIP（虚拟IP）的访问入口，正常情况下VIP绑定在Master上，当Master出现故障后，将VIP漂移到Slave上，此方案的数据同步方式采用的是Mysql原生的binlog复制方式。

基于HA软件的高可用方案的特点：

- 结构简单，容易管理
- 入侵性小，对用户透明
- 依赖keepalive本身的高可用

## 大厂实践

### 网易

网易的单节点Mysql采用的是keepalived方案，采用经典的MySQL主主复制架构。

- 首先利用Master上的keepalive定时调用故障检查check脚本，发现异常后进行3次重试，重试后MySQL依然无法正常服务则触发切换
- 切换不是采用keepalive传统的降低权值的方式进行的，而是直接stop keepalive来触发slave抢占VIP，升级为主
- 升级为主后slave keepalive会调用升主检查脚本，判定relay log应用完成后才放开写，关闭read only正式提供服务

Keepalive这套方案在网易内部主要用在一些负载比较小，但是对稳定性和可靠性要求比较高的数据库，比如openresty等云计算服务的元数据库，易信朋友圈数据库，也已经在线上稳定运行了3，4年的时间（截止2017年），可以做到秒级别的切换。

## References

1. https://mp.weixin.qq.com/s/_rlHJKrYXyiXgqUEwTwS9A
2. https://mp.weixin.qq.com/s/ozTHWrwOufJZlGnQ7SoRLA
3. https://mp.weixin.qq.com/s/HS3Cit5r2K-B4adW9DIl1g
4. https://cloud.tencent.com/developer/article/1574879