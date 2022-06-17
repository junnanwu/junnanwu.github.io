# JDBC

JDBC（Java Database Connectivity）是Java定义的访问数据库的一套标准API。

由每个数据库的厂商提供适配JDBC的驱动，这样以来，我们使用Java连接数据库就不需要担心不同的数据库厂商了，编写一套代码，就可以访问不同的数据库了。

JDBC API在以下两个包中：

- `java.sql`
- `javax.sql`

## Mysql JDBC

### 下载JDBC驱动

- Jar包

  [点此下载mysql JDBC驱动](https://dev.mysql.com/downloads/connector/j/)（选择Platform independent，即与平台无关的）

- maven依赖

  ```
  <!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
  <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.26</version>
  </dependency>
  ```

### 建立Connection连接

#### connection URL

URL是由数据库厂商指定的格式，[详见此](https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-reference-url-format.html)，例如，MySQL的URL是：

```
protocol//[hosts][/database][?properties]
```

一般格式：

```
jdbc:mysql://<hostname>:<port>/<db>?key1=value1&key2=value2
```

#### properties

[详见此](https://dev.mysql.com/doc/connector-j/5.1/en/connector-j-connp-props-security.html)

- `allowMultiQueries`

  一个statement中允许使用`;`分隔多个查询，默认是`false`，不影响Batch

- `useSSL`

  > Use SSL when communicating with the server (true/false), default is `true` when connecting to MySQL 5.5.45+, 5.6.26+, or 5.7.6+, otherwise default is `false`

- `useUnicode`

  > Should the driver use Unicode character encodings when handling strings? Should only be used when the driver can't determine the character set mapping, or you are trying to 'force' the driver to use a character set that MySQL either doesn't natively support (such as UTF-8), true/false, defaults to `true`

- `characterEncoding`

  > If `useUnicode` is set to true, what character encoding should the driver use when dealing with strings? (defaults is to `autodetect`)

  注意MySQL的UTF-8是`utf8`，即`characterEncoding=utf8`

- `serverTimezone`

  > Override detection/mapping of time zone. Used when time zone from server doesn't map to Java time zone

例如：

```
jdbc:mysql://10.240.101.24:3306/data_web?allowMultiQueries=true&characterEncoding=UTF-8&useSSL=false&serverTimezone=Asia/Shanghai
```

### 代码示范

主要流程：

- 通过JDBC Drivers获取连接

  `DriverManager`会自动扫描classpath，找到所有的JDBC驱动，然后根据我们传入的URL自动挑选一个合适的驱动。

- 通过Connections获取Statements

- 通过Statements执行想要执行的语句，并得到ResultSets

- 读取ResultSets，得到最终结果

```java
public class JDBCTest {

    public static void main(String[] args) throws ClassNotFoundException {
        String JDBC_URL = "jdbc:mysql://localhost:3306/data_web";
        String JDBC_USER = "root";
        String JDBC_PASSWORD = "root";
        try (Connection connection = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
            try (Statement statement = connection.createStatement()) {
                try (ResultSet resultSet = statement.executeQuery("SHOW DATABASES")) {
                    System.out.println("通过列名来获取：");
                    //System.out.println("通过index来获取（从1开始）:");
                    while (resultSet.next()) {
                        //System.out.println(resultSet.getString(1));
                        System.out.println(resultSet.getString("Database"));
                    }
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
```

注意：

- 在ResultSet第一个调用`next()`后，得到的才是第一行
- ResultSet获取列的时候，第一列从1开始，而不是0，还可以通过列名直接获取
- JDBC在`java.sql.Types`定义了一组常量来表示如何映射SQL数据类型

## Hive JDBC

### URL

[详见此](https://cwiki.apache.org/confluence/display/hive/HiveServer2+Clients#HiveServer2Clients-ConnectionURLs)

格式：

```
jdbc:hive2://<host1>:<port1>,<host2>:<port2>/dbName;initFile=<file>;sess_var_list?hive_conf_list#hive_var_list
```

- `<file>`

  创建连接后，在SQL语句执行之前，会自动执行的脚本，

  例如：`user=foo;password=bar`

- `sess_var_list`

  session variables，key=value的格式，使用分号分隔

- `hive_conf_list`

  [Hive configuration variables](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)，key=value的格式，使用分号分隔

- `hive_var_list` 

  Hive variables，key=value的格式，使用分号分隔

例如：

- 经常执行语句会超时，增加如下`hive_conf_list`配置：

  ```
  url: jdbc:hive2://82.157.126.218:7001/default;?hive.server2.session.check.interval=60000;hive.server2.idle.operation.timeout=1800000;hive.server2.idle.session.timeout=2400000#
  ```

### Maven依赖

```xml
<dependency>
    <groupId>org.apache.hive</groupId>
    <artifactId>hive-jdbc</artifactId>
    <version>3.1.0</version>
</dependency>
```

注意：

hive JDBC依赖了很多比如hadoop等相关的其他依赖，所以直接下载java jar是不能运行的人，Maven是可以解决依赖传递的，以至于最后打出来的fat jar足足有150M（Mysql jdbc简单连接项目打出来的fat jar只有5M左右...）

也可以点击这里下载[Uber-jar](https://github.com/timveil/hive-jdbc-uber-jar)

### 样例代码

```java
import java.sql.SQLException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.DriverManager;
 
public class HiveJdbcClient {
  private static String driverName = "org.apache.hive.jdbc.HiveDriver";
 
  /**
   * @param args
   * @throws SQLException
   */
  public static void main(String[] args) throws SQLException {
      try {
      Class.forName(driverName);
    } catch (ClassNotFoundException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      System.exit(1);
    }
    //replace "hive" here with the name of the user the queries should run as
    Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
    Statement stmt = con.createStatement();
    String tableName = "testHiveDriverTable";
    stmt.execute("drop table if exists " + tableName);
    stmt.execute("create table " + tableName + " (key int, value string)");
    // show tables
    String sql = "show tables '" + tableName + "'";
    System.out.println("Running: " + sql);
    ResultSet res = stmt.executeQuery(sql);
    if (res.next()) {
      System.out.println(res.getString(1));
    }
       // describe table
    sql = "describe " + tableName;
    System.out.println("Running: " + sql);
    res = stmt.executeQuery(sql);
    while (res.next()) {
      System.out.println(res.getString(1) + "\t" + res.getString(2));
    }
 
    // load data into table
    // NOTE: filepath has to be local to the hive server
    // NOTE: /tmp/a.txt is a ctrl-A separated file with two fields per line
    String filepath = "/tmp/a.txt";
    sql = "load data local inpath '" + filepath + "' into table " + tableName;
    System.out.println("Running: " + sql);
    stmt.execute(sql);
 
    // select * query
    sql = "select * from " + tableName;
    System.out.println("Running: " + sql);
    res = stmt.executeQuery(sql);
    while (res.next()) {
      System.out.println(res.getInt(1) + "\t" + res.getString(2));
    }
 
    // regular hive query
    sql = "select count(1) from " + tableName;
    System.out.println("Running: " + sql);
    res = stmt.executeQuery(sql);
    while (res.next()) {
      System.out.println(res.getString(1));
    }
  }
}
```

## ClickHouse JDBC

### 样例代码

```java
public class JDBCTest {
    public static void main(String[] args) {
        String url = "jdbc:clickhouse://82.157.52.xxx:8123/default";
        String username = "default";
        String password = "xxx";
        ClickHouseDataSource dataSource = new ClickHouseDataSource(url);
        try (Connection conn = dataSource.getConnection(username,password);
             Statement stmt = conn.createStatement();
             ResultSet resultSet = stmt.executeQuery("select today()")) {
            while (resultSet.next()){
                Object object = resultSet.getObject(1);
                System.out.println(object);
            }
        } catch (SQLException exception) {
            exception.printStackTrace();
        }
    }
}
```

注意：

- 最好使用ClickHouse JDBC最新的版本，低版本有很多漏洞，而且经测不支持LocalDate的映射（`0.2.4`版本）

## Presto JDBC

依赖：

```
<dependency>
    <groupId>com.facebook.presto</groupId>
    <artifactId>presto-jdbc</artifactId>
    <version>0.271</version>
</dependency>
```

样例代码：

```
public class Main {

    private static String url = "jdbc:presto://49.233.xx.xx:9000/hive/hsz_sap?user=xxx";

    public static void main(String[] args) throws SQLException {
        Connection connection = DriverManager.getConnection(url);
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery("show tables from hive.hsz_sap");
        while (resultSet.next()){
            System.out.println(resultSet.getString(1));
        }
    }
}
```



## JDBC连接池

JDBC连接池有一个标准的接口`javax.sql.DataSource`，注意这个类位于Java标准库中，但仅仅是接口。要使用JDBC连接池，我们必须选择一个JDBC连接池的实现。常用的JDBC连接池有：

- 

## References

1. https://www.liaoxuefeng.com/wiki/1252599548343744/1255943820274272
1. https://prestodb.io/docs/current/installation/jdbc.html

