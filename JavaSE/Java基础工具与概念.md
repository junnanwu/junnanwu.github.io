# Java基础工具与概念

## jdk提供的工具

### Javac

Javac工具将Java源文件编译成.class字节码文件

格式：

```
Javac [ options ] [ sourcefiles ] [ classes ] [ @argfiles ]
```

- options

  命令参数

  - `-d`

    生成包含包路径的字节码文件

    ```
    $ javac Hello.java -d target
    ```

- sourcefiles

  一个或多个需要编译的待编译的源文件（例如Myclass.class）

  当待编译的文件较少的时候，可以直接将文件名写在命令行上即可

- classes

  One or more classes to be processed for annotations (such as MyPackage.MyClass).

- @argfiles

  待编译的文件名组成的文件，可以是一个或者多个

  当待编译的文件很多的时候，可以采用这种方式，文件名前面加上@字符。

### Java

Java命令用于启动一个Java应用，它会启动Java运行环境，加载指定的class文件，调用main方法：

main方法如下：

```
public static void main(String[] args)
```

main方法：

- 必须被public和static修饰
- 不能有返回值
- 必须接受一个String数组参数

格式：

```
Java [ options ] class [ arguments ]
```

或（jar包模式）

```
Java [ options ] -jar file.jar [ arguments ]
```

参数：

- `options`

  - `-jar`

    > When you use this option, the JAR file is the source of all user classes, and other user class path settings are ignored.

- `class`

  需要调用的class

- `arguments`

  传递给main方法的参数

- `ClassPath`

  `cp`

  指定一个或多个目录作为ClassPath，多个目录使用`:`进行分割（Linux，Mac），此选项会覆盖环境变量中的ClassPath。

  **如果不设置ClassPath参数，同时也不设置ClassPath环境变量，那么ClassPath由当前目录(.)组成。**

注意：

- 执行的时候需要考虑到ClassPath

  例如，如果A.class在a.b.c包下，那么需要在最外层(src下)执行

  ```
  $ Java a.b.c.A
  ```

  或者在`src/a/b/c`下执行，即指定ClassPath

  ```
  $ Java -cp ../../../ a.b.c.A
  ```

### Javadoc

为Java文件生成Javadoc。

## 关于ClassPath

由于大家每天都是用IDE进行开发，加上网上很多老旧资料，导致ClassPath这个概念很多人并不是很清晰，例如现在网上很多安装jdk的教程还会让你去设置ClassPath环境变量。

### ClassPath是什么

当你的代码中写了import语句，new语句等，虚拟机需要找到这些class在哪里，虚拟机又不可能遍历一遍你的电脑，所以需要你提供几个目录供虚拟机查找，这个就是ClassPath。

所以ClassPath意思就是path of Class，即告诉虚拟机，去哪里寻找class文件，如果将虚拟机类比为Linux，那么ClassPath就是Linux中的Path变量。

举例：

你在`/a/b`目录下，对A.Java执行了`Javac`命令，在同目录生成了A.class文件，此时你可以在`/a/b`文件夹下执行`Java A`，因为如果不设置ClassPath，ClassPath默认就是当前目录。

但是如果你想在`/c`文件夹下执行`/a/b/A.class`，那么你就可以将`a/b/`目录设置为ClassPath，这个时候，你就可以在`/c`文件夹下执行`Java A`命令了。

如何设置ClassPath呢？

1. 设置全局环境变量

   ```
   $ export CLASS_PATH=/a/b
   ```

   不建议这样设置，会影响到其他的项目。

2. 通过`Java -cp`命令指定（推荐）

   ```
   $ Java -cp /a/b A
   ```

在IDE中运行Java程序，IDE自动传入的`-cp`参数是当前工程的`bin`目录和引入的jar包。

### Java核心类库去哪里找

这里涉及到了Java虚拟机的[双亲委派模型](../JavaEE/深入理解Java虚拟机)，核心类库的类（`<JAVA_HOME>\lib`文件夹下）最终都会由应用程序类加载器(Application Class Loader)加载，**第三层，应用程序类加载器（Application ClassLoader）负责加载用户ClassPath上所有的类库。**

故核心类库由应用程序加载器加载，它会找到对应的核心类库。

所以我们看到网上很多教程还在让将`rt.jar`等核心类库加入到ClassPath中是完全没有必要的。

## 关于JAVA_HOME

Java本身是不需要配置这个环境变量的，安装Java只需要将jdk的bin目录添加到PATH变量中即可，方便随时调用Javac、java等命令。

但是一些用到jdk/jre的工具有可能会使用JAVA_HOME环境变量：

1. 例如：IDEA中的Gradle可以选择Gradle JVM为JAVA_HOME，这个时候，如果你没有设置JAVA_HOME环境变量，那么就会报错了。

   <img src="Java%E5%9F%BA%E7%A1%80%E5%B7%A5%E5%85%B7%E4%B8%8E%E6%A6%82%E5%BF%B5_assets/image-20211025114743038.png" alt="image-20211025114743038" style="zoom: 33%;" />

2. 在没有配置JAVA_HOME环境变量的时候，我本地的CAS Tomcat服务也出现了异常，

   在我指定JAVA_HOME的时候，启动Tomcat显示（即使用指定的JRE）：

   ```
   Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home
   ```

   在没有指定JAVA_HOME的时候，启动Tomcat会使用/User目录下的jdk15，导致版本不对，服务异常。

所以在配置Java环境的时候，最好配置上JAVA_HOME环境变量，以便其他软件使用。

## Jar

Jar(Java Archive)，Java归档。

Jar文件使用zip格式进行打包，Java提供了Jar命令对Jar包进行创建，浏览，压缩，并通过`java -jar`运行Jar包。

JAR 文件与 ZIP 文件唯一的区别就是在 JAR 文件的内容中，包含了一个`META-INF/MANIFEST.MF`文件，这个文件是在生成 JAR 文件的时候自动创建的。

**参数**

- `c`

  创建一个新的Jar包

  ```
  jar cf jar-file input-file(s)
  ```

- `m`

  定义`MANIFEST.MF`文件

  ```
  $ jar -cvfm test.jar META-INF/MANIFEST.MF Test.class
  ```

- `v`

  将过程信息输出

- `t`

  查看Jar包内容

  ```
  jar tf jar-file
  ```

- `x`

  解压

  ```
  jar xf jar-file archived-file(s)
  ```

**使用**

简单的Hello world：

1. 创建`HelloWorld.java`并javac编译

   ```java
   public class HelloWorld {
       public static void main(String[] args) {
           System.out.println("Hello World");
       }
   }
   ```

2. 创建`MANIFEST.MF`并指定MainClass

   ```
   $ echo Main-Class: HelloWorld > MANIFEST.MF
   ```

3. 打Jar包

   ```
   $ jar -cvfm hello.jar MANIFEST.MF HelloWorld.class
   ```

4. 运行

   ```
   $ java -jar hello.jar
   ```

在大型项目中，不可能手动编写`MANIFEST.MF`文件，再手动创建zip包。Java社区提供了大量的开源构建工具，例如[Maven](../Tool/Maven)，可以非常方便地创建jar包。

## Reference

1. [JDK Tools and Utilities](https://docs.oracle.com/Javase/7/docs/technotes/tools/index.html)
2. https://www.liaoxuefeng.com/wiki/1252599548343744/1260466914339296
3. https://www.cnblogs.com/flashsun/p/7246260.html