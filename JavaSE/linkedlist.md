# LinkedList

## ArrayList与LinkedList的区别

- 存储结构

  - ArrayList动态数组
  - LinkedList为双向链表，不存在扩容问题

- 随机访问

  - ArrayList擅长随机访问
  - LinkedList不擅长随机访问

- 增删

  - ArrayList在增删的时候，主要耗时的是移动元素
  - LinkedList在增删的时候，主要是需要先找到位置为index的元素

  所以数据量大小、插入数据量、增删的位置都会影响增删的效率。

- 内存占用

  - ArrayList的内存浪费在不管有没有元素，都占用了分配的内存

  - LinkedList的内存消耗在于，一个节点存储了指向下一个和上一个的指针

## 什么时候使用LinkedList

在大数据量、非常靠前的位置进行增删的时候，可以选择LinkedList。

例如：

10, 000条数据，在1/10处（1000处）插入10, 000条数据，二者的时间差不多，越往后的位置插入，ArrayList越快。

所以，除了在大数据量的头部增删外，效率角度大部分场景都都是使用ArrayList（由于ArrayList的内存占用更紧密，影响缓存）。

另外LinkedList实现了Queue接口，栈、队列以及双端队列等数据结构使用LinkedList实现更简单。



