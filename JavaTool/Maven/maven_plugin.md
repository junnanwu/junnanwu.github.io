# Maven插件

实际上，执行每个phase，Maven都会调用相关联的插件来执行。例如，当Maven执行`compile`这个Phase的时候，就会由compiler插件执行`compiler:compile`这个goal来完成编译。

Maven也提供了一系列不需要声明的标准插件，例如：

| 插件名称 | 对应执行的phase |
| :------- | :-------------- |
| clean    | clean           |
| compiler | compile         |
| surefire | test            |
| jar      | package         |

当然，如果标准插件无法满足，我们也可以使用自定义的的插件。

## 声明插件

例如：

```xml
<project>
  ...
  <build>
    <plugins>
      <plugin>
        <artifactId>maven-myquery-plugin</artifactId>
        <version>1.0</version>
        <executions>
          <execution>
            <id>execution1</id>
            <phase>test</phase>
            <configuration>
              <url>http://www.foo.com/query</url>
              <timeout>10</timeout>
              <options>
                <option>one</option>
                <option>two</option>
                <option>three</option>
              </options>
            </configuration>
            <goals>
              <goal>query</goal>
            </goals>
          </execution>
          <execution>
            <id>execution2</id>
            <configuration>
              <url>http://www.bar.com/query</url>
              <timeout>15</timeout>
              <options>
                <option>four</option>
                <option>five</option>
                <option>six</option>
              </options>
            </configuration>
            <goals>
              <goal>query</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
  ...
</project>
```

在第一个`execution`中，相关配置被绑定到了`test`phase中，而第二个`execution`没有指定phase，那么如果对应的goal有默认的phase，那么就在那个phase执行，如果这个goal没有绑定默认的phase，那么就不执行。

一般一个`goal`是有默认的`phase`的，但是我们可以通过`execution`将这个`goal`绑定到其他`phase`上。

在Maven 3.3.1之后，可以通过下面`plugins@id`的方式直接调用对应的`execution`：

```
mvn myquery:query@execution1
```

**插件版本不生效怎么办？**

在IDEA中，有时候我们在`<plugin>`在添加一个插件的指定版本的时候，一直显示红色无法加载，这个时候我们可以在上面的`<dependency>`中添加这个插件，将其下载到本地，然后`<plugin>`中就恢复正常了。

## maven-assembly-plugin

可以使用[该插件](http://maven.apache.org/plugins/maven-assembly-plugin/usage.html)打包fat jar，官方提供的预定义描述符：

- `bin`

  只打包编译结果，并包含 README, LICENSE 和 NOTICE 文件，输出文件格式为 tar.gz, tar.bz2 和 zip

- `jar-with-dependencies`

  打包编译结果和所有的依赖

- `src`

  打包源码文件

- `project`

  打包整个项目

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

descriptor

```xml
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

- `<includeBaseDirectory>`

  是否多加一层基目录，否的话就会将要打包的直接打包在基目录下

- `useProjectArtifact`

  > Determines whether the attached artifacts produced during the current project's build should be included in this dependency set. (Since 2.2-beta-1)
  >
  > **Default value is**: `false`.

版本测试：

2.2（默认版本）

包含好多个goal，使用assembly:assembly会产生classes文件（其中包括文件），并将文件也打包进去

3.0、3.3版本之后

之后两个goal，主要就是single，这个时候，不会产生classes文件，并且没有文件

## maven-dependency-plugin

[官方文档详见此](https://maven.apache.org/plugins/maven-dependency-plugin/index.html)

常用的goal

`dependency:tree`

可选参数：

- `includes`

  过滤器，过滤你想看的依赖

  参数值：string，每个段都是可选的：`[groupId]:[artifactId]:[type]:[version]`

  支持通配符`*`
  
  例如：

  - `org.apache.*`
  - `:::*-SNAPSHOT`
  
- `verbose`

  是否显示省略的依赖树，类型是`boolean`，默认为`false`

举例：

```
$ mvn dependency:tree -Dverbose -Dincludes="*logback:logback*"
xxxx
\- ch.qos.logback:logback-classic:jar:1.2.3:compile
   \- ch.qos.logback:logback-core:jar:1.2.3:compile
```

https://www.cnblogs.com/lianshan/p/7350614.html

`dependency:copy-dependencies`

>takes the list of project direct dependencies and optionally transitive dependencies and copies them to a specified location, stripping the version if desired. This goal can also be run from the command line

有选择的将直接依赖复制到某个地方

## maven-shade-plugin

## docker-maven-plugin

## dockerfile-maven

https://github.com/spotify/dockerfile-maven

https://github.com/spotify/dockerfile-maven/blob/master/docs/usage.md

https://github.com/spotify/dockerfile-maven/blob/master/docs/authentication.md

## spring-boot-maven-plugin

https://blog.csdn.net/u010406047/article/details/110878472

## Reference

1. Maven官方文档：[Guide to Configuring Plug-ins](https://maven.apache.org/guides/mini/guide-configuring-plugins.html)
2. Maven官方文档：[Apache Maven Dependency Plugin](https://maven.apache.org/plugins/maven-dependency-plugin/)
2. 博客：[Java 打包 FatJar 方法小结](https://developer.aliyun.com/article/630208)
4. Github：[dockerfile-maven](https://github.com/spotify/dockerfile-maven)