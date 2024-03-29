# 虚拟机类加载机制

Class文件需要被加载到虚拟机中才能被使用，而虚拟机如何加载这些Class文件，Class文件中的信息进入到虚拟机后又回发生什么，我们将介绍。

Java天生可以动态拓展的语言特性就是依赖运行期动态加载和动态链接这个特点实现的。

## 类加载的时机

![class_load_phase](calss_loading_mechanism_assets/class_load_phase.png)

这里面解析阶段也可以在初始化之后再开始，这是为了支持Java语言的动态绑定

## 什么时候初始化

对于什么情况下需要开始第一阶段“加载”，虚拟机规范没有强制约束，由虚拟机自由把握，但是对于初始化阶段，则严格规范了以下六种情况：

1. 遇到`new`、`getstatic`、 `putstatic`、 `invokestatic`这四条字节码指令时，如果类型没有进行过初始化，则需要先触发其初始化阶段，典型场景有：
   - 使用`new`关键字实例化对象的时候
   - 读取或设置一个类型的静态字段（被final修饰，已在编译期把结果放在常量池中的字段除外）
   - 调用一个类型的静态方法的时候
2. 使用`java.lang.reflect`包的方法进行反射调用的时候，如果类型没有进行过初始化，则需要先触发其初始化
3. 当初始化类的时候，如果发现其父类还没有进行初始化，则需要先触发其父类的初始化
4. 当虚拟机启动的时候，用户需要指定一个要执行的主类，虚拟机会先初始化这个主类（包含main方法的那个类）虚拟机会先初始化这个主类
5. JDK7新加入的动态语言支持
6. JDK8接口中的默认方法

虚拟机规范规定有且只有这六种会触发类型初始化的场景

## 类加载的过程

### 加载

1. 通过一个类的全限定名来获取定义此类的二进制字节流
2. 将这个字节流所代表的静态存储结构转换为方法区运行时的数据结构
3. 在内存中生成一个代表这个类的`java.lang.Class`对象，作为方法取这个类的各种数据的访问入口

相对于类的其他阶段，非数据阶段的加载阶段（获取二进制字节流的动作）是开发者可控性最强的阶段，加载阶段即可以使用Java虚拟机里内置的引导类加载器来完成，也可以由用户定义的类加载器取完成。

### 验证

虽然Java程序无法做到访问数组边界以外的数据，将一个对象转型为它并未实现的类型，跳转到不存在的代码行之类的，因为如果尝试这么做了，编译期会抛出异常，拒绝编译。

但是Class文件的来源不一定是Java源码编译而成，完全可以用0，1直接在二进制编译期敲出Class文件在内的任何途径产生。

所以如果对其完全信任的话，有可能会因为载入了有错误的或有恶意企图的字节码流而导致整个系统受攻击甚至崩溃，所以验证字节码是Java虚拟机保护自身的一项必要的措施

大致上包括下面四个阶段的检验动作，文件格式检验，元数据验证，字节码验证和符号引用验证

### 准备

**准备阶段是正式为类中定义的变量（静态变量static）分配内存并设置类变量初始值的阶段**，从概念上讲，这些变量所使用的内存都应该在方法区中进行分配，这时候进行的内存分配仅包括类变量，不包括实例变量，实例变量将会在对象实例化时随着对象一起分配在Java堆中，其次是这里所说的初始值通常情况指的是数据类型的零值

`public static int value = 123;`

这个变量value在初始化之后的初始值为0而不是123，因为这时还没有开始执行任何Java方法，而把value赋值为123的`putstatic`指令是程序被编译后，存放于类构造器`<clinit>()`方法之中，所以把value赋值给123的动作要到类的初始化的阶段才会执行。

但是：

`public static final int value = 123;`

如果类字段的字段属性中存在ConstantValue属性，在准备阶段变量值就会被初始化为ConstantValue属性所指定的初始值，所以上述代码在编译时，javac将会为value生成ConstantValue属性，在准备阶段就会根据ConstantValue的设置将value赋值为123。

### 解析

解析阶段是Java虚拟机将常量池内的符号引用替换为直接引用的过程，符号引用。

### 初始化

类的初始化是类加载过程的最后一个步骤，直到初始化阶段，Java虚拟机才真正开始执行类中编写的Java程序代码，将主导权移交给应用程序。

