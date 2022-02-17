# Druid

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