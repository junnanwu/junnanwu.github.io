# Spring Kafka动态新增topic

## 场景

我们需要做一个监控告警功能，告警消费端负责识别告警topic，然后去数据库中查到这个topic对应的告警方式，并实施相应的告警。

这里就需要动态的监听topic，当新增一个告警项的时候：

- 数据库中新增一条告警项，里面是topic和对应的配置方式
- Kafka新增一个topic
- 告警消费端不需要重启也要动态的监听到新增的topic

## 通配符方式

这里通过`@KafkaListener`的`topicPattern`属性来实现。

通配符能实现动态的监听新增的topic是否符合匹配规则，并监听符合规则的topic。

内部我们异步的去消费告警信息，防止阻塞。

代码如下：

```java
@KafkaListener(topicPattern = "aaa.*", groupId = "test")
public Object listenKafkaPattern(ConsumerRecord<?, ?> record) {
    log.info("收到消息！");
    ExecutorService executorService = Executors.newCachedThreadPool();
    executorService.submit(() -> {
        try {
            log.info("消费到消息topic：{}，value: {}，offset: {} 开始处理10s", record.topic(), record.value(), record.offset());
            Thread.sleep(10 * 1000);
            log.info("消费完毕！");
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    });
    log.info("我先溜了！");
    return null;
}
```

上述代码可以监听`aaa`开头的topic，并动态监测新增的topic是否也是`aaa`开头。

## References

1. https://blog.csdn.net/qq_35457078/article/details/88838511
2. https://blog.csdn.net/songzehao/article/details/103091486