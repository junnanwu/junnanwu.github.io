# ThreadLocal

ThreadLocal在java.lang包中，官方对该类的说明：

>This class provides thread-local variables. These variables differ from their normal counterparts in that each thread that accesses one (via its get or set method) has its own, independently initialized copy of the variable. ThreadLocal instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

该类提供线程独有的变量，此变量不同于其他变量，每个访问变量的线程都有它自己的、独立的变量副本。ThreadLocal实例通常是private static字段，可以将状态（例如用户ID、事务ID）和线程关联起来。

## 简单使用

```java
private static ThreadLocal<String> threadLocal = new ThreadLocal<>();
public static void main(String[] args) {
    threadLocal.set("test");
    System.out.println(threadLocal.get());
    threadLocal.remove();
}
```

下面是ThreadLocal的主要方法：

```java
//获取ThreadLocal的值
public T get()
//设置ThreadLocal的值
public void set(T value)
//删除ThreadLocal的值
public void romove()
//初始化Thread的值
protected T initialValue()
```

## 内部实现

下面是ThreadLocal的set方法：

```java
public void set(T value) {
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
        map.set(this, value);
    else
        createMap(t, value);
}
```

```java
ThreadLocalMap getMap(Thread t) {
  	//每一个thread中都维护了一个ThreadLocalMap
  	return t.threadLocals;
}
```

Thread为每个线程维护了ThreadLocalMap这么一个Map：

```java
public class Thread implements Runnable {
    ThreadLocal.ThreadLocalMap threadLocals = null;
    ...
}
```

所以ThreadLocal的set步骤为：

1. 取出Thread维护的变量ThreadLocalMap
2. 将ThreadLocal本身作为key，要set的内容作为value，存入map

ThreadLocalMap是ThreadLocal的内部类，内部是一个Entry数组，Entry的key是LocalThread对象本身，value则是要存储的对象。

下面我们看ThreadLocalMap的set方法：

```java
private void set(ThreadLocal<?> key, Object value) {
    // 0. 初始容量为16的数组
    Entry[] tab = table;
    int len = tab.length;
    // 1. 与HashMap类似，同取模操作，通过HashCode算出在数组中的位置i
    int i = key.threadLocalHashCode & (len-1);
	// 2. 从i开始遍历tab，直到对应位置为空，
    for (Entry e = tab[i]; e != null; e = tab[i = nextIndex(i, len)]) {
        ThreadLocal<?> k = e.get();
        // 2.1 若中间key值相等，则替换value值
        if (k == key) {
            e.value = value;
            return;
        }

        if (k == null) {
            replaceStaleEntry(key, value, i);
            return;
        }
    }
	// 3. 数组对应位置为空，则新增
    tab[i] = new Entry(key, value);
    int sz = ++size;
    // 4. 满足条件则扩容（扩大2倍）
    if (!cleanSomeSlots(i, sz) && sz >= threshold)
        rehash();
}
```

ThreadLocalMap的get方法也类似，根据Hash计算出槽位，向后遍历，直至找出key值相同的。

## 应用

### 连接池

管理数据库的Connection的时候，我们可以将其交由ThreadLocal来进行管理，ThreadLocal能够避免大量参数传递，同时保证了当前线程的操作都是用同一个Connection。

### 参数传递

有时候，将后续要用的变量存储在ThreadLocal中，后续可以直接取，而不用层层的参数传递。

### 用户相关

可以用ThreadLocal来实现Session等与用户相关的东西，由于Session是与用户绑定的，不同用户对应不同的线程，ThreadLocal又属于线程内部变量，这样就可以使用ThreadLocal来存储用户的信息。

## ThreadLocal会造成内存泄漏吗，如何避免

ThreadLocalMap是使用ThreadLocal的弱引用来作为key的，弱引用的对象会在GC中被回收。

如果一个`ThreadLocal`没有外部强引用来引用它，那么系统 GC 的时候，这个`ThreadLocal`势必会被回收，这样一来，`ThreadLocalMap`中就会出现`key`为`null`的`Entry`，就没有办法访问这些`key`为`null`的`Entry`的`value`，如果当前线程再迟迟不结束的话，这些`key`为`null`的`Entry`的`value`就会一直存在一条强引用链：`Thread Ref -> Thread -> ThreaLocalMap -> Entry -> value`永远无法回收，造成内存泄漏。

其实，`ThreadLocalMap`的设计中已经考虑到这种情况，也加上了一些防护措施：在`ThreadLocal`的`get()`,`set()`,`remove()`的时候都会清除线程`ThreadLocalMap`里所有`key`为`null`的`value`。

分配使用了`ThreadLocal`又不再调用`get()`,`set()`,`remove()`方法，那么就会导致内存泄漏。

由于`ThreadLocalMap`的生命周期跟`Thread`一样长，如果都没有手动删除对应`key`，都会导致内存泄漏，但是使用弱引用可以多一层保障：**弱引用`ThreadLocal`不会内存泄漏，对应的`value`在下一次`ThreadLocalMap`调用`set`,`get`,`remove`的时候会被清除**。

因此，`ThreadLocal`内存泄漏的根源是：由于`ThreadLocalMap`的生命周期跟`Thread`一样长，如果没有手动删除对应`key`就会导致内存泄漏，而不是因为弱引用。

所以，每次使用完`ThreadLocal`，都调用它的`remove()`方法，清除数据。

**key 使用强引用**：引用的`ThreadLocal`的对象被回收了，但是`ThreadLocalMap`还持有`ThreadLocal`的强引用，如果没有手动删除，`ThreadLocal`不会被回收，导致`Entry`内存泄漏。
