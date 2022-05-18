# Mysql Information Schema

## PROCESSLIST

表示了mysql服务器的进程集。

注意：

- 与`SHOW PROCESSLIST`类似，如果你有`PROCESS`权限，那么你会看到所有用户的连接，否则，普通用户只能看到他们自己线程的信息

## INNODB_TRX

提供了信息关于在InnoDB中执行的当前的每个事务。

字段：

- `trx_id`

  事务id

- `trx_state`

  事务执行的状态， `RUNNING`、 `LOCK WAIT`、 `ROLLING BACK`、`COMMITTING`

- `trx_mysql_thread_id`

  事务线程id，可以和PROCESSLIST进行JOIN

- `trx_weight`

  事务的权重

- `trx_tables_locked`

  当前执行SQL的行锁数量

- `trx_lock_structs`

  事务保留的锁数量

- `trx_isolation_level`

  当前事务的隔离级别

### 应用

- 当某个表发生`metadata lock`死锁的时候，可以查看此表，`kill`对应session

## References

