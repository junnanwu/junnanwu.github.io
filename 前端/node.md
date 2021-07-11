# Mybatis

### 相关依赖

```xml
<!--junit-->
<dependency>
    <groupId>junit</groupId>
    <artifactId>junit</artifactId>
    <version>4.12</version>
    <scope>test</scope>
</dependency>

<!--mybatis依赖-->
<dependency>
    <groupId>org.mybatis</groupId>
    <artifactId>mybatis</artifactId>
    <version>3.5.5</version>
</dependency>
<!--mysql数据库驱动-->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>5.1.38</version>
</dependency>
```

### Dao层接口

UserMapper接口

### 完整结构

![image-20200929153835719](img/image-20200929153835719.png)

### 核心配置文件

#### `<properties>`

设置属性键值对，可以读取外部属性文件

还可以读取外部properties文件

```properties
driver=com.mysql.jdbc.Driver
url=jdbc:mysql://localhost:3306/study_mybatis_01_01?useUnicode=true&characterEncoding=utf-8
username=root
password=root
```

```xml
<!--方案二：引入外部配置文件-->
<properties resource="dataSource.properties" >
  	<!--方案一：直接定义属性-->
    <!--属性名和外部属性名一样时，外部属性名起作用-->
    <!--<property name="username" value="root"/>-->
    <!--<property name="password" value="root"/>-->
</properties>
```

#### `<typeAliases>`

给用户自定义的实体类定义别名，在接口映射文件中可以直接使用别名替代类全限定名

- **内置别名**

内置别名可以直接使用，别名不区分大小写

| **别名**       | **映射类型** |
| -------------- | ------------ |
| **_byte**      | byte         |
| **_long**      | long         |
| **_short**     | short        |
| **_int**       | int          |
| **_integer**   | int          |
| **_double**    | double       |
| **_float**     | float        |
| **_boolean**   | boolean      |
|                |              |
| **string**     | String       |
| **byte**       | Byte         |
| **long**       | Long         |
| **short**      | Short        |
| **int**        | Integer      |
| **integer**    | Integer      |
| **double**     | Double       |
| **float**      | Float        |
| **boolean**    | Boolean      |
|                |              |
| **date**       | Date         |
| **decimal**    | BigDecimal   |
| **bigdecimal** | BigDecimal   |
| **object**     | Object       |
| **map**        | Map          |
| **hashmap**    | HashMap      |
| **list**       | List         |
| **arraylist**  | ArrayList    |
| **collection** | Collection   |
| **iterator**   | Iterator     |

方案一：

```xml
<typeAliases>
  <!--
        typeAlias :
        1. type：指定实体类全名
        2. alias: 指定别名，如果省略这个属性，默认使用类名字做为别名，别名不区分大小写。
        -->
  <typeAlias type="com.itheima.entity.User" alias="User"/>
</typeAliases>
```

**方式二（推荐方案）**

包扫描配置别名package

```xml
<typeAliases>
  <!--
        package指定包名
        1. 自动将这个包下所有的实体类定义别名，别名就是类的名字。
        2. 可以使用多个package标签，指定不同的包名
        -->
  <package name="com.itheima.entity"/>
</typeAliases>
```

#### `<environments>`

MyBatis可以配置多种环境，有助于将SQL映射应用于多个数据库之中，如dev(开发环境)、test(测试环境)、prd(生成环境)。

**transactionManager事务管理器**

| 类型    | 作用                                                         |
| ------- | ------------------------------------------------------------ |
| JDBC    | 由JDBC进行事务的管理                                         |
| MANAGED | 事务由容器来管理，后期学习Spring框架的时候，所有的事务由容器管理 |

**dataSource数据源**

| 类型     | 作用                                                         |
| -------- | ------------------------------------------------------------ |
| UNPOOLED | 不使用连接池，每次自己创建连接                               |
| POOLED   | 使用mybatis创建的连接池                                      |
| JNDI     | 由应用服务器提供连接池的资源，我们通过JNDI指定的名字去访问连接池资源 |

