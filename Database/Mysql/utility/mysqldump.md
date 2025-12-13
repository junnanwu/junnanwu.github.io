# mysqldump

此工具可以对数据库进行备份。

格式：

```
mysqldump [options] db_name [tbl_name ...] > dump.sql
```

或者所有数据库：

```
mysqldump [options] --all-databases > dump.sql
```

## 参数

- `--user`

- `--password`

- `--host=host_name, -h host_name`

- `--skip-add-drop-table`

- `--skip-comments`

- `--where`

  只dump符合WHERE条件的行。

## References

1. https://dev.mysql.com/doc/refman/5.7/en/mysqldump.html