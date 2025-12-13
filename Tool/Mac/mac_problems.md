# Mac遇到的问题

## 无法验证开发者

当弹出：无法打开"chromedriver"，因为无法验证开发者的时候

需要执行如下：

```
$ xattr -d com.apple.quarantine /usr/local/bin/chromedriver
```

若目录带有空格：

```
$ xattr -d com.apple.quarantine '/Applications/Another Redis Desktop Manager.app'
```

## 无法打开可执行文件

有时候我们的shell脚本文件，突然无法执行：

```
$ ./_generate_sidebar.sh
zsh: operation not permitted: ./_generate_sidebar.sh
```

查看此文件，发现类型后面多了个`@`：

```
$ ll _generate_sidebar.sh
-rwxr-xr-x@ 1 wujunnan  staff   1.6K  6 16 11:47 _generate_sidebar.sh
```

这是因为系统对此文件添加了保护，如下操作即可：

```
$ sudo xattr -r -d com.apple.quarantine $filePath
```

## References

1. https://www.jianshu.com/p/203bddb231c3