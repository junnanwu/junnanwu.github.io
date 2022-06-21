# volatile和synchronized

## 背景

### 缓存一致性

由于处理器是无法独立完成工作的，它需要和内存进行交互，例如读取运算数据，存储结果数据等， 但是处理器的运算速度要比内存的读写速度快几个数量级，这就不得不引入读写速度更快的高速缓存 (Cache) 来作为内存和处理器之间的缓冲。

这很好的解决了处理器与内存速度之间的矛盾，但是也为计算机带来了更高的复杂度，它引入了一个新问题，**缓存一致性**。

每个处理器都有自己的高速缓存，它们又共享同一主内存，当多个处理器处理同一数据的时候，它们的缓存可能存在数据不一致，那么这个时候，同步回主内存应该以哪个缓存为主呢？

为了解决缓存一致性问题，不同处理器读写时都遵循了一些协议：MSI、MESI (Intel) 等。

MESI协议保证了每个缓存中使用的共享变量的副本是一致的。它核心的思想是：当CPU写数据时，如果发现操作的变量是共享变量，即在其他CPU中也存在该变量的副本，会发出信号通知其他CPU将该变量的缓存行置为无效状态，因此当其他CPU需要读取这个变量时，发现自己缓存中缓存该变量的缓存行是无效的，那么它就会从内存重新读取。

### 指令重排

为了增加执行效率，处理器可能会对输入代码的顺序进行修改，处理器会保证修改顺序后的结果和修改之前是一致的，但是不保证程序之间的各个语句的执行顺序和代码顺序一致，那么，如果同时有另一个计算任务依赖此计算任务的中间结果，就可能出现问题。

类似的，Java虚拟机的即时编译器中也有指令重排优化。

### Java内存模型

由于不同系统底层硬件和内存访问的方式不同，Java定义了一个抽象的**Java内存模型**，具体实现由不同的虚拟机完车工，从而屏蔽系统底层的差异，Java内存模型规定如下：

> 所有的变量都存储在主内存 (Main Memory) 中，每条线程有自己的工作内存，线程的工作内存中保存了被该线程使用的变量的主内存副本，线程对变量的所有操作(读取、赋值等)都必须在工作内存中进行，而不能直接读写主内存中的数据。不同的线程之间也无法直接访问对方工作内存中的变量，线程间变量值的传递均需要通过主内存来完成。

也就是说将上述高速缓存，内存抽象为了主内存和工作内存。

Java内存模型还规定了一些基本的原子操作：

- `lock`

  作用于主内存的变量，它把一个变量标识为一条线程独占的状态。

- `unlock`

  作用于主内存的变量，它把一个处于锁定状态的变量释放出来，释放后的变量才可以被其他线程锁定。

- `read`

  作用于主内存的变量，它把一个变量的值从主内存传输到线程的工作内存中，以便随后的load动作使用。

- `load`

  作用于工作内存的变量，它把read操作从主内存中得到的变量值放入工作内存的变量副本中。

- `use`

  作用于工作内存的变量，它把工作内存中一个变量的值传递给执行引擎，每当虚拟机遇到一个需要使用变量的值的字节码指令时将会执行这个操作。

- `assign`

  作用于工作内存的变量，它把一个从执行引擎接收的值赋给工作内存的变量，每当虚拟机遇到一个给变量赋值的字节码指令时执行这个操作。

- `store`

  作用于工作内存的变量，它把工作内存中一个变量的值传送到主内存中，以便随后的write操作使用。

- `write`

  作用于主内存的变量，它把store操作从工作内存中得到的变量的值放入主内存的变量中。

Java内存模型还规定了在执行上述8种基本操作时必须满足如下规则：

- 不允许read和load、store和write操作之一单独出现，即不允许一个变量从主内存读取了但工作内存不接受，或者工作内存发起回写了但主内存不接受的情况出现。
- 不允许一个线程丢弃它最近的assign操作，即变量在工作内存中改变了之后必须把该变化同步回主内存。
- 不允许一个线程无原因地(没有发生过任何assign操作)把数据从线程的工作内存同步回主内存中。
- 一个新的变量只能在主内存中“诞生”，不允许在工作内存中直接使用一个未被初始化 (load或assign)  的变量，换句话说就是对一个变量实施use、store操作之前，必须先执行assign和load操作。
- ...

