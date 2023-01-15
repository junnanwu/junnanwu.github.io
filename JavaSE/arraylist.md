# ArrayList

## 关于扩容

每次新增的时候，ArrayList会判断是需要扩容，需要的话，会扩容为原来的1.5倍：

```java
int newCapacity = oldCapacity + (oldCapacity >> 1);
```

## 关于遍历过程中删除元素

### 为什么会报错

AbstractList中有一个变量，记录了这个List修改的次数：

```java
protected transient int modCount = 0;
```

在add或remove的时候，该变量都会加1：

```java
modCount++;
```

使用迭代器对List进行迭代的代码如下（与foreach等效）：

```java
private static void useIterator(List<String> list) {
    Iterator<String> iterator = list.iterator();
    while (iterator.hasNext()) {
        System.out.println(iterator.next());
    }
}
```

下面是获取Iterator的源码：

```java
public Iterator<E> iterator() {
    return new Itr();
}
```

Iterator是ArrayList的一个内部类：

```java
private class Itr implements Iterator<E> {
    public boolean hasNext() {
        return cursor != size;
    }

    public E next() {
        checkForComodification();
        //...
        return (E) elementData[lastRet = i];
    }
    
    final void checkForComodification() {
        if (modCount != expectedModCount)
            throw new ConcurrentModificationException();
    }
}
```

Iterator在调用`next()`方法的时候，**会先检查此时的修改次数是否和创建迭代器时候的修改次数相同，不同，则报错**。

即`modCount != expectedModCount`，所以，理论上，在迭代的过程中进行修改，就应该抛出ConcurrentModificationException。

### 一定会报错吗

但是，在我测试的时候，发现在某些情况，并没有抛出ConcurrentModificationException，例如如下代码：

```java
private static void removeWithForEach() {
    List<String> list = new ArrayList<>();
    list.add("1");
    list.add("2");
    list.add("3");
    for (String s : list) {
        if (s.equals("2")) {
            list.remove("2");
        }
    }
    System.out.println(list);
}
```

输出：

```
[1, 3]
```

后来发现问题出在`Iterator.hasNext`方法上：

```java
public boolean hasNext() {
    return cursor != size;
}
```

当remove了倒数第二个元素之后，size-1，而再次调用hasNext方法的时候，cursor也移到了最后一个元素上，二者正好相等，也就是说**并不会进入最后一个循环**。

我们加入如下打印语句：

```java
for (String s : list) {
    System.out.println("迭代到: " + s);
    if (s.equals("2")) {
        list.remove("2");
    }
}
System.out.println(list);
```

会发现，确实没有进入最后一个循环：

```
迭代到: 1
迭代到: 2
[1, 3]
```

**删除其他元素会出现这种情况吗？**

如果remove了倒数第二个前面的元素，例如倒数第三个元素，那么删除之后，size-1，而再次调用hasNext方法的时候，`cursor == size`，将执行next方法，然后发现`modCount > expectedModCount`，抛出ConcurrentModificationException。

如果remove了最后一个元素，`size - 1`，而再次调用hasNext方法的时候`cursor > size`，依然返回true，同样的，执行next方法，发现`modCount > expectedModCount`，抛出ConcurrentModificationException。

**所以，当remove倒数第二个元素的时候，恰好不会报错，在迭代中删除其他任何元素都会报错。**

当add的时候，由于`size + 1`，所以无论在哪里插入，`cursor < size`都成立，然后出现`modCount > expectedModCount`从而报错。

也可参考：[【Java】ArrayList迭代时remove元素 , 未抛出ConcurrentModificationException异常](https://blog.csdn.net/m0_46202073/article/details/109477305)