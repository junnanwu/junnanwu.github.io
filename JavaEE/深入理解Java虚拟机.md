# 深入理解Java虚拟机

# 一.走进Java

# 二. Java内存区域和内存溢出异常

## 2.1 Java虚拟机的内存分配

- 程序计数器(Program Counter Register)

  是一个较小的内存空间，他可以看作是**当前线程所执行的字节码行号指示器**，字节码解释器的值来选取下一条需要执行的字节码指令，他是程序控制流的指示器

  由于Java虚拟机的多线程是通过线程轮流切换，分配处理器执行时间的方式来实现的，在任何一个确定的时刻，一个内核都只会执行一条线程中的指令，因此为了线程切换后能恢复到正确的执行位置，每条线程都需要有一个独立的程序计数器，各条线程之间的计数器互不影响，独立储存，我们称这类内存区域为“**线程私有**”的内存。

  如果程序正在执行的是一个Java方法，这个计数器记录的是正在执行的虚拟机字节码指令的地址

- Java虚拟机栈(Java Virtual Machine Stack)

  我们通常指的栈就是这个虚拟机栈，这个与程序计数器一样，也是**线程私有**的，**虚拟机栈描述的是Java方法执行的线程内存模型**，每个方法被执行的时候，Java虚拟机都会同步创建一个栈帧用于存储局部变量表，操作数栈，动态连接，方法出口等信息。每一个方法被调用直至执行完毕的过程，就对应着一个栈帧在虚拟机栈中从入栈到出栈的过程。
  
  如果线程请求的栈深度大于虚拟机所允许的深度，将抛出`StackOverflowError`异常，如果Java虚拟机栈容量可以动态扩展，当栈扩展时无法申请到足够的内存会抛出`OutofMemoryError`异常
  
- 本地方法栈(Native Method Stacks)

  本地方法栈与虚拟机栈所发挥的作用是非常相似的，虚拟机栈为虚拟机执行Java方法服务，而本**地方法栈则是为虚拟机使用到本地的方法**服务

- Java堆(Java Heap)

  Java堆是虚拟机所管理的内存中的最大的一块儿，Java堆是被所有**线程共享**的一块儿内存区域，在虚拟机启动时创建。

  此内存区域的唯一目的就是**存放对象实例**，“所有的对象实例以及数组都应当在堆上分配”

  Java堆是垃圾收集器管理的区域，无论将堆怎么划分，都不会改变Java堆中存储内容的共性，无论是哪个区域，存储的都只能是对象的实例

  Java堆可以处于物理上不连续的内存空间，但是在逻辑上它们应该是连续的

  在Java堆无法进行拓展的时候，Java虚拟机会抛出`OutOfMemoryError`异常

- 方法区(Method Area)

  与堆内存一样，是各个**线程共享的内存区域**，它**用于存储已经被虚拟机加载的类型信息，常量，静态变量**，即时编译后的代码缓存等数据

  这个区域可以选择不实现垃圾收集，相对而言，垃圾收集行为在这个区域是比较少出现的

  如果方法区无法进行拓展的时候，Java虚拟机会抛出`OutOfMemoryError`异常

- 运行时常量池（Runtime Constant Pool)

  是方法区的一部分，Class文件中除了有类的版本，字段，方法，接口等描述信息外，还有一项信息是常量池(Constant Pool Table)，用于存放编译期生成的各种字面量与符号引用，这部分内容存在方法区的运行时常量池中

  运行时常量池相对于Class文件常量池的另外一个重要的特性时具备动态性，Java语言并不要求常量一定只有编译期才能产生

- 直接内存（Direct Memory)

  这部分内存并不是虚拟机运行时数据区的一部分，也不是虚拟机规范中定义的内存区域，但是很可能导致`OutOfMemoryError`的出现

  在JDK1.4中，新加入的NIO类，引用了一种基于通道（Channel）与缓冲区的I/O方式，它可以使用Native数据库直接分配堆外内存，这样能显著提高性能，因为避免了在Java堆和Native堆之间来回复制数据

  虽然不会收到Java堆大小的限制，但是，既然是内存，肯定会受到本机总内存的限制，经常会被忽略，导致动态拓展的时候出现`OutOfMemoryError`异常



2.2 HotSpot虚拟机在Java堆中对象的分配，布局和访问

创建对象

当Java虚拟机遇到一个字节码指令new指令时，首先要检查这个这个指令的参数是否能在常量池中定位到一个类的符号引用，并且检查这个符号引用代表的类是否已经被加载，解析和初始化过，如果没有，那必须先进行响应类的初始化（第七章）

