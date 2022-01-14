# Maven

## Maven介绍

Apache Maven是一个项目管理工具，基于POM（project object model）文件，Maven可以实现对Java项目的构建和管理。

### 标准目录

Maven项目标准目录结构如下：

```
a-maven-project
├── pom.xml
├── src
│   ├── main
│   │   ├── java
│   │   └── resources
│   └── test
│       ├── java
│       └── resources
└── target
```

### pom.xml

```
<project ...>
	<modelVersion>4.0.0</modelVersion>
	<groupId>com.junnanwu</groupId>
	<artifactId>maven_project</artifactId>
	<version>1.0</version>
	<packaging>jar</packaging>
	<properties>
        ...
	</properties>
	<dependencies>
        <dependency>
            <groupId>commons-logging</groupId>
            <artifactId>commons-logging</artifactId>
            <version>1.2</version>
        </dependency>
	</dependencies>
</project>
```

- `packaging`

  项目的打包方式，默认为`jar`

- `dependencies/dependency*`

  使用`<dependency>`声明一个依赖后，Maven就会自动下载这个依赖包并把它放到classpath中。

  - `groupId`

    类似Java包名，通常是公司或者组织的名字

  - `artifactId`

    项目的名称

  - `version`

  一个maven工程就是由这3个变量作为唯一标识，引用其他第三方库的时候，也是通过这三个变量确定的。

  - `scope`

    指定依赖作用域

    - `complle`

      编译时需要，最常见的类型，默认也是这种，Maven会把这种类型的依赖直接放入classpath

    - `test`

      编译Test时需要，例如JUnit

    - `runtime`

      编译时不需要，但是运行时需要用到，例如mysql驱动

    - `provided`

      编译时需要，但是运行的时候不需要，例如Serverlet API，编译的时候，需要，但是运行的时，Servlet服务器内置了相关的Jar，所以运行的时候，不需要。

注意：

当我们打包的时候要想打包某个依赖的时候，可以使用`provided`

## 依赖管理

### 引入依赖

