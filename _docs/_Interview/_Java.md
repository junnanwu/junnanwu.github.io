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

- [x] `ArrayList`内部结构，新增逻辑

- [x] `ArrayList`和`LinkedList`的区别

- [x] `HashMap`的结构及put步骤

- [x] `ConcurrentHashMap`的实现方式、为什么比`HashTable`效率要高

  在jdk1.8之前，ConcurrentHashMap使用的是分段思想，其中，其中Segment继承于 ReentrantLock，当一个线程访问不同的Segment的时候，不会影响到其他的Segment，核心数据如 value ，以及链表都是 volatile 修饰的，保证了获取时的可见性。

  不会像HashTable一样，什么操作都要进行同步处理，效率低下。

  jdk1.8，ConcurrentHashMap采用了CAS+synchronized（synchronized进行了优化）来保证并发，当进行put的时候，首先采用CAS进行尝试，失败则使用synchronized进行写入。

  Guava中Cache的实现就是利用ConcurrentHashMap的思想。

- [x] 接口和抽象类的区别

- [x] 深拷贝与浅拷贝的理解

- [x] 异常的分类

- [x] 线程池执行流程和参数含义、Java提供的默认线程池及其参数、如何设置线程池大小、拒绝策略

- [x] `ThreadLocal`是如何实现的、有哪些应用

- [x] `ThreadLocal`会造成内存泄漏吗？如何避免

  `ThreadLocal`有可能会造成内存泄漏，因为ThreadLocalMap是Thread的一个属性，而Thread的生命周期是很长的，所以我们创建的TheadLocal我们不再使用，由于作为Key其是虚引用，所以下一次垃圾回收就会被回收掉，对应的key变为null，其对应的值就无法被回收，当然虚拟机已经考虑到了这种情况，每当你调用remove、get方法的时候，都会对Map中key为null的值进行清除。

  但是如果，set之后，就不再调用，也不使用remove方法进行移除，就会造成内存泄漏。

  所以，在使用ThreadLocal的时候，要注意取完值之后，进行remove操作。

- [x] `volatile`、`synchronized`分别是如何实现的

- [x] `synchronized`和`ReentrantLock`有什么区别，如何应用

  - `synchronized`加锁和释放锁的动作都是自动的，无需手动操作，`ReentrantLock`加锁和解锁都需要手动操作
  - `synchronized`不能实现公平锁，而`ReentrantLock`可以选择实现公平锁，即多个线程按照申请锁的顺序获得锁
  - `synchronized`一旦锁定就不能中断，除非执行完毕，或者抛出异常，而`ReentrantLock`可以实现中断
  - `synchronized`在线程协同方面只能通过`wait()`/`notify()`/`notifyAll()`来实现，而`ReentrantLock`可以给一个锁构建多个`condition`，在线程协作方面更加灵活。

  在效率方面，在Java初期，`synchronized`的效率较差，但是经过Java6的一系列优化，二者的效率已相差无几，所以如果用到上面说的高级功能，可以使用`ReentrantLock`，如果只是简单的加锁操作，还是推荐使用`synchronized`。

- [x] AQS是什么

  AQS即AbstractQueuedSynchronizer，抽象队列同步器，是JCU中很多锁接口都是基于AQS实现的，例如ReentrantLock。

  AbstractQueuedSynchronizer中有两个关键变量：

  一个是state，int类型，用来记录加锁的状态，初始值为0，当进行加锁的操作的时候，同过CAS操作来对state进行加1。

  另一个变量记录了哪个线程进行了加锁操作，这样当第二个线程进行加锁操作的时候，会看到第一个线程已经占用了这个锁，这个时候，线程二会将自己放到等待队列中。

  等到线程一使用完之后，会释放锁，即将state减1，直至到0，彻底释放锁。接下来从等待队列的队头唤醒线程二重新尝试加锁。

- [x] jdk对`synchronized`进行了哪些优化

- [x] `CAS`原理，有什么问题

## 虚拟机

- [x] 双亲委派模型是什么，作用是什么

- [x] JVM的内存布局，分别有什么作用

- [x] **类的加载过程**

  - 加载，将Class文件加载进内存，并创建 Class对象，将Class文件常量部分加载进运行时常量池
  - 验证，对Class文件进行验证
  - 准备，对静态变量进行初始化，赋初始值
  - 解析，将常量池中的符号引用，解析为直接饮用
  - 初始化 ，执行静态代码块，静态复制语句等

