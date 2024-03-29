# MySQL索引

InnoDB支持如下索引：

- B+数索引
- 全文索引
- 哈希索引

## 为何采取B+树作为索引

- 二叉树

  二叉树查找的时候即二分查找，加快了查询效率，但缺点在于当数据顺序插入的时候 ，会退化为链表。

- 平衡二叉树

  平衡二叉树的定义如下：

  符合二叉树的条件下，任何节点的两个子树的高度差最大为1，否则通过左旋或者右旋来保持平衡。

  这显然解决了二叉树不平衡的问题，但是平衡二叉树每个节点只有一个关键字，树的高度较大，导致查询次数变多，即I/O次数变多，影响查询性能。

  （为什么I/O次数会很多）

- B树

  B即Balance，平衡多路查找树，每个节点可以有多个关键字，解决了平衡二叉树高度太大的问题。

- B+树

  B+数又对B数进行了改进：

  - B+树的非叶子节点不保存具体的数据，而只保存关键字的索引

  - 所有的数据最终都会保存到叶子节点

    因为所有数据必须要到叶子节点才能获取到，所以每次数据查询的次数都一样，查询速度更稳定，而且遍历所有节点的时候，更加方便。

  - B+树叶子节点的关键字从小到大有序排列

    所以对排序和范围查找有更好的支持。

## 聚集索引

聚集索引（Clustered  Index）即按照每个表的主键构造一颗B+树，同时叶子节点存放的即为整张表行记录数据。

如果没有定义主键，InnoDB会选择以唯一索引来代替，如果没有唯一索引，那么InnoDB会隐式定义一个主键来作为聚集索引（一个6字节大小的指针）。

## 辅助索引

辅助索引（Secondary Index），也称为非聚集索引/二级索引，叶子节点并不包括行记录的全部数据，叶子节点包含索引键和主键。

当通过辅助索引进行查找的时候，先通过辅助索引查找到指定主键，再对聚集索引树通过主键进行查找，最后找到对应的数据页。

## 联合索引

联合索引（Composite Indexes），又称为多列索引（Multiple-column Index），和辅助索引相似，叶子节点都是存储的索引值和主键地址，只不过联合索引值是多个列。

例如，一个有a,b两列的表，对a, b两列创建联合索引：

![composite_index_example](mysql_index_assets/composite_index_example.png)

通过叶子节点可以读出所有数据，数据按照 (a,b) 的顺序进行了存放。

### 最左匹配



## 覆盖索引

覆盖索引（Covering Index），即一个索引包含所有需要查询的字段的值，我们就称之为覆盖索引，覆盖索引不是一种索引，而是一种执行计划。

覆盖索引的好处就是辅助索引不包含整行记录的所有信息，故其索引要远小于聚集索引，可以减少大量 I/O操作。

好处：

当执行`count(*)`的时候，当有辅助索引的时候，由于辅助索引更小，所以存储引擎会选择使用辅助索引来实现。

当使用覆盖索引的时候，Mysql的Explain的Extra列可以看到`Using index`的信息。

例如：

点那个表有一个多列索引(a,b)，执行下面语句：

```
SELECT a, b FROM table;
```

就可以使用这个索引做覆盖索引。

## References

1. 书籍：《MySQL技术内幕—INNODB存储引擎》—— 姜承尧