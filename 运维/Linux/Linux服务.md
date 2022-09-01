# Linux服务

服务（service），即一个**常驻内存的程序**，也被称为daemon，后台程序。

当我们启动Linux之后，系统就帮我们启动了很多服务，例如打印服务、ssh连接服务，定时调度服务等。

一般服务命名都会以d结尾，即daemon，例如sshd，crond，mysqld。

## system V版本

在Unix的早期版本system V中，我们启动系统服务是通过init脚本的处理方式，即系统核心调用的第一个程序是init，然后init去唤醒所有系统所需要的服务。

所有的服务启动脚本通常放在`/etc/init.d/`下面，即程序提供的一个shell脚本，可以直接调用，如下：

- `/ect/init.d/daemon start`
- `/ect/init.d/daemon stop`
- `/ect/init.d/daemon restart`
- `/ect/init.d/daemon status`

也可以通过service命令来调用，如下：

格式：

```
service SCRIPT-Name COMMAND
```

service命令相当于把COMMAND传递给`/etc/init.d`中的对应脚本。

还可以利用chkconfig命令来管理服务：

例如：

- 列出所有SysV服务

  ```
  $ chkconfig --list
  ```

- 开启自启动

  ```
  $ chkconfig rhnsd on
  ```

## CentOS 7.x版本

从CentOS 7.x之后，放弃了上述启动脚本的方式，改用systemd启动服务机制，systemd将服务的执行脚本称为一个服务单元（unit），放在`/usr/lib/systemd/system`等目录下，例如：

```
$ ls /usr/lib/systemd/system|grep cron
crond.service
$ ls /usr/lib/systemd/system|grep clickhouse
clickhouse-server.service
```

`crond.service`是定时处理服务，`clickhouse-server.service`是数据库软件ClickHouse注册的服务。

systemd机制有如下特点：

- 平行处理所有服务，旧的init启动脚本的是一项一项任务依次启动，而现在的主机和操作系统基本都是多核架构，采用并发启动的方式更加合理，大大加快了系统的启动速度。

- systemd的所有操作仅仅通过`systemctl`这一个命令即可实现，不像上述init的方式还需要`init`、`chkconfig`

  、`service`等命令。

- 服务相依性的自我检查，即如果B服务的启动需要依赖A服务，启动服务B的时候，systemd会自动帮你启动A服务。

- 将服务单位unit按照功能进行分类：service、socket、target、path等。

- 向下兼容旧的init的方式。

### 通过systemctl进行管理

格式：

```
systemctl [command] [unit]
```

command：

- `start`

- `stop`

- `restart`

  关闭unit，然后再start。

- `reload`

  不关闭unit，重新载入配置。

- `enable`

  设置开机自启。

- `disable`

- `status`

查看系统的所有启动的服务：

```
$ systemctl list-units
```

查看系统中所以的服务：

```
$ systemctl list-units --all
```

### systemctl配置文件

```
$ cat /usr/lib/systemd/system/sshd.service
[Unit]
Description=OpenSSH server daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target sshd-keygen.service
Wants=sshd-keygen.service

[Service]
Type=notify
EnvironmentFile=/etc/sysconfig/sshd
ExecStart=/usr/sbin/sshd -D $OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=on-failure
RestartSec=42s

[Install]
WantedBy=multi-user.target
```

主要分为三个部分：

- `[Unit]`

  unit本身，以及前置依赖。

- `[Service]/[Socket]/[Timer]`

  不同unit的配置，指定了启动/关闭/重新启动服务的脚本。

- `[install]`

  此unit要挂载到哪个target下面。

## References

1. 《鸟哥Linux私房菜》