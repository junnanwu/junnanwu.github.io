# Gradle

Gradle是Java软件开发中的自动化构建工具，类似于传统的Ant和Maven，Gradle吸收沿用了Maven中比较成功的一些实践，但相对又有极强的拓展性。

由于Ant过于灵活，导致配置臃肿，而面对现代大规模的项目，Maven默认的结构和生命周期又常常会太过限制，而且定制拓展过于累赘，Gradle则正是二者的折中。

Maven非常武断，它建议一个工程只包含一个Java源代码目录且只产生一个JAR文件。这对于许多企业级项目不一定合适。 Gradle允许你轻松地打破约定。与这个现象对立的是，Ant不会给你任何关于如何组织构建脚本方面的指导以确保最大程度的灵活性。 Gradle则折中选择，既提供约定，又给予你改变约定的能力。

Gradle基于Groovy而不是XML，XML在表述构建逻辑方面存在不足，Gradle你可以使用Java或者Groovy语言来编写定制逻辑。

## 构建简单Java项目

1. 创建Java代码，代码放在`src/main/java`下

   ```
   src
   └── com
       └── junnanwu
           ├── ToDoApp.java
           ├── domain
           │   └── ToDoItem.java
           └── service
               ├── ToDoService.java
               └── impl
                   └── ToDoServiceImpl.java
   ```

2. 在项目的根目录下 (与src同级) 创建构建脚本build.gradle

3. 在build.gradle中添加Java插件

   ```
   apply plugin : 'java'
   ```

   Java插件引入的约定之一就是源代码的位置，默认情况下，插件会到`src/main/java`目录下查找。

   Java插件提供了一个任务叫做build，这个build任务会以正确的顺序编译你的源代码，运行测试结果，组装JAR文件。

4. 运行构建命令

   ```
   $ gradle build
   
   Starting a Gradle Daemon, 2 incompatible Daemons could not be reused, use --status for details
   
   BUILD SUCCESSFUL in 3s
   1 actionable task: 1 executed
   ```

5. 生成构建文件

   ```
   build
   ├── libs
   │   └── gradle_study.jar
   └── tmp
       └── jar
           └── MANIFEST.MF
   ```

## 多项目构建

位于顶层目录的项目被称为根项目，它协调构建子项目，并为子项目定义一些共同的或特定的行为。

在多项目构建中，默认是通过settings.gradle文件来声明子项目的，并在根项目的build.gradle文件放在一起。

可以通过调用带有项目路径参数的include方法来引用子项目。

```
include 'model'
include 'respository', 'web'
```

注意：

- include的参数是项目路径，即相对于根目录的项目目录

- 有多个项目可以用逗号分隔

- 如果要添加更深层次的项目，可以使用`:`来分隔每一个子项目的层次结构

  例如：你想要映射modle/todo/items目录结构，则可以通过`model:todo:items`方式来添加子项目

- 根项目和所有的子项目都应该使用相同的group和version

- 所有子项目都是Java项目，并且都需要Java插件来保证正常运行，所以只需要对子项目应用插件，而不是根项目

可以通过`gradle projects`查看项目结构：

```
$ gradle projects 

> Task :projects

------------------------------------------------------------
Root project
------------------------------------------------------------

Root project 'data-web'
+--- Project ':backend'
+--- Project ':schedule'
+--- Project ':upms'
\--- Project ':warehouse'
```

### 构建多模块

#### 声明项目依赖

```
//modle子项目不需要任何外部依赖
project(':modle'){
    ...
}

project(':repository'){
    ...
    dependencies {
        complie project(':modle')
    }
}
```

注意：

- 对另一个项目的依赖，也要将其所有依赖添加到classpath中
- 对另一个子项目的依赖意味着，这个子项目必须先被构建

#### 多项目部分构建

#### 定义公共行为

如果你想为所有的项目或者只有子项目定义一些公共的行为，所以Projects API提供了两个专门的方法：

```
//公共的项目配置
allprojects()
subprojects()
```

例如：

- 将Java插件应用到所有子项目中

  ```
  subprojects {
      apply plugin: 'java'
  }
  ```


## 使用插件

添加插件（必须在父项目中）：

```
plugins {
    id 'java'
    id 'org.springframework.boot' version '2.4.1'
}
```

注意：

 `java`是“核心插件”，而`org.springframework.boot`是“社区插件”（[Gradle插件中心](https://links.jianshu.com/go?to=https%3A%2F%2Fplugins.gradle.org%2F)），必须指定version。

## References

1. 书籍：《实战Gradle》
1. 官方文档：[The Java Library Plugin](https://docs.gradle.org/current/userguide/java_library_plugin.html)
