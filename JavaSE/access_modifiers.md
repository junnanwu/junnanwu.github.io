# Java访问修饰符

我们知道，Java有四个访问修饰符：

- private——仅对本类可见
- package-private——对本包可见（默认的）
- protected——对本包和所有子类可见
- public——对外部完全可见

## protected

### 关于protected的误区

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

我有疑问，既然所有类是继承自Object，而Object的clone方式是protected修饰的，那么根据protected的特点：对本包和所有子类可见，那clone方法对于子类Dog是可见的呀，为什么上面代码还会报编译错误呢？

也可以详见此问题：[Java类中为什么不能直接调用Object的clone()方法](https://m.imooc.com/wenda/detail/546127)

经过查阅资料，这里主要存在一个对protected的误区，针对实例的属性：

**在子类和父类不同包的情况下，对于同父类的亲兄弟类，子类只能在自己的作用范围内，访问自己继承的那个父类的protected实例方法域，而无法到访问其他子类（同父类的亲兄弟类）所继承的protected实例方法域。**

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

### Object的clone方法

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

## 最佳实践

关于如何使用这些修饰符，总的原则是：使类和成员的可访问性最小化。

### 类

对于顶级的（非内部的）类和接口，只有两种访问级别可选：包级私有的和共有的。

将类或接口定义为包级私有，意味着它是这个包的实现的一部分，而不是该包导出API的一部分，在以后的发行版中，可以修改和删除。

但如果一个类只被另外一个类使用，则应该将其设计为那个类的内部类。

### 字段

除了常量之外，公有类不应该包含任何外部能访问的字段。通常来说，最好将其记为private，而方法标记为public，这是面向对象（OOP）所提倡的数据封装精神。如果你将公有类的字段设计为非private，那么你再想修改这些字段就不现实了，因为访问公有类的客户端已经遍布全球各地了。

包级私有的类的字段设计为公有是没有什么错误的，因为该类只能由包内访问，是可控的。

### 方法

需要对外提供的API的方法可以声明为public。

关于什么时候需要使用protected方法：

- 我们的类是需要继承的，而且提供了特殊的方法给子类用，而不是给其他类用，例如，Object.clone
- 子类需要提供父类抽象方法的实现，例如下面的模版方法模式

**protected典型场景——模版方法模式**

protected还用在一个典型的场景中，即父类需要调用某些子类提供的功能，即设计模式中的模版方法模式。

模版方法的核心思想就是定义一个操作的一系列步骤，对于某些暂时不确定的步骤，就留给子类实现。

```java
public abstract class SuperClass
    public final void exposedMethod {
    	//其他步骤
        hiddenMethod();
    }

    abstract protected void hiddenMethod();
}

public class SubClass extends SuperClass {
    protected void hiddenMethod() { }
}
```

exposedMethod方法即为骨架方法，为了防止子类重写骨架方法，父类一般用final修饰骨架方法，对于需要子类实现的抽象方法，一般声明为protected，使得这些方法对于子类可见，但对于外部客户端不可见。

### package-private

为了更方便测试，可以将一个类的字段或方法声明为package-private，即默认类型。

对于私有和包级私有的区别，不是特别重要，因为他们都不对外暴露，不能为了方便测试，将修饰符提升为public。

## References

1. 《Java核心技术——卷1》
2. Joshua Bloch，《Effective Java》中文，原书第三版 ，p65
3. 提问：[Java类中为什么不能直接调用Object的clone()方法](https://m.imooc.com/wenda/detail/546127)
4. Stack Overflow：[When i need to use a protected access modifier](https://stackoverflow.com/questions/17595224/when-i-need-to-use-a-protected-access-modifier)
5. 廖雪峰：[模版方法模式](https://www.liaoxuefeng.com/wiki/1252599548343744/1281319636041762)