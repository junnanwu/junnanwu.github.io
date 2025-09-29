# Integer

## int和Integer的区别

1. int是基本类型，Integer是int的包装类型
2. 默认值不同，int默认值为0，Integer默认值为null
3. Integer变量实际上是对象的引用
4. Integer必须实例化后才能使用

## Integer的自动拆箱

```java
Integer i1 = new Integer(1);
Integer i2 = new Integer(1);
System.out.println(i1 == i2);
System.out.println(i1.equals(i2));
```

前者为false，后者为true；

```java
Integer i1 = 1;
Integer i2 = 1;
Integer i3 = 128;
Integer i4 = 128;
System.out.println(i1 == i2);
System.out.println(i3 == i4);
```

前者为true，后者为false；

Integer重写了equals方法，Integer自动装箱时对数值在-128到127的对象放入缓存中，第二次就直接取缓存中的数据而不会new。

```java
Integer i1 = 1;
int i2 = 1;
System.out.println(i1 == i2);
```

Integer类型和int比较时，会自动拆箱，化为基本类型数据比较。