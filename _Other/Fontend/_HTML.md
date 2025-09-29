# HTML

## HTML入门

```html
<html>
	<head>
		<title>这是标题</title>
	</head>
	<body>
		这里是正文
	</body>
</html>
```

以上使用的标签组成了HTML页面的基本结构，现将所有标签进行陈述：

- `<html>` 整个页面的根标签，理论上一个页面只需要一个，由头和体组成。
- `<head>`头标签，用于引入脚本、导入样式、提供元信息等。一般情况下头标签的内容在浏览器端都不显示。
- `<body>`体标签，是整个网页的主体，我们编写的html代码基本都在此标签体内。

## HTML注释

在模板代码中，我们使用到了HTML注释

- 格式：<!--注释内容 -->

## HTML常用标签

### 标题标签

```html
标题标签
作用:在页面中展示一个标题,标题中的文字会自动的加粗
h1-h6
<h1>标题文字</h1>  最大
<h2>标题文字</h2>
<h3>标题文字</h3>
<h4>标题文字</h4>
<h5>标题文字</h5>
<h6>标题文字</h6>  最小
特点:
行间元素:会独自占用html中的一行
```

### 水平线标签

```html
水平线标签
作用:在页面中绘制一条横线,可以把页面分成上下两部分
使用标签:
<hr/>:自闭和标签 horizontal rule
属性:
size属性:设置水平线的高度,单位是像素(px)
noshade属性:没有阴影,表示纯色,取值:noshade
color属性:用于设置颜色
属性值:
1.可以颜色的英文单词
红色:red 绿色:green 蓝色:blue
2.使用三原色(红绿蓝),取值"#00"-"#FF"(16进制)
红色:"#FF0000" 简化:"#F00"
绿色:"#00FF00"
蓝色:"#0000FF"
白色:"#FFFFFF"
黑色:"#000000"
自定义:"#123456"
```

### 字体标签

```html
字体标签
作用:用来设置文字的大小,颜色和字体
使用标签:
<font>要设置的字体</font>
属性:
size:设置字体的大小,范围1(小)--7(大),不写默认3号字体
color:设置字体的颜色,不写默认黑色
face:设置字体 火狐:默认微软雅黑 IE:默认宋体
```

### 格式化标签

```html
格式化标签
作用:用于对文字进行格式化
加粗: b标签 bold
格式:<b>文字</b>
斜体: i标签 italic
格式:<i>文字</i>
添加下划线: u标签 underline
格式:<u>文字</u>
注意:
在html中同级的标签是可以相互嵌套使用的
<b><i><font></font></i></b>  
```

### 段落/换行标签

```html
段落标签:可以把文字分段显示,会在每段文字的前后添加一些空白
使用标签:
<p>一段文字</p>
换行标签:
<br/> 自闭和标签 break
```

### 图片标签

```html
<!--
图片标签:用于在页面中显示一个图片
使用标签:
<image/> 自闭和标签
属性:
src:设置图片的路径(建议使用相对路径)
title:设置图片的标题,鼠标移动到图片上,会显示标题
alt:图片丢失,显示文字
height:设置图片的高度,单位是像素px
width:设置图片的宽度,单位是像素px
```

### 列表标签

```html
列表标签:用于在页面中显示一个列表
1.有序列表:使用ol标签  ordered lists
格式:
<ol>
    <li>列表项</li>
    <li>列表项</li>
    <li>列表项</li>
    ...
    <li>列表项</li>
</ol>
属性:
type:用于设置列表显示的文字(1,I,A,a...),不写默认是阿拉伯数字
2.无序列表:使用ul标签  unordered lists 
格式:
<ul>
    <li>列表项</li>
    <li>列表项</li>
    <li>列表项</li>
    ...
    <li>列表项</li>
</ul>
属性:
type:用于设置列表显示的形状
属性值: disc实心圆(不写默认)  square方块    circle空心圆
3.列表标签中的列表项:使用li标签
注意:
单独书写ol和ul标签没有意义,必须和列表项li标签一起使用
每个li标签都会占用html中的一行(行级元素)
```

```html
<!--1.有序列表:使用ol标签-->
<ol>
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ol>
<ol type="a">
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ol>
<ol type="I">
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ol>

<!--
列表使用阿拉伯数字
使用start属性:设置列表的起始文字
-->
<ol start="100">
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ol>

<!--2.无序列表:使用ul标签-->
<ul>
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ul>
<ul type="square">
    <li>北京</li>
    <li>上海</li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ul>
<ul type="circle">
    <li>北京</li>
    li>
    <li>广州</li>
    <li>深圳</li>
    <li>杭州</li>
</ul>
```

### 超链接

```html
超链接标签:用于页面的跳转,可以让我们由一个页面跳转到另外一个页面 anchor
使用标签:
<a>文字|图片</a>
属性:
href:设置跳转的路径
属性值:
1.可以是其他的页面(.html,.jsp)
2.可以是页面的url地址(http://www.itcast.cn)
target:设置跳转的方式
属性值:
_self:默认属性,在当前页面打开新的链接
_blank:在新的页面打开新的链接
```

```html
<a href="#">07_html标签_段落标签.html</a><br/>
<a href="07_html标签_段落标签.html">07_html标签_段落标签.html</a><br/>
<a href="http://www.itcast.cn" target="_blank">点我到传智</a>

<!--图片超链接-->
<a href="http://www.itheima.com" target="_blank">
    <%E5%89%8D%E7%AB%AF_assets src="%E5%89%8D%E7%AB%AF_assets/logo2.png">
</a>
```

### 表格标签

HTML表格由\<table>标签以及一个或多个\<tr>、\<th>或\<td>标签组成。

- `<table>` 是父标签，相当于整个表格的容器。

  - border  表格边框的宽度。单位像素px
  - width 表格的宽度。单位像素px
  - cellpadding 单元边沿与其内容之间的空白。单位像素px
  - cellspacing 单元格之间的空白。 单位像素px
  - bgcolor 表格的背景颜色。

- `<tr>`标签用于定义行 table row 

- `<td>`标签用于定义表格的单元格（一个列）table data

  - colspan 单元格可横跨的列数。
  - rowspan  单元格可横跨的行数。 
  - align 单元格内容的水平对齐方式, 取值：left 左 、right 右、center 居中。
  - nowrap 单元格中的内容是否折行。

- `<th>`标签用于定义表头。单元格内的内容默认居中、加粗。table heading

  ![1595563484651](%E5%89%8D%E7%AB%AF_assets/1595563484651.png)

练习1：编写3*3表格，使用\<th>修饰表头

![](%E5%89%8D%E7%AB%AF_assets/14.png)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>表格标签</title>
</head>
<body>
    <!--
        表格标签:用于在页面中绘制一张表格,用于页面的布局,可以使用页面中的数据上下左右对齐
        table标签:用于在页面中创建一个表格,单独书写table没有意义,配合子标签一起使用
            使用格式:<table></table>
        table标签的子标签tr:用于在表格中创建一个行
            格式:<tr></tr>
        tr子标签th:表头标签(列标签),表头中的文字会自动的加粗和居中
            格式:<th></th>
        tr的子标签td:列标签(单元格),在行中创建列
            格式:<td></td>
        表格标签的属性:
            - border  表格边框的宽度。单位像素px
            - width 表格的宽度。单位像素px
            - cellpadding 单元边沿与其内容之间的空白。单位像素px
            - cellspacing 单元格之间的空白。 单位像素px
            - bgcolor 表格的背景颜色。
            - align 单元格内容的水平对齐方式, 取值：left 左 、right 右、center 居中。
    -->
    <!--
        练习1：编写3(行)*3(列)表格，使用<th>修饰表头
    -->
    <!--使用table标签创建一个表格-->
    <table border="1px" width="500px" cellpadding="0px" cellspacing="0px">
        <!--使用3个tr标签,创建3行-->
        <tr bgcolor="aqua">
            <!--使用3个th标签,创建3个表头-->
            <th>1-1</th>
            <th>1-2</th>
            <th>1-3</th>
        </tr>
        <tr>
            <td>2-1</td>
            <td>2-2</td>
            <td>2-3</td>
        </tr>
        <tr align="right">
            <td>3-1</td>
            <td>3-2</td>
            <td>3-3</td>
        </tr>
    </table>
</body>
</html>
```

**nowrap属性**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>nowrap属性</title>
</head>
<body>
    <!--
        nowrap属性
        nowrap 单元格中的内容是否折行(不换行)
    -->
    <table border="1px" width="500px" cellpadding="0px" cellspacing="0px">
        <tr>
            <td>11111 aaaa bbbbb  ccccccccccc ddddddddddddddddddd  333333333333333333</td>
            <td nowrap="nowrap">11111 aaaa bbbbb  ccccccccccc ddddddddddddddddddd  333333333333333333</td>
        </tr>
    </table>
</body>
</html>
```

![1595571548410](%E5%89%8D%E7%AB%AF_assets/1595571548410.png)

快速制表：

生成3行2列的表格

使用乘法规则定义行列的数目，输入如下：

table>tr3>td2【此时按下Tab（制表键），输入内容中间和后面都不能留有空格和换行等内容】

### 实体字符(转义字符)

```html
实体字符(转义字符)
半个英语字母英文空格&nbsp; Non Breaking Space(不间断空格)
一个汉字中文空格&emsp; Em Space
小于号&lt;
大于号&gt;
&符号&amp;
×叉号&times;
￥人民币符号&yen;
$美元符号
```

### div标签和span标签

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>div标签和span标签</title>
</head>
<body>
    <!--
        div标签和span标签
        作用:用于页面的布局,可以把页面分成一块一块的
            页面的流行的布局方式:div标签和span标签+css
        注意:
            div标签和span标签一般都是和css(层叠样式表)一起使用,否则没有意义
        div标签:行级(间)标签,会霸占html中的一行
        span标签:行内标签,只会占用一行中的一部分(占用的大小和里边的内容多少有关)
    -->
</body>
    <div>我是一个div</div>div外边的内容
    <span>我是一个span</span>span外边的内容
</html>
```

![1595572467557](%E5%89%8D%E7%AB%AF_assets/1595572467557.png)

## 表单相关标签

### 1.表单标签

#### input标签

`<input>` 标签用于获得用户输入信息，type属性值不同，搜集方式不同。最常用的标签。

- type属性
  - text:普通文本
  - password:密码输入框,里边的密码以黑色的小圆点显示
  - radio:单选框
  - checkbox:多选框
  - file:上传文件
  - image:上传图片使用
  - hidden:隐藏域,存储数据使用,不会在浏览器页面显示
  - botton:普通按钮,配合js使用
  - reset:重置按钮,把表单的恢复到默认状态(清空表单)
  - submit:提交按钮,把表单的数据,提交到服务器。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>表单标签</title>
</head>
<body>
    <!--
        表单标签:我们可以在表单中输入一些数据,获取用户输入的数据,最终把数据保存到数据库中
            注册,登录==>输入一些数据
        form标签:在页面中创建一个表单,单独书写没有意义,配合子标签一起使用
        form标签的属性:
            action:设置表单提交的路径,路径一般都是java中的某一个类(没有服务器,写#)
            method:设置表单的提交方式(get,post),不写method默认都是get方法
        form标签的子标签:input标签
            作用:让用户在标签中输入数据
            type属性的属性值:
                - text:普通文本
                - password:密码输入框,里边的密码以黑色的小圆点显示
                - date:日期框
                - radio:单选框
                - checkbox:多选框
                - file:上传文件
                - image:上传图片使用
                - hidden:隐藏域,存储数据使用,不会在浏览器页面显示
                - botton:普通按钮,配合js使用
                - reset:重置按钮,把表单的恢复到默认状态(清空表单)
                - submit:提交按钮,把表单的数据,提交到服务器。
        form标签的子标签:select标签,下拉选标签
            作用:可以让用户在多个值中选择一个
            注意:
                配合子标签option(下拉选的列表项)一起使用
        form标签的子标签:textarea多行文本域标签
            作用:可以让用户输入多行文本
    -->
    <!--创建一个表单-->
    <form action="#" method="get">
        <!--
            form标签的子标签:input标签,让用户可以在标签中输入数据
        -->
        <!--- text:普通文本-->
        请输入用户名:<input type="text"/><br/>
        <!--- password:密码输入框,里边的密码以黑色的小圆点显示-->
        请输入密码:<input type="password" /><br/>
        <!--- date:日期框-->
        请选择您的出生日期:<input type="date"><br/>
        <!--
            - radio:单选框
            表单标签的属性name:可以给标签起一个名字
                同名的radio标签互斥,只能选择一个
            表单标签的属性checked:可以给单选框|多选框设置一个默认选中的值
        -->
        请选择您的性别:
        男<input type="radio" name="sex" checked="checked">
        女<input type="radio" name="sex"><br/>
        <!--- checkbox:多选框-->
        请选择您的爱好:
        抽烟<input type="checkbox">
        喝酒<input type="checkbox">
        烫头<input type="checkbox" checked="checked"><br/>
        <!--- file:上传文件-->
        <input type="file"><br/>
        <!--
            - image:上传图片使用
            属性:
                src:设置要上传图片的路径
                height:设置图片的高度,单位像素
                width:设置图片的宽度,单位像素
        -->
        <input type="image" src="%E5%89%8D%E7%AB%AF_assets/2.jpg" height="200px" width="170px"><br/>
        <!--
            - hidden:隐藏域,存储数据使用,不会在浏览器页面显示
            表单标签的属性value:给标签添加默认值
        -->
        <input type="hidden" value="18">
        <!--
            - botton:普通按钮,配合js使用
            表单标签的属性value:
                按钮标签(button,reset,submit)给按钮起名字
                其他标签:给标签设置默认值
        -->
        <input type="button" value="没事别点我">
        <!--- reset:重置按钮,把表单的恢复到默认状态(清空表单)-->
        <input type="reset">
        <!--
            - submit:提交按钮,把表单的数据,提交到服务器。
            根据写的form标签的属性action路径,把表单提交到服务器的某一个类中
        -->
        <input type="submit" value="注册">
    </form>
</body>
</html>
```

#### select标签

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>select标签</title>
</head>
<body>
    <!--
        form标签的子标签:select标签,下拉选标签
            作用:可以让用户在多个值中选择一个
            注意:
                配合子标签option(下拉选的列表项)一起使用
    -->
    <form action="#" method="post">
        <select>
            <option>北京</option>
            <option>上海</option>
            <option>广州</option>
            <option>深圳</option>
            <option>杭州</option>
        </select>
    </form>
</body>
</html>
```

#### textarea标签

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>textarea标签</title>
</head>
<body>
    <!--
        form标签的子标签:textarea多行文本域标签
            作用:可以让用户输入多行文本
        属性:
            rows:设置文本域默认显示的行数
            cols:设置文本域默认显示的列数
        注意:
            多行文本域使用的不是特别多,已经被文本编辑器给取代了
    -->
    <form action="#">
        <textarea rows="10" cols="20"></textarea>
    </form>
</body>
</html>
```

### 2.form表单标签的属性

标签的通用属性:

- name：元素名，如果需要表单数据提交到服务器，必须提供name属性值，服务器通过属性值获得提交的数据。

- value属性：设置input标签的默认值。submit和reset为按钮显示数据

  注意:除了文本输入域(text,password,textarea)其他标签需要设置value属性值

- checked属性：单选框或复选框被选中。

- readonly：是否只读

- disabled：是否可用

select标签的属性:

- name属性：发送给服务器的名称
- multiple属性：不写默认单选，取值为“multiple”表示多选。
- size属性：多选时，可见选项的数目。
- `<option>` 子标签：下拉列表中的一个选项（一个条目）。
  - selected ：勾选当前列表项
  - value ：发送给服务器的选项值。

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>form表单标签的属性</title>
</head>
<body>
    <!--
        标签的通用属性:
            - name：元素名，如果需要表单数据提交到服务器，必须提供name属性值，服务器通过name属性值获得提交的数据。
            - value属性：设置input标签的默认值。botton,submit和reset为按钮显示数据
              注意:除了文本输入域(text,password,textarea)其他标签需要设置value属性值,value属性值就是提交到服务器的数据
            - checked属性：单选框或复选框被选中。
            - readonly：是否只读
            - disabled：是否可用
            - placeholder:html5的新特性,给标签添加一个默认值;输入数据隐藏默认值,删除数据会显示默认值
    -->
    <form action="#" method="get">
        请输入用户名:<input type="text" name="username" value="张三"/><br/>
        请输入用户名:<input type="text" name="username" value="张三" readonly="readonly"/><br/>
        请输入用户名:<input type="text" name="username" value="张三" disabled="disabled"/><br/>
        <hr/>
        用户名:<input type="text" name="username" placeholder="请输入姓名"/><br/>
        密码:<input type="password" name="password" placeholder="请输入密码"/><br/>
        请选择您的出生日期:<input type="date" name="date"><br/>

        请选择您的性别:
        男<input type="radio" name="sex" checked="checked" value="男">
        女<input type="radio" name="sex" value="女"><br/>
        <!--- checkbox:多选框-->
        请选择您的爱好:
        抽烟<input type="checkbox" name="hobby" value="抽烟">
        喝酒<input type="checkbox" name="hobby" value="喝酒">
        烫头<input type="checkbox" checked="checked" name="hobby" value="烫头"><br/>

        <!--
            select标签的属性:
                - name属性：发送给服务器的名称
                - multiple属性：不写默认单选，取值为“multiple”表示多选。
                - size属性：多选时，可见选项的数目。
                - <option> 子标签：下拉列表中的一个选项（一个条目）。
                  - selected ：勾选当前列表项
                  - value ：发送给服务器的选项值。不写value默认把option标签的标签体发送到服务器
        -->
        <select name="city">
            <option value="bj">北京</option>
            <option value="sh">上海</option>
            <option>广州</option>
            <option>深圳</option>
            <option selected="selected">杭州</option>
        </select>

        <select name="city" multiple="multiple">
            <option value="bj">北京</option>
            <option value="sh">上海</option>
            <option>广州</option>
            <option>深圳</option>
            <option selected="selected">杭州</option>
        </select>

        <select name="city" multiple="multiple" size="2">
            <option value="bj">北京</option>
            <option value="sh">上海</option>
            <option>广州</option>
            <option>深圳</option>
            <option selected="selected">杭州</option>
        </select>
    </form>
</body>
</html>
```

### 3.form表单的提交方式

action属性: 值为URL规定当提交表单的时候, 向何处发动表单数据

method属性: get  post 规定如何发送表单数据

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>form表单的提交方式</title>
</head>
<body>
    <!--
        form表单的提交方式
        form标签的属性method,可以设置表单的提交方式
        1.get(不写method属性,默认):当我们点击提交按钮的时候,会把表单中的数据追加到浏览器的地址栏中提交到服务器
            格式:
                xxx.html?k=v&k=v&k=v&k=v&k=v&k=v&k=v&k=v
                会在.html的后边添加一个?,?后边就是我们表单中提交的数据
                数据是以键值对的方式提交的,多个键值对之间使用&符号连接
                健值对:k=v
                k:标签标签name的属性值
                    name="username"  k=>username
                    name="password"  k=>password
                v:标签的value属性值,文本输入框就是,输入框中输入的内容
                     value="男" v==>男
                     注意:除了文本输入框,其他的标签必须有value属性值,用来发送到服务器
             ...form表单的提交方式.html?username=jack&password=1234&sex=男&hobby=抽烟&hobby=喝酒&hobby=烫头&city=bj#
             ...form表单的提交方式.html?username=rose&password=4321&sex=on&hobby=喝酒&city=杭州#
             sex=on  <input type="radio" name="sex" >标签上没有写默认的value属性值
             烫头<input type="checkbox" checked="checked" > 没有发送烫头,标签上没name属性

             弊端:
                a.把数据追加到浏览器的地址栏中,会暴漏敏感信息(密码)
                b.浏览器的地址栏的长度是有限制的,提交的数据大小有限制,不能提交大的文件(最多能提交几kb的数据)
        2.post:会把提交的数据隐藏在请求服务器的请求体中(javaweb)
            好处:
                a.安全,用于无法直接看到提交的数据
                b.可以提交大的文件
    -->
    <form action="#" method="get">
        用户名:<input type="text" name="username" placeholder="请输入姓名"/><br/>
        密码:<input type="password" name="password" placeholder="请输入密码"/><br/>
        请选择您的性别:
        男<input type="radio" name="sex" checked="checked" value="男">
        女<input type="radio" name="sex" ><br/>
        <!--- checkbox:多选框-->
        请选择您的爱好:
        抽烟<input type="checkbox" name="hobby" value="抽烟">
        喝酒<input type="checkbox" name="hobby" value="喝酒">
        烫头<input type="checkbox" checked="checked" name="hobby"><br/>
        <select name="city">
            <option value="bj">北京</option>
            <option value="sh">上海</option>
            <option>广州</option>
            <option>深圳</option>
            <option selected="selected">杭州</option>
        </select>
        <input type="submit" value="注册">
    </form>
</body>
</html>
```