- [x] Java内存模型是什么

- [ ] 对象头都包含哪些内容

- [x] 说下Java虚拟机如何实现垃圾回收

- [x] 有哪些垃圾回收算法

  - 标记清除算法，标记已过期的对象，然后进行清除，缺点就是当大量对象死亡的时候，移动量大 ，而且产生很多内存碎片，适合老年代，CMS垃圾收集器即采用的此种算法

  - 标记复制算法，将初始区域分为两个部分，只使用其中一个部分，然后回收的时候将存活的对象复制到另一个区域，解决了上述对象大量死亡的时候，工作量大和内存碎片的问题，此种算法适合新生代使用，但是缺点就是浪费内存空间，为了解决这个问题，可以将新生代分为一块eden和两块Survial。这也是主流新生代回收器采用的算法，serial，parlNew等。

  - 标记整理算法

    标记存储下来的对象，然后进行移动，来清除内存碎片。

- [x] 什么是GC ROOT，有哪些GC ROOT

  - 栈中的对象
  - 方法区中的常量
  - 锁对象

- [x] **都有哪些垃圾回收器**

  上面提到的新生代的serial，parlNew，还有老年代的CMS。

  serial和parlNew回收的方式类似，都会暂停所有用户线程，区别是parlNew是多个线程并行进行收集。

  CMS的缺点是标记清除算法的内存碎片问题，可以指定回收多少次之后进行内存整理，优点是速度快。

  还有较新的G1回收器，他是负责整个堆内存的回收。

  G1的特点是可以指定停顿时间（200ms左右）、将内存分为不同的Region、按照收益动态的进行进行回收。

  G1局部采用的是标记-复制算法，整体上采用的标记-整理算法，都不会产生内存碎片。

  但G1实现较为复杂，在简单的应用下并不占优势，在大内存下占有优势，临界点差不多6-8G。

- [x] 引用类型有哪些

  - 强引用
  - 虚引用，OOM之前会进行清理
  - 弱引用，下一次GC进行清理，例如ThreadLoalMapkey值的引用。

- [ ] **OutOfMemory实际经历**

  - 应用页面点击没反应了
  - 先上服务器查看日志，发现日志停留在几十秒前
  - 重启应用没几十分钟，还是相同的情况。
  - 使用`ps-aux|sort`命令，发现Java服务进程内存占用非常大
  - 又通过`jstack`命令查看堆内存情况，看到FGC次数很多
  - 然后再通过`jmap`将快照保存，使用Memory-analysis工具，查看栈跟踪，发现指向同一处业务代码
  - 分析业务代码，通过员工的参数查出员工，再去商户表查出对应客户，然后遍历，返回给前端
  - 关联表查出的数据为空，这里没有判空，等于查出所有客户表，等于查询了一条300万的LIst，导致内存溢出
  - 多次请求导致产生了大量对象，新生代GC后， 内存用尽，然后使用老年代，再触发Full GC，一次Full  GC释放的内存不够，就连续多次Full GC，导致用户线程停止，请求的对象还在被引用，导致死循环一样，频繁GC

- [ ] **虚拟机优化经历**

  - 将Xmx和Xms设置为相同，类似List指定初始大小 ，避免频繁扩容
  - 当堆内存大于8G的时候，尝试指定G1作为垃圾收集器
  - 减少GC次数，Full GC不低于10分钟1次，保证新生代GC后剩下的对象不多

- [x] 什么是内存泄漏？

  即有的对象用不到了，但是也没有被垃圾回收给回收掉

- [x] 常量池的分类，作用 Spring

- [ ] IOC和AOP的理解

- [ ] JDK动态代理和CGLIB代理有什么区别

  - JDK动态代理

    基于接口实现，代码层面，通过反射来构造一个基于同一个接口的实现类。

  - CGLIB

    基于继承思想，通过修改字节码的技术生成一个继承了需要代理类的对象。