![image-20200929180910144](img/image-20200929180910144.png)

#### `<mappers>`

**作用**

加载外部的映射文件

**应用**

1. 使用相对于类路径的资源引用

   ```xml
   <mappers>
       <!--加载映射文件-->
       <mapper resource="UserMapper.xml"/>
   </mappers>
   ```

2. 使用完全限定资源定位符（URL）

   ```xml
   <mappers>
       <!--加载映射文件-->
       <mapper url="file:///C:/idea_project/ssm/study_mybatis_01_01/src/main/resources/UserMapper.xml"/>
   </mappers>
   ```

3. 使用映射器接口的完全限定类名

   - **要求：接口和映射文件处于同一包下，且名称相同(忽略后缀)**

   ```xml
   <mappers>
       <!--加载映射文件-->
       <mapper class="com.itheima.dao.UserMapper"/>
   </mappers>
   ```

4. 将包内的映射器接口实现全部注册为映射器

   - **要求：接口和映射文件处于同一包下，且名称相同(忽略后缀)**

   ```xml
   <mappers>
       <!--加载映射文件-->
       <package name="com.itheima.dao" />
   </mappers>
   ```

**注意**

- 默认情况下，maven只会将src/main/resources目录下的配置文件进行打包
- 如果我们会将一些配置放在src/main/java目录下，默认情况下不会被打包
- 因此我们需要重新指定需要打包的配置文件

```xml
<build>
    <!--重新指定资源文件-->
    <resources>
        <!--指定src/main/java下的xml文件和properties文件作为资源文件-->
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.properties</include>
            </includes>
        </resource>
        <!--指定src/main/resources下的xml文件和properties文件作为资源文件-->
        <resource>
            <directory>src/main/resources</directory>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.properties</include>
            </includes>
        </resource>
    </resources>
</build>
```

### 日志

如果我们希望项目中使用log4j，可以通过下面的步骤实现：

1. pom.xml引入log4j的坐标

   ```xml
       <dependency>
           <groupId>log4j</groupId>
           <artifactId>log4j</artifactId>
           <version>1.2.17</version>
       </dependency>
   ```

2. mybatis-config.xml加入日志设置(必须在其他配置上面)

   ```xml
        <!-- 指定使用log4j输出日志-->
       <settings>
           <setting name="logImpl" value="LOG4J"/>
       </settings>
   ```

3. 在src/main/resoures目录下创建`log4j.properties`文件，内容如下：

   ```properties
   log4j.rootLogger=DEBUG, stdout
   log4j.appender.stdout=org.apache.log4j.ConsoleAppender
   log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
   log4j.appender.stdout.layout.ConversionPattern=%5p [%t] - %m%n
   ```



### 接口映射文件

#### 列名与entity属性名不一致

##### `<resultMap>`标签

当sql查询回来的列名与entity的属性不一致的时候，可以使用`<resultMap>`标签处理

定义`<resultMap>`标签

```xml
<!--id为此映射的名字，type为所映射的实体类-->
<resultMap id="UserResultMap" type="User">
  <!--property与column相同的就不再写了-->
  <!--id为主键字段映射，result为非主键字段映射-->
  <id property="id" column="id"/>
  <result property="userName" column="user_name"/>
  <result property="homeAddress" column="home_address"/>
</resultMap>
```

```xml
<select id="selectAll" resultMap="UserResultMap">
    select *from t_user
</select>
```

#### 获取主键自增值

##### `<selectKey>`标签

```xml
<insert id="insert01" parameterType="User">
    <selectKey resultType="int" keyProperty="id" order="AFTER">
        select LAST_INSERT_ID()
    </selectKey>
    insert into t_user(id,user_name,birthday, sex,home_address)
    values (null,#{userName},#{birthday},#{sex},#{homeAddress})
</insert>
```

