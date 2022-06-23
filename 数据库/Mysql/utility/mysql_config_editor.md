# mysql_config_editor

## 背景

此工具解决了每次登录mysql都需要输入复杂密码的问题。

如果没有此工具，我们客户端正常登录流程如下：

```
$ mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
...
```

如果密码特别长，那么每次都需要输入。

这种登录方式没有`--login-path`参数，默认读取配置中 `[client]`和`[mysql]`组的配置（mysql的配置文件是属于某个组的）。

当我们指定了`--login-path=mypath`参数，则会默认读取配置中 `[client]`和`[mysql]`和`[mypath]`组的配置。

## 使用

我们可以通过mysql_config_editor来保存登录信息：

```
$ mysql_config_editor set --login-path=client --host=localhost --user=root --password
Enter password:
xxx
```

set选项：

- `--help`
- `--host=host_name, -h host_name`
- `--login-path=name, -G name`
- `--password, -p`
- `--port=port_num, -P port_num`
- `--socket=file_name, -S file_name`
- `--user=user_name, -u user_name`

我们可以看到在用户目录下（类Unix）生成了一个`.mylogin.cnf`文件，其内容为密文：

```
$ ll ~/.mylogin.cnf
-rw-------  1 wujunnan  staff   136B  6 23 23:23 .mylogin.cnf
```

注意，此文件优先级高于配置文件。

我们可以通过如下命令来查看：

```
$ mysql_config_editor print --all
[client]
user = root
password = *****
host = localhost
```

这样我们就可以通过如下方式不用输入密码即可登录了：

```
$ mysql --login-path=client
Welcome to the MySQL monitor.  Commands end with ; or \g.
...
```

我们也可以删除这个组信息，然后重新进行设置：

```
$ mysql_config_editor remove --login-path=client
```

详细配置，详见[官方文档](https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html)。

## References

1. https://dev.mysql.com/doc/refman/8.0/en/mysql-config-editor.html



