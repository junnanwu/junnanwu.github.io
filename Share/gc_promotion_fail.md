# Promotion Failure引发的服务超时：CMS底层原理与调优实战

对于后台服务来说，我们希望用户的使用体验更好，相较于高吞吐，我们更关心低延迟，所以以最短停顿时间为目标的 CMS 收集器是不错的选择。

> 吞吐量 = 代码运行时间 /（代码运行时间 + 垃圾收集时间）

在了解Promotion Failure问题之前，我们先了解下CMS垃圾收集器的设计理念。

## 传统收集器的内存划分

关于对象的生命周期有两个假说：

- 绝大多数对象都是朝生夕灭的
- 熬过多次垃圾收集过程的对象就越难以消亡

基于以上两个分代假说，多数垃圾收集器进行了分代设计，将对象存储区域分为新生代和老年代，新生代关注少量存活的对象，剩下难以消亡的对象，转移到老年代，老年代就不用频繁进行回收了。

新生代绝大多数对象都是朝生夕灭，只有少量对象存活，所以大多数新生代垃圾收集器都采用了复制算法。

要想实现复制算法，可以将新生代一分为二，先使用其中的一个区，该区满了之后，将少量的存活对象复制到另一个区，如下图所示：

![gc_copy](gc_promotion_fail_assets/gc_copy.jpg)

但是一次只能使用新生代的一半内存，浪费严重。

于是Serial、ParNew等新生代收集器的新生代都将内存区域分为较大的Eden区和两块较小的Survivor区，每次只使用Eden和其中一块Survivor区（From），发生收集的时候，将Eden区和其中一块Survivor区中存活的对象复制到另外一块Survivor区（To）。

当然，复制的过程涉及存活对象的移动，需要暂停用户线程，即STW（Stop The World）。

新生代和老年代内存划分如下图所示：

![memory_distribution](gc_promotion_fail_assets/memory_distribution.jpg)

HotSpot虚拟机Eden和Survivor的默认大小比例是8:1，所以新生代内存利用率达到了90%。

默认新生代和老年代的大小比例为1:2，且新生代每复制一次对象的年龄就加一，达到一定年龄，就会晋升老年代，默认晋升年龄为6次。

Serial和ParNew这两个新生代收集器都采用了复制算法，区别是，Serial是一个单线程的收集器，而ParNew是Serial的多线程版本，可以使用多条线程同时进行垃圾收集。ParNew是激活CMS后默认的新生代收集器。

## 适合老年代的收集算法

对于老年代来说，回收后仍然有大量的存活对象，而复制算法需要复制大量存活的对象，显然不合适，有两种常用于老年代的收集算法：

**标记-整理算法**，标记所有待回收对象后，将所有存活的对象移动到内存空间的一侧

![gc_compact](gc_promotion_fail_assets/gc_compact.jpg)

标记-整理算法的优点是收集后的内存是连续的，分配效率更高，而且没有内存碎片问题，缺点是老年代存活对象数很多，移动并更新所有引用成本很高，STW时间较长。

但是由于内存分配和访问更加频繁，整体的吞吐是更高的，所以，关注吞吐量的Parallel Scavenge收集器是基于标记-整理算法的。

**标记-清除算法**，标记完所有待回收对象后，回收掉这些对象：

![gc_sweep](gc_promotion_fail_assets/gc_sweep.jpg)

标记-清除算法的优点是清除待回收对象不涉及对象移动，所以耗时较短，而且可以和用户线程并行进行，缺点是会产生大量内存碎片。

## CMS收集器

CMS（Concurrent Mark Sweep），从名字就可以看出来，是一款采用标记-清除算法的老年代垃圾收集器，CMS的收集过程如下：

![cms_gc_phase](gc_promotion_fail_assets/cms_gc_phase.jpg)

- 初始标记是标记GC Roots能直接关联到的对象，速度很快
- 并发标记是从GC Roots直接关联的对象开始遍历整个对象图，不需要停顿用户时间
- 重新标记是修正并发标记期间产生的新对象，停顿时间稍微长点
- 最后是并发清理，采用清除算法，所以不需要移动存活对象，所以是可以和用户线程并发进行的

我们可以看到，CMS需要STW的仅仅是初始标记和重新标记阶段，所以延迟时间很短（4核8G服务器，3G左右大小的老年代，需200-300ms）。

## CMS收集器的缺点

**处理器资源敏感**

处理器资源敏感是并发程序通用的问题，默认CMS启动的回收线程数是：(处理器核心数量+3) /4，当CPU为两核的时候，需要有50%的处理器资源（一个线程）进行垃圾回收，可能导致用户线程执行速度大幅降低，如果CPU为四核及以上，那垃圾收集线程只会占用不超过25%的CPU资源，我们生产服务器为四核，启动一个回收线程，影响有限。

