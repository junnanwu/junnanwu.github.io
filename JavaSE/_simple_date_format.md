# 线程不安全的SimpleDateFormat

## 错误示范

先测试`SimpleDateForamat.format`方法：

```java
public class SimpleDateFormatTest {
    public static SimpleDateFormat SIMPLE_DATE_FORMAT_MINUTE_SECOND = new SimpleDateFormat("mm:ss");

    private static void test01() {
        for (int i = 0; i < 10; i++) {
            int finalI = i;
            new Thread(() -> {
                Date date = new Date(finalI * 1000);
                try {
                    System.out.println(SIMPLE_DATE_FORMAT_MINUTE_SECOND.format(date));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }).start();
        }
    }
```

该方法开启10个线程将毫秒值转换成Date，正常结果应该是`00:01`到`00:10`，但是实际上得到了如下输出：

```
00:04
00:06
00:05
00:04
00:04
00:04
00:05
00:08
00:07
00:09
```

我们发现了多个重复的值，这说明`SimpleDateForamat.format`方法是线程不安全的。

接下来我们看`SimpleDateFormat.parse`方法：

```java
public class SimpleDateFormatTest {
    public static SimpleDateFormat SIMPLE_DATE_FORMAT_DEFAULT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    private static void test02() {
        String date = "2022-12-01 22:20:00";
        for (int i = 0; i < 10; i++) {
            new Thread(() -> {
                try {
                    System.out.println(SIMPLE_DATE_FORMAT_DEFAULT.parse(date));
                } catch (Exception e) {
                    System.out.println("抛出异常：" + e.toString());
                }
            }).start();
        }
    }
}
```

该方法开启10个线程将字符串转换成日期，结果如下：

```
抛出异常：java.lang.NumberFormatException: For input string: "11122.E211122E.2"
抛出异常：java.lang.NumberFormatException: For input string: "11122.E211122E.211122E2"
抛出异常：java.lang.NumberFormatException: For input string: "11122.E211122E.211122E211122E0"
Thu Apr 01 22:20:00 CST 94883
Sat Dec 03 10:40:00 CST 2022
Thu Dec 01 22:20:00 CST 2022
Thu Dec 01 22:20:00 CST 2022
Thu Dec 01 22:20:00 CST 2022
Thu Dec 01 22:20:00 CST 2022
Thu Dec 01 22:20:00 CST 2022
```

我们可以看到，不仅抛出了运行时异常`java.lang.NumberFormatException`，还有一个转换错误。

以上足以说明SimpleDateFormat是线程不安全的。

## 规范

在SimpleDateFormat类的文档注释中，作者写到：

> Date formats are not synchronized. It is recommended to create separate format instances for each thread. If multiple threads access a format concurrently, it must be synchronized externally.

即，Date Formats内部并没有做synchronized处理，建议每个线程创建独立的实例来使用，如果多个线程要访问一个实例，必须进行同步处理。

同样的，在阿里规范中也写到：

>【强制】SimpleDateFormat 是线程不安全的类，一般不要定义为 static 变量，如果定义为 static，必须加锁，或者使用 DateUtils 工具类。
>
>正例:注意线程安全，使用 DateUtils。亦推荐如下处理:
>
>```java
>private static final ThreadLocal<DateFormat> df = new ThreadLocal<DateFormat>() { 
>    @Override
>    protected DateFormat initialValue() {
>        return new SimpleDateFormat("yyyy-MM-dd");
>    } 
>};
>```
>
>说明:如果是 JDK8 的应用，可以使用 Instant 代替 Date，LocalDateTime 代替 Calendar，
>
>DateTimeFormatter 代替 SimpleDateFormat，官方给出的解释：simple beautiful strong immutable thread-safe。

## 原因

DateFormat抽象类中有一个成员变量Calendar，当然Calendar也是线程不安全的。

```java
public abstract class DateFormat extends Format {
	//...
	protected Calendar calendar;
	//...
}
```

SimpleDateFormat的format等方法内部都是通过此calendar来实现的。

```java
private StringBuffer format(Date date, StringBuffer toAppendTo,
                            FieldDelegate delegate) {
    //...
    calendar.setTime(date);
    //...
}
```

