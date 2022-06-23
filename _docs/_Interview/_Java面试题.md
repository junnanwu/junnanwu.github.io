# Java面试题

## 数据结构

### 几大排序算法

```
选择排序
	遍历一边，找出最大的，然后再遍历，找出最大的...
	实现：外层for:(i=0,i<arr.length-1,i++) 即从第一个到倒数第二个
			  内层for:(j=i+1,j<arr.length,j++) 即从外for循环的最后一个的后一个到，数组最后一个
	特点就是每次也会出现一个最大的，时间复杂度都是O(n*n)
冒泡排序
	相邻的两个进行比较，大的话就放在右边，这样一轮下来就会有一个最大的了
	外层for循环:(i=1,i<arr.length,i++)从第一个到
	内层for循环:(j=0,i<arr.length-i,j++)
							if (arr[j] > arr[j + 1])
插入排序
	就像打牌，前面的都是有序的，后面的每个都按顺序插入到前面的对应位置上
	
快速排序
	操作步骤就是先挑出一个元素，为基准元素，将比基准元素小的都放在基准元素左边，其他的放在右边，然后递归的进行此过程
快速排序的最坏运行情况是 O(n²)，比如说顺序数列的快排。但它的平摊期望时间是 O(nlogn)，且 O(nlogn) 记号中隐含的常数因子很小，比复杂度稳定等于 O(nlogn) 的归并排序要小很多。所以，对绝大多数顺序性较弱的随机数列而言，快速排序总是优于归并排序。

归并排序
将一个未排序的数组从中间分开为两部分，然后再分为四部分，然后一直分割下去，直到分割为一个一个小的数据，再俩俩归并在一起，使之有序，不停的归并，最后成为一个拍好序的队列
归并排序和选择排序一样，归并排序的性能不受输入数据的影响，但表现比选择排序好的多，因为始终都是O(nlogn）的时间复杂度。代价是需要额外的内存空间。
```

#### 选择排序

```java
//选择排序
public class SelectionSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

        // 总共要经过 N-1 轮比较
        for (int i = 0; i < arr.length - 1; i++) {
            int min = i;

            // 每轮需要比较的次数 N-i
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[j] < arr[min]) {
                    // 记录目前能找到的最小值元素的下标
                    min = j;
                }
            }

            // 将找到的最小值和i位置所在的值进行交换
            if (i != min) {
                int tmp = arr[i];
                arr[i] = arr[min];
                arr[min] = tmp;
            }

        }
        return arr;
    }
}
```

#### 冒泡排序

```java
public class BubbleSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝，不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

        for (int i = 1; i < arr.length; i++) {
            // 设定一个标记，若为true，则表示此次循环没有进行交换，也就是待排序列已经有序，排序已经完成。
            boolean flag = true;

            for (int j = 0; j < arr.length - i; j++) {
                if (arr[j] > arr[j + 1]) {
                    int tmp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = tmp;

                    flag = false;
                }
            }

            if (flag) {
                break;
            }
        }
        return arr;
    }
}
```

#### 插入排序

```java
public class InsertSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝，不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

        // 从下标为1的元素开始选择合适的位置插入，因为下标为0的只有一个元素，默认是有序的
        for (int i = 1; i < arr.length; i++) {

            // 记录要插入的数据
            int tmp = arr[i];

            // 从已经排序的序列最右边的开始比较，找到比其小的数
            int j = i;
            while (j > 0 && tmp < arr[j - 1]) {
                arr[j] = arr[j - 1];
                j--;
            }

            // 存在比其小的数，插入
            if (j != i) {
                arr[j] = tmp;
            }

        }
        return arr;
    }
}
```

#### 归并排序

```java
public class MergeSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝，不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

        if (arr.length < 2) {
            return arr;
        }
        int middle = (int) Math.floor(arr.length / 2);

        int[] left = Arrays.copyOfRange(arr, 0, middle);
        int[] right = Arrays.copyOfRange(arr, middle, arr.length);

        return merge(sort(left), sort(right));
    }

    protected int[] merge(int[] left, int[] right) {
        int[] result = new int[left.length + right.length];
        int i = 0;
        while (left.length > 0 && right.length > 0) {
            if (left[0] <= right[0]) {
                result[i++] = left[0];
                left = Arrays.copyOfRange(left, 1, left.length);
            } else {
                result[i++] = right[0];
                right = Arrays.copyOfRange(right, 1, right.length);
            }
        }

        while (left.length > 0) {
            result[i++] = left[0];
            left = Arrays.copyOfRange(left, 1, left.length);
        }

        while (right.length > 0) {
            result[i++] = right[0];
            right = Arrays.copyOfRange(right, 1, right.length);
        }

        return result;
    }

}
```

#### 快速排序

```java
public class QuickSort implements IArraySort {

    @Override
    public int[] sort(int[] sourceArray) throws Exception {
        // 对 arr 进行拷贝，不改变参数内容
        int[] arr = Arrays.copyOf(sourceArray, sourceArray.length);

        return quickSort(arr, 0, arr.length - 1);
    }

    private int[] quickSort(int[] arr, int left, int right) {
        if (left < right) {
            int partitionIndex = partition(arr, left, right);
            quickSort(arr, left, partitionIndex - 1);
            quickSort(arr, partitionIndex + 1, right);
        }
        return arr;
    }

    private int partition(int[] arr, int left, int right) {
        // 设定基准值（pivot）
        int pivot = left;
        int index = pivot + 1;
        for (int i = index; i <= right; i++) {
            if (arr[i] < arr[pivot]) {
                swap(arr, i, index);
                index++;
            }
        }
        swap(arr, pivot, index - 1);
        return index - 1;
    }

    private void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

}
```

#### Java中排序怎么办

```
Arrays.sort是插入排序+快速排序+归并排序

Collections.sort(stringList);

对象类型的怎么排序
Collections.sort(studentList, new StudentComparator());

import java.util.Comparator;
public class StudentComparator implements Comparator<Student> {

    @Override
    public int compare(Student o1, Student o2) {
        // TODO Auto-generated method stub
        return o1.name.compareTo(o2.name);
    }
}
```



## JavaSE

## 集合

### List相关

#### 数组怎么转为集合

```
1. 使用原生类型，for循环遍历，一个一个添加
2. 使用Arrays.asList()
		List<String> resultList= new ArrayList<>(Arrays.asList(array));
		注意：调用Arrays.asList()时，其返回值类型是ArrayList，但此ArrayList是Array的内部类，调用add()时，会报错：java.lang.UnsupportedOperationException，并且结果会因为array的某个值的改变而改变，故需要再次构造一个新的ArrayList。
3. Collections.addAll()
	List<String> resultList = new ArrayList<>(array.length);
	Collections.addAll(resultList,array);
```

#### Vector和ArrayList有啥区别

```
ArrayList不同，Vector中的操作是线程安全的
Vector与ArrayList一样，也是通过数组实现的，不同的是它支持线程的同步，即某一时刻只有一个线程能够写Vector，跟HashTable差不多，访问它比访问ArrayList慢

ArrayList和Vector的扩展数组的大小不同
ArrayList在内存不够时默认是扩展1.5倍，Vector默认扩容当前容量的两倍
Vector属于线程安全级别的，但是大多数情况下不使用Vector，因为线程安全需要更大的系统开销
```

#### 听说过CopyOnWriteArrayList么,它为什么性能比ArrayList好

```
CopyOnWriteArrayList这是一个ArrayList的线程安全的变体，其原理大概可以通俗的理解为:初始化的时候只有一个容器，很长一段时间，这个容器数据、数量等没有发生变化的时候，大家(多个线程)，都是读取(假设这段时间里只发生读取的操作)同一个容器中的数据，所以这样大家读到的数据都是唯一、一致、安全的，但是后来有人往里面增加了一个数据，这个时候CopyOnWriteArrayList 底层实现添加的原理是先copy出一个容器(可以简称副本)，再往新的容器里添加这个新的数据，最后把新的容器的引用地址赋值给了之前那个旧的的容器地址，但是在添加这个数据的期间，其他线程如果要去读取数据，仍然是读取到旧的容器里的数据。

CopyOnWrite容器主要是多线程环境下保证线程安全, 并通过读写分离提高性能
　　
在添加的时候是需要加锁的，否则多线程写的时候会Copy出N个副本出来。
final ReentrantLock lock = this.lock;
lock.lock();

CopyOnWrite容器只能保证数据的最终一致性，不能保证数据的实时一致性。所以如果你希望写入的的数据，马上能读到，请不要使用CopyOnWrite容器
```

