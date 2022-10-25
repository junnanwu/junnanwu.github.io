# Jenkins

## Jenkins自动构建项目的类型

- 自由风格软件项目（Freestyle Project）

  Jenkins定义了一个应用的生命周期，你只需要在每个生命周期使用适当的插件即可。

- Maven项目（Maven Project）

- 流水线项目（Pipeline Project）

  使用流水线项目你可以自定义应用的整个生命周期，非常灵活。

## 自由风格项目

我们生产中实际使用的就是自由风格的方式，能实现简单的自动部署。

## 插件

### 用户管理

jenkins用户管理可以安装[Role-based Authorization Strategy插件](https://plugins.jenkins.io/role-strategy/)，这个插件基于角色进行权限的配置。

通过通配符匹配不同的任务来实现视图级别的隔离。

注意：

- 如果想要不同的用户只能看到指定的view，在配置Manage and Assign Roles-->Manage Roles-->Global Roles 时，不要给View的Read权限，要不然登录用户后能看到所有view

## 安装Jenkins

这里使用docker的方式安装Jenkins

```
$ docker run --name jenkins -d -p 8081:8080 -p 50000:50000 -v jenkins-data:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkinsci/blueocean
```

注意：这里看是否需要prefix，需要的话：

```
JENKINS_ARGS="--prefix=jenkins"
```

**安装npm**

在Docker容器中安装npm，由于需要部署前端文件，所以在Jenkins中需要安装npm。

由于官方镜像使用的alpine linux，所以采用的方式是：

```
$ apk add --update npm
```

## Reference

1. https://www.jenkins.io/zh/doc/
1. https://superuser.com/questions/1125969/how-to-install-npm-in-alpine-linux
