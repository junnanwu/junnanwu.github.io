# SpringBoot Stater Parent

我们在新建SpringBoot项目的时候，首先一般需要导入如下POM依赖：

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.6.8</version>
</parent>
```

那么`spring-boot-starter-parent`都有何作用呢？

> The `spring-boot-starter-parent` is a special starter that provides useful Maven defaults. It also provides a `dependency-management` section so that you can omit `version` tags for “blessed” dependencies.

总的来说，`spring-boot-starter-parent`两个作用：默认配置与依赖管理。

`spring-boot-starter-parent`依赖内部没有任何依赖项，只有一个POM文件，其中包括如下部分：

- `<properties>`内规定了一些默认属性
- `<pluginManagement>`内提供了一些默认插件
- `<resources>`内指定了哪些文件是资源文件
- `spring-boot-dependencies`为其parents依赖，负责管理依赖版本

接下来详细看看这三部分（可以温习[Maven基础](../../工具/Build/Maven.md)）。

## 默认属性

```xml
<properties>
    <java.version>1.8</java.version>
    <resource.delimiter>@</resource.delimiter>
    <maven.compiler.source>${java.version}</maven.compiler.source>
    <maven.compiler.target>${java.version}</maven.compiler.target>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
</properties>
```

指定了使用的 JDK 版本号为`1.8`，编译时使用`UTF-8`编码方式。

## 默认插件

提供了`spring-boot-maven-plugin`、`maven-shade-plugin`等一系列插件及其配置：

```xml
<pluginManagement>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <executions>
                <execution>
                    <id>repackage</id>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <mainClass>${start-class}</mainClass>
            </configuration>
        </plugin>
		...
    </plugins>
</pluginManagement>
```

## 默认资源

```xml
<resources>
    <resource>
        <directory>${basedir}/src/main/resources</directory>
        <filtering>true</filtering>
        <includes>
            <include>**/application*.yml</include>
            <include>**/application*.yaml</include>
            <include>**/application*.properties</include>
        </includes>
    </resource>
    <resource>
        <directory>${basedir}/src/main/resources</directory>
        <excludes>
            <exclude>**/application*.yml</exclude>
            <exclude>**/application*.yaml</exclude>
            <exclude>**/application*.properties</exclude>
        </excludes>
    </resource>
</resources>
```

- 第一个`resource`块`<filter>true</filter>`，表示只会将这三类文件复制到输出目录。
- 第一个`resource`块没有`<filter>true</filter>`，表示会将所有其他文件复制到输出目录。

## 依赖管理

`spring-boot-starter-parent`POM也有如下parent依赖，专门负责管理依赖版本。

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-dependencies</artifactId>
    <version>2.6.7</version>
</parent>
```

`spring-boot-dependencies`中就是依赖版本的管理了：

```xml
<properties>
    <jedis.version>3.7.1</jedis.version>
    <jetty.version>9.4.46.v20220331</jetty.version>
    <logback.version>1.2.11</logback.version>
    <build-helper-maven-plugin.version>3.2.0</build-helper-maven-plugin.version>
    ...
</properties>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>redis.clients</groupId>
            <artifactId>jedis</artifactId>
            <version>${jedis.version}</version>
        </dependency>
        <dependency>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-reactive-httpclient</artifactId>
            <version>${jetty-reactive-httpclient.version}</version>
        </dependency>      
        <dependency>
            <groupId>ch.qos.logback</groupId>
            <artifactId>logback-access</artifactId>
            <version>${logback.version}</version>
        </dependency>
        ...
    </dependencies>
</dependencyManagement>
...
```

**理解Maven的Dependency Management**

Dependency Management即Maven对依赖版本等信息的管理，当引入依赖的时候，Maven会先在Dependency Management中查找是否有这个依赖的版本等模版信息，有的话则使用（dependency的优先级大于Management）。

**总结**

`spring-boot-starter-parent`依赖并不提供具体依赖项，而是提供了插件，打包默认配置以及依赖的版本管理。

## References

1. https://docs.spring.io/spring-boot/docs/2.6.8/reference/html/getting-started.html#getting-started
2. https://stackoverflow.com/questions/60041457/spring-boot-starter-parent-resources-includes-excludes-explained
