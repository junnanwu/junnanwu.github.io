# Java调用本地命令

在Java中要想执行脚本或者调用程序必须通过ProcessBuilder 和 Runtime 类。

## Process类

`ProcessBuilder.start()` 和 `Runtime.exec()`方法都被用来创建一个操作系统进程（执行命令行操作），并返回 Process 子类的一个实例，该实例可用来控制进程状态并获得相关信息。

Process类提供了执行从进程输入、执行输出到进程、等待进程完成、检查进程的退出状态以及销毁（杀掉）进程的方法。创建进程的方法可能无法针对某些本机平台上的特定进程很好地工作，比如，本机窗口进程，守护进程，Microsoft Windows 上的 Win16/DOS 进程，或者 shell 脚本。创建的子进程没有自己的终端或控制台。它的所有标准 io（即 stdin、stdout 和 stderr）操作都将通过三个流 (`getOutputStream()`、`getInputStream()` 和 `getErrorStream()`) 重定向到父进程。父进程使用这些流来提供到子进程的输入和获得从子进程的输出。因为有些本机平台仅针对标准输入和输出流提供有限的缓冲区大小，如果读写子 进程的输出流或输入流迅速出现失败，则可能导致子进程阻塞，甚至产生死锁。 当没有 Process 对象的更多引用时，不是删掉子进程，而是继续异步执行子进程。 对于带有 Process 对象的 Java 进程，没有必要异步或并发执行由 Process 对象表示的进程。

通过查看JDK源码可知，`Runtime.exec`最终是通过调用ProcessBuilder来真正执行操作的。

例如，Mac OS调用phantomjs：

```java
String url = "https://hxduat.xxx.com/report/company_operations_daily_report/multi-progress.html";
String cmd = "phantomjs template/script/getImage.js" + " " + url;
System.out.println("开始执行...");
Runtime.getRuntime().exec(cmd).waitFor();
System.out.println("执行结束!")
```

## Apache Common-Exec

Apache的第三方库，该库提供了更加详细的设置和监控方法等等。

## References

1. https://www.cnblogs.com/ontway/p/7455249.html