- `keyColumn`主键的列名,一般无需指定
- `resultType`主键数据类型
-  `keyProperty `主键对应的类对象的属性名
- `order`获取主键的时机，AFTER（记录插入后再获取主键值），BEFORE（记录插入前获取主键值，使用较少，了解即可）
-  `LAST_INSERT_ID()`是sql的一个函数返，表示`AUTO_INCREMENT`由于最近执行的`INSERT`语句而成功为列添加的第一个自动生成的值。`LAST_INSERT_ID()`如果没有成功插入行，则值保持不变

##### insert标签的`useGeneratedKeys`和`keyProperty`属性

```xml
<insert id="insert02" useGeneratedKeys="true" keyProperty="id" >
  INSERT INTO t_user(id,user_name,birthday, sex,home_address)
  VALUES (null, #{userName}, #{birthday}, #{sex}, #{homeAddress})
</insert>
```

| 属性             | 说明                                                         |
| :--------------- | ------------------------------------------------------------ |
| useGeneratedKeys | true 使用数据库自动生成的主键                                |
| keyColumn        | 表中主键的列名，一般无需指定，只有在某些数据库（如PostgreSQL）中主键不是表中的第一列时才需要使用此属性 |
| keyProperty      | 实体类中主键的属性名                                         |

#### 使用ognl 表达式获取参数，$与#的区别

查询t_user表中前n条数据（根据id升序排序）并打印，n是一个方法参数

接口中的方法

```java
List<User> selectTopN(@Param("n") String n);
```

映射文件

```xml
<select id="selectTopN" resultMap="userResultMap">
 	 select * from t_user order by id asc limit ${n}
</select>
```

`${n}`的含义是字符串拼接，所以传入的是字符串也不会出错

但是当使用`#{n}`的时候

占位符对应的是`String n = '3'`

语句就变成了`select * from t_user order by id asc limit '3'`,就会报错

所以，这种情况，当传入的参数是String类型的时候，但是目标接受的是数字，就会出现这种问题

要么使用`${}`进行拼接，要么提前传入int类型

注意：

1. 使用${}会有SQL注入的风险，所以生产中尽量使用`#{}`
2. 需要的是数字但是如果传入**字符串**类型参数,则只能使用`${}`,

#### 动态SQL

##### `<if><where>`

**`<if>`标签**

判断条件是否为真，如果为真则将if中字符串拼接到SQL语句中

 **`<where>`标签**

1.  where标签就相当于SQL语句中where关键字
2. 去掉多余的and、or关键字

```xml
<select id="selectByNameAndSex" resultMap="userResultMap">
  select *from  t_user
  <where>
    <if test="userName!=null and userName != ''">
      user_name=#{userName}
    </if>
    <if test="sex!=null and sex!=''">
      and  sex=#{sex}
    </if>
  </where>
</select>
```

##### `<if><set>`

`<set>`标签

1. 一般与if标签配合使用
2. set用在update语句中，相当于set关键字
3. 会自动去掉能多余的逗号

```xml
<update id="updateByIdSelective">
  update t_user
  <set>
    <if test="userName!=null">
      user_name = #{userName},
    </if>
    <if test="birthday!=null">
      birthday = #{birthday},
    </if>
    <if test="sex!=null">
      sex = #{sex},
    </if>
    <if test="homeAddress!=null">
      home_address = #{homeAddress},
    </if>
  </set>
  where id=#{id}
</update>
```

##### `<foreach>`

需求：批量向表中插入数据

```xml
<insert id="insertRecords">
  insert into t_user values
  <!--
            foreach 遍历操作
                collection 参数名，要求必须是Iterable对象或数组或Map
                item       表示遍历过程中每个元素的变量
                separator  遍历完每个元素后添加的分割符
        -->
  <foreach collection="users" item="user"  separator=",">
    (#{user.id}, #{user.userName}, #{user.birthday}, #{user.sex}, #{user.homeAddress})
  </foreach>
</insert>
<delete id="deleteByIdS">
  delete from t_user where id in
  <!--
           open     遍历开始前添加的符号
           close    遍历完成后添加的符号
        -->
  <foreach collection="ids" item="id" separator="," open="(" close=")">
    #{id}
  </foreach>
</delete>
```