初始化阶段就是执行类构造器的`<clinit>()`方法的过程，`<clinit>()`并不是Java代码中直接编写的方法，它是Javac编译器的自动生成物。

### 什么是`<clinit>()`方法

1. `<clinit>()`方法是由编译器自动手机类中的所有**类变量（被static修饰的变量）的赋值动作和静态语句块**（`static{}`块）中的语句合并而成，编译器收集的顺序是由语句在源文件中出现的顺序决定的，静态语句块中只能访问到定义在静态语句块之前的饭变量，定义在他之后的变量，在前面的静态语句可以赋值，但是不能访问

   ```java
   public class Test{
   	static{
   		i = 0;  //给变量赋值可以正常的编译通过
   		System.out.println(i);  //这句编译会提示”非法向前引用“
   	}
   	static int i = 1;
   }
   ```

2. **`<clinit>()`方法与类的构造函数不一样**，他不需要显式的的调用父类构造器，Java虚拟机会保证在子类的`<clinit>()`方法执行前，父类的`<clinit>()`方法已经执行完毕，因此在Java虚拟机中第一个被执行的`<clinit>()`方法肯定是`java.lang.Object`

3. 由于父类的`<clinit>()`方法先执行，也就意味着父类的静态语句块要优先于子类的变量赋值操作

   ```java
   static class Parent{
   		public static int A =1;
   		static{
   				A = 2;
   		}
   }
   
   static class Sub extends Parent{
   		public static int B = A;
   }
   
   public static void main(String[] args){
   		System.out.println(Sub.B); //值为2
   }
   ```

4. `<clinit>()`方法对于类或者接口来说并不是必须的，如果一个类没有静态语句块，也没有对变量的赋值操作，那么编译器可以不为这个类生成`<clinit>()`方法

5. java虚拟机必须保证一个类的`<clinit>()`方法在多线程环境中被正确地加锁同步，如果多个线程同时去初始化一个类，那么只会有其中一个线程去执行这个类的`<clinit>()`方法，其他线程都要阻塞等待

## 类加载器

Java虚拟机设计者有意将类加载阶段中的“通过一个类的全限定名来获取描述该类的二进制字节流”，这个动作放到Java虚拟机外部去实现，以便让应用程序自己决定如何去获取所需的类，实现这个动作的代码被称为“类加载器”（Class Loader）。

**对于任何一个类，都必须由加载他的类加载器和这个类的本身一起共同确立其在Java虚拟机中的唯一性**（包括Class对象的`equals()`方法，`isAssignableFrom()`方法， `isInstance()`方法的返回结果）

## Java三层类加载器

> 站在Java虚拟机的角度讲，只存在两种不同的类加载器，一种是启动类加载器{Bootstrap ClassLoader},这个类加载器由C++实现，是虚拟机的一部分，另一种就是其他所有类的加载器，由Java实现，独立存在于虚拟机之外，并且全部继承自抽象类Java.lang.ClassLoader。

