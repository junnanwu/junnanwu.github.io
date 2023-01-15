# JavaSE

## 其他 

### 接口和抽象类的区别

- 一个类只能继承一个抽象类 ，但是可以实现多个接口
- 抽象类中可以有方法实现，而接口中一般没有方法实现（Java8支持）
- 一个类要实现接口就需要实现接口的所有方法 ，而接口类实现接口不需要实现所有方法
- 接口中的实例变量默认是final的，但是抽象类中的不一定

### 浅拷贝深拷贝的理解

浅拷贝指的是将`A`对象的所有字段拷贝给`A'`对象，包括引用类型字段。

深拷贝（Deep Copy）指的是递归的将原对象的所有字段拷贝，拷贝前后的对象是完全独立的。

可以通过Apache Commons Lang包的工具类或者 Json 序列化并反序列化的方式来实现。

### 异常的分类

顶级接口Throwable，下面分为Error和Exception，Exception又有RuntimeException。

- 继承自RuntimeException的异常为运行时异常
- Exception下的其他异常被称为受检异常

## 多线程

### 线程池

#### 线程池几个参数的含义即其值

- 核心线程数
- 最大线程数
- 最大存活时间
- 队列
- 拒绝策略

#### Java默认线程池

|            | 核心线程数 | 最大线程数        | 最大存活时间 | 队列             |
| ---------- | ---------- | ----------------- | ------------ | ---------------- |
| 固定线程池 | n          | n                 | 0            | LinkedBlockQueue |
| 缓存线程池 | 0          | Integer.max_value | 60s          | SynchronousQueue |
| 单一线程池 | 1          | 1                 | 0            | LinkedBlockQueue |

#### Java线程数的选择

`(CPU_TIME/(IO_TIME + CPU_TIME))*CPU_NUM`

### ThreadLocal

#### ThreadLocal会造成内存泄漏吗，如何避免

ThreadLocalMap是使用ThreadLocal的弱引用来作为key的，弱引用的对象会在GC中被回收。

如果一个`ThreadLocal`没有外部强引用来引用它，那么系统 GC 的时候，这个`ThreadLocal`势必会被回收，这样一来，`ThreadLocalMap`中就会出现`key`为`null`的`Entry`，就没有办法访问这些`key`为`null`的`Entry`的`value`，如果当前线程再迟迟不结束的话，这些`key`为`null`的`Entry`的`value`就会一直存在一条强引用链：`Thread Ref -> Thread -> ThreaLocalMap -> Entry -> value`永远无法回收，造成内存泄漏。

其实，`ThreadLocalMap`的设计中已经考虑到这种情况，也加上了一些防护措施：在`ThreadLocal`的`get()`,`set()`,`remove()`的时候都会清除线程`ThreadLocalMap`里所有`key`为`null`的`value`。

分配使用了`ThreadLocal`又不再调用`get()`,`set()`,`remove()`方法，那么就会导致内存泄漏。

由于`ThreadLocalMap`的生命周期跟`Thread`一样长，如果都没有手动删除对应`key`，都会导致内存泄漏，但是使用弱引用可以多一层保障：**弱引用`ThreadLocal`不会内存泄漏，对应的`value`在下一次`ThreadLocalMap`调用`set`,`get`,`remove`的时候会被清除**。

因此，`ThreadLocal`内存泄漏的根源是：由于`ThreadLocalMap`的生命周期跟`Thread`一样长，如果没有手动删除对应`key`就会导致内存泄漏，而不是因为弱引用。

所以，每次使用完`ThreadLocal`，都调用它的`remove()`方法，清除数据。

**key 使用强引用**：引用的`ThreadLocal`的对象被回收了，但是`ThreadLocalMap`还持有`ThreadLocal`的强引用，如果没有手动删除，`ThreadLocal`不会被回收，导致`Entry`内存泄漏。

## 锁

### ReentantLock和synchronized的区别

- synchronized是属于JVM层面的锁，是Java关键字，ReentantLock是API层面的锁。