| foreach标签的属性 | 作用                                      |
| ----------------- | ----------------------------------------- |
| collection        | 参数名，要求必须是Iterable对象或数组或Map |
| index（了解即可） | 元素下标                                  |
| item              | 表示遍历过程中每个元素的变量              |
| separator         | 每次遍历后添加分隔符                      |
| open              | 遍历前添加什么符号                        |
| close             | 遍历后添加什么符号                        |

##### `<sql>/<include>`

定义可重用的代码块并使用

```xml
<!--定义可重用的代码块-->
<sql id="conditionSql">
  <if test="condition!=null and condition!=''">
    where user_name like concat('%',#{condition},'%')
    or home_address like concat('%',#{condition},'%')
  </if>
</sql>
<!--根据条件查询-->
<select id="selectByConditon" resultMap="userResultMap">
  select * from t_user
  <!--引用代码块-->
  <include refid="conditionSql"/>
</select>
<!--根据条件统计-->
<select id="countByConditon" resultType="int">
  select count(1) from t_user
  <!--引用代码块-->
  <include refid="conditionSql"/>
</select>
```

#### 复杂映射



#### 级联案例查询

```xml
<!--用户详细信映射-->
<resultMap id="userDetailResultMap" type="User">
  <id property="id" column="id"/>
  <result property="username" column="username"/>
  <result property="birthday" column="birthday"/>
  <result property="sex" column="sex"/>
  <result property="address" column="address"/>
  <!--
        association和collection都可以通过column属性和select属性配合完成级联查询操作
            select  子查询，一个select标签的id
            column  指定参数传递，格式为'参数名=传值给子查询字段'
        -->
  <association property="userInfo" column="userId=id" select="selectUserInfoByUserId"/>
  <collection property="orders"   column="userId=id"  select="selectOrderByUserId"/>
</resultMap>
<!--用户拓展信息映射-->
<resultMap id="userInfoResultMap" type="UserInfo">
  <result property="userId" column="user_id"/>
</resultMap>
<!--订单信息映射-->
<resultMap id="orderResultMap" type="Order">
  <result property="userId" column="user_id"/>
  <result property="createTime" column="create_time"/>
</resultMap>

<!--查询用户信息-->
<select id="selectAllUserAndInfoAndOrder" resultMap="userDetailResultMap">
  select * from t_user
</select>
<!--查询用户拓展信-->
<select id="selectUserInfoByUserId" resultMap="userInfoResultMap">
  select * from t_user_info where user_id=#{userId}
</select>
<!--查询订单信-->
<select id="selectOrderByUserId" resultMap="orderResultMap">
  select * from t_order where user_id=#{userId}
</select>
```

#### 自动映射

在简单的场景（resultType）下，MyBatis 可以为你自动映射查询结果。但如果遇到复杂的场景，你需要构建一个结果映射（ResultMap）。 但是在本节中，你将看到，你可以混合使用这两种策略。让我们深入了解一下自动映射是怎样工作的。

当自动映射查询结果时，MyBatis 会获取结果（sql查询结果集）中返回的列名并在 Java 类中查找相同名字的属性（忽略大小写）。 这意味着如果发现了 *ID* 列和 *id* 属性，MyBatis 会将列 *ID* 的值赋给 *id* 属性。

通常数据库列使用大写字母组成的单词命名，单词间用下划线分隔；而 Java 属性一般遵循驼峰命名法约定。为了在这两种命名方式之间启用自动映射，需要在`mybatis-config`文件中将 `mapUnderscoreToCamelCase` 设置为 true。

```xml
<settings>
    <setting name="logImpl" value="LOG4J"/>
    <setting name="mapUnderscoreToCamelCase" value="true"/>
</settings>
```

有三种自动映射等级：

- `NONE` - 禁用自动映射。仅对手动映射的属性进行映射。

