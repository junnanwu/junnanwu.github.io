# 浅拷贝与深拷贝

## 浅拷贝

浅拷贝（Shallow Copy）指的是将`A`对象的所有字段拷贝给`A'`对象。

如果`A`对象的字段`a`是引用类型，那么就会将`a`字段的地址值拷贝给`A'`的`a'`字段，修改`a'`字段内容，由于`a'`和`a`字段指向的是同一个对象，那么`A`对象的`a`字段也会被改变。

## 深拷贝

深拷贝（Deep Copy）指的是递归的将原对象的所有字段拷贝，拷贝前后的对象是完全独立的。

深拷贝的实现方式：

1. 实现`Cloneable`，添加`clone`方法，并为引用类型也调用此方法，并确保引用类型字段也是如是实现`clone`方法
2. Apache Commons Lang `SerializationUtils`类的`clone`方法
3. 通过各种JSON序列化的方式

## Cloneable

具体说下上面的第一种方式，即实现Cloneable的方式。

Cloneable是一个标记接口，即接口内部没有任何方法和属性。当我们的类实现了这个接口，我们在调用这个类继承自Object的`clone()`方法的时候，才不会抛出CloneNotSupportedException。

同时，根据约定，我们实现了这个接口之后，也要重写Object的`clone()`方法：

```java
protected native Object clone() throws CloneNotSupportedException;
```

这是一个native

## References

1. 博客：[How to Make a Deep Copy of an Object in Java](https://www.baeldung.com/java-deep-copy)

 
