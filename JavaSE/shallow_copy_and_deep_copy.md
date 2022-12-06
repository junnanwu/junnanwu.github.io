# 浅拷贝与深拷贝

在分层项目中，我们经常会将不同类型的Bean之间进行拷贝，例如将Do对象拷贝到Vo对象，本文将对相关内容进行总结。

本文主要包括，浅拷贝和深拷贝的概念、Java Cloneable接口、常用Bean拷贝工具。

## 概念

**浅拷贝**（Shallow Copy）指的是将原对象的所有字段的值拷贝给目标对象。

如果`A`对象的字段`a`是引用类型，那么就会将`a`字段的地址值拷贝给`A'`的`a'`字段，修改`a'`字段内容，由于`a'`和`a`字段指向的是同一个对象，那么`A`对象的`a`字段也会被改变。

**深拷贝**（Deep Copy）指的是将原对象基本类型字段的值拷贝给目标对象，而引用类型，则递归的进行拷贝，创建一个新的类型。

拷贝前后的对象状态完全独立的，修改互不影响。

## 关于Cloneable接口

Cloneable是一个标记接口，即接口内部没有任何方法和属性。当一个类实现了这个接口，我们在调用这个类继承自Object的`clone()`方法的时候，才不会抛出CloneNotSupportedException。

同时，根据约定，我们实现了这个接口之后，也要重写Object的`clone()`方法：

```java
protected native Object clone() throws CloneNotSupportedException;
```

这是一个native方法，默认是进行浅拷贝，所以我们在重写的时候，除了调用super.clone方法之外，还要修正一些可变对象。

另外，重写的方法的修饰符还要扩大为public以供客户端访问。

例如，重写Student的clone接口以实现深拷贝（前提是School类也正确的重写了clone方法）：

```java
@Data
@AllArgsConstructor
public class Student implements Cloneable {
    private int year;
    private String name;
    private LocalDate graduationDate;
    private School school;

    @Override
    public Student clone() {
        try {
            Student student = (Student) super.clone();
            student.school = this.school.clone();
            return student;
        } catch (CloneNotSupportedException e) {
            throw new AssertionError();
        }
    }
}
```

注意：

- 如果成员是不可变的，例如String、LocalDate，那么这种浅拷贝也是安全的，不必进行处理
- 重写的clone方法可以不再抛出CloneNotSupportedException，因为继续抛出这个受检异常，调用方捕获到也没有什么可处理的，而且通过编译的代码，后续这里是不会抛出异常的，所以这里可以转换为抛出AssertionError，代表不会发生，以简化调用流程
- 如果你的类需要设计为线程安全的，那么clone方法也需要设计为同步方法

（详见《Effective Java》第13条：谨慎的覆盖clone）

重写clone方法不但需要注意上面可能会出现的问题，一些复杂对象重写起来也是非常麻烦的，所以需要**谨慎的覆盖clone方法**。

阿里《Java开发手册》同样有如下推荐：

> 【推荐】慎用 Object 的 clone 方法来拷贝对象。
> 说明：对象 clone 方法默认是浅拷贝，若想实现深拷贝，需覆写 clone 方法实现域对象的深度遍历式拷贝。

## 浅拷贝工具类

常用Bean拷贝工具（默认都是浅拷贝）：

- Apache BeanUtils
- Spring BeanUtils
- Cglib BeanCopier
- mapstruct

### Apache BeanUtils

Apache BeanUtils是Apache commons组件里面的成员，性能较差，不推荐使用。

Apache BeanUtils通过反射获取到目标对象的属性、方法及描述符，并通过反射来创建新对象，并赋值。

当然，其性能较差的原因除了基于反射较慢外，还有如下原因：

- 输出了大量的日志调试信息（涉及到大量的字符串拼接）
- 重复的对象类型检查（大量的instanceof）
- 类型转换（如果属性名相同，类型不同，Apache BeanUtils会帮你做类型转换）

由于较差的性能，所以，阿里《Java开发手册》同样有如下强制说明：

> 【强制】避免用 Apache Beanutils进行属性的copy。
>  说明：Apache BeanUtils 性能较差，可以使用其他方案比如 Spring BeanUtils，Cglib BeanCopier，注意均是浅拷贝。

### Spring BeanUtils

Spring BeanUtils同样采用的是反射的方式，但是相比Apache BeanUtils，直接取最核心的反射进行set/get，省去一些非核心功能，进行了如下优化/简化，：

- 优化日志打印
- 不进行类型转换（类型不同则不复制）
- 增加了缓存，避免了类的属性描述符重复加载

从而大大优化了拷贝性能，如果使用Spring项目，不用导入其他依赖，可以直接使用。