类加载完成后，接下来虚拟机为新生对象分配内存，对象所需内存在类加载完全后便可完全确定，然后将一个确定大小的内存块从堆内存中划分出来，划分的方式分为指针碰撞(Bump The Pointer)和列表空闲(Free List)，选择哪种分配方式由Java堆是否规整决定，而Java堆是否规整又由所采取的垃圾收集器是否带有空间压缩整理的能力决定

内存分配完成之后，虚拟机必须将分配到的内存空间都初始化为零值，这步操作保证了对象的实例字段在Java代码中可以不赋值初始值就能直接使用，使程序能访问到这些字段的数据类型所对应的零值

接下来Java虚拟机还要对对象进行必要的设置，例如这个对象是哪个类的实例，如何才能找到类的元数据信息，对象的哈希值，对象的GC分代年龄等信息，这些信息存放在对象的对象头之中

从Java程序来讲对象的创建才刚刚开始，构造函数还没有执行，所有字段都是默认的零值，一般来说，new指令后会接着执行`<init>()`方法，按照程序员的意愿对对象进行初始化，这样一个真正可以用的对象才算完全被构造出来

对象的内存布局

在HotSpot虚拟机中，对象在堆中的存储布局可以划分为三个部分，对象头，实例数据，对齐填充

HotSpot虚拟机默认的分配顺序是

```
longs/doubles,ints,shorts/chars,bytes/booleans,oops
```



# 三. 垃圾收集器与内存分配策略

## 可达性分析算法

程序计数器，虚拟机栈，本地方法栈随着方法的进入和退出有条不紊的执行着出栈和进栈操作，每一个栈帧中分配多少内存基本上是类结构确定下来的就已经知道的，当方法或者线程结束的时候，内存就跟着回收了

而Java堆和方法区这两个区域则有着显著的不确定性，一个接口的多个实现类需要的内存可能会不一样，只有处于运行期间，我们才能知道程序究竟会创建哪些对象，穿件多少个对象，这部分内存的分配和回收是动态的，我们讲的内存的分配和回收也是特指这一部分内存

当前主流的商用程序语言中，内存管理系统都是通过可达性分析(Reachability Analysis)来判断对象是否存活的，这个算法的基本思路就是通过一些列称为“GC Roots"的根对象作为起始节点集，从这些节点开始，根据引用关系向下搜索，搜索的过程为“引用链”，如果某个对象到GC Roots间没有任何引用链相连，则证明该对象不可能再被使用

## 引用

jdk1.2之后，Java对引用的概念进行了扩充，将引用分为强引用，软引用，弱引用和虚引用

- 强引用是最传统的“引用”的定义，是指在程序代码之中普遍存在的引用赋值，即类似`Object obj = new Object()`这种引用关系，无论任何情况下，只要强引用关系还存在，垃圾收集器就永远不会回收掉被引用的对象
- 软引用是用来描述一些还有用，但非必须的对象，只被软引用关联着的对象，在系统将要发生内存溢出之前，会把这些对象列进回收范围之中进行第二次回收，如果这次还没有足够的内存，才会抛出内存溢出异常
- 弱引用也是用来描述那些非必须对象，但是它的强度比软引用更弱一些，被弱引用关联的对象只能生存到下一次垃圾收集发声为止。当垃圾收集器来时工作，无论当前内存是否足够，都会回收掉只被弱引用关联的对象
- 虚引用是最弱的一种引用关系，无法通过一个弱引用来取得一个对象实例，为一个对象设置虚引用关联的唯一目的就是为了能在这个对象能被收集器回收时收到一个系统通知

要真正宣告一个对象死亡，至少要经历两次标记过程，如果对象在进行可达性分析后发现没有与GC Roots相连接的引用链，那它将会被第一次标记，随后进行一次筛选，筛选的条件是此对象是否有必要执行`finalize()`方法，假如对象没有覆盖`finalize()`方法，或者`finalize()`方法已经被虚拟机调用过，那么虚拟机将这两种情况都视为“没有必要执行“

如果这个对象被判定为确有必要执行`finalize()`方法，那么这个对象会被放置在一个名为F-Queue的队列之中，并在稍后由一条由虚拟机自动建立的，低调度优先级的Finalizer线程去执行它们的`finalize()`方法，稍后收集器将对F-Queue中的对象进行第二次小规模的标记，如果对象要在`finalize()`中成功拯救了自己——只要重新与引用链上的任何一个对象建立关联即可，那再第二次标记时，它将被移出“即将回收”的集合，如果对象这个时候还没有逃脱，那基本上它就真的要被回收了。

这个方法代价运行高昂，没有必要使用。





# 七. 虚拟机类加载机制

Class文件需要被加载到虚拟机中才能被使用，而虚拟机如何加载这些Class文件，Class文件中的信息进入到虚拟机后又回发生什么，我们将介绍。

