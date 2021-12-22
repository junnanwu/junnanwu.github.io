# Java基础工具与概念

## jdk提供的工具

### javac

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
java [ options ] class [ arguments ]
```

或（jar包模式）

```
java [ options ] -jar file.jar [ arguments ]
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

  指定一个或多个目录/zip/jar作为类的搜索路径，即ClassPath，多个目录使用`:`进行分割（Linux，Mac），此选项会覆盖环境变量中的ClassPath。

  **如果不设置ClassPath参数，同时也不设置ClassPath环境变量，那么ClassPath由当前目录(.)组成。**
  
- `-D<名称>=<值>`

  设置系统属性

例如：

- 启动的时候指定系统的字符集

  ```
  java -Dfile.encoding=UTF-8 ...
  ```

  

注意：

- 执行的时候需要考虑到ClassPath

  例如，如果A.class在a.b.c包下，那么需要在最外层(src下)执行

  ```
  $ java a.b.c.A
  ```

  或者在`src/a/b/c`下执行，指定ClassPath

  ```
  $ java -cp ../../../ a.b.c.A
  ```

### Javadoc

为Java文件生成Javadoc。

## 关于ClassPath

由于大家每天都是用IDE进行开发，加上网上很多老旧资料，导致ClassPath这个概念很多人并不是很清晰，例如现在网上很多安装jdk的教程还会让你去设置ClassPath环境变量。

### ClassPath是什么

当你的代码中写了import语句，new语句等，虚拟机需要找到这些class在哪里，虚拟机又不可能遍历一遍你的电脑，所以需要你提供几个目录供虚拟机查找，这个就是ClassPath。

所以ClassPath意思就是path of Class，即告诉虚拟机，去哪里寻找class文件，如果将虚拟机类比为Linux，那么ClassPath就是Linux中的Path变量。

举例：

你在`/a/b`目录下，对A.java执行了`javac`命令，在同目录生成了A.class文件，此时你可以在`/a/b`文件夹下执行`java A`，因为如果不设置ClassPath，ClassPath默认就是当前目录。

但是如果你想在`/c`文件夹下执行`/a/b/A.class`，那么你就可以将`a/b/`目录设置为ClassPath，这个时候，你就可以在`/c`文件夹下执行`java A`命令了。

如何设置ClassPath呢？

1. 设置全局环境变量

   ```
   $ export CLASS_PATH=/a/b
   ```

   不建议这样设置，会影响到其他的项目。

2. 通过`Java -cp`命令指定（推荐）

   ```
   $ java -cp /a/b A
   ```

在IDE中运行Java程序，IDE自动传入的`-cp`参数是当前工程的`bin`目录和引入的jar包。

### 理解lib文件夹

当我们写一个JDBC测试代码，如下：

```java
public class JDBCTest {
    public static void main(String[] args) throws ClassNotFoundException {
		//注册驱动
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/data_web", "root", "root")) {
            try (Statement stmt = conn.createStatement()) {
                try (ResultSet rs = stmt.executeQuery("SHOW DATABASES")) {
                    while (rs.next()) {
                        System.out.println(rs.getString(1));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
```

其中需要用到Mysql JDBC驱动，即下面语句：

```java
Class.forName("com.mysql.jdbc.Driver");
```

这里我们可以去官网下载`mysql-connector-java-8.0.27.jar`，这个jar包里面包含`com.mysql.jdbc.Driver.class`，那么我们应该把这个Jar包放在哪里才能让上述语句找到呢？

我们初学的时候通常会被告诉要放在lib文件夹下，为什么放在lib文件夹下就可以了呢，名字必须叫lib吗？

其实还是我们上面说的，Java只会去ClassPath下找对应的.class文件，那么我们需要做的就是把这个jar包放在ClassPath中即可。

下面是我们的目录结构，我们选择将jar包放在src同级的lib文件夹中，目录结构如下：

```
├── lib
│   └── mysql-connector-java-8.0.27.jar
└── src
    └── com
        └── junnanwu
            └── jdbc
                ├── JDBCTest.class
                └── JDBCTest.java
```

那么通过上述推荐的使用`-cp`参数来将lib文件夹也加入到ClassPath中即可：

