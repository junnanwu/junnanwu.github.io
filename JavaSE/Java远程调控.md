# Java远程调控

## JPDA

JPDA（Java Platform Debugger Architecture）是一系列API和Java debug实现。

JDWP（Java Debug Wire Protocol）定义了debuggee和debugger之间的通信协议。

可以通过`-agentlib:jdwp` 或 `-Xrunjdwp`指定JDWP的配置：

```
java -agentlib:jdwp=transport=dt_socket,server=y,address=8000,suspend=n <other arguments>
```

```
java -Xdebug -Xrunjdwp:server=y,transport=dt_socket,address=4000,suspend=n myapp
```

参数：

- `transport`

  必选参数，

  >Name of the transport to use in connecting to debugger application. 

- `server`

  默认值为`n`

  > If "y", listen for a debugger application to attach; otherwise, attach to the debugger application at the specified `address. `
  >
  > If "y" and no address is specified, choose a transport address at which to listen for a debugger application, and print the address to the standard output stream.

- `suspend`

  > If "y", VMStartEvent has a suspendPolicy of SUSPEND_ALL. If "n", VMStartEvent has a suspendPolicy of SUSPEND_NONE.

- 

IDEA实现了对JPDA的支持





- `suspend`

  是否在调试客户端建立起来后再执行



![JPDA_architecture](Java%E8%BF%9C%E7%A8%8B%E8%B0%83%E6%8E%A7_assets/JPDA_architecture.png)

## References

- https://en.wikipedia.org/wiki/Java_Platform_Debugger_Architecture
- https://stackoverflow.com/questions/975271/remote-debugging-a-java-application
- https://docs.oracle.com/javase/8/docs/technotes/guides/jpda/conninv.html#Invocation