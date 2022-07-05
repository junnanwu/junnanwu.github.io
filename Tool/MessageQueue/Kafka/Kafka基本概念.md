# Kafka基本概念

Kafka中的Topic 被分成了若干分区，每个分区在同一时间只被一个consumer消费



https://mp.weixin.qq.com/s/2L901M5fUNvlU70TBGCGyQ

```
感觉作者写的acks=all 和 min.insync.replicas > 1 冲突啊，只能有一个生效

min.insync.replicas 表示ISR集合中的最少副本数，默认值是1，并只有在acks=all或-1时才有效,我们知道leader副本默认就包含在ISR中，如果ISR中只有1个副本，acks=all也就相当于acks=1了，引入min.insync.replicas的目的就是为了保证下限：不能只满足于ISR全部写入，还要保证ISR中的写入个数不少于min.insync.replicas。
常见的场景是创建一个三副本（即replication.factor=3）的topic，最少同步副本数设为2（即min.insync.replicas=2），acks设为all，以保证最高的消息持久性。
```

```
消息丢失，要从每个环节(Producer/Broker/Consumer)逐步分析.
1.Producer端消息丢失，需要消息生产者自行处理； 建议的应对策略如下：
1.1 尽量使用带有回调通知(CallBack)的send()方法；
1.2 设置acks=all;
1.3 为规避一定程度上的网络抖动问题，可以设置一定的重试次数(此设置仅用于自动重试，无法确保消息一定能发送成功)。
2. Broker端的消息丢失，需要Kafka集群管理员处理；
建议的应对策略如下：
2.1 创建topic时，设置副本数>1 (使用参数 replication-factor 设置合理的副本数 建议使用3副本);
2.2 禁用unclean leader参与主副本选举，可设置参数 unclean.leader.election.enable=false ；
2.3 设置ISR最小数量 > 1，可设置参数 min.insync.replicas = n (N >=2, 通常建议 min.insync.replicas 稍小于 topic的副本数。比如 副本数=3，min.insync.replicas=2。)
3. 消费者端的消息丢失，需要消息消费者自行处理； 建议的应对策略如下：
3.1 禁用自动提交消费位移，由消费者自行处理位移提交的时机。可设置参数 enable.auto.commit=false；
3.2 若需要独占所有分区的消息，注意groupID不能重复。
3.3 使用默认的latest策略消费消息，当topic扩容(增加分区数量)，Producer先于Consumer感知分区数的变更，部分消息被发送至新增的分区中，Consumer在感知到新增分区时会发生Reblance，当Reblance结束后新的分区消费方案下发至消费者组中的各个消费成员，被分配到新增分区的消费者成员直接从最新位移除开始消费消息(这类场景就会造成新增分区的部分数据丢失)。 tips: 此类场景比较极端，但有可能发生。
```

