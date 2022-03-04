# Gradle基本原理

每个Gradle构建都包含三个基本的构建块：project、task和property，Gradle API中有相应的类来表示project和task。

## project

一个project代表一个正在构建的组件，当构建进程启动后，Gradle基于build.gradle中的配置实例化org.gradle.api.Project类。

project API：

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
Description of project gradle_study: myProject
```

## 属性

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



## task

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

默认情况下，每个新创建的task都是`org.gradle.api.DefaultTask`类型的。

### 声明task

Task接口提供了两个相关的方法开声明task动作：

- `doFirst()`
- `doLast()`

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
- Gradle并不能保证task依赖的执行顺序

### 声明task的inputs和outputs

Gradle通过比较两个构建task的inputs和outputs来决定task是否是最新的。

## Gradle构建声明周期阶段

比执行的三个阶段

- 初始化阶段

  在初始化阶段，Gradle为项目创建了一个project实例。

- 配置阶段

  Gradle构造了一个模型来表示任务，并参与到任务中来，增量式构建特性决定了模型中的task是否需要执行。

- 执行阶段

  所有的task都应该被以正确的顺序执行。执行的顺序是由它们的依赖决定的。



## References

1. 《实战Gradle》