# Maven

## Maven基础

加载setting的顺序

优先加载 用户目录下的 setting.xml,如果没有，则找全局的setting.xml

即pom.xml > /home_dir/.m2/settings.xml > /maven_dir/conf/settings.xml

## Maven的生命周期

[详见此官方文档](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)

### 生命周期

Maven三套**独立的**生命周期 (lifecycle)，这三个周期分别是：

- `default` 部署项目相关流程
- `clean` 清理项目

- `site` 网站发布相关

### 阶段

**每一个生命周期都是由不同的阶段 (phases) 组成。**

例如，`default`生命周期：

- `validate` 
- `compile`
- `test`
- `package`
- `verify`
- `install`
- `deploy`

你可以通过`mvn + phase`命令来调用上述声明流程，**运行某个阶段的时候，它之前的所有阶段都会被运行**，例如，当你输入`mvm package`的时候：就会依此从`validate`阶段运行到`package`阶段。

clean生命周期：

- `pre-clean`
- `clean`
- `post-clean`

### goal

一个阶段会绑定一个或多个goal，goal的命名总是：`plugin:goal`的形式。

例如：

| Phase     | plugin:goal                                                  |
| --------- | ------------------------------------------------------------ |
| `compile` | `compiler:compile`                                           |
| `test`    | `surefire:test`                                              |
| `package` | `ejb:ejb` or `ejb3:ejb3` or  `jar:jar`  or  `par:par` or  `rar:rar`  or  `war:war` |

## Maven插件

当Maven执行`compile`这个Phase的时候，就会由compiler插件执行`compiler:compile`这个goal来完成编译。

### maven-assembly-plugin插件

可以使用官方提供的打包方式：

```xml
<configuration>
    <descriptorRefs>
        <descriptorRef>jar-with-dependencies</descriptorRef>
    </descriptorRefs>
</configuration>
```

也可以使用`descriptors`指定打包文件

```xml
<configuration>
    <descriptors>
        <descriptor>src/assembly/src.xml</descriptor>
    </descriptors>
</configuration>
```

http://maven.apache.org/plugins/maven-assembly-plugin/usage.html



```
<?xml version='1.0' encoding='UTF-8'?>
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.0 http://maven.apache.org/xsd/assembly-1.1.0.xsd">

    <id>${project.version}</id>

    <formats>
        <format>jar</format>
    </formats>

    <includeBaseDirectory>false</includeBaseDirectory>

    <!-- 指定将工程依赖的包打到包里的指定目录下 -->
    <dependencySets>
        <dependencySet>
            <useProjectArtifact>true</useProjectArtifact>
            <outputDirectory>lib</outputDirectory>
            <scope>runtime</scope>
        </dependencySet>
    </dependencySets>

    <!-- 指定要包含的文件集，可以定义多个fileSet -->
    <fileSets>
        <fileSet>
            <directory>src/main/resources</directory>
            <outputDirectory>conf</outputDirectory>
            <includes>
                <include>log4j2.xml</include>
            </includes>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>src/main/script</directory>
            <outputDirectory>conf</outputDirectory>
            <includes>
                <include>assembly.xml</include>
            </includes>
            <fileMode>0644</fileMode>
        </fileSet>
        <fileSet>
            <directory>src</directory>
            <outputDirectory>sql</outputDirectory>
            <includes>
                <include>example.sql</include>
            </includes>
            <fileMode>0644</fileMode>
        </fileSet>
    </fileSets>
</assembly>
```

