# Gradle基本原理

## Gradle Hello World

每个Gradle的构建都是以一个脚本开始的，当在shell中执行gradle命令的时候，Gradle会去寻找名字是`build.gralde`的文件。

我们可以在`build.gralde`中创建一个task：

```
task helloWorld{
    doLast{
        println 'Hello world!'
    }
}
```

我们可以看到如下输出：

```
$ gradle -q helloWorld
Hello world!
```

我们还可以查看所有任务：

```
$ gradle -q tasks --all
```

看到如下输出：

```
------------------------------------------------------------
All tasks runnable from root project
------------------------------------------------------------

Build tasks
-----------
assemble - Assembles the outputs of this project.
build - Assembles and tests this project.
buildDependents - Assembles and tests this project and all projects that depend on it.
buildNeeded - Assembles and tests this project and all projects it depends on.
classes - Assembles main classes.
clean - Deletes the build directory.
jar - Assembles a jar archive containing the main classes.
testClasses - Assembles test classes.

...

Other tasks
-----------
compileJava - Compiles main Java source.
compileTestJava - Compiles test Java source.
helloWorld
```

Gradle提供了任务组的概念，例如`Build tasks`，每个构建脚本都会默认暴露在`Other tasks`任务组中。

## Gradle基本构成

每个Gradle构建都包含三个基本的构建块：project、task和property，Gradle API中有相应的类来表示project和task。

### project

一个project代表一个正在构建的组件，当构建进程启动后，Gradle基于build.gradle中的配置实例化`org.gradle.api.Project`类。

Project类API：

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

调用project的方法：

```
setDescription("myProject")
println "Description of project $name: " + project.description
```

得到输出：

```
> Configure project :
Description of project gradle-project: myProject
```

### property

一个属性可以是一个任务的描述或项目的版本，你也可以通过拓展属性自定义一些变量，使用示例：

```
project.ext.myProp = 'myValue'

//简写
ext {
    someOtherProp = 123
}

assert myProp == 'myValue'
println project.someOtherProp
ext.someOtherProp = 567
```

### task

`org.gradle.api.Task`接口的API：

```
//task依赖
dependesOn()

//动作定义
doFirst()
doLast()
getActions()

//输入输出数据声明
getInputs()
getOutputs()

//getter/setter
getDescription()
getEnable()
getGroup()
setDescription()
setEnable()
setGroup()
```

#### 声明task

Task接口提供了两个相关的方法来声明task动作：

- `doFirst(Closure)`
- `doLast(Closure)`

当Task被执行的时候，动作逻辑被定义为闭包参数被依次执行。

定义一个打印版本的task：

```
task printVersion {
    doLast {
        println "Version: $version"
    }
}
```

输出：

```
> Task :printVersion
Version: 0.1-SNAPSHOT
```

上述方法放在doFrist也一样的效果。

还可以为task设置group和description，它们都是task文档的一部分。

```
task printVersion(group: 'verisoning', description: 'Prints projects version.') {
    doLast {
        logger.quiet "Version: $version"
        println "Version: $version"
    }
}
```

dependsOn方法允许声明依赖其他task。

注意：

- doLast的别名为`<<`
- Gradle保证了被依赖的task需要先执行，并不能保证没有依赖关系的task之间的执行顺序

#### task配置

我们可以声明一个task，并不定义动作或者使用`<<`，这种task，Gradle称之为task配置。

task配置块永远在task动作执之前被执行。

#### Gradle构建声明周期阶段

无论什么时候执行Gradle构建，都会运行三个不同的生命周期阶段：

- 初始化阶段

  在初始化阶段，Gradle为项目创建了一个project实例。在多项目中这个阶段很重要，根据你要执行的项目，Gradle找出哪些项目依赖需要参与到构建当中。

- 配置阶段

  Gradle构造了一个模型来表示任务，并参与到任务中来，增量式构建特性决定了模型中的task是否需要执行。

  注意：

  项目的每一次构建的任何配置代码都可以被执行，即使你只执行`gradle tasks`。

- 执行阶段

  所有的task都应该被以正确的顺序执行。执行的顺序是由它们的依赖决定的，如果任务被认为没有被修改过，将被跳过。

#### 声明task的inputs和outputs

Gradle通过比较两个构建task的inputs和outputs来决定task是否是最新的。

## References

1. 书籍：《实战Gradle》