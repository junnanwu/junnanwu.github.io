# Java访问修饰符

我们知道，Java有四个访问修饰符：

- private——仅对本类可见
- public——对外部完全可见
- protected——对本包和所有子类可见
- 默认——对本包可见

## 关于protected的误区

其实，对本包和所有子类可见，是不足以说明protected的用法的，protected的规则还是比较微妙的。

在看Cloneable接口的时候，针对如下代码：

```java
public class Dog implements Cloneable{
}

class Test{
    public static void main(String[] args) {
        Dog dog = new Dog();
        //编译报错：java: clone() 在 java.lang.Object 中是 protected 访问控制
        dog.clone();
    }
}
```

我有疑问，既然所有类是继承自Object，而Object的clone方式是protected修饰的，那么根据protected的特点：对本包和所有子类可见，那clone方法对于子类Dog类是可见的呀，为什么上面代码还会报编译错误呢？

也可以详见此问题：[Java类中为什么不能直接调用Object的clone()方法](https://m.imooc.com/wenda/detail/546127)

经过学习，这里主要存在一个对protected的误区，针对实例的属性：

**对于同父类的亲兄弟类，子类只能在自己的作用范围内，访问自己继承的那个父类的protected实例方法域，而无法到访问其他子类（同父类的亲兄弟类）所继承的protected实例方法域。**

例如：

```java
package a;

public class Animal {
    protected String name;
}
```

```java
package b;
import a.Animal;

public class Dog extends Animal {
	//可以访问
    public static void main(String[] args) {
        Dog dog = new Dog();
        System.out.println(dog.name);
    }
}

class Cat {
    public static void main(String[] args) {
        Dog dog = new Dog();
        //不可以访问
        System.out.println(dog.name);
    }
}
```

这也正是为什么我们在自己的类中创建个实例A，却不能调用实例A继承自Object的clone方法的原因。

## 最佳实践

通常来说，最好将类中的字段标记为private，而方法标记为public，这是面向对象（OOP）所提倡的数据封装精神。

### protected

在实际中，要谨慎使用protected修饰字段，因为其他程序员可能基于你的类设计了子类，并访问了protected字段，你再修改这些字段就会影响到他们的程序，这违背了OOP的数据封装。

protected修饰方法更有实际意义，如果需要限制某个方法的使用，就可以将它声明为protected，这样子类就可以使用这些方法。

**Object的clone方法**

典型如Object的clone方法，我们希望clone后的对象是和原来的对象没有任何状态关系的，也就深拷贝，但是，如果一个类中有引用类型字段，Object的clone方法只会简单拷贝引用，即浅拷贝，如果该方法是public的，那么该方法在所有地方都可以调用，该clone行为就是不可控的。

所以Object的clone方法为protected的，即默认不让在其他类中进行访问，只有在该类中才可以访问该对象的clone方法，我们可以在该类中重写clone方法，如下所示，实现深拷贝，这个时候，clone方法已经是我们预期的深拷贝了，我们再将权限扩大为public，暴露给其他所有类去访问。

```java
@Data
@AllArgsConstructor
public class Student implements Cloneable {
    private int year;
    private String name;
    private School school;

    @Override
    public Student clone() throws CloneNotSupportedException {
        Student student = (Student) super.clone();
        //引用类型也调用其clone方法clone出一个新对象，而不是简单的拷贝引用
        student.school = this.school.clone();
        return student;
    }
}
```





### default



## Reference

1. 书籍：《Java核心技术——卷1》
2. 提问：[Java类中为什么不能直接调用Object的clone()方法](https://m.imooc.com/wenda/detail/546127)