### **Cglib BeanCopier**

Cglib的BeanCopier并没有采用反射的方式，而是通过操作字节码，直接编写class文件，然后执行，性能优于上面两种基于反射的方式，性能也接近原生方法了（get/set）。

### mapstruct

mapstruct是一个实体类映射框架，不同于上面三种在运行时生成目标文件，**mapstruct在编译期就实现了源对象到目标对象的映射**，如果编译器能通过，那么运行期就可以通过（原理类似lombok），非常安全，而且在运行期间就可以直接调用生成的实现类，不用再通过反射来实现，速度也非常快，接近原生方法。

mapstruct可以通过注解解决映射的字段名字不一样的问题（上面的也支持，需要自定义Converter），例如，当Car类的numberOfSeats需要映射为CarDto类的seatCount，我们可以定义如下Mapper（来自mapstruct官方文档）：

```java
@Mapper
public interface CarMapper {
    CarMapper INSTANCE = Mappers.getMapper( CarMapper.class );
 
    @Mapping(source = "numberOfSeats", target = "seatCount")
    CarDto carToCarDto(Car car);
}
```

mapstruct还提供了如下功能：

- 不同类型之间的映射，例如String类型映射为枚举类型
- 集合类型转换，例如字段`List<Car>`映射到`List<CatDto>`
- 多个对象映射为一个对象
- ...

### 性能测试

根据该文章的性能测试：[Performance comparison BeanUtils object attributes and the copy source code analysis](https://www.codetd.com/en/article/8291633)，对不同长度的列表进行拷贝，测试结果如下：

| Copy format          | The number of objects: 1 | The number of objects: 1000 | The number of objects: 100000 | The number of objects: 1000000 |
| -------------------- | ------------------------ | --------------------------- | ----------------------------- | ------------------------------ |
| Hard Code            | 0 ms                     | 1 ms                        | 18 ms                         | 43 ms                          |
| cglib BeanCopier     | 111 ms                   | 117 ms                      | 107 ms                        | 110 ms                         |
| Spring BeanUtils     | 116 ms                   | 137 ms                      | 246 ms                        | 895 ms                         |
| Apache PropertyUtils | 167 ms                   | 212 ms                      | 601 ms                        | 7869 ms                        |
| Apache BeanUtils     | 167 ms                   | 275 ms                      | 1732 ms                       | 12380 ms                       |

（环境为`OS = macOS 10.14, = the CPU 2.5 GHz,Intel Core I7, Memory =16 GB, 2133MHz LPDDR3`）

（参考了其他测试，例如：[Github yangtu222 BeanUtils](https://github.com/yangtu222/BeanUtils)、[Java Bean mapper performance tests](https://www.christianschenk.org/blog/java-bean-mapper-performance-tests/)，数据跟上述测试结果相似）

测试结果表明：

- 硬编码速度是最快的，即采用new、set的方式，但是写起来是不太方便的
- Apache BeanUtils 在复制大量对象的情况下性能下降严重，所以不推荐使用
- 上面几个测试工具中cglib BeanCopier 性能是最好、最为稳定的

## 深拷贝实现

可以通过如下方法实现深拷贝

1. 正确的重写`clone`方法，即对一些可变对象进行修正
2. 通过序列化、反序列化的方式

## 总结

实际开发中，尽量不要覆盖clone方法，不要使用Apache BeanUtils，Spring项目可以使用Spring BeanUtils，在数据量大的情况下，可以采用Cglib BeanCopier，数据量大且设计数据转换，可以采用mapstruct。

## References

1. 博客：[How to Make a Deep Copy of an Object in Java](https://www.baeldung.com/java-deep-copy)
1. 阿里，《Java开发手册》，嵩山版，p10
1. Joshua Bloch，《Effective Java》中文，原书第三版 ，第13条
1. 博客：[Java 对象拷贝原理剖析及最佳实践](https://my.oschina.net/u/4090830/blog/5598304)
1. 博客：[CGLIB中BeanCopier源码实现](https://www.jianshu.com/p/f8b892e08d26)
1. mapstruct官网：[mapstruct.org](https://mapstruct.org/)
1. 博客：[mapstruct原理解析](https://blog.csdn.net/datastructure18/article/details/120208842)
1. 博客：[Performance comparison BeanUtils object attributes and the copy source code analysis](https://www.codetd.com/en/article/8291633)
1. Github：[Github yangtu222 BeanUtils](https://github.com/yangtu222/BeanUtils)
1. 博客：[Java Bean mapper performance tests](https://www.christianschenk.org/blog/java-bean-mapper-performance-tests/)