- **`PARTIAL` - 默认级别，只有处理复杂映射(一对一映射，一对多映射)时不会进行自动映射。**

  **注意：级联查询不是复杂映射**

- `FULL` - 自动映射所有属性。

所以，在前面章节的**复杂映射案例中，我们必须显式指定所有字段的映射**

### 注解开发

```java
  /**
     * 通过id查询用户基础信息
     */
    @Select(value="select * from t_user where id = #{id}")
    User selectById(@Param("id") Integer id);

    /**
     * 更新用户信息基础信息
     * @param user
     * @return
     */
    @Update(value=" update t_user set username=#{username}, birthday=#{birthday}, sex=#{sex}, address=#{address} where id=#{id}")
    int update(User user);
    /**
     * 更新用户信息基础信息
     * @param id
     * @return
     */
    @Delete(value=" delete from  t_user where id=#{id}")
    int deleteById(@Param("id") Integer id);

    /**
     * 插入
     * @param user
     * @return
     */
    @Insert("insert into t_user(username,birthday,sex,address) values (#{username},#{birthday},#{sex},#{address})")
    @SelectKey(resultType = Integer.class,keyProperty ="id",before = false,statement = "select LAST_INSERT_ID()")
    int insert(User user);
```

| 属性        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| statement   | 获取主键的SQL语句                                            |
| keyProperty | 实体类中主键的属性名                                         |
| resultType  | 主键数据类型                                                 |
| before      | 是否在新增记录之前返回主键值<br />false：之后 <br />true：之前 |

### 测试Test

```java
package com.itheima.dao;

import com.itheima.entity.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.Test;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

public class UserMapperTest {

    @Test
    public void selectAll() throws IOException {
        //1. 获取核心配置文件，得到输入流对象
        InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
        //2. 构造会话工厂建造类
        SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
        //3. 通过建造类得到会话工厂
        SqlSessionFactory factory = builder.build(inputStream);
        //4. 通过会话工厂得到会话对象
        SqlSession session = factory.openSession();
        //5. 通过会话对象得到UserMapper接口的代理对象
        UserMapper userMapper = session.getMapper(UserMapper.class);
        //6. 执行查询操作
        List<User> users = userMapper.selectAll();
        for (User user : users) {
            System.out.println(user);
        }
        //7. 关闭会话
        session.close();
    }
}
```

### 封装MyBatisUtils

```java
/**
 * mybatis工具类
 * 使用步骤：
 *  1-获取mapper
 *  2-执行CRUD操作(可能是1次，也可能多次)
 *  3-提交事务
 *  4-关闭session
 */
public class MyBatisUtils {
    private static SqlSessionFactory factory;
    private  static final ThreadLocal<SqlSession> session = new ThreadLocal<>();

    // 读取核心配置文件，初始化SqlSessionFactory,只执行一次
    static {
        //1. 得到输入流对象
        try( InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");) {
            //2. 构造会话工厂建造类
            SqlSessionFactoryBuilder builder = new SqlSessionFactoryBuilder();
            //3. 通过建造类得到会话工厂
            factory = builder.build(inputStream);
            System.out.println("创建SqlSessionFactory成功");
        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("加载mybatis核心配置文件失败");
        }
    }

    /**
     * 获取Mapper
     * @param clazz     Mapper类
     * @return
     */
    public static <T> T getMapper(Class<T> clazz){
        //4. 通过会话工厂得到会话对象
        if(null == session.get()){
            session.set(factory.openSession());
        }
        //5. 会话对象得到UserMapper接口的代理对象
        return session.get().getMapper(clazz);

    }

    /**
     * 提交并关闭
     */
    public static void commitAndClose(){
        System.out.println("关闭 ……");
        if(null != session.get()){
            session.get().commit();
            session.get().close();
            session.remove();
        }
    }
}
```

