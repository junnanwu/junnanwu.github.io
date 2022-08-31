# Maven

## Maven介绍

Apache Maven是一个项目管理工具，基于POM（project object model）文件，Maven可以实现对Java项目的构建和管理。

由于Ant过于灵活，构建脚本长而难以维护， Maven团队认识到标准化项目布局和统一构建生命周期的必要性。 Maven选择约定优于配置的思想。

例如，使用标准目录， 这使得开发人员可以轻松的知道去哪里找什么类型的文件，例如，Java应用程序源代码的目录是`src/main/java`。

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

```xml
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

### 设置仓库镜像

由于Maven官方仓库下载速度太慢，我们可以使用国内的景象进行替换，[详见此](https://developer.aliyun.com/mvn/guide)。

在Maven的配置文件`<mirrors></mirrors>`标签中添加mirror子节点中添加如下内容：

```
<mirror>
  <id>aliyunmaven</id>
  <mirrorOf>*</mirrorOf>
  <name>阿里云公共仓库</name>
  <url>https://maven.aliyun.com/repository/public</url>
</mirror>
```

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

一个阶段会绑定零个或多个goal，如果一个phase没有绑定goal，那么就跳过这个phase。

goal的命名总是：`plugin:goal`的形式。

一个Phase也会绑定一些默认的goal，例如：

clean生命周期：

| Phase   | plugin:goal   |
| :------ | :------------ |
| `clean` | `clean:clean` |

默认生命周期有很多phase，goal的默认绑定与打包类型相关，下面是打包类型为`ejb`/`ejb3`/`jar`/ `par`/`rar`/ `war`的时候的绑定：

| Phase                    | plugin:goal                                                  |
| :----------------------- | :----------------------------------------------------------- |
| `process-resources`      | `resources:resources`                                        |
| `compile`                | `compiler:compile`                                           |
| `process-test-resources` | `resources:testResources`                                    |
| `test-compile`           | `compiler:testCompile`                                       |
| `test`                   | `surefire:test`                                              |
| `package`                | `ejb:ejb` *or* `ejb3:ejb3` *or* `jar:jar` *or* `par:par` *or* `rar:rar` *or* `war:war` |
| `install`                | `install:install`                                            |
| `deploy`                 | `deploy:deploy`                                              |

没有绑定在特定parse的goal也可以单独执行，例如：

```
mvn clean dependency:copy-dependencies package
```

上述命令意味着先执行clean生命周期中的clean及其之前phase，然后执行dependency:copy-dependencies goal，最后执行default生命周期中的package及其之前phase。

## Dependency Management

Dependency Management的作用是集中管理依赖，例如：

1. excluded部分
2. version

Dependency Management中有的信息，dependency中再次使用就不用再写，详见[官方文档](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)例子。

相当于依赖的模版，当maven使用某个依赖的时候，会去Dependency Management中寻找有没有对应的模版，如果有，则直接使用其模版，如果模板的内容不合适，可以直接在dependency中指定自己需要的内容，dependency的优先级大于Management。

### Importing Dependencies

由于maven是单继承的，所以在大型项目中，要想引入多份Dependency Management，可以通过导入import scope的依赖来实现。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>maven</groupId>
            <artifactId>A</artifactId>
            <version>1.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        <dependency>
            <groupId>test</groupId>
            <artifactId>d</artifactId>
            <version>1.0</version>
        </dependency>
    </dependencies>
</dependencyManagement>
```

此项目就继承了A项目的Dependency Management.

### Bill of Materials (BOM) POMs

> A BOM is a special kind of POM that is used to control the versions of a project’s dependencies and provide a central place to define and update those versions.

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>com.test</groupId>
        <version>1.0.0</version>
        <artifactId>bom</artifactId>
    </parent>

    <groupId>com.test</groupId>
    <artifactId>parent</artifactId>
    <version>1.0.0</version>
    <packaging>pom</packaging>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>log4j</groupId>
                <artifactId>log4j</artifactId>
                <version>1.2.12</version>
            </dependency>
            <dependency>
                <groupId>commons-logging</groupId>
                <artifactId>commons-logging</artifactId>
                <version>1.1.1</version>
            </dependency>
        </dependencies>
    </dependencyManagement>
    <modules>
        <module>project1</module>
        <module>project2</module>
    </modules>
</project>
```

其他想要使用这个库的项目应该把这个POM导入他们的dependencyManagement中。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>com.test</groupId>
            <artifactId>bom</artifactId>
            <version>1.0.0</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

> When referring to artifacts whose POMs have transitive dependencies, the project needs to specify versions of those artifacts as managed dependencies. Not doing so results in a build failure since the artifact may not have a version specified.

依赖版本的生效顺序：

1. 在POM中直接显式指定的版本
2. 父项目中提供的版本
3. 导入的pom版本
4. dependency mediation

如果在继承多个 pom 时发生冲突，则按顺序更早声明的依赖项优先。

### Spring BOM

我们可以在我们项目中的dependencyManagement导入spring-framework-bom来确保所有Spring依赖在同一版本。

```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-framework-bom</artifactId>
            <version>4.3.8.RELEASE</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

这样导入的时候就不需要指定版本属性：

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-web</artifactId>
    </dependency>
<dependencies>
```

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

## Resources标签

如前文所说，maven约定的资源文件夹为

- `src/main/resouces`
- `src/test/resources`

这两个目录中的文件也会分别被复制到`target/classes`和`target/test-classes`目录中，打包插件也会默认将这两个目录下的文件打包到jar或war中。

这也正是Maven Resources标签所决定的，其默认值为：

```xml
<resource>
    <!-- 主资源目录  -->    
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*.*</include>
    </includes>
    <filtering>false</filtering>
</resource>
```

当我们想让`mapper`包下的xml文件也被打包到classpath下的时候，就可以通过修改`<resource>`的方式来实现。

标签`<filtering>`是一个bool值，默认值为false。指定打包时的配置文件中是否进行变量替换。

例如：

配置文件中的（默认的占位符为`${}`）：

```
application.user=${username}
```

如果`<filtering>`为true，可以使用如下属性对上述占位符进行替换：

```xml
<properties>
    <username>mysql</username>
</properties>
```

## 模块管理

## References

1. https://www.liaoxuefeng.com/wiki/1252599548343744/1309301146648610
2. https://dzone.com/articles/the-skinny-on-fat-thin-hollow-and-uber
3. https://stackoverflow.com/questions/11947037/what-is-an-uber-jar
4. https://developer.aliyun.com/mvn/guide
7. https://www.baeldung.com/spring-maven-bom
8. https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html
8. https://www.jianshu.com/p/563ca2d68842
