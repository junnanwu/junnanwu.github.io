# JavaSE

## 数据类型

### int和Integer的区别

1. int是基本类型，Integer是int的包装类型
2. 默认值不同，int默认值为0，Integer默认值为null
3. Integer变量实际上是对象的引用
4. Integer必须实例化后才能使用

### Integer的自动拆箱

```java
Integer i1 = new Integer(1);
Integer i2 = new Integer(1);
System.out.println(i1 == i2);
System.out.println(i1.equals(i2));
```

前者为false，后者为true；Integer重写了equals方法。

```java
Integer i1 = 1;
Integer i2 = 1;
Integer i3 = 128;
Integer i4 = 128;
System.out.println(i1 == i2);
System.out.println(i3 == i4);
```

前者为true，后者为false；Integer自动装箱时对数值在-128到127的对象放入缓存中，第二次就直接取缓存中的数据而不会new。

```java
Integer i1 = 1;
int i2 = 1;
System.out.println(i1 == i2);
```

Integer类型和int比较时，会自动拆箱，化为基本类型数据比较。

## String

### String  str =  new  String("abc") 和 String str = "abc"的区别

`String str = "abc"`是把常量池中`abc`的地址给`str`，`String  str =  new  String("abc")`是把常量池的abc地址给堆里的对象，对象的地址再给`str`。

### 字符串常量优化

```java
public class StringTest {
    @Test
    public void test01(){
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
    }
}
```

结果：

```java
s3==s4 => true
s3==s5 => false
s3==s6 => false
s3==s7 => false
s3==s8 => true
```

- `String s1 = "wu";`

  JVM去字符串常量池中寻找`wu`，存在就返回常量池中的引用，不存在就创建后返回引用。

- `String s3 = "wujunnan";`

  JVM去字符串常量池中创建`wujunnan`字符串并返回引用。

- `String s4 = "wu"+"junnan";`

  这里用到了常量优化机制，如果`=`右边的内容全部都是常量（包括final关键字修饰的常量），那么在编译时期就可以运算出右边的结果，其实际就是把右边的结果赋值给左边。

  所以会直接得到`wujunnan`字符串，然后去常量池中发现这个字符串已经存在，那么久直接返回这个字符串的地址。

- `String s5 = s1+s2;` `String s6 = s1+"junnan";`

  字符串的串联是通过StringBuilder的`append()`方法来完成的，JVM会在堆中创建一个以s1为基础的StringBuilder对象，然后调用`append()`方法，这时候s5，s6中保存的是**StringBulider对象**的地址。

- `String s7 = new String("wujunnan");`

  过程见上。

- `String s8 = s7.intern();`

  查询常量池中是否有s7这个字符串，如果有的话就返回常量池中的引用。

### StringBuilder和StringBuffer

- 可拓展

  StringBuilder和StringBuffer都继承了AbstractStringBuilder，AbstractStringBuilder内有两个非常重要的变量，分别是：

  ```
  char[] value; 
  int count;
  ```

  注意value上面并没有加final，所以是长度可变的。

- 安全性

  StringBuffer在多线程中是安全的，StringBuilder与StringBuffer自身的`append()`方法内都使用了继承自AbstractStringBuilder的`append()`方法，StringBuffer安全原因在于在`append()`方法上**使用了synchronized**关键字，而StringBuilder没有使用。

  AbstractStringBuilder的`append()`方法的具体实现：

  ```java
  public AbstractStringBuilder append(String str) {
    if (str == null)
      return appendNull();
    int len = str.length();              // 待插入的字符串的长度
    ensureCapacityInternal(count + len); // 扩容
    str.getChars(0, len, value, count);  // 将str拷贝到数组中
    count += len;    // 容器内实际容纳的字符长度 = 原有长度 + 本次新增的长度
    return this;
  }
  ```

- 拼接效率

  当String进行拼接的时候，每两个String进行拼接就会创建一个StringBuilder对象，多个String进行拼接会创建大量的对象，导致效率很低；相对于StringBuilder的`append()`方法由于没有`synchronized`关键字，所以StringBuilder的拼接效率是三者最高的。

  StringBuffer一般用于SQL语句的拼接。

  测试结果为：

  ```
  2012 millis has costed when used String.
  103 millis has costed when used StringBuffer.
  57 millis has costed when used StringBuilder.
  ```


## 集合

### ArrayList的构建、新增逻辑

当我们使用空参构造一个Arraylist，默认大小为10，每次新增的时候，会判断是否满，满了的话，会进行扩容，扩为原来的1.5倍：

```java
int newCapacity = oldCapacity + (oldCapacity >> 1);
```

### ArrayList与LinkedList的区别

- 存储结构

  - ArrayList动态数组
  - LinkedList为双向链表，不存在扩容问题

- 随机访问

  - ArrayList擅长随机访问
  - LinkedList不擅长随机访问

- 增删

  - ArrayList在增删的时候，主要耗时的是移动元素
  - LinkedList在增删的时候，主要是需要先找到位置为index的元素

  所以数据量大小、插入数据量、增删的位置都会影响增删的效率。

- 内存占用

  - ArrayList的内存浪费在不管有没有元素，都占用了分配的内存

  - LinkedList的内存消耗在于，一个节点存储了指向下一个和上一个的指针

### 什么时候使用LinkedList

在大数据量、非常靠前的位置进行增删的时候，可以选择LinkedList。

例如：

10, 000条数据，在1/10处（1000处）插入10, 000条数据，二者的时间差不多，越往后的位置插入，ArrayList越快。