Java天生可以动态拓展的语言特性就是依赖运行期动态加载和动态链接这个特点实现的

## 类加载的时机

![类加载时机](%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/%E7%B1%BB%E5%8A%A0%E8%BD%BD%E6%97%B6%E6%9C%BA.png)

![类加载时机](%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/类加载时机.png)

这里面解析阶段也可以在初始化之后再开始，这是为了支持Java语言的动态绑定

### 什么时候初始化

对于什么情况下需要开始第一阶段“加载”，虚拟机规范没有强制约束，由虚拟机自由把握，但是对于初始化阶段，则严格规范了以下六种情况：

1. 遇到new, getstatic, putstatic, invokestatic这四条字节码指令时，如果类型没有进行过初始化，则需要先触发其初始化阶段，典型场景有：
   - 使用new关键字实例化对象的时候
   - 读取或设置一个类型的静态字段（被final修饰，已在编译期把结果放在常量池中的字段除外）
   - 调用一个类型的静态方法的时候
2. 使用`java.lang.reflect`包的方法进行反射调用的时候，如果类型没有进行过初始化，则需要先触发其初始化
3. 当初始化类的时候，如果发现其父类还没有进行初始化，则需要先触发其父类的初始化
4. 当虚拟机启动的时候，用户需要指定一个要执行的主类，虚拟机会先初始化这个主类（包含main方法的那个类）虚拟机会先初始化这个主类
5. JDK7新加入的动态语言支持
6. JDK8接口中的默认方法

虚拟机规范规定有且只有这六种会触发类型初始化的场景

### 类加载的过程

#### 加载阶段

1. 通过一个类的全限定名来获取定义此类的二进制字节流
2. 将这个字节流所代表的静态存储结构转换为方法区运行时的数据结构
3. 在内存中生成一个代表这个类的java.lang.Class对象，作为方法取这个类的分钟数据的访问入口

相对于类的其他阶段，非数据阶段的加载阶段（获取二进制字节流的动作）是开发着可控性最强的阶段，加载阶段即可以使用Java虚拟机里内置的引导类加载器来完成，也可以由用户定义的类加载器取完成

#### 验证

虽然Java程序无法做到访问数组边界以外的数据，将一个对象转型为它并未实现的类型，跳转到不存在的代码行之类的，因为如果尝试这么做了，编译期会抛出异常，拒绝编译。

但是Class文件的来源不一定是Java源码编译而成，完全可以用0，1直接在二进制编译期敲出Class文件在内的任何途径产生。

所以如果对其完全信任的话，有可能会因为载入了有错误的或有恶意企图的字节码流而导致整个系统受攻击甚至崩溃，所以验证字节码是Java虚拟机保护自身的一项必要的措施

大致上包括下面四个阶段的检验动作，文件格式检验，元数据验证，字节码验证和符号引用验证

#### 准备

**准备阶段是正式为类中定义的变量（静态变量static）分配内存并设置类变量初始值的阶段**，从概念上讲，这些变量所使用的内存都应该在方法区中进行分配，这时候进行的内存分配仅包括类变量，不包括实例变量，实例变量将会在对象实例化时随着对象一起分配在Java堆中，其次是这里所说的初始值通常情况指的是数据类型的零值

`public static int value = 123;`

这个变量value在初始化之后的初始值为0而不是123，因为这时还没有开始执行任何Java方法，而把value赋值为123的`putstatic`指令是程序被编译后，存放于类构造器`<clinit>()`方法之中，所以把value赋值给123的动作要到类的初始化的阶段才会执行。

但是：

`public static final int value = 123;`

如果类字段的字段属性中存在ConstantValue属性，在准备阶段变量值就会被初始化为ConstantValue属性所指定的初始值，所以上述代码在编译时，javac将会为value生成ConstantValue属性，在准备阶段就会根据ConstantValue的设置将value赋值为123。

#### 解析

解析阶段是Java虚拟机将常量池内的符号引用替换为直接引用的过程，符号引用

#### 初始化

类的初始化是类加载过程的最后一个步骤，直到初始化阶段，Java虚拟机才真正开始执行类中编写的Java程序代码，将主导权移交给应用程序。

初始化阶段就是执行类构造器的`<clinit>()`方法的过程，`<clinit>()`并不是Java代码中直接编写的方法，它是Javac编译器的自动生成物

#### 什么是`<clinit>()`方法

1. `<clinit>()`方法是由编译器自动手机类中的所有**类变量(被static修饰的变量)的赋值动作和静态语句块**（static{}块）中的语句合并而成，编译器收集的顺序是由语句在源文件中出现的顺序决定的，静态语句块中只能访问到定义在静态语句块之前的饭变量，定义在他之后的变量，在前面的静态语句可以赋值，但是不能访问

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

