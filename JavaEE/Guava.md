**unmodifiable**

Collections.unmodifiableXxx所返回的集合和源集合**是同一个对象**，只不过可以对集合做出改变的API都被override，会抛出UnsupportedOperationException。

所以当我们改变源集合，那么也会导致不可变集合变化。

**defensive copies**

那么我们要想避免上述情况，就需要进行保护性拷贝

```java
@Test
public void testUnmodifiable(){
  ArrayList<String> list = new ArrayList<>();
  list.add("a");
  list.add("b");
  list.add("c");
  //3
  System.out.println(list.size());
  List<String> unmodifiableList1 = Collections.unmodifiableList(list);
  List<String> unmodifiableList2 = Collections.unmodifiableList(new ArrayList<>(list));
  list.add("d");
  //4
  System.out.println(unmodifiableList1.size());
  //3
  System.out.println(unmodifiableList2.size());
  //throw java.lang.UnsupportedOperationException
  unmodifiableList1.add("a");
}
```

guava提出了Immutable的概念

**为什么使用不可变集合**

- 当对象被不可信任的库调用的时候，不可变的形式是安全的
- 不可变对象被多个线程调用的时候，不存在竞态条件问题
- 所有不可变集合都比它们的可变形式有更好的内存利用率
- 不可变对象因为有固定不变，可以作为常量来安全使用

重要提示：所有Guava不可变集合的实现都不接受null值。我们对Google内部的代码库做过详细研究，发现只有5%的情况需要在集合中允许null元素，剩下的95%场景都是遇到null值就快速失败。如果你需要在不可变集合中使用null，请使用JDK中的Collections.unmodifiableXXX方法。更多细节建议请参考“使用和避免null”。

**如何创建不可变集合**

- `copyOf`

  ```
  ImmutableSet.copyOf(set);
  ```

- `of`

  ```
  ImmutableSet.of(“a”, “b”, “c”);
  ImmutableMap.of(“a”, 1, “b”, 2);
  ```

- `Builder`

  ```
  public static final ImmutableSet<Color> GOOGLE_COLORS =
          ImmutableSet.<Color>builder()
              .addAll(WEBSAFE_COLORS)
              .add(new Color(0, 191, 255))
              .build();
  ```

**asList视图**

所有不可变集合都有一个asList()方法提供ImmutableList视图，来帮助你用列表形式方便地读取集合元素。例如，你可以使用sortedSet.asList().get(k)从ImmutableSortedSet中读取第k个最小元素。

asList()返回的ImmutableList通常是——并不总是——开销稳定的视图实现，而不是简单地把元素拷贝进List。也就是说，asList返回的列表视图通常比一般的列表平均性能更好，比如，在底层集合支持的情况下，它总是使用高效的contains方法。

**Multiset**

无序但是可以重复的集合

```java
mutiset.add("a");
mutiset.add("a");
mutiset.add("b");
mutiset.add("c");
mutiset.add("d");

System.out.println(multiset.size());
System.out.println(multiset.count("a"));
```

**Multimap**

JDK提供给我们的Map是一个键，一个值，一对一的，那么在实际开发中，显然存在一个KEY多个VALUE的情况（比如一个分类下的书本），我们往往这样表达：`Map<k,List<v>>`，非常麻烦

```java
@Test
public void testMultimap(){
  ArrayListMultimap<String, String> multimap = ArrayListMultimap.create();
  multimap.put("英文","A");
  multimap.put("英文","B");
  multimap.put("中文","一");
  //[A, B]
  System.out.println(multimap.get("英文"));
}
```

友情提示下，guava所有的集合都有create方法，这样的好处在于简单，而且我们不必在重复泛型信息了。

Multimap的实现类有：ArrayListMultimap/HashMultimap/LinkedHashMultimap/TreeMultimap/ImmutableMultimap/......

**BiMap**

JDK提供的MAP让我们可以find value by key，那么能不能通过find key by value呢，能不能KEY和VALUE都是唯一的呢。

在实际场景中有这样的需求吗？比如通过用户ID找到mail，也需要通过mail找回用户名。没有guava的时候，我们需要create forward map AND create backward map

```java
    @Test
    public void testBiMap(){
        HashBiMap<String, String> hashBiMap = HashBiMap.create();
        hashBiMap.put("410108199706010053","17801160801");
        //17801160801
        System.out.println(hashBiMap.get("410108199706010053"));
        //410108199706010053
        System.out.println(hashBiMap.inverse().get("17801160801"));
        hashBiMap.forcePut("testKey1","17801160801");
        //放入相同的value会报错
        //java.lang.IllegalArgumentException: value already present: 17801160801
        hashBiMap.put("testKey2","17801160801");
    }
```

