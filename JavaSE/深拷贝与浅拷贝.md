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

## References

1. https://www.baeldung.com/java-deep-copy
