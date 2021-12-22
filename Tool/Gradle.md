# Gradle

### compile、api、implementation的区别

从Android Gradle plugin 3.0开始，对于依赖包的配置方式，引入了implementation和api，使用Android Studio新建项目时，原来用compile的地方全部默认被替换成了implementation.

- implementation: 依赖包中依赖的library只能在依赖包内部使用，主工程无法访问依赖包依赖的library中的类和方法。
- api(原compile): 会将依赖包中依赖的其它library一同编译和打包到apk中，宿主工程可以使用依赖包中依赖的其它library的类和方法

## 查看gradle依赖树

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

- dependencyInsight——查找

  - `--dependency <dependency>`

    必须参数，具体查看哪个依赖，可以是完整的格式，`group:name`，或者是他的一部分，如果匹配到了多个依赖，都会进行展示。

  - `--configuration <name>`

    必选参数

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

备注：

- `(c)`

  dependency constraint 依赖约束

- `(*)`

  dependencies omitted (listed previously) 意思就是这个依赖上面出现过，这里就不再展开了

### gradle如何配置使用阿里云数据源

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

## References
