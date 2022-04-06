# ThreadLoad

ThreadLocal在java.lang包中

官方对该类的说明：

>This class provides thread-local variables. These variables differ from their normal counterparts in that each thread that accesses one (via its get or set method) has its own, independently initialized copy of the variable. ThreadLocal instances are typically private static fields in classes that wish to associate state with a thread (e.g., a user ID or Transaction ID).

Thread为每个线程维护了ThreadLocalMap这么一个Map，而ThreadLocalMap的key是LocalThread对象本身，value则是要存储的对象

ThreadLocalMap是ThreadLocal的内部类，用Entry来进行存储

调用ThreadLocal的set()方法时，实际上就是往ThreadLocalMap设置值，key是ThreadLocal对象，值是传递进来的对象

调用ThreadLocal的get()方法时，实际上就是往ThreadLocalMap获取值，key是ThreadLocal对象

**ThreadLocal本身并不存储值，它只是作为一个key来让线程从ThreadLocalMap获取value**

常用方法

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

`set(T value)`

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

```java
//Class Thread
/* ThreadLocal values pertaining to this thread. This map is maintained
     * by the ThreadLocal class. */
ThreadLocal.ThreadLocalMap threadLocals = null;
```

```java
void createMap(Thread t, T firstValue) {
      //实例化一个新的ThreadLocalMap，并赋值给线程的成员变量threadLocals
      t.threadLocals = new ThreadLocalMap(this, firstValue);
}
```

```java
//ThreadLocal的静态内部类
static class ThreadLocalMap{
  
    static class Entry extends WeakReference<ThreadLocal<?>> {
      /** The value associated with this ThreadLocal. */
      Object value;

      Entry(ThreadLocal<?> k, Object v) {
        super(k);
        value = v;
      }
    }
  
    ThreadLocalMap(ThreadLocal<?> firstKey, Object firstValue) {
      	//INITIAL_CAPACITY值为16
        table = new Entry[INITIAL_CAPACITY];
        int i = firstKey.threadLocalHashCode & (INITIAL_CAPACITY - 1);
        table[i] = new Entry(firstKey, firstValue);
        size = 1;
        setThreshold(INITIAL_CAPACITY);
    }
}
```

每个线程Thread持有一个ThreadLocalMap类型的实例threadLocals，结合此处的构造方法可以理解成每个线程Thread都持有一个Entry型的数组table，而一切的读取过程都是通过操作这个数组table完成的。

`get()`

```java
public T get() {
  	//1.获取当前线程
    Thread t = Thread.currentThread();
  	//2.根据当前线程获取ThreadLocalMap-map
    ThreadLocalMap map = getMap(t);
  	//3. 如果map不为空
    if (map != null) {
      //4. 则在map中以ThreadLocal为key在map中获取对应的value
      ThreadLocalMap.Entry e = map.getEntry(this);
      //5. 如果value不为空，则返回value
      if (e != null) {
        @SuppressWarnings("unchecked")
        T result = (T)e.value;
        return result;
      }
    }
    //6. 否则，Map为空或者e为空，通过initialValue函数获取初始值value，然后用ThreadLocal的引用和value作为firstKey和firstValue创建一个新的Map
    return setInitialValue();
}
```

```java
private T setInitialValue() {
    //通过initialValue函数获取初始值value
    T value = initialValue();
    Thread t = Thread.currentThread();
    ThreadLocalMap map = getMap(t);
    if (map != null)
      map.set(this, value);
    else
      createMap(t, value);
    return value;
}
```



ThreadLocal和Synchronized都是为了解决多线程中相同变量的访问冲突问题，不同的点是

- Synchronized是通过线程等待，牺牲时间来解决访问冲突
- ThreadLocal是通过每个线程单独一份存储空间，牺牲空间来解决冲突，并且相比于Synchronized，ThreadLocal具有线程隔离的效果，只有在线程内才能获取到对应的值，线程外则不能访问到想要的值。

当某些数据是以线程为作用域并且不同线程具有不同的数据副本的时候，就可以考虑采用ThreadLocal。



## ThreadLocal的应用

### 连接池

**最典型的是管理数据库的Connection：**当时在学JDBC的时候，为了方便操作写了一个简单数据库连接池，需要数据库连接池的理由也很简单，频繁创建和关闭Connection是一件非常耗费资源的操作，因此需要创建数据库连接池。

那么，数据库连接池的连接怎么管理呢？我们交由ThreadLocal来进行管理。为什么交给它来管理呢？ThreadLocal能够实现**当前线程的操作都是用同一个Connection，保证了事务**

```java
package cn.itcast.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Collection;

public class C3P0Utils2 {
    //获取资源
    public static DataSource dataSource = new ComboPooledDataSource();
    //将Connection与当前线程绑定
    private static ThreadLocal<Connection> local = new ThreadLocal<>();
    
    //获取连接的函数
    public static Connection getConnection(){
        //如果Connecetion为空的话
        Connection connection = local.get();
        try {
            if(connection==null){
                //获取Connection对象
                connection = dataSource.getConnection();
                //把Connection放进ThreadLocal里面
                local.set(connection);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return connection; 
    }
  
		//关闭数据库连接
    public static void closeConnection() {
        //从线程中拿到Connection对象
        Connection connection = local.get();

        try {
            if (connection != null) {
                //恢复连接为自动提交
                connection.setAutoCommit(true);

                //这里不是真的把连接关了,只是将该连接归还给连接池
                connection.close();

                //既然连接已经归还给连接池了,ThreadLocal保存的Connction对象也已经没用了
                local.remove();

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
```

### 避免一些参数传递

其实上面的例子中也是避免了connection的参数传递，只用一个closeConnection()的空参就可以将connection进行关闭（归还），但是后来我们也没怎么使用这个了，

例如我们想在BaseServlet中，写一个返回成功信息的一个方法，这个方法在最后的调用中，需要respond将这些信息返回，但是，那个方法里面又没有response对象，首先我们可以采用参数传递的方法，但是我们最外层提供的方法里面就会有一个不变的参数response，非常影响体验，那么我们可以使用ThreadLocal来避免参数传递
