# ReentrantLock

Java5提供了`java.util.concurrent`包，其中提供了`Lock`接口，重入锁（`ReentrantLock`）是`Lock`接口最常见的实现。

顾名思义，它与`synchronized`一样是可重入的，另外它还提供了一些高级功能。

## 等待可中断

当持有锁的线程长期不释放锁的时候，正在等待的线程可以选择放弃等待，改为处理其他事情。可中断特性对处理执行时间非常长的同步块很有帮助。

## 公平锁

是指多个线程在等待同一个锁时，必须按照申请锁的时间顺序来依次获得锁；而非公平锁则不保证这一点，在锁被释放时，任何一个等待锁的线程都有机会获得锁。synchronized中的锁是非公平的，ReentrantLock在默认情况下也是非公平的，但可以通过带布尔值的构造函数要求使用公平锁。不过一旦使用了公平锁，将会导致ReentrantLock的性能急剧下降，会明显影响吞吐量。

## 锁绑定多个条件

是指一个`ReentrantLock`对象可以同时绑定多个`Condition`对象。在`synchronized`中，锁对象的`wait()`跟它的`notify()`或者`notifyAll()`方法配合可以实现一个隐含的条件，如果要和多于一 个的条件关联的时候，就不得不额外添加一个锁。

而`ReentrantLock`则无须这样做，多次调用`newCondition()`方法即可。

## 选择

`ReentrantLock`和`synchronized`之间如何选择？

- 在Java5之前，`synchronized`对性能影响较大，经过后续优化之后，Java6，二者性能就已持平，并且长远看，Java虚拟机更容易针对`synchronized`来进行优化，因为Java虚拟机可以在线程和对象的元数据中记录`synchronized`中锁的相关信息
- `synchronized`是在Java语法层面的同步，足够清晰，也足够简单。每个Java程序员都熟悉 `synchronized`，但J.U.C中的Lock接口则并非如此。因此在只需要基础的同步功能时，更推荐 `synchronized`
- Lock应该确保在`finally`块中释放锁，否则一旦受同步保护的代码块中抛出异常，则有可能永远不 会释放持有的锁。这一点必须由程序员自己来保证，而使用`synchronized`的话则可以由Java虚拟机来确保即使出现异常，锁也能被自动释放

