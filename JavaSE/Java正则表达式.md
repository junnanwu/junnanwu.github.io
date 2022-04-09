# Java正则表达式

## 关于二次转义

Java里面写正则，需要经过Java编译器和正则引擎两次解析，所以需要考虑到这两次涉及的转义。

- 最终输出：`\`  
- 传给正则引擎：`\\`
- 传给Java编译器：`\\\\`

例如：

```java
public static void main(String[] args) {
    //根据\"进行分隔 \"
    String target = "a\\\"b";
    System.out.println(target);
    //正则引擎需要读到的是 \" -> 都是那么java需要传入正则引擎的是 \\" -> 那么需要传入正则引擎的是 \\\\\"
    String[] result = target.split("\\\\\"");
    System.out.println(Arrays.toString(result));
}
```

结果为：

```
a\"b
[a, b]
```

