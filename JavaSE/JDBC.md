# JDBC

JDBC（Java Database Connectivity）是Java定义的访问数据库的一套标准API。

由每个数据库的厂商提供适配JDBC的驱动，这样以来，我们使用Java连接数据库就不需要担心不同的数据库厂商了，编写一套代码，就可以访问不同的数据库了。

JDBC API在以下两个包中：

- `java.sql`
- `javax.sql`

## 连接JDBC

我们以Mysql为例

### 下载JDBC驱动

[点此下载mysql JDBC驱动](https://dev.mysql.com/downloads/connector/j/)（选择Platform independent，即与平台无关的）

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

## JDBC连接池

JDBC连接池有一个标准的接口`javax.sql.DataSource`，注意这个类位于Java标准库中，但仅仅是接口。要使用JDBC连接池，我们必须选择一个JDBC连接池的实现。常用的JDBC连接池有：

- 

## Reference

1. https://www.liaoxuefeng.com/wiki/1252599548343744/1255943820274272

