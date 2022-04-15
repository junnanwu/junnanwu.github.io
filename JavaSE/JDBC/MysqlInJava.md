# Mysql In Java

## Tk-MyBatis

### @Id

最简单的情况下，只需要一个 `@Id` 标记字段为主键即可。数据库中的字段名和实体类的字段名是完全相同的，这中情况下实体和表可以直接映射。

**提醒：如果实体类中没有一个标记 `@Id` 的字段，当你使用带有 `ByPrimaryKey` 的方法时，所有的字段会作为联合主键来使用，也就会出现类似 `where id = ? and countryname = ? and countrycode = ?` 的情况**

正常情况下，**一个实体类中至少需要一个标记 `@Id` 注解的字段，存在联合主键时可以标记多个。**

### @Column

`@Column` 注解支持 `name`, `insertable` 和 `updateable` 三个属性。

`name` 配置映射的列名。

`insertable` 对提供的 `insert` 方法有效，如果设置 `false` 就不会出现在 SQL 中。

`updateable` 对提供的 `update` 方法有效，设置为 `false` 后不会出现在 SQL 中。

配置示例如：

```
@Column(name = "user_name")
private String name;
```

除了直接映射 `name` 到 `user_name` 这种用法外，在使用关键字的情况，还会有下面的用法：

```
@Column(name = "`order`")
private String order;
```

对于关键字这种情况，通用 Mapper 支持自动转换。

### @Transient

一般情况下，实体中的字段和数据库表中的字段是一一对应的，但是也有很多情况我们会在实体中增加一些额外的属性，这种情况下，就需要使用 `@Transient` 注解来告诉通用 Mapper 这不是表中的字段。

`insertUseGeneratedKeys`

背景：

今天前端添加目录，由于需要回显父级目录，他直接像编辑回显一个把父级目录修改之后就传给了我，也就是id也是错的id，但是奇怪的是插入的时候居然没有出错。

后来看了一下，是因为我用了`insertUseGeneratedKeys`，之前一直是需要返回自增主键的时候才会使用它，其实它还会做的工作就是即使插入的对象即使有id属性，也会被忽略，使用数据库的自增主键。

所以我认为只要是新增(主键自增)就使用这个API，这样的话即使穿入的有错误的id也不会造成错误。

`insertList`

该方法传入的数组不能为空，注意判断

```
tagFilterSectionMapper.insertList(tagFilterSectionDOS);
```

### Example

## PageHelper