# CSS

## CSS基础概述

### CSS介绍

CSS (Cascading Style Sheets) ：指层叠样式表

- 样式：给HTML标签添加需要显示的效果。

- 层叠：使用不同的添加方式，给同一个HTML标签添加样式，最后所有的样式都叠加到一起，共同作用于该标签。

### CSS样式规则

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSS样式规则</title>
    <!--
        CSS样式规则:在html页面中如何使用css
        格式:
            选择器{
                属性名:属性值;
                属性名:属性值;
                属性名:属性值;
                属性名:属性值;
                ...
                属性名:属性值;
            }
            选择器:选择要添加html标签的方式,可以根据标签的名称,标签的id属性值,标签的class属性值来选择要添加样式的标签
            属性:给标签添加的显示效果(大小,颜色...)
       CSS样式规则需要写在一个style(样式)标签中
       格式:
       <style type="text/css">
            选择器{
                属性名:属性值;
                属性名:属性值;
                属性名:属性值;
                属性名:属性值;
                ...
                属性名:属性值;
            }
       </style>
    -->
    <style type="text/css">
        /*使用标签选择器:根据标签名称选择到对应的标签*/
        h1{
            /*给h1标签添加一个字体颜色*/
            color: red;
        }
        h2,div{
            /*字体颜色*/
            color: blue;
            /*字体大小*/
            font-size: 50px;
        }
    </style>
</head>
<body>
    <h1>我是一个h1标题标签</h1>
    <h1>我是一个h1标题标签</h1>
    <h1>我是一个h1标题标签</h1>
    <h2>我是一个h2标题标签</h2>
    <div>我是div标签</div>
</body>
</html>
```

### 引入css样式的方式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>引入css样式的方式</title>
    <!--
        引入css样式的方式
        1.行内样式:在标签上直接写style属性,属性值就是要设置的样式
            格式:
                <标签 style="属性名:属性值;属性名:属性值;属性名:属性值;..属性名:属性值;"></标签>
            作用域:
                只针对当前的标签有效
        2.内部(内嵌)样式:在页面中创建一个style标签,在标签中写css的样式规则
            格式:
               <style type="text/css">
                    选择器{
                        属性名:属性值;
                        属性名:属性值;
                        属性名:属性值;
                        属性名:属性值;
                        ...
                        属性名:属性值;
                    }
               </style>
            作用域:
                在当前页面中,针对选择器选择到的所有标签都有效
        3.外部(外联)样式:把css的样式规则,写在一个以.css结尾的文件中
            需要在html中使用link标签引入外部的css文件使用
            格式:
                <link href="外部css文件的路径" type="text/css" rel="stylesheet" />
                href="外部css文件的路径" css文件一般都放在当前项目的css文件夹中,所以使用相对路径
                type="text/css" 说明引入的文件是文本类型的css文件(固定写法)
                rel="stylesheet"  stylesheet:样式表,说明引入的css文件是html文件的一个样式表(固定写法)
            作用域:
                css文件可以被多个页面同时引用,哪个页面引用的,对哪个页面中的标签有效
       样式的优先级:
        行内样式>内部样式|外部样式(内部和外部谁写在后边,后边的样式会覆盖前边的样式)
    -->
</head>
<!--2.内部(内嵌)样式-->
<style>
    /*选择所有的h1标签*/
    h1{
        color: pink;
    }
</style>
<!--3.外部(外联)样式-->
<link href="css/1.css"  rel="stylesheet"/>
<!--rel表示当前引用的是一个样式表文件-->
<body>
    <!--1.行内样式-->
    <div style="color: red;font-size: 20px">我是一个div</div>
    <div style="color: green">我是一个div</div>
    <div style="color:yellow;">我是一个div</div>
    <!--2.内部(内嵌)样式-->
    <h1 style="color: gold">我是h1标题标签</h1>
    <h1>我是h1标题标签</h1>
</body>
</html>
```

1.css文件

```css
h1{
    color: blue;
    font-size: 50px;
}
```

![1595728454040](%E5%89%8D%E7%AB%AF_assets/1595728454040.png)

### CSS的选择器

##### 基本选择器(重点)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSS的选择器</title>
</head>
    <!--
        CSS的选择器:使用何种方式选择要添加样式的html标签
        常用:
        1.元素(标签,标记)选择器:根据元素(标签,标记)的名称,选择对应的元素
            <h1></h1>   选择器: h1{属性名:属性值;...}
            <div></div>   选择器: div{属性名:属性值;...}
            ...
        2.id选择器:需要给元素添加一个id属性,通过id的属性值选择到元素
            <h1 id="d001"></h1>
            <div id="d001"></div>
            选择器:
                #元素id的属性值{属性名:属性值;...}
                #d001{属性名:属性值;...}
            注意:
                如果给多个html元素,添加相同的id属性值
                id在页面中具有唯一性,之后使用JavaScript通过元素的id属性值,获取到元素
                如果多个元素的id属性值是相同的,只能获取到第一个
       2.class(类)选择器:需要给元素添加一个class属性,通过class的属性值选择到元素
            <h1 class="c001"></h1>
            <div class="c001"></div>
            选择器:
                .元素的class属性值{属性名:属性值;...}
                .c001{属性名:属性值;...}
    -->
    <style>
        /*1.元素(标签,标记)选择器*/
        h1{
            color: red;
        }
        a{
            color: green;
        }
        /*2.id选择器*/
        #d001{
            color: #880088;
        }
        /*3.class(类)选择器*/
        .c001{
            color: chocolate;
        }
    </style>
<body>
    <!--1.元素(标签,标记)选择器-->
    <h1>标题标签</h1>
    <h1>标题标签</h1>
    <a href="#">我是一个超链接标签</a>
    <a href="#">我是一个超链接标签</a>
    <!--2.id选择器-->
    <div id="d001">我是一个div</div>
    <h2 id="d001">我是一个h2标题标签</h2>
    <!--2.class(类)选择器-->
    <div class="c001">我是一个div</div>
    <h2 class="c001">我是一个h2标题标签</h2>
