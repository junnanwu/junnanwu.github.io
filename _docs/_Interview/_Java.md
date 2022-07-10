# Java面试题

## JavaSE

- [x] `int`和`Integer`的区别

- [x] `String  str =  new  String("abc")` 和 `String str = "abc"`的区别，说出并解释下面的输出：

  ```java
  String s1 = "wu";
  String s2 = "junnan";
  String s3 = "wujunnan";
  String s4 = "wu"+"junnan";
  String s5 = s1+s2;
  String s6 = s1+"junnan";
  String s7 = new String("wujunnan");
  String s8 = s7.intern();
  //一定加括号，以免造成悲剧！
  System.out.println("s3==s4 => "+(s3==s4));
  System.out.println("s3==s5 => "+(s3==s5));
  System.out.println("s3==s6 => "+(s3==s6));
  System.out.println("s3==s7 => "+(s3==s7));      	
  System.out.println("s3==s8 => "+(s3==s8));
  ```

- [x] `StringBuilder`和`Stringbuffer`的区别

- [ ] `ArrayList`内部结构，新增逻辑

- [ ] `ArrayList`和`LinkedList`的区别

- [ ] `HashMap`的结构及put步骤

- [ ] `ConcurrentHashMap`的实现方式、为什么比`HashTable`效率要高

- [ ] 接口和抽象类的区别

- [ ] 深拷贝与浅拷贝的理解

- [ ] 异常的分类

- [ ] 线程池执行流程和参数含义、Java提供的默认参数池及其参数、如何设置线程池大小、拒绝策略

- [ ] `ThreadLocal`是如何实现的、有哪些应用

- [ ] `volatile`、`synchronized`分别是如何实现的

- [ ] `synchronized`和`ReentrantLock`有什么区别，如何应用

- [ ] `synchronized`的原理

- [ ] jdk对`synchronized`进行了哪些优化

- [ ] `CAS`原理，有什么问题

- [ ] 常量池的分类，作用

## 虚拟机

- [ ] 双亲委派模型是什么，作用是什么
- [ ] JVM的内存布局，分别有什么作用
- [ ] 新建一个对象的过程
- [ ] Java内存模型是什么
- [ ] 对象头都包含哪些内容
- [ ] 说下Java虚拟机如何实现垃圾回收
- [ ] 有哪些垃圾回收算法
- [ ] 什么是GC ROOT，有哪些GC ROOT
- [ ] 都有哪些垃圾回收器
- [ ] 引用类型有哪些
- [ ] OutOfMemory实际经历
- [ ] 虚拟机优化经历

## Spring

- [ ] Spring里面用到了哪些设计模式
- [ ] IOC和AOP的理解
- [ ] JDK动态代理和CGLIB代理有什么区别
- [ ] Spring AOP和 AspectJ AOP 有什么区别
- [ ] SpringBean的生命周期
- [ ] Spring如何解决循环依赖的

## Mysql

- [ ] Mysql索引类型有哪些，结构分别是什么
- [ ] 回表指的是什么
- [ ] 事务的ACID是什么
- [ ] 4个隔离级别是什么
- [ ] Mysql主从同步如何实现的
- [ ] Myisam和innodb的区别

## Redis

- [ ] Redis基本数据类型
- [ ] Redis为什么那么快
- [ ] Redis的过期删除策略是什么
- [ ] Redis的持久化方式
- [ ] 如何实现Redis的高可用
- [ ] Redis的事务了解吗

## Kafka

- [ ] 你使用Kafka的场景是什么
- [ ] 选型如何考虑的
- [ ] 怎么保证消息的可靠性
- [ ] Kafka为什么吞吐量很大

## RabbitMQ

- [ ] 你使用MQ的场景是什么
- [ ] 怎么保证消息的可靠性
- [ ] 一直消费失败导致消息积压怎么办

## Linux

- [ ] docker


## Elasticsearch



## 计算机网络

- [ ] TCP/IP四层模型、OSI七层模型
- [ ] TCP三次握手、四次挥手
- [ ] 浏览器请求一个网址的过程
- [ ] HTTPS的工作原理
- [ ] Reactor模型的理解

## 其他

- [ ] 分布式锁如何设计



