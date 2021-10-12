# IDEA

## 快捷键

- 插入快捷键

  `alt+inster==command+n`

- 整段加注释

  `shift+control+/`

- 重写方法

  `ctrl+O`

- 添加类

  `option+enter`

- 各视图区域的切换

  `cmd + 视图区域对应的数字`

- 显示方法的参数信息

  `Command+P`

- 打开项目结构对话框

  `Command+;` 

- 基本的代码补全

  `Ctrl+Space` 

- 自动生成变量名

  `Command+Option+v`

- 大小写切换

  `Command+Shift+u`

- 看每一行的编辑者是谁

  `右键+annotate`

- 查看某个类在哪个地方被使用

  `Alt+F7`

- 查看当前文件所处的位置

  `Alt+F1`

## IDEA好用插件

**Lombok**

略

**SQL Params Setter**

一款将预查询语句和参数转换为SQL语句的插件。

当然同类插件也有更出名的mybatis log plugin，但是开始收费了，就找了个代替的。

说明如下：

>A simple tool that helps you to extract a executable sql from mybatis logs like below:
>==> Preparing: select * from table where name = ?
>==> Parameters: Tom(String)
>After selecting these two lines of logs above, you can right click your mouse and select "SQL Params Setter" in the popup menu, then the result executable sql, i.e. "select * from table where name = 'Tom'" will be copied to your clipboard.
>
>Note:
>The selected area should contain both keyword [Preparing:] in the 1st line and keyword [Parameters:] in the 2nd line.

**CamelCase**

各种驼峰，蛇形等各种形式的转换。

IDEA自带的有大小写转换，但是实际上遇到数据库中的蛇形字段转换成驼峰的需求的时候，就无法满足了，可以使用此插件。

说明如下：

> Switch easily between kebab-case, SNAKE_CASE, PascalCase, camelCase, snake_case or space case. See Edit menu or use ⇧ + ⌥ + U / Shift + Alt + U. Allows to disable some conversions or change their order in the preferences.

**POJO to JSON**

将POJO转换为JSON方便接口调试





**Key promoter X**

对于很多刚刚开始使用IDEA的开发者来说，最苦恼的就是不知道快捷键操作是什么。

**使用IDEA，如果所有操作都使用鼠标，那么说明你还不是一个合格的程序员。**

这里推荐一款可以进行快捷键提示的插件Key promoter X。

Key Promoter X 是一个提示插件，当你在IDEA里面使用鼠标的时候，如果这个鼠标操作是能够用快捷键替代的，那么Key Promoter X会弹出一个提示框，告知你这个鼠标操作可以用什么快捷键替代。

当我使用鼠标查看一个方法都被哪些类使用的时候，就会提示：