- [ ] Spring AOP和 AspectJ AOP 有什么区别

  - Spring AOP是Spring支持的面向切面AOP的编程
    - 仅支持方法执行切入点
    - 只能在运行时织入
    - SpringAOP 使用了大量AspectJ的注解和代码，比如`@Aspect`，`@Around`，`@Pointcut`注解
  - AspectJ是一个面向切面的框架
    - 支持所有切入点
    - 拥有更好的性能
    - 支持编译时，加载时织入（提供了单独的编译工具和类加载器）

- [ ] Spring启动流程

  - 初始化Spring容器
  - 注册每一个Bean的BeanDefinition到容器中
  - 按照BeanDefinition的规定进行初始化，并放入容器

- [ ] Springboot的启动流程

- [ ] **SpringBean的生命周期**

  - 首先Spring启动的时候，通过扫描注解配置等信息，例如@Scope、@Lazy、@DependsOn等信息，包装成BeanDefinition
  - 接着执行BeanFactoryPostProcessor对Bean进行实例化
  - 接下来对Bean进行属性注入，包括解决循环依赖等问题
  - 进行初始化的操作，判断Bean是否实现了Aware相关的接口，例如ApplicationContextAware接口，来获取ApplicationContext对象从而获取Spring Bean
  - 处理BeanPostProcessor，执行相关初始化方法，例如@PostConstruct、实现了InitializingBean接口的init-method方法等
  - 销毁的时候，看有没有配置相关的destroy方法

- [ ] Spring如何解决循环依赖的

  Spring是采用三级缓存的方式来解决循环依赖的，循环依赖的产生的原因是A依赖了B，当初始化A的时候，发现B还没有进行初始化，开始B的初始化，这个时候B又依赖了A，就导致了循环依赖。

  Spring有三级缓存：

  - singletonObjects

    一级缓存，用于保存实例化、注入、初始化完成的bean实例

  - earlySingletonObjects

    二级缓存，用于保存实例化完成的bean实例

  - singletonFactories

    三级缓存，用于保存bean创建工厂

  Spring的创建过程：

  - A从一级缓存中找不到实例，则创建A实例，并添加到三级缓存
  - 开始注入B，找不到B实例，则创建B实例，并添加到三级缓存，B开始依赖注入，从三级缓存获取到A，完成注入，将B添加到一级缓存
  - 开始注入A，A初始化完成之后，添加到一级缓存结束。

  https://www.zhihu.com/question/438247718/answer/1730527725

- [ ] 为何需要三级缓存，而不是两级

  第三级缓存是ObjectFactory，有时候A依赖的对象可能是有AOP代理的，我们最后注入的肯定需要时代理后的对象，二级缓存里面是初始化后的对象，肯定是不符合要求的，所以需要从三级缓存中获取Factory从而后去代理对象。

- [ ] 什么情况Spring无法解决循环依赖

  - 非单例模式

    也就是`@Scope("prototype") `，这样每次都会创建一个新的对象，不会放入缓存

  - 构造器注入

    A在构造的同时，就触发了注入B操作，此时B开始构造，而A又没有完成构造，所以无法注入。

  - @Async 类型的 AOP Bean 的循环依赖

    @Async产生的代理和普通的代理不同，所以当通过A的三级缓存来获取bean的早期引用的时候，获取到的是 bean的原始对象，而没有提前生成代理对象。

    因为二级缓存中存放的bean的早期引用，比如是最终的bean的引用是相同的。

- [ ] Spring里面用到了哪些设计模式

  - 模版方法模式

    例如JDBCTemplate，实现了抽象类中对数据源的操作，这些操作是各种JDBC都需要的共性操作，所以在父抽象类中统一进行规定。

    再例如，Hibernate中定义了模版方法HibernateCallback()，里面是对session的操作，不再是使用传统的继承的方式来实现，而是基于依赖优先于继承原则，在HibernateTemplate中用到这个模版的地方使用将Callback作为参数传入，并通过匿名类的方式来实现，减少子类的数量。

  - 代理模式

    代理模式是将真实的对象进行代理，实现一些额外的操作。

    代理模式分为静态代理和动态代理两种：

    - 静态代理

      一般需要代理者和委托者拥有同样的父类，这样代理类就可以替代委托类。

      静态代理的缺点就是需要手动编写代理对象，当有多个委托类的时候，工作量很大。

    - 动态代理

      动态代理在代理对象上更加灵活，动态代理类的字节码在运行时自动生成，简化了编程工作。

      - JDK动态代理
      - CGLIB动态代理