### Java三层类加载器

> 站在Java虚拟机的角度讲，只存在两种不同的类加载器，一种是启动类加载器{Bootstrap ClassLoader},这个类加载器又C++实现，是虚拟机的不一部分，另一种就是其他所有类的加载器，由Java实现，独立存在于虚拟机之外，并且全部继承自抽象类Java.lang.ClassLoader。

1. 启动类加载器（Bootstrap ClassLoader）

   > 这个类加载器负责加载放在`<JAVA_HOME>\lib`目录，或者被-Xbootclasspath参数所指定的路径中存放的，而且是Java虚拟机能够识别的（根据文件名识别）

   从上面可以知道，虚拟机会自动到`<JAVA_HOME>\lib`目录去寻找基础类库，而jdk1.5之前是需要指定classpath的，jdk1.5之后不需要再指定classpath，但是需要指定` JAVA_HOME`这个环境变量

   ```
   export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_261.jdk/Contents/Home
   ```

   - `rt.jar`，是JAVA基础类库，rt代表的是RunTime，是Java运行时环境中所有核心Java类的集合。比如String类，System类，Object类等，JVM在运行时从`rt.jar`文件访问所有这些类。

     

     ![image-20201209193341871](%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/image-20201209193341871.png)

     [reference](http://blog.sina.com.cn/s/blog_87c4e86b0102z1ax.html)

   - `dt.jar`

     >Also includes dt.jar, the DesignTime archive of BeanInfo files that tell interactive development environments (IDE's) how to display the Java components and how to let the developer customize them for the application.

     dt.jar(DesignTime)作用是告bai诉集成开发环境du(IDE's)如何显示Java组件，主要是swing的包

     <%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets src="%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/image-20201209212501446.png" alt="image-20201209212501446" style="zoom:50%;" />

   - `tools.jar`

     tools.jar是工具类库，是系统用来编译一个类的时候用到的  也就是javac的时候用

     <%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets src="%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/image-20201209212613765.png" alt="image-20201209212613765" style="zoom:50%;" />

2. 拓展类加载器（Extension ClassLoader）

   > 这个类加载器是在类`sun.misc.Launcher$ExtClassLoader`中以Java代码实现的，它负责加载`<JAVA_HOME>\lib\ext`目录中的类库，这是一种Java系统类库的扩展机制，JDK的开发团队允许用户将具有通用性的类库放置在ext目录里以拓展Java SE的功能，开发者可以直接在程序中使用拓展类加载器来加载Class文件。

3. 应用程序类加载器（Application ClassLoader）

   > 这个类加载器由`sun.misc.Launcher$AppClassLoader`来实现，它负责加载用户类路径（ClassPath）上所有的类库，开发者同样可以直接在代码中使用这个类加载器，一般情况下这个就是程序默认的类加载器

### 双亲委派模型

**什么是双亲委派模型**

各种类加载器直接的层次关系被称为“双亲委派加载模型”（Parents Delegation Medel）

>双亲委派模型的工作过程是，如果一个类加载器收到了类加载的请求，他首先不会自己去尝试加载这个类，而是把这个请求委派为父类加载器去完成 ，每一个层次的类加载器中，只有当父加载器反馈自己无法完成这个加载请求时，子加载器才会尝试自己去加载。

**双亲委派模型的好处**

避免重复加载，避免核心类篡改

Java中的类随着它的类加载器一起具备了一种带有优先级的层次关系，例如类java.lang.Object,它存在`rt.jar`中，无论哪一种类加载器要加载这个类，最终都是委派为处于模型最顶端的启动类接载器进行加载，因此Object类在程序的各种类加载器环境中都能保证是同一个类。

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

![ClassAndClassLoader](%E6%B7%B1%E5%85%A5%E7%90%86%E8%A7%A3Java%E8%99%9A%E6%8B%9F%E6%9C%BA_assets/ClassAndClassLoader.png)

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

   通过静态方法获取类对象，Class.forName("com.wan.Test");



你可以认为每一个Class对象拥有磁盘上的那个.class字节码内容,每一个class对象都有一个getClassLoader()方法，得到是谁把我从.class文件加载到内存中变成Class对象的



我们再来看一下 java.lang.Long的加载，按上面分析，应该是由根类加载器加载得到的，此时启动类加载器是应用类加载器，但实际类加载器是根类加载器。

所以回到我们最开始那个问题，没有main方法是因为执行的根本不是我们自己写的类，执行的是java核心中的那个Long类，当然没有main方法了。 这样就防止我们应用中写的类覆盖掉java核心类。

```java
public class Long {
	public static void main(String[] args) {
		System.out.println("Hi, i am here");
	}
}
```