1. 启动类加载器（Bootstrap ClassLoader）

   > 这个类加载器负责加载放在`<JAVA_HOME>\lib`目录，或者被-Xbootclasspath参数所指定的路径中存放的，而且是Java虚拟机能够识别的（根据文件名识别）

   - `rt.jar`，是JAVA基础类库，rt代表的是RunTime，是Java运行时环境中所有核心Java类的集合。比如String类，System类，Object类等，JVM在运行时从`rt.jar`文件访问所有这些类。

     [reference](http://blog.sina.com.cn/s/blog_87c4e86b0102z1ax.html)
   
   - `dt.jar`

     >Also includes dt.jar, the DesignTime archive of BeanInfo files that tell interactive development environments (IDE's) how to display the Java components and how to let the developer customize them for the application.

     dt.jar(DesignTime)作用是告bai诉集成开发环境du(IDE's)如何显示Java组件，主要是swing的包

   - `tools.jar`

     tools.jar是工具类库，是系统用来编译一个类的时候用到的  也就是javac的时候用

2. 拓展类加载器（Extension ClassLoader）

   > 这个类加载器是在类`sun.misc.Launcher$ExtClassLoader`中以Java代码实现的，它负责加载`<JAVA_HOME>\lib\ext`目录中的类库，这是一种Java系统类库的扩展机制，JDK的开发团队允许用户将具有通用性的类库放置在ext目录里以拓展Java SE的功能，开发者可以直接在程序中使用拓展类加载器来加载Class文件。

3. 应用程序类加载器（Application ClassLoader）

   > 这个类加载器由`sun.misc.Launcher$AppClassLoader`来实现，它负责加载用户类路径（ClassPath）上所有的类库，开发者同样可以直接在代码中使用这个类加载器，一般情况下这个就是程序默认的类加载器

## 双亲委派模型

**什么是双亲委派模型**

各种类加载器直接的层次关系被称为"双亲委派加载模型"（Parents Delegation Medel）

>双亲委派模型的工作过程是，如果一个类加载器收到了类加载的请求，他首先不会自己去尝试加载这个类，而是把这个请求委派为父类加载器去完成 ，每一个层次的类加载器中，只有当父加载器反馈自己无法完成这个加载请求时，子加载器才会尝试自己去加载。

**双亲委派模型的好处**

避免重复加载，避免核心类篡改

Java中的类随着它的类加载器一起具备了一种带有优先级的层次关系，例如类`java.lang.Object`,它存在`rt.jar`中，无论哪一种类加载器要加载这个类，最终都是委派为处于模型最顶端的启动类接载器进行加载，因此Object类在程序的各种类加载器环境中都能保证是同一个类。

如果没有双亲委派模型，都又各个类加载器去自行加载的话，如果用户自己也写了一个Object的类，并且放在ClassPath中，那系统就会出现多个不同的Object类，Java类型体系中最基础的行为也就无法保障了

**ClassLoader方法**

`public abstract class ClassLoader extends Object`

每个Class对象内部都有一个classLoader字段标记自己是被哪个ClassLoader加载的

ClassLoader 里面有三个重要的方法 `loadClass()`、`findClass()` 和 `defineClass()`

`loadClass()` 方法是加载目标类的入口，它首先会查找当前 ClassLoader 以及它的双亲里面是否已经加载了目标类，如果没有找到就会让双亲尝试加载，如果双亲都加载不了，就会调用 `findClass()` 让自定义加载器自己来加载目标类。

ClassLoader 的`findClass()` 方法是需要子类来覆盖的，不同的加载器将使用不同的逻辑来获取目标类的字节码。拿到这个字节码之后再调用 `defineClass()` 方法将字节码转换成 Class 对象。

双亲委派模型对于保证Java程序的稳定运作极为重要，但是实现却非常简单，全部集中在`java.lang.ClassLoader`的`loadClass()`方法之中：

```java
protected synchronized Class<?> loadClass(String name,boolean reslve) throws ClassNotFoundException{
    //先检查请求的类是否已经被加载过了
    Class c = findLoadedClass(name);
    if(c==null){
        try{
            if(parent !=null){
                c = parent.loadClass(name,false);
            }else{
                c = findBootstrapClassOrNull(name);
            }
        }catch(ClassNotFoundException e){

        }
        if(c ==null){
            //父类加载器无法加载
            c.findClass(name);
        }
    }
    if(resolve){
        resolveClass(c);
    }
    return c;
}
```

类加载器：

`getClassLoader()`Class类的方法，获取该类的类的类加载器

获取类对象的几种方法：

```
Test test = new Test();
```

1. `test.getClass();`

   在运行时确定，所以运行实例才是该类对象。super.getClass()不能获得父类的类对象，仍然是当前类对象。

   获得父类类对象： `test.getClass().getSuperclass()`

   ```java
   class Father{
   	public void showName(){
     	System.out.println("Father...");
     }
   }
   class Child extends Father{
     public void showName(){
     	System.out.println("children");
     }
   }
   
   Father father = new Child();
   System.out.println(Father.class); //结果是 Father
   System.out.println(father.getClass()); //结果是 Child
   ```

2. `Test.class;`

   在编译时确定，返回当前类的类对象实例。不会加载静态变量

3. `Class.forName("类路径");`

   会加载静态变量，比如jdbc驱动利用这个加载一些静态属性

   通过静态方法获取类对象，`Class.forName("com.wu.Test")`;

你可以认为每一个Class对象拥有磁盘上的那个.class字节码内容,每一个class对象都有一个getClassLoader()方法，得到是谁把我从.class文件加载到内存中变成Class对象的

## References

1. 《深入理解Java虚拟机》——周志强 







