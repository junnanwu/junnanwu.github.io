# Typora

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
- [Markdown](#markdown)
- [Markdown](#markdown)
  - [高亮](#%E9%AB%98%E4%BA%AE)
  - [链接](#%E9%93%BE%E6%8E%A5)
  - [Emoji](#emoji)
  - [脚注](#%E8%84%9A%E6%B3%A8)
  - [HTML](#html)
    - [特殊符号](#%E7%89%B9%E6%AE%8A%E7%AC%A6%E5%8F%B7)
  - [数学公式](#%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F)
    - [行内公式](#%E8%A1%8C%E5%86%85%E5%85%AC%E5%BC%8F)
    - [数学公式块](#%E6%95%B0%E5%AD%A6%E5%85%AC%E5%BC%8F%E5%9D%97)
- [其他](#%E5%85%B6%E4%BB%96)
  - [配置自动图片上传](#%E9%85%8D%E7%BD%AE%E8%87%AA%E5%8A%A8%E5%9B%BE%E7%89%87%E4%B8%8A%E4%BC%A0)
  - [生成目录](#%E7%94%9F%E6%88%90%E7%9B%AE%E5%BD%95)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Markdown

Markdown是由 Daring Fireball创造的，但是不同的编辑器有不同的格式，Typora支持的是 [GitHub Flavored Markdown](https://help.github.com/articles/github-flavored-markdown/).

本文参考：[Markdown Reference](https://support.typora.io/Markdown-Reference/)

### 高亮

语法：`==...==`

例如：

- 这里是==高亮==

### 链接

Markdown支持两种链接：

- 内部链接

  [点击跳转HTML](#HTML)

- 引用链接

  [Google](https://www.google.com)

[详见这里](https://support.typora.io/Links/)

### Emoji

格式：`:happy:`

例如：

- :happy:
- :cn:

[点此查看typora支持Emoji](https://blog.csdn.net/qq_43630810/article/details/109108879)

### 脚注

语法：`[^1]:xxx`

例如：

- You can create footnotes like this[^1] 

### HTML

可以使用HTML来表示Markdown不支持的格式

例如：

- 红色字体

   <span style="color:red">this text is red</span>

  ```
   <span style="color:red">this text is red</span>
  ```

#### 特殊符号

Markdown同样支持HTML的特殊符号

| 代码       | 符号     |
| ---------- | -------- |
| `&divide;` | &divide; |

### 数学公式

#### 行内公式 

格式：`$...$`

例如：

- $\lim_{x \to \infty} \exp(-x) = 0$

  ```
  $\lim_{x \to \infty} \exp(-x) = 0$
  ```

- $\frac{3}{8}$

  ```
  $\frac{3}{8}$
  ```

#### 数学公式块

格式：`$$...$$`

例如：

- $$ \mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix} \mathbf{i} & \mathbf{j} & \mathbf{k} \\ \frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\ \frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\ \end{vmatrix} $$

  ```
  $$
  \mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
  \mathbf{i} & \mathbf{j} & \mathbf{k} \\
  \frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
  \frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
  \end{vmatrix}
  $$
  ```

[^1]: this is the reference



### 流程图

[详见此](https://support.typora.io/Draw-Diagrams-With-Markdown/)

```sequence
Alice->Bob: Hello Bob, how are you?
Note right of Bob: Bob thinks
Bob-->Alice: I am good thanks!
```

## 其他

### 配置自动图片上传

### 生成目录

有时候我们需要在文档开头生成整个文档的目录，我们就可以使用[doctoc](https://github.com/thlorenz/doctoc)工具。

- 全局安装

  ```
  $ npm install -g doctoc
  ```

- 给当前目录及所有子目录的md文件加目录

  ```
  $ doctoc .
  ```

- 给指定文件加上目录

  ```
  $ doctoc README.md
  
  $ doctoc CONTRIBUTING.md LICENSE.md
  ```

- 指定位置生成目录

  你可以将下面的标记放在你文档的任何位置让目录生成在这个中间。

  ```
  <!-- START doctoc -->
  <!-- END doctoc -->
  ```
  
- 更新目录

  ```
  <!-- START doctoc generated TOC please keep comment here to allow auto update -->
  <!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
  
  <!-- END doctoc generated TOC please keep comment here to allow auto update -->
  ```
  
  生成的目录这三行不要动，再次再次运行`doctoc`命令即可更新目录。

更多操作可以查看官方文档。

## test
