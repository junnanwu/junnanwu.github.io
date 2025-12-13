# Druid

## 配置

| 参数                          | 说明                                                         |
| ----------------------------- | ------------------------------------------------------------ |
| InitialSize                   | 初始化连接数                                                 |
| MinIdle                       | 最小的空闲连接数                                             |
| MaxActive                     | 最大允许的连接数                                             |
| MaxWait                       | 获取连接等待的超时时间                                       |
| TimeBetweenEvictionRunsMillis | 检测需要关闭的空闲连接的间隔时间                             |
| KeepAlive                     | 设置是否保持连接活动                                         |
| MinEvictableIdleTimeMillis    | 连接在池中的最小生存时间                                     |
| TestWhileIdle                 | 设置空闲时是否检测连接可用性                                 |
| TestOnBorrow                  | 设置获取连接时是否检测连接可用性                             |
| ValidationQuery               | 设置检测连接是否可用的sql语句                                |
| ValidationQueryTimeout        | 校验连接是否可用的超时时间                                   |
| ConnectionErrorRetryAttempts  | 设置获取连接出错时的自动重连次数                             |
| FailFast                      | 设置获取连接出错时是否马上返回错误，true为马上返回           |
| NotFullTimeoutRetryCount      | 设置获取连接时的重试次数，-1为不重试                         |
| BreakAfterAcquireFailure      | true表示向数据库请求连接失败后，就算后端数据库恢复正常也不进行重连，客户端对pool的请求都拒绝掉，false表示新的请求都会尝试去数据库请求connection，默认为false |

connectionErrorRetryAttempts：

经测试和查看源码：此参数不起作用

```java
//失败后循环进行连接
for (;;) {
    ...
    PhysicalConnectionInfo connection = null;

    try {
        connection = createPhysicalConnection();
    } catch (SQLException e) {
        LOG.error("create connection SQLException, url: " + jdbcUrl + ", errorCode " + e.getErrorCode()
                  + ", state " + e.getSQLState(), e);
        errorCount++;
        //connectionErrorRetryAttempts 连接失败重试次数，然而并不起作用
        if (errorCount > connectionErrorRetryAttempts && timeBetweenConnectErrorMillis > 0) {
            // fail over retry attempts
            setFailContinuous(true);
            if (failFast) {
                lock.lock();
                try {
                    notEmpty.signalAll();
                } finally {
                    lock.unlock();
                }
            }
			//失败后不进行重试
            if (breakAfterAcquireFailure) {
                break;
            }

            try {
                //失败等待间隔
                Thread.sleep(timeBetweenConnectErrorMillis);
            } catch (InterruptedException interruptEx) {
                break;
            }
        }
    } catch (RuntimeException e) {
        LOG.error("create connection RuntimeException", e);
        setFailContinuous(true);
        continue;
    } catch (Error e) {
        LOG.error("create connection Error", e);
        setFailContinuous(true);
        break;
    }

    if (connection == null) {
        continue;
    }

    boolean result = put(connection);
    if (!result) {
        JdbcUtils.close(connection.getPhysicalConnection());
        LOG.info("put physical connection to pool failed.");
    }

    errorCount = 0; // reset errorCount

    if (closing || closed) {
        break;
    }
}
```



**警告 discard long time none received connection. 问题**

源码在此：

```java
if (valid && isMySql) {
    long lastPacketReceivedTimeMs = MySqlUtils.getLastPacketReceivedTimeMs(conn);
    if (lastPacketReceivedTimeMs > 0) {
        long mysqlIdleMillis = currentTimeMillis - lastPacketReceivedTimeMs;
        if (lastPacketReceivedTimeMs > 0 //
            && mysqlIdleMillis >= timeBetweenEvictionRunsMillis) {
            discardConnection(holder);
            String errorMsg = "discard long time none received connection. "
                + ", jdbcUrl : " + jdbcUrl
                + ", version : " + VERSION.getVersionNumber()
                + ", lastPacketReceivedIdleMillis : " + mysqlIdleMillis;
            LOG.warn(errorMsg);
            return false;
        }
    }
}
```

- `lastPacketReceivedTimeMs` 即上次使用的时间
- `mysqlIdleMillis` 即空闲时间
- `timeBetweenEvictionRunsMillis` 默认60秒

所以含义就是，如果连接空闲了60秒以上，那么就丢弃这个连接并打印了errorMsg日志。

原理就是，如果数据库回收了连接，那么客户端将出现异常，那么就在客户端连接超时之后主动回收连接。

## References

- https://www.renfei.net/posts/1003414
- https://github.com/alibaba/druid/issues/1338