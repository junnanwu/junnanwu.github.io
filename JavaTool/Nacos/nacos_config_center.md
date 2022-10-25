# Nacos配置中心

Nacos作用之一就是作为配置中心。

Nacos配置中心提供了如下功能：

- 支持JSON、XML、YAML、HTML、Properties多种类型的配置文件
- 支持配置文件的版本记录（不支持不同版本之间进行diff）
- 支持配置文件的导出和导入
- 支持不同环境使用、即不同环境之间的隔离
- docker、k8s等多种安装方式

## 核心概念

- Namespace

  不同的命名空间下，可以存在相同的 Group 或 Data ID 的配置。Namespace 的常用场景之一是不同环境的配置的区分隔离，例如开发测试环境和生产环境的资源（如配置、服务）隔离等。

- Group

  一个系统和应用可能包括多个配置集，Group即代表这个组织或者配置集，默认分组为`DEFAULT_GROUP`。

- Data Id

  即一个配置集的唯一Id

- 配置快照

  Nacos客户端SDK会在本地生成配置快照，当客户端无法连接到Nacos的时候，可以读取本地配置快照。

![nacos_data_model](nacos_config_center_assets/nacos_data_model.jpeg)

## 鉴权

- 人员

  可以添加用户，同时支持LADP。

- 角色

  一个人可以绑定多个角色。

- 资源

  资源可选的只有namespace，一个角色可以绑定多个资源。

注意，要想使用鉴权，需要将服务端的`nacos.core.auth.enabled`配置设置为true。

## SpringBoot示例

### 引入依赖

```xml
<dependency>
    <groupId>com.alibaba.boot</groupId>
    <artifactId>nacos-config-spring-boot-starter</artifactId>
    <version>0.2.7</version>
</dependency>
```

[此处](https://github.com/nacos-group/nacos-spring-boot-project/wiki)可以查看不通版本的的升级内容。

注意，在使用Nacos`0.2.1`版本以上的时候，对应Spring版本不要超过`2.4`，不然会报如下错误：

```
Error creating bean with name ‘nacosConfigurationPropertiesBinder’: Bean instantiation via constructor failed; nested exception is org.springframework.beans.BeanInstantiationException: Failed to instantiate
```

### 配置文件

在`application.yml`中加如下配置：

```yml
nacos:
    config:
        auto-refresh: true
        bootstrap:
            enable: true
        data-id: xxx
        group: xxx
        namespace: 713e5b47-b390-489a-9db8-37d9a7089c26
        server-addr: 127.0.0.1:8848
        type: yaml
        username: xxx
        password: xxx
```

这样就可以将原来的配置都复制到Nacos中，你的项目即可读到。

注意：

- 当服务端开启权限之后，此处配置就需要增加username和password，即登录Nacos的账号密码。
- `nacos.config.bootstrap.enable`配置是开启Nacos配置预加载，如果在启动过程中需要读到的配置咋Nacos中，那么需要开启此配置。

### 使用

```java
@RestController
@RequestMapping("nacos")
public class NacosController {

    @NacosValue(value = "${nacos.key01}", autoRefreshed = true)
    private String key01;

    @Value(value = "${nacos.key02}")
    private String key02;

    @GetMapping("key01")
    Object getConfig01(){
        return key01;
    }

    @GetMapping("key02")
    Object getConfig02(){
        return key02;
    }
}
```

`nacos.key01`即会自动刷新，`nacos.key02`则是原有的方式获取值。

### 实际应用

我们是希望多个部门进行使用，而namespace作为资源可以绑定到角色上，处于此，我们将namespace与部门结合，例如：

- 数据组uat环境：data-uat
- 增长组prod环境：grow-prod

再将namespace绑定在角色上，角色绑定在人员上，即可实现部门之间、生产和测试环境之间的隔离。

## References

1. Nacos官方文档：[Nacos 文档](https://nacos.io/zh-cn/docs/what-is-nacos.html)
3. Nacos Wiki：[nacos-spring-boot-project wiki](https://github.com/nacos-group/nacos-spring-boot-project/wiki)