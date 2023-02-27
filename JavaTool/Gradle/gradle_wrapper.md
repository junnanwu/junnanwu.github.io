# Gradle Wrapper

## Wrapper的好处

Gradle推荐使用包装器（Wrapper）的方式来执行构建任务，这样的好处是：

- 在开发或部署的时候，不需要提前准备Gradle环境
- Wrapper指定了Gradle的版本，不需要再担心版本兼容问题

## 安装Wrapper

可以通过Gradle内置的wrapper任务来添加Gradle Wrapper，详见[官方文档](https://docs.gradle.org/current/userguide/gradle_wrapper.html)，步骤如下：

1. 执行wrapper任务生成包装器文件（需要系统已安装Gradle）

   ```
   $ gradle wrapper 
   ```

   注意：

   - 默认情况下，会使用和系统Gradle相同的版本
   - Gradle Wrapper默认类型为`bin`，即没有样例代码和文档

   当然还可以指定版本和类型：

   ```
   $ gradle wrapper --gradle-version 7.5 --distribution-type bin|all
   ```

2. 生成包装器

   ```
   ├── gradle
   │   └── wrapper
   │       ├── gradle-wrapper.jar
   │       └── gradle-wrapper.properties
   ├── gradlew
   └── gradlew.bat
   ```

   其中：

   - `gradle/wrapper/gradle-wrapper.properties`中存储了Gradle的版本信息

3. 验证

   ```
   $ ./gradlew --version
   
   ------------------------------------------------------------
   Gradle 7.5
   ------------------------------------------------------------
   
   Build time:   2022-07-14 12:48:15 UTC
   Revision:     c7db7b958189ad2b0c1472b6fe663e6d654a5103
   
   Kotlin:       1.6.21
   Groovy:       3.0.10
   Ant:          Apache Ant(TM) version 1.10.11 compiled on July 10 2021
   JVM:          1.8.0_211 (Oracle Corporation 25.211-b12)
   OS:           Mac OS X 10.16 x86_64
   ```

注意：

- 下载下来的包装器文件应该提交到版本控制系统中（故` .gitignore`不应该忽略所有Jar文件）

- 第一次使用`./gralew`将会在此地址下载此文件：

  ```
  ~/.gradle/wrapper/dists/gradle-7.5-bin
  ```

## References

1. Gradle官方文档：[The Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html)