当我们需要引入依赖的时候，可以去[mvean中央仓库](https://mvnrepository.com/)进行搜索，Maven维护了一个中央仓库，所有的第三方库将自身的jar及相关信息上传至中央仓库，Maven从中央仓库下载到本地（用户目录的`.m2`目录）。

maven解决了依赖管理问题，例如，我们的项目依赖`abc`这个jar包，而`abc`又依赖`xyz`这个jar包，当我们声明了`abc`的依赖时，Maven自动把`abc`和`xyz`都加入了我们的项目依赖。

**查看依赖树：**

```
mvn dependency:tree
```

加上`-Dverbose`会显示更详细的信息。

### 依赖关系



**加载setting的顺序**

优先加载 用户目录下的 setting.xml,如果没有，则找全局的setting.xml

即pom.xml > /home_dir/.m2/settings.xml > /maven_dir/conf/settings.xml

## Maven生命周期

[详见此官方文档](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)

### 生命周期

Maven三套**独立的**生命周期 (lifecycle)，Maven的步骤必须按照这个生命周期来，而Ant的每个步骤都需要你去手工定义，这也是Maven比较简单的一个原因。

使得我们在不同的项目中，也能使用相同的命令`mvn clean install`。

预定义的三个**独立的**生命周期分别是：

- `default` 部署项目相关流程

- `clean` 清理项目

  **（注意：与上面的不是一个生命周期）**

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

所以我们常用指令：`mvn clean package`，其步骤，也就不难理解了。

### goal

一个阶段会绑定一个或多个goal，goal的命名总是：`plugin:goal`的形式。

例如：

| Phase     | plugin:goal                                                  |
| --------- | ------------------------------------------------------------ |
| `compile` | `compiler:compile`                                           |
| `test`    | `surefire:test`                                              |
| `package` | `ejb:ejb` or `ejb3:ejb3` or  `jar:jar`  or  `par:par` or  `rar:rar`  or  `war:war` |

## Java打包

Java打包有几种方式

- `Skinny`

  仅打包你所写的部分代码。

- `Thin`

  打包你所写的代码和它的直接一级依赖

- `Hollow`

  与上述`Thin`相反

- `Fat/Uber`

  打包所有依赖及依赖的依赖

其中，最实用的就是fat jar，因为其中包含了除了虚拟机外的所有依赖。fat jar也称为Uber jar，其中又分为这几种模式：

- `Unshaded`

  将所有依赖的jar文件中的class文件都平铺到一个jar中，然后使用JVM默认的类加载器加载，对于复杂应用很可能会碰到同名类相互覆盖问题。

  代表插件，[maven-assembly-plugin](http://maven.apache.org/plugins/maven-assembly-plugin/).

- `Shaded`

  跟`unsladed`类似，但是为了避免依赖冲突，重命名了所有依赖的包名，使用 JVM默认的类加载器。

  但是改名也会带来其他问题，例如:

  - 代码中使用`Class.forName`或 `ClassLoader.loadClass`装载的类，Shade Plugin是感知不到的。

  - 同名文件覆盖问题也没法杜绝，比如`META-INF/services/javax.script.ScriptEngineFactory`不属于类文件，但是被覆盖后会出现问题。

  代表插件，[maven-shade-plugin](http://maven.apache.org/plugins/maven-shade-plugin/).

- `JAR of JARs`

  一个Jar包中内嵌了其他Jar包，这个方式彻底解决了解压到出来同名覆盖的问题，但是这个是不被JVM原生支持的，JVM仅会读取包含class文件的Jar包，所以需要自定义ClassLoader。

  代表插件：[Spring boot plugin](https://docs.spring.io/spring-boot/docs/current/maven-plugin/reference/htmlsingle/).

## Maven插件

实际上，执行每个phase，Maven都会调用相关联的插件来执行。例如，当Maven执行`compile`这个Phase的时候，就会由compiler插件执行`compiler:compile`这个goal来完成编译。

Maven也提供了一系列不需要声明的标准插件，例如：

| 插件名称 | 对应执行的phase |
| :------- | :-------------- |
| clean    | clean           |
| compiler | compile         |
| surefire | test            |
| jar      | package         |

当然，如果标准插件无法满足，我们也可以使用自定义的的插件。

### 声明插件

例如：

```xml
<project>
    ...
	<build>
		<plugins>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-shade-plugin</artifactId>
                <version>3.2.1</version>
				<executions>
					<execution>
						<phase>package</phase>
						<goals>
							<goal>shade</goal>
						</goals>
						<configuration>
                            ...
						</configuration>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
</project>
```

**插件版本不生效怎么办？**

在IDEA中，有时候我们在`<plugin>`在添加一个插件的指定版本的时候，一直显示红色无法加载，这个时候我们可以在上面的`<dependency>`中添加这个插件，将其下载到本地，然后`<plugin>`中就恢复正常了。

### maven-assembly-plugin

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

### maven-dependency-plugin

[官方文档详见此](https://maven.apache.org/plugins/maven-dependency-plugin/index.html)

常用的goal

`dependency:tree`

可选参数：

- `includes`

  过滤器，过滤你想看的依赖

  参数值：string，每个段都是可选的：

  ```
  [groupId]:[artifactId]:[type]:[version]
  ```

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



### maven-shade-plugin



## 模块管理



## References

1. https://maven.apache.org/
2.   https://www.liaoxuefeng.com/wiki/1252599548343744/1309301146648610
4. https://dzone.com/articles/the-skinny-on-fat-thin-hollow-and-uber
5. https://stackoverflow.com/questions/11947037/what-is-an-uber-jar
6. https://developer.aliyun.com/article/630208
6. https://maven.apache.org/plugins/maven-dependency-plugin
