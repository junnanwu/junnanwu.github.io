# HashMap

## HashMap如何计算槽位

jdk1.7的方式为：`(table.length - 1) & hash`，当length总是2的n次方时，`h & (length-1)`运算, 等价于对length取模，也就是`h%length`，但是&比%具有更高的效率。

jdk1.8对这方面进行了优化：`(h = k.hashCode()) ^ (h >>> 16)`，这里会使得原高位没有变化，而低16位与高16位进行了异或运算，使得低位有了高位的特征。后续在计算数据位置的时候，会通过`(length - 1) & hash`，当length长度较小的时候，只会与hash的低位进行运算，这会使得此种算法出来的槽位更加分散。

## HashMap put步骤

1. 初始化长度默认为16的数组，负载因子为0.75，`最大节点数 = 数组length * 负载因子`
2. 通过上述方式计算槽位
3. 如果节点为空则直接插入
4. 节点不为空，则判断key是否为相同，相同则替换value值
5. 若key值不同，则判断节点是否是红黑树，如果是则插入红黑树
6. 如果不是红黑树，那向后遍历链表，如果key值一样，则替换，如果下一个节点为空，则插入新节点（也就是尾插）
7. 查看当前链表长度是否8，大于的话则把当前链表转为红黑树
8. 查看当前节点数是否达到最大节点数，是的话则扩容，即扩大为原来的2倍，`newCap = oldCap << 1`

源码如下：

```java
/hash：调用了hash方法计算hash值，key：就是我们传入的key值，value：就是我们传入的value值，onlyIfAbsent：也就是当键相同时，不修改已存在的值
  final V putVal(int hash, K key, V value, boolean onlyIfAbsent, boolean evict) {
  //tab就是数组
  Node<K,V>[] tab; 
  //p是插入数组位置上的node
  Node<K,V> p; 
  //n为这个数组的长度，i为要插入的位置
  int n, i;
  //这一部分，先判断数组是否是空的，是的话就通过resize方法来创建一个新的数组
  if ((tab = table) == null || (n = tab.length) == 0)
    n = (tab = resize()).length;
  //第二部分，p是插入位置的node，如果是null，那么就直接插入（(n - 1) & hash 等价取模）
  if ((p = tab[i = (n - 1) & hash]) == null)
    tab[i] = newNode(hash, key, value, null);
  //第三部分，如果插入的部分不为null
  else {
    //新建一个node e
    Node<K,V> e; 
    //插入位置上的node的key
    K k;
    //第三部分第一小节, 如果你要插入数据的hash和对应位置的hash相同且key值相同
    //那么就直接使用插入的值p替换掉旧的值e,也就是key值一样，替换掉原来的
    if (p.hash == hash &&((k = p.key) == key || (key != null && key.equals(k))))
      e = p;
    //第三部分第二小节, key值不同，那么这个节点的类型是红黑树，那么就直接插入红黑树
    else if (p instanceof TreeNode)
      e = ((TreeNode<K,V>)p).putTreeVal(this, tab, hash, key, value);
    //第三部分第三小节，否则就是链表结构
    else {
      //遍历这个链表
      for (int binCount = 0; ; ++binCount) {     		
        //第三小节第一段，p是插入位置的node（采用尾插的方式）
        //如果这个链表p后面没有节点了(e)，意思就是这个位置只有一个，新增节点并退出循环
        if ((e = p.next) == null) {
          //那么就新建一个节点
          p.next = newNode(hash, key, value, null);
          //判断当前链表的长度是否大于阈值8，如果大于那就会把当前链表转变成红黑树
          if (binCount >= TREEIFY_THRESHOLD - 1) // -1 for 1st
            treeifyBin(tab, hash);
          break;
        }
        //第三小节第二段，e是p后面的节点，
        //p后面有值，就是e
        //这一步跟上面一样，插入的key与e的key一样，退出循环，后面不用看了
        if (e.hash == hash &&((k = e.key) == key || (key != null && key.equals(k))))
          break;
        //第三小节第三段，将p后面的节点e给p，相当于后移了
        p = e;
      }
    }
    //第三部分第四小节
    //上一步的break，要么是新节点，要么是key一样的节点，用新的value替换旧的，并返回value
    if (e != null) { // existing mapping for key
      V oldValue = e.value;
      if (!onlyIfAbsent || oldValue == null)
        e.value = value;
      afterNodeAccess(e);
      return oldValue;
    }
  }
  ++modCount;
  //第四部分
  //size是实际存在的键值对数量
  //插入成功之后，还要判断一下实际存在的键值对数量size是否大于阈值threshold。如果大于那就开始扩容了
  if (++size > threshold)
    resize();
  afterNodeInsertion(evict);
  return null;
}
```

## HashSet

HashSet内部由HashMap实现：

```java
private static final Object PRESENT = new Object();

public HashSet() {
    map = new HashMap<>();
}

public int size() {
    return map.size();
}
public boolean isEmpty() {
    return map.isEmpty();
}

public boolean add(E e) {
    return map.put(e, PRESENT)==null;
}
```

https://coolshell.cn/articles/9606.html