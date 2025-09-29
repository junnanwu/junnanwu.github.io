# String

## String  str =  new  String("abc") 和 String str = "abc"的区别

`String str = "abc"`是把常量池中`abc`的地址给`str`，`String str = new String("abc")`是把常量池的abc地址给堆里的对象，对象的地址再给`str`。

### 字符串常量优化

```java
public class StringTest {
    @Test
    public void test01(){
        String s1 = "wu";
        String s2 = "junnan";
        String s3 = "wujunnan";
        String s4 = "wu"+"junnan";
        String s5 = s1+s2;
        String s6 = s1+"junnan";
        String s7 = new String("wujunnan");
	    String s8 = s7.intern();
        //一定加括号，以免造成悲剧！
        System.out.println("s3==s4 => "+(s3==s4));
        System.out.println("s3==s5 => "+(s3==s5));
        System.out.println("s3==s6 => "+(s3==s6));
        System.out.println("s3==s7 => "+(s3==s7));      	
        System.out.println("s3==s8 => "+(s3==s8));
    }
}
```

结果：

```java
s3==s4 => true
s3==s5 => false
s3==s6 => false
s3==s7 => false
s3==s8 => true
```

- `String s1 = "wu";`

  JVM去字符串常量池中寻找`wu`，存在就返回常量池中的引用，不存在就创建后返回引用。

- `String s3 = "wujunnan";`

  JVM去字符串常量池中创建`wujunnan`字符串并返回引用。

- `String s4 = "wu"+"junnan";`

  这里用到了常量优化机制，如果`=`右边的内容全部都是常量（包括final关键字修饰的常量），那么在编译时期就可以运算出右边的结果，其实际就是把右边的结果赋值给左边。

  所以会直接得到`wujunnan`字符串，然后去常量池中发现这个字符串已经存在，那么久直接返回这个字符串的地址。

- `String s5 = s1+s2;` `String s6 = s1+"junnan";`

  字符串的串联是通过StringBuilder的`append()`方法来完成的，JVM会在堆中创建一个以s1为基础的StringBuilder对象，然后调用`append()`方法，这时候s5，s6中保存的是**StringBulider对象**的地址。

- `String s7 = new String("wujunnan");`

  过程见上。

- `String s8 = s7.intern();`

  查询常量池中是否有s7这个字符串，如果有的话就返回常量池中的引用。

## StringBuilder和StringBuffer

- 可拓展

  StringBuilder和StringBuffer都继承了AbstractStringBuilder，AbstractStringBuilder内有两个非常重要的变量，分别是：

  ```
  char[] value; 
  int count;
  ```

  注意value上面并没有加final，所以是长度可变的。

- 安全性

  StringBuffer在多线程中是安全的，StringBuilder与StringBuffer自身的`append()`方法内都使用了继承自AbstractStringBuilder的`append()`方法，StringBuffer安全原因在于在`append()`方法上**使用了synchronized**关键字，而StringBuilder没有使用。

  AbstractStringBuilder的`append()`方法的具体实现：

  ```java
  public AbstractStringBuilder append(String str) {
    if (str == null)
      return appendNull();
    int len = str.length();              // 待插入的字符串的长度
    ensureCapacityInternal(count + len); // 扩容
    str.getChars(0, len, value, count);  // 将str拷贝到数组中
    count += len;    // 容器内实际容纳的字符长度 = 原有长度 + 本次新增的长度
    return this;
  }
  ```

- 拼接效率

  当String进行拼接的时候，每两个String进行拼接就会创建一个StringBuilder对象，多个String进行拼接会创建大量的对象，导致效率很低；相对于StringBuilder的`append()`方法由于没有`synchronized`关键字，所以StringBuilder的拼接效率是三者最高的。

  StringBuffer一般用于SQL语句的拼接。

  测试结果为：

  ```
  2012 millis has costed when used String.
  103 millis has costed when used StringBuffer.
  57 millis has costed when used StringBuilder.
  ```
