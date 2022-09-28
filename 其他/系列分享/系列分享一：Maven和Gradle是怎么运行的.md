# 系列分享一：Maven和Gradle是怎么运行的

Maven和Gradle作为两个Java主流的构建工具，我们几乎每天都要和它们打交道，所以搞清楚我们每天运行的命令后面发生了什么是有必要的。

## Maven

Maven作为老牌Java构建工具，使用简单，广泛，Java开发几乎都会使用Maven，但是也有部分开发停留在固定命令阶段，对Maven的生命周期和插件机制不甚了解，那么在你引入Maven插件的时候，你很可能会对其中的配置感到困惑，所以本文Maven部分主要讲解Maven的核心——生命周期和插件机制。

作为一个Java开发，我们对`mvn clean package`可以说是非常熟悉了，这命令后面意味着什么呢？让我们从Maven的生命周期开始。

### 生命周期

在Maven出现之前，项目构建的生命周期就已经存在， 开发人员每天都在对项目进行清理，编译，测试以及部署，但是不同团队之间，还是会有一些差异，所以Maven对项目的构建过程进行了抽象。

初学者最大的误区就是Maven的生命周期是一个整体，其实Maven有三个独立的生命周期，分别是clean、default、site。**每个生命周期都包含一些阶段（phase），这些阶段是有序的，并且后面的阶段依赖前面的阶段**。

例如，clean生命周期的阶段如下：pre-clean、clean、post-clean，当我们执行mvn clean的时候，就会先执行pre-clean阶段，再执行clean阶段。

下面我们在看default生命周期，其主要阶段如下：validate、compile、test、package、verify、install、deploy。

类似的，当我们执行mvn package命令的时候，就会依此执行validate、compile、test、package阶段。

### 插件目标

上面仅仅是Maven的生命周期和对应的阶段，是一种抽象，**真正的实现是由插件的目标（goal）来完成**，一个插件往往有多个目标，他们被绑定到不同的阶段上，当执行到对应阶段的时候，对应的目标将被执行。

例如，default生命周期的compile阶段是由maven-compiler-plugin的compile目标来实现。

为了能让用户几乎不用任何配置就能构建Maven项目，Maven在一些主要的生命周期阶段绑定了很多插件的目标，除了上面的compile阶段，还有clean生命周期的clean阶段与maven-clean-plugin插件的clean目标绑定。

下面是defult生命周期阶段的默认绑定（打包类型为Jar）：

| Phase                    | plugin:goal               |
| :----------------------- | :------------------------ |
| `process-resources`      | `resources:resources`     |
| `compile`                | `compiler:compile`        |
| `process-test-resources` | `resources:testResources` |
| `test-compile`           | `compiler:testCompile`    |
| `test`                   | `surefire:test`           |
| `package`                | `jar:jar`                 |
| `install`                | `install:install`         |
| `deploy`                 | `deploy:deploy`           |

**mvn命令行格式**

mvn后面除了跟phase外，还能直接指定goal，格式为：

```
mvn [options] [<goal(s)>] [<phase(s)>]
```

例如，通过maven-dependency-plugin插件（默认插件）的tree目标查看项目的依赖树：

```
$ mvn dependency:tree
```

还可以通过命令行给插件传递参数，插件maven-surefire-plugin提供了一个maven.test.skip参数，当其值为true的时候，跳过单元测试，故可运行如下命令：

```
$ mvn clean package -Dmaven.test.skip=true
```

### 自定义绑定

除了Maven默认的绑定，我们也可以将某个插件的目标绑定到生命周期的某个阶段上。

例如，当我们想打一个fat包，我们引入maven-assembly-plugin插件，并把其中的single目标绑定到default生命周期的package阶段。

```xml
<plugin>
    <artifactId>maven-assembly-plugin</artifactId>
    <executions>
        <execution>
            <phase>package</phase>
            <goals>
                <goal>single</goal>
            </goals>
        </execution>
    </executions>
    <configuration>
        ...
    </configuration>
</plugin>
```

这时候当我们执行`mvn package`，我们会看到`maven-jar-plugin:3.0.2:jar`和`maven-assembly-plugin:2.2-beta-5:single`这两个goal都会被执行：