- synchronized 的实现涉及到锁的升级，具体为无锁、偏向锁、自旋锁、向OS申请重量级锁

  ReentrantLock实现则是通过利用CAS自旋机制保证线程操作的原子性和volatile保证数据可见性以实现锁的功能。

  

- synchronized 不需要用户去手动释放锁，synchronized 代码执行完后系统会自动让线程释放对锁的占用； ReentrantLock则需要用户去手动释放锁，如果没有手动释放锁，就可能导致死锁现象。

- synchronized为非公平锁 ReentrantLock则即可以选公平锁也可以选非公平锁，通过构造方法new ReentrantLock时传入boolean值进行选择，为空默认false非公平锁，true为公平锁。

- synchronized不能绑定； ReentrantLock通过绑定Condition结合await()/singal()方法实现线程的精确唤醒，而不是像synchronized通过Object类的wait()/notify()/notifyAll()方法要么随机唤醒一个线程要么唤醒全部线程。

  

- synchronized是不可中断类型的锁，除非加锁的代码中出现异常或正常执行完成； ReentrantLock则可以中断，可通过trylock(long timeout,TimeUnit unit)设置超时方法或者将lockInterruptibly()放到代码块中，调用interrupt方法进行中断。

- synchronzied锁的是对象，锁是保存在对象头里面的，根据对象头数据来标识是否有线程获得锁/争抢锁；ReentrantLock锁的是线程，根据进入的线程和int类型的state标识锁的获得/争抢。

### AQS是什么

AQS是java并发包的基础类，AbstractQueuedSynchronizer，抽象队列同步器。

ReentrantLock内部包含了一个AQS对象，也就是AbstractQueuedSynchronizer类型的对象。

AQS对象内部有一个核心的变量叫做state，是int类型的，代表了加锁的状态。

初始状态下，这个state的值是0。

另外，这个AQS内部还有一个关键变量，用来记录当前加锁的是哪个线程，初始化状态下，这个变量是null。

接着线程跑过来调用ReentrantLock的lock()方法尝试进行加锁，这个加锁的过程，直接就是用CAS操作将state值从0变为1。

接着线程2会看一下，是不是自己之前加的锁啊？当然不是了，**“加锁线程”**这个变量明确记录了是线程1占用了这个锁，所以线程2此时就是加锁失败。
接着，线程2会将自己放入AQS中的一个等待队列，因为自己尝试加锁失败了，此时就要将自己放入队列中来等待，等待线程1释放锁之后，自己就可以重新尝试加锁了

接着，线程1在执行完自己的业务逻辑代码之后，就会释放锁！**他释放锁的过程非常的简单**，就是将AQS内的state变量的值递减1，如果state值为0，则彻底释放锁，会将“加锁线程”变量也设置为null！

接下来，会从**等待队列的队头唤醒线程2重新尝试加锁。**

https://zhuanlan.zhihu.com/p/86072774

## 虚拟机

### 双亲委派模型

JVM采取的是双亲委派模型，如果一个类加载器收到了类加载的请求，他首先会让父加载器去加载，只有当父加载器无法加载的时候，才会尝试自己去加载。

我们常见的有这三种加载器，启动类加载器(Bootstrap ClassLoader)，拓展类加载器(Extension ClassLoader)，应用程序加载器(Application ClassLoader)

双亲委派模型的好处就是避免重复加载，覆盖核心类库。

### 类的加载过程

- 加载

  由类加载器来完成，通过类的全限定名来找到类文件，获取二进制字节流，并将字节流所代表的静态存储结构转换为方法区运行时的数据结构。

  在内存中生成一个代表这个类的`java.lang.Class`对象，作为方法区这个类的各种数据的访问入口。

- 验证

  验证Class文件的合法性

- 准备

  为类中的静态变量分配内存，并设置初始值。

- 解析

  将常量池中的符号引用，解析为直接引用。

- 初始化

  执行类构造器方法，即静态代码块，静态变量的赋值动作等。

### 都有哪些垃圾回收器

新生代：Serial、parNew

当进行垃圾回收的时候，必须暂停其他线程的工作。ParNew改进为多线程。

