# git config

## 参数

- `--system`

  修改的是`/etc/gitconfig` 文件，这是系统上的每一个用户的通用配置

- `--global`

  修改的是`~/.gitconfig`，只针对当前用户

- `--local`

  修改的是当前本地仓库的配置文件及`.git/config`，`git config`默认使用的就是这个参数

- `--list -l`

  查看Git的配置

## 举例

- 安装完Git后，需要先设置用户名和密码

  ```
  $ git config --global user.name "John Doe"
  $ git config --global user.email johndoe@example.com
  ```

  如果使用了 `--global` 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息。 当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运行没有 `--global` 选项的命令来配置。

- 查看Git中该变量的原始值

  ```
  $ git config --show-origin user.name
  file:/Users/wujunnan/.gitconfig	wujunnan
  ```

- 设置别名

  ```
  $ git config --global alias.co commit
  ```

  下次使用commit命令时直接换成`git co` 即可

## 属性

## core.autocrlf

有时候当你提交文件的时候，会提示：

```
warning: CRLF will be replaced by LF in lombok.config.
```

这个是用于处理提交文件中的换行符：

```
$ git config core.autocrlf
input
```

此属性的取值可能为：

- `true`

  当你add时，文本文件中所有`CRLF`都会被替换成`LF`，即`\n`，当你checkout时，文本文件中所有的`LF`会被替换成`CRLF`，在widows电脑上可以这么设置。

- `false`

  不会执行任何换行符转换。

- `input`

  add时，将`CRLF`转换成`LF`，checkout时，不做转换，Mac电脑上可以这样配置。

所以，刚开始的提示的原因是我用的Mac OS，但是有个文件的换行符是`CRLF`，所以`add`的时候，自动转换成了`LF`。

## References

1. Git官方文档：[Customizing Git - Git Configuration](https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration)