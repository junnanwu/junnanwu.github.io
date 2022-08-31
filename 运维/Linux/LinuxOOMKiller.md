# Linux OOM Killer

`/var/log/message`日志如下所示：

```
Aug 17 02:05:38 txy-bj-jr-data-pro-node1 kernel: [ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
Aug 17 02:05:38 txy-bj-jr-data-pro-node1 kernel: [19690]  1003 19690  2564438   676252    1499        0             0 java

Aug 17 02:05:38 txy-bj-jr-data-pro-node1 kernel: Out of memory: Kill process 19690 (java) score 166 or sacrifice child
Aug 17 02:05:38 txy-bj-jr-data-pro-node1 kernel: Killed process 19690 (java), UID 1003, total-vm:10257752kB, anon-rss:2705008kB, file-rss:0kB, shmem-rss:0kB
```

- vm/vsz

  虚拟内存大小（Virtual Memory Size），表明是虚拟内存的大小，表明了该线程可以访问的所有内存的大小，包括被交换的内存和共享库内存。

- rss

  常驻内存集（Resident Set Size），表示相应进程再RAM中占用实际物理内存的大小，不包括在SWAP中占用的虚拟内存的大小。

### 查看某个线程的分数

```
$ cat /proc/29697/oom_score
102
```

### 查看所有线程的分数

```
$ ps -eo pid,comm,pmem --sort -rss | awk '{"cat /proc/"$1"/oom_score" | getline oom; print $0"\t"oom}'
```

### 防止某个线程被Kill

设置参数/proc/PID/oom_adj为-17，可临时关闭linux内核的OOM机制。

```
$ echo -17 > /proc/$PID/oom_adj
```

阅读内核源码可知oom_adj的可调值为15到-16，其中15最大-16最小，-17为禁止使用OOM。oom_score为2的n次方计算出来的，其中n就是进程的oom_adj值，所以oom_score的分数越高就越会被内核优先杀掉。

## References

1. https://blog.51cto.com/laoxu/1267097
2. https://stackoverflow.com/questions/18845857/what-does-anon-rss-and-total-vm-mean