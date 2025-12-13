# KubeSphere

KubeSphere的多租户系统分为三个层级，即集群、企业空间和项目。

## 企业空间

您可以在一个 KubeSphere 集群中创建多个企业空间，每个企业空间下可以创建多个项目。KubeSphere 为每个级别默认设有多个内置角色。此外，您还可以创建拥有自定义权限的角色。

有一个默认的企业空间system-workspace，即系统企业空间，其中运行着与系统相关的组件和服务。

当你创建了一个企业空间，需要给这个企业空间分配一个或多个可用集群，以便项目可用在集群中创建。

不同的企业空间之间可以设置网络隔离，网络隔离默认情况下是关闭的。

### 配额

企业空间配额用于给空间中所有项目和DevOps项目的总资源使用量。

### 部门

在企业空间下可以创建部门，部门可以设置：

- 企业空间角色
- 项目角色
- DevOps项目角色

即代表，在这个部门下的人员即为这些角色。

## 项目

KubeSphere中的项目和Kubernetes中的命名空间相同，为资源提供了虚拟隔离。

创建项目步骤：

- 默认情况下，没有设置项目配额，可以给每个项目分配不同的CPU和内存资源
- 邀请其他用户至该项目，并分配`operator`角色
- 启用项目网关，创建应用路由

### 应用程序



### 配额

可以为项目设置资源配额，包括预留和限制。

KubeSphere默认不为项目设置任何请求或限制。

## DevOps项目

支持基于Jenkinsfile流水线构建CI/CD流水线。

### Jenkins Agent

Jenkins agent部分指定某一部分在Jenkins环境中执行的位置。

顶级agent指示Jenkins为整个流水线分配一个执行器。

可选项：

- `any`

  在任何一个代理上执行流水线或者某个阶段。

- `node`

  当`pipeline`块的顶部没有全局代理，那么每个stage部分都需要他自己的agent部分。

- `label`

  在提供了标签的Jenkins环境中选择指定的label执行。

- `node`

  `agent { node { label 'labelName' } }` 和 `agent { label 'labelName' }` 一样，但是 `node` 允许额外的选项 (比如 `customWorkspace` )。

- `docker`

  使用给定的容器执行流水线，或者阶段。

  ```
  agent {
      docker {
          image 'maven:3-alpine'
          label 'my-defined-label'
          args  '-v /tmp:/tmp'
      }
  }
  ```

- `dockerfile`

  使用从源代码库中的Dockerfile构建的容器。



[详情参见此](https://kubesphere.com.cn/docs/v3.3/devops-user-guide/how-to-use/pipelines/choose-jenkins-agent/)





## References

- https://www.jenkins.io/zh/doc/book/pipeline/syntax/#%e4%bb%a3%e7%90%86











## References

1. https://github.com/kubesphere/kubesphere
2. https://kubesphere.io/zh/docs/v3.3/introduction/