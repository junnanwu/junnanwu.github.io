# Kafka入门

## Kafka概念

如果所有的消费者实例都属于相同的消费群，那么记录将有效地被均衡到每个消费者实例。

如果所有的消费者实例有不同的消费群，那么每个消息将被广播到所有的消费者进程。

## Mac测试Kafka

1. 安装

   ```
   $ brew install kafka
   ```

2. 启动zookeeper

   ```
   $ zookeeper-server-start zookeeper.properties &
   ```

   启动kafka

   ```
   $ kafka-server-start server.properties &
   ```

   使用brew

   ```
   $ brew services restart kafka
   ```

   

3. 创建一个topic

   ```
   $ kafka-topics --create --topic test-events --bootstrap-server localhost:9092
   Created topic test-events.
   ```

   查看各个参数的含义

   ```
   $ kafka-topics
   ```

   - `--create`

     创建一个新的topic

   - `--topic <String: topic>`

     要创建、修改、描述或者删除的topic，除了`--create`外，其他的也可以使用正则表达式

   - `--bootstrap-server <String: server to connect to>`

     要连接的Kafka server

4. 查看topic详情

   ```
   $ kafka-topics --describe --topic test-events --bootstrap-server localhost:9092
   Topic: test-events	TopicId: tQCHyj39TkyjMOPrprzgpA	PartitionCount: 1	ReplicationFactor: 1	Configs: segment.bytes=1073741824
   Topic: test-events	Partition: 0	Leader: 0	Replicas: 0	Isr: 0
   ```

5. 查看一共有哪些topics

   ```
   $ kafka-topics --list --bootstrap-server localhost:9092
   test-events
   ```

6. 向topic写入

   ```
   $ kafka-console-producer --topic voice-events --bootstrap-server localhost:9092
   >This is my first event
   >This is my second event
   ```

   可以使用`Ctrl+C`停止

7. 读取事件

   ```
   $ kafka-console-consumer --topic voice-events --from-beginning --bootstrap-server localhost:9092
   This is my first event
   This is my second event
   ```

   可以使用`Ctrl+C`停止
   
7. 删除topic

   ```
   $ kafka-topics --topic voice-events --delete --bootstrap-server localhost:9092
   ```
   
   当然，也可以使用正则匹配，删除`aaa`开头的topic：

   ```
   $  kafka-topics --topic "aaa.*" --delete --bootstrap-server localhost:9092
   ```

## Linux测试Kafka

1. [下载Kafka](https://kafka.apache.org/downloads)

2. 开启zookeeper

   ```
   $ bin/zookeeper-server-start.sh config/zookeeper.properties
   ```

   

3. 开启Kafka服务

   ```
   $ nohup ./kafka-server-start.sh ../config/server.properties &
   ```

   



## References

1. https://kafka.apache.org/quickstart
2. https://kafka.apache.org/intro
3. https://kafka.apache.org/documentation/
4. https://www.cnblogs.com/skzxc/p/15709493.html