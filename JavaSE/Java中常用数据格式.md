# Java中常用的数据格式

## properties

### Java读取properties文件

- 方式一：基于ClassLoder读取配置文件（将`test.properties`放在classpath下）

  ```java
  Properties properties = new Properties();
  InputStream inputStream = PropertiesTest.class.getClassLoader().getResourceAsStream("test.properties");
  try {
      properties.load(inputStream);
  } catch (IOException e) {
      e.printStackTrace();
  }
  System.out.println(properties.getProperty("name"));
  ```

- 方式二：基于`java.util.ResourceBundle`

  ```java
  ResourceBundle bundle = ResourceBundle.getBundle("test");
  System.out.println(bundle.getString("name"));
  ```

  

## JSON

## YML

## References
