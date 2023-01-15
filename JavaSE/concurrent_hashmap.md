# ConcurrentHashMap

ConcurrentHashMap1.8之前采用的是分段锁技术，其中 Segment 继承于 ReentrantLock，当一个线程访问不同的Segment的时候，不会影响到其他的Segment。

由于 HashEntry 中的 value 属性是用 volatile 关键词修饰的，保证了内存可见性，所以每次获取时都是最新值。

1.8抛弃了原有的分段锁，而是采用了CAS+synchronized来保证并发安全性。

put操作的时候，利用CAS尝试进行写入，如果失败则利用synchronized锁写入数据。