```java
package com.zb.smbms.util;
 
import java.io.IOException;
import java.io.Reader;
 
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
 
public class MyBatisUtil {
 
	private static SqlSessionFactory sessionFactory = null;
	/*
	 * 创建本地线程变量，为每一个线程独立管理一个session对象 每一个线程只有且仅有单独且唯一的一个session对象
	 * 加上线程变量对session进行管理，可以保证线程安全，避免多实例同时调用同一个session对象
	 * 每一个线程都会new一个线程变量，从而分配到自己的session对象
	 */
	private static ThreadLocal<SqlSession> threadlocal = new ThreadLocal<SqlSession>();
 
	// 创建sessionFactory对象，因为整个应用程序只需要一个实例对象，故用静态代码块
	static {
		try {
			Reader reader = Resources.getResourceAsReader("Mybatis_config.xml");
			sessionFactory = new SqlSessionFactoryBuilder().build(reader);
			reader.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
 
	/**
	 * 返回sessionFactory对象 工厂对象
	 * 
	 * @return sessionFactory
	 */
	public static SqlSessionFactory getSessionFactory() {
		return sessionFactory;
	}
 
	/**
	 * 新建session会话，并把session放在线程变量中
	 */
	private static void newSession() {
		// 打开一个session会话
		SqlSession session = sessionFactory.openSession();
		// 将session会话保存在本线程变量中
		threadlocal.set(session);
	}
	
	/**
	 * 返回session对象
	 * @return session
	 */
	public static SqlSession getSession(){
		//优先从线程变量中取session对象
		SqlSession session = threadlocal.get();
		//如果线程变量中的session为null，
		if(session==null){
			//新建session会话，并把session放在线程变量中
			newSession();
			//再次从线程变量中取session对象
			session = threadlocal.get();
		}
		return session;
	}
	
	/**
	 * 关闭session对象，并从线程变量中删除
	 */
	public static void closeSession(){
		//读取出线程变量中session对象
		SqlSession session = threadlocal.get();
		//如果session对象不为空，关闭sessoin对象，并清空线程变量
		if(session!=null){
			session.close();
			threadlocal.set(null);
		}
	}
	
}
```



## 测试, 怎么使用

```java
package cn.itcast.dao;

import cn.itcast.entity.User;
import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.io.InputStream;
import java.util.List;

public class UserMapperTest {
    SqlSession session;
    UserMapper mapper;
    @Before
    public void setUp() throws Exception {
        InputStream inputStream = Resources.getResourceAsStream("mybatis-config.xml");
        SqlSessionFactoryBuilder factory = new SqlSessionFactoryBuilder();
        SqlSessionFactory build = factory.build(inputStream);
        session = build.openSession();
        mapper = session.getMapper(UserMapper.class);
    }

    @After
    public void tearDown() {
        session.commit();
        session.close();
    }

    @Test
    public void selectAll() {
        List<User> users = mapper.selectAll();
        for (User user : users) {
            System.out.println(user);
        }
    }
}
```



# Spring

## Spring入门案例

### 使用Spring容器来创建对象

1. 导入坐标依赖

   ```xml
   <groupId>com.ithiema</groupId>
   <artifactId>study_spring_01_01</artifactId>
   <version>1.0-SNAPSHOT</version>
   
   <dependencies>
       <!--spring 的ioc容器jar包-->
       <dependency>
           <groupId>org.springframework</groupId>
           <artifactId>spring-context</artifactId>
           <version>5.0.5.RELEASE</version>
       </dependency>
       <!--单元测试-->
       <dependency>
           <groupId>junit</groupId>
           <artifactId>junit</artifactId>
           <version>4.12</version>
       </dependency>
   </dependencies>
   ```

2. 创建Account实体类

   ```java
   public class Account {
       private Integer id;
       private String name;//用户名称
       private Double money;//账户金额
   	//getter、setter、无参构造、有参构造、toString...省略
   }
   ```