**无法处理浮动垃圾**

我们从上面CMS回收过程可以看到，并发清理的过程是和用户线程同时进行的，所以在清理的过程中，还会有新的对象晋升入老年代，被称为“浮动垃圾”，所以**CMS不能像其他收集器那样，等老年代几乎满了再进行回收，所以还需要预留一些空间，默认老年代内存达到92%的时候，触发老年代回收**。

**内存碎片**

由于CMS采用的是标记-清除算法，会产生大量的内存碎片，也会出现老年代还有很多剩余空间，但是无法找到连续的空间来分配对象，尤其是大对象。

## CMS收集器常见问题

由于CMS无法处理浮动垃圾并且存在内存碎片，常见有以下两个问题：

- **Promotion Failed**（晋升失败）
- **Concurrent Mode Failure**（并发失败）

Promotion Failed 是在进行Minor GC后，对象进入老年代，而此时老年代因为剩余空间不足或者没有足够的连续内存空间来存放这些对象。

Concurrent Mode Failure 是在**执行CMS GC并发周期的过程中**同时有对象要放入老年代，而此时老年代空间不足造成的。

以上两种情况多数时候（[详见此](https://icefrozen.github.io/article/java-cms-gc-log)）会导致CMS退化为Serial Old收集器对整个堆进行Full GC，导致较长的停顿时间。

## 问题现象

2025年3月28日，19:50到20:10之间，业务方调用我们的画像服务有大量的请求超时情况，业务方RPC超时时间为500ms。

## 排查过程

首先观察服务监控看板，服务器内存和CPU水位都在正常范围，具体看来：

- 内存在19:30从72%上涨到74%左右，在正常范围内
- CPU水位在19:30无明显变化（后续CPU下降是20:05扩容导致）

![dashboard_memory](gc_promotion_fail_assets/dashboard_memory.jpg)

![dashboard_cpu_avg](gc_promotion_fail_assets/dashboard_cpu_avg.jpg)

接下来看GC监控是否正常，发现在日志超时的时间点，频繁CMS GC，并且耗时相较平时的CMS GC（图中左侧的GC，200毫秒左右），时间较长，均在1秒以上，判断该GC非正常CMS GC：

![dashboard_old_cms_pause_time](gc_promotion_fail_assets/dashboard_old_cms_pause_time.jpg)

通过老年代的内存看板也能看出该GC非正常CMS GC，因为没有达到老年代最大内存就提前回收：

![dashboard_old_generation_memory](gc_promotion_fail_assets/dashboard_old_generation_memory.jpg)

由于我们之前新增了打印GC日志的参数，所以通过less命令（生产环境大文件不要使用vim打开，vim会加载全部文件，占用过多内存），搜索当天gc.log文件中第一个出现的【full 18】，日志如下所示：

![full_18_gc_log](gc_promotion_fail_assets/full_18_gc_log.png)

中间promotion failed日志含义：

- Minor GC在2025-03-28T19:58:51.679发生回收，新生代大小从274943K （268.5M）到274119K（267.7M），共花0.069s（至于为什么新生代回收后还这么大，是因为晋升失败是不会对Eden和From区的对象做释放的，[详见此文](http://lovestblog.cn/blog/2016/05/18/ygc-worse/)）
- 紧接着一次Full GC，从2784749K（2719.5M）到760844K（743.01M），共耗时1.387s

并且使用[gceasy](https://gceasy.io/)对GC日志进行分析，也可以看到有一次GC的原因是Promotion Failure，耗时1.38s：

![easygc_gc_causes](gc_promotion_fail_assets/easygc_gc_causes.jpg)

## 原因分析

从GC日志中，可以明确的是**：本次较长时间的停顿是Promotion Failed后，CMS退化为Serial Old，对整个堆进行串行收集导致的。**

结合初始配置、GC日志（打印初始参数）、监控等，我们得知我们服务GC配置如下：

- 堆总大小：4G
- **新生代总大小：332.75M**
- Eden区和Survivor区的比例：8:1 （即Survivor区33.2M）
- 晋升老年代年龄：6
- 老年代总大小：3.68G
- **老年代触发GC比例：92%**（从JDK6开始CMS触发比例从68%提升到92%）

其中关于新生代的默认大小，有些出乎意料：

之前一直认为，NewRatio 默认为 2，也就是 YoungGen 与 OldGen的比例是 1:2，那新生代大小应该是 4G/3 = 1365M，但是实际上并非如此，CMS会根据CPU核数等进行一个比较复杂的计算，得到一个值（332.75M），并和上面NewRatio计算出的值（1365M）相比，然后取较小的那个，即332.75M。具体参考[此文](https://cloud.tencent.com/developer/article/1424252)。

**为什么会发生Promotion Failed？**

前面我们提到，Promotion Failed是在进行Minor GC时，Survivor区放不下，对象只能放入老年代，而此时老年代因为剩余空间不足或者没有足够的连续内存空间来存放这些对象。

gceasy中显示的老年代内存使用情况：

![easygc_old_generation_memory](gc_promotion_fail_assets/easygc_old_generation_memory.jpg)

我们可以看到在19:30，老年代GC增长的曲线开始变陡，随后陆续发生Promotion Failed，我们分别看下变陡前后新生代向老年代的晋升量：
18:19发生一次Young GC，向老年代晋升2375232K-2375178K=54KB，GC log如下所示：

![normal_young_gc_log](gc_promotion_fail_assets/normal_young_gc_log.png)

而19:58，曲线较陡的时候，向老年代晋升2784182K-2783610K=572K，GC log如下所示：

![large_size_young_gc_log](gc_promotion_fail_assets/large_size_young_gc_log.png)

证实确实突然有大量对象晋升到老年代，所以推测，当时请求量变大，同时出现一些大参数的请求，并且晋升年龄较小（默认为6），导致**老年代晋升了一些大对象，而老年代剩余空间碎片化较严重，导致这些大对象无法分配，从而导致Promotion Failed**。

通过查看RPC接口请求日志，确实存在一些较大的请求参数。

## 调优思路

- **增加新生代大小**（-Xmn1536m），减少新生代回收的频次，从而减少promtion动作
- 老年代提前触发GC（-XX:CMSInitiatingOccupancyFraction=60），多留出一些的空闲空间
- 增加晋升年龄至15（-XX:MaxTenuringThreshold=15），同样减少promotion动作
- 减少大对象的存在，优化接口，限制一次接口请求的参数

## 调优效果

根据上面的调整思路，将配置调整为：

```
-Xmn1536m  -XX:MaxTenuringThreshold=15
-XX:CMSInitiatingOccupancyFraction=60
-XX:+UseCMSInitiatingOccupancyOnly
```

调整后：

15秒内一共发生4次采集，共计60ms（图中15秒采集一次）；

![dashboard_after_optimized](gc_promotion_fail_assets/dashboard_after_optimized.jpg)

调整前：

15秒一共发生21次采集，共计340ms;

![dashboard_before_optimized](gc_promotion_fail_assets/dashboard_before_optimized.jpg)

年轻代的回收次数缩小了4倍（20/5），耗时缩小5倍（300/60） 。

每次晋升老年代大小降低为1220949K-1220943K=6K，显著减少。

![after_optimize_gc_log](gc_promotion_fail_assets/after_optimize_gc_log.png)

且时至今日（2025-12-14），未再出现Promotion Failure问题。

## 最后

1. **高并发服务使用CMS的时候，必须显式指定下新生代大小（-Xmn）**，默认的新生代大小过小，在高并发的情况下大量对象过早晋升，可能导致Promotion Failure或者Concurrent Mode Failure
2. 高并发服务使用CMS的时候，建议调低CMS的触发阈值，默认的92%过高，可能导致Promotion Failure或者Concurrent Mode Failure
3. **高并发服务一定打印GC日志（所有Java服务都应该打印，对性能影响有限）**，不然发生GC异常毫无排查手段
4. 遇到此类RT高问题，先看服务、GC大盘，有无异常，再看具体接口细节
5. 不要只看单台机器和单个时间点的监控，要时间横向对比（和平时的CMS GC对比，更容易发现问题），服务横向对比
6. 高并发的服务，尽量避免出现大对象

## References

1. [《深入理解Java虚拟机（第3版）》](https://book.douban.com/subject/34907497/) 周志明
2. [Java中9种常见的CMS GC问题分析与解决](https://tech.meituan.com/2020/11/12/java-9-cms-gc.html)
3. [Major GC和Full GC的区别是什么？触发条件呢？ - RednaxelaFX的回答](https://www.zhihu.com/question/41922036/answer/93079526)
4. [Java Hotspot G1 GC的一些关键技术](https://tech.meituan.com/2016/09/23/g1.html)
5. [Java垃圾回收详解(6)](https://icefrozen.github.io/article/java-cms-gc-log/)
6. [CMS GC 新生代默认是多大？](https://cloud.tencent.com/developer/article/1424252)
7. [Metaspace 之三--jdk8 Metaspace 调优](https://www.cnblogs.com/duanxz/p/10276603.html)
8. [关于CMS GC的一些疑问](https://hllvm-group.iteye.com/group/topic/41018)
9. [YGC前后新生代变大？](http://lovestblog.cn/blog/2016/05/18/ygc-worse/)





