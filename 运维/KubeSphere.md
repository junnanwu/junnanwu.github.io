# KubeSphere

KubeSphere的多租户系统分为三个层级，即集群、企业空间和项目。

您可以在一个 KubeSphere 集群中创建多个企业空间，每个企业空间下可以创建多个项目。KubeSphere 为每个级别默认设有多个内置角色。此外，您还可以创建拥有自定义权限的角色。

有一个默认的企业空间system-workspace，即系统企业空间，其中运行着与系统相关的组件和服务。

当你创建了一个企业空间，需要给这个企业空间分配一个或多个可用集群，以便项目可用在集群中创建。

KubeSphere中的项目和Kubernetes中的命名空间相同，为资源提供了虚拟隔离。

## 项目

创建项目步骤：

- 默认情况下，没有设置项目配额，可以给每个项目分配不同的CPU和内存资源
- 邀请其他用户至该项目，并分配`operator`角色
- 启用项目网关，创建应用路由

## DevOps项目









## References

1. https://github.com/kubesphere/kubesphere
2. https://kubesphere.io/zh/docs/v3.3/introduction/