# Kubernetes

## 重要概念

### Pod实例

Pod是可以在K8S中创建和管理的、最小可部署的计算单元。

同一个Pod里的几个docker服务，好像被部署在同一台机器上，可以通过losthost相互访问，并且可以共用Pod里的存储资源。

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



## Reference

1. https://zhuanlan.zhihu.com/p/292081941