所以，除了在大数据量的头部增删外，效率角度大部分场景都都是使用ArrayList（由于ArrayList的内存占用更紧密，影响缓存）。

另外LinkedList实现了Queue接口，栈、队列以及双端队列等数据结构使用LinkedList实现更简单。

### HashMap

#### HashMap如何计算槽位

jdk1.7的方式为：`(table.length - 1) & hash`，当length总是2的n次方时，`h & (length-1)`运算, 等价于对length取模，也就是`h%length`，但是&比%具有更高的效率。

jdk1.8对这方面进行了优化：`(h = k.hashCode()) ^ (h >>> 16)`，这里会使得原高位没有变化，而低16位与高16位进行了异或运算，使得低位有了高位的特征。后续在计算数据位置的时候，会通过`(length - 1) & hash`，当length长度较小的时候，只会与hash的低位进行运算，这会使得此种算法出来的槽位更加分散。

#### HashMap put步骤

1. 初始化长度默认为16的数组，负载因子为0.75，`最大节点数 = 数组length * 负载因子`
2. 通过上述方式计算槽位
3. 如果节点为空则直接插入
4. 节点不为空，则判断key是否为相同，相同则替换value值
5. 若key值不同，则判断节点是否是红黑树，如果是则插入红黑树
6. 如果不是红黑树，那向后遍历链表，如果key值一样，则替换，如果下一个节点为空，则插入新节点（也就是尾插）
7. 查看当前链表长度是否8，大于的话则把当前链表转为红黑树
8. 查看当前节点数是否达到最大节点数，是的话则扩容，即扩大为原来的2倍，`newCap = oldCap << 1`

源码如下：

```java
/hash：调用了hash方法计算hash值，key：就是我们传入的key值，value：就是我们传入的value值，onlyIfAbsent：也就是当键相同时，不修改已存在的值
  final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict) {
  //tab就是数组
  Node<K,V>[] tab; 
  //p是插入数组位置上的node
  Node<K,V> p; 
  //n为这个数组的长度，i为要插入的位置
  int n, i;
  //这一部分，先判断数组是否是空的，是的话就通过resize方法来创建一个新的数组
  if ((tab = table) == null || (n = tab.length) == 0)
    n = (tab = resize()).length;
  //第二部分，p是插入位置的node，如果是null，那么就直接插入（(n - 1) & hash 等价取模）
  if ((p = tab[i = (n - 1) & hash]) == null)
    tab[i] = newNode(hash, key, value, null);
  //第三部分，如果插入的部分不为null
  else {
    //新建一个node e
    Node<K,V> e; 
    //插入位置上的node的key
    K k;
    //第三部分第一小节, 如果你要插入数据的hash和对应位置的hash相同且key值相同
    //那么就直接使用插入的值p替换掉旧的值e,也就是key值一样，替换掉原来的
    if (p.hash == hash &&((k = p.key) == key || (key != null && key.equals(k))))
      e = p;
    //第三部分第二小节, key值不同，那么这个节点的类型是红黑树，那么就直接插入红黑树
    else if (p instanceof TreeNode)
      e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
    //第三部分第三小节，否则就是链表结构
    else {
      //遍历这个链表
      for (int binCount = 0; ; ++binCount) {     		
        //第三小节第一段，p是插入位置的node（采用尾插的方式）
        //如果这个链表p后面没有节点了(e)，意思就是这个位置只有一个，新增节点并退出循环
        if ((e = p.next) == null) {
          //那么就新建一个节点
          p.next = newNode(hash, key, value, null);
          //判断当前链表的长度是否大于阈值8，如果大于那就会把当前链表转变成红黑树
          if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
            treeifyBin(tab, hash);
          break;
        }
        //第三小节第二段，e是p后面的节点，
        //p后面有值，就是e
        //这一步跟上面一样，插入的key与e的key一样，退出循环，后面不用看了
        if (e.hash == hash &&((k = e.key) == key || (key != null && key.equals(k))))
          break;
        //第三小节第三段，将p后面的节点e给p，相当于后移了
        p = e;
      }
    }
    //第三部分第四小节
    //上一步的break，要么是新节点，要么是key一样的节点，用新的value替换旧的，并返回value
    if (e != null) { // existing mapping for key
      V oldValue = e.value;
      if (!onlyIfAbsent || oldValue == null)
        e.value = value;
      afterNodeAccess(e);
      return oldValue;
    }
  }
  ++modCount;
  //第四部分
  //size是实际存在的键值对数量
  //插入成功之后，还要判断一下实际存在的键值对数量size是否大于阈值threshold。如果大于那就开始扩容了
  if (++size > threshold)
    resize();
  afterNodeInsertion(evict);
  return null;
}
```

### HashSet

HashSet内部由HashMap实现：

```java
private static final Object PRESENT = new Object();

public HashSet() {
    map = new HashMap<>();
}

public int size() {
    return map.size();
}
public boolean isEmpty() {
    return map.isEmpty();
}

public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```

### ConcurrentHashMap

ConcurrentHashMap1.8之前采用的是分段锁技术，其中 Segment 继承于 ReentrantLock，当一个线程访问不同的Segment的时候，不会影响到其他的Segment。

由于 HashEntry 中的 value 属性是用 volatile 关键词修饰的，保证了内存可见性，所以每次获取时都是最新值。

1.8抛弃了原有的分段锁，而是采用了CAS+synchronized来保证并发安全性。

put操作的时候，利用CAS尝试进行写入，如果失败则利用synchronized锁写入数据。

https://zhuanlan.zhihu.com/p/91139880

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

不同线程有自己的ThreadLocal，可以用来线程隔离，参数传递等。

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