3. 创建spring01.xml配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
       <!--
       bean标签的作用：创建对象
       id属性：设置对象在容器中的唯一标识
       class属性：设置对象的全限定名称，用于反射创建对象
       -->
       <bean id="account" class="com.itheima.entity.Account">
           <!--
           property标签作用：为创建的对象赋值，前提条件对象中必须有该变量setter方法
           name属性：设置成员变量的名称(这个其实是setter的方法名字)
           value属性：设置成员变量赋的值
   				ref：赋值的内容是对象
           -->
           <property name="id" value="1"/>
           <property name="name" value="特朗普"/>
           <property name="money" value="50000000"/>
       </bean>
   </beans>
   
   		<!--
   		bean标签里面还有如下属性
       scope:  设置bean的作用域
           - singleton:  默认值，单例，全局唯一，只会实例化一次
           - prototype:  多例，每次getBean都会实例化一个新的对象
       -->
   ```

4. 测试

   ```java
   public class SpringTest {
       @Test
       public void test01(){
           //通过配置文件来初始化Spring的核心容器
           ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring01.xml");
           //从容器中获取Account对象
           Account account = (Account) applicationContext.getBean("account");
           System.out.println(account);
       }
   }
   ```

## IOC

**解耦的关键是IOC**

- 在上面的优化方案中，成功做到了AccountController和AccountServiceImpl的解耦，而解耦的关键是：**将Controller对servcie实现类的控制权（实例化）交给测试类来完成**。

- 这种优化方案其实就是**控制反转（IOC，inverse of control ）**的思想。

  控制即控制权

  控制反转==对象控制权交给其他子系统或类

**Spring是一个IOC容器**

​	Spring控制反转==对象控制权交给Spring的对象容器

### 使用Spring的IOC容器解偶

1. 创建spring02.xml配置文件

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <beans xmlns="http://www.springframework.org/schema/beans"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
   
       <!--
       配置accountController对象，放入Spring的容器
       -->
       <bean id="a" class="com.itheima.controller.AccountController">
           <!--
   		为成员变量accountService赋值
   			ref:	赋值的内容是对象
   			value：	赋值的内容是基础数据类型
   		-->
           <property name="accountService" ref="accountService"/>
       </bean>
       <!--
       配置accountService对象，放入Spring的容器
       -->
       <bean id="accountService" class="com.itheima.service.AccountServiceImpl"/>
    
   </beans>
   ```

2. 测试

   ```java
   @Test
   public void test02(){
       //初始化Spring的容器对象
       ApplicationContext applicationContext = new ClassPathXmlApplicationContext("spring02.xml");
       //从容器中取出对象AccountController
       // *****可以根据beanName获取，也可以根据Class获取
       // AccountController accountController = (AccountController)applicationContext.getBean("accountController");
       // AccountController accountController = applicationContext.getBean("accountController",AccountController.class);
       AccountController accountController = applicationContext.getBean(AccountController.class);
       //执行对象中的新增账户方法
       accountController.save(new Account(1,"安倍晋三",50000.0));
   }
   ```

## 依赖注入(DI)

即给里面的属性赋值

1. setter注入（**property标签**）
   - 调用setter方法注入数据

2. 构造注入（**constructor-arg标签**）
   - 实例化时通过构造函数注入数据

## 注解开发

### 多配置文件

```java
<!--
	resource：加载的配置文件名
		也可以使用表达式,'spring-*'表示匹配所有以'spring-'开头的配置文件
-->
<import resource="spring.xml"/>
<import resource="spring-*.xml"/>
```

### 读取properties文件

1. 加载指定的properties文件

   ```xml
   <context:property-placeholder location="classpath:filename.properties">
   ```

2. 使用加载的数据

   ```xml
   <property name="propertyName" value="${propertiesName}"/>
   ```

   注意：如果需要加载所有的properties文件，可以使用*.properties表示加载所有的properties文件

### 疑问：classpath是什么意思？

```xml
<context:property-placeholder location="classpath:filename.properties">
```

初步解答：classpath代表生成classes文件后的目录

### 启用注解功能

```java
<context:component-scan base-package="packageName"/>
```

- 在进行包所扫描时，会对配置的包及其子包中所有java文件进行扫描

- 扫描结束后会将可识别的有效注解转化为spring对应的资源加入IoC容器

