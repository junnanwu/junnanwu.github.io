# 线程中断

## 线程何时会停止

- 线程正常中止

  `run()`方法执行到`return`语句返回

- 线程意外终止

  `run()`方法因为未捕获的异常导致线程终止

- 人为终止

  对某个线程的`Thread`实例调用`stop()`方法强制终止

## 被弃用的Thread.stop()

当我们采用`stop()`这种暴力的方式终止目标线程的时候，目标线程会立即被终止，导致类似`finally`中的清理工作无法完成，并导致目标线程立即释放所持有的锁，可能会导致数据的不同步，所以Thread的`stop()`方法被标记为弃用。

那么代替`stop()`的则是中止机制，即我们并不强迫目标线程立即终止，而是向其发送中止信号，由目标线程本身自己处理。

## Thread.interrupt()

上面说的向目标线程发送中止信号的操作，由`Thread.interrupt()`来执行，具体来说，其行为如下：

> If this thread is blocked in an invocation of the wait(), wait(long), or wait(long, int) methods of the Object class, or of the join(), join(long), join(long, int), sleep(long), or sleep(long, int), methods of this class, then its interrupt status will be cleared and it will receive an InterruptedException.
>
> If this thread is blocked in an I/O operation upon an InterruptibleChannel then the channel will be closed, the thread's interrupt status will be set, and the thread will receive a java.nio.channels.ClosedByInterruptException.
>
> ...
>
> If none of the previous conditions hold then this thread's interrupt status will be set.

- 如果线程被`wait()`、`sleep(long)`、`join()`等阻塞，将抛出`InterruptedException`**并清除中断标志**
- 如果线程处于IO阻塞，那么线程将抛出`ClosedByInterruptException`，并设置中断标志
- 如果线程未处于阻塞状态，则仅设置中断标志

## 处理中断信号

`Thread.interrupt()`方法向目标线程发出了中止信号，接下来就需要目标线程对中止信号进行相应的处理了。

### 无阻塞方法

循环检查本线程的中断标志位，如果被设置了中断标志就自行停止线程。

简单示例如下：

```java
public class InterruptOfFlag {
    public static void main(String[] args) throws InterruptedException {
        AThread thread01 = new Thread01();
        thread01.start();
        //让目标线程运行1ms
        Thread.sleep(1);
        thread01.interrupt();
        thread01.join();
        System.out.println("测试结束! ");
    }
}

class Thread01 extends Thread {
    @Override
    public void run() {
        System.out.println("开始目标线程...");
        int count = 0;
        while (!isInterrupted()) {
            System.out.println("Hello " + count++);
        }
        System.out.println("退出目标线程! ");
    }
}
```

运行结果如下：

```
开始目标线程...
Hello 0
Hello 1
Hello 2
...
Hello 30
退出目标线程! 
测试结束! 
```

### 阻塞方法

当有阻塞方法的时候，需要正确处理`InterruptedException`异常，正常结束线程：

```java
public class InterruptOfException {
    public static void main(String[] args) throws InterruptedException {
        Thread thread02 = new Thread02();
        thread02.start();
        Thread.sleep(1000);
        thread02.interrupt();
        thread02.join();
        System.out.println("测试结束! ");
    }
}

class Thread02 extends Thread {
    @Override
    public void run() {
        System.out.println("开始目标线程...");
        int count = 0;
        while (!isInterrupted()) {
            System.out.println("Hello " + count++);
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                break;
            }
        }
        System.out.println("退出目标线程! ");
    }
}
```

运行结果如下：

```
开始目标线程...
Hello 0
Hello 1
...
Hello 9
退出目标线程! 
测试结束! 
```

## 检测中断标志的方法

上述两个案例中采用了`isInterrupted()`的方式，此种方式不会清除中断标志。

- `interrupted()`

  ```java
  public static boolean interrupted() {
      return currentThread().isInterrupted(true);
  }
  ```

  此静态方法会清除标志位，并不是代表线程又恢复了，可以理解为仅仅是代表它已经响应完了这个中断信号然后又重新置为可以再次接收信号的状态。

  也就意味着当此检测到此方法为true的时候，如果没有正常处理，那么其他方法将不再后机会进行处理，除非内部再次调用`interrupt()`。

- `isInterrupted()`

  ```java
  public boolean isInterrupted() {
      return isInterrupted(false);
  }
  ```

- `isInterrupted(boolean ClearInterrupted)`

  ```java
  private native boolean isInterrupted(boolean ClearInterrupted);
  ```

## References

1. https://www.liaoxuefeng.com/wiki/1252599548343744/1306580767211554
2. https://docs.oracle.com/javase/8/docs/technotes/guides/concurrency/threadPrimitiveDeprecation.html
3. https://www.zhihu.com/question/41048032
