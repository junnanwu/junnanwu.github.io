# JDK8新特性

## lambda表达式

**stream().map().collect()的用法**

map()

用于映射每个元素到对应的结果

用例1：

```java
List list= Arrays.asList(“a”, “b”, “c”, “d”);

List collect =list.stream().map(String::toUpperCase).collect(Collectors.toList());
System.out.println(collect); //[A, B, C, D]
```

用例2：

```java
List<Integer> numbers = Arrays.asList(3, 2, 2, 3, 7, 3, 5);
// 获取对应的平方数
List<Integer> squaresList = numbers.stream().map( i -> i*i).distinct().collect(Collectors.toList());
```



```java
headers = tagFilterVO.getHeaders().stream()
        .map(TagSystemHeaderVO::getHeader)
        .reduce((a, b) -> {
            a.addAll(b);
            return a;
        })
        .orElse(new ArrayList<>())
        .toArray(new String[]{});
```

```java
headers = tagFilterVO.getTagFilterItems()
        .stream()
        .map(TagFilterItemDO::getTagField)
        .distinct()
        .collect(Collectors.toList())
        .toArray(new String[]{});
```

```java
    public static final Map<Integer, TagSystemEnum> tagSystemMap = Stream.of(
            TagSystemEnum.values())
            .collect(Collectors.toMap(TagSystemEnum::getId,item -> item));
```



### lambda表达式不能访问非final的局部变量

> 我们知道，每个方法在执行的同时都会创建一个栈帧用于存储局部变量表、操作数栈、动态链接，方法出口等信息，每个方法从调用直至执行完成的过程，就对应着一个栈帧在虚拟机栈中入栈到出栈的过程（《深入理解Java虚拟机》第2.2.2节 Java虚拟机栈）

就是说在执行方法的时候，局部变量会保存在栈中，方法结束局部变量也会出栈，随后会被垃圾回收掉，而此时，内部类对象可能还存在，如果内部类对象这时直接去访问局部变量的话就会出问题，因为外部局部变量已经被回收了，解决办法就是把匿名内部类要访问的局部变量复制一份作为内部类对象的成员变量，查阅资料或者通过反编译工具对代码进行反编译会发现，底层确实定义了一个新的变量，通过内部类构造函数将外部变量复制给内部类变量。

- 为何还需要用final修饰？

其实复制变量的方式会造成一个数据不一致的问题，在执行方法的时候局部变量的值改变了却无法通知匿名内部类的变量，随着程序的运行，就会导致程序运行的结果与预期不同，于是使用final修饰这个变量，使它成为一个常量，这样就保证了数据的一致性。

在lambda表达式中对变量的操作都是基于原变量的副本，不会影响到原变量的值，报错必须使用final只是能再编译的时候提醒开发者

## Optional

### 基本方法

- `Optional(T value)`

  构造方法，`private`修饰

  内部调用了`Objects.requireNonNull(T obj)`该方法中，如果为null则抛出空指针异常

  将`Objects.requireNonNull(T obj)`方法的返回值赋给value

- `of(T value)`

  ```java
  public static <T> Optional<T> of(T value) {
      return new Optional<>(value);
  }
  ```

  内部调用了构造函数

  - 通过`of(T value)`函数所构造出的Optional对象，当Value值为空时，依然会报NullPointerException
  - 通过`of(T value)`函数所构造出的Optional对象，当Value值不为空时，能正常构造Optional对象

- EMPTY对象

  ```java
  public final class Optional<T> {
      //省略....
      private static final Optional<?> EMPTY = new Optional<>();
      private Optional() {
          this.value = null;
      }
      //省略...
      public static<T> Optional<T> empty() {
          @SuppressWarnings("unchecked")
          Optional<T> t = (Optional<T>) EMPTY;
          return t;
      }
  }
  ```

- `ofNullable(T value)`

  ```java
  public static <T> Optional<T> ofNullable(T value) {
    return value == null ? empty() : of(value);
  }
  ```

  相比较`of(T value)`当value值为null的时候，会报NullPointerException异常；`ofNullable(T value)`不会throw Exception，`ofNullable(T value)`直接返回一个`EMPTY`对象

- `orElse(T other)`

  当构造的value传入一个null的时候，给予一个默认值

- `orElseGet(Supplier<? extends T> other)`

  `orElse(T)`无论前面Optional容器是null还是non-null，都会执行orElse里的方法，`orElseGet(Supplier)`并不会，如果service无异常抛出的情况下，Optional使用orElse或者orElseGet的返回结果都是一样的

- `orElseThrow(Supplier<? extends X> exceptionSupplier)`

  当value值是null的时候，直接抛出一个异常

- `map(Function<? super T, ? extends U> mapper)`

  ```java
  public<U> Optional<U> map(Function<? super T, ? extends U> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
      return empty();
    else {
      return Optional.ofNullable(mapper.apply(value));
    }
  }
  ```

- `flatMap(Function<? super T, Optional<U>> mapper)`

  ```java
  public<U> Optional<U> flatMap(Function<? super T, Optional<U>> mapper) {
    Objects.requireNonNull(mapper);
    if (!isPresent())
      return empty();
    else {
      return Objects.requireNonNull(mapper.apply(value));
    }
  }
  ```

- `isPresent()`

  ```java
  public boolean isPresent() {
    return value != null;
  }
  ```

- `ifPresent(Consumer<? super T> consumer)`

  ```java
  public void ifPresent(Consumer<? super T> consumer) {
    if (value != null)
      consumer.accept(value);
  }
  ```

- `filter(Predicate<? super T> predicate)`

  ```java
  public final class Optional<T> {
      //省略....
     Objects.requireNonNull(predicate);
          if (!isPresent())
              return this;
          else
              return predicate.test(value) ? this : empty();
  }
  ```

### 用法

- 例一：

  ```java
  public String getCity(User user)  throws Exception{
    if(user!=null){
      if(user.getAddress()!=null){
        Address address = user.getAddress();
        if(address.getCity()!=null){
          return address.getCity();
        }
      }
    }
    throw new Excpetion("取值错误"); 
  }
  ```

  优化：

  ```java
  public String getCity(User user) throws Exception{
      return Optional.ofNullable(user)
                     .map(u-> u.getAddress())
                     .map(a->a.getCity())
                     .orElseThrow(()->new Exception("取指错误"));
  }
  ```

- 例二：

  ```java
  if(user!=null){
      dosomething(user);
  }
  ```

  优化：

  ```java
  Optional.ofNullable(user)
    .ifPresent(u->{
      dosomething(u);
  });
  ```

- 例三：

  ```java
  public User getUser(User user) throws Exception{
      if(user!=null){
          String name = user.getName();
          if("zhangsan".equals(name)){
              return user;
          }
      }else{
          user = new User();
          user.setName("zhangsan");
          return user;
      }
  }
  ```

  优化：

  ```java
  public User getUser(User user) {
      return Optional.ofNullable(user)
                     .filter(u->"zhangsan".equals(u.getName()))
                     .orElseGet(()-> {
                          User user1 = new User();
                          user1.setName("zhangsan");
                          return user1;
                     });
  }
  ```

  