- [ ] SpringSecurity中用到了哪些设计模式

  - 模版方法模式

    也就是一个抽象类公开定义了执行它的方法的模版，然后通过子类去实现。

    `AbstractUserDetailsAuthenticationProvider`是用来验证的，提供了两个抽象的方法，`retrieceUser()`、`additionalAuthenticationChecks()`。

    前者用来从数据源中获取用户对象，后者用来做额外的校验。

  - 责任链模式

    在这种模式中，通常每个接收者都包含对另一个接收者的引用，如果一个对象不能处理该请求，那么它会把相同的请求传给下一个接收者，依此类推。

    例如：`VirtualFilterChain`，从`additionalFilters`取出过滤器链中的一个个过滤器 ，挨个调用`doFilter()`方法。

  - 策略模式

    通过输入来来决定使用不同的策略。

    例如，SecurityContextHolder中定义登录用户信息存储的方法，我们还可以通过他来获取Context，来获取用户信息，就SecurityContextHolder如何保存SecuritContext，定义了三种策略，用户可以自行选择使用哪一种策略。

    - MODE_THREADLOCAL，默认使用ThreadLocal实现
    - MODE_GLOBAL，表示SecurityContextHolder是全局的，所有线程都可以访问，适合单机系统
    - MODE_INHERITABLETHREADLOCAL，表示有父子关系的线程可以访问

    用户可以通过程序设置或者定义系统变量的方式来决定使用哪一种策略。

  - 代理模式

    给某一个对象提供一个代理，并由代理对象控制对原对象的引用，它是一种对象结构型模式。

    在Spring  Security中的应用就是创建过滤器的时候，使用了Spring的DelegatingFilterProxy，这个代理中保存了Spring中的容器。

    有时候我们需要实现一个过滤器，如果我们想在过滤器中使用某个bean，就会出现问题，因为filter加载完成的时候，bean还没有装配，所以filter所依赖的bean为空，我们可以用DelegatingFilterProxy来实现这个功能。

  - 适配器模式

    适配器模式使接口不兼容的类可以一起工作。

    WebSecurityConfigurerAdapter

  - 观察者模式

    Observer(观察者模式)指多个对象间存在一对多的依赖关系，当一个对象的状态发生改变时，所有依赖于它的对象都得到通知并自动更新，观察者模式也称为发布-订阅模式、模型-视图模式，它是对象行为型模式。

    具体到 Spring Security 中，如登录成功事件发布，session 销毁事件等等，都算是观察者模式。

  - 建造者模式

    AuthenticationManagerBuilder

    这个是Spring Security最核心的配置，通过他我们可以指定对哪些请求进行拦截，指定我们实现的session管理，用户管理等。

## Mysql

- [ ] Mysql索引类型有哪些，结构分别是什么
- [ ] 回表指的是什么
- [ ] 事务的ACID是什么
- [ ] 4个隔离级别是什么
- [ ] Mysql主从同步如何实现的
- [ ] Myisam和innodb的区别
- [ ] MySQL怎么保证已提交事务的数据不丢失
- [ ] MySQL的查询过程

## Redis

- [ ] Redis基本数据类型

- [ ] Redis为什么那么快

- [ ] Redis的过期删除策略是什么

  - 定期删除，每隔一定的时间，扫描进行删除
  - 惰性删除，在查询的时候，就进行删除

- [ ] Redis的持久化方式

  - RDB

    给当前数据库的问价进行备份，然后持久化。

    支持设置例如一分钟内修改若干次后就进行持久化的操作。

  - AOF

    保存执行的修改命令，类似Mysql binlog中的Statement模式，并且命令过多的时候会进行命令合并。

    此种方式会先讲命令写入缓冲区，缓冲区写入磁盘，支持awlays、everysec、no（由操作系统决定）等方式。

- [ ] 如何实现Redis的高可用

- [ ] Redis的事务了解吗

## Kafka

- [ ] 你使用Kafka的场景是什么

  - 埋点数据做流式处理，业务方发送给我们的接口平台，然后接口平台发送给Kafka，Kafka再发送给Flink，做日志的校验。
  - 电话告警，主要做一个解偶，接收业务方的通知，然后进行告警。

- [ ] 选型如何考虑的

