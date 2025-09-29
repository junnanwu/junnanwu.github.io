# Kubernetes

Kubernetes抽象了数据中心的硬件基础设施，使得对外暴露的只是一个巨大的资源池。

**资源利用率**

谷歌最早开发Kubernetes早期系统的一个重要的原因就是为了提供资源利用率，当运行成千上万台机器的时候，哪怕一丁点的利用率的提升也意味着节约了数百万美元。

**简化管理**

当你管理数以千计的节点的时候，人工去管理每一台机器将不再现实，对于Kubernetes来说，集群包含多少个节点都是一样的，不会带来什么复杂度的提升。

**健康检查和自我修复**

**自动扩容**



K8s集群分为Master和Worker节点。

Master节点的组件：

- `API Server`

  K8s的请求入口服务 。

- `etcd`

  K8s的存储服务。etcd存储了K8s的关键配置和用户配置，K8s中仅有API Server才具备读写权限，其他组件必须通过API Server的接口才能读写数据。

- 

Worker节点的组件：

- Kubelet

  Worker节点的监视器，以及与Master节点的通讯。

- 





## 重要概念

### Pod

Pod是可以在K8S中创建和管理的、最小可部署的计算单元。

同一个Pod里的几个docker服务，好像被部署在同一台机器上，可以通过losthost相互访问，并且可以共用Pod里的存储资源。

同个Pod内的Container之间能够共享网络、IPC等，而不同Pod的Container之间完全隔离。

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
  imagePullSecrets:
  - name: docker_reg_secret
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

imagePullSecrets

Pod可以在此处指定我们创建的Secret来连接Docker私服。

查看[官方文档](https://kubernetes.io/zh-cn/docs/concepts/containers/images/#using-a-private-registry)，里面讲解了如何从私有仓库拉取镜像，其中一种方式就是通过指定imagePullSecrets的方式。

**containers**

imagePullPolicy：

- Always

  默认值，每次创建Pod都重新拉取一次镜像，当镜像名字的版本没有精准指定的时候，也会被认为是Always。

- ifNotPresent

  本地有则使用本地镜像，不拉取。

- Never

  从不拉取镜像，即使本地没有。



### Deployment



### Service



## 命令

查看所有namespace

```
$ kubectl get ns
```

查看服务

```
$ kubectl get|describe ${RESOURCE} [-o ${FORMAT}] -n=${NAMESPACE}
# ${RESOURCE}有: pod、deployment、replicaset(rs)
```

```
$ kubectl get deployment -n=bigdata-uat [-o wide]
```

服务部署失败了排查

```
$ kubectl describe ${RESOURCE} ${NAME}
```

```
$ kubectl describe pod analysis-frontend-6cd965d8b-9hskq -n=bigdata-uat
```

删除服务

```
kubectl delete ${RESOURCE} ${NAME}
```





有的资源是有缩写的，可以通过如下命令查看：

```
$ kubectl api-resources
```

还可以查看此资源是否在某个namespace下的，包括其API版本。



版本回滚
拉取镜像失败
前端部署方案
增加副本
滚动更新 业务不中断



网络问题

NodePort类型/机制仅仅提供了对k8s集群外访问的方式，很快就会发现这种方法违背了Service的流量负载均衡的策略，因为通过Pod所在机器IP访问的流量，只能够导入到该机器上的Pod，其他机器上就不行了。

是这样吗？

## References

1. [《K8S系列一：概念入门》](https://zhuanlan.zhihu.com/p/292081941)
1. [《K8S系列二：实战入门》](https://www.zhihu.com/people/wo-shi-xiao-bei-wa-ha-ha)
1. [《K8S系列四：服务管理》](https://zhuanlan.zhihu.com/p/367774885)
1. [《k8s外网如何访问业务应用》](https://www.jianshu.com/p/50b930fa7ca3)
1. [《kuberbetes部署策略详解》](https://www.qikqiak.com/post/k8s-deployment-strategies/)
1. K8s官方文档[《私有仓库拉取镜像》](https://kubernetes.io/zh-cn/docs/tasks/configure-pod-container/pull-image-private-registry/)
1. Jenkins官方文档[《流水线语法》](https://www.jenkins.io/zh/doc/book/pipeline/syntax/#%e4%bb%a3%e7%90%86)