## volatile

Java提供了volatile关键字来保证可见性，当一个共享变量被volatile修饰时

### 可见性

即当一个线程修改了这个变量，新值对于其他线程来说是可以立即得知的。

而普通变量被修改后则需要向主内存进行回写，另一个线程再进行读取操作，新变量的值才会对其可见。

但是volatile不能保证原子性，当不符合下面两条规则的场景中，我们还是需要加锁：

1. 运算结果并不依赖当前变量的值，或者只有单一线程能修改变量的值
2. 变量不需要其他的状态变量参与

所以类似下面场景，适合使用volatile：

当`shutdown()`方法被调用时，能保证所有线程的`doWork()`方法都停下来。

```java
volatile boolean shutdownRequested;
public void shutdown(){
	shutdownRequested = true;
}

public void doWork(){
    while (!shutdownRequested){
        //...
    }
}
```

### 有序性

使用volatile变量的第二个语义是禁止指令重排序优化。

问题复现：

```java
Map configOptions;
char[] configText;
// 此变量必须定义为volatile
volatile boolean initialized = false;

// 假设以下代码在线程A中执行
// 模拟读取配置信息，当读取完成后
// 将initialized设置为true,通知其他线程配置可用 configOptions = new HashMap();
configText = readConfigFile(fileName); processConfigOptions(configText, configOptions); initialized = true;

// 假设以下代码在线程B中执行
// 等待initialized为true，代表线程A已经把配置信息初始化完成 
while (!initialized) {
	sleep(); 
}
// 使用线程A中初始化好的配置信息 
doSomethingWithConfig();
```

假设A线程中`initialized=true`被提前执行，那么线程B此时就无法获取到正确的配置信息，volatile则可以解决此类问题。

观察加入volatile关键字和没有加入volatile关键字时所生成的汇编代码发现，加入volatile关键字时，会多出一个lock前缀指令

lock前缀指令实际上相当于一个内存屏障，内存屏障会提供3个功能：

1. 它确保指令重排序时不会把其后面的指令排到内存屏障之前的位置，也不会把前面的指令排到内存屏障的后面
2. 它会强制将对缓存的修改操作立即写入主存
3. 如果是写操作，它会导致其他CPU中对应的缓存行无效

**volatile实现**

通过对比发现，关键变化在于有volatile修饰的变量，赋值后(前面`mov%eax，0x150(%esi)`这句便是赋值操作)多执行了一个`"lock addl$0x0，(%esp)"`操作，这个操作的作用相当于一个内存屏障，指重排序时不能把后面的指令重排序到内存屏障之前的位置，只有一个处理器访问内存时，并不需要内存屏障；但如果有两个或更多处理器访问同一块内存，且其中有一个在观测另一个，就需要内存屏障来保证一致性了。

这句指令中的`addl$0x0, (%esp )`（把ESP寄存器的值加0）显然是一个空操作，之所以用这个空操作而不是空操作专用指令nop，是因为IA32手册规定lock前缀不允许配合nop指令使用。这里的关键在于lock前缀，查询IA32手册可知，它的作用是将本处理器的缓存写入了内存，该写入动作也会引起别的处理器或者别的内核无效化(Invalidate)其缓存，这种操作相当于对缓存中的变量做了一次前面介绍Java内存模式中所说的`store`和`write`操作。所以通过这样一个空操作，可让前面volatile变量的修改对其他处理器立即可见。

## synchronized

### 原子性

当多个线程读写共享变量时，由于线程可以在任何指令处暂停，会导致数据不一致的问题。

例如：

加线程和减线程分别对共享变量num加10000次和减10000次，但结果却总不为0，如下所示：

```java
public class SynchronizedTest {
    public static void main(String[] args) throws InterruptedException {
        AddThread addThread = new AddThread();
        SubtractThread subtractThread = new SubtractThread();
        addThread.start();
        subtractThread.start();
        addThread.join();
        subtractThread.join();
        System.out.println("测试结束，num为: " + Counter.num);
    }
}

class Counter {
    public static int num = 0;
}

class AddThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            Counter.num++;
        }
    }
}

class SubtractThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            Counter.num--;
        }
    }
}
```

结果为：

```
测试结束，num为: 1784
```

