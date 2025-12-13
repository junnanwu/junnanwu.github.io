# Linux安装字体

安装字体库

```
$ sudo yum -y install fontconfig
```

在下面目录创建chinese文件夹，并将字体文件上传：

```
$ cd /usr/share/fonts
$ mkdir chinese
```

修改权限

```
$ sudo chmod -R 755 chinese/
```

刷新缓存

```
$ fc-cache
```

查看字体列表

```
$ fc-list
```