[CopyOnWriteArrayList详解](https://www.cnblogs.com/myseries/p/10877420.html)

### Set相关

```
HashSet底层数据结构采用哈希表实现，元素无序且唯一，线程不安全，效率高，可以存储null元素，元素的唯一性是靠所存储元素类型是否重写hashCode()和equals()方法来保证的，如果没有重写这两个方法，则无法保证元素的唯一性。

具体实现唯一性的比较过程：存储元素首先会使用hash()算法函数生成一个int类型hashCode散列值，然后已经的所存储的元素的hashCode值比较，如果hashCode不相等，则所存储的两个对象一定不相等，此时存储当前的新的hashCode值处的元素对象；如果hashCode相等，存储元素的对象还是不一定相等，此时会调用equals()方法判断两个对象的内容是否相等，如果内容相等，那么就是同一个对象，无需存储；如果比较的内容不相等，那么就是不同的对象，就该存储了，此时就要采用哈希的解决地址冲突算法，在当前hashCode值处类似一个新的链表， 在同一个hashCode值的后面存储存储不同的对象，这样就保证了元素的唯一性。
```

[java集合超详解](https://blog.csdn.net/feiyanaffection/article/details/81394745)

#### Hashmap和Hashtable的区别

```
Hashtable是遗留类，很多映射的常用功能与HashMap类似，它是线程安全的，任一时间只有一个线程能写Hashtable，并发性不如ConcurrentHashMap，因为ConcurrentHashMap引入了分段锁。Hashtable不建议在新代码中使用，不需要线程安全的场合可以用HashMap替换，需要线程安全的场合可以用ConcurrentHashMap替换。
```

#### 讲讲CurrentHashMap

```
如果需要考虑到线程安全问题，那么我们可以选择使用Collections.synchronizedMap(Map)创建线程安全的map集合，Hashtable和ConcurrentHashMap，不过ConcurrentHashMap的性能和效率明显高于前两者。

HashEntry跟HashMap差不多的，但是不同点是，他使用volatile去修饰了他的数据Value还有下一个节点next。

jdk1.7

ConcurrentHashMap采用了分段锁技术

jdk 1.8
其中抛弃了原有的Segment分段锁，而采用了CAS + synchronized来保证并发安全性
跟HashMap很像，也把之前的HashEntry改成了Node，但是作用不变，把值和next采用了volatile去修饰，保证了可见性，并且也引入了红黑树，在链表大于一定值的时候会转换（默认是8）

CAS是乐观锁的一种实现方式，是一种轻量级锁，JUC 中很多工具类的实现就是基于 CAS 的。

CAS操作的流程，线程在读取数据时不进行加锁，在准备写回数据时，比较原值是否修改，若未被其他线程修改则写回，若已被修改，则重新执行读取流程。

这是一种乐观策略，认为并发操作并不总会发生。

根据key计算出 hashcode 。
判断是否需要进行初始化。
即为当前 key 定位出的 Node，如果为空表示当前位置可以写入数据，利用CAS尝试写入，失败则自旋保证成功。
如果当前位置的 hashcode == MOVED == -1,则需要进行扩容。
如果都不满足，则利用 synchronized 锁写入数据。
如果数量大于 TREEIFY_THRESHOLD 则要转换为红黑树。
```

### 异常相关

#### 线程有几种状态

```
//这个是Thread类内部的一个内部枚举
public enum State {
	NEW,
	RUNNABLE,
	BLOCKED,
	WAITING,
	TIMED_WAITING,
	TERMINATED;
}
初始状态(NEW)：
实现Runnable接口和继承Thread可以得到一个线程类，new一个实例出来，线程就进入了初始状态

就绪状态(RUNNABLE之READY)
该状态下的线程已经获得执行所需的所有资源，只要CPU分配执行权就能运行。
所有就绪态的线程存放在就绪队列中。

运行中状态(RUNNABLE之RUNNING)
获得CPU执行权，正在执行的线程。
由于一个CPU同一时刻只能执行一条线程，因此每个CPU每个时刻只有一条运行态的线程。

阻塞状态(BLOCKED)
阻塞状态就是拿不到锁，会放入一个阻塞队列中，由一个阻塞队列存放所有阻塞态的线程，处于阻塞态的线程会不断请求资源，一旦请求成功，就会进入就绪队列(READY)，等待执行。

等待(WAITING)
处于这种状态的线程不会被分配CPU执行时间，它们要等待被显式地唤醒，否则会处于无限期等待的状态。
当前线程中调用wait、join、park函数时，当前线程就会进入等待态。
也有一个等待队列存放所有等待态的线程。
线程处于等待态表示它需要等待其他线程的唤醒才能继续运行。
进入等待态的线程会释放CPU执行权，并释放资源（如：锁）


超时等待(TIMED_WAITING)
处于这种状态的线程不会被分配CPU执行时间，不过无须无限期等待被其他线程显示地唤醒，在达到一定时间后它们会自动唤醒。
它和等待态一样，并不是因为请求不到资源，而是主动进入，并且进入后能够自动唤醒，不需要其他线程唤醒；
与等待态的区别：到了超时时间后自动进入阻塞队列，开始竞争锁。
进入该状态后释放CPU执行权 和 占有的资源。

终止状态(TERMINATED)
当线程的run()方法完成时，或者主线程的main()方法完成时，我们就认为它终止了。这个线程对象也许是活的，但是它已经不是一个单独执行的线程。线程一旦终止了，就不能复生。
在一个终止的线程上调用start()方法，会抛出java.lang.IllegalThreadStateException异常。

有资源有执行权：运行态
有资源无执行权：就绪态
无资源无执行权：阻塞态（会一直请求资源）
主动释放资源和执行权，不设置超时时间，需要被唤醒：等待态
主动释放资源和执行权，设置超时时间，能自动唤醒：超时等待态
```

JVM会为一个使用内部锁（synchronized）的对象维护两个集合，**Entry Set**和**Wait Set**，也有人翻译为锁池和等待池，意思基本一致。

对于Entry Set：如果线程A已经持有了对象锁，此时如果有其他线程也想获得该对象锁的话，它只能进入Entry Set，并且处于线程的BLOCKED状态。

对于Wait Set：如果线程A调用了wait()方法，那么线程A会释放该对象的锁，进入到Wait Set，并且处于线程的WAITING状态。

还有需要注意的是，某个线程B想要获得对象锁，一般情况下有两个先决条件，一是对象锁已经被释放了（如曾经持有锁的前任线程A执行完了synchronized代码块或者调用了wait()方法等等），二是线程B已处于RUNNABLE状态。

对于Entry Set中的线程，当对象锁被释放的时候，JVM会唤醒处于Entry Set中的某一个线程，这个线程的状态就从BLOCKED转变为RUNNABLE。

对于Wait Set中的线程，当对象的notify()方法被调用时，JVM会唤醒处于Wait Set中的某一个线程，这个线程的状态就从WAITING转变为RUNNABLE；或者当notifyAll()方法被调用时，Wait Set中的全部线程会转变为RUNNABLE状态。所有Wait Set中被唤醒的线程会被转移到Entry Set中。

#### 关于多线程的几个方法

```
Thread.sleep(long millis)，
当前线程调用此方法，当前线程进入TIMED_WAITING，(超时等待)状态，但不释放对象锁，millis后线程自动苏醒进入就绪状态。
线程被放入超时等待队列。

obj.wait()，当前线程调用对象的wait()方法，当前线程释放对象锁，进入等待队列(WAITING)。
wait()方法会释放CPU执行权和占有的锁。

wait和notify必须配套使用，即必须使用同一把锁调用；
wait和notify必须放在一个同步块中

obj.notify()唤醒在此对象监视器上等待的单个线程，选择是任意性的。notifyAll()唤醒在此对象监视器上等待的所有线程。
当对象的notify()方法被调用时，JVM会唤醒处于Wait Set中的某一个线程，这个线程的状态就从WAITING转变为RUNNABLE；或者当notifyAll()方法被调用时，Wait Set中的全部线程会转变为RUNNABLE状态。

yield()方法仅释放CPU执行权，锁仍然占用，线程会被放入就绪队列，会在短时间内再次执行。
```

#### Threadloca介绍一下，有应用吗？

```
ThreadLocal提供了线程的局部变量，每个线程都可以通过set()和get()来对这个局部变量进行操作，但不会和其他线程的局部变量进行冲突，实现了线程的数据隔离

我的理解是主要用于避免参数传递，比如我们想要一个线程内操作的变量是同一个的时候，不同方法就需要通过形参进行传递，但是我们可以利用Threadlocal，只需要通过set() get()方法就可以进行存取，就不需要写那么多的形参来传递参数。
```

### 线程同步问题

#### 如何实现线程同步，怎么解决多线程问题

```
synchronized
```

#### 说说多线程的各种锁

```
synchronized
synchronized机制是给共享资源上锁，只有拿到锁的线程才可以访问共享资源，这样就可以强制使得对共享资源的访问都是顺序的。
锁的内存语义：

当线程释放锁时，JMM会把该线程对应的本地内存中的共享变量刷新到主内存中
当线程获取锁时，JMM会把该线程对应的本地内存置为无效。从而使得被监视器保护的临界区代码必须从主内存中读取共享变量。

使用synchronized修饰的代码具有原子性和可见性，在需要进程同步的程序中使用的频率非常高，可以满足一般的进程同步要求。
synchronized实现的机理依赖于软件层面上的JVM，因此其性能会随着Java版本的不断升级而提高。
到了Java1.6，synchronized进行了很多的优化，有适应自旋、锁消除、锁粗化、轻量级锁及偏向锁等，效率有了本质上的提高。在之后推出的Java1.7与1.8中，均对该关键字的实现机理做了优化。
最后，尽管Java实现的锁机制有很多种，并且有些锁机制性能也比synchronized高，但还是强烈推荐在多线程应用程序中使用该关键字，因为实现方便，后续工作由JVM来完成，可靠性高。只有在确定锁机制是当前多线程程序的性能瓶颈时，才考虑使用其他机制，如ReentrantLock等。

ReentrantLock
可重入锁，顾名思义，这个锁可以被线程多次重复进入进行获取操作。
ReentantLock继承接口Lock并实现了接口中定义的方法，除了能完成synchronized所能完成的所有工作外，还提供了诸如可响应中断锁、可轮询锁请求、定时锁等避免多线程死锁的方法。
Lock实现的机理依赖于特殊的CPU指定，可以认为不受JVM的约束，并可以通过其他语言平台来完成底层的实现。在并发量较小的多线程应用程序中，ReentrantLock与synchronized性能相差无几，但在高并发量的条件下，synchronized性能会迅速下降几十倍，而ReentrantLock的性能却能依然维持一个水准。
因此我们建议在高并发量情况下使用ReentrantLock。

ReentrantLock引入两个概念：公平锁与非公平锁。

公平锁指的是锁的分配机制是公平的，通常先对锁提出获取请求的线程会先被分配到锁。反之，JVM按随机、就近原则分配锁的机制则称为不公平锁。

ReentrantLock在构造函数中提供了是否公平锁的初始化方式，默认为非公平锁。这是因为，非公平锁实际执行的效率要远远超出公平锁，除非程序有特殊需要，否则最常用非公平锁的分配机制。

使用ReentrantLock必须在finally控制块中进行解锁操作
Lock lock = new ReentrantLock();
try {
     lock.lock();
     //…进行任务操作5 
}finally {
    lock.unlock();
}

上述两种锁机制类型都是"互斥锁"

```

#### synchronized和lock锁的区别

```
1. 首先synchronized是java内置关键字，是jvm层面，Lock是个java类，是jdk层面；
2. synchronized无法判断是否获取锁的状态，Lock可以判断是否获取到锁；
3.synchronized会自动释放锁，Lock需在finally中手工释放锁（unlock()方法释放锁），否则容易造成线程死锁；
4.Lock锁适合大量同步的代码的同步问题，synchronized锁适合代码少量的同步问题。
ReentrantLock还可以实现公平锁机制, 就是谁排队时间最长谁先执行获取锁。
```

#### 锁升级的原理

```
锁升级原理
一开始是无锁的状态，一上来会先去判断一下有没有锁，有锁的话最开始的时候锁是支持偏向锁的。偏向锁当前获取到锁资源的这个线程，我会优先让他再去获取这个锁，如果它没获取到这个锁，就升级为一个轻量级的，一个cas锁，即乐观锁，乐观锁的时候它是一个比较和交换的过程，如果没有设置成功的话，它会进行一个自旋，然后自旋到一定次数之后才会升级成一个synchronized的这样一个重量级的锁，这样的话他就保证了性能的问题。
```

#### CAS的原理

```
CAS，Conmpare And Swap，英文翻译过来就是"比较和交换"。它的过程是3步，第一步是读值，第二步比较值，看值和自己刚刚读的一不一样，第3步是修改，如果值跟自己读的一样，就修改。
CAS的bug是会出现的问题 ABA 空循环。如果要解决ABA 问题，可以使用AtomicStampedReference类, 它内部用类似创建版本号的方式来解决 ABA 问题。

乐观锁是一种思想，即认为读多写少，遇到并发写的可能性比较低，所以采取在写时先读出当前版本号，然后加锁操作（比较跟上一次的版本号，如果一样则更新），如果失败则要重复读-比较-写的操作。
CAS是一种更新的原子操作，比较当前值跟传入值是否一样，一样则更新，否则失败。
```

#### AQS是什么

```

```

#### 如何让线程交替打印AB

```
使用一个标记值flag，然后
public class Test {
    public static void main(String[] args) {
        final PrintAB print = new PrintAB();
        new Thread(new Runnable() {
            public void run(){
                for(int i=0;i<5;i++) {
                    print.printA();
                }
            }
        }).start();
        new Thread(new Runnable() {
            public void run() {
                for(int i=0;i<5;i++) {
                    print.printB(); }
            }
        }).start();
    }
}
class PrintAB{
    private boolean flag = true;
    public synchronized void printA () {
        while(!flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            } }
        System.out.print("A");
        flag = false;
        this.notify();
    }
    public synchronized void printB () {
        while(flag) {
            try {
                this.wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        System.out.print("B");
        flag = true;
        this.notify(); }
}
```

#### 如何让线程交替打印ABC

```
Synchronized同步的方法

思路就是每个人拿着自己和上一个线程的锁，例如A线程：c,a; B线程：a,b; C线程 b,c;
然后我们调用的时候，先让a执行，保证初始的这个顺序
然后A先判断是否持有外部锁synchronized (prev) { 
然后判断是否持有自身锁synchronized (self) {
都持有的话就执行打印，然后计数
唤醒B线程竞争self a锁
self代码块执行完毕，然后self a锁释放
这时候a和b锁没有被使用，那么B线程即可运行
占用a,b
然后A的外部代码块调用prev.wait()这时候释放c锁
即可完成这个顺序

但是刚开始就必须按照ABC这个顺序进行调用

public class ABC_Synch {
    public static class ThreadPrinter implements Runnable {
        private String name;
        private Object prev;
        private Object self;

        private ThreadPrinter(String name, Object prev, Object self) {
            this.name = name;
            this.prev = prev;
            this.self = self;
        }

        @Override
        public void run() {
            int count = 10;
            while (count > 0) {// 多线程并发，不能用if，必须使用whil循环
                synchronized (prev) { // 先获取 prev 锁
                    synchronized (self) {// 再获取 self 锁
                        System.out.print(name);// 打印
                        count--;

                        self.notifyAll();// 唤醒其他线程竞争self锁，注意此时self锁并未立即释放。
                    }
                    // 此时执行完self的同步块，这时self锁才释放。
                    try {
                        if (count == 0) {// 如果count==0,表示这是最后一次打印操作，通过notifyAll操作释放对象锁。
                            prev.notifyAll();
                        } else {
                            prev.wait(); // 立即释放 prev锁，当前线程休眠，等待唤醒
                        }
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public static void main(String[] args) throws Exception {
        Object a = new Object();
        Object b = new Object();
        Object c = new Object();
        ThreadPrinter pa = new ThreadPrinter("A", c, a);
        ThreadPrinter pb = new ThreadPrinter("B", a, b);
        ThreadPrinter pc = new ThreadPrinter("C", b, c);

        new Thread(pa).start();
        Thread.sleep(10);// 保证初始ABC的启动顺序
        new Thread(pb).start();
        Thread.sleep(10);
        new Thread(pc).start();
        Thread.sleep(10);
    }
}
```

```
Lock锁方法
我们通过一个自增的state的值来确定是否打印，例如ThreadA，里面的run方法来一个for循环(不控制i++)，我们可以在先上锁，然后判断while (state % 3 == 0),是的话就打印A, state++; i++; 然后在finally中解锁

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class ABC_Lock {
    private static Lock lock = new ReentrantLock();// 通过JDK5中的Lock锁来保证线程的访问的互斥
    private static int state = 0;//通过state的值来确定是否打印

    static class ThreadA extends Thread {
        @Override
        public void run() {
            for (int i = 0; i < 10;) {
                try {
                    lock.lock();
                    while (state % 3 == 0) {// 多线程并发，不能用if，必须用循环测试等待条件，避免虚假唤醒
                        System.out.print("A");
                        state++;
                        i++;
                    }
                } finally {
                    lock.unlock();// unlock()操作必须放在finally块中
                }
            }
        }
    }

    static class ThreadB extends Thread {
        @Override
        public void run() {
            for (int i = 0; i < 10;) {
                try {
                    lock.lock();
                    while (state % 3 == 1) {// 多线程并发，不能用if，必须用循环测试等待条件，避免虚假唤醒
                        System.out.print("B");
                        state++;
                        i++;
                    }
                } finally {
                    lock.unlock();// unlock()操作必须放在finally块中
                }
            }
        }
    }

    static class ThreadC extends Thread {
        @Override
        public void run() {
            for (int i = 0; i < 10;) {
                try {
                    lock.lock();
                    while (state % 3 == 2) {// 多线程并发，不能用if，必须用循环测试等待条件，避免虚假唤醒
                        System.out.print("C");
                        state++;
                        i++;
                    }
                } finally {
                    lock.unlock();// unlock()操作必须放在finally块中
                }
            }
        }
    }

    public static void main(String[] args) {
        new ThreadA().start();
        new ThreadB().start();
        new ThreadC().start();
    }
}
```



#### 说说锁的分类

```
公平锁/非公平锁
公平锁是指多个线程按照申请锁的顺序来获取锁。
对于Java ReentrantLock而言，通过构造函数指定该锁是否是公平锁，默认是非公平锁。非公平锁的优点在于吞吐量比公平锁大。
对于synchronized而言，也是一种非公平锁。由于其并不像ReentrantLock是通过AQS的来实现线程调度，所以并没有任何办法使其变成公平锁。

可重入锁
可重入锁又名递归锁，是指在同一个线程在外层方法获取锁的时候，在进入内层方法会自动获取锁。
对于Java ReentrantLock而言, 其名字是Re entrant Lock即是重新进入锁。对于synchronized而言，也是一个可重入锁。可重入锁的一个好处是可一定程度避免死锁。
synchronized void setA() throws Exception{
    Thread.sleep(1000);
    setB();
}
synchronized void setB() throws Exception{
    Thread.sleep(1000);
}
上面的代码就是一个可重入锁的一个特点，如果不是可重入锁的话，setB可能不会被当前线程执行，可能造成死锁。

独享锁/共享锁
独享锁是指该锁一次只能被一个线程所持有；共享锁是指该锁可被多个线程所持有。
对于Java ReentrantLock而言，其是独享锁。但是对于Lock的另一个实现类ReadWriteLock，其读锁是共享锁，其写锁是独享锁。读锁的共享锁可保证并发读是非常高效的，读写、写读 、写写的过程是互斥的。独享锁与共享锁也是通过AQS来实现的，通过实现不同的方法，来实现独享或者共享。对于synchronized而言，当然是独享锁。

互斥锁/读写锁
上面说到的独享锁/共享锁就是一种广义的说法，互斥锁/读写锁就是具体的实现。互斥锁在Java中的具体实现就是ReentrantLock；读写锁在Java中的具体实现就是ReadWriteLock。

乐观锁/悲观锁
悲观锁：总是假设最坏的情况，每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，这样别人想拿这个数据就会阻塞直到它拿到锁。比如Java里面的同步原语synchronized关键字的实现就是悲观锁。
乐观锁：顾名思义，就是很乐观，每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在更新的时候会判断一下在此期间别人有没有去更新这个数据，可以使用版本号等机制。乐观锁适用于多读的应用类型，这样可以提高吞吐量，在Java中java.util.concurrent.atomic包下面的原子变量类就是使用了乐观锁的一种实现方式CAS(Compare and Swap 比较并交换)实现的。

分段锁
分段锁其实是一种锁的设计，并不是具体的一种锁，对于ConcurrentHashMap而言，其并发的实现就是通过分段锁的形式来实现高效的并发操作，ConcurrentHashMap中的分段锁称为Segment，它即类似于HashMap（JDK7与JDK8中HashMap的实现）的结构，即内部拥有一个Entry数组，数组中的每个元素又是一个链表；同时又是一个ReentrantLock（Segment继承了ReentrantLock)。当需要put元素的时候，并不是对整个HashMap进行加锁，而是先通过hashcode来知道他要放在那一个分段中，然后对这个分段进行加锁，所以当多线程put的时候，只要不是放在一个分段中，就实现了真正的并行的插入。但是，在统计size的时候，就是获取HashMap全局信息的时候，就需要获取所有的分段锁才能统计。
分段锁的设计目的是细化锁的粒度，当操作不需要更新整个数组的时候，就仅仅针对数组中的一项进行加锁操作。

偏向锁/轻量级锁/重量级锁
这三种锁是指锁的状态，并且是针对synchronized。在Java 5通过引入锁升级的机制来实现高效synchronized。这三种锁的状态是通过对象监视器在对象头中的字段来表明的。
偏向锁是指一段同步代码一直被一个线程所访问，那么该线程会自动获取锁。降低获取锁的代价。
轻量级锁是指当锁是偏向锁的时候，被另一个线程所访问，偏向锁就会升级为轻量级锁，其他线程会通过自旋的形式尝试获取锁，不会阻塞，提高性能。
重量级锁是指当锁为轻量级锁的时候，另一个线程虽然是自旋，但自旋不会一直持续下去，当自旋一定次数的时候，还没有获取到锁，就会进入阻塞，该锁膨胀为重量级锁。重量级锁会让其他申请的线程进入阻塞，性能降低。

自旋锁
在Java中，自旋锁是指尝试获取锁的线程不会立即阻塞，而是采用循环的方式去尝试获取锁，这样的好处是减少线程上下文切换的消耗，缺点是循环会消耗CPU。
```

Java SE 1.6为了减少获得锁和释放锁带来的性能消耗，引入了“偏向锁”和“轻量级锁”：锁一共有4种状态，级别从低到高依次是：无锁状态、偏向锁状态、轻量级锁状态和重量级锁状态



## 设计模式

### 单例模式

首先我们讲一下需求，什么时候需要单例设计模式？

正常情况下，当我们创建对象的时候，每次创建的对象都是不同的对象，现在我们每次创建对象，只想创建一个对象，也就是单例对象，那么我们就用到了单例设计模式。

至于怎么实现，思路很简单，核心思想就是将构造方法私有化，在类内部创建一个静态方法`getInstance()`来获取同一个静态的对象，具体实现方式，就有两种思路，就是我们所说的饿汉式和懒汉式。

饿汉式，就是很饿，二话不说，不管你有没有调用，我先创建个对象来吃，先在类内部new一个私有静态对象，你调用`getInstance()`方法的时候，我就把这个对象给你return回去，这样就实现了每次调用`getInstance()`方法返回的都是同一个对象。

然后是懒汉式，就是很懒，抽一下鞭子动一下，所以它不会提前创建好对象，会先定义一个类的引用变量p，当你调用`getInstance()`方法的时候，会先判断p变量是否为null，为null的话就new一个对象给这个静态变量p，如果不为null的话就直接把p给return。

优劣，饿汉式，提前创建好对象，浪费了内存，但是不存在多线程问题，懒汉式由于存在一个判断和new这两个步骤，就存在多线程问题，线程A检测到p为null，准备new的时候，线程B也去检测了p，然后A和B分别new了不同的对象给了引用变量p，会导致创建的对象不止一个，所以懒汉式虽然节省了内存，但是还需要解决多线程问题。

总结，所以当你的静态对象的构建并不复杂的时候，推荐使用饿汉式，当构建过程耗时较长的时候，推荐使用懒汉式。

### 动态代理



## JVM

### Java内存模型

Java的内存结构：

- 多线程共享的内存内存

  - 堆((Java Heap)

    此区域的唯一目的就是为了存放对象实例，Java堆是垃圾回收管理的区域，在物理上可以处于不连续的内存，但是在逻辑上应该是连续的，我们可以通过配置文件分配堆得内存大小，当Java堆满的时候，会抛出`OutOfMemoryError`异常

  - 方法区(Method Area)

    储存已被虚拟机加载的类信息，常量，静态变量，通过反射获取到的类型、方法名、字段名称、访问修饰符等信息就是从方法区获取到的

    方法区因为总是存放不会轻易改变的内容，故又被称之为“永久代”，在方法区中，常量池有运行时常量池和Class文件常量池

    - 运行时常量池

      是方法区的一部分，Class文件中有一部分是常量池，这个常量池是具有动态性的，并不一定只有编译的时候才会产生常量，运行时常量池的内存区域Java虚拟机规范没有做出要求，不同提供商可以自己来实现

- 线程独享的内存

  - 程序计数器(Program Counter Register)

    这个是一个较小的内存，是当前线程所执行的字节码的行号指示器，记录的是正在执行的虚拟机字节码指令的地址。

  - Java栈(Java Stack)

    也叫本地虚拟机栈，我们通常说的栈，就是这个虚拟机栈

    Java栈中存放的是一个个的栈帧，每个栈帧对应一个被调用的方法，在栈帧中包括**局部变量**表(Local Variables)、操作数栈(Operand Stack)、指向当前方法所属的类的运行时常量池的引用(Reference to runtime constant pool)、方法返回地址(Return Address)和一些额外的附加信息。

    当线程执行一个方法时，就会随之创建一个对应的栈帧，并将建立的栈帧压栈。当方法执行完毕之后，便会将栈帧出栈。　

  - 本地方法栈(Native Method Stacks)

    与栈类似，只不过是为了为虚拟机用到本地方法服务

堆和栈的区别：

- 功能上

   基本数据类型的变量（int、short、long、byte、float、double、boolean、char等）以及对象的引用变量，其内存分配在栈上， 变量出了作用域就会自动释放

- 线程私有方面

  栈内存属于线程私有的，每个线程都会有一个栈内存，其储存的变量只在其所属线程可见

- 空间大小

  - 栈的内存要远远小于堆内存，栈的深度是有限制的，如果递归没有及时跳出，很可能发生`StackOverFlowError`问题
  - Xms选项可以设置堆的开始时的大小，Xmx选项可以设置堆的最大值

线程安全的本质：

线程安全本质是由于多个线程对同一个堆内存中的Count变量操作的时候，每一个线程会在线程内部创建这个堆内存Count变量的副本，线程内所有的操作都是对这个Count副本进行操作。这时如果其他线程操作这个堆内存Count变量,改变了Count值对这个线程是不可见的。当前线程操作完Count变量将值从副本空间写到主内存(堆内存)的时候就会覆盖其他线程操作Count变量的结果，引发线程不安全问题。

**JDK8**

JDK7的Hotspot，将方法区中的字符串常量池，静态变量移到了堆中

JDK8中将方法区中的类型信息等放在了元空间，在直接内存中，但是这时候，堆中的常量池，直接内存中的元空间逻辑上还是属于方法区中的。

JDK1.6时，String常量池位于方法区中，存放的是字符串常量。JDK1.7时，String常量池位于堆中，存放的是字符串的引用。

元空间是什么

元空间的本质和永久代类似，都是对JVM规范中方法区的实现。不过元空间与永久代之间最大的区别在于：元空间并不在虚拟机中，而是使用本地内存。因此，默认情况下，元空间的大小仅受本地内存限制，但可以通过以下参数来指定元空间的大小

关于为什么移除永久代

- 字符串存在永久代中，容易出现性能问题和内存溢出。
- 类及方法的信息等比较难确定其大小，因此对于永久代的大小指定比较困难，太小容易出现永久代溢出，太大则容易导致老年代溢出。
- 永久代会为 GC 带来不必要的复杂度，并且回收效率偏低。

```
public class Test(){
		public static main(String[] args){
				Student s = new Student();
				s.name = "张三";
				s.age = 20;
				s.show();
				Student s2 = new Student();
				s2.name = "李四";
        s2.age = 21;
        s2.show();
		}
}
```

Student程序运行时候的内存情况

- Test.class先进入方法区，这里又分为静态区(main)和非静态区
- main方法被虚拟机自动调用，栈帧压栈，开始执行主方法，开始是`Student s =new Student();   `
- 声明变量之前，会先将字节码文件加载进方法区，Student.class也进入方法区，这里也是分为静态区(school="xx")和非静态区(name,age,show())，静态区直接被初始化值
- 堆内存中存放student对象，会将方法区中的非静态的变量加载入堆， 并且赋予初始化值(name=null, age=0)，包括成员方法的引用地址，然后就会把新建的Student对象的地址赋值给引用变量s
- `s.name="张三" s.age=20`就会根据s的地址将堆内存中的变量进行赋值 
- `s.show()`先根据s的地址找到对象，再根据对象中的引用找到方法`show()`，方法压栈执行 ，方法执行完，弹栈

### JVM垃圾回收机制



### JVM的类加载机制

JVM采取的是双亲委派模型，如果一个类加载器收到了类加载的请求，他首先会让父加载器去加载，只有当父加载器无法加载的时候，才会尝试自己去加载。

我们常见的有这三种加载器，启动类加载器(Bootstrap ClassLoader)，拓展类加载器(Extension ClassLoader)，应用程序加载器(Application ClassLoader)

- 启动类加载器负责加载`<JAVA_HOME>\lib`中的基础类库，里面主要包括`rt.jar`,`tools.jar`,`dt.jar`
  - rt是RunTime，里面是Java的核心基础类库，类似System, Long, Object这些基础类都会被加载
  - dt是DesignTime，里面主要是swing的包
  - tools是系统编译类用到的工具，类似支持java，javac的相关类
- 拓展类加载器负责加载`<JAVA_HOME>\lib\ext`中的类库，用于拓展java
- 应用程序加载器就是运行classpath中的所有的类库，平时我们写的不指定类加载器基本都是应用程序加载器加载的

双亲委派模型的好处就是避免重复加载，覆盖核心类库。

比如我自己写一个Object类，在类加载的时候就会一层一层的让父加载器加载，最后是启动类加载器加载核心类库中的Object，而不是加载我们写的Object，保证虚拟机中只有一个Object类

### 内存泄露和内存溢出

## JavaWeb

### get和post请求的区别

1. 用途上

   get请求一般用于获取资源，post用于对指定资源进行处理

2. 形式上

   在使用浏览器发请求的时候，get请求没有请求体，参数拼在URL中，post请求有请求体，数据放在请求体中

3. 关于安全性

   由于get请求参数拼接在URL后面，所以一般敏感数据，比如账号密码登录使用post请求

4. 长度的限制

   还是受限于URL的长度，由于浏览器的和服务器的限制，get请求的参数长度是有限制的，而post使用请求体则没有长度限制

5. 幂等性

   get请求是获取资源，多次同样的请求结果应该是一致的，也就是幂等，而post请求不是幂等的，是有副作用的，有副作用所以浏览器不会缓存，也不能存书签，类比的话get比如查看最新20条微博，post就是点赞评论

6. 其他

   最后其实上述说的主要基于语义上的区别，语法上没有那么多限制，get请求同样可以有请求体，比如用postman可以自己写带请求体的get请求，或者ES中的高级查询中，也把查询条件放在了请求体中，因为查询条件可能很复杂，用json写才舒服，post也同样可以再URL后面拼接参数，既要遵守约定，不要随意“创新”，又不能死板，认为他就得怎么样。

### 重定向和请求转发的区别

1. 请求和响应的次数不同，请求转发是一次请求响应，而重定向是多次请求响应
2. 请求转发是服务器内部进行的跳转，客户端的域名不发生变化，主体是服务器，而重定向是进行了两次浏览器和服务器的交互
3. 用法不同，请求转发一般用于携带数据的跳转，通过request域携带数据进行跳转，而重定向一般用于单纯的跳转，不涉及数据传输
4. 请求转发只能访问自己的项目，但是重定向还可以访问别的资源
5. 重定向是response对象的方法，但是请求转发是request对象的方法

### Cookie和Session是什么

Cookie实际上就是一小段文本信息，也是以key-value的形式进行存储，value只能是字符串的形式，Cookie大小限制在4kb，而且Cookie中不能存在特殊的字符，空格，逗号，分号等，接着上面服务器如何识别客户端，当我们第一次创建Session的时候，就会把jsessionid存入Cookie然后发送到客户端，下次客户端再次访问服务器的时候，会携带所有Cookie，这样就可以通过jsessionid来识别客户端了。

这是Cookie大部分的应用，Cookie还能给客户端一些方便，最常见的就是记住账号密码，服务器接收到这个账号密码之后，再把这个信息写到Cookie中携带到客户端，就可以方便的为用户自动填写用户名和密码了，这个也是Cookie这个名字的来源。

Session本质就是一个域对象，里面可以存储键值对，value可以是任意类型，key是字符串，当我们需要记录用户的状态的时候，就需要用某种机制来记录不同用户的状态，这个机制就是Session，典型的就是购物车，Session是保存在服务端的，里面有一个唯一个标识ID，现在储存了用户的状态信息，那么服务端如何识别哪个客户端是这个信息的主人呢？这就用到了Cookie技术。

### 怎么实现记住账号密码？

```
HTML页面在前端可以直接存入cookie

<input class="u-input" type="text" placeholder="用户账号" id="username" />

<input class="u-pass" type="password" id="password" />

<input type="checkbox" onclick="save()" id="ck_rmbUser"/>记住账号

<button class="login"  onclick="loginclick()">登录</button>

引入cookie插件

<script src="js/jquery.cookie.js" type="text/javascript"></script>

实现方法

<script type="text/javascript">
 $(document).ready(function() {
  if ($.cookie("rmbUser") == "true") {
   $("#ck_rmbUser").attr("checked", true);
   $("#username").val($.cookie("username"));
   $("#password").val();
   $("#password").val($.cookie("password"));
  }
 });
</script>

//记住用户名密码
<script type="text/javascript">
 function save() {
  if ($("input[type='checkbox']").is(':checked')) {
   var username = $("#username").val();
   var password = $("#password").val();
   $.cookie("rmbUser", "true", {
    expires : 7
   }); //存储一个带7天期限的cookie
   $.cookie("username", username, {
    expires : 7
   });
   $.cookie("password", password, {
    expires : 7
   });
  } else {
   $.cookie("rmbUser", "false", {
    expire : -1
   });
   $.cookie("username", "", {
    expires : -1
   });
   $.cookie("password", "", {
    expires : -1
   });
  }
 };
```

如果服务器不能用session，应该用什么方案，jwt的结构是什么

```
jwt：JSON Web Token 
由三部分组成：Header（头部）、Payload（负载）、Signature（签名）
xxxxx.yyyyy.zzzzz
由令牌的类型（即JWT）和正在使用过的签名算法组成
{ 
    "alg": "HS256",
    "typ": "JWT" 
}
那么，这个JSON是Base64Url编码成JWT的第一部分

Payload（负载）
载荷的属性有三类：
预定义（Registered） 公有（public） 私有（private）
{
    "sub": "1",
    "iss": "http://localhost:8000/auth/login",
    "iat": 1451888119,
    "exp": 1454516119,
    "nbf": 1451888119,
    "jti": "37c107e4609ddbcc9c096ea5ee76c667",
    "aud": "dev"
}

Signature（签名）
签名属于jwt的第三部分。主要是把头部的base64UrlEncode与负载的base64UrlEncode拼接起来，再进行HMACSHA256加密，加密结果再进行base64url加密，最终得到的结果作为签名部分

如果一个客户端带着jwt请求服务端，服务端要确保这个请求是合法并且没有被篡改的请求，那么服务端是需要一个规则来进行验证的。所以上述签名的加密过程就是服务端的使用的规则，加密结果再和jwt的第三部分进行匹配，确定是否相同，如果相同则为合法请求。如果不相等，则为非法请求。

非法者非法请求的时候，可以通过同样的规则来伪造一个jwt，但是客户端一般是不知道服务端的密钥的（盐），所以非法者几乎不能伪造出合法的请求。
```



### 说说cookie的域对象

```
例如 "https://map.baidu.com/" 与 "https://fanyi.baidu.com/" 公用一个相同的一级域名"qq.com"，如果想让 "map.baidu.com" 下的cookie被 "fanyi.baidu.com" 访问

我们就需要用到 cookie 的domain属性，并且需要把path属性设置为 "/"。例：

document.cookie = "username=caofeng; path=/; domain=baidu.com"

如果要实现相互共享，就把两个域名cookie的domain都设置成baidu.com
```



### servlet的生命周期

默认情况下，servlet是在浏览器第一次访问servlet的时候创建servlet对象，执行`init()`方法，之后所有浏览器访问的都是这个servlet对象，浏览器每次访问的时候都会执行`service()`方法，当服务器关闭的时候，Servlet实例即可被垃圾回收并执行`destroy()`方法

### CORS

### 什么是跨域问题，怎么解决

```

```

**浏览器同源政策**

同源政策是浏览器一个重要的安全策略，没有同源策略非常危险，比如我自己制作一个与淘宝页面非常像的静态页面，但是请求的却是淘宝的服务器，那么在你看来跟正常的淘宝网页是几乎一样的，一旦你选择了登录，输入了密码，那么密码将被其他人获取到。

所以浏览器就采用了同源策略，如果两个 URL 的 protocol、port和host都相同的话，则这两个 URL 是同源，浏览器的同源策略会限制一些跨域操作，例如，非同源AJAX请求不能发送，DOM无法获得，同源策略虽然规避了一些风险，但是也给前后端分离开发带来了一些问题。

可以使用一些方法来规避跨域政策，例如JSONP，CORS，我们一般采用CROS策略。

**CORS**

CORS是一个W3C标准，全称是"跨域资源共享"（Cross-origin resource sharin），它允许浏览器向跨源服务器，发出`XMLHttpRequest`请求，从而克服了AJAX只能同源使用的限制CORS有两种请求，分为简单请求和非简单请求。

**简单请求**

同时满足以下两大条件，就属于简单请求：

- 请求方法是以下三种方法之一
  - HEAD
  - GET
  - POST
- HTTP的头信息不超出一些字段

这是为了兼容表单(form)，因为历史上表单是一直可以发跨域请求的，这个简单请求的目的就是，表单可以发的我也可以发。

简单请求流程

- 请求

  对于简单请求，浏览器发现这次请求是跨域请求，那么就会自动在请求头中加入一个`Origin`字段，这个字段的内容是本次请求来自哪里(协议 + 域名 + 端口)

- 响应

  接下来服务器会识别这个源是否在范围内，如果不在，服务器会返回一个正常的HTTP回应，这时候浏览器发现相应头没有`Access-Control-Allow-Origin`字段，就会报错；如果这个源在服务器的范围内，服务器返回的响应，会多出几个头信息字段

  - ```
    Access-Control-Allow-Origin: http://api.bob.com
    ```

    该字段是必须的。它的值要么是请求时Origin字段的值，要么是一个*，表示接受任意域名的请求

  - ```
    Access-Control-Allow-Credentials: true
    ```

    该字段可选。它的值是一个布尔值，表示是否允许发送Cookie，设为true，即表示服务器明确许可，Cookie可以包含在请求中，一起发给服务器

    另一方面，开发者必须在AJAX请求中打开`withCredentials`属性，否则，即使服务器同意发送Cookie，浏览器也不会发送。或者，服务器要求设置Cookie，浏览器也不会处理。

    ```
    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;
    ```

    需要注意的是，如果要发送Cookie，`Access-Control-Allow-Origin`就不能设为星号，必须指定明确的、与请求网页一致的域名。

  - ```
    Access-Control-Expose-Headers: FooBar
    ```

    可选，该例子指定，`getResponseHeader('FooBar')`可以返回`FooBar`字段的值。

  三个与CORS请求相关的字段，都以`Access-Control-`开头

**非简单请求**

非简单请求是那种对服务器有特殊要求的请求，比如请求方法是`PUT`或`DELETE`，或者`Content-Type`字段的类型是 `application/json`。

- 预检请求

  非简单请求的CORS请求，会在正式通信之前，增加一次HTTP查询请求，称为**预检请求**(preflight)。

  浏览器先询问服务器，当前网页所在的域名是否在服务器的许可名单之中，以及可以使用哪些HTTP动词和头信息字段。只有得到肯定答复，浏览器才会发出正式的`XMLHttpRequest`请求，否则就报错。

  比如网页发送了一个HTTP请求，method为put，并且发送一个自定义头信息`X-Custom-Header`

  ```
  var xhr = new XMLHttpRequest();
  xhr.open('PUT', url, true);
  xhr.setRequestHeader('X-Custom-Header', 'value');
  xhr.send();
  ```

  浏览器发现，这是一个非简单请求，就自动发出一个预检请求，要求服务器确认可以这样请求。预检请求的请求方法是`OPTIONS`，表示这个请求是用来询问的。

  ```
  OPTIONS /cors HTTP/1.1
  Origin: http://api.bob.com
  //该字段是必须的，用来列出浏览器的CORS请求会用到哪些HTTP方法
  Access-Control-Request-Method: PUT
  //该字段是一个逗号分隔的字符串，指定浏览器CORS请求会额外发送的头信息字段，上例是X-Custom-Header。
  Access-Control-Request-Headers: X-Custom-Header
  Host: api.alice.com
  Accept-Language: en-US
  Connection: keep-alive
  User-Agent: Mozilla/5.0.
  ```

- 回应预检请求

  如果服务器否定了预检请求，会返回一个正常的HTTP回应，但是没有任何CORS相关的头信息字段。

  ```
  HTTP/1.1 200 OK
  Date: Mon, 01 Dec 2008 01:15:39 GMT
  Server: Apache/2.0.61 (Unix)
  Access-Control-Allow-Origin: http://api.bob.com
  Access-Control-Allow-Methods: GET, POST, PUT
  Access-Control-Allow-Headers: X-Custom-Header
  Content-Type: text/html; charset=utf-8
  Content-Encoding: gzip
  Content-Length: 0
  Keep-Alive: timeout=2, max=100
  Connection: Keep-Alive
  Content-Type: text/plain
  ```

  这时，浏览器就会认定服务器不同意预检请求，因此触发一个错误；

  ```
  XMLHttpRequest cannot load http://api.alice.com.
  Origin http://api.bob.com is not allowed by Access-Control-Allow-Origin.
  ```

- 通过预检请求

  一旦服务器通过了预检请求，以后**每次**浏览器正常的CORS请求，就都跟简单请求一样，会有一个`Origin`头信息字段。

  ```
  PUT /cors HTTP/1.1
  Origin: http://api.bob.com
  Host: api.alice.com
  X-Custom-Header: value
  Accept-Language: en-US
  Connection: keep-alive
  User-Agent: Mozilla/5.0...
  ```

  服务器的回应，也都会有一个`Access-Control-Allow-Origin`头信息字段。

  ```
  Access-Control-Allow-Origin: http://api.bob.com
  Content-Type: text/html; charset=utf-8
  ```

**与JSONP的比较**

CORS与JSONP的使用目的相同，但是比JSONP更强大。JSONP只支持`GET`请求，CORS支持所有类型的HTTP请求。JSONP的优势在于支持老式浏览器，以及可以向不支持CORS的网站请求数据。

[Reference](http://www.ruanyifeng.com/blog/2016/04/cors.html)——来自阮一峰博客

### 常见的http返回状态码

```
3XX 重定向
通常告诉客户端需要向另一个URI发送GET请求
301("Moved Permanently")
服务器知道客户端试图访问的是哪个资源，但它不喜欢客户端用当前URI来请求该资源("Moved Permanently")
302
资源的URI已临时定位到其他位置了，姑且算你已经知道了这个情况了
303
资源的URI已更新，你是否能临时按新的URI访问
当301,302,303响应状态码返回时，几乎所有的浏览器都会把POST改成GET，并删除请求报文内的主体，之后请求会自动再次
304
我们理解为服务端内容未改变，将缓存在浏览器端
304也会发送请求，确实是进行了一次请求，但服务端端返回了空的报文头，
发送
304("Not Modified")
307 Temporary Redirect：临时重定向。与302有相同的含义

4XX——表明客户端是发生错误的原因所在
401("Unauthorized")
客户端试图对一个受保护的资源进行操作，却又没有提供正确的认证证书。
402("Payment Required")
403("Forbidden")
客户端请求的结构正确，但是服务器不想处理它。
404("Not Found")
404表明服务器无法把客户端请求的URI转换为一个资源
405("Method Not Allowd")
405一个资源只支持GET方法，但是客户端使用PUT方法访问

5XX——服务器本身发生错误
500 Internal Server Error：貌似内部资源出故障了。
503 Service Unavailable：抱歉，我现在正在忙着。该状态码表明服务器暂时处于超负载或正在停机维护，现在无法处理请求。
```

### Ajax的书写方式

```
JQuery：
$.ajax({
    url: "/greet",
    data: {name: 'jenny'},
    type: "POST",
    dataType: "json",
    success: function(data) {
        // data = jQuery.parseJSON(data);  //dataType指明了返回数据为json类型，故不需要再反序列化
        ...
    }
});

Vue发起get请求:
this.$axios.get(this.GLOBAL.host.+“后台接口地址”,{
    params:{            
        phone:12345678   //参数，键值对，key值：value值
        name:hh
    }
}).then(res => {
    //获取你需要用到的数据
});
```

### JQuery常用的选择器

```
id选择器
#id       $（"#test").css("background","#bbffaa")
标签选择器
element   $("p") ;//选取所有的<p>元素
class选择器
.class  $(".test");//选取类名为test的元素
```

### 什么是RESTful风格API有什么优缺点

```
GET、POST、PUT、DELETE。它们分别对应四种基本操作+资源名+数量
URI中不应该有动词

不用PUT和DELETE，原因是增加复杂度，并没有带来什么好处
有的浏览器可能不支持POST、GET之外的提交方式，要特殊处理
有时候业务逻辑有时难以被抽象为资源的增删改查
```

### TCP协议有了解吗，三次握手，四次挥手啥意思

```

```

## Spring

### Spring常用的注解

```
1. 声明bean的注解
@Component
@Service
@Repository  在数据访问层使用（dao层）
@Controller
2. 注入bean的注解
@Autowired：由Spring提供
3. java配置类相关注解
@Configuration 声明当前类为配置类
@Bean 注解在方法上，声明当前方法的返回值为一个bean
@ComponentScan 用于对Component进行扫描
4. AOP相关注解
@Aspect 声明一个切面
@After 在方法执行之后执行
@Before 在方法执行之前执行
@Around 在方法执行之前与之后执行
@PointCut 声明切点
5. @Value 为属性注入值
6. @Enable*注解说明
7. SpringMVC部分
@Controller 声明该类为SpringMVC中的Controller
@RequestMapping 用于映射Web请求，包括访问路径和参数
@ResponseBody 支持将返回值放在response内，而不是一个页面，通常用户返回json数据
@RequestBody 允许request的参数在request体中
@PathVariable 用于接收路径参数
```

### SpringIOC和DI是什么

```
IOC
在Java开发中，Ioc意味着将你设计好的对象交给容器控制，而不是传统的在你的对象内部直接控制。
传统Java SE程序设计，我们直接在对象内部通过new进行创建对象，是程序主动去创建依赖对象；
而IoC是有专门一个容器来创建这些对象，这就叫控制反转，是一种思想
这让对象与对象之间的耦合性更低了，整个体系结构变得非常灵活

DI
依赖注入，就是从IOC容器中将对象所需要的资源注入
```

### SpringAOP是什么，什么原理

```
Spring AOP就是基于动态代理的面向切面式编程，如果要代理的对象实现了某个接口，那么Spring AOP会使用JDK Proxy，去创建代理对象，而对于没有实现接口的对象，Spring AOP会使用Cglib，这时候Spring AOP会使用Cglib生成一个被代理对象的子类来作为代理。
具体使用我们需要创建一个切面类，上面加上@Aspect注解，里面定义@pointcut和@Before等增强
```

```
/**
 * @Aspect-表示这是一个切面对象 切面对象 = 切点+增强
 */
@Component
@Aspect
public class ServiceAspect {
    /**
     * @Pointcut标记的方法称为切点 切点以表达式的形式表示需要进行增强的方法集
     */
    @Pointcut("execution(* com.itheima.service.impl.*.*(..))")
    public void pt1() {
    }

    /**
     * 增强之@Before 切点方法执行之前执行
     */
    @Before("pt1()")
    public void beforePrintLog() {
        System.out.println("[AOP]@Before,在方法之前执行");
    }
}
```

### Spring实现实例化和注入的方式

```
Spring容器实现实例化的三种方式：
	使用构造器
	使用静态工厂实例化bean
	使用实例工厂的方式实例化bean
	
Spring注入的方式：
	基于set方法的注入
	基于构造方法进行注入
	自动装配
		default-autowire，它是在xml文件中进行配置的，可以设置为byName、byType、constructor和autodetect；
	注解
	@Autowired自动根据类型装配，不需要setter，getter方法
```



有一个写好的类。

首先我们要对其进行实例化，我们通过bean标签来实现。

```xml
<bean id="accountService1" class="com.itheima.service.impl.AccountServiceImpl" scope="singleton"/>
```

实例化有三种方式：

- 默认构造方法实例化bean，这是最常用的实例化bean的方法

- 配置静态工场

  我们需要创建一个静态工厂类，创建bean时，除了需要指定class属性外，还需要通过`factory-method`属性来指定创建`bean`实例的工厂方法，**Spring将调用此方法返回实例对象**。

  ```xml
  <bean id="staticFactoryAccountService" class="com.itheima.factory.StaticFactory" factory-method="creatAccountService"/>
  ```

- 配置实例工场

  跟上面差不多，只不过这个工厂方法里面不是静态的。

这三种方式，没啥区别，主要用第一种。

这里面，我们可以选择单例，或者多例模式进行实例化，**bean标签默认的是单例**。

多例的话，就相当于new了一个对象

**注解的方式**

- @Component @Controller @Service @Repository来实现实例化

- 我们可以使用@Scope来选择多例

- @Bean注解

  将方法的返回值存储到Spring IOC容器中

**注入：**

A实例化之后，B当我们使用他的时候，就需要将它从Spring容器中注入，下面我们说的对象就是B了

- setter和getter注入

  ```xml
  <bean id="account1" class="com.itheima.entity.Account">
    <property name="id" value="1"/>
    <property name="name" value="特朗普"/>
    <property name="money" >
      <value>50000000</value>
    </property>
  </bean>
  ```

- 构造函数注入

  ```xml
  <bean id="account2" class="com.itheima.entity.Account">
    <constructor-arg name="id" value="1"/>
    <constructor-arg name="name" value="特朗普"/>
    <constructor-arg name="money">
      <value>50000000</value>
    </constructor-arg>
  </bean>
  ```

- 自动装配

  首先要知道另一个东西，default-autowire，它是在xml文件中进行配置的，可以设置为byName、byType、constructor和autodetect；比如byName，不用显式的在bean中写出依赖的对象，它会自动的匹配其它bean中id名与本bean的set**相同的，并自动装载

  @Autowired是用在JavaBean中的注解，通过byType形式，用来给指定的字段或方法注入所需的外部资源。

@Configuration

- 用配置类代替xml

@ComponentScan

- Spring是一个依赖注入的容器，当你使用注解注入的时候，spring不知道去哪里可以找到这个bean，ComponentScan做的事情就是告诉Spring从哪里找到bean，由你来定义哪些包需要被扫描。
- 如果你的其他包都在使用了@SpringBootApplication注解的main app所在的包及其下级包，则你什么都不用做，SpringBoot会自动帮你把其他包都扫描了

### Spring所有bean都需要注入吗

```
不是的，pojo类是不需要注入的
注入是为了解耦合，比如说我们用有一个Service接口，Service1是mysql实现的，那么如果我们现在业务变更，需要用Oracle来实现，那么我们新建一个Oracle实现的Service2即可。
pojo类一般一创建就不再发生变化，那么所以也就不需要使用IOC
```

### Spring用到了哪些设计模式

```
单例模式：
	我们创建bean的时候，默认实例化的是一个单例的对象
	
工厂模式：
	Spring使用工厂模式可以通过BeanFactory或ApplicationContext创建bean对象

模版模式：

代理模式：
	例如AOP用到了动态带代理
	
建造者模式：


策略模式：
	Spring框架会定义很多接口，我们默认使用的也是他的实现类，但是当我们不满足于他的实现类的时候，我们可以自己对Spring规定的接口进行实现，通过不同的过程达到同一个目标就是策略模式
	例如SpringSecurity进行密码校验的时候，默认的UserDetailsService的实现类，是让我们从配置文件中找我们定义的账号和密码，但是我们需要从数据库中查找需要的账号和密码，这时候我们就需要自己实现UserDetailsService这个接口。

观察者模式：
	观察者模式，就是事件源，事件，观察者，监听器就是观察者的具体体现

适配器模式：
	在Spring-MVC中，控制器的实现有很多种，我们常使用的@Controller，或者实现Controller接口或者实现HttpRequestHandler接口，而在DispatcherServlet能适配这三种控制器的实现，这就是控制器模式
```

### SpringMVC的执行流程是什么

```
前端用户发送请求，首先被前端控制器dispatcherServlet捕获，DispatcherSerlet对请求的Url进行解析，获取到资源标识符
根据该URI，调用handlerMappering，获取该handler配置的所有相关对象（包括handler对象以及handler对象对应的拦截器，最后以HandlerExcutionChain对象的形式返回
DispatcherSevlet根据获得到的Handler，选择一个合适的HandlerAdapter
提取Request中的模型数据，填充Handler入参，开始执行Handler，也就是我们写的Controller
在填充的过程中，根据你写的配置，Spring将帮你做一些额外的工作
	HttpMessageConveter：将请求消息（JSON、xml等数据）转换成一个对象，将对象转换成执行的响应信息
	数据转换，对请求的消息进行数据类型转换
	数据格式化等(也就是String转换成各种类型的)
	数据验证等等
Handler执行玩之后，向dispatcherServlet对象返回一个ModleAndView对象
ViewResolver结合ModelAndView来渲染视图
然后返回给DispatcherSevlet,再返回给前端
```

[谈谈Spring中都用到了哪些设计模式？](https://www.cnblogs.com/kyoner/p/10949246.html)

### SpringMVC如何实现请求参数的绑定

```
基本类型和String类型
	控制器形参和表单元素的name取值一致即可自动绑定，不一致的话使用@RequestParam 
实体类类型
	如果表单和实体类型一致，可以自动转换
实体类关联实体类对象
	表单就需要写上对象.属性名进行命名
RequestBody接收的是请求体里面的数据；而RequestParam接收的是key-value
```

### SpringMVC如何解决中文乱码问题

SpringMVC需要解决中文乱码问题，但是在Springboot项目中，有了启动类，集成了tomcat，已经将这些需要统一解决的问题进行了处理。

```
对于springMVC项目，如何解决乱码问题呢？项目中一般会在web.xml中配置编码过滤器
  <filter>
    <filter-name>encodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>UTF-8</param-value>
    </init-param>
    <init-param>
      <param-name>forceEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>encodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
```

[透彻分析javaWeb项目乱码问题](https://zhuanlan.zhihu.com/p/106734647)

### Spring是如何管理事务的

```

```

### Spring是如何管理异常的

```

```

### Spring你都哪些异常怎么解决的

```

```

### 用过滤器吗，怎么用的？

```

```

### 监听器的应用

```

```



## Mybatis

### Mybatis中#和$的区别

首先是明白SQL注入问题，当用户输入的内容作为SQL语句语法的一部分，导致SQL改变了真正的含义，例如：

当用户输入的账号为XXX 密码为：`XXX'  OR 'a'='a`时：

```
SELECT * FROM 用户表 WHERE NAME = 'XXX' AND PASSWORD ='XXX' OR 'a'='a';
```

其实注入问题出现的本质就是，SQLString类型的变量有`''`，那么我们在拼接时候就可以在里面添加`'`来改变原来SQL语句的含义

解决SQL注入问题，我们使用的是jdbc预处理对象，

```
String sql = "select * from user where username = ? and password = ?";
PreparedStatement preparedStatement = connection.prepareStatement(sql);
preparedStatement.setObject(1, username);
preparedStatement.setObject(2, password);
```

**为什么预处理对象能解决SQL注入问题？**

在mysql5.1后，提供了类似于jdbc的预处理-参数化查询。它的查询方法是：

- 先预发送一个sql模板过去
- 再向mysql发送需要查询的参数

(通过日志你可以看到jdbc向数据库发送了两条信息`Preparing:`和`Parameters:`)

就好像填空题一样，不管参数怎么注入，mysql都能知道这是变量，不会做语义解析，起到防注入的效果，这是在mysql中完成的。

那么这里的#和$就很好理解了，#使用的是占位符的方式，$使用的是拼接的方式

注意：

- 当我们dao层不指定`@param`的时候

  ```
  List<User> findByName(String name)
  ```

  使用`#{X}`的时候X不论为什么，都会取的到name

  但是`${X}`的时候，只能使用`value`

- 我们在项目中用到的基本都是`#`，这样可以防止SQL注入

### Mybatis中的模糊查询语句

```
因为中间有个变量，所以需要concat
where user_name like concat('%',#{condition},'%')
```

### Mybatis如何获取自增主键

```xml
<selectKey resultType="int" keyProperty="id" order="AFTER" >
  select LAST_INSERT_ID()
</selectKey>
```

### ResultMap的作用

```
在简单的场景下，MyBatis 可以为你自动映射查询结果，但是当数据库中的列名和pojo类名相同的时候，你需要构建一个结果映射（ResultMap）
```

### Mybatis中的动态sql语句是什么意思

```
动态sql意思是SQL的 主体结构，在编译的时候还不能确定，只能等到程序运行起来，在执行的过程中才能确定，这种动态语句叫做动态SQL
mybatis中动态的sql语句的主要标签是if,where,foreach,set
我在工作中也有用到过，比如在之前的健身房预约私教课项目，网页上面会有一个搜索框，里面可以用名字进行模糊查询，还有价格范围进行查询，那么这个时候，我们可以用where和if标签来选择出我们传过来的查询条件，来构建一个动态sql语句，同时满足多条件和无条件的分页查询
```

### Mabatis批量执行语句怎么办？

```
mybatis是一支持动态SQL的：
我们可以使用foreach标签进行处理
<insert id="addMyUsers">
    insert into myuser(name,age,did) values
    <foreach collection="users" item="user" separator=",">
      (#{user.name},#{user.age},#{user.dept.id})
    </foreach>
</insert>

<insert id="addMyUsers">
    <foreach collection="list" item="user" separator=";">
        insert into myuser(name,age,did) values (#{user.name},#{user.age},#{user.dept.id})
    </foreach>
</insert>
```



## Springboot

### SpringMVC打的是什么包，Springboot打的是什么包

```
SpringMVC打的是war包，war本身就是用于web应用的打包
Springboot打的是jar包，因为Springboot，
首先，SpringBoot应用是可以打包成JAR或者WAR形式的。但是官方文档推荐的是打包成JAR，作为一个web应用，为什么会推荐打包成JAR，这是因为SpringBoot内集成了Tomcat服务器，当你启动SpringBoot应用的时候，内置的Tomcat服务器就会启动，加载web应用。
从依赖中可以看出。其次，WAR包的启动需要Tomcat或者Jetty容器，这就在SpringBoot会引起JAR冲突，需要排除依赖，这样反而违背了SpringBoot简洁的特点。JAR包的启动入口就是main函数。
```

## Spring Cloud

### 什么是Spring Cloud

Spring Cloud 就是微服务系统架构的一站式解决方案，在平时我们构建微服务的过程中需要做如服务发现注册、配置中心 、消息总线 、负载均衡 、断路器 、数据监控等操作，而 Spring Cloud 为我们提供了一套简易的编程模型，使我们能在 Spring Boot的基础上轻松地实现微服务项目的构建。

### 你这个SpringCloud都用到的哪些组件

```
这个我用到了比如说注册中心Eureka，SpringCloudGateWay网关,负载均衡Ribbon, Feign远程调用，Hystrix熔断器
```

### 什么是微服务

微服务是为了区别传统的单体应用架构，单体式应用内部包含了所有需要的服务。而且各个服务功能模块有很强的耦合性，也就是相互依赖彼此，很难拆分和扩容。

但是这种架构简单，容易部署，但是当用户人数增加，服务升级，应用拓展的时候就非常麻烦，当我们想要升级某个服务的时候，不能单独拓展该服务，只能扩展整个应用程序，并且某个服务出错也会导致整个服务器的瘫痪，不能实现高可用，高性能和高并发。

微服务则将单一应用划分为一组小的服务，每个服务能够独立部署，服务之间采用轻量级的通信机制，通常是Result风格的HTTP接口。

这样的话每个服务可用独立的进行开发，一个服务的瘫痪不会导致整个服务的瘫痪，每个服务还可以通过集群实现高可用和高并发，拓展性和维护性也很强，甚至不同的服务还可以采用不同的语言进行开发。

### Spring Cloud内部服务

- Spring Cloud 的服务发现框架——Eureka

  Eureka是一个基于REST的服务，实现了服务的管理，注册和发现、状态监管、动态路由。Eureka负责管理记录服务提供者的信息。服务调用者无需自己寻找服务，Eureka自动匹配服务给调用者。Eureka与服务之间通过心跳机制进行监控，功能上类似与注册中心zookeeper。

- 负载均衡服务——Ribbon

  当我们部署了多个服务提供者，消费者就面临选择，这时候Ribbon就可以提供多种负载均衡策略，默认的是可用过滤策略，过滤掉故障和请求数超过阈值的服务实例，再从剩下的实例中轮询调用。

  **遇到的问题**就是，一旦开启了负载均衡，加上了`@LoadBalanced`注解，就不能再使用discoveryClient获取ip进行访问使用，只能使用逻辑虚拟机名进行访问

- 熔断器——Hystrix

  Hystrix用于处理分布式系统的**延迟和容错**，并可以对相关的服务进行降级，在分布式系统中，很多服务不可避免的会调用失败，比如超时异常等，Hystrix会保证当一个服务出问题的时候，通过断路器直接将此请求链路断开，从而不会引发雪崩现象，并通过设置 `fallbackMethod` 来给一个方法设置备用的代码逻辑来实现服务降级。

- 远程调用——Feign

  Feign是一个http请求调用轻量级框架，我们使用了Ribbon已经很方便了，不需要再写ip地址了，可以直接使用相关服务的名字就可以进行相关的调用了，但是还得进行URL的拼接，Feign使这一过程进一步封装简化，通过MVC注解，实现像原来一样在Controller层对Service层直接进行调用，Feign整合了Ribbon和Hystrix。

- 网关——Spring Cloud Gateway

  提供了外部访问的统一入口，

- 分布式配置——Spring Cloud Config

  Spring Cloud Config为微服务中的各个服务提供了集中化的管理，采用git来存储配置信息

- 总线——Spring Cloud Bus

  SpringCloud Bus管理和传播所有分布式项目中的消息，如果修改了配置文件，发送一次请求，所有的客户端便会重新读取配置文件。

### Zookeeper和Eureka的区别

```
- Zookeeper保证了C(一致性)，P(分区容错性)，Zookeeper当master节点失去联系的时候，会重新选举节点，选举的时间有点长，这个期间整个集群是不可用的，这在云部署环境下是不能容忍的。

- Eureka保证了A(可用性)，P(分区容错性)，Eureka在设计时就保证了可用性，Eureka的各个节点之间是平等的，某个节点失去联系不会影响正常节点的服务，剩余节点依然可以提供注册和查询服务，不过查到的信息可能不是最新的(不能保证强一致性)

  

  Eureka还有一种自我保护的机制，就是在15分钟低于85%的节点都没有进行心跳续约，Eureka就认为出现了网络故障，Eureka不再移出过期的服务，并且仍然能够接受注册和请求，但是不会同步到其他节点上，当网络稳定的时候注册信息会被同步。

  因此，Eureka可以很好地应对因网络故障导致部分节点失去联系的情况。
```

## Database

### 基础

#### CHAR类型和VARCHAR类型的区别

```
char 表示定长，长度固定，varchar表示变长，即长度可变。char如果插入的长度小于定义长度时，则用空格填充；varchar小于定义长度时，还是按实际长度存储，插入多长就存多长。

InnoDB 存储引擎和数据列 建议使用 VARCHAR类型，因为内部的行存储格式没有区分固定长度和可变长度列
```

#### MySQL中的几种日志

```
MySQL中的几种日志
重做日志(redo log)
确保事务的持久性。redo日志记录事务执行后的状态，用来恢复未写入data file的已成功事务更新的数据
事务开始之后就产生redo log
内容：物理日志，即记录修改后的数据行
当数据库对数据做修改的时候，需要把数据页从磁盘读到buffer pool中，然后在buffer pool中进行修改，那么这个时候buffer pool中的数据页就与磁盘上的数据页内容不一致，称buffer pool的数据页为dirty page 脏数据，如果这个时候发生非正常的DB服务重启，那么这些数据还没在内存，并没有同步到磁盘文件中（注意，同步到磁盘文件是个随机IO），也就是会发生数据丢失，所以在重启mysql服务的时候，可以根据redo log进行重做，从而达到事务的持久性
redo log的存在为了：当我们修改的时候，写完内存了，但数据还没真正写到磁盘的时候。此时我们的数据库挂了，我们可以根据redo log来对数据进行恢复。因为redo log是顺序IO，所以写入的速度很快，并且redo log记载的是物理变化（xxxx页做了xxx修改），文件的体积很小，恢复速度很快。

回滚日志(undo log)
保证数据的原子性，保存了事务发生之前的数据的一个版本，可以用于回滚，同时可以提供多版本并发控制下的读（MVCC），也即非锁定读
在数据修改的时候，不仅记录了redo log，还记录undo log，如果因为某些原因导致事务失败或回滚了，可以用undo log进行回滚
比如我们要insert一条数据了，那undo log会记录的一条对应的delete日志。我们要update一条记录时，它会记录一条对应相反的update记录。

二进制日志(binlog)
binlog记录了数据库表结构和表数据变更，比如update/delete/insert/truncate/create。它不会记录select（因为这没有对表没有进行变更）
主要有两个作用： 复制和恢复数据
MySQL在公司使用的时候往往都是一主多从结构的，从服务器需要与主服务器的数据保持一致，这就是通过binlog来实现的
数据库的数据被干掉了，我们可以通过binlog来对数据进行恢复。
因为binlog记录了数据库表的变更，所以我们可以用binlog进行复制（主从复制)和恢复数据。

慢查询日志(slow query log)
慢日志记录执行时间过长和没有使用索引的查询语句，报错select、update、delete以及insert语句，慢日志只会记录执行成功的语句
```

### 索引

#### 索引是什么，有什么好处

```
索引其实是一种数据结构，能够帮助我们快速的检索数据库中的数据。
```

#### 索引有什么坏处

```
索引需要占用更多的储存空间，创建索引和维护索引要花费一定的时间，当对表进行更新操作时，索引需要被重建，这样降低了数据的维护速度
```

#### 索引的结构是什么

```
常见的MySQL主要有两种结构：Hash索引和B+Tree索引，我们使用的是InnoDB引擎，默认的是B+树。
```

#### 索引为什么采用B+树的结构

```
因为Hash索引底层是哈希表，哈希表是一种以key-value存储数据的结构，所以多个数据在存储关系上是完全没有任何顺序关系的，所以，对于区间查询是无法直接通过索引查询的，就需要全表扫描。所以，哈希索引只适用于等值查询的场景。而B+ Tree是一种多路平衡查询树，所以他的节点是天然有序的（左子节点小于父节点、父节点小于右子节点），所以对于范围查询的时候不需要做全表扫描。
```



**索引结构详解**

索引结构的选择：

- 哈希结构致命缺陷是范围查找；
- 普通二叉树的致命缺陷是，当你顺序插入的时候，就退化为了链表。

- 所以可以采用平衡二叉树，平衡二叉树的缺陷是每个节点只有一个关键字，IO次数还是过多。

- B树(balance)，特点就是每个节点可以存储多个key，减少了IO的次数

- B+树

  - B树是非叶子节点和叶子节点都会存储数据。而B+树只有叶子节点才会存储数据

  - B+树存储的数据都是在一行上，而且这些数据都是有指针指向的，也就是有顺序的


因此Mysql的索引用的就是B+树：

- 范围查询
- 减少磁盘IO



聚集索引

索引采用的是平衡树这种数据结构，也就是b tree或者 b+ tree，建表语句有了主键，表在磁盘上的存储结构就由整齐排列的结构转变成了树状结构。

那么我们根据这个主键进行搜索的时候，就会根据这个树的结构进行搜索，那么时间复杂度大大降低

索引的坏处

增删改数据都会改变平衡树各节点中的索引数据内容，破坏树结构， 因此，在每次数据改变时， DBMS必须去重新梳理树（索引）的结构以确保它的正确，这会带来不小的性能开销，也就是为什么索引会给查询以外的操作带来副作用的原因。

非聚集索引

非聚集索引和聚集索引一样， 同样是采用平衡树作为索引的数据结构。索引树结构中各节点的值来自于表中的索引字段， 假如给user表的name字段加上索引 ， 那么索引就是由name字段中的值构成，在数据改变时， DBMS需要一直维护索引结构的正确性。如果给表中多个字段加上索引 ， 那么就会出现多个独立的索引结构，每个索引（非聚集索引）互相之间不存在关联。 因此， 给表添加索引，会增加表的体积， 占用磁盘存储空间。

非聚集索引和聚集索引的区别在于， 通过聚集索引可以查到需要查找的数据， 而通过非聚集索引可以查到记录对应的主键值 ， 再使用主键的值通过聚集索引查找到需要的数据。

聚集索引（主键）是通往真实数据所在的唯一路径。

例如：

- 给用户的生日创建索引

  `create index index_birthday on user_info(birthday);`

- 查询生日在1991年11月1日出生用户的用户名

  `select user_name from user_info where birthday = '1997-06-01'`

- 首先，通过非聚集索引`index_birthday`查找`birthday`等于`1997-06-01`的所有记录的主键ID值

- 然后，通过得到的主键ID值执行聚集索引查找，找到主键ID值对就的真实数据（数据行）存储的位置

- 最后， 从得到的真实数据中取得`user_name`字段的值返回， 也就是取得最终的结果

- 我们把`birthday`字段上的索引改成双字段的覆盖索引

  `create index index_birthday_and_user_name on user_info(birthday, user_name);`

- 通过非聚集索引index_birthday_and_user_name查找birthday等于1991-11-1的叶节点的内容，然而， 叶节点中除了有user_name表主键ID的值以外， user_name字段的值也在里面， 因此不需要通过主键ID值的查找数据行的真实所在， 直接取得叶节点中user_name的值返回即可。 

所以：

1. 较频繁的作为查询条件的字段应该创建索引；
2. 唯一性太差的字段不适合单独创建索引，即使该字段频繁作为查询条件；
3. 更新非常频繁的字段不适合创建索引。
4. 一般情况下不鼓励使用like操作，如果非使用不可，如何使用也是一个问题。`like '%aaa%' `不会使用索引而`like 'aaa%'`可以使用索引。

#### 什么是聚簇索引（聚集索引）

```
在InnoDB里，表数据文件本身就是按B+Tree组织的一个索引结构，聚簇索引是一种数据存储方式，它按照每张表的主键构造一颗B+树，同时叶子节点中存放的就是整张表的行记录数据。

聚簇索引查询会更快，因为主键索引树的叶子节点直接就是我们要查询的整行数据了。而非主键索引的叶子节点是主键的值，查到主键的值以后，还需要再通过主键的值再进行一次查询。
```

#### 聚簇索引的缺点

```
插入速度严重依赖于插入顺序，按照主键的顺序插入是最快的方式，否则将会出现页分裂，严重影响性能。因此，对于InnoDB表，我们一般都会定义一个自增的ID列为主键

更新主键的代价很高

二级索引访问需要两次索引查找，第一次找到主键值，第二次根据主键值找到行数据。
```

#### 什么是辅助索引

```
辅助索引，也叫非聚集索引。和聚集索引相比，叶子节点中并不包含行记录的全部数据，叶子结点包含键值和书签(主键)，一般查找的时候，会先通过键值找到主键值，再去聚集索引中找到完整的数据。
```

#### 什么是覆盖索引

```
指一个查询语句的执行只用从辅助索引中就能够取得，不必从查询聚集索引中读取。

如，表covering_index_sample中有一个普通索引idx_key1_key2(key1,key2)。当我们通过SQL语句：select key2 from covering_index_sample where key1 = 'keytest';的时候，就可以通过覆盖索引查询，无需回表
```

#### 什么是联合索引、最左前缀匹配

```
在创建多列索引时，我们根据业务需求，where子句中使用最频繁的一列放在最左边，因为MySQL索引查询会遵循最左前缀匹配的原则，即最左优先，在检索数据时从联合索引的最左边开始匹配。所以当我们创建一个联合索引的时候，如(key1,key2,key3)，相当于创建了(key1)、(key1,key2)和(key1,key2,key3)三个索引，这就是最左匹配原则。
```

联合索引又叫复合索引，所以说创建复合索引时，应该仔细考虑列的顺序。对索引中的所有列执行搜索或仅对前几列执行搜索时，复合索引非常有用；仅对后面的任意列执行搜索时，复合索引则没有用处。

因此我们在创建复合索引时应该将**最常用**作限制条件的列放在**最左边**，依次递减

[我以为我对Mysql索引很了解，直到我遇到了阿里的面试官](https://zhuanlan.zhihu.com/p/73204847)

#### 什么时候创建索引

```

```

#### 什么时候不建或者少建索引

```
表记录太少
经常插入、删除、修改的表
数据重复且分布平均的表字段
```

#### MySQL使用的是什么存储引擎

```
我使用的Mysql5.6使用的是InnoDB作为存储引擎
```

Mysql 底层数据引擎以插件形式设计，MySQL5.5版本之前，MyISAM是MySQL默认的存储引擎，5.5之后，MySQL的默认引擎变成了InnoDB。

#### MyISAM和InnoDB有什么区别

```
InnoDB支持事务，MyISAM不支持
InnoDB支持外键，而MyISAM不支持
InnoDB是聚集索引，使用B+Tree作为索引结构，数据文件是和（主键）索引绑在一起的（表数据文件本身就是按B+Tree组织的一个索引结构），必须要有主键，通过主键索引效率很高。但是辅助索引需要两次查询，先查询到主键，然后再通过主键查询到数据。因此，主键不应该过大，因为主键太大，其他索引也都会很大。
MyISAM是非聚集索引，也是使用B+Tree作为索引结构，索引和数据文件是分离的，索引保存的是数据文件的指针。主键索引和辅助索引是独立的。
InnoDB不保存表的具体行数，执行select count(*) from table时需要全表扫描。而MyISAM用一个变量保存了整个表的行数，执行上述语句时只需要读出该变量即可，速度很快（注意不能加有任何WHERE条件）；
Innodb不支持全文索引，而MyISAM支持全文索引，在涉及全文索引领域的查询效率上MyISAM速度更快高；PS：5.7以后的InnoDB支持全文索引了
InnoDB支持表、行(默认)级锁，而MyISAM支持表级锁
InnoDB表必须有唯一索引（如主键）（用户没有指定的话会自己找/生产一个隐藏列Row_id来充当默认主键），而Myisam可以没有
```

[深入理解 Mysql 索引底层原理](https://zhuanlan.zhihu.com/p/113917726)

### 事务

#### 事务隔离级别

```
未提交读：一个事务可以读取到，另外一个事务尚未提交的变更。
已提交读：一个事务提交后，其变更才会被另一个事务读取到。
可重复读：在一个事务执行的过程中所读取到的数据，和事务启动时所看到的一致。
串行化：当操作一行数据时，读写分别都会加锁。当出现读写锁互斥时，会排队串行执行。
```

#### 事务隔离级别的应用

```
该业务逻辑中写数据一条数据A，并在事务结束前发出去一条消息给其他的应用，其他的应用受到消息会先来查询数据A，然后你很可能会发现其他应用来查询A时发现A并不存在。原因就是整个事务相关的还未commit，其他不在事务中的查询DB请求都读取不到未commit的数据(一般都是读已提交的事务隔离级别ISOLATION_READ_COMMITTED)
```

#### 事务的四大特性

```
原子性：事务要么全部完成，要么全部回滚
	例如A给B转账，要么A扣钱，B收到钱，要么就是A没扣钱，B没收到，不存在A扣钱但是B没收到的情况
隔离性：隔离性是指多个事务并发执行的时候，事务内部的操作与其他事务是隔离的，并发执行的各个事务之间不能互相干扰。
持久性：持久性是指事务一旦提交，它对数据库的改变就应该是永久性的
一致性：一致性是指事务执行前后，数据处于一种合法的状态，这种状态是语义上的。
	例如AB转账总金额不能改变
	数据库根据原子性，隔离性，持久性来保证一致性
```

#### 事务有几种传播机制

```
事务的使用：@Transactional(propagation = Propagation.REQUIRED)

PROPAGATION_REQUIRED 
使用当前的事务,如果当前没有事务,则自己新建一个事务,子方法是必须运行在一个事务中的;如果当前存在事务,则加入这个事务,成为一个整体。	

	在外围方法未开启事务的情况下Propagation.REQUIRED修饰的内部方法会新开启自己的事务，且开启的事务相互独立，互	 不干扰
	
	只要外围方法开启了事务，那么不管里面的方法有没有开启事务，那么这个外部方法整个就是一个事务，一旦内部出现任何	RuntimeException都会进行回滚。
	
PROPAGATION_REQUIRES_NEW	
如果当前有事务,则挂起该事务,并且自己创建一个新的事务给自己使用;

	在外围方法开启事务的情况下Propagation.REQUIRES_NEW修饰的内部方法依然会单独开启独立事务，且与外部方法事务也	 独立，内部方法之间、内部方法和外部方法事务均相互独立，互不干扰(里面的事务用了try catch)。
	
PROPAGATION_NESTED	
(nested，嵌套)
如果当前有事务,则开启子事务(嵌套事务),嵌套事务是独立提交或回滚;

	他修饰的内部方法属于外部事务的子事务，外围主事务回滚，子事务一定回滚，而内部子事务可以单独回滚而不影响外围主	事务和其他子事务
	
NESTED和REQUIRED修饰的内部方法都属于外围方法事务，如果外围方法抛出异常，这两种方法的事务都会被回滚。
但是REQUIRED是加入外围方法事务，所以和外围事务同属于一个事务，一旦REQUIRED事务抛出异常被回滚，外围方法事务也将被回滚。
而NESTED是外围方法的子事务，有单独的保存点，所以NESTED方法抛出异常(用了try catch)被回滚，不会影响到外围方法的事务。

NESTED和REQUIRES_NEW都可以做到内部方法事务回滚而不影响外围方法事务。但是因为NESTED是嵌套事务，所以外围方法回滚之后，作为外围方法事务的子事务也会被回滚。而REQUIRES_NEW是通过开启新的事务实现的，内部事务和外围事务是两个事务，外围事务回滚不会影响内部事务。

我们需要内部事务回滚，但是外部不回滚-->那内部方法使用NESTED
我们需要外部事务回滚，内部事务不回滚-->那么内部方法使用REQUIRES_NEW
我们需要外部事务回滚，内部事务也回滚-->那么就使用默认的REQUIRES

PROPAGATION_SUPPORTS 看父方法有没有事务，有的话我就有，没有的话我就没有

PROPAGATION_NOT_SUPPORTED	父事务有事务，那就挂起，不使用事务去运行

PROPAGATION_MANDATORY	支持当前事务，假设当前没有事务，就抛出异常

PROPAGATION_NEVER	不使用事务，上下文存在事务，就抛出异常
```

#### 事务传播机制的应用

```
PROPAGATION_REQUIRES_NEW
现在有一个发送100个红包的操作，在发送之前，要做一些系统的初始化、验证、数据记录操作，然后发送100封红包，然后再记录发送日志，发送日志要求100%的准确，如果日志不准确，那么整个父事务逻辑需要回滚。
就是通过这个PROPAGATION_REQUIRES_NEW 级别的事务传播控制就可以完成。发送红包的子事务不会直接影响到父事务的提交和回滚


假设我们有一个注册的方法，方法中调用赠送优惠券的方法，如果我们希望赠送优惠券不会影响注册流程（即添加积分执行失败回滚不能使注册方法也回滚）
那么我们可以这样设计
//开启默认的事务
@Transactional
public void register(User user){
	membershipPointService.addPoint(Point point);
}

//addRecord()方法本身和外围addCoupon()方法抛出异常都不会使register()方法回滚
@Transactional(propagation = Propagation.NESTED)
public void addCoupon(Coupon coupon){
	addRecord()
}

//addRecord()方法抛出异常也不会影响外围addCoupon()方法的执行
@Transactional(propagation = Propagation.NOT_SUPPORTED)
public void addRecord(Record record){
}
```

#### 说说AOP在事务中的应用

```
声明式事务管理使用了 AOP 实现的，本质就是在目标方法执行前后进行拦截。在目标方法执行前加入或创建一个事务，在执行方法执行后，根据实际情况选择提交或是回滚事务。
使用这种方式，对代码没有侵入性，方法内只需要写业务逻辑就可以了。
```

### 数据库如何进行调优

```
1. 正确使用索引
		在查询语句当中包含有MAX(),MIN()和ORDERBY这些命令的时候，WHERE判断的字段上创建索引
2. 避免索引失效
		尽量避免使用NOT,(!=或者<>),IS NULL
		尽量避免使用模糊查询前缀%号
		尽量避免条件中有or，或者将这两个字段创建索引
		多列索引，走最左原则
		字符串不加单引号索引失效，也就是对于varchar类型字段传入Int值是无法走索引的，应该做到对应的字段类型传对应的值总是对的
		当一个字段被索引，同时出现where条件后面，是不能进行任何运算
3. 避免使用子查询影响查询效率，而用join
	  之所以更有效率一些，是因为MySQL不需要在内存中创建临时表来完成这个逻辑上的需要两个步骤的查询工作
4. 减少select*，尽量使用覆盖索引(只访问索引的查询(索引列和查询列一致))
5. 在MySQL中尽量所有的update都使用主键id去更新，因为id是聚集索引存储着整行数据，不需要回表，性能是最高的
数据库表结构优化
1. 使用可存下数据的最小的数据类型
2. 使用简单地数据类型，int要比varchar类型在mysql处理上更简单
3. 尽可能使用not null定义字段，每个字段尽量都有默认值
```

### 什么是数据库三范式

```
一范式就是属性不可分割
二范式就是要有主键，要求其他字段都依赖于主键
三范式就是要消除传递依赖，方便理解，可以看做是"消除冗余"
```

[如何理解关系型数据库的常见设计范式？](https://www.zhihu.com/question/24696366)

### 什么是数据库的存储过程

```
SQL语句是需要先编译再执行的，而存储过程（Stored Procedure）是一组为了完成特定功能的SQL语句集，经编译后存储在数据库中，用户通过指定存储过程的名字并给定参数（如果该存储过程带有参数）来调用执行它。

主要的优点有：

- 执行速度较快，因为存储过程是预编译的，在首次运行一个存储过程时查询，优化器对其进行分析优化，并且给出最终被存储在系统表中的执行计划。而批处理的Transaction-SQL语句在每次运行时都要进行编译和优化，速度相对要慢一些。
- 减少网络流量：在调用存储过程时，网络中传送的只是该调用语句，从而大大减少网络流量并降低了网络负载。

由于互联网迭代速度快，现在存储过程在互联网领域很少使用。
```

## 数据库应用题

## Linux

### Linux的常见命令

```
文件的操作
rm mv ls cp pwd grep
网络相关
scp
ssh
防火墙
firewall
查看端口
netstat
查看系统内存
free
查看进程
ps -ef |grep tomcat
jps
查看日志
tail -f查看实时日志
tail -100f查看最后100行的日志
查看当前系统时间
date
Fri Jan 25 14:17:17 CST 2019
```

### Docker常用的命令

```
docker images
docker pull centos

docker run -i -t --name mytest centos:centos6 /bin/bash 从image启动一个container
docker run -d ubuntu

//开启/停止/重启container
docker start CONTAINER_ID
docker stop CONTAINER_ID
docker restart CONTAINER_ID
//查看日志
docker logs
//进入容器
docker exec
//查看容器进程
docker ps -a
```

### 为什么Docker镜像这么小

```
通常我们下载一个centos镜像至少有3G，在docker容器中使用docker pull centos下载的镜像为啥只有200M呢
Linux操作系统分别由两部分组成
1.内核空间(kernel)
2.用户空间(rootfs)
内核空间是kernel,Linux刚启动时会加载bootfs文件系统，之后bootf会被卸载掉，
通过docker pull centos命令下载镜像，实质上下载centos操作系统的rootfs，因此docker下载的镜像大小只有200M

Docker镜像的复用主：多个不同的Docker镜像能够共享同样的镜像层。
```

### Dockerfile

```
Dockerfile由多条指令构成，Dockerfile中的每一条指令都会相应于Docker镜像中的一层。
FROM ubuntu:14.04   --200M 因为使用了
ADD compressed.tar /  --100M
RUN rm /compressed.tar  --命令 
ADD compressed.tar /   --100M

最后总大小为300M
```

## Dubble

什么是RPC调用

```
RPC就是远程过程调用
本地调用某个函数方法
本地机器的RPC框架把这个调用信息封装起来（调用的函数、入参等），序列化(json、xml等)后，通过网络传输发送给远程服务器
过在客户端和服务器之间建立TCP连接
远程服务器收到调用请求后，远程机器的RPC框架反序列化获得调用信息，并根据调用信息定位到实际要执行的方法，执行完这个方法后，序列化执行结果，通过网络传输把执行结果发送回本地机器
本地机器的RPC框架反序列化出执行结果，函数return这个结果
```

## Redis

### Redis为什么很快

```
redis是单线程的
首先，采用了多路复用io非阻塞机制
然后，数据结构简单，操作节省时间
最后，运行在内存中，自然速度快
```

### Redis持久化方案

```
RDB快照(Redis DataBase)
RDB持久化是指在指定的时间间隔内将内存中的数据集快照写入磁盘，也是默认的持久化方式，这种方式是就是将内存中数据以快照的方式写入到二进制文件中,默认的文件名为dump.rdb。
这是默认的配置
save 900 1     #900秒内如果超过1个key被修改，则发起快照保存
save 300 10    #300秒内容如超过10个key被修改，则发起快照保存
save 60 10000
如果数据量很大，保存快照的时间会很长。
AOF日志(Append Only File)
AOF文件保存过程
redis会将每一个收到的写命令都通过write函数追加到文件中(默认是 appendonly.aof)。
always 选项会严重减低服务器的性能；
everysec 选项比较合适，可以保证系统崩溃时只会丢失一秒左右的数据，并且 Redis 每秒执行一次同步对服务器性能几乎没有任何影响；
```

### Redis有几种数据结构，分别有什么应用

```
redis有几种数据结构？
String 整数，浮点数或者字符串
Set 集合
Zset 有序集合
Hash 散列表
List 列表
```

### Redis的应用

```
缓存，毫无疑问这是Redis当今最为人熟知的使用场景。再提升服务器性能方面非常有效；

排行榜，在使用传统的关系型数据库（mysql oracle 等）来做这个事儿，非常的麻烦，而利用Redis的SortSet(有序集合)数据结构能够简单的搞定；

计算器/限速器，利用Redis中原子性的自增操作，我们可以统计类似用户点赞数、用户访问数等，这类操作如果用MySQL，频繁的读写会带来相当大的压力；限速器比较典型的使用场景是限制某个用户访问某个API的频率，常用的有抢购时，防止用户疯狂点击带来不必要的压力；

好友关系，利用集合的一些命令，比如求交集、并集、差集等。可以方便搞定一些共同好友、共同爱好之类的功能；

简单消息队列，除了Redis自身的发布/订阅模式，我们也可以利用List来实现一个队列机制，比如：到货通知、邮件发送之类的需求，不需 要高可靠，但是会带来非常大的DB压力，完全可以用List来完成异步解耦；

Session共享，以PHP为例，默认Session是保存在服务器的文件中，如果是集群服务，同一个用户过来可能落在不同机器上，这就会导致用户频繁登陆；采用Redis保存Session后，无论用户落在那台机器上都能够获取到对应的Session信息。

一些频繁被访问的数据，经常被访问的数据如果放在关系型数据库，每次查询的开销都会很大，而放在redis中，因为redis 是放在内存中的可以很高效的访问
```

### 讲一讲缓存穿透，缓存雪崩以及缓存击穿吧

```
穿透数据库，击穿redis

缓存穿透：就是客户持续向服务器发起对不存在服务器中数据的请求。客户先在Redis中查询，查询不到后去数据库中查询。
缓存击穿：就是一个很热门的数据，突然失效，大量请求到服务器数据库中
缓存雪崩：就是大量数据同一时间失效。

解决缓存穿透：
缓存中取不到的数据，在数据库中也没有取到，这时可以将key-value对写为key-null，这样可以防止攻击用户反复用同一个id暴力攻击
缓存击穿：
最好的办法就是设置热点数据永不过期，拿到刚才的比方里，那就是你买腾讯一个永久会员
```

### redis常用的API

```
BoundHashOperations hashKey = redisTemplate.boundHashOps("HashKey");
Map entries = redisTemplate.boundHashOps("HashKey").entries();
```

## Nginx

### 什么是Nginx的正向代理，什么是反向代理

```
代理也被称为正向代理，是一个位于客户端和目标服务器之间的代理服务器，客户端将发送的请求和制定的目标服务器都提交给代理服务器，然后代理服务器向目标服务器发起请求，并将获得的结果返回给客户端的过程
	为在防火墙内的局域网客户端提供访问Internet的途径,如google网站
	对客户端访问授权，上网进行认证

相对于代理服务，反向代理的对象就是服务器，即代理服务代理的时服务器而不是客户端，它的作用现在是代替服务器接受请求
	负载均衡，通过反向代理服务器来优化网站的负载,反向代理服务器根据每个服务器的性 能来分配请求,保证服务器的负载能在有效的范围内
	
主要是nginx处理静态页面的效率远高于tomcat的处理能力，使用c语言开发的nginx对静态资源每秒的吞吐量是使用Java语言开发的tomcat的6倍
```

## RabbitMQ

### 说说四种模式

```
简单模式：
	就是没有交换机，发布者直接通过队列发送给生产者
工作队列模式：
	也是没有交换机，有一个发布者，一个队列，多个消费者
订阅模式：
- Fanout：广播，将消息交给所有绑定到交换机的队列（收到的消息都是一样的），发送方直接发送给交换机，然后不同的队列去取。
- Direct：定向，把消息交给符合指定routing key 的队列，消息的发送方，必须制定路由，然后发给交换机
```

## Elasticsearch

### 什么是ES

```
ES是一个基于RESTful web接口并且构建在Apache Lucene之上的开源分布式搜索引擎
```

### 说说什么是倒排索引

```
倒排索引通过分词器，将索引库中的内容进行分词，并记录着这个词在位置和次数，当用户进行查询的时候，通过词去找到这个数据，而不是通过这个数据去找到这个词，与正常的检索顺序是相反的，所以叫倒排索引。
```

### 常见的分词器有哪些

```
分为单字分词器
	将中文词分成了一个一个的文字
二分分词器
	将中文每两个分为一个词
词库分词器
	如IKAnalyzer
	IK分词器有两种分词模式：ik_max_word和ik_smart模式，常用的细粒度分词
```

### 怎么自定义拓展词库

```
我们可以在elasticsearch/config/analysis-ik/目录下，新建一个词典
将我们自定义的扩展词典文件添加到IKAnalyzer.cfg.xml配置中即可
```

### ES的结构是什么

```
索引库（indexes）---------------------------------Databases 数据库

类型（type）----------------------------------Table 数据表

文档（Document）--------------------------Row 行

字段（Field）---------------------Columns 列 

映射配置（mappings）--------- 表结构
```

