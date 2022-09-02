# Spring Transactional

**编程式事务**

人为用手动去实现实现的开启与回滚等操作，这些逻辑耦合在代码中。

**声明式事务**

仅仅使用注解去解决事务，代码中不体现。

## 事务回滚

默认情况下，如果发生了`RuntimeException`，Spring的声明式事务将自动回滚。

如果要针对Checked Exception回滚事务，需要在`@Transactional`注解中写出来：

```java
@Transactional(rollbackFor = {RuntimeException.class, IOException.class})
public buyProducts(long productId, int num) throws IOException {
    ...
}
```

业务异常可以继承`RuntimeException`，这样就不必任何特殊声明，即可让Spring的声明式事务生效。

## 事务传播

- `REQUIRED`

  默认传播级别，如果当前没有事务，就创建一个新事务，如果当前有事务，就加入到当前事务中执行。

- `SUPPORTS`

  表示如果有事务，就加入到当前事务，如果没有，那也不开启事务执行。这种传播级别可用于查询方法，因为SELECT语句既可以在事务内执行，也可以不需要事务。

- `REQUIRES_NEW`

  表示不管当前有没有事务，都必须开启一个新的事务执行。如果当前已经有事务，那么当前事务会挂起，等新事务完成后，再恢复执行。

- ...

开启：

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public Product createProduct() {
    ...
}
```

### 如何传播事务

Spring使用声明式事务，最终也是通过执行JDBC事务来实现功能的，那么，一个事务方法，如何获知当前是否存在事务？

答案是使用ThreadLocal。Spring总是把JDBC相关的`Connection`和`TransactionStatus`实例绑定到`ThreadLocal`。如果一个事务方法从`ThreadLocal`未取到事务，那么它会打开一个新的JDBC连接，同时开启一个新的事务，否则，它就直接使用从`ThreadLocal`获取的JDBC连接以及`TransactionStatus`。

## References

1. https://www.liaoxuefeng.com/wiki/1252599548343744/1282383642886177