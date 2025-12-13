# 序列化

## Serializable



如果只实现Serializable，那么当你对这个类做一些改变，例如增加字段等，就会发现，无法进行反序列化，抛出`InvalidClassException`异常。

因为Java会根据这个Java类生成一个SHA指纹，即serialVersionUID，当类的字段发生变化的时候，这个指纹也会发生变化，所以无法进行反序列化。

这个时候，你可以指定serialVersionUID字段，例如：

```
private static final long serialVersionUID = 1L;
```

这样以后，再进行序列化的时候，就会直接使用这个值代替指纹。

p9

> 【强制】序列化类新增属性时，请不要修改 serialVersionUID 字段，避免反序列失败;如果 完全不兼容升级，避免反序列化混乱，那么请修改 serialVersionUID 值。
>
> 说明：注意serialVersionUID不一致会抛出序列化运行时异常。



## References