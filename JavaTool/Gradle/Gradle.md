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



## 依赖管理

### 仓库配置

Gradle支持引入公共仓库和自定义仓库。

Gradle相关接口提供了快捷方式来声明Maven Central，即通过调用`mavenCentral()`方法：

```
repositories {
    mavenCentral()
}
```

### 本地依赖缓存

Gradle会自动下载你所需要的依赖，并将它们存储在本地缓存中，后续的构建将重用这些依赖。

如果远程仓库变动了，Gradle通过比较本地和远程的校验来检测依赖是否发生变化，不仅如此，Gradle还会通过其他措施来校验依赖是否变化，可靠性更强。

### compile、api、implementation

从Android Gradle plugin 3.0开始，对于依赖包的配置方式，引入了implementation和api，使用Android Studio新建项目时，原来用compile的地方全部默认被替换成了implementation.

- **implementation: 依赖包中依赖的library只能在依赖包内部使用，主工程无法访问依赖包依赖的library中的类和方法。**
- api(原compile): 会将依赖包中依赖的其它library一同编译和打包到apk中，宿主工程可以使用依赖包中依赖的其它library的类和方法

compile已经被废弃，应该使用上述两种替换。

其他可选：

- compileOnly：

[详见官方文档](https://docs.gradle.org/current/userguide/java_library_plugin.html)

### 依赖报告

- 对于没有模块的：

  ```
  gradle dependencies
  ```

- 有模块的（app为你的模块名）

  ```
  gradle app:dependencies
  ```

  参数：

  - `--configuration`

    可选参数

  例如：查看upm模块，compile的

  ```
  $ gradle :upms:dependencies --configuration compile
  > Task :upms:dependencies
  
  ------------------------------------------------------------
  Project :upms
  ------------------------------------------------------------
  
  compile - Dependencies for source set 'main' (deprecated, use 'implementation' instead).
  +--- org.mybatis.spring.boot:mybatis-spring-boot-starter:2.1.0
  |    +--- org.springframework.boot:spring-boot-starter:2.1.6.RELEASE (*)
  |    +--- org.springframework.boot:spring-boot-starter-jdbc:2.1.6.RELEASE (*)
  |    +--- org.mybatis.spring.boot:mybatis-spring-boot-autoconfigure:2.1.0
  |    |    \--- org.springframework.boot:spring-boot-autoconfigure:2.1.6.RELEASE (*)
  |    +--- org.mybatis:mybatis:3.5.2
  |    \--- org.mybatis:mybatis-spring:2.0.2
  +--- org.mybatis.generator:mybatis-generator-core:1.3.3 -> 1.3.7
  \--- org.mybatis.generator:mybatis-generator-maven-plugin:1.3.7
       +--- org.apache.maven:maven-plugin-api:3.5.4
       |    +--- org.apache.maven:maven-model:3.5.4
       |    |    +--- org.codehaus.plexus:plexus-utils:3.1.0
       |    |    \--- org.apache.commons:commons-lang3:3.5
       |    +--- org.apache.maven:maven-artifact:3.5.4
       |    |    +--- org.codehaus.plexus:plexus-utils:3.1.0
       |    |    \--- org.apache.commons:commons-lang3:3.5
       |    +--- org.eclipse.sisu:org.eclipse.sisu.plexus:0.3.3
       |    |    +--- javax.enterprise:cdi-api:1.0
       |    |    |    +--- javax.annotation:jsr250-api:1.0
       |    |    |    \--- javax.inject:javax.inject:1
       |    |    +--- org.eclipse.sisu:org.eclipse.sisu.inject:0.3.3
       |    |    +--- org.codehaus.plexus:plexus-component-annotations:1.5.5
       |    |    +--- org.codehaus.plexus:plexus-classworlds:2.5.2
       |    |    \--- org.codehaus.plexus:plexus-utils:3.0.17 -> 3.1.0
       |    +--- org.codehaus.plexus:plexus-utils:3.1.0
       |    \--- org.codehaus.plexus:plexus-classworlds:2.5.2
       \--- org.mybatis.generator:mybatis-generator-core:1.3.7
  
  (*) - dependencies omitted (listed previously)
  
  A web-based, searchable dependency report is available by adding the --scan option.
  
  BUILD SUCCESSFUL in 0s
  1 actionable task: 1 executed
  ```

注意：

- `(c)`

  dependency constraint 依赖约束

- `(*)`

  此依赖被排除了，依赖管理器选择了相同的或者另一个版本的类库

- 针对版本冲突Gradle的策略是获取最新的版本

#### dependencyInsight

Gradle还提供了不同类型的报告：

dependencyInsight（观察报告），它解释了依赖是如何被选择的，以及为什么。

参数：

- `--dependency <dependency>`

  依赖名称，必选参数，可以是完整的格式，`group:name`，或者是他的一部分，如果匹配到了多个依赖，都会进行展示。

- `--configuration <name>`

  配置名称，默认是compile

例如：

```
$ gradle :upms:dependencyInsight --dependency javax.inject:javax.inject   --configuration compile

> Task :upms:dependencyInsight
javax.inject:javax.inject:1
   variant "runtime" [
      org.gradle.status = release (not requested)
   ]

javax.inject:javax.inject:1
\--- javax.enterprise:cdi-api:1.0
     \--- org.eclipse.sisu:org.eclipse.sisu.plexus:0.3.3
          \--- org.apache.maven:maven-plugin-api:3.5.4
               \--- org.mybatis.generator:mybatis-generator-maven-plugin:1.3.7
                    \--- compile

A web-based, searchable dependency report is available by adding the --scan option.

BUILD SUCCESSFUL in 0s
1 actionable task: 1 executed
```

注意：

- dependencyInsight报告展示的依赖树是从特定依赖到配置的

### 强制指定依赖版本

```
configurations.cargo.reso1utionStrategy {
    force 'org.codehaus.cargo:cargo-ant:l.3.0'
}
```

### 排除依赖

```
implementation("io.springfox:springfox-swagger2:2.9.2") {
    exclude group: "org.slf4j", module: "slf4j-api"
}
```

注意：

- version属性是不可用的

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

### 构建子项目

在多项目构建中，你可以从根目录为某个子项目执行task。你只需要确定连接项目路径和task名称既可（路径用`:`表示。

例如，为子项目model执行`build task`

```
$ gradle :modle:build
```

### 构建多模块

#### 声明项目依赖

```
//modle子项目不需要任何外部依赖
project(':modle'){
    ...
}

project(':repository'){
    ....
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

  



gradle如何配置使用阿里云数据源

对所有项目生效，在在`${USER_HOME}/.gradle/`下创建`init.gradle`文件

```
allprojects{
    repositories {
        def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/public/'
        def ALIYUN_JCENTER_URL = 'https://maven.aliyun.com/repository/jcenter/'
        def ALIYUN_GOOGLE_URL = 'https://maven.aliyun.com/repository/google/'
        def ALIYUN_GRADLE_PLUGIN_URL = 'https://maven.aliyun.com/repository/gradle-plugin/'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                    remove repo
                }
                if (url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
                    remove repo
                }
                if (url.startsWith('https://dl.google.com/dl/android/maven2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_GOOGLE_URL."
                    remove repo
                }
                if (url.startsWith('https://plugins.gradle.org/m2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_GRADLE_PLUGIN_URL."
                    remove repo
                }
            }
        }
        maven { url ALIYUN_REPOSITORY_URL }
        maven { url ALIYUN_JCENTER_URL }
        maven { url ALIYUN_GOOGLE_URL }
        maven { url ALIYUN_GRADLE_PLUGIN_URL }
    }
    
    buildscript{
        def ALIYUN_REPOSITORY_URL = 'https://maven.aliyun.com/repository/public/'
        def ALIYUN_JCENTER_URL = 'https://maven.aliyun.com/repository/jcenter/'
        def ALIYUN_GOOGLE_URL = 'https://maven.aliyun.com/repository/google/'
        def ALIYUN_GRADLE_PLUGIN_URL = 'https://maven.aliyun.com/repository/gradle-plugin/'
        all { ArtifactRepository repo ->
            if(repo instanceof MavenArtifactRepository){
                def url = repo.url.toString()
                if (url.startsWith('https://repo1.maven.org/maven2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_REPOSITORY_URL."
                    remove repo
                }
                if (url.startsWith('https://jcenter.bintray.com/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_JCENTER_URL."
                    remove repo
                }
                if (url.startsWith('https://dl.google.com/dl/android/maven2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_GOOGLE_URL."
                    remove repo
                }
                if (url.startsWith('https://plugins.gradle.org/m2/')) {
                    project.logger.lifecycle "Repository ${repo.url} replaced by $ALIYUN_GRADLE_PLUGIN_URL."
                    remove repo
                }
            }
        }
        maven { url ALIYUN_REPOSITORY_URL }
        maven { url ALIYUN_JCENTER_URL }
        maven { url ALIYUN_GOOGLE_URL }
        maven { url ALIYUN_GRADLE_PLUGIN_URL }
    }
}

```

## 配置包装器

1. 定义一个类型为Wrapper的任务，并指定gradle的版本

   ```
   task wrapper(type: Wrapper){
       gradleVersion = '1.7'
   }
   ```

2. 执行包装器任务生成包装器文件

   ```
   $ gradle wrapper 
   ```

3. 生成包装器

   ```
   ├── build.gradle
   ├── gradle
   │   └── wrapper
   │       ├── gradle-wrapper.jar
   │       └── gradle-wrapper.properties
   ├── gradlew
   └── gradlew.bat
   ```

4. 验证

   ```
   $ ./gradlew --version
   
   ------------------------------------------------------------
   Gradle 1.7
   ------------------------------------------------------------
   
   Build time:   2013-08-06 11:19:56 UTC
   Build number: none
   Revision:     9a7199efaf72c620b33f9767874f0ebced135d83
   
   Groovy:       1.8.6
   Ant:          Apache Ant(TM) version 1.8.4 compiled on May 22 2012
   Ivy:          2.2.0
   JVM:          1.8.0_211 (Oracle Corporation 25.211-b12)
   OS:           Mac OS X 10.16 x86_64
   ```

注意：

- 下载下来的包装器文件应该提交到版本控制系统中
- 为了记录构建使用过包装器，将wrapper任务保留在项目中也是有用的

## References

1. 《实战Gradle》
2. https://docs.gradle.org/current/userguide/java_library_plugin.html