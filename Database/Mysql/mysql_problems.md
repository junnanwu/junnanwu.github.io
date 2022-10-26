# Mysql遇到的问题

## GTID模式下创建临时表问题

问题描述：

在安装bitbucket的时候，提示没有创建临时表的权限，后来经查询后，看到了这篇文章：[bitbucket安装连接数据库时提示没有创建临时表权限](https://www.cnblogs.com/liu102401/p/9660250.html)，才发现，原来是因为GTIDs。

GTID即Global Transaction Identifiers，全局事务ID，由serverID和事务ID构成，这就使得根据GTID来简化复制。

但是GTID也是有限制的：

> `CREATE TEMPORARY TABLE` and `DROP TEMPORARY TABLE` statements are not supported inside transactions.

即不能在事务中创建临时表。

## References

1. 官方文档：[Restrictions on Replication with GTIDs](https://dev.mysql.com/doc/refman/5.7/en/replication-gtids-restrictions.html)
2. 博客：[bitbucket安装连接数据库时提示没有创建临时表权限](https://www.cnblogs.com/liu102401/p/9660250.html)