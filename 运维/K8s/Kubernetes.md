# Kubernetes

Kubernetes抽象了数据中心的硬件基础设施，使得对外暴露的只是一个巨大的资源池。

**资源利用率**

谷歌最早开发Kubernetes早期系统的一个重要的原因就是为了提供资源利用率，当运行成千上万台机器的时候，哪怕一丁点的利用率的提升也意味着节约了数百万美元。

**简化管理**

当你管理数以千计的节点的时候，人工去管理每一台机器将不再现实，对于Kubernetes来说，集群包含多少个节点都是一样的，不会带来什么复杂度的提升。

**健康检查和自我修复**

**自动扩容**

## 重要概念

### Pod

Pod是可以在K8S中创建和管理的、最小可部署的计算单元。

同一个Pod里的几个docker服务，好像被部署在同一台机器上，可以通过losthost相互访问，并且可以共用Pod里的存储资源。

### Deployment

管理和控制Pod和ReplicaSet，管控它们在用户期望的状态中。

### Service

Deployment、ReplicationController和ReplicaSet主要管控Pod程序服务；那么，Service和Ingress则负责管控Pod网络服务。

K8S中的Service并不是我们常说的服务，而更像网关层，是若干个Pod的流量入口，流量均衡器。

Service是K8S服务的核心，屏蔽了服务细节，统一对外暴露服务接口。

举个例子，我们的一个服务A，部署了3个备份，也就是3个Pod；对于用户来说，只需要关注一个Service的入口就可以，而不需要操心究竟应该请求哪一个Pod。Service还可以对不同的Pod做负载均衡。

### Ingress

Service主要负责的是K8S集群内部的网络拓扑，集群外部访问，就需要Ingress了。

Ingress是整个K8S集群的接入层，复杂集群内外通讯。

### namespace

可以通过K8S集群内创建namespace来分隔资源和对象。

## 配置kubectl

## 部署服务

### Pod

K8S中的所有对象都通过yaml来表示，例如：

```
apiVersion: v1
kind: Pod
metadata:
  name: memory-demo
  namespace: mem-example
spec:
  containers:
  - name: memory-demo-ctr
    image: polinux/stress
    resources:
      limits:
        memory: "200Mi"
      requests:
        memory: "100Mi"
    command: ["stress"]
    args: ["--vm", "1", "--vm-bytes", "150M", "--vm-hang", "1"]
    volumeMounts:
    - name: redis-storage
      mountPath: /data/redis
  volumes:
  - name: redis-storage
    emptyDir: {}
```

**apiVersion**

Kubernete支持多个API版本，还有API组的概念，一个版本表示为`$GROUP_NAME/$VERSION`

- `v1`

  是Kubernetes API的第一个稳定版本。 它包含许多核心对象，属于核心组，核心组的`GROUP_NAME`可以省略。

- `apps/v1`

  apps组包含一些应用层的API组合，如：Deployments, RollingUpdates, and ReplicaSets。

- `batch/v1`

  batch组包含与批处理相关的对象。

可以通过如下命令来查看不同kind的版本：

```
$ kubectl explain Pod.apiVersion|grep VERSION
VERSION:  v1
$ kubectl explain Deployment.apiVersion|grep VERSION
VERSION:  apps/v1
$ kubectl explain Service.apiVersion|grep VERSION
VERSION:  v1
```

**kind**

即该配置的类型。可以是Pod、Deployment、Service等。

**metadata**

元数据

- name表示这个Pod的名称
- namespace表示命名空间

**spec**

### Deployment



### Service



## References

1. https://zhuanlan.zhihu.com/p/292081941
1. https://zhuanlan.zhihu.com/p/308477039
1. https://www.jianshu.com/p/50b930fa7ca3