# ThreadLoad

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