线程A执行了`calendar.setTime`之后，线程B也执行了`calendar.setTime`。线程A再次使用calendar的时候，就会使用到线程B设置的calendar，导致拿到线程B format的结果。

## 解决方案

### 创建局部变量

像SimpleDateFormat文档注释里面的说的那样，我们可以在使用的时候，创建一个新的SimpleDateFormat局部变量，局部变量是线程私有的，自然就不存在线程竞争问题。

可以在工具类中完成上述操作，参考`cn.hutool.core.date`的DateUtil的format方法：

```java
package cn.hutool.core.date;

public class DateUtil extends CalendarUtil {
    public static String format(Date date, String format) {
        if (null == date || StrUtil.isBlank(format)) {
            return null;
        }

        final SimpleDateFormat sdf = new SimpleDateFormat(format);
        if (date instanceof DateTime) {
            final TimeZone timeZone = ((DateTime) date).getTimeZone();
            if (null != timeZone) {
                sdf.setTimeZone(timeZone);
            }
        }
        return format(date, sdf);
    }
}
```

### 加锁操作

再如SimpleDateFormat文档注释所说，我们可以通过加锁的方式来使用静态的SimpleDateFormat，限制一次只能有一个线程访问，那自然也不会出现多线程问题，但是加锁会大大降低代码的并发能力，增加接口延迟时间，所以不推荐。

### 使用ThreadLocal

我们知道ThreadLocal是每个线程的"私有"存储，也就是说，每个线程可以在ThreadLocal存储一个自己的SimpleDateFormat实例，每次取的都是该线程对应的SimpleDateFormat，自然也不存在竞争。

可以参考`com.alibaba.excel.util.DateUtils`的format方法：

```java
package com.alibaba.excel.util;

public class DateUtils {
    private static final ThreadLocal<Map<String, SimpleDateFormat>> DATE_FORMAT_THREAD_LOCAL =
        new ThreadLocal<>();

    public static String format(Date date, String dateFormat) {
        if (date == null) {
            return null;
        }
        if (StringUtils.isEmpty(dateFormat)) {
            dateFormat = defaultDateFormat;
        }
        return getCacheDateFormat(dateFormat).format(date);
    }

    private static DateFormat getCacheDateFormat(String dateFormat) {
        Map<String, SimpleDateFormat> dateFormatMap = DATE_FORMAT_THREAD_LOCAL.get();
        if (dateFormatMap == null) {
            dateFormatMap = new HashMap<String, SimpleDateFormat>();
            DATE_FORMAT_THREAD_LOCAL.set(dateFormatMap);
        } else {
            SimpleDateFormat dateFormatCached = dateFormatMap.get(dateFormat);
            if (dateFormatCached != null) {
                return dateFormatCached;
            }
        }
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dateFormat);
        dateFormatMap.put(dateFormat, simpleDateFormat);
        return simpleDateFormat;
    }
}
```

### 使用java.time包的api

在Java8之前，由于Java Date诸多的不合理的设计，其中包括：

- 月份、天数等从0开始算
- 复杂的日期运算，简单的时间计算也需要通过Calendar
- 当然还包括线程不安全的SimpleDateFormat、Date、Calendar等

Stephen Colebourne主导设计了更加优秀合理的第三方时间库：Joda-Time，Java也邀请他参与设计了JSR310标准，即Java 8 java.time包中一系列优秀的API：

- 日期和时间分离为LocalDate、LocalTime，更加合理

- 所有类都采用不可变类来保证线程安全

- 引入了很多Joda-Time的API来简化时间运算，几乎不再需要DateUtil，例如，很轻松的能获取到昨天日期：

  ```
  LocalDate today = LocalDate.now();
  LocalDate yesterday = today.minusDays(1);
  ```

Java 8以上的都应该使用更加合理、方便的java.time。

## 总结

SimpleDateFormat是线程不安全的，不要定义为static共享使用，可以通过局部变量或ThreadLocal的方式来保证线程安全，有条件还是提倡Java 8及以上的系统使用java.time包的API。

## References

1. 《阿里开发手册嵩山版》
2. 知乎：[SimpleDateFormat线程不安全的5种解决方案！](https://zhuanlan.zhihu.com/p/372836976)