老年代：CMS（Concurrent Mark Sweep）

基于标记清除算法，四个步骤：

- 初始标记（GC ROOT能直接关联到的对象）
- 并发标记
- 重新标记
- 并发清除

标记清除算法，会导致大量碎片，执行完若干次GC后会进行整理。

CMS支持并发。

### G1收集器

在G1收集器出现之前的所有其他收集器，包括CMS在内，垃圾收集的目标范围要么是整个新生代(Minor GC)，要么就是整个老 年代(M ajor GC)，再要么就是整个Java堆(Full GC)。而G1跳出了这个樊笼，它可以面向堆内存任何部分来组成回收集(Collection Set，一般简称CSet)进行回收，衡量标准不再是它属于哪个分代，而是哪块内存中存放的垃圾数量最多，回收收益最大。

G1不再坚持固定大小以及固定数量的分代区域划分，而是把连续的Java堆划分为多个大小相等的独立区域(Region)，每一个Region都可以

把期望停顿时间设置为一两百毫秒或者两三百毫秒会是比较合理的。

相比CMS，G1的优点有很多，暂且不论可以指定最大停顿时间、分Region的内存布局、按收益动态确定回收集这些创新性设计带来的红利，单从最传统的算法理论上看，G1也更有发展潜力。与CMS 的“标记-清除”算法不同，G1从整体来看是基于“标记-整理”算法实现的收集器，但从局部(两个Region 之间)上看又是基于“标记-复制”算法实现，无论如何，这两种算法都意味着G1运作期间不会产生内存空间碎片，垃圾收集完成之后能提供规整的可用内存。这种特性有利于程序长时间运行，在程序为大对象分配内存时不容易因无法找到连续内存空间而提前触发下一次收集。

目前在小内存应用上CMS的表现大概率仍然要会优于G1，而在大内存应用上G1则大多能发挥其优势，这个优劣势的Java堆容量平衡点通常在6GB至8GB之间。

首先可以指定一个预期的停顿时间。然后g1会把堆划分为各个region，在回收时，它会评估每个region回收多少垃圾，需要停顿多久，尽量满足指定的停顿时间

rocketmq生产集群就指定的G1，jvm最多有2048个region。

GC的考虑指标：

- 吞吐量
- 停顿时间

两个指标是互斥的，对于后台计算任务，吞吐量优先考虑 ，对于前端Web应用型，响应时间优先考虑。

而G1最大的优势就在于**可预测的停顿时间模型**

### JVM优化

常用参数

- `-Xmx`

  memory maximum，堆的最大内存数。

- `-Xms`

  memory startup，堆的初始化大小。

- `-Xmn`

   memory nursery/new，堆中新生代大小。

- `-Xss`

  stack size，线程栈的大小。

调优

1. 当堆内存大于8G的时候，指定G1作为垃圾收集器
2. 设置堆内存的初始值和最大值相同，避免每次垃圾回收完成后JVM重新分配内存
3. 将新生代设置为堆内存的1/4或1/3

### 为什么有的程序频繁GC

- Java的堆内存太小
- 频繁创建对象，例如String字符串拼接

怎么排查：

- 开启`-XX:+PrintGCDetails`等参数

- 发现项目启动后的18秒内产生了3次`Full GC`，`-XX:MetaspaceSize=128m`提高元空间初始大小，减少GC次数

  Full GC不低于10分钟1次、Full GC执行时间不到1s

- 对比`3.266` 、`8.919`两条数据，发现年轻代的总内存大小在变大，这是由于当年轻代可用内存空间不足时不仅发生了`minor gc`还发生了堆扩容，由此可知我们设置的jvm堆初始大小`-Xms4096m`并不能满足服务启动时所需要的堆内存大小，所以应修改参数为 `-Xms8092m` 

### 内存泄漏

内存泄漏是指当对象不再使用的时候，不能被垃圾回收器给回收掉。

https://zhuanlan.zhihu.com/p/32540739

https://zhuanlan.zhihu.com/p/420345135

### OOM



## References

1. https://www.cnblogs.com/dearcabbage/p/10603460.html