</body>
</html>
```

##### 扩展选择器

- 扩展：属性选择器

属性选择器，在标签后面使用中括号标记，其基本语法格式如下：

```css
标签名[标签属性=’标签属性值’]{属性1:属性值1; 属性2:属性值2; 属性3:属性值3; }
```

该选择器，是对“元素选择器”的扩展，对一组标签进一步过滤。例如：

- 扩展：包含选择器

包含选择器，两个标签之间使用空格，给指定父标签的后代标签设置样式，可以方便在区域内编写样式。

```css
父标签 后代标签{属性1:属性值1; 属性2:属性值2; 属性3:属性值3; }
```

该选择器，是对“元素选择器”的扩展，对一个标签内部所有后代标签进行过滤。

- 扩展：伪类选择器

在支持 CSS的浏览器中，链接的不同状态都可以不同的方式显示，这些状态包括：活动状态，已被访问状态，未被访问状态，和鼠标悬停状态。书写有顺序！必须是 l v h a

```css
<style>
    a:link {color: #FF0000}	/* 未访问的链接 */
    a:visited {color: #00FF00}	/* 已访问的链接 */
    a:hover {color: #FF00FF}	/* 鼠标移动到链接上 */
    a:active {color: #0000FF}	/* 选定的链接 */
</style>
<a href="http:\\www.itcast.cn" target="_blank">点击我到传智</a>
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSS的扩展选择器</title>
    <!--
        CSS的扩展选择器
        1.属性选择器:对元素选择器进行扩展,在继续通过标签的属性选择到对应的标签
        格式:
            标签名[属性名='属性值']{属性名:属性值;...}
        2.包含选择器(子父类选择器):对元素选择器进行扩展,通过后代选择对应的标签
        格式:
            父标签 子标签{属性名:属性值;...}
        3.伪类选择器:专用于超链接标签
        格式:必须是lvha顺序
             a:link {color: #FF0000}	/* 未访问的链接 */
             a:visited {color: #00FF00}	/* 已访问的链接 */
             a:hover {color: #FF00FF}	/* 鼠标移动到链接上 */
             a:active {color: #0000FF}	/* 选定的链接 */
    -->
    <style>
        /*input{
            !*背景色*!
            background-color: green;
        }*/
        /*给type="text"标签添加样式*/
        input[type='text']{
            background-color: green;
        }
        /*给type="password"标签添加样式*/
        input[type='password']{
            background-color: pink;
        }

        /*2.包含选择器(子父类选择器)*/
        /*给div中的div添加样式*/
        div div{
            color: yellow;
        }
        #d001 h3{
            color: aqua;
        }
        /*3.伪类选择器:专用于超链接标签*/  
        a:link {color: #FF0000}	/* 未访问的链接 */
        a:visited {color: #00FF00}	/* 已访问的链接 */
        a:hover {color: #FF00FF}	/* 鼠标移动到链接上 */
        a:active {color: #0000FF}	/* 选定的链接 */
    </style>
</head>
<body>
    <!--1.属性选择器-->
    <input type="text" name="username"/>
    <input type="password" name="password"/>

    <!--2.包含选择器(子父类选择器)-->
    <div>我是div</div>
    <div id="d001">
        <div>我是div中的div</div>
        <h3>我是div中的h3</h3>
    </div>

    <!--3.伪类选择器:专用于超链接标签-->
    <a href="http://www.itcast.cn" target="_blank">点击我到传智</a>
</body>
</html>
```



## CSS常用样式

### 边框和尺寸

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>边框和尺寸</title>
    <style>
        /*
            边框:给元素添加边框
                border:可以同时给元素设置4个边框(上下左右)
                border-top:上边框
                border-right:右边框
                border-bottom:下边框
                border-left:左边框
                属性值:同时设置边框的颜色,尺寸(像素),格式(不区分先后顺序)
                格式: solid实线 double双线 none无边 ridge山脊
                边框圆角:
                    border-radius 可以设置四个角(左上,右上,右下,左下)边框从多少像素开始圆滑 一般设置一个值全部应用.
            尺寸:设置元素的高度和宽度
                width:设置元素的宽度,单位像素
                height:设置元素的高度,单位像素
        */
        div{
            /*给div添加边框*/
            border: 1px red solid;
            border-bottom: 10px green double;
            border-left: 5px ridge;
            /*给div设置尺寸*/
            width: 300px;
            height: 100px;
        }
        span{
            /*给span标签添加边框*/
            border: red solid 2px;
            /*给span添加边框圆角*/
            border-radius: 50px;
        }
    </style>
</head>
<body>
    <div>我是一个div</div>
    <span>我是一个span</span>
</body>
</html>
```

![1595731918780](%E5%89%8D%E7%AB%AF_assets/1595731918780.png)

### 转换属性

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>转换属性</title>
    <style>
        /*
            转换属性
            display:可以把行间元素和行内元素相互转换,还可以隐藏元素
            行间元素:占用html中的一行
                h1-h6,ul,ol,div...
            行内元素:占用一行中的一部分
                span,%E5%89%8D%E7%AB%AF_assets,a...
            display的属性值:
                inline:设置元素为行内元素(行内元素默认display的属性值)
                block:设置元素为行间元素(行间元素默认display的属性值)
                none:设置隐藏元素(不在html页面中显示,也不会占用空间)
        */
        div{
            border: 1px solid red;
        }
        span{
            border: 1px solid green;
        }
    </style>
</head>
<body>
    <div>我是一个div,我会占用一行</div>
    <!--使用display属性inline把div转换为行内元素-->
    <div style="display: inline">我是一个div,我只占用一行的一部分</div>
    <span>我是一个span,我只占用一行的一部分</span>
    <!--使用display属性block把span转换为行间元素-->
    <span style="display: block">我是一个span,我会占用一行</span>
    <!--使用display属性none隐藏标签-->
    <span style="display: none">我是隐藏起来的标签,你看不到我</span>
    <%E5%89%8D%E7%AB%AF_assets style="display: none" src="%E5%89%8D%E7%AB%AF_assets/2.jpg" height="100px" width="80px">
</body>
</html>
```

![1595733367727](%E5%89%8D%E7%AB%AF_assets/1595733367727.png)

### 字体属性

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>字体属性</title>
    <style>
        /*
            字体属性:
                color:设置字体颜色
                font-size:设置字体大小,单位像素px
                font-weight:bold 设置字体加粗
                font-style:italic 设置斜体
                font-family:字体(幼圆,宋体,楷体)
                text-decoreation:none 取消文字上的下划线
        		text-decoration: underline 加下划线;
        */
    </style>
</head>
<body>
    <a href="http://www.itheima.com" target="_blank" style="color: red">我是红色的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="font-size: 50px">我是50px大小的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="font-weight: bold">我是粗体的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="font-style: italic">我是斜体的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="font-style: italic;font-weight: bold;color: green">我是粗体斜体绿色的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="font-family: 楷体">我是楷体的超链接</a><br/>
    <a href="http://www.itheima.com" target="_blank" style="text-decoration: none">我是没有下划线的超链接</a>
</body>
</html>
```

![1595733893766](%E5%89%8D%E7%AB%AF_assets/1595733893766.png)

### 背景色和背景图片

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>背景色和背景图片</title>
    <style>
        /*
            背景色和背景图片
                background-color:设置背景色
                background-image:url(图片的地址)设置背景图片
                background-repeat: no-repeat;背景图片不平铺
                background-position: top 0px right 0px;背景图片位置 右上角
        */
    </style>
</head>
<!--给整个body添加一个背景图片-->
<body style="background-image: url(%E5%89%8D%E7%AB%AF_assets/bg.jpg);background-repeat:no-repeat;background-position: top 30px right 100px">
    <!--给div添加一个背景色-->
    <div style="border: 1px red solid;background-color: pink;width: 300px; height: 500px">我是一个div</div>
    <!--给提交按钮添加背景色-->
    <input type="submit" value="用户注册" style="background-color: gold;color: white">
</body>
</html>
```

![1595734682050](%E5%89%8D%E7%AB%AF_assets/1595734682050.png)

### CSS的盒子模型

![1595735842955](%E5%89%8D%E7%AB%AF_assets/1595735842955.png)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CSS的盒子模型</title>
    <!--
        CSS的盒子模型:可以把html中的任意元素,都可以看成是被一个盒子包裹起来
        盒子的外边距:设置这个盒子到其他盒子之间的距离,或者设置盒子到body框的距离
        盒子的内边距:设置盒子边框到盒子中内容的距离
        使用css的属性:margin,设置外边距
            margin:同时设置4个外边距
            margin-top:上外边距
            margin-right:右外边距
            margin-bottom:下外边距
            margin-left:左外边距
       使用css的属性:padding,设置内边距
            padding:同时设置4个内边距
            padding-top:上内边距
            padding-right:右内边距
            padding-bottom:下内边距
            padding-left:左内边距
    -->
    <style>
        div{
            /*设置div的边框和尺寸*/
            border: 1px solid red;
            width: 300px;
            height: 200px;
            /*设置div的外边距*/
            margin: 50px;/*同时设置4个外边距为50px*/
            margin-left: 100px;/*设置左外边距100px*/
            margin: 50px 100px;/*上下50px 左右100px*/
            margin: 50px 100px 150px;/*顺时针上50px 右100px 下150px 左100px*/
            margin: 50px 100px 150px 200px;/*顺时针上50px 右100px 下150px 左200px*/
            margin: 50px auto;/*上下50px 左右auto会自动居中*/
            /*设置div的内边距*/
            padding: 50px;/*同时设置4个内边距为50px*/
        }

    </style>
</head>
<body>
    <div>我是一个div</div>
</body>
</html>
```

### 案例-公司简介

案例效果展示

![1577560513351](%E5%89%8D%E7%AB%AF_assets/1577560513351.png)

案例需求分析

![1595743775393](%E5%89%8D%E7%AB%AF_assets/1595743775393.png)

案例代码实现

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>公司简介案例</title>
    <style>
        /*获取h1标题标签*/
        h1{
            /*设置h1居中显示*/
            text-align: center;
        }
        /*获取hr标签*/
        hr{
            /*设置颜色*/
            color: orange;
        }
        /*获取id是redColor的标签*/
        #redColor{
            color: red;
        }
        /*获取class是bi的标签*/
        .bi{
            /*加粗*/
            font-weight: bold;
            /*斜体*/
            font-style: italic;
        }
    </style>
</head>
<body>
<!--<h1 align="center">公司简介</h1>-->
<h1>公司简介</h1>
<hr />
<p>
&emsp;&emsp;<span id="redColor">“中关村黑马程序员训练营”</span> 是由<span class="bi">传智播客</span>联合中关村软件园、CSDN， 并委托传智播客进行教学实施的软件开发高端培训机构，致力于服务各大软件企业，解决 当前软件开发技术飞速发展， 而企业招不到优秀人才的困扰。
目前，“中关村黑马程序员训练营”已成长为行业“学员质量好、课程内容深、企业满意”的移动开发高端训练基地， 并被评为 中关村软件园重点扶持人才企业。
</p>
<p>
&emsp;&emsp;黑马程序员的学员多为大学毕业后，有理想、有梦想，想从事IT行业，而没有环境和机遇改变自己命运的年轻人。 黑马程 序员的学员筛选制度，远比现在90%以上的企业招聘流程更为严格。任何一名学员想成功入学“黑马程序员”， 必须经历长达2 个月的面试流程，这些流程中不仅包括严格的技术测试、自学能力测试，还包括性格测试、压力测试、 品德测试等等测试。毫 不夸张地说，黑马程序员训练营所有学员都是精挑细选出来的。百里挑一的残酷筛选制度确 保学员质量，并降低企业的用人风 险。
</p>
<p>
&emsp;&emsp;中关村黑马程序员训练营不仅着重培养学员的基础理论知识，更注重培养项目实施管理能力，并密切关注技术革新， 不 断引入先进的技术，研发更新技术课程，确保学员进入企业后不仅能独立从事开发工作，更能给企业带来新的技术体系和理 念。
</p>
<p>
&emsp;&emsp;一直以来，黑马程序员以技术视角关注IT产业发展，以深度分享推进产业技术成长，致力于弘扬技术创新，倡导分享、 开 放和协作，努力打造高质量的IT人才服务平台。
</p>
<hr />
<p style="text-align: center;color: gray;font-size: 12px">
江苏传智播客教育科技股份有限公司<br/>
版权所有Copyright © 2006-2018, All Rights Reserved 苏ICP备16007882
</p>
</body>
</html>
```

## 注册页面案例

### 页面原型

![1577565301570](%E5%89%8D%E7%AB%AF_assets/1577565301570.png)

### 需求分析

![1595744779816](%E5%89%8D%E7%AB%AF_assets/1595744779816.png)

### 案例实现

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>注册页面案例</title>
    <!--
        分析:
        1.给整个body添加一个背景色(米黄色)
        2.创建一个外层的div,设置样式(边框,背景色,尺寸,外边距)
        3.创建一个内层的div,设置样式(尺寸,外边距,字体,字体颜色)
        4.创建一个form表单
        5.在form中创建9*2的表格
        6.给表格中添加元素(文本,input标签,图片)
        7.设置input标签的样式(高度,宽度,边框,边框圆角,颜色)
        8.设置验证码input标签的宽度
        9.设置用户注册案例的样式(边框,背景色,字体颜色,居中,尺寸)
    -->
    <style>
        /*设置外部div的样式*/
        .bigDiv{
            height: 500px;/*高度*/
            width: 800px;/*宽度*/
            border: 10px gray ridge;/*边框*/
            margin: 50px auto;/*外边距*/
            background-color: white;/*背景色*/
        }
        /*设置内部div的样式*/
        .regDiv{
            height: 500px;/*高度*/
            width: 400px;/*宽度*/
            margin: 0px auto;/*外边距*/
            font-family: "楷体";/*字体*/
            color: gray;/*字体颜色*/
            /*border: 1px red solid;*/
        }
        /*设置所有tr的高度*/
        tr{
            height: 50px;
        }
        /*7.设置input标签的样式(高度,宽度,边框,边框圆角,颜色)*/
        input[type="text"],
        input[type="password"],
        input[type="date"],
        input[type="email"]{
            border: 1px solid gray;/*边框*/
            width: 180px;/*宽度*/
            height: 30px;/*高度*/
            border-radius: 15px;/*边框圆角*/
        }
        /*8.设置验证码input标签的宽度*/
        input[name="checkCode"]{
            width: 60px;
        }
        /*9.设置用户注册案例的样式(边框,背景色,字体颜色,居中,尺寸)*/
        input[type="submit"]{
            width: 100px;/*宽度*/
            height: 30px;/*高度*/
            background-color: gold;/*背景色*/
            color: white;/*字体颜色*/
            border: 1px solid gold;/*边框*/
            border-radius: 5px;/*边框圆角*/
        }
    </style>
</head>
<!--1.给整个body添加一个背景色(米黄色)-->
<body style="background-color: beige">
    <!--
        2.创建一个外层的div,设置样式(边框,背景色,尺寸,外边距)
    -->
    <div class="bigDiv">
        <!--3.创建一个内层的div,设置样式(尺寸,外边距,字体,字体颜色)-->
        <div class="regDiv">
            <!--4.创建一个form表单-->
            <form action="#" method="get">
                <!--5.在form中创建9*2的表格-->
                <table>
                    <!--6.给表格中添加元素(文本,input标签,图片)-->
                    <tr>
                        <td>用户名</td>
                        <td>
                            <input type="text" name="username" placeholder="请输入用户名"/>
                        </td>
                    </tr>
                    <tr>
                        <td>密码</td>
                        <td>
                            <input type="password" name="password" placeholder="请输入密码"/>
                        </td>
                    </tr>
                    <tr>
                        <td>邮箱</td>
                        <td>
                            <input type="email" placeholder="请输入邮箱"/>
                        </td>
                    </tr>
                    <tr>
                        <td>姓名</td>
                        <td>
                            <input type="text" name="name" placeholder="请输入姓名"/>
                        </td>
                    </tr>
                    <tr>
                        <td>手机号</td>
                        <td>
                            <input type="text" name="phone" placeholder="请输入手机号"/>
                        </td>
                    </tr>
                    <tr>
                        <td>性别</td>
                        <td>
                            <input type="radio" name="sex" checked="checked"/>男
                            <input type="radio" name="sex" />女
                        </td>
                    </tr>
                    <tr>
                        <td>生日</td>
                        <td>
                            <input type="date" name="birthday"/>
                        </td>
                    </tr>
                    <tr>
                        <td>验证码</td>
                        <td>
                            <input type="text" name="checkCode" placeholder="验证码"/>
                            <%E5%89%8D%E7%AB%AF_assets src="%E5%89%8D%E7%AB%AF_assets/checkCode.bmp">
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center">
                            <input type="submit" value="用户注册"/>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
    </div>
</body>
</html>
```

# JavaScript

## JavaScript基础语法

### JavaScript的引入方式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JS两种引入方式</title>
    <!--
        JS两种引入方式:在html中如何使用js
        1.内嵌式(内部脚本):在html中创建一个script标签,在标签中写js代码
            格式:
                <script type="text/javascript">
                    js代码;
                </script>
        2.外联式(外部脚本):新建一个以.js结尾的文件,在文件中写js代码
            在html页面中使用script标签引入外部的js文件
            一个js文件可以被多个html页面同时引入
            格式:
                <script type="text/javascript" src="外部js文件的路径"></script>
        注意:
            1.如果script标签引入了外部js文件,那么标签中就不能写js代码了,会失去作用
                如果想要再写js代码,需要重新创建一个script
            2.理论上script标签可以写在html页面中的任意位置,在不影响功能的前提下,尽量把script标签
                写在页面的下边,让浏览器先解析出页面,给用户展示,在执行js的代码(页面显示速度快)
    -->
    <!--1.内嵌式(内部脚本)-->
    <script type="text/javascript">
        //全局函数alert(数据);可以在页面中弹出一个对话框,输出指定的数据
        alert(1);
    </script>
    <!--2.外联式(外部脚本)-->
    <script src="js/1.js"></script>
</head>
<body>

</body>
</html>
```

1.js文件

```javascript
alert("你好");
```

![1595747936050](%E5%89%8D%E7%AB%AF_assets/1595747936050.png)

![1595747966444](%E5%89%8D%E7%AB%AF_assets/1595747966444.png)

### JS三种输出方式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JS三种输出方式</title>
</head>
<body>
    <script>
        //JS三种输出方式
        //1.把数据输出到浏览器的控制台
        console.log("hello");
        //2.输出到html页面的body中
        document.writeln("200");
        //3.浏览器弹出对话框输出
        alert("你好");
    </script>
</body>
</html>
```

![1595748269794](%E5%89%8D%E7%AB%AF_assets/1595748269794.png)

### js的基本语法_变量

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js的基本语法_变量</title>
    <script>
        /*
            js的基本语法_变量
            java语言:强类类型的语言,在使用每种数据类型之前,必须先明确变量的数据类型
                int a = 10;
                double d =1.1;
            js语言:弱类型语言,在使用每种数据的时候,都可以使用var(es5)|let(es6)关键字来接收数据
                给变量赋什么类型的值,那么这个变量就是什么类型
            定义变量
                var 变量名; 变量没有赋值,有默认值undefined
                let 变量名; 变量没有赋值,有默认值undefined
            定义变量的同时,给变量进行初始化赋值:
                var 变量名 = 数据值;
                let 变量名 = 数据值;
            在js中还可以定义常量:常量的值是不能改变的
                const 常量名 = 数据值;
        */
        var a;
        //alert(a);//undefined

        var i = 10;
        //alert(i);//10

        var d = 1.1;
        //alert(d);

        var b = true;
        //alert(b);//true

        var str = "你好";
        //alert(str);//你好

        var c = 'abc';//在js中没有字符类型的,单引号包裹的也是字符串
        //alert(c);//abc

        /*
            var和let的区别(了解)
            var:作用域在这个script标签中都有效(作用域大)
            var:可以先使用变量,在定义变量

            let:只在局部的位置有效(局部变量)
            let:必须先定义后使用
         */
        for(var i=0; i<10; i++){
            //alert(i);
        }
        //alert(i);//10 i可以继续使用

        for(let a=0; a<10; a++){
            //alert(a);
        }
        //alert(a);//undefined a出了作用域就不能在继续使用了

        //alert(aa);//undefined aa定义完了没有赋值
        var aa = 100;

        alert(bb);
        let bb = 200;//ReferenceError: can't access lexical declaration `bb' before initialization
    </script>
</head>
<body>

</body>
</html>
```

### JS数据类型简介

#### 基本数据类型

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JS基本数据类型</title>
    <script>
        /*
            JS基本数据类型
            undefined类型:只有一个值undefined,变量定义未赋值默认值
            null类型:只有一个值null,undefined类型就是使用null演化而来
            number类型:所有的整数和小数
            string类型:所有被单引号和双引号包裹的字符串
            boolean类型:只有两个值true和false

            关键字typeof:可以查看变量的数据类型
        */
        //alert(undefined==null);//true

        var a;
        //alert(a)//默认值: undefined
        //alert(typeof a);//类型: undefined

        var b = 10;
        //alert(b);//10
        //alert(typeof b);//类型: number

        var c = 1.1;
        //alert(c);//1.1
        //alert(typeof c);//类型: number

        var d = true;
        //alert(d);//true
        //alert(typeof d)//类型: boolean

        var str = "abc";
        alert(str);//abc
        alert(typeof str);//类型: string
    </script>
</head>
<body>

</body>
</html>
```

#### 引用数据类型

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JS引用数据类型</title>
    <script>
        /*
            JS引用数据类型
            java语言:面向对象的编程语言,先定义类,根据类创建对象,调用对象的方法
            js语言:基于对象的编程语言,在js中没有类,里边使用的对象都是使用函数模拟出来的,包含了一些内置对象
                var obj = new Object();
                var str = new String("字符串");
                var date = new Date();
                注意:所有的对象都是object对象
         */
        var obj = new Object();
        //alert(obj);//[object Object]
        //alert(typeof obj);//类型: object
        //Object对象可以直接使用属性赋值
        obj.name = "张三";
        obj.age = 18;
        obj.sex = "男";
        console.log(obj);//Object { name: "张三", age: 18, sex: "男" }
        //使用对象名.属性名,获取属性值
        //alert(obj.name);//张三

        var str1 = new String();
        //alert(str1);//""
        //alert(typeof str1);//object

        var str2 = new String("abc");
        //alert(str2);//abc
        //alert(typeof str2);//object

        var date = new Date();
        alert(date);//Sun Jul 26 2020 15:59:03 GMT+0800
        alert(typeof date);//object
    </script>
</head>
<body>

</body>
</html>
```

### js的基本语法_运算符

 **注意:除了以下运算符,其他运算符和java中一致**

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JS的运算符</title>
    <script>
        /*
            算术运算符
         */
        //alert(5/2);//2.5
        //alert("5"+5);//字符串连接55
        //在js中计算的时候,会把字符串的整数转换为整数参与计算
        //alert("5"-5);//0
        //alert("5"*5);//25
        //alert("5"/5);//1
        //alert("5"%5);//0

        //alert("a"/5);//NaN not number:无效数字

        /*
            比较运算符:
                ==:比较的是两个数的值是否相等
                ===:比较的是两个数的值和数据类型是否相等
         */
        alert("5"==5);
        alert("5"===5);
    </script>
</head>
<body>

</body>
</html>
```

### js的基本语法_js的布尔运算规则(了解)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js的基本语法_js的布尔运算规则</title>
    <script>
        /*
            js的基本语法_js的布尔运算规则
            可以使用一些非布尔类型的值,作为布尔值来使用
            boolean类型: true:真  false:假
            undefined类型: 作为false
            null类型:作为false
            string类型: ""空字符串作为false,非空的字符串作为true
            number类型: 0|0.0作为false使用,非0的数字作为true
            object类型: 所有的对象都可以作为true
         */
        var a = Date();
        if(a){
            alert("你猜猜我能出现吗?")
        }
    </script>
</head>
<body>

</body>
</html>
```

### js的基本语法_JS中的语句

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js的基本语法_JS中的语句</title>
    <script>
        //js中的常用语句,大部分和java一样
        //if语句
        var a = 10;
        if(a>10){
            console.log("a大于10");
        }else if(a<10){
            console.log("a小于10");
        }else{
            console.log("a等于10");
        }

        //switch语句
        var b = 8;
        switch (b){
            case 1:
                console.log("星期一");
                break;
            case 2:
                console.log("星期二");
                break;
            case 3:
                console.log("星期三");
                break;
            case 4:
                console.log("星期四");
                break;
            case 5:
                console.log("星期五");
                break;
            case 6:
                console.log("星期六");
                break;
            case 7:
                console.log("星期日");
                break;
            default:
                console.log("您输入的有误");
                break;
        }
        //while循环:条件成立执行
        var c = 1;
        while (c<=5){
            console.log(c);
            c++;
        }
        console.log("----------------------------");
        //do while循环:无论条件是否成立,最少会执行一次
        var d = 5;
        do{
            console.log(d);
            d++;
        }while (d<5);
        console.log("----------------------------");
        //普通for循环
        for(var i=0; i<=5; i++){
            console.log(i);
        }
        console.log("----------------------------");
        /*
            增强for循环
            java中:用于遍历数组和集合
                for(数据类型 变量名: 数组|集合){
                    System.out.println(变量名);
                }
            js中:用于遍历数组,在js中是没有集合的
                forin格式:获取的是数组的索引
                    for(var|let 索引 in 数组){
                        console.log(数组[索引]);
                    }
                forof格式:获取的是数组中的元素
                    for(var|let 变量名 of 数组){
                        console.log(变量名);
                    }
         */
        //定义一个数组
        var arr = [1,2,3,"a","b","c",true,false,1.1,2.2,3.3];
        //使用普通for循环遍历数组
        for(var i=0; i<arr.length; i++){
            console.log(arr[i]);
        }
        console.log("----------------------------");
        //使用增强for循环遍历数组
        //forin格式:获取的是数组的索引
        for(var index in arr){
            //console.log(index);//索引0,1,2,3,4....10
            console.log(arr[index]);
        }
        console.log("----------------------------");
        //forof格式:获取的是数组中的元素
        for(var s of arr){
            //console.log(s);
            alert(s);
        }
    </script>
</head>
<body>

</body>
</html>
```

### 案例:九九乘法表

![1577653877699](%E5%89%8D%E7%AB%AF_assets/1577653877699.png)

```java
package demo01;

public class Demo01 {
    public static void main(String[] args) {
        //99乘法表
        for (int i = 1; i <=9 ; i++) {
            for (int j = 1; j <=i ; j++) {
                System.out.print(j+"*"+i+"="+(i*j)+"\t");
            }
            System.out.println();
        }
    }
}
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>案例九九乘法表</title>
    <script>
        //在页面中创建一个table表格
        document.write("<table border='1px' width='80%' cellspacing='0px' cellpadding='0px'>");
        //在表格中输出一个标题
        document.write("<caption>九九乘法表</caption>");
        //定义外层的for循环,控制打印的行数
        for(var i=1; i<=9; i++){
            //在表格中创建tr
            document.write("<tr>");
            //定义内层for循环,控制每行打印几列
            for(var j=1; j<=i; j++){
                //在行中创建列,输出口诀
                document.write("<td>"+j+"*"+i+"="+(j*i)+"</td>")
            }
            document.write("</tr>");
        }
        document.write("</table>");
    </script>
</head>
<body>
    <!--<table border="1px" width="80%" cellspacing="0px" cellpadding="0px">
        <caption>九九乘法表</caption>
        <tr>
            <td>1-1</td>
            <td>1-2</td>
            <td>1-3</td>
        </tr>
    </table>-->
</body>
</html>
```

### Js代码调试

![1577650047625](%E5%89%8D%E7%AB%AF_assets/1577650047625.png)

### 函数(重点) 

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js中的函数</title>
    <script>
        /*
            js中的函数:就相当于java中的方法
            定义函数使用关键字function(函数)
            1.普通函数
            定义格式:
                function 函数名(参数列表){
                    函数体;
                    return 返回值;
                }
            注意:
                1.函数是没有返回值类型的,在函数中写return就有返回值,不写return没有返回值
                2.只写return,不写具体的返回值,return的作用就是结束函数
                3.函数的参数列表,不能写数据类型,直接写变量名即可
                    (var a,var b) 错误  (a,b)正确
            使用格式:
                有返回值的函数:
                    var 变量 = 函数名(参数);
                没有返回值的函数
                    函数名(参数);
         */
        //定义一个计算两个整数和的函数
        function sum(a,b) {
            document.write(a+b);
        }
        //调用函数
        //sum(10,20);

        function sum2(a,b) {
            return a+b;
            //return true;
        }
        var s = sum2(10,20);
        document.writeln("s:"+s);
        document.write("<br/>");

        //定义一个函数,参数使用可变参数,底层就是一个数组
        function method(...arr) {
            //数组中元素进行累加求和
            var ss = 0;
            for(var a of arr){
                //累加求和
                ss +=a;
            }
            //把和返回
            return ss;
        }

        var sss = method(10,20,30,40,50,60);
        document.write("sss:"+sss);
        document.write("<br/>");
        
        /*
            2.匿名函数:没有名字的函数
            定义格式:
                 function (参数列表){
                    函数体;
                    return 返回值;
                }
            使用格式:
               1.可以把匿名函数赋值给一个变量,变量名就相当于是函数的名字,通过变量名就可以调用函数
               2.在js中有一些函数的参数需要传递其他的函数,就可以使用匿名函数传递(定时器)
         */
        //定义一个计算两个小数和的方法
        var cc = function (a,b) {
            return a+b;
        }
        //调用匿名函数
        var ccc = cc(1.1,2.2);
        document.write(ccc);
    </script>
</head>
<body>

</body>
</html>
```

### js中的事件

#### a.事件概述

js的事件是js不可或缺的组成部分，要学习js的事件，必须要理解如下几个概念：

1. 事件源：被监听的html元素
2. 事件：某类动作，例如点击事件，移入移出事件，敲击键盘事件等
3. 事件与事件源的绑定：在事件源上注册上某事件
4. 事件触发后的响应行为：事件触发后需要执行的代码，一般使用函数进行封装 

#### b.常用的事件

| **事件名**      | **描述**                                      |
| --------------- | --------------------------------------------- |
| **onload**      | 某个页面或图像被完成加载                      |
| **onsubmit**    | 当表单提交时触发该事件---注意事件源是表单form |
| **onclick**     | 鼠标点击某个对象                              |
| ondblclick      | 鼠标双击某个对象                              |
| **onblur**      | 元素失去焦点                                  |
| **onfocus**     | 元素获得焦点                                  |
| **onchange**    | 用户改变域的内容                              |
| onkeydown       | 某个键盘的键被按下                            |
| onkeypress      | 某个键盘的键被按下或按住                      |
| onkeyup         | 某个键盘的键被松开                            |
| onmousedown     | 某个鼠标按键被按下                            |
| onmouseup       | 某个鼠标按键被松开                            |
| **onmouseover** | 鼠标被移到某元素之上                          |
| **onmouseout**  | 鼠标从某元素移开                              |
| onmousemove     | 鼠标被移动                                    |

#### c.事件的基本使用

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js中的事件(非常重要)</title>
    <script>
        function butOnclick() {
            //事件的处理逻辑
            alert("就点你咋地!");
        }

        //定义图片鼠标移入事件的响应函数
        function %E5%89%8D%E7%AB%AF_assetsOnmouseover() {
            alert("鬼子又来抢花姑娘了!");
        }

        //定义文本框获取焦点事件的响应函数
        function textOnfocus() {
            alert("haha");
        }
    </script>
</head>
<body>
    <!--按钮发生了点击事件-->
    <input type="button" value="没事别点我" onclick="butOnclick()"/>
    <!--图片鼠标移入事件-->
    <%E5%89%8D%E7%AB%AF_assets src="%E5%89%8D%E7%AB%AF_assets/1.jpg" width="150px" height="200px" onmouseover="%E5%89%8D%E7%AB%AF_assetsOnmouseover()">
    <!--文本获取焦点事件-->
    <input typeof="text" placeholder="请输入你想输入的内容" onfocus="textOnfocus()"/>
</body>
</html>
```

#### d.页面加载事件

当用户进入或离开页面的时候, 就会触发JavaScript函数, 比方说, onload事件常被用来处理用户进入或离开时所建立的cookies

```html
<script>
    /*
            js中的页面加载事件
            onload 某个页面或图像被完成加载
            把body中的内容全部显示完毕,在执行页面加载函数中的代码
            让页面先显示出来,在执行函数
         */
    //alert(1);

    //定义页面加载事件的响应函数
    function bodyOnload() {
        alert(1);
    }

    //页面加载事件的第二种写法
    window.onload = function () {
        alert(2);
    }
</script>
```

## JS如何定义对象

#### 基于已有的对象扩充其属性和方法

```js
<script type="text/javascript">
var object = new Object();
object.name = "zhangsan";
object.sayName = function(name){
       this.name = name;
       alert(this.name);
}
object.sayName("lisi");
</script>
```

弊端：这种对象的可复用性不强，如果需要使用多个对象，还需要重新扩展其属性和方法



#### 用var关键字定义对象

JavaScript用一个{…}表示一个对象，键值对以xxx: xxx形式申明，用,隔开。

```js
<script>
  var wujunnan = {
    name:'武俊男',
    gender:'男',
    age:18,
    //要求属性名必须是一个有效的变量名。如果属性名包含特殊字符，就必须用''括起来
    //而且访问的时候，也不能再使用 . ，只能使用[]进行访问
    //实际上JavaScript对象的所有属性都是字符串，不过属性对应的值可以是任意数据类型
    'middle-shool':'郑州回中',
    presentation(){
      //如果不加this会怎么样？
      alert('我叫'+this.name+'，性别'+this.gender+'，今年'+wujunnan.age+'岁了，高中是'+wujunnan['middle-shool']);
    }
  }
//这个括号必须加
wujunnan.presentation();
alert(wujunnan.name);
//如果访问不存在的数据类型，那么返回的是undefined类型
alert(wujunnan.wife);//undefined
//JS是动态语言，对象的属性可以自由的添加或者删除
//添加属性
wujunnan.wife='she';
alert(wujunnan.wife);//she
//删除属性
delete wujunnan.wife;
alert("删除后的效果"+wujunnan.wife);//undefine
//判断一个对象是否具有某个属性,不过要小心，如果in判断一个属性存在，这个属性不一定是本身的，它可能是继承得到的
alert('name' in wujunnan);//true
//如何对对象进行遍历
for (let i in wujunnan) {
  document.write(i+':'+wujunnan[i]+"<br>");
}
</script>
```

遍历后打印出来的内容，将注释也打印出来了

```
name:武俊男
gender:男
age:18
middle-shool:郑州回中
presentation:presentation(){ //如果不加this会怎么样？ alert('我叫'+this.name+'，性别'+this.gender+'，今年'+wujunnan.age+'岁了，高中是'+wujunnan['middle-shool']); }
```







## 常用内置对象

#### 1.字符串String

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>字符串String</title>
    <script>
        /*
            字符串String
            String 对象用于处理文本（字符串）。
            String对象中定义了一些处理字符串的函数
            创建对象的方式:
            1. var str = new String("字符串");
            2. var str = "字符串";
            3. var str = '字符串';
            4. var str = `字符串`;使用反向单引号创建字符串,可以使用${}引用其他字符串对象
         */
        //1. var str = new String("字符串");
        var str1 = new String("abc");
        //alert(str1);//abc
        //alert(typeof str1);//类型: obejct

        //2. var str = "字符串";
        var str2 = "a-b-c";
        //alert(str2);//a-b-c
        //alert(typeof str2);//类型: string

        //3. var str = '字符串';
        var str3 = 'abc';
        //alert(str3);//abc
        //alert(typeof str3);//类型: string

        //4. var str = `字符串`;使用反向单引号创建字符串,可以使用${}引用其他字符串对象
        var str4 = `hello${str2}`;
        //alert(str4);//helloa-b-c

        //属性:length 字符串的长度
        //alert(str1.length);//3
        //alert(str2.length);//5
        //alert(str3.length);//3
        //alert(str4.length);//10

        //函数:charAt() 返回在指定索引的字符。
        //alert("a-b-c".charAt(0));//a
        //alert("a-b-c".charAt(1));//-

        //使用length属性和charAt方法遍历字符串
        for(var i=0; i<str2.length; i++){
            //alert(str2.charAt(i));
        }

        //函数:concat() 连接字符串
        //alert(str1.concat(str2));//abca-b-c
        //alert(str1+str2);//abca-b-c

        /*
            函数:indexOf() 在字符串中从前往后查找另一个字符串的索引
                找到了,返回对应的索引
                找不到,返回-1
            函数:lastIndexOf() 在字符串中从后往前查找另一个字符串的索引
                找到了,返回对应的索引
                找不到,返回-1
         */
        //alert("a-b-c".indexOf("-"));//1
        //alert("a-b-c".indexOf("w"));//-1
        //alert("a-b-c".lastIndexOf("-"));//3

        /*
            函数:toLowerCase() 把字符串转换为小写。
            函数:toUpperCase() 把字符串转换为大写。
         */
        //alert("AAA".toLowerCase());//aaa
        //alert("safdsa1231ASFDAS".toUpperCase());//SAFDSA1231ASFDAS

        /*
            函数:substring(开始索引,结束索引): 截取两个索引之间的字符,包含头,不包含尾
            a-b-c==> -b-
         */
        //alert("a-b-c".substring(1,4));//-b-

        //函数:substr(开始索引) 从开始索引截取到字符串默认
        //-b-c
        //alert("a-b-c".substr(1));//-b-c

        //函数:substr(开始索引,字符个数) 截取从开始索引到指定字符个数内容
        //a-b-c==> -b-
        alert("a-b-c".substr(1,3));//-b-
    </script>
</head>
<body>

</body>
</html>
```

#### 2.数组Array

##### 数组的基本创建

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>数组的基本使用</title>
    <script>
        /*
            Array 对象
                Array 对象用于在单个的变量中存储多个值。
                在js中是没有集合的,可以使用数组作为集合使用,Array数组长度是可以变化的,可以存储任意数据类型的数据
                相当于java中的集合,泛型是Object  ArrayList<Object>
            创建 Array 对象的语法：
            1.var arr = new Array(); 创建一个长度为0的数组
            2.var arr = new Array(size); 创建指定长度的数组,数组中的元素有默认值undefined
            3.var arr = new Array(element0, element0, ..., elementn); 创建包含指定元素的数组
            4.var arr = [element0, element0, ..., elementn]; 创建包含指定元素的数组
         */
        //1.var arr = new Array(); 创建一个长度为0的数组
        var arr1 = new Array();
        console.log(arr1.length);//0
        console.log(arr1);//Array [  ]

        //往数组中添加元素
        arr1[0] = "a";
        arr1[1] = 1;
        arr1[5] = 100;
        console.log(arr1.length);//6
        console.log(arr1);//Array [ "a", 1, undefined,undefined ,undefined , 100 ]
        //alert(arr1);//a,1,,,,100
        //alert(arr1[3]);//undefined

        //2.var arr = new Array(size); 创建指定长度的数组,数组中的元素有默认值undefined
        var arr2 = new Array(10);
        //alert(arr2.length);//10
        //alert(arr2);//,,,,,,,,,

        arr2[5] = 88;
        //alert(arr2);//,,,,,88,,,,

        //3.var arr = new Array(element0, element0, ..., elementn); 创建包含指定元素的数组
        var arr3 = new Array(1,2,3,true,false,1.1,2.2,"aaa","bbb","ccc");
        //alert(arr3.length);//10
        //alert(arr3);//1,2,3,true,false,1.1,2.2,aaa,bbb,ccc

        //4.var arr = [element0, element0, ..., elementn]; 创建包含指定元素的数组
        var arr4 = [1,2,3,true,false,1.1,2.2,"aaa","bbb","ccc"];
        //alert(arr4.length);//10
        //alert(arr4);//1,2,3,true,false,1.1,2.2,aaa,bbb,ccc

        /*
            二维数组:数组中的元素仍是一个数组
         */
        var arrArr = [
            [1,2,3],
            ["a","b","c"],
            [true,false]
        ];
        //alert(arrArr.length);//3
        //alert(arrArr[1]);//a,b,c
        //alert(arrArr[1][2]);//c

        //遍历二维数组,获取里边的每一个元素(一维数组)
        for(var arr of arrArr){
            for(var a of arr){
                console.log(a);
            }
        }

    </script>
</head>
<body>

</body>
</html>
```

##### 数组中的常用方法

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>数组中的常用方法</title>
    <script>
        /*
            要求能够查询w3c手册完成如下功能
            1. 创建数组 []
            2. 数组合并 concat(数组)
            3. 添加元素
                数组头添加 unshift
                数组尾添加 push
            4. 删除元素
                数组头删除 shift
                数组尾删除 pop
            5. 数组元素拼接为字符串 join(分隔符)
            6. 排序数组元素 sort() 对数组的元素进行排序,默认是升序排序
         */
        //1. 创建数组 []
        var arr1 = ["a","b","c"];
        var arr2 = [1,2,3];
        //2. 数组合并 concat(数组)
        console.log(arr1.concat(arr2));//Array [ "a", "b", "c", 1, 2, 3 ]

        //数组头添加 unshift
        arr1.unshift("头部");
        console.log(arr1);//Array [ "头部", "a", "b", "c" ]
        //数组尾添加 push
        arr1.push("尾部");
        console.log(arr1);//Array [ "头部", "a", "b", "c", "尾部" ]

        //数组头删除 shift
        arr1.shift();
        console.log(arr1);//Array [ "a", "b", "c", "尾部" ]
        //数组尾删除 pop
        arr1.pop();
        console.log(arr1);//Array [ "a", "b", "c" ]

        //5. 数组元素拼接为字符串 join(分隔符)
        console.log(arr1.join("-"));//a-b-c
        console.log(arr1.join(","));//a,b,c

        var arr3 = [1,5,4,3,2];
        //6. 排序数组元素 sort() 对数组的元素进行排序,默认是升序排序
        console.log("排序前:"+arr3);//排序前:1,5,4,3,2
        console.log("排序后:"+arr3.sort());//排序后:1,2,3,4,5

        //sort(函数()) 根据函数中写的规则排序
        console.log("排序后:"+arr3.sort(function (a,b) {
            return a-b;//升序
        }));//排序后:1,2,3,4,5

        console.log("排序后:"+arr3.sort(function (a,b) {
            return b-a;//降序
        }));//排序后:5,4,3,2,1
    </script>
</head>
<body>

</body>
</html>
```

#### 3.日期Date

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>日期Date</title>
    <script>
        /*
            日期Date
                Date 对象用于处理日期和时间。
            创建 Date 对象的语法：
                var myDate=new Date();
            常用的方法:
                getFullYear() 从 Date 对象以四位数字返回年份。
                getMonth() 从 Date 对象返回月份 (0 ~ 11)。
                getDate() 从 Date 对象返回一个月中的某一天 (1 ~ 31)。
                getHours() 返回 Date 对象的小时 (0 ~ 23)。 1 3
                getMinutes() 返回 Date 对象的分钟 (0 ~ 59)。 1 3
                getSeconds() 返回 Date 对象的秒数 (0 ~ 59)。 1 3
                getMilliseconds() 返回 Date 对象的毫秒(0 ~ 999)。 1 4
                getTime() 返回 1970 年 1 月 1 日至今的毫秒数。
                toLocaleString() 根据本地时间格式，把 Date 对象转换为字符串。
         */
        var d =new Date();
        //alert(d);//Mon Jul 27 2020 11:55:28 GMT+0800

        //alert(d.getFullYear()+"年"+(d.getMonth()+1)+"月"+d.getDate()+"日");
        //alert(d.getHours()+"时"+d.getMinutes()+"分"+d.getSeconds()+"秒"+d.getMilliseconds()+"毫秒");
        //alert(d.getTime());//1595822392760
        alert(d.toLocaleString());//2020/7/27 下午12:00:24
    </script>
</head>
<body>

</body>
</html>
```

#### 4.数学运算Math 

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>数学运算Math </title>
    <script>
        /*
            数学运算Math
            Math 对象用于执行数学任务。
            Math类中的属性和方法可以直接通过Math.属性|Math.方法名(参数)直接使用==>java中静态的成员
            属性:
                PI 返回圆周率（约等于3.14159）。
            方法:
                ceil(x) 向上取整
                floor(x) 向下取整
                round(x) 四舍五入
                pow(x,y) 返回 x 的 y 次幂
                random() 返回 0 ~ 1 之间的随机数。
         */
        console.log(Math.PI);//3.141592653589793
        console.log(Math.ceil(5.999999));//6
        console.log(Math.ceil(5.0000001));//6
        console.log(Math.floor(5.999999));//5
        console.log(Math.floor(5.0000001));//5
        console.log(Math.round(5.55));//6
        console.log(Math.round(5.4999999));//5
        console.log(Math.pow(2,3));//8
        console.log(Math.random());//0.9070583248568889
        //获取[1-10]之间的随机数 Math.random()==>[0,1)*10==>[0,10)+1==>[1,10]
        for(var i=0; i<10; i++){
            console.log(Math.floor(Math.random()*10+1));
        }
    </script>
</head>
<body>

</body>
</html>
```

#### 5.RegExp(正则表达式)

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>RegExp(正则表达式)</title>
    <script>
        /*
            RegExp(正则表达式)
            RegExp 对象表示正则表达式，它是对字符串执行模式匹配的强大工具
            正则表达式本质就是一个包含了某些规则的字符串,用于对其他的字符串进行校验
            需求:校验手机号
            规则:  "1[345789][0-9]{9}"
                1.11位数字
                2.第一位是1
                3.第二位在345789中选择一个
            创建 RegExp 对象的语法：
                var reg = new RegExp("^正则表达式的规则$");
                var reg = /^正则表达式的规则$/;
            RegExp对象常用方法:
                test("要校验的字符串") 判断字符串是否满足正则表达式的规则
                    满足:返回true
                    不满足:返回false
         */
        //创建RegExp对象
        var reg = /^1[345789][0-9]{9}$/;
        //调用正则表达式中的方法test,对手机号进行校验
        console.log(reg.test("13888888888"));//true
        console.log(reg.test("138888888881"));//false
        console.log(reg.test("12888888888"));//false

        /*
            了解:String对象中正则表达式相关的方法
            match(正则表达式) 判断字符串是否匹配正则表达式的规则
                匹配成功:返回字符串本身
                匹配失败:返回null
         */
        console.log("13888888888".match(reg));//Array [ "13888888888" ]
        console.log("138888888a8".match(reg));//null
    </script>
</head>
<body>

</body>
</html>
```

#### 6.全局函数

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>js的全局函数</title>
    <script>
        /*
            全局函数:在script标签中可以直接使用的函数
            1. 字符串转为数字
                parseInt();//字符转为整数数字,从左到右遇到非数字停止
                parseFloat();//字符转为小数数字,从左到右遇到非数字停止
                isNaN();//判断非数字,非数字返回true,是数字返回false
            2. 对数据进行加密
                encodeURI() 把字符串编码为 URI。
            3. 对加密数据进行解密
                decodeURI() 解码某个编码的 URI。
            4. 把字符串当做js表达式来执行
                eval() 计算 JavaScript 字符串，并把它作为脚本代码来执行
         */
        //1. 字符串转为数字
        var a = parseInt("11a11");
        console.log(a+1);//12

        var b= parseFloat("1.1afdsaf22");
        console.log(b+100);//101.1

        //2. 对数据进行加密
        var str = "明天下午两点去偷地瓜";
        console.log("原字符串:"+str);//原字符串:明天下午两点去偷地瓜
        var enStr = encodeURI(str);
        console.log("加密后字符串:"+enStr);//加密后字符串:%E6%98%8E%E5%A4%A9%E4%B8%8B%E5%8D%88%E4%B8%A4%E7%82%B9%E5%8E%BB%E5%81%B7%E5%9C%B0%E7%93%9C

        //3. 对加密数据进行解密
        var deStr = decodeURI(enStr);
        console.log("解密后字符串:"+deStr);//解密后字符串:明天下午两点去偷地瓜

        //4. 把字符串当做js表达式来执行 eval() 计算 JavaScript 字符串，并把它作为脚本代码来执行
        var aaa = "1+5*10-20";
        var bbb = eval(aaa);
        console.log(aaa);//1+5*10-20
        console.log(bbb);//31

        //isNaN();//判断非数字,非数字返回true,是数字返回false
        console.log(isNaN("aa"));//true
        console.log(isNaN("11"));//false
    </script>
</head>
<body>

</body>
</html>

```

## BOM对象

- BOM(browser Object Model)浏览器对象模型
- JS把浏览器抽象成为一些对象,运行我们使用js来模拟浏览器的行为.

### screen对象

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>screen对象</title>
    <script>
        /*
            screen对象
            Screen 对象包含有关客户端显示屏幕的信息。
            属性:
                height 返回显示屏幕的高度。
                width 返回显示器屏幕的宽度。
            screen对象中的属性,可以通过screen.属性名直接使用
         */
        alert(screen.width+"*"+screen.height);
    </script>
</head>
<body>

</body>
</html>
```

### navigator对象

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>navigator对象</title>
    <script>
        /*
            navigator对象
            navigator 对象包含有关浏览器的信息。
            属性:
                appName 返回浏览器的名称。
                appVersion 返回浏览器的平台和版本信息
           navigator对象中的属性,可以通过navigator.属性名直接使用
         */
        alert(navigator.appName);//Netscape(网景)
        alert(navigator.appVersion);//5.0 (Windows)
    </script>
</head>
<body>

</body>
</html>
```

### history对象

03_history对象.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>history对象</title>
    <script>
        /*
            history对象
            History 对象包含用户（在浏览器窗口中）访问过的 URL。
            History 对象是 window 对象的一部分，可通过 window.history 属性对其进行访问。
            函数:
                back() 加载 history 列表中的前一个 URL。
                forward() 加载 history 列表中的下一个 URL。

         */
        //创建鼠标点击事件的响应函数
        function goBack() {
            window.history.back();
        }
        function goForward() {
            window.history.forward();
        }
    </script>
</head>
<body>
    <input type="button" value="上一步" onclick="goBack()"/>
    <input type="button" value="下一步" onclick="goForward()"/>
    <a href="04_history对象.html">跳转到04_history对象.html</a>
</body>
</html>
```

04_history对象.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>history对象</title>
    <script>
        //创建鼠标点击事件的响应函数
        function goBack() {
            window.history.back();
        }
    </script>
</head>
<body>
    <input type="button" value="上一步" onclick="goBack()"/>
    <h1>我是一个新的页面</h1>
</body>
</html>
```

### Window 对象

#### 弹框的方法

1. 提示框：alert(提示信息);
2. 确认框：confirm(提示信息);
3. 输入框：prompt(提示信息);

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>window对象_弹框方法</title>
    <script>
        /*
            window对象
            window 对象表示浏览器中打开的窗口。
            弹框方法(函数)
                1. 提示框：alert(提示信息);
                2. 确认框：confirm(提示信息);
                3. 输入框：prompt(提示信息);
            注意:
                使用window对象中的属性和方法,可以省略对象名,直接写方法名和对象名
         */
        /*
            1. 提示框：alert(提示信息);
            在页面中弹出一个对话框,可以输出一些数据
         */
        //window.alert("hello");
        //alert("hello");

        /*
            2. 确认框：confirm(提示信息);
            在页面中弹出一个确认框,让用户进行选择
            返回值:
                点击确定,返回true,执行一些操作
                点击取消,返回false,取消一些操作
         */
        //var con = confirm("您确定要删除吗?");
        //alert(con);

        /*
            3. 输入框：prompt(提示信息);
            在页面中弹出一个输入框,可以让用户输入一些数据
            比如:可以输入二次密码(登录密码,支付密码)
            返回值:
                点击确定,返回输入的内容,根据用户输入的内容进行一些操作
                点击取消,返回null
         */
        var pro = prompt("请输入您的支付密码:");
        alert(pro);
    </script>
</head>
<body>

</body>
</html>
```

![1595986717137](%E5%89%8D%E7%AB%AF_assets/1595986717137-1596036966235.png)

#### 定时器

```java
1. 返回值 setTimeout(函数,毫秒值); 执行一次的定时器
2. 返回值 setInterval(函数,毫秒值); 反复执行的定时器
参数:
	函数:定义一个有名函数,传递函数名字;或者使用匿名函数
    毫秒值:设置定时器的时间,在指定的时间结束之后,会执行传递的函数
返回值:
	返回的是定时器的id值,可以用于取消定时器使用
3. clearTimeout(定时器的id值);取消执行一次的定时器
4. clearInterval(定时器的id值);取消反复执行的定时器
```

06_window对象_定时器方法.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>window对象_定时器方法</title>
    <script>
        /*
            window对象_定时器方法
            1. 返回值 setTimeout(函数,毫秒值); 执行一次的定时器
            2. 返回值 setInterval(函数,毫秒值); 反复执行的定时器
            参数:
                函数:定义一个有名函数,传递函数名字;或者使用匿名函数
                毫秒值:设置定时器的时间,在指定的时间结束之后,会执行传递的函数
            返回值:
                返回的是定时器的id值,可以用于取消定时器使用
            3. clearTimeout(定时器的id值);取消执行一次的定时器
            4. clearInterval(定时器的id值);取消反复执行的定时器
         */
        //1. 返回值 setTimeout(函数,毫秒值); 执行一次的定时器
        //创建一个函数
        /*function c4() {
            alert("c4爆炸了!")
        }*/

        //创建一个执行一次的定时器,5秒钟之后调用c4函数执行
        //setTimeout(c4,5000);

        //使用匿名函数
        var timeId = setTimeout(function () {
            alert("c4爆炸了!");
        },5000);
        //alert(timeId);//2

        function butOnclick() {
            //3. clearTimeout(定时器的id值);取消执行一次的定时器
            clearTimeout(timeId);
        }
    </script>
</head>
<body>
    <input type="button" value="警察拆除了炸弹" onclick="butOnclick()"/>
</body>
</html>
```

07_window对象_定时器方法.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>window对象_定时器方法</title>
    <script>
        //2. 返回值 setInterval(函数,毫秒值); 反复执行的定时器
        //创建一个反复执行的定时器,每隔2秒钟执行一次
        var interId = setInterval(function () {
            alert("哈哈,你的电脑中毒了!")
        },2000);

        function butOnclick() {
            //4. clearInterval(定时器的id值);取消反复执行的定时器
            clearInterval(interId);
        }
    </script>
</head>
<body>
    <input type="button" value="使用杀毒软件,查杀了病毒" onclick="butOnclick()"/>
</body>
</html>
```

### location对象

```javascript
1. 获取当前浏览器地址
location.href
2. 刷新当前页面
location.reload();
3. 跳转页面:相当于在页面输入地址并敲击回车
location.href = "地址" ;
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>location对象</title>
    <script>
        /*
            location对象
            Location 对象包含有关当前 URL(浏览器的地址) 的信息。
            属性:
                href:获取当前浏览器的url地址
                href = "新的url地址":在浏览器地址栏中输入了地址,并且敲击回车的过程(打开页面)
            方法:
                reload() 重新加载当前文档。 刷新页面
         */
        function getURL() {
            alert(location.href);
        }
        function setURL() {
            location.href = "http://www.baidu.com";
            //location.href = "07_window对象_定时器方法.html";
        }
        function myReload() {
            location.reload();
        }
    </script>
</head>
<body>
    <input type="button" value="获取url" onclick="getURL()"/>
    <input type="button" value="跳转到百度" onclick="setURL()"/>
    <input type="button" value="刷新页面" onclick="myReload()"/>
</body>
</html>
```

### web存储

```java
- HTML5为JS增加了两个可以存储数据的对象
  - localStorage 本地存储 永久存储数据 作用域 所有页面永久访问
  - sessionStorage 会话存储 临时存储数据 作用域 一次会话(连续跳转的几个页面)

- 不管是 localStorage，还是 sessionStorage，可使用的API都相同
- 常用的有如下几个（以localStorage为例）：
      setItem(key,value)  : 存储一个数据
      getItem(key)		: 获取一个数据
      removeItem(key)		: 删除一个数据
      clear()			: (了解)清除所有数据

- localStorage与 sessionStorage二者区别:
  - 存储时间  localStorage永久存储 sessionStorage临时存储
  - 作用域  localStorage所有页面  sessionStorage一次会话(连续跳转的几个页面)


```

11_web存储.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>web存储对象</title>
    <script>
        /*
            web存储对象
              - localStorage 本地存储 永久存储数据 作用域 所有页面永久访问
              - sessionStorage 会话存储 临时存储数据 作用域 一次会话(连续跳转的几个页面)
        */
        //使用localStorage对象存储数据
        localStorage.setItem("userName","张学友");

        //获取localStorage对象中存储的数据
        var v1 = localStorage.getItem("userName");
        //alert("v1:"+v1);//v1:张学友

        //移除localStorage对象存储的数据
        localStorage.removeItem("userName");
        var v2 = localStorage.getItem("userName");
        //alert("v2:"+v2);//v2:null

        function setDate() {
            localStorage.setItem("local1","11");
            localStorage.setItem("local2","22");
            sessionStorage.setItem("session1","33");
            sessionStorage.setItem("session2","44");
        }

        function tiaozhuan() {
            location.href = "11_web存储对象.html";
        }
    </script>
</head>
<body>
    <input type="button" value="存储数据" onclick="setDate()"/>
    <input type="button" value="11_web存储对象.html" onclick="tiaozhuan()"/>
</body>
</html>
```

11_web存储.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>web存储对象</title>
    <script>
        //获取web对象中存储的数据
        alert(localStorage.getItem("local1"));
        alert(localStorage.getItem("local2"));
        alert(sessionStorage.getItem("session1"));
        alert(sessionStorage.getItem("session2"));
    </script>
</head>
<body>

</body>
</html>
```

**注:直接打开页面看不到sessionStorage存储的数据,跳转可以看到**

## DOM对象

### dom简介

![1595991003925](%E5%89%8D%E7%AB%AF_assets/1595991003925-1596036966235.png)

### dom获取元素

- dom获取元素

- 第一种(掌握):es6提供了强大的根据CSS选择器获取元素的接口

  - document.querySelector(CSS选择器) 根据css选择器获取一个元素
  - document.querySelectorAll(CSS选择器) 根据css选择器获取元素对象数组集合

- 根据第一种语法,完成如下功能:

  - 根据Id选择器获取一个元素
  - 根据类选择器获取一个(多个)元素
  - 根据标签选择器获取一个(多个)元素
  - 根据name属性选择器获取一个(多个)元素
  - 根据关系选择器获取一个(多个)元素

- 第二种(了解):es5之前也有获取元素的接口

  - 根据id获取一个元素 document.getElementById(ID) === querySelector(#ID)

  - 根据class获取多个元素 document.getElementsByClassName(class) === querySelectorAll(.class)

  - 根据标签名称获取多个元素 document.getElementsByTagName(标签名称) === querySelectorAll(标签)

  - 根据name属性获取多个元素 

    document.getElementsByName('name值') === querySelectorAll(元素名称[name=name值])

- 小总结

  - es6接口获取元素功能非常强大,而且接口非常易用.
  - es5接口功能非常局限,而且接口使用复杂.

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>10-dom获取元素</title>
</head>
<body>

<form action="#" method="get">
    姓名 <input type="text" name="userName" id="userName" value="邱少云"/> <br/>
    密码 <input type="password" name="userPass"> <br/>
    生日 <input type="date" name="userBirth"><br/>
    性别 <input type="radio" name="gender" value="male" class="radio">男&emsp;
         <input type="radio" name="gender" value="female" class="radio"/>女<br/>
    爱好 <input type="checkbox" name="hobby" value="smoke">抽烟
         <input type="checkbox" name="hobby" value="drink">喝酒
         <input type="checkbox" name="hobby" value="perm">烫头<br/>
    头像 <input type="file" name="userPic"><br/>
    学历
    <select name="userEdu" >
        <option value="0">请选择</option>
        <option value="1">入门</option>
        <option value="2">精通</option>
        <option value="3">放弃</option>
    </select><br/>
    简介
    <textarea name="userIntro"  cols="30" rows="10">默认值</textarea><br/>
    <input type="reset" value="清空按钮"/>
    <input type="submit" value="提交按钮"/><br/>
    <input type="button" value="普通按钮">
    <button>专业按钮</button><button>&times;</button>

</form>
头像 <input type="file" name="userPic"><br/>

<script >
    // 1.根据Id选择器获取一个元素,获取id=userName的标签对象
    var userNameEle = document.querySelector("#userName");
    console.log(userNameEle);//<input type="text" value="邱少云" id="userName" name="userName">
    console.log("---------------------------");

    // 2.根据(class)类选择器获取一个(多个)元素,获取class=radio的标签对象数组
    var radioEleArr = document.querySelectorAll(".radio");
    console.log(radioEleArr.length);//2
    //遍历数组,获取数组中的每一个对象
    for(var radioEle of radioEleArr){
        console.log(radioEle);
        /*
            <input type="radio" class="radio" value="male" name="gender">
            <input type="radio" class="radio" value="female" name="gender">
         */
    }
    console.log("---------------------------");

    // 3.根据标签选择器获取一个(多个)元素,获取所有的option标签对象数组
    var optionEleArr = document.querySelectorAll("option");
    //遍历数组,获取数组中的每一个对象
    for(var optionEle of optionEleArr){
        console.log(optionEle);
        /*
            <option value="0">
            <option value="1">
            <option value="2">
            <option value="3">
         */
    }
    console.log("---------------------------");

    // 4.根据name属性选择器获取一个(多个)元素,获取name=hobby的input标签对象数组
    var hobbyEleArr = document.querySelectorAll("input[name='hobby']");
    //遍历数组,获取数组中的每一个对象
    for(var hobbyEle of hobbyEleArr){
        console.log(hobbyEle);
        /*
            <input type="checkbox" value="smoke" name="hobby">
            <input type="checkbox" value="drink" name="hobby">
            <input type="checkbox" value="perm" name="hobby">
         */
    }
    console.log("---------------------------");

    // 5.根据关系(后代)选择器获取一个(多个)元素,获取文件选择框
    var userPicEle = document.querySelector("form input[name='userPic']");
    console.log(userPicEle);//<input type="file" name="userPic">

    //------------ 华丽丽的分割线 --------
    console.log("-------------es5--------------");
	//第二种(了解):es5之前也有获取元素的接口
    // 1. 根据id获取一个元素,获取id=userName的标签对象
    var userNEle = document.getElementById("userName");
    console.log(userNEle);//<input type="text" value="邱少云" id="userName" name="userName">

    // 2. 根据class获取多个元素
    var rEleArr = document.getElementsByClassName("radio");
    for(var rEle of rEleArr){
        console.log(rEle);
    }

    // 3. 根据标签名称获取多个元素
    var optEleArr = document.getElementsByTagName("option");
    for(var optEle of optEleArr){
        console.log(optEle);
    }

    // 4. 根据name属性获取多个元素
    var hEleArr = document.getElementsByName("hobby");
    for(var hEle of hEleArr){
        console.log(hEle);
    }

</script>
</body>
</html>
```

### dom操作内容

- dom操作内容

  ```html
  1. document.write(html内容) 向body中追加html内容
  2. element.innerText; 获取或者修改元素的纯文本内容
  3. element.innerHTML; 获取或者修改元素的html内容
  4. element.outerHTML; 获取或者修改包含自身的html内容
  
  ```

- 总结:

  ```html
  - innerText 获取的是纯文本  innerHTML获取的是所有html内容
  - innerText 设置到页面中的是纯文本   innerHTML设置到页面中的html会展示出外观效果
  - innerHTML不包含自身 outerHTML包含自身的html内容
  ```

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>dom操作内容</title>
</head>
<body>

<div id="d1">我是d1<br/></div>
<div id="d2">我是d2</div>
<div id="d3">我是d3</div>

<script>
    // 1. 向body中追加html内容
    document.write("<h1>我是h1标题标签</h1>");

    /*
        innerText:只能获取|设置标签中的文本
        innerHTML:可以获取|设置标签体
        outerHTML:可以获取|设置整个标签
     */

    // 2. 获取元素的纯文本,html内容对比
    //获取id是d1的元素 <div id="d1">我是d1<br/></div>
    var d1Ele = document.querySelector("#d1");
    console.log(d1Ele.innerText);//我是d1==>标签中的文本
    console.log(d1Ele.innerHTML);//我是d1<br>==>标签体
    console.log(d1Ele.outerHTML);//<div id="d1">我是d1<br></div>==>整个标签

    // 3. 修改元素的纯文本,html内容对比
    //获取id是d2的元素 <div id="d2">我是d2</div>
    var d2Ele = document.querySelector("#d2");
    //d2Ele.innerText = "<h2>我是h2标签体标签</h2>";//显示纯文本
    d2Ele.innerHTML = "<h2>我是h2标签体标签</h2>";//显示标签

    // 4. 获取或修改包含元素自身的html内容(了解)
    //获取id是d3的元素 <div id="d3">我是d3</div>
    var d3Ele = document.querySelector("#d3");
    console.log(d3Ele.outerHTML);//<div id="d3">我是d3</div>
    d3Ele.outerHTML = "<h3>我是h3标签体标签</h3>";//把d3的div整个替换为了h3标签

</script>

</body>
</html>
```



### dom操作属性

- dom操作属性

  ```html
  1. 给元素设置自定义属性
  语法: element.setAttribute(属性名,属性值) 给元素设置一个属性值,可以设置原生和自定义
  2. 获取元素的自定义属性值
  语法: element.getAttribute(属性名) 获取元素的一个属性值,可以获取原生和自定义
  3. 移除元素的自定义属性
  语法: element.removeAttribute(属性名) 
  
  ```

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>12-dom操作属性</title>
</head>
<body>
	
<form action="#" method="get">
    姓名 <input type="text" name="userName" value="张三"  /> <br/>
    密码 <input type="password" name="userPass" > <br/>
    生日 <input type="date" name="userBirth"><br/>
    性别 <input type="radio" name="gender" value="男" checked="checked">男&emsp;
    <input type="radio" name="gender" value="女"/>女<br/>
    爱好 <input type="checkbox" name="hobby" value="smoke"  checked="checked"/>抽烟
    <input type="checkbox" name="hobby" value="drink" checked="checked"/>喝酒
    <input type="checkbox" name="hobby" value="perm"/>烫头<br/>
    头像 <input type="file" name="userPic"><br/>
    学历
    <select name="userEdu" >
        <option value="0">请选择</option>
        <option value="1">入门</option>
        <option value="2">精通</option>
        <option value="3">放弃</option>

    </select><br/>
    简介
    <textarea name="userIntro"  cols="30" rows="10">默认值</textarea><br/>
    <input type="reset" value="清空按钮"/>
    <input type="submit" value="提交按钮"/><br/>
    <input type="button" value="普通按钮">
    <button>专业按钮</button><button>&times;</button>


</form>
<script >
    // 1. 获取文本框的值
    //获取name="userName"的文本输入框
    var userNameEle = document.querySelector("input[name='userName']");
    /*
        1.对象名.属性名:获取属性的值
        标签是文本输入框,通过对象名.value属性,可以获取到页面中用户输入的内容
        2.对象名.getAttribute("属性名")根据属性名,获取属性的值(只能获取标签上属性的值,获取不用用户输入的内容)
     */
    console.log(userNameEle.value);//张三 李四(页面输入的内容)
    console.log(userNameEle.getAttribute("value"));//张三 张三(根据属性名,获取属性的值)
    console.log(userNameEle.type);//text
    console.log(userNameEle.name);//userName

    //修改标签对象的value值
    //userNameEle.value = "老王";
    //userNameEle.setAttribute("value","尼古拉斯赵四");

	//单选框或复选框的选中状态
    //获取所有的复选框
    var hobbyEleArr = document.querySelectorAll("input[name='hobby']");
    //遍历数组,获取每一个复选框对象
    for(let hobbyEle of hobbyEleArr){
        //对象名.checked属性可以获取到复选框|单选框的选中状态:选中:true,未选中:false
        //console.log(hobbyEle.checked);
        //alert(hobbyEle.checked);
        //根据属性名,获取属性值:有checked属性,值就是checked;没有checked属性:值就是null
        //alert(hobbyEle.getAttribute("checked"));
    }

    // 2. 给元素设置自定义属性
    alert(userNameEle.getAttribute("haha"));//null
    userNameEle.setAttribute("haha","哈哈");

    // 3. 获取元素的自定义属性值
    alert(userNameEle.getAttribute("haha"));//哈哈

    // 4. 移除元素的自定义属性
    userNameEle.removeAttribute("haha");
    alert(userNameEle.getAttribute("haha"));//null
</script>
</body>
</html>
```



### dom操作样式

dom操作样式

```java
1. 设置一个css样式
语法: element.style.color   获取或者修改一个css样式
2. 批量设置css样式
语法: element.style.cssText 获取后者修改 标签的style属性的文本值
3. 通过class设置样式
语法: element.className 获取或者修改标签的class属性的文本值
4. 切换class样式
语法: element.classList es6特别提供的操作元素class的接口
    element.classList常用方法有四个:
    add("class样式名称")  添加一个class样式
    remove("class样式名称") 移除一个class样式
    contains("class样式名称") 判断是否包含某一个样式,包含返回true,不包含返回false
    toggle("class样式名称") 切换一个class样式 有则删除,无则添加
```

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>13-dom操作样式</title>
</head>
<body>
<style>
    #p1{ background-color: red;}
    .mp{color:green}
    .mpp{background-color: lightgray;}
</style>
<p id="p1">1. 设置一个css样式</p>
<p id="p2">2. 批量设置css样式</p>
<p id="p3" class="mpp">3. 通过class设置样式</p>
<p id="p4">4. 切换class样式</p>
<input type="button" value="切换样式" id="b1" />

<script >
    let p1 = document.querySelector("#p1");//获取段落标签
    let p2 = document.querySelector("#p2");//获取段落标签
    let p3 = document.querySelector("#p3");//获取段落标签
    let p4 = document.querySelector("#p4");//获取段落标签

    // 1. 给p1设置css样式  <p id="p1">1. 设置一个css样式</p>
    //白色字体
    p1.style.color = "white";
    //黑色背景
    p1.style.backgroundColor = "black";
    //获取一个样式名
    //alert(p1.style.backgroundColor);//black
    //alert(p1.style.color);//white
    //隐藏不显示
    p1.style.display = "none";
    //显示
    p1.style.display = "block";

    // 2. 给p2批量设置css样式
    p2.style.cssText = "color: red;font-family: '楷体';border: 1px solid green";

    // 3. 给p3通过class设置样式
    //a.给元素添加class属性的方式添加样式
    //p3.setAttribute("class","mp mpp");
    //b.使用className属性添加
    //p3.className= "mp mpp";
    //alert(p3.className);//mp mpp
    p3.className = p3.className+" mp";// mpp + " mp"==>mpp mp

    // 4. 切换class样式
    //获取p4的class样式集合
    var p4List = p4.classList;

    //添加一个class样式
    p4List.add("mpp");

    //判断某一个样式是否存在
    //alert(p4List.contains("mpp"));//true
    //alert(p4List.contains("mp"));//false

    //添加一个class样式
    p4List.add("mp");

    //移除一个class样式
    p4List.remove("mp");

    //获取id是b1的按钮
    //通过对象名.事件属性名,给元素添加事件
    var b1Ele = document.querySelector("#b1");
    b1Ele.onclick = function () {
        //切换,无则添加,有则删除
        p4List.toggle("mp");
    }
</script>
</body>
</html>
```

### dom操作元素 

- dom操作元素

```html
1. 后面添加(掌握)
innerHTML 获取或者设置标签的html内容
2. 后面添加(了解)
document.createElement(""标签名称"") 创建一个标签对象 <div></div>
parentNode.appendChild(newNode) 给父标签添加一个子标签
3. 移除元素(了解)
element.outerHTML=""
```

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>14-dom操作元素</title>
</head>
<body>
<div id="container">
    <input id="smoke" type="checkbox" name="hobby" value="抽烟">
    <label for="smoke">抽烟&emsp;</label>

<!--    <input id="drink" type="checkbox" name="hobby" value="喝酒">-->
<!--    <label for="drink">喝酒&emsp;</label>-->

<!--    <input id="perm" type="checkbox" name="hobby" value="烫头">-->
<!--    <label for="perm">烫头&emsp;</label>-->

</div>
<script >
    //获取div标签对象
    var divEle = document.querySelector("#container");

    //1. 后面添加喝酒(掌握) innerHTML
    //alert(divEle.innerHTML);
    divEle.innerHTML += "<input id='drink' type='checkbox' name='hobby' value='喝酒'>"
        + "<label for='drink'>喝酒&emsp;</label>";
    
    //2. 后面添加烫头(了解)
    //创建input标签,使用document对象中方法createElement("标签名称")
    var inputEle = document.createElement("input");
    console.log(inputEle);//<input>
    //<input id="perm" type="checkbox" name="hobby" value="烫头">
    inputEle.setAttribute("id","perm");
    console.log(inputEle);//<input id="perm">
    inputEle.setAttribute("type","checkbox");
    inputEle.setAttribute("name","hobby");
    inputEle.setAttribute("value","烫头");
    console.log(inputEle);//<input type="checkbox" id="perm" name="hobby" value="烫头">

    //<label for="perm">烫头&emsp;</label>
    //创建标签
    var lableEle = document.createElement("lable");
    //添加属性
    lableEle.setAttribute("for","perm");
    console.log(lableEle);//<lable for="perm">
    //添加标签体
    lableEle.innerHTML="烫头&emsp;";
    console.log(lableEle);//<label for="perm">烫头&emsp;</label>

    //使用父标签div中的方法appendChild(子标签);添加子标签
    divEle.appendChild(inputEle);
    divEle.appendChild(lableEle);

    //3.移除元素(了解) outerHTML
    divEle.outerHTML = "";//删除div
</script>
</body>
</html>
```

## 正则表达式

会使用如下正则表达式匹配字符串

```java
验证邮编
/\d{6}/
校验是否全由8位数字组成
/^[0-9]{8}$/
中文名称
/^[\u4E00-\u9FA5]{2,4}$/
是否带有小数
/^\d+\.\d+$/
验证身份证号
/\d{17}[\d|X]|\d{15}/
校验电话码格式
/^((0\d{2,3}-\d{7,8})|(1[3584]\d{9}))$/
验证网址
/http(s)?:[//]{2}([\w-]+\.)+[\w-]+([/]{1}[\w- ./?%&=]*)?/
验证EMail
/\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/

```



```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>正则表达式练习</title>
    <script>
        //创建正则表达式的对象
        var reg = /\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
        //使用正则表达式中的方法test,判断字符串是否满足正则的规则
        console.log(reg.test("2713557@qq.com"));//true
        console.log(reg.test("2713557qq.com"));//false
        console.log(reg.test("2713557@qq"));//false
        console.log(reg.test("zhangsan@163.com"));//true
        console.log(reg.test("zhangsan@sina.com.cn"));//true
    </script>
</head>
<body>

</body>
</html>
```



## 综合案例

### 1.案例-轮播图

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>轮播图案例</title>
    <script>
        //定义一个页面加载事件:让页面先加载完毕,在执行function中的代码
        window.onload = function () {
            /*
                分析:
                    1.定义一个变量,记录图片的整数值%E5%89%8D%E7%AB%AF_assetsInt
                    2.创建一个反复执行的定时器,每隔3秒钟执行一次
                    3.判断图片的整数值%E5%89%8D%E7%AB%AF_assetsInt<3 %E5%89%8D%E7%AB%AF_assetsInt++; 否则 %E5%89%8D%E7%AB%AF_assetsInt=1
                    4.通过图片的id属性值获取图片对象
                    5.修改图片对象的src的属性值
             */
            //1.定义一个变量,记录图片的整数值%E5%89%8D%E7%AB%AF_assetsInt
            var %E5%89%8D%E7%AB%AF_assetsInt = 1;
            //2.创建一个反复执行的定时器,每隔3秒钟执行一次
            setInterval(function () {
                //3.判断图片的整数值%E5%89%8D%E7%AB%AF_assetsInt<3 %E5%89%8D%E7%AB%AF_assetsInt++; 否则 %E5%89%8D%E7%AB%AF_assetsInt=1
                if(%E5%89%8D%E7%AB%AF_assetsInt<3){
                    %E5%89%8D%E7%AB%AF_assetsInt++;
                }else{
                    %E5%89%8D%E7%AB%AF_assetsInt=1;
                }
                //4.通过图片的id属性值获取图片对象
                var %E5%89%8D%E7%AB%AF_assetsAdELe = document.querySelector("#%E5%89%8D%E7%AB%AF_assetsAd");
                //5.修改图片对象的src的属性值
                %E5%89%8D%E7%AB%AF_assetsAdELe.src = "../%E5%89%8D%E7%AB%AF_assets/ad"+%E5%89%8D%E7%AB%AF_assetsInt+".jpg";

            },3000);
        }
    </script>
</head>
<body>
    <div style="width: 500px;margin: 50px auto">
        <%E5%89%8D%E7%AB%AF_assets id="%E5%89%8D%E7%AB%AF_assetsAd" src="../%E5%89%8D%E7%AB%AF_assets/ad1.jpg">
    </div>
</body>
</html>

```

### 2.案例-表单校验

```html
form表单的 onsubmit 事件 表单提交之前触发
onsubmit的事件源是form表单

用法实例:
onsubmit="return 函数()"  函数返回true则表单正常提交,函数返回false则阻止表单提交
```

```html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>案例三_表单校验</title>
</head>
<body>
<form action="#" method="post" onsubmit="return checkForm()">
    用户名：<input id="txtUserName" type="text"/><span id="txtUserNameMsg"></span>
    <br/>
    密码：<input id="txtUserPwd" type="text"/><span id = "txtUserPwdMsg"></span>
    <br/>
    确认密码：<input id="txtUserPwd2" type="text"/><span id="txtUserPwdMsg2"></span>
    <br/>
    <input type="submit" value="提交"/>
</form>
</body>
<script>
		//验证用户名
        //1.不能为空，必须是字母(大小写)、数字、8--16位
        //获取id是txtUserName的文本框对象
        var txtUserNameEle = document.querySelector("#txtUserName");
        //获取id是txtUserNameMsg的错误信息对象
        var txtUserNameMsgEle = document.querySelector("#txtUserNameMsg");
        //定义一个布尔值,记录判断的结果
        var b1 = false;
        //定义一个判断用户名的正则表达式
        var reg = /^[a-zA-Z0-9]{8,16}$/
        //给txtUserNameEle添加一个失去焦点事件
        txtUserNameEle.onblur = function () {
            //判断用户名不能为空
            if(txtUserNameEle.value==""){
                //用户名是空的,显示错误信息
                txtUserNameMsgEle.innerHTML = "<font color='red'>用户名不能为空</font>"
                b1 = false;
            }
            //必须是字母(大小写)、数字、8--16位
            else if(!reg.test(txtUserNameEle.value)){
                //不满足正则的规则,显示错误信息
                txtUserNameMsgEle.innerHTML = "<font color='red'>用户名必须是字母(大小写)、数字、8--16位</font>"
                b1 = false;
            }else{
                //条件都满足,把错误信息取消
                txtUserNameMsgEle.innerHTML="";
                b1 = true;
            }
        }
      
     	//2.密码不能为空,密码必须是：8--16位数字
        //获取id是txtUserPwd的密码输入框
        var txtUserPwdEle = document.querySelector("#txtUserPwd");
        //获取id是txtUserPwdMsg的密码输入框错误信息
        var txtUserPwdMsgEle = document.querySelector("#txtUserPwdMsg");
        //定义一个布尔值
        var b2 = false;
        //定义一个校验密码的正则表达式
        reg = /^\d{8,16}$/;
        //给txtUserPwdEle对象添加一个失去焦点事件
        txtUserPwdEle.onblur = function () {
            //密码不能为空
            if(txtUserPwdEle.value==""){
                //密码是空的,显示错误信息
                txtUserPwdMsgEle.innerHTML = "<font color='red'>密码不能为空</font>"
                b2 = false;
            }
            //密码必须是：8--16位数字
            else if(!reg.test(txtUserPwdEle.value)){
                //不满足正则的规则,显示错误信息
                txtUserPwdMsgEle.innerHTML = "<font color='red'>密码必须是：8--16位数字</font>"
                b2 = false;
            }else{
                //条件都满足,把错误信息取消
                txtUserPwdMsgEle.innerHTML="";
                b2 = true;
            }
        }
   
        
        //3.确认密码：必须与密码相同
        //获取id是txtUserPwd2的确认密码输入框
        var txtUserPwd2Ele = document.querySelector("#txtUserPwd2");
        //获取id是txtUserPwdMsg2的确认密码输入框错误信息
        var txtUserPwdMsg2Ele = document.querySelector("#txtUserPwdMsg2");
        //定义一个布尔值
        var b3 = false;
        //给txtUserPwd2Ele添加一个失去焦点事件
        txtUserPwd2Ele.onblur = function () {
            //确认密码：必须与密码相同
            if(txtUserPwdEle.value!=txtUserPwd2Ele.value){
                //显示错误信息
                txtUserPwdMsg2Ele.innerHTML = "<font color='red'>确认密码：必须与密码相同</font>";
                b3 = false;
            }else{
                txtUserPwdMsg2Ele.innerHTML = "";
                b3 = true;
            }
        }
        
        //表单提交事件的响应函数
        function checkForm(){
            //三个判断条件的布尔值都是true,在提交表单
            alert("b1:"+b1);
            alert("b2:"+b2);
            alert("b3:"+b3);
            var flag = b1 && b2 && b3;
            alert("flag:"+flag)
            return flag;
        }
    </script>
</html>
```

### 3.案例-可以启停的时钟

```html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>可以启停的时钟</title>
    <style>
	    #clockId {
	        color: red;
	        font-size: 100px;
	        font-family: "楷体";
	    }
	</style>
</head>
<body>
<input id="butStart" type="button" value="启动"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input id="butStop" type="button" value="停止"/>

<br/><br/>
<span id="clockId"></span>
</body>

<script>       
        //1.为"启动"按钮绑定事件
        //获取id是butStart的按钮对象
        var butStartEle = document.querySelector("#butStart");

        //定义一个变量,记录定时器返回的id值,用于取消定时器
        var interId;

        //给butStartEle对象添加一个鼠标点击事件
        butStartEle.onclick = function () {
            //定义一个反复执行的定时器,1秒钟执行一次
            interId = setInterval(function () {
                //获取当前系统的时间和日期
                var date = new Date();
                //对时间和日期进行格式化
                var str = date.toLocaleString();
                //获取id是clockId的span标签,标签体设置为格式化之后的时间
                document.querySelector("#clockId").innerHTML =str;
            },1000);
        }
        
        //2.为"停止"按钮绑定事件
        //获取id是butStop的按钮对象,并给对象添加一个鼠标点击事件
        document.querySelector("#butStop").onclick =function () {
            //结束反复执行的定时器
            clearInterval(interId);
        }
        
    </script>
</html>
```



### 4-案例-商品全选

![1572600617133](%E5%89%8D%E7%AB%AF_assets/1572600617133-1596036966236.png)

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>案例-商品全选</title>
</head>
<body>
<button id="btn1">1. 全选</button>
<button id="btn2">2. 全不选</button>
<button id="btn3">3. 反选</button>
<br/>
<input type="checkbox">电脑
<input type="checkbox">手机
<input type="checkbox">汽车
<input type="checkbox">别墅
<input type="checkbox" checked="checked">笔记本
<script >
	/*
	 	商品全选
	    1. 全选 点击全选按钮,所有复选框都被选中
	    分析:
	        1.获取id是btn1的全选按钮对象
	        2.给btn1按钮对象添加一个鼠标点击事件
	        3.在鼠标点击事件的响应函数中,获取所有的checkbox复选框,返回一个数组
	        4.遍历数组,获取每一个checkbox对象
	        5.设置checkbox对象的属性checked为true
	 */
	document.querySelector("#btn1").onclick = function () {
        var arr = document.querySelectorAll("input[type='checkbox']");
        for(var cbEle of arr){
            cbEle.checked =true;
        }
    }

	/*
	    2. 全不选 点击全不选按钮,取消所有选中的复选框
        分析:
	        1.获取id是btn2的全不选按钮对象
	        2.给btn2按钮对象添加一个鼠标点击事件
	        3.在鼠标点击事件的响应函数中,获取所有的checkbox复选框,返回一个数组
	        4.遍历数组,获取每一个checkbox对象
	        5.设置checkbox对象的属性checked为false
	*/
    document.querySelector("#btn2").onclick = function () {
        var arr = document.querySelectorAll("input[type='checkbox']");
        for(var cbEle of arr){
            cbEle.checked =false;
        }
    }

    /*
        3. 反选 点击反选按钮,所有复选框状态取反
        分析:
	        1.获取id是btn3的反选按钮对象
	        2.给btn3按钮对象添加一个鼠标点击事件
	        3.在鼠标点击事件的响应函数中,获取所有的checkbox复选框,返回一个数组
	        4.遍历数组,获取每一个checkbox对象
	        5.设置checkbox对象的属性checked为!checked
     */
    document.querySelector("#btn3").onclick = function () {
        var arr = document.querySelectorAll("input[type='checkbox']");
        for(var cbEle of arr){
            cbEle.checked =!cbEle.checked;
        }
    }
</script>
</body>
</html>
```



### 5-案例-省市级联

![1572602429296](%E5%89%8D%E7%AB%AF_assets/1572602429296-1596036966236.png)

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8" />
		<title>案例-省市级联</title>
		<style type="text/css">
					.regist_bg {
						width: 100%;
						height: 600px;
						padding-top: 40px;
						background-image: url(../%E5%89%8D%E7%AB%AF_assets/bg.jpg);
					}
					.regist {
						border: 7px inset #ccc;
						width: 600px;
						padding: 40px 0;
						padding-left: 80px;
						background-color: #fff;
						margin-left: 25%;
						border-radius: 10px;
					}
					input[type="submit"] {
						background-color: aliceblue;
						width: 100px;
						height: 35px;
						color: red;
						cursor: pointer;
						border-radius: 5px;
					}
		</style>

	</head>
	<body>
		<div class="regist_bg">
			<div class="regist">
				<form action="#">
					<table width="600" height="350px">
						<tr>
							<td colspan="3">
								<font color="#3164af">会员注册</font> USER REGISTER
							</td>
						</tr>
						<tr>
							<td align="right">用户名</td>
							<td colspan="2"><input id="loginnameId" type="text" name="loginname" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">密码</td>
							<td colspan="2"><input id="loginpwdId" type="password" name="loginpwd" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">确认密码</td>
							<td colspan="2"><input id="reloginpwdId" type="password" name="reloginpwd" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">Email</td>
							<td colspan="2"><input id="emailId" type="text" name="email" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">姓名</td>
							<td colspan="2"><input name="text" name="username" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">性别</td>
							<td colspan="2">
								<input type="radio" name="gender" value="男" checked="checked" />男
								<input type="radio" name="gender" value="女" />女
							</td>
						</tr>
						<tr>
							<td align="right">电话号码</td>
							<td colspan="2"><input type="text" name="phone" size="60" /> </td>
						</tr>
						<tr>
							<td align="right">所在地</td>
							<td colspan="3">								
								<select id="provinceId" style="width:150px">
									<option value="">----请-选-择-省----</option>

								</select>
								<select id="cityId" style="width:150px">
									<option value="">----请-选-择-市----</option>
								</select>
							</td>
						</tr>
						<tr>
							<td width="80" align="right">验证码</td>
							<td width="100"><input type="text" name="verifyCode" /> </td>
							<td><%E5%89%8D%E7%AB%AF_assets src="../%E5%89%8D%E7%AB%AF_assets/checkCode.bmp" /> </td>
						</tr>
						<tr>
							<td></td>
							<td colspan="2">
								<input type="submit" value="注册" />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<!--
		省市级联
			1. 页面加载完成后自动装载省数据
			2. 当选中省时,装载该省的市数据
		-->
		<script type="text/javascript">
			//准备省市数据
			let provinceData = ["北京","河北","辽宁"];
			//准备省对应的市数据 json对象 对象名.key可以获取value值
			let cityData = {
				"北京":["顺义区","昌平区","朝阳区"],
				"河北":["保定","石家庄","廊坊"],
				"辽宁":["沈阳","铁岭","抚顺"]
			};
			//获取省份select标签对象
			var provinceEle = document.querySelector("#provinceId");
            //获取城市select标签对象
            var cityEle = document.querySelector("#cityId");

			
			//页面加载完成时填充省选项
			//定义一个页面加载事件
			window.onload = function () {
				//遍历存储省份的数组,获取每一个省份名称
				for(var proName of provinceData){
				    //给省份的select标签对象,追加标签体
                    provinceEle.innerHTML += "<option value='"+proName+"'>"+proName+"</option>";
				}
            }
			
			//当省选项值改变时改变对应的市
			//给省份的select标签对象添加一个内容改变事件onchage
			provinceEle.onchange = function () {
				//初始化城市select标签的标签体
                cityEle.innerHTML = "<option value=''>----请-选-择-市----</option>";
				//this对象,当前标签对象,也就是provinceEle对象
				//alert(this.value);
				//alert(provinceEle.value);
				//根据省份的名称,获取对应的城市数组
				var citysEle = cityData[this.value];
				//alert(citysEle);//["顺义区","昌平区","朝阳区"]
				//遍历存储城市名称的数组,获取每一个城市名称
				for(var cityName of citysEle){
				    //给城市select标签追加标签体
                    cityEle.innerHTML += "<option value='"+cityName+"'>"+cityName+"</option>";
				}
            }
			

		</script>

	</body>
</html>

```

### 6-案例-隔行变色

```html
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>表格隔行变色</title>
		<script type="text/javascript">
			/*
				分析:
					1.定义一个页面加载事件,让页面加载完毕,在获取表格
					2.获取表格中所有的tr对象,返回一个数组
					3.遍历数组,获取每一个tr对象
					4.判断获取的tr对象是奇数行还是偶数行
						是奇数行:设置背景色为xxx色
						是偶数行:设置背景色为yyy色
			 */
            //1.定义一个页面加载事件,让页面加载完毕,在获取表格
			window.onload = function () {
                //2.获取表格中所有的tr对象,返回一个数组
				var trEleArr = document.querySelectorAll("tr");
                //3.遍历数组,获取每一个tr对象
				for(var i=2 ; i<trEleArr.length; i++){
                    //4.判断获取的tr对象是奇数行还是偶数行
					if(i%2!=0){
                        //是奇数行:设置背景色为xxx色
						trEleArr[i].bgColor= "pink";
                    }else{
                        //是偶数行:设置背景色为yyy色
                        trEleArr[i].bgColor= "greenyellow";
                    }

                    /*
                    	扩展:给每行添加鼠标移入和移出事件
                    	鼠标移入到当前行,把背景色改成zzz色
                    	鼠标移出当前行,把背景色还原
                     */
                    //定义一个变量,记录当前行的背景色
					var bg;
					//给当前行添加鼠标移入事件
					trEleArr[i].onmouseover = function () {
						bg = this.bgColor;
						this.bgColor = "yellow";
                    }

                    //给当前行添加鼠标移出事件
                    trEleArr[i].onmouseout =  function () {
						this.bgColor = bg;
                    }
                }

            }
		</script>
	</head>
	<body>
		<table id="tab1" border="1" width="800" align="center" >
			<tr>
				<td colspan="5"><input type="button" value="删除"></td>
			</tr>
			<tr style="background-color: #999999;">
				<th><input type="checkbox"></th>
				<th>分类ID</th>
				<th>分类名称</th>
				<th>分类描述</th>
				<th>操作</th>
			</tr>
			<tr bgcolor="pink">
				<td><input type="checkbox"></td>
				<td>1</td>
				<td>手机数码</td>
				<td>手机数码类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr bgcolor="greenyellow">
				<td><input type="checkbox"></td>
				<td>2</td>
				<td>电脑办公</td>
				<td>电脑办公类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr bgcolor="pink">
				<td><input type="checkbox"></td>
				<td>3</td>
				<td>鞋靴箱包</td>
				<td>鞋靴箱包类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr bgcolor="greenyellow">
				<td><input type="checkbox"></td>
				<td>4</td>
				<td>家居饰品</td>
				<td>家居饰品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr>
				<td><input type="checkbox"></td>
				<td>5</td>
				<td>牛奶制品</td>
				<td>牛奶制品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr><tr>
				<td><input type="checkbox"></td>
				<td>6</td>
				<td>大豆制品</td>
				<td>大豆制品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr>
				<td><input type="checkbox"></td>
				<td>7</td>
				<td>海参制品</td>
				<td>海参制品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr>
				<td><input type="checkbox"></td>
				<td>8</td>
				<td>羊绒制品</td>
				<td>羊绒制品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr>
				<td><input type="checkbox"></td>
				<td>9</td>
				<td>海洋产品</td>
				<td>海洋产品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
			<tr>
				<td><input type="checkbox"></td>
				<td>10</td>
				<td>奢侈用品</td>
				<td>奢侈用品类商品</td>
				<td><a href="">修改</a>|<a href="">删除</a></td>
			</tr>
		</table>
	</body>
</html>

```



# JSON数据

## 什么是json

JSON(JavaScript Object Notation, JS 对象标记) 是一种轻量级的**数据交换**格式。它基于ECMAScript的一个子集，采用**完全独立于编程语言**的文本格式来存储和表示数据。就是说不同的编程语言JSON数据是一致的。JS原生支持JSON.简洁和清晰的层次结构使得 JSON 成为理想的数据交换语言。 易于人阅读和编写，同时也易于机器解析和生成，并有效地提升网络传输效率。

## json的语法格式

json对象有三种数据格式，分别如下：

| 类型          | 语法                                        | 解释                                   |
| ------------- | ------------------------------------------- | -------------------------------------- |
| 对象类型      | {"key1":value,"key2":value,"key3":value...} | 其中key是字符串类型，而value是任意类型 |
| 数组/集合类型 | [value,value,value...]                      | 其中value是任意类型                    |
| 混合类型      | [{},{}... ...] 或 {"key":[]... ...}         | 对象格式和数组格式可以互相嵌套         |

[{"key1":value,"key2":value,"key3":value...},{"key1":value,"key2":value,"key3":value...}]

{"key1":value,"key2":[value,value,value...],"key3":value...}

{"key1":value,"key2":[{"key1":value,"key2":value,"key3":value...},value,value...],"key3":value...}

## json格式练习

### 练习1:对象练习

```java
案例一
{key:value,key:value}
 
class Person{
   String firstname = "张";
   String lastname = "三丰";
   Integer age = 100;
}

Person p = new Person();
System.out.println(p.firstname);//张
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JSON格式的练习一</title>
    <script>
        /*
            JSON格式的练习一
            {key:value,key:value}
            class Person{
               String firstname = "张";
               String lastname = "三丰";
               Integer age = 100;
            }

            Person p = new Person();
            System.out.println(p.firstname);//张

            分析:
                json本质是一个对象
                key:字符串类型,value:可以是任意类型
                对象中包含了多个键值对
         */
        var json = {"firstname":"张","lastname":"三丰","age":100};
        alert(json);//[object Object]
        //可以使用对象名.key,可以获取到value值
        alert(json.firstname);
        alert(json.lastname);
        alert(json.age);
    </script>
</head>
<body>

</body>
</html>
```

### 练习2:数组练习

```
案例2:[value,value,value...]
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JSON格式的练习二</title>
    <script>
        /*
            案例2:[value,value,value...]
         */
        var json  = [1,2,3,true,false,"a","b","c",1.1,2.2,3.3];
        //json本质就是一个数组,遍历数组,获取数组中的每一个元素
        for(var s of json){
            alert(s);
        }
    </script>
</head>
<body>

</body>
</html>
```

### 练习3:对象和数组混合练习

```json
案例3:[{key:value,key:value},{key:value,key:value}]
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JSON格式的练习三</title>
    <script>
        /*
            案例3:[{key:value,key:value},{key:value,key:value}]
            分析:
                json的本质是一个数组
                数组中的每一个元素,都是一个对象
                对象中包含了多个键值对
        */
        var json = [
            {"name":"迪丽热巴","age":18},
            {"name":"古力娜扎","age":19}
        ];
        //遍历数组,获取数组中的每一个元素(对象)
        for(var obj of json){
            //通过对象名.key,获取value值
            alert(obj.name+"\t"+obj.age);
        }
    </script>
</head>
<body>

</body>
</html>
```

应用:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>省市级联</title>
</head>
<body>
<form>
    &emsp;
    <select id="province">
        <option value="">-----请选择省(直辖市)------</option>
    </select>
    &emsp;
    <select id="city">
        <option value="">-----请选择市(区)------</option>
    </select>
</form>
</body>
<script>
    //json的语法格式:[value,value,value...] 数组类型的
   let provinceData = ["北京","河北","河南","山东","山西"];
   let cityData = {
       "北京":["西城","海淀","东城","朝阳","昌平"],
       "河北":["保定","石家庄","廊坊","邯郸"],
       "河南":["郑州","洛阳","开封","信阳","南阳"]
   };
   //获取省份的对象
    var provinceEle = document.querySelector("#province");
    var cityEle = document.querySelector("#city");
    //给省份添加元素
    //遍历省份数组
    provinceEle.innerHTML = "<option value=''>-----请选择省(直辖市)------</option>";
    window.onload = function () {
        for (let province of provinceData) {
            provinceEle.innerHTML += "<option value="+province+">"+province+"</option>";
        }
    }

    provinceEle.onchange = function () {
        cityEle.innerHTML = "<option value=''>-----请选择市(区)------</option>";
        //从存储对象的json中根据key获取value,可以使用对象名.key,可以获取到value值
        var citysEle = cityData[this.value];
        for(var cityName of citysEle){
            cityEle.innerHTML += "<option value='"+cityName+"'y>"+cityName+"</option>";
        }

    }


</script>
</html>
```

## JSON格式转换

- JSON对象与字符串转换的相关函数

```
-  JSON.stringify(object) 把json对象转为字符串
-  JSON.parse(string) 把字符串转为json对象
```

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>JSON格式转换</title>
    <script>
        /*
            JSON格式转换
            -  JSON.stringify(object) 把json对象转为字符串
            -  JSON.parse(string) 把字符串转为json对象
         */
        //创建json格式的数据
        var json = {"name":"柳岩","age":18};
        //alert(typeof json);//object

        //JSON.stringify(object) 把json对象转为字符串
        var str = JSON.stringify(json);
        //alert(str);//{"name":"柳岩","age":18}
        //alert(typeof str);//string
        //alert(str.name);//undefined

        //JSON.parse(string) 把字符串转为json对象
        var obj = JSON.parse(str);
        alert(typeof obj);//object
        alert(obj.name+"\t"+obj.age);//柳岩	18
    </script>
</head>
<body>

</body>
</html>
```

## 将Java对象转换为json字符串

常用的json转换工具

Jackson开源免费的json转换工具，springmvc转换默认使用Jackson

Jackson把Java对象转换成JSON字符串的API：

| 方法名                         | 作用                                                 | 说明 |
| ------------------------------ | ---------------------------------------------------- | ---- |
| new ObjectMapper()             | 创建ObjectMapper对象                                 |      |
| writeValueAsString(Object obj) | 使用ObjectMapper对象，把任意类型数据转换为JSON字符串 |      |

依赖坐标

```
 <!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
        <dependency>
            <groupId>com.fasterxml.jackson.core</groupId>
            <artifactId>jackson-databind</artifactId>
            <version>2.9.8</version>
        </dependency>
```

json应用

```
1. 导入pom依赖
2. 创建一个User类：包含name,age,sex三个属性
3. 在main函数中，实例化User对象，给属性赋值
4. 创建一个字符串数组对象，包含三个字符串
5. 创建一个List<User>，包含三个用户对象
6. 创建一个Map对象，键名为：user，键为User对象
7. 实例化ObjectMapper对象，调用writeValueAsString()方法输出转换后的字符串对象
```



## 再看JSON

JSON与JS的关系：

**JSON 是 JS 对象的字符串表示法，它使用文本表示一个 JS 对象的信息，本质是一个字符串**

JSON 使用 JavaScript 语法来描述数据对象，但是 JSON 仍然独立于语言和平台

```
JSON 值可以是：
数字（整数或浮点数）
字符串（在双引号中）
逻辑值（true 或 false）
数组（在方括号中）
对象（在花括号中）
```

```
JSON 文件的文件类型是 ".json"
JSON 文本的 MIME 类型是 "application/json"
```

JSON 最常见的用法之一，是从 web 服务器上读取 JSON 数据（作为文件或作为 HttpRequest），将 JSON 数据转换为 JavaScript 对象，然后在网页中使用该数据。

**JSON 对象**

```
{"firstName":"John" , "lastName":"Doe"}
```

```
{
  "employees": [
    { "firstName":"John" , "lastName":"Doe" },
    { "firstName":"Anna" , "lastName":"Smith" },
    { "firstName":"Peter" , "lastName":"Jones" }
  ]
}
```

JSON数组可以包含多个对象

**JS:**

JS的数据类型:

```
字符串值，数值，布尔值，数组，对象
```

JS的数组是一种特殊类型的对象。在 JavaScript 中对数组使用 typeof 运算符会返回 "object"。

数组使用数字来访问其“元素”。在本例中，`person[0]` 返回 Bill：

```
var person = ["Bill", "Gates", 62];
```

对象使用*名称*来访问其“成员”。在本例中，`person.firstName` 返回 Bill：

```
var person = {firstName:"John", lastName:"Doe", age:46};
```

数组元素可以是对象, 所以也可以是在数组中存放数组, 因为数组也是对象









# JQuery

## 简介

jquery：是javascript的一套框架  --企业主流：vue框架（项目二）

作用：大大简化javascript的代码量 倡导写更少的代码，做更多的事情

框架：对原有javascript的功能代码进行封装，对外提供更加简单的语法方式实现同样的功能，大大提高开发效率

了解：jquery框架封装javascript的原理

~~~html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="../js/jquery.js"></script>
    <script>
        onload=function(){
             //js
            console.log(document.getElementById("username"));

            //jq  jquery("#username")
            console.log(jquery("#username"));
            //jq  $("#username")
            console.log($("#username"));
        }
    </script>
</head>
<body>
        <input type="text" id="username"/>
</body>
</html>
~~~

jquery.js文件：

```js
function jquery(id){
	id=id.substring(1);
	return document.getElementById(id);
 }
let $=jquery;
```

## html文档中如何使用jquery

条件：需要引入jquery框架文件

jquery框架文件：就是对javascript功能代码的二次封装 简称js库

js库的版本：

~~~
1.x：兼容IE6/7/8，使用最为广泛的 企业应用

2.x：不兼容IE6/7/8，很少有人使用

3.x：不兼容IE6/7/8，只支持最新的浏览器。除非特殊要求，一般不会使用3.x版本的
													 咱们要讲新特性
													 课下同学们用哪个版本都行（新特性除外）

开发版本：命名为jQuery-x.x.x.js      好处：代码格式好 便于看源码 但是体积大
生产版本：命名为jQuery-x.x.x.min.js  好处：体积小 代码格式不好
~~~

## 快速入门

步骤：

~~~
1 导入js库（jquery-3.3.1.min.js）
2 编写页面加载事件测试是否引入成功
~~~

代码：

~~~html
<head>
    <meta charset="UTF-8">
    <title>jq的入门</title>
    <!--
        1：导入提供的封装好的js库（3.x版本）
        2: 编写jq的页面加载事件（和js的代码都不一样）
                特点注意:只要是任何页面用到了$ 一定存在js库
    -->
    <script src="../js/jquery-3.3.1.js"></script>
    <script>
        /*jq的页面加载
        *       格式：$(function(){ 当页面的内容加载完毕，会执行的代码 })
        * */
        $(function(){
            alert("我是jq的页面加载事件");
        })
    </script>
</head>
~~~



## Jquery基础语法

### 1.  js和jq的页面加载事件区别

```html
js页面加载事件
只执行一次,如果有多个是按照页面从上到下的加载顺序后面的覆盖前面的      
jq页面加载事件
有多少个页面加载方法，就执行多少次，执行顺序是按照页面的从上到下的顺序
jq的页面加载会优先于js的页面加载
```

~~~
同学答案：
js的加载在页面中只执行一次,并且后面的会覆盖前面的.jq需要引js库,jq的页面加载会优先于js,并且会多次执行
~~~

代码：

~~~html
<head>
    <meta charset="UTF-8">
    <title>jq的页面加载和js的页面加载区别.html</title>

    <!--js-->
    <script>
        onload=function(){
            alert("js2");
        }
    </script>

    <!--js-->
    <script>
        onload=function(){
            alert("js1");
        }
    </script>


    <!--jq-->
    <script src="../js/jquery-3.3.1.js"></script>
    <script>
        $(function(){
            alert("jq1");
        })
    </script>
    <script>
        $(function(){
            alert("jq2");
        })
    </script>

</head>
~~~

### 2. js的dom对象和jq的对象进行互转

~~~
js的dom对象有自己的方法和属性
jquery对象也有自己的方法和属性
	特点：
		jquery对象不能使用js的dom对象方法和属性 
		js的dom对象也不能使用jquery的方法和属性
	解决：
		只要jquery对象转成js的dom对象 就可以使用js的方法和属性
      	 只要js的dom对象转成jquery对象 就可以使用jq的方法和属性
jquery对象转换成js的dom对象： jquery对象[0] 或者 jquery对象.get(0)
js的dom对象转换成jquery对象： $(dom对象)
~~~

代码：

~~~html
<head>
    <meta charset="UTF-8">
    <title>jq和js的互相转换.html</title>
    <!--<script>
        onload=function(){
           let dd= document.getElementById("dd");
           dd.innerHTML="我点";
        }
    </script>-->

    <script src="../js/jquery-3.3.1.js"></script>
    <!--<script>
        $(function(){
            let dd=$("#dd");
            //dd.innerHTML="我点";
            dd.html("我点");
        })
    </script>-->

    <!--结论：js的方法和jq的方法不通用 js有js的 jq有jq的-->

    <!--

    问题是：能不能让js的方法和jq的方法通用
             可以： 将js的对象转换成jq对象   $("js对象")
                    将jq对象转换成js对象    $("#dd").get(0) 或者是 $("#dd")[0]

    -->

    <!--<script>
        $(function(){
            let dd=$("#dd");
            dd[0].innerHTML="我点";
        })
    </script>-->

    <script>
        onload=function(){
            let dd=document.getElementById("dd");
            $(dd).html("123");
        }
    </script>

</head>
~~~





### 3. jQuery操作标签的文本和value值方法

val()    html()     text()

~~~
val([value]): 获得/设置元素value属性相应的值  
html([value]):获得/设置元素的标签体内容  
text([value]): 获得/设置元素的文本内容	
~~~

~~~~html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>jq操作文本和value值的方法.html</title>
    <!--
        html([参数])
            操作标签体  <a href="#">百度</a>
        text([参数])
           操作标签文本的  百度
        val([参数])
           操作标签value属性值的

        以上3个方法 不写参数是获取内容  写上参数是设置内容

    -->

    <script src="../js/jquery-3.3.1.js"></script>
    <script>
        $(function(){
            //html([参数])
            //alert($("#dd").html());  //获取div中的内容（包含标签体） <a href="#">百度</a>
            //$("#dd").html("<h3>abcdefg</h3>"); //覆盖原有的标签体
        })
    </script>

    <script>
        $(function(){
            //text([参数])
            //alert($("#dd").text()); //获取div中的内容(只包含文本)  百度
            //$("#dd").text("<h3>abcdefg</h3>");//覆盖原有的标签体
        })
    </script>


    <script>
        $(function(){
            alert($("#t1").val()); //获取带有value属性值的内容
            $("#t1").val("dcba"); //赋值 覆盖
        })
    </script>

</head>
<body>
        <div id="dd">
            <a href="#">百度</a>
        </div>

        <hr/>

        <input type="text" value="abcd" id="t1">

</body>
</html>
~~~~



### 4. jQuery操作标签属性

~~~
attr(属性名，[值])方法   弊端
prop(属性名，[值])方法   jq:1.6版本之后才能用到的属性
~~~

代码演示：

~~~html
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="../js/jquery-3.3.1.js"></script>
    <!--
         获取标签属性的方法：
                attr(属性,[值])
                prop(属性,[值])
                不写值是获取  写上是设置
    -->

    <script>
        $(function(){
            // 获取属性
            alert($("#%E5%89%8D%E7%AB%AF_assetss").attr("alt"));
            // 设置属性 覆盖/添加
            //$("#%E5%89%8D%E7%AB%AF_assetss").attr("width","500px");
            // 删除属性
            //$("#%E5%89%8D%E7%AB%AF_assetss").removeAttr("width");
        })
    </script>


    <script>
        $(function(){
             //添加事件   jquery.不带on事件名(function(){触发内容})
            $("#ck").click(function(){
                //attr属性中的弊端  获取复选的checked属性 不是我们要的结果
                alert($("#ck").attr("checked"));  //获取的不是想要的结果
                // 1.6之后，有一个新的属性 代替了attr
                alert($("#ck").prop("checked")); //获取的是想要的结果
            })
        })
    </script>

    <!--总结是：
            获取/设置属性可以选择attr或prop
            但是获取复选框或者是下拉框一定要选择使用prop

    -->
</head>
<body>
    <%E5%89%8D%E7%AB%AF_assets src="../%E5%89%8D%E7%AB%AF_assets/12.jpg" alt="图片没要找到" width="300px" id="%E5%89%8D%E7%AB%AF_assetss" />
    <hr/>
    <input type="checkbox" id="ck" />

</body>
</html>
~~~



### 5. jquery操作标签样式

~~~
css(name,[value]) 获取/设置指定的CSS样式
addClass(value)   给指定的标签添加样式
removeClass(value)  删除指定的样式	 
toggleClass(value) 切换样式，如果没有样式，则添加，如果有样式，则删除
~~~

~~~html
<head>
    <meta charset="UTF-8">
    <title>jquery操作标签样式</title>
    <script src="js/jquery-3.3.1.min.js"></script>
    <style>
        .style{
            width:300px;
            height: 200px;
            background-color: blue;
        }
    </style>
    <script>
        $(function(){
            //jq的事件绑定方式
            $("#bt1").click(function () {
                // 设置div标签样式
                //$("#d1").css("width","300");
                //$("#d1").css("height","200");
                //$("#d1").css("background-color","red");
                
              	// 获取div标签的样式
                //alert($("#d1").css("height"));
                //alert($("#d1").css("background-color"));

                //addClass(样式)：可以给某个标签添加外部样式
                //$("#d1").addClass("style");

                //removeClass(样式):删除指定的样式
                //$("#d1").removeClass("style");

                // toggleClass(样式) 如果该标签有样式 是删除  如果该标签没样式 是添加
                $("#d1").toggleClass("style");
            })
        })
    </script>
</head>
<body>
        <div id="d1">
            abcdefg
        </div>
        <input type="button" value="变身" id="bt1"/>
</body>
</html>
~~~

### 6. Jquery事件绑定

jQuery的事件与js的事件的功能和作用一样，只是在使用语法上稍微有些差异。

~~~js
js对象.事件名=function(){}
		js对象.onclick=function(){}

jq对象.事件名(function(){})
		jq对象.click(function(){})
~~~

### 7. jquery操作标签的方法

~~~
append(element) 添加到最后一个子元素，两者之间是父子关系
prepend(element) 添加到第一个子元素，两者之间是父子关系
before(element) 添加到当前元素的前面，两者之间是兄弟关系
after(element) 添加到当前元素的后面，两者之间是兄弟关系
remove() 删除指定元素
empty() 清空元素的所有子元素
~~~

代码演示：

~~~html
<head>
    <meta charset="UTF-8">
    <title>jq操作标签的方法.html</title>
    <!--
        append(element) 添加到最后一个子元素，两者之间是父子关系
        prepend(element) 添加到第一个子元素，两者之间是父子关系
        before(element) 添加到当前元素的前面，两者之间是兄弟关系
        after(element) 添加到当前元素的后面，两者之间是兄弟关系
        remove() 删除指定元素
        empty() 清空元素的所有子元素
    -->

    <script src="../js/jquery-3.3.1.js"></script>
    <script>
        //ol -- li 是父子关系
        $(function(){

            //append(element) 添加到最后一个子元素，两者之间是父子关系
            $("#ol").append("<li>重庆1</li>");  //$("<li>重庆</li>").appendTo($("#ol"));
            //prepend(element) 添加到第一个子元素，两者之间是父子关系
            $("#ol").prepend("<li>重庆2</li>");
        })
    </script>

    <script>
        // 兄弟关系  li --li 是兄弟关系 before之前 after之后
        $(function(){
            //before(element) 添加到当前元素的前面，两者之间是兄弟关系
            $("#ll").before("<li>重庆3</li>");
            // after(element) 添加到当前元素的后面，两者之间是兄弟关系
            $("#ll").after("<li>重庆4</li>");
        })
    </script>

    <script>
        $(function(){
            $("#ll").remove(); //删除指定元素
        })
    </script>

    <script>
        $(function(){
            $("#ol").empty(); //清空指定元素下的所有内容
        })
    </script>
</head>
<body>
            <ol id="ol">

                <li>北京</li>

                <li id="ll">上海</li>

                <li>广州</li>
                <li>深圳</li>

            </ol>
</body>
~~~



## jq选择器

选择器：就是帮你获取到页面标签的方式

~~~
1 基本选择器
ID选择器       $("#id名称")   需要html标签上有id属性
类选择器       $(".class名称") 需要html标签上有class属性
元素选择器     $("标签元素名称")
----------------------------------------------------------------		  	
2 层级选择器
元素1 元素2    匹配元素1下面的所有元素2(包含子子孙孙)
元素1>元素2    匹配元素1下面的所有元素2（只包含子元素）
-----------------------------------------------------------------
3 基本过滤选择器
元素:first     根据过滤获取第一个元素
元素:last      根据过滤获取最后一个元素
元素:even      根据过滤获取偶数索引的元素
元素:odd       根据过滤获取奇数索引的元素
元素:not(元素) 根据过滤获取不包含指定元素的所有元素
元素:eq(索引)  根据过滤获取索引相等的元素
元素:gt(索引)  根据过滤获取大于索引的元素
元素:lt(索引)  根据过滤获取小于索引的元素
-----------------------------------------------------------------
4 属性选择器
$("A[属性名]")  根据标签元素的属性名来匹配
$("A[属性名=值]") 根据标签元素的属性名的值来匹配
$("A[属性名=值][属性名=值] ...") 包含多个属性条件的选择器 
--------------------------------------------------------------
~~~

基本选择器代码演示

~~~html
<head>
    <meta charset="UTF-8">
    <title>基本选择器</title>
    <link rel="stylesheet" href="../css/style.css" /> <!--css-->
    <script src="../js/jquery-3.3.1.js"></script> <!--jquery-->
    <script>
         $(function(){
             $("#bt1").click(function(){
                 // 让id为one的div背景色变成红色     ID选择器       $("#id名称")   需要html标签上有id属性
                 $("#one").css("background-color","red");
             })

             $("#bt2").click(function(){
                 //让class为mini的div背景色变成红色  类选择器       $(".class名称") 需要html标签上有class属性
                 $(".mini").css("background-color","red");
             })


             $("#bt3").click(function(){
                 //让所有div背景色变成红色  元素选择器     $("标签元素名称")
                $("div").css("background-color","red");
             })

         })
    </script>
</head>
<body>
        <div id="one">
            <div class="mini">11111</div>
        </div>

        <div id="two">
            <div class="mini">22222</div>
            <div class="mini">33333</div>
        </div>

        <div id="three">
            <div class="mini">44444</div>
            <div class="mini">55555</div>
            <div class="mini">66666</div>
        </div>


        <span id="four"></span>

        <input type="button" value="让id为one的div背景色变成红色" id="bt1" />
        <input type="button" value="让class为mini的div背景色变成红色" id="bt2" />
        <input type="button" value="让所有div背景色变成红色" id="bt3" />
</body>
~~~

层级选择器代码演示

~~~html
<head>
    <meta charset="UTF-8">
    <title>基本选择器</title>
    <link rel="stylesheet" href="../css/style.css" /> <!--css-->
    <script src="../js/jquery-3.3.1.js"></script> <!--jquery-->
    <script>
        $(function(){
            $("#bt1").click(function(){
                //让body下的所有div背景色变成红色  元素1 元素2    匹配元素1下面的所有元素2(包含子子孙孙)
                $("body div").css("background-color","red");
            })

            $("#bt2").click(function(){
                //让body下子div背景色变成红色  元素1>元素2    匹配元素1下面的所有元素2（只包含子元素）
                $("body>div").css("background-color","red");
            })
        })

    </script>
</head>
<body>
        <div id="one">
            <div class="mini">11111</div>
        </div>

        <div id="two">
            <div class="mini">22222</div>
            <div class="mini">33333</div>
        </div>

        <div id="three">
            <div class="mini">44444</div>
            <div class="mini">55555</div>
            <div class="mini">66666</div>
        </div>
        <span id="four"></span>

        <input type="button" value="让body下的所有div背景色变成红色" id="bt1" />
        <input type="button" value="让body下子div背景色变成红色" id="bt2" />
</body>
~~~

基本过滤选择器代码演示

~~~html
<head>
    <meta charset="UTF-8">
    <title>基本选择器</title>
    <link rel="stylesheet" href="../css/style.css"> <!--css-->
    <script src="../js/jquery-3.3.1.js"></script> <!--jquery-->
    <script>
         $(function(){
             $("#bt1").click(function(){
                 //让第一个div元素背景红色  元素:first     根据过滤获取第一个元素
                 $("div:first").css("background-color","red");
             })

             $("#bt2").click(function(){
                 //让最后一个div元素背景红色  元素:last      根据过滤获取最后一个元素
                $("div:last").html("background-color","red");
             })

             $("#bt3").click(function(){
                 //让偶数div元素背景红色  元素:even      根据过滤获取偶数索引的元素
                 $("div:even").css("background-color","red");
             })

             $("#bt4").click(function(){
                 //让奇数div元素背景红色  元素:odd       根据过滤获取奇数索引的元素
                 $("div:odd").css("background-color","red");
             })

             $("#bt5").click(function(){
                 //让class不为mini的div元素背景红色  元素:not(元素) 根据过滤获取不包含指定元素的所有元素
                 $("div:not(.mini)").css("background-color","red");
             })

             $("#bt6").click(function(){
                 //让索引值是3的div元素背景红色  元素:eq(索引)  根据过滤获取索引相等的元素
                 $("div:eq(3)").css("background-color","red");
             })

             $("#bt7").click(function(){
                 //让索引值大于3的div元素背景红色  元素:gt(索引)  根据过滤获取大于索引的元素
                 $("div:gt(3)").css("background-color","red");
             })

             $("#bt8").click(function(){
                 //让索引值小于3的div元素背景红色  元素:lt(索引)  根据过滤获取小于索引的元素
                 $("div:lt(3)").css("background-color","red");
             })

         })
    </script>
</head>
<body>
        <div id="one"> <!--0-->
            <div class="mini">11111</div> <!--1-->
        </div>
        <div id="two"> <!--2-->
            <div class="mini">22222</div> <!--3-->
            <div class="mini">33333</div> <!--4-->
        </div>
        <div id="three"> <!--5-->
            <div class="mini">44444</div> <!--6-->
            <div class="mini">55555</div> <!--7-->
            <div class="mini">66666</div> <!--8-->
        </div>
        <span id="four"></span>

        <input type="button" value="让第一个div元素背景红色" id="bt1" />
        <input type="button" value="让最后一个div元素背景红色" id="bt2" />
        <input type="button" value="让偶数div元素背景红色" id="bt3" />
        <input type="button" value="让奇数div元素背景红色" id="bt4" />
        <input type="button" value="让class不为mini的div元素背景红色" id="bt5" />
        <input type="button" value="让索引值是3的div元素背景红色" id="bt6" />
        <input type="button" value="让索引值大于3的div元素背景红色" id="bt7" />
        <input type="button" value="让索引值小于3的div元素背景红色" id="bt8" />
</body>
~~~

属性选择器代码演示

~~~html
<head>
    <meta charset="UTF-8">
    <title>基本选择器</title>
    <link rel="stylesheet" href="../css/style.css"> <!--css-->
    <script src="../js/jquery-3.3.1.js"></script> <!--jquery-->
    <script>
        $(function(){
            $("#bt1").click(function(){
                //让有id属性的div标签背景变红色  $("A[属性名]")  根据标签元素的属性名来匹配
                $("div[id]").css("background-color","red");
            })


            $("#bt2").click(function(){
                //让有id属性且值是two的div标签背景变红色  $("A[属性名=值]") 根据标签元素的属性名的值来匹配
                $("div[id='two']").css("background-color","red");
            })


            $("#bt3").click(function(){
                //让有title属性值是t3且id属性值是three标签背景变红色  $("A[属性名=值][属性名=值] ...") 包含多个属性条件的选择器
                $("div[title='t3'][id='three']").css("background-color","red");
            })
        })
    </script>
</head>
<body>
        <div id="one" title="t1">
            <div class="mini">11111</div>
        </div>
        <div id="two" title="t2">
            <div class="mini">22222</div>
            <div class="mini">33333</div>
        </div>
        <div id="three" title="t3">
            <div class="mini">44444</div>
            <div class="mini">55555</div>
            <div class="mini">66666</div>
        </div>
        <span id="four"></span>

        <input type="button" id="bt1" value="让有id属性的div标签背景变红色">
        <input type="button" id="bt2" value="让有id属性且值是two的div标签背景变红色">
        <input type="button" id="bt3" value="让有title属性值是t3且id属性值是three标签背景变红色">
</body>
~~~



## jq遍历方式

jquery的遍历循环方法

```markdown
1 普通遍历    for(var i=0;i<数组/集合.length;i++)
2 jquery对象方法遍历   $(“数组/集合”).each(function(a,b){})
3 jquery3.0特有的方式 for(变量名 of 数组/集合)
```

细节：

~~~
1 for循环中的每个元素获取都是dom对象 $(arr[i])
2 this代表的是dom对象  $(this)
~~~

代码演示：

~~~html
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <!--
           jq的遍历循环：
                    1 普通遍历  for(let i=xx;i<xx.length;i++){}
                    2 jq的遍历方法  $("数组/集合").each(function(a,b){})  a:角标  b:角标的内容
                    3 jq3.0特有的方法 条件是要使用jq3.0版本以上的js库  for(el of 数组/集合)

    -->
    <script src="../js/jquery-3.3.1.js"></script>
    <!--1 普通遍历  for(let i=xx;i<xx.length;i++){}-->
    <!--<script>
        $(function(){
            let arr=$("li");
            for(let i=0;i<arr.length;i++){
                // jq循环的细节1：在jq循环中的每一个标签元素都是js对象 不是jq对象
                // jq循环的细节2：在jq循环中的this这个应用也是js对象 不是jq对象
                        // 要不用js的方法 要不转jq 用jq的方法
                alert($(arr[i]).text());//进行包装
            }
        })
    </script>-->

    <!--2 jq的遍历方法
            $.each($("li"),function(a,b){})
    -->
   <!-- <script>
        $(function(){
            $("li").each(function(a,b){
                //a 角标
                //b 角标的内容
                alert(a+":"+$(b).text());
            })
        })
    </script>-->


    <!--jq3.0特有的方法 条件是要使用jq3.0版本以上的js库 -->
    <script>
        $(function(){
            let arr=$("li");
            for(el of arr){
                alert($(el).text());
            }
        })
    </script>


</head>
<body>
            <ol id="ol">
                <li>北京</li>
                <li>上海</li>
                <li>广州</li>
                <li>深圳</li>
            </ol>
</body>
~~~



## 综合案例

### 1. 隔行换色

```html
<script>
    // 奇数行
    $('tr:eq(1):even').css('background-color','lightgray');
    // 偶数行
    $('tr:eq(1):odd').css('background-color','skyblue');
    
</script>
```



### 2. 商品全选

```html
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <title>案例-商品全选</title>
    <script src="../js/jquery-3.2.1.min.js"></script>
</head>
<body>
<!--
商品全选
    1. 全选 点击全选按钮,所有复选框都被选中
    2. 反选 点击反选按钮,所有复选框状态取反
-->
<button id="btn1">1. 全选</button>
<button id="btn2">2. 反选</button>
<br/>
<input type="checkbox">电脑
<input type="checkbox">手机
<input type="checkbox">汽车
<input type="checkbox">别墅
<input type="checkbox" checked="checked">笔记本
<script>
    $(function(){
      $("#ckbox").click(function(){
        //var checkedvalue=$(this).prop("checked");
        //$(".itemSelect").prop("checked",checkedvalue);
        $(".itemSelect").prop("checked",$(this).prop("checked"));
      })

      // 反选
      $("#bt1").click(function(){
        $(".itemSelect").click();
      })
    })
</script>
</body>
</html>
```

### 3. QQ表情

```html
<script>
        $(function(){
            $("ul %E5%89%8D%E7%AB%AF_assets").click(function(){
                // 将当前点击的图片移入到另一个标签的末尾
                // $("p").append($(this));
                //$(this).appendTo($("p"));

                //优化：当前点击的图片克隆一份 移入到另一个标签的末尾 保证自己还存在
                $(this).clone().appendTo($("p"));
            })
        })
    </script>
```

# Ajax

Asynchronous  Javascript And XML（异步 JavaScript 和 XML)

通过在后台与服务器进行少量数据交换，Ajax 可以使网页实现异步更新

传统的web前端与后端的交互中, 浏览器直接访问Tomcat的Servlet来获取数据, Servlet通过转发把数据发送给浏览器

当我们使用Ajax之后, 浏览器显示把请求发送到XMLHttpRequest异步对象之中, 异步对象对请求进行封装, 然后再发送给服务器, 服务器并不是以转发的方式响应, 而是以流的方式把数据返回给浏览器

XMLHttpRequest异步对象会不停的监听服务器状态的变化, 得到服务器返回的数据, 就写到浏览器上, 因为不是转发的方式, 所以是无刷新就能够获取服务器端的数据

## 浏览器和后台服务器交互的方式

1. 超链接

   ```html
   <a href"浏览器地址?username="jack">提交</a>
   ```

2. 表单提交数据

   ```html
   <from action="服务器的地址" method="post">
   <input type="text" name="username" value="用户填写的">
   </from>
   ```

3. js的方式

   ```js
   location.href = "服务器的地址? username ="'要传递的数据'"
   ```

   Location对象是Window对象的一部分, window.location()是显示当前网页的url

   location.href

4. Ajax(异步提交)

## js的Ajax的交互方式

1. 创建ajax对象

    ```javascript
    let xhr = new XMLHttpRequest();
    ```

2. 告诉ajax请求方式和请求服务器的地址

    ```javascript
    xhr.open(请求方式，请求地址);
    ```

3. 发送请求

    ```javascript
    xhr.send();
    ```

4. 获取服务器返回的数据

    ```javascript
    xhr.onload=function(){
    	xhr.responseText;
    }
    ```

## JQuery的ajax交互方式

### 第一种, 第二种交互方式

```
方式一 $.get(url,[data],[fn],[dataType]):发送了一个get请求
方式二 $.post(url,[data],[fn],[dataType]):发送一个post请求
参数介绍：
url:要访问的地址
data:要传递的数据，是json字符串的格式 key=value
有两种格式：
json格式：
	data:{"username":"chen","nickname":"alien"}
标准参数模式：
	data:"username=chen&nickname=alien"
  发送给服务器端的请求参数，
  格式：
  方式一：key=value&key=value
  方式二：{key:value,key:value...}
fn(d): 回调函数  d:代表的是服务器响应回来的数据
dataType:服务器响应的数据类型 
			默认 text:字符串格式 
			     json:json格式
第四个参数 type 类型  说的响应结果的数据的封装类型 ？    
  text 响应的结果是以文本形式回来的。
  json 响应的结果是以json形式回来的。
  xml  响应的结果是以xml形式回来的。
	如果不写默认是text文本
```

```js
<script>
    $(function(){
    $("#bt").click(function(){
        // 编写jq的ajax代码
        let url="http://localhost:8080/fuwuqi/ht1";
        let data={"username":"zhangsan"};  //json格式
        $.get(url,data,function(d){
            alert(d);  //打印服务器还回来的数据  (字符串)
        });
    })
})
</script>
```

### 第三种, 交互方式

```
方式三：
$.ajax({key:value})
参数介绍：
type：提交方式
url:访问地址
data:传递的参数
success:服务器响应成功之后的回调函数
error：服务器响应失败之后的回调函数
dataType:服务器返回来的数据类型 默认字符串
```

```js
<script>
    $(function(){
      $("#bt").click(function(){
          // jq的ajax异步和服务器交换数据
          $.ajax({
              type:"post",
              url:"http://localhost:8080/fuwuqi/ht1",
              data:{"username":"zhangsan"},
              success:function(d){alert(d)},
              error:function(){alert("访问服务器失败")}
          });
      })
  	})
</script>
```

## 附: 四种访问服务器的方式

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <script src="../WEB-INF/lab/jquery-3.3.1.js"></script>
    <script>
        function newLocation() {
        <!--js的window.location的方式跳转-->
            window.location="http://localhost:8080/name/myMethod";
        }
        /*Ajax的跳转方式*/
        $(function () {
            var xhr = new XMLHttpRequest();
            $("#ajax").blur(function () {
                var url = "http://localhost:8080/name/myMethod";
                var data = {"usernaem":"zhangsan"};
                $.get(url,data,function (d) {
                })
            })
        })

    </script>
</head>
<body>
<!--form表单的跳转方式-->
<form method="get" action="/name/myMethod">
    用户名<input type="text"/>
    <br/>
    密码<input type="text"/>
    <input type="submit" value="提交"/>
</form>
<form method="post" action="http://localhost:8080/name/myMethod">
    用户名<input type="text"/>
    <br/>
    密码<input type="text"/>
    <input type="submit" value="提交"/>
    <br/>
    <input type="button" value="js的location跳转" onclick="newLocation()"/>
    <br/>
    ajax
    <input type="text" id="ajax">
</form>
<!--超链接的跳转方式-->
<!--相对路径进行访问-->
<a href="myMethod" target="_blank">点击我跳转1</a>
<!--绝对路径进行访问-->
<a href="http://localhost:8080/name/myMethod" target="_blank">点击我跳转2</a>
<!--不带协议的绝对路径进行访问-->
<a href="/name/myMethod" target="_blank">点击我跳转3</a>
<br/>

</body>
</html>
```

# Vue

Vue (读音 /vjuː/，类似于view) 是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。

我们需要先引入环境

```html
<script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
```

或者将js文件下载到本地，便于练习使用

```html
<script src="js/vue2.6.12.js"></script>
```

### 声明式渲染

Vue.js 的核心是一个允许采用简洁的模板语法来声明式地将数据渲染进 DOM 的系统：

#### 文本插值

```html
<body>
  <div id="app">
    <p>{{user1.username}}</p>
    <!--里面可以进行运算 36-->
    <p>{{user1.age*2}}</p>
    <!--123456-->
    <p>{{user1.password+456}}</p> 
    <!--否-->
    <p>{{user1.vip?"是":"否"}}</p>
  </div>	
</body>

<script>
  var app = new Vue({
    el:'#app',
    data:{
      user1:{username:"小明",age:18,password:"123",vip:false}
    }
  })
</script>
```

问：new Vue都发生了什么？

new关键字在JS中代表实例化一个对象，而JS中类是通过function进行实现的，通过源码发现会执行初始化操作，Vue 初始化主要就干了几件事情，合并配置，初始化生命周期，初始化事件中心，初始化渲染，初始化 data、props、computed、watcher 等等，最后初始化完成检测到如果有 el 属性，则调用 vm.$mount 方法挂载 vm，挂载的目标就是把模板渲染成最终的DOM；此过程我们重点关注initState以及最后执行的mount.

#### 绑定元素属性

除了文本插值，我们还可以像这样来绑定元素 attribute

`v-bind`

你看到的 `v-bind` attribute 被称为**指令**。指令带有前缀 `v-`，以表示它们是 Vue 提供的特殊 attribute。可能你已经猜到了，它们会在渲染的 DOM 上应用特殊的响应式行为。在这里，该指令的意思是：“将这个元素节点的 `title` attribute 和 Vue 实例的 `message` property 保持一致”。

`v-on`

为了让用户和你的应用进行交互，我们可以用 `v-on` 指令添加一个事件监听器，通过它调用在 Vue 实例中定义的方法

 `v-model` 

Vue 还提供了 `v-model` 指令，它能轻松实现表单输入和应用状态之间的双向绑定

































































































