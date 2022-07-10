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

### LocalThread

不同线程有自己的LocalThread，可以用来线程隔离，参数传递等。

## 锁

## References

1. https://www.cnblogs.com/dearcabbage/p/10603460.html

