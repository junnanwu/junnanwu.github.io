# Linux日志

## /var/log/messages

这里记录了全局系统消息。

> This file has all the global system messages located inside, including the messages that are logged during system startup. Depending on how the syslog config file is sent up, there are several things that are logged in this file including mail, cron, daemon, kern, auth, etc

- 当程序因为系统OOM被杀死的时候，可以来这里看日志信息
- 磁盘读取出错的时候，这里也会记录日志