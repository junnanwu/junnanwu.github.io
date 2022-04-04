# Jenkins

## Jenkins是什么？



## Jenkins自动构建项目的类型

- 自由风格软件项目（Preestyle Project）

  Jenkins定义了一个应用的生命周期，你只需要在每个生命周期使用适当的插件即可。

- Maven项目（Maven Project）

- 流水线项目（Pipeline Project）

  使用流水线项目你可以自定义应用的整个生命周期，非常灵活。



## 自由风格项目

我们生产中实际使用的就是自由风格的方式，能实现简单的自动部署。



## 迁移Jenkins步骤

1. 复制war包
2. 新建环境变量`JENKINS_HOME`（用于Jenkins识别，并存放Jenkins用户信息，插件等配置文件）
3. 将原来`JENKINS_HOME`中的文件打包复制到新的`JENKINS_HOME`下
4. 在新机器上生成ssh私钥公钥，并将公钥放置在需要ssh连接的机器/git服务器上
5. 启动war包

注意：

- 用root用户启动则会报错



## Reference
