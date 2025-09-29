# 常用的数据格式

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

从结构上看，所有的数据都能分成三种类型：

- 单独的值

  值又可以是：

  - 数值
  - 字符串（双引号）
  - 逻辑值（`true`/`false`）
  - `null`值

- 数组

- 映射

json的规则非常简单，如下所示：

1. 并列的数据之间用逗号`,`分隔
2. 并列数据的集合（数组）用方括号`[]`表示。
3. 映射用冒号`: `表示
4. 映射的集合（对象）用大括号`{}`表示

注意：

- json的字符串必须在双引号内

## YML

YAML(YAML Ain't Markup Language)

基本语法：

- 大小写敏感
- 使用缩进表示层级关系
- 缩进时不允许使用Tab键，只允许使用空格
- 缩进的空格数目不重要，只要相同层级的左侧元素左侧对齐即可

`#`表示单行注释。

支持数据结构：

- 键值对

  ```
  animal: pets
  ```

- 数组

  ```
  - Cat
  - Dog
  - Goldfish
  ```

  也可以采用行内的表示法：

  ```
  animal: [Cat,Dog]
  ```

- 复合机构

  ```
  languages:
   - Ruby
   - Perl
   - Python 
  ```

各种数据类型的表示：

- 数值

  ```
  number: 12.30
  ```

- 布尔值

  ```
  isSet: true
  ```

- null用`~`表示

  ```
  parent: ~ 
  ```

- 时间采用ISO8601格式

  ```
  iso8601: 2001-12-14t21:59:43.10-05:00 
  ```

- 日期采用ISO8601格式

  ```
  date: 1976-07-31
  ```

- 字符串

  - 默认不使用引号

    ```
    str: 这是一行字符串
    ```

  - 如果字符串之中包含空格或特殊字符，需要放在引号之中（单引号和双引号都可以使用）

    ```
    str: '内容： 字符串'
    ```

    

  

## References

1. https://www.ruanyifeng.com/blog/2009/05/data_types_and_json.html
1. http://www.ruanyifeng.com/blog/2016/07/yaml.html