这是因为`num++`即`n = n + 1`这条语句实际上执行了3条指令：

```
ILOAD
IADD
ISTORE
```

我们假设`n`的值是`100`，如果两个线程同时执行`n = n + 1`，得到的结果很可能不是`102`，而是`101`，原因在于：

```ascii
┌───────┐    ┌───────┐
│Thread1│    │Thread2│
└───┬───┘    └───┬───┘
    │            │
    │ILOAD (100) │
    │            │ILOAD (100)
    │            │IADD
    │            │ISTORE (101)
    │IADD        │
    │ISTORE (101)│
    ▼            ▼
```

如果线程1在执行`ILOAD`后被操作系统中断（volatile能保证此时n是最新的），此刻如果线程2被调度执行，它执行`ILOAD`后获取的值仍然是`100`，最终结果被两个线程的`ISTORE`写入后变成了`101`，而不是期待的`102`。

疑问，上面说到volatile会导致其他核缓存失效，那么为啥Thread2的`ISTORE (101)`操作之后，Thread1的缓存副本100没有失效？



这说明多线程模型下，要保证逻辑正确，对共享变量进行读写时，必须保证一组指令以原子方式执行：即某一个线程执行时，其他线程必须等待：

```
┌───────┐     ┌───────┐
│Thread1│     │Thread2│
└───┬───┘     └───┬───┘
    │             │
    │-- lock --   │
    │ILOAD (100)  │
    │IADD         │
    │ISTORE (101) │
    │-- unlock -- │
    │             │-- lock --
    │             │ILOAD (101)
    │             │IADD
    │             │ISTORE (102)
    │             │-- unlock --
    ▼             ▼
```

通过加锁和解锁的操作，就能保证3条指令总是在一个线程执行期间，不会有其他线程会进入此指令区间。

Java程序使用`synchronized`关键字对一个对象进行加锁，但是由于`synchronized`代码块无法并发执行，且加上额外的加锁和解锁操作，所以`synchronized`会造成性能损失。

我们将上面的案例使用`synchronized`改写如下：

```java
public class SynchronizedTest {
    public static void main(String[] args) throws InterruptedException {
        AddThread addThread = new AddThread();
        SubtractThread subtractThread = new SubtractThread();
        addThread.start();
        subtractThread.start();
        addThread.join();
        subtractThread.join();
        System.out.println("测试结束，num为：" + Counter.num);
    }
}

class Counter {
    public static final Object lock = new Object();
    public static int num = 0;
}

class AddThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            synchronized (Counter.lock) {
                Counter.num++;
            }
        }
    }
}

class SubtractThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 10000; i++) {
            synchronized (Counter.lock) {
                Counter.num--;
            }
        }
    }
}
```

这样输出的num就总是0了。注意在上述例子中，`synchronized`锁的应该是同一对象。

## 先行发生原则

如果Java内存模型中所有的有序性都仅靠volatile和synchronized来完成，那么有很多操作都将会变得非常啰嗦，Java有一个先行发生原则，通过此原则，我们不需要陷入Java内存模型复杂的定义之中，就可以判断数据是否存在竞争。

如果两个操作之间的关系不在此列，并且无法从下列规则推导出 来，则它们就没有顺序性保障，虚拟机可以对它们随意地进行重排序。

- 程序次序规则

  按照程序控制，在前面的操作先行发生于在后面的操作

- 管程锁定规则

  一个unlock操作先行发生于后面（时间上）对同一个锁的lock操作

  （synchronized）

- volatile变量规则

  对一个volatile变量的写操作先行发生于后面对这个变量的读操作

- 线程启动规则

  Thread对象的start()方法先行发生于此线程的每一个动作

- 线程终止规则

  线程中的所有操作都先行发生于对此线程的终止检测

- 线程中断规则

  对线程`interrupt()`方法的调用先行发生于被中断线程的代码检测到中断事件的发生，可以通过`Thread::interrupted()`方法检测到是否有中断发生

- 对象终结规则

- 传递性

  如果操作A先行发生于操作B，操作B先行发生于操作C，那就可以得出 操作A先行发生于操作C的结论

## References

1. 《深入理解Java虚拟机》
1. https://www.liaoxuefeng.com/wiki/1252599548343744/1306580844806178