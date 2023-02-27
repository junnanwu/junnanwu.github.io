# Gradle参数

Gradle参数分为Gradle本身的参数和Project的参数，详细可见[官方文档](https://docs.gradle.org/current/userguide/build_environment.html)。

https://tomgregory.com/gradle-project-properties-best-practices/

## Gradle自身参数

Gradle参数用于控制构建过程的Java进程。

可以通过如下方式增加参数：

- 命令行`-P`参数
- `GRADLE_USER_HOME`下的`gradle.properties`
- 项目根目录下的`gradle.properties`
- Gradle安装目录下的`gradle.properties`

可以设置的参数如下：

- `org.gradle.daemon=(true,false)`
- `org.gradle.jvmargs=(JVM arguments)`
- `org.gradle.logging.level=(quiet,warn,lifecycle,info,debug)`
- `org.gradle.parallel=(true,false)`

使用样例如下：

`gradle.properties`文件如下：

```
gradlePropertiesProp=gradlePropertiesValue
sysProp=shouldBeOverWrittenBySysProp
systemProp.system=systemValue
```

创建如下任务：

```
tasks.register('printProps') {
    doLast {
        println commandLineProjectProp
        println gradlePropertiesProp
        println systemProjectProp
        println System.properties['system']
    }
}
```

执行如下命令查看测试结果：

```
$ gradle -q -PcommandLineProjectProp=commandLineProjectPropValue -Dorg.gradle.project.systemProjectProp=systemPropertyValue printProps
commandLineProjectPropValue
gradlePropertiesValue
systemPropertyValue
systemValue
```

## 系统属性

由于Gradle也是一个Java进程，也可以通过`-D`来将参数传递给JVM。

可以设置如下参数：

- `gradle.user.home=(path to directory)`

## 环境变量

Gradle运行时同时也会读取系统的一些环境变量：

- `GRADLE_OPTS`
- `GRADLE_USER_HOME`
- `JAVA_HOME`

## 项目属性

Gradle还可以通过如下参数传递给Project对象一些项目参数：

- 命令行`-P`参数

- 如下命名的系统属性：

  ```
  org.gradle.project.foo=bar
  ```

- 如下命令的变量：

  ```
  ORG_GRADLE_PROJECT_foo=bar
  ```

可以通过如下方法检查项目属性是否存在：

```
Project.hasProperty(java.lang.String)
```

## References

1. Gradle官方文档：[Build Environment](https://docs.gradle.org/current/userguide/build_environment.html)