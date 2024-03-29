# Redis持久化

Redis是内存数据库，如果不将数据持久化到硬盘上，那么一旦服务状态进程退出，那么数据也会丢失，为此，Redis提供了两种持久化的方式，RDB模式和AOF模式。

## RDB模式

RDB模式将某个时间点上的数据库状态保存到一个RDB文件中，该文件还可以还原生成时候的数据库状态。

该模式既可以手动执行，也可以配置定期执行。

### 手动模式

有两个命令可以用于生成RDB文件，一个是`SAVE`，另一个是`BGSAVE`，`SAVE`命令会阻塞Redis服务器进程，直到RDB文件创建完毕为止，这期间，服务器不能处理任何命令请求，而`BGSAVE`则会派生出一个子进程进行处理。

至于载入RDB文件，只要Redis服务器在启动的时候检测到RDB文件的存在，它就会自动载入RDB文件。

注意：因为AOF文件的更新频率同行更高，那么如果服务器开启了AOF，那么服务器会优先使用AOF文件还原数据库状态。

### 自动保存

RDB模式还可以通过设置服务器配置的save选项，让服务器每隔一段时间执行一次`BGSAVE`命令，例如：

```
save 900 1     //900秒内，1次修改
save 300 10    //300秒内，10次修改
save 60 10000  //60秒内，100000次修改
```

上述配置意味着只要满足上述三个条件的任意一个，`BGSAVE`命令就会执行。

**自动保存的实现原理**

Redis内部有个dirty计数器，服务器每执行一个数据库修改（一次修改，不是一条语句）之后，dirty计数器都会进行增加，还有一个lasetsave属性，即上次save的时间，save后此，dirty计数器会被清零。

Redis服务器每100秒执行一次周期性操作函数，`serverCron`，该函数的任务之一就是检查save选项所保存的条件是否满足，满足即调用`BGSAVE`。

## AOF模式

AOF（Append only file）模式，是通过保存Redis服务器所执行的写命令来记录数据库状态，类似mysql binlog的`statement-based`模式。

该模式下，命令请求会先保存到AOF缓冲区中，然后根据`appendfsync`选项来选择不同的策略来持久化：

- `always`

  将缓冲区的所有内容写入并同步到AOF文件。

- `everysec`

  如果上次AOF距现在超过一秒钟，则对AOF文件进行同步（默认）。

- `no` 

  将缓冲区所有内容写到AOF，但并不对AOF文件进行同步，何时同步由操作系统决定。

### AOF文件重写

为了解决AOF文件体积膨胀问题，Redis提供了AOF文件重写功能，Redis会创建一个新的AOF文件来替代现有的AOF文件。

此重写并非真正的重写，此功能不是通过分析、优化原有语句实现的，而是分析数据库的状态：

首先从数据库中读取现在的值，然后生成一条语句去记录当前键值对，代替之前记录这个键值对的多个复杂冗余语句。

## References

1. 《Redis设计与实现》——黄健宏
