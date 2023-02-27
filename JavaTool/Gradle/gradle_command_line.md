# Gradle命令行

但凡使用Gradle，都需要了解Gradle命令行，这里介绍一下其格式和参数，详见[官方文档](https://docs.gradle.org/current/userguide/command_line_interface.html)。

## 命令格式

```
gradle [taskName...] [--option-name...]
```

可以指定多个任务，中间用空格分隔，多任务会在保证依赖顺序的前提下，交换执行的顺序。

多项目可以通过全限定名来执行某个项目下的任务：

```
$ gradle :my-subproject:taskName
```

或者

```
$ cd my-subproject
$ gradle taskName
```

在根项目目录下执行如下命令，代表所有子项目都执行test任务

```
$ gradle test
```

注意，如果是 `help` 、`dependencies`等任务，则只会执行调用命令所在的project的任务。

## 选项

参数相关：

- `-P,--project-prop`

  项目参数是构建脚本中可用的变量。你可以使用这个选项直接向构建脚本中传入参数（比如，`-Pmyprop=myvalue`）。

日志相关

- `-i --info`

  INFO级别，能输入更多的信息。

- `-q --quiet`

  减少构建打印的信息。

帮助相关（任务）：

- `tasks`

  显示项目中所有可运行的task，包括他们的描述信息。

- `properties`

  显示项目中所有可用的属性。

**查看依赖顺序**

通过`-m --dry-run `参数来查看一个任务的依赖顺序，例如：

```
$ gradle build -m
:compileJava SKIPPED
:processResources SKIPPED
:classes SKIPPED
:bootJarMainClassName SKIPPED
:bootJar SKIPPED
:jar SKIPPED
:assemble SKIPPED
:compileTestJava SKIPPED
:processTestResources SKIPPED
:testClasses SKIPPED
:test SKIPPED
:check SKIPPED
:build SKIPPED
```

**跳过某个任务**

通过 `-x --exclude-task`参数跳过某个任务， 例如，跳过单元测试：

```
$ gradle build -m -x test
:compileJava SKIPPED
:processResources SKIPPED
:classes SKIPPED
:bootJarMainClassName SKIPPED
:bootJar SKIPPED
:jar SKIPPED
:assemble SKIPPED
:check SKIPPED
:build SKIPPED
```

**失败继续运行**

某个依赖失败，继续执行。

```
$ gradle test --continue
```

## References

1. Gradle官方文档：[Command-Line Interface](https://docs.gradle.org/current/userguide/command_line_interface.html)