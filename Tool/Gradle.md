# gradle

**compile、api、implementation的区别**

从Android Gradle plugin 3.0开始，对于依赖包的配置方式，引入了implementation和api，使用Android Studio新建项目时，原来用compile的地方全部默认被替换成了implementation.

- implementation: 依赖包中依赖的library只能在依赖包内部使用，主工程无法访问依赖包依赖的library中的类和方法。
- api(原compile): 会将依赖包中依赖的其它library一同编译和打包到apk中，宿主工程可以使用依赖包中依赖的其它library的类和方法

**gradle依赖树怎么看**

```
\--- org.mybatis.spring.boot:mybatis-spring-boot-starter-test:2.1.3
     +--- org.springframework.boot:spring-boot-starter-test:2.3.0.RELEASE (*)
     \--- org.mybatis.spring.boot:mybatis-spring-boot-test-autoconfigure:2.1.3
          +--- org.springframework.boot:spring-boot-autoconfigure:2.3.0.RELEASE (*)
          +--- org.springframework.boot:spring-boot-test-autoconfigure:2.3.0.RELEASE (*)
          +--- org.springframework.boot:spring-boot-test:2.3.0.RELEASE (*)
          +--- org.springframework:spring-test:5.2.6.RELEASE (*)
          \--- org.springframework:spring-tx:5.2.6.RELEASE (*)
```

- `+`和`\`都表示节点，`\`是最后一个节点的意思
- `(c)` - dependency constraint 依赖约束
- `(*)` - dependencies omitted (listed previously) 意思就是这个依赖上面出现过，这里就不再展开了

**gradle如何配置使用阿里云数据源**

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