```
$ mvn clean package
...
[INFO] --- maven-jar-plugin:3.0.2:jar (default-jar) @ example_project ---
[INFO]
[INFO] --- maven-assembly-plugin:2.2-beta-5:single (default) @ example_project ---
...
```

并打出了一个普通Jar包和一个fat Jar包：

```
$ ls -l target|grep jar
-rw-r--r--  1 wujunnan  staff   149M Sep 25 00:26 example_project-1.0-SNAPSHOT-jar-with-dependencies.jar
-rw-r--r--  1 wujunnan  staff    17K Sep 25 00:21 example_project-1.0-SNAPSHOT.jar
```

说到打包，这里稍微展开说下，我们可以看到上面的默认插件maven-jar-plugin打出来的包是只有17K，也就是只有我们写的代码（即Skinny包），并没有依赖，这作为项目肯定是无法运行的。

所以如果是普通的项目，我们可以引入maven-assembly-plugin这类插件，将依赖和我们的代码都打包到一个Jar包中（也就是Fat/Uber包），当然使用了Spring项目，通常会引入spring-boot-maven-plugin插件。

### 依赖管理

Maven提供了dependencyManagement可以让我们在父项目中管理我们的依赖，主要包括依赖的版本。

所以我们创建SpringBoot项目的时候可以很好的利用这一点来管理依赖，通常我们在SpringBoot项目的POM文件中添加如下部分：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.6.7</version>
</parent>
```

我们可以看到spring-boot-starter-parent项目的POM文件还有一个parent部分：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-dependencies</artifactId>
    <version>2.6.7</version>
</parent>
```

其中spring-boot-dependencies项目部分主要就是对依赖版本部分的依赖了：

```xml
<properties>
    <activemq.version>5.16.4</activemq.version>
    ...
</properties>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.apache.activemq</groupId>
            <artifactId>activemq-amqp</artifactId>
            <version>${activemq.version}</version>
        </dependency>
        <dependency>
            <groupId>org.apache.activemq</groupId>
            <artifactId>activemq-blueprint</artifactId>
            <version>${activemq.version}</version>
        </dependency>
        ...
    </dependencies>
</dependencyManagement>
```

同理，还有插件管理也是如此，spring-boot-starter-parent项目中还有pluginManagement部分对很多插件做了默认配置，这就正是为什么在我们的项目中引入spring-boot-maven-plugin插件，并没有进行阶段的绑定，在执行`mvn package`的时候，spring-boot-maven-plugin插件的目标依然会被执行。

## Gradle

Maven最大的缺点就是过于死板，例如，我们想在打包完成后输出Jar包的大小，实现起来就非常困难，需要定制插件，而插件的编写是十分困难的，而Gradle作为基于Maven的新一代构建工具，**在保证约定大于配置的同时，使用了Groovy来灵活的定制逻辑**，满足上面的需求，使用Gradle仅仅需要加入几行Groovy脚本。

同时Gradle还具有构建速度更快、对非Gradle项目兼容性好等优点，所以Gradle被越来越多的项目所使用，尤其是大型项目，例如，SpringBoot在2020年6月就改为使用Gradle进行构建，主要目的就是大大提升了SpringBoot的构建速度，使用Maven需要一个小时甚至以上的时间，而使用Gradle，则只需要9分钟。

我们公司大部分项目都是基于Gradle的，部分新来的同事没有使用过Gradle，故本文Gradle部分会详细一些。

### 基本概念

Gradle的核心概念是Project和Task。

当构建进程启动后，Gradle就会基于build.gradle实例化Project类，其API如下：

```
//构建脚本配置
apply()
buildscript()

//依赖管理
dependencies()
configurations()
getDependencies()
getConfigurations()

//getter/setter
getName()
getDescription()
getGroup()
getVerison()
setVersion()

//创建文件
file()

//创建任务
task()
```

一个project可以创建多个task，应用插件。





## 总结



## References

1. Maven官方文档：[Introduction to the Build Lifecycle.](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
2. 书籍：《Maven实战》，作者：许晓斌
3. 书籍：《实战Gradle》，作者：Benjamin Muschko
4. 博客：[Migrating Spring Boot's Build to Gradle](https://spring.io/blog/2020/06/08/migrating-spring-boot-s-build-to-gradle)
5. Gradle官方文档：[The Java Plugin](https://docs.gradle.org/current/userguide/java_plugin.html)