- [x] 怎么保证消息的可靠性

  - 生产端丢失

    将ack设置为ALL，服务端收到消息，并写到所有分片上。

    设置retries次数，发送失败的采取策略进行保存。

  - 服务端丢失

    设置从机器数

    不允许没有完全同步的副本参与选举。

    设置最小副本数

  - 消费者丢失

    消费者改自动提交为手动提交。

- [ ] Kafka为什么吞吐量很大

  - 顺序写入

    虽然使用磁盘进行存储，但是顺序写入磁盘的速度还是要高于内存的随机写入的。

  - 页缓存

    也就是在操作磁盘的过程中加了一个内存缓冲。

  - 零拷贝技术

    将文件直接从磁盘拷贝到网卡，不再经由程序之手，减少了内核和用户模式之间的上下文切换。

## RabbitMQ

- [ ] 你使用MQ的场景是什么
- [ ] 怎么保证消息的可靠性
- [ ] 一直消费失败导致消息积压怎么办

## Linux

- [ ] docker


## Elasticsearch

## ClickHouse

- [ ] ClickHouse为什么块

  - 作为OLAP平台，ClickHouse有着这些平台的特点，OLAP的特点就是读取大量的行，少量的列，这就非常适合列式存储，列式存储，相同的类型的数据存储在一起，也会使得压缩率更高，IO效率更高
  - 向量化执行，采用CPU的指令，相当于将n次的for循环，转换为n个重复的操作执行一次，效果非常好
  - ClickHouse将数据划分为多个partition，通过多个CPU核心分别处理其中的一部分来实现并行数据处理。在这种设计下，单条Query就能利用整机的CPU，极致的并行处理能力
  - 分布式计算，除了优秀的单机处理能力，ClickHouse还提供了可线性拓展的分布式计算能力，ClickHouse会自动将查询拆解为多个Task下发到集群中，然后进行多机并行处理，最后把结果汇总到一起。

- [ ] ClickHouse遇到的bug

  - decimal不能和float进行运算

    ```
    #a为decimal类型
    SELECT a FROM tableA WHERE a > 1.1
    ```

    解决办法就是将1.1通过toDecimal32进行转化。

  - 某个版本复杂语句无法解析数字数字开头的字段，回退到特定版本。

## 项目

- [ ] 数仓模型是什么

  首先是离线数仓：

  - 首先是ODS（Operational Data Store，即数据运营）层，从主营等业务Mysql通过Datax将原始数据同步过来
  - 然后DWD（Data WareHouse Detail）层对数据进行初步加工，分为事实表和维度表
  - 其次是DWS（Data WareHouse Service）层对数据进一步进行加工
  - 最后是DM（Data Market）应用层，供业务和数据分析使用

  其次是实时数仓：

  - 通过CloudCanal，实时读取binlog，然后写入到ClickHouse，通过ClickHouse再进行一些事实的计算，产出大屏等准实时数据
  - 通过Maxwell获取binlog，然后发送到Kafka，再通过Flink进行实时解析，然后写入HDFS

## 计算机网络

- [ ] TCP/IP四层模型、OSI七层模型

  - 应用层（HTTP协议）
  - 传输层（TCP/UDP协议）
  - 网络层（IP协议）
  - 数据链路层

- [ ] TCP三次握手、四次挥手

  三次握手流程：

  - A请求建立连接 
  - B同意建立建立
  - A返回ack

  四次挥手：

  - A发送finish
  - B发送ack
  - B发送finish
  - A发送ack

- [ ] 浏览器请求一个网址的过程

- [ ] HTTPS的工作原理

- [ ] Reactor模型的理解

## 算法

- [ ] 几大排序算法

  - 选择排序

    遍历一边，选择一个最大的；再遍历一边，再选择一个最大的。

  - 冒泡排序

    每两个进行交换，进行一轮之后，就会选择出一个最大的，一直交换，直至最后。

  - 插入排序

    就像打牌，每来一个，都要插入已排好的顺序中。

  - 快速排序

    挑出一个元素为基准元素，将小于基准元素的放在其左边，大于基准元素的放在其右边，递归执行。

  - 归并排序

    将一个未排序的数组分成一个一个的小片段，然后再两两归并在一起，使之有序，不停的归并，最后拍成一个有序的队列。

## 其他

- [ ] 分布式锁如何设计