```
java -cp lib/mysql-connector-java-8.0.27.jar:src com.junnanwu.jdbc.JDBCTest
```

所以其实原理还是ClassPath，那么当然可以把lib起名为任何名字，只要最后将对应的jar包加入ClassPath即可。

当然，我们都是使用方便的IDE来开发，那么在IDEA中对应的操作就是：建一个文件夹（例如lib），然后**右键 -> Add as Library**，即可。

如果我们使用maven来管理项目，使用约定好的目录结构，那就更简单了，不过最后原理还是一样的。

### Java核心类库去哪里找

这里涉及到了Java虚拟机的[双亲委派模型](../JavaEE/深入理解Java虚拟机)，核心类库的类（`<JAVA_HOME>\lib`文件夹下）最终都会由应用程序类加载器(Application Class Loader)加载，**第三层，应用程序类加载器（Application ClassLoader）负责加载用户ClassPath上所有的类库。**

故核心类库由应用程序加载器加载，它会找到对应的核心类库。

所以我们看到网上很多教程还在让将`rt.jar`等核心类库加入到ClassPath中是完全没有必要的。

## 关于JAVA_HOME

Java本身是不需要配置这个环境变量的，安装Java只需要将jdk的bin目录添加到PATH变量中即可，方便随时调用javac、java等命令。

但是一些用到jdk/jre的工具有可能会使用`JAVA_HOME`环境变量：

1. 例如：IDEA中的Gradle可以选择Gradle JVM为`JAVA_HOME`，这个时候，如果你没有设置`JAVA_HOME`环境变量，那么就会报错了。

   <img src="Java%E5%9F%BA%E7%A1%80%E5%B7%A5%E5%85%B7%E4%B8%8E%E6%A6%82%E5%BF%B5_assets/java-home-idea-gradle.png" alt="image-20211025114743038" style="zoom: 33%;" />

2. 在没有配置`JAVA_HOME`环境变量的时候，我本地的CAS Tomcat服务也出现了异常，

   在我指定`JAVA_HOME`的时候，启动Tomcat显示（即使用指定的JRE）：

   ```
   Using JRE_HOME:        /Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home
   ```

   在没有指定`JAVA_HOME`的时候，启动Tomcat会使用/User目录下的jdk15，导致版本不对，服务异常。

所以在配置Java环境的时候，最好配置上`JAVA_HOME`环境变量，以便其他软件使用。

## Jar

Jar(Java Archive)，Java归档。

Jar文件使用zip格式进行打包，Java提供了Jar命令对Jar包进行创建，浏览，压缩，并通过`java -jar`运行Jar包。

JAR 文件与 ZIP 文件唯一的区别就是在 JAR 文件的内容中，包含了一个`META-INF/MANIFEST.MF`文件，这个文件是在生成 JAR 文件的时候自动创建的。

格式：

```
jar {ctxui}[vfmn0PMe] [jar-file] [manifest-file] [entry-point] [-C dir] files ...
```

清单文件名, 档案文件名和入口点名称的指定顺序与 `m`, `f` 和`e` 标记的指定顺序相同。

**参数**

- `-c`

  创建一个新的Jar包

  ```
  jar cf jar-file input-file(s)
  ```

- `-t`

  查看Jar包内容

  ```
  jar tf jar-file
  ```

- `-x`

  解压

  ```
  jar xf jar-file archived-file(s)
  ```

- `-v`

  将过程信息输出

- `-f`

  指定档案文件名

- `-m`

  定义`MANIFEST.MF`清单文件

  ```
  $ jar -cvfm test.jar META-INF/MANIFEST.MF Test.class
  ```

- `-e`

  为Jar文件指定入口点

例如

- 将两个类文件归档到一个名为 classes.jar 的档案中

  ```
  jar cvf classes.jar Foo.class Bar.class
  ```

- 使用现有的清单文件`mymanifest`并将`foo/`目录中的所有文件归档到`classes.jar`中

  ```
  jar cvfm classes.jar mymanifest -C foo/ .
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

## References

1. [JDK Tools and Utilities](https://docs.oracle.com/Javase/7/docs/technotes/tools/index.html)
2. https://www.liaoxuefeng.com/wiki/1252599548343744/1260466914339296
3. https://www.cnblogs.com/flashsun/p/7246260.html