### Bean的定义(@Component)

@Component @Controller @Service @Repository

设置该类为spring管理的bean

```
@Component
public class ClassName{}
```







SpringMVC的处理流程

首先我们接收到前端的一个url请求，我们的前端控制器会直接拦截，例如dispatcherServlet，因为我们配置了url-parrten，接下来前端控制器就会将这个url请求的资源发给处理器适配器，处理器适配器通过寻找比如我们的控制器，就是有@Controller，然后寻找@ResultMapping，然后会将handle和一些其他handle拦截器对象返回给前端控制器，前端控制器再去请求处理器适配器，处理器适配器去让我们写的处理器执行，然后接收到它返回的数据，例如ModelAndView，并将这个再返回给前端控制器，前端控制器去把这些数据给视图解析器，视图解析器会将这些数据进行解析，并返回前端控制器，前端控制器再将解析后的View数据发送给jsp等View模型，jsp进行渲染之后就将jsp返回到前端控制器，最后前端控制器响应用户



AOP

AOP是面向切面编程

使用动态代理的技术，不修改代码就可以对已有的方法进行拦截，增强方法

例如参数校验，事务控制，打印日志，异常处理

动态代理就是通过Proxy.newProxyInstance自动的生成一个代理类，里面需要传入一个InvocationHandler实现类，实现类需要实现一个invoke()方法，我们在这个方法里面定义增强内容。但是Spring中我们获取的Bean是已经代理好的对象，它需要我们定义一个切面Aspect来实现类似上述invoke()方法体内容，切面对象=切点Pointcut+增强，其中切点是一个表达式来指定需要增强的方法集，注解通过@Pointcut(表达式)来实现切点，XML通过<aop:pointcut 表达式/>来实现切点；增强就是一系列方法及何时执行，注解通过在相关方法上面加@Before，而XML通过<aop:before 切点 方法/>分别将方法与各种形式的增强绑定。这样当我们调用切点中的方法的时候，就会以我们绑定的方式对该方法进行增强







Spring的两种动态代理

jdk的动态代理和Cglib的动态代理

java动态代理是利用反射机制生成一个实现代理接口的匿名类，在调用具体方法前调用InvokeHandler来处理

cglib动态代理是利用asm开源包，对代理对象类的class文件加载进来，通过修改其字节码生成子类来处理

 （1）JDK动态代理只能对实现了接口的类生成代理，而不能针对类
 （2）CGLIB是针对类实现代理，主要是对指定的类生成一个子类，覆盖其中的方法

 因为是继承，所以该类或方法最好不要声明成final 



Spring用了哪些注解

首先在实例化的时候，@Component @Controller @Service @Repository

然后注入的时候  @Autowired @Value

还有@Scope

AOP 先定义切面类@Aspect，然后切点方法@Pointcut，然后是增强注解@Before



Spring如何进行事务控制

首先需要实例化一个事务控制器，指定数据源

在Spring中开启事务支持

然后在相关的一般都用在service层中，在相关方法前加上@Transactional即可

模式的隔离级别是 REPEATABLE_READ 可重复读



还有一个事务传播

我们的方法内部调用了其他的方法，两个事务发生了冲突，就需要我们进行指定

这个不太了解



Mybatis常用标签

核心配置文件中有

environments，用来配置数据源

mapper，用来加载映射文件，可以使用\<package>来指定包

typeAliases，给Java类型指定别名

properties，用来引入外部的文件



动态SQL

```
<if/where>
where中的某个属性为null或者空字符串，那么就不作为查询条件
<if/set>
要想修改一个user的语句，当某个属性为null的时候，我们就能自动去掉多余的 ,
<for/each>
我们就可以自动插入一个list
```



#{} ${}的区别



级联查询

```
association和collection都可以实现级联查询
<association property="userInfo" column="userId=id" select="selectUserInfoByUserId"/>
<collection property="orders"   column="userId=id"  select="selectOrderByUserId"/>
```





还有一个映射文件

insert delete update select











