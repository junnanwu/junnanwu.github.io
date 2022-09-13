# KubeSphere创建DevOps项目

## K8s是什么

K8s是负责自动化运维管理多个Docker程序的集群。

## K8s的好处

- 资源统一管理
- 自动扩容缩容
- 简化部署
- 自我修复

## K8s的核心概念

### namespace

命名空间，分隔资源和对象。

### 部署相关

#### Pod

Pod是可以在K8s中创建和管理的、最小可部署的计算单元。同一个Pod内可以有多个docker容器。

#### Deployment

管理和控制Pod，当我们创建Deployment后，就会自动创建指定副本数的Pod，当某个Pod运行失败，也会重新运行一个新的Pod以保证一共有指定副本数的Pod。

### 网络相关

#### Service

若干个Pod的流量入口，流量均衡器。

Service其实就是我们微服务的一个抽象，对于一个服务来说，其他服务不关心它内部一共有几个副本，也不关心其内部如何做的负载均衡，只关心最后对外暴露的IP和端口，这也正是Service的功能。

Service有几种发布类型：

- ClusterIP

  提供一个集群内部的虚拟IP，这个是默认选项，但是依然不能被外网访问。

- NodePort

  K8s集群的每个节点都打开一个相同的端口（范围是30000-32767，也可以手动指定一个NodePort），将流量导向Service本身的IP:端口。

- LoadBalancer

  使用云提供商的负载均衡器向外部暴露服务。

NodePort的方式满足外网访问，比较简单，但也有缺点，它依赖了某个节点的IP，不满足高可用，LoadBalance依赖云提供商的负载均衡服务，另外也可以使用Ingress充当集群的入口。

#### Ingress

Ingress是整个K8S集群的接入层，负责复杂集群内外通讯，类似Nginx。

K8s的网络访问示意图：

![k8s-network-access-path](KubeSphere%E5%88%9B%E5%BB%BADevOps%E9%A1%B9%E7%9B%AE_assets/k8s-network-access-path.png)

## 发布一个K8s服务

### 连接到K8s

kubectl是K8s的命令行工具，就类似mysql之于mysqld，kubectl可以安装在任意一台机器上去操作K8s集群，所以，需要首先需要连接到K8s，这里是通过一个YAML配置文件（K8s所有资源都是通过YAML配置文件来描述）来进行连接。

可以将YAML文件放在`$HOME/.kube/config`目录下，接下来再此使用kubectl命令的时候就会自动读取配置了。

### 创建namespace

创建一个namespace，我们接下来会在这个namespace下来创建资源。

```
$ kubectl create namespace ${name}
```

### 部署Deployment

同样的，Deployment也通过YAML文件来描述，如下所示：

```yml
# api版本
apiVersion: apps/v1
# 该配置的类型
kind: Deployment
# Deployment的元数据
metadata:
  # Deployment的name
  name: APP_NAME
  # 对应上面的namespace
  namespace: PROJECT_NAME
#详细配置
spec:
  #pod的副本数
  replicas: 1
  #定义了Deployment如何查找Pod
  selector:
    #即有APP_NAME标签的Pod被该Deloyment管理
    matchLabels:
      app: APP_NAME
  #pod的相关信息
  template:
    metadata:
      #pod的标签
      labels:
        app: APP_NAME
    #pod的详细信息
    spec:
      containers:
        - name: APP_NAME
          image: IMAGE_NAME
          ports:
            - name: http-9091
              #pod对应端口
              containerPort: 9091
              protocol: TCP
          #pod对应资源
          resources:
            requests:
              cpu: 0.2
              memory: 1Gi
            limits:
              cpu: 1
              memory: 1Gi
```

具体参数详见[官方文档](https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/deployment/)。

通过如下命令，即可发布该Deployment：

```
$ kubectl create -f ${DEPLOYMENT_YAML}
```

发布Deployment的同时，也会创建一个Pod，Pod的端口为9091，Pod对应的IP也为K8s分配的虚拟IP，外网无法访问的，所以我们还需要创建Service，作为Pod的流量入口。

### 创建Service

这里使用的是Service的NodePort的方式：

```yml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: APP_NAME
  name: APP_NAME
  namespace: PROJECT_NAME
spec:
  ports:
    - name: http
      #容器端口
      port: 9091
      protocol: TCP
      #将容器请求代理到目标端口
      targetPort: 9091
      #NodePort类型中指定节点上的端口
      nodePort: 30081
  selector:
    #管理标签为APP_NAME的Pod
    app: APP_NAME
  sessionAffinity: None
  #使用NodePort发布类型
  type: NodePort
```

具体参数详见[官方文档](https://kubernetes.io/zh-cn/docs/concepts/workloads/controllers/deployment/)。

## KubeSphere是什么

KubeSphere是在Kubernetes之上构建的云原生操作系统，提供了如下功能：

- 提供了UI页面来操作K8s，进一步简化了K8s操作
- 同时也集成了一些常用的组件，例如Jenkins，方便的创建流水线
- 多租户管理，方便权限控制

详情可以参考详情可以[官方文档](https://kubesphere.io/zh/docs/v3.3/)。

## KubeSphere核心概念

- 企业空间

  企业空间是KubeSphere抽象出来的一个概念，它用来管理项目、DevOps项目、应用模版，用于租户的权限隔离，一般是一个组一个企业空间，例如大数据企业空间。

- 项目

  项目对应了K8s中的namespace。一般一个环境是一个项目，例如大数据生产项目、大数据测试项目。

- 应用负载

  应用负载对应了K8s的Deployment，负责管理和创建Pod。

- 服务

  服务对应了K8s的Service，将一组Pod统一的进行暴露，在不同Pod之间进行负载均衡。

- 应用路由

  应用路由对应了K8s的Ingress，可以通过IP+路由来暴露Service，类似Nginx。

- 容器组

  容器组对应了K8s的Pod，是K8s操作的最小和基本单元。

## 创建Java后端项目DevOps项目

（以gradle为例）

### 准备工作

需要创建好namespace、project、DevOps项目及对应有权限的账户。

### 项目添加文件

在项目根路径创建ci包，里面创建如下Dockerfile：

```
FROM java:8

ENV TZ=Asia/Shanghai
ADD build/libs/*-SNAPSHOT.jar /app.jar

ENTRYPOINT ["java","-jar","/app.jar"]
```

注意：

- `ENV TZ`为时区，如果不指定，则容器内为林威治时间，即慢8个小时。
- `build/libs`是在gradle默认打包位置，maven需要修改为`target`

再创建如下deploy.yml：

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: APP_NAME
  namespace: PROJECT_NAME
spec:
  minReadySeconds: 60
  replicas: 1
  selector:
    matchLabels:
      app: APP_NAME
  template:
    metadata:
      labels:
        app: APP_NAME
    spec:
      containers:
        - name: APP_NAME
          image: IMAGE_NAME
          ports:
            - name: http-9091
              containerPort: 9091
              protocol: TCP

          resources:
            requests:
              cpu: 0.2
              memory: 1Gi
            limits:
              cpu: 1
              memory: 1Gi
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: APP_NAME
  name: APP_NAME
  namespace: PROJECT_NAME
spec:
  ports:
    - name: http
      port: 9091
      protocol: TCP
      targetPort: 9091
      nodePort: 30081
  selector:
    app: APP_NAME
  sessionAffinity: None
  type: NodePort
```

注意，需要修改部分配置：

- 端口，上面配置中，9091为项目本身的端口，30081为最终对外暴露端口
- namespace对应了KubeSphere中创建的项目

### 添加凭证

用到了三个凭证：

1. gitlab账号，名称为`git-account`，类型为`用户名和密码`
2. 连接k8s服务的配置，名称为`kubeconfig`，类型为`kubeconfig`
3. Docker私服（harbor）账号，名称为`docker-account`，类型为`用户名和密码`

注意，上面三个凭证的名称和下面的Jenkinsfile相对应，不要随意改动。

### 创建流水线

新建一个流水线，修改如下Jenkinsfile，修改后复制到项目的Jenkinsfile中。

```
pipeline {
  agent {
    node {
      label 'gradle'
    }

  }
  stages {
    stage('Checkout') {
      agent none
      steps {
        sh "echo 即将部署分支$BRANCH"
        git(credentialsId: "$GIT_CREDENTIAL_ID", url: "$GIT_URL", branch: "$BRANCH", changelog: true, poll: false)
        sh '''cat ci/deploy.yml
sed -i "s#APP_NAME#$APP_NAME#g" ci/deploy.yml
sed -i "s#PROJECT_NAME#$PROJECT_NAME#g" ci/deploy.yml
sed -i "s#IMAGE_NAME#$REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BUILD_NUMBER#g" ci/deploy.yml
cat ci/deploy.yml'''
      }
    }

    stage('Build And Push') {
      agent none
      steps {
        container('gradle') {
          sh 'gradle clean bootJar'
          sh 'docker build -f ci/Dockerfile -t $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BUILD_NUMBER .'
          sh 'docker images'
          withCredentials([usernamePassword(credentialsId : "$DOCKER_CREDENTIAL_ID" , passwordVariable : 'DOCKER_PASSWORD' ,usernameVariable : 'DOCKER_USERNAME' ,)]) {
            sh '''echo "$DOCKER_PASSWORD" | docker login "$REGISTRY" -u "$DOCKER_USERNAME" --password-stdin
docker push $REGISTRY/$DOCKERHUB_NAMESPACE/$APP_NAME:SNAPSHOT-$BUILD_NUMBER'''
          }
        }
      }
    }

    stage('Deploy') {
      agent none
      steps {
        container('gradle') {
          withCredentials([kubeconfigContent(credentialsId : "$KUBECONFIG_CREDENTIAL_ID" ,variable : 'KUBECONFIG' ,)]) {
            sh '''mkdir ~/.kube
echo "$KUBECONFIG" > ~/.kube/config
kubectl apply -f ci/deploy.yml --kubeconfig=/root/.kube/config
echo "deploy Done."'''
          }
        }
      }
    }
  }
  
  environment {
    REGISTRY = 'dockerhub.xxx.com'
    DOCKERHUB_NAMESPACE = 'bigdata-uat'
    PROJECT_NAME = 'bigdata-uat'
    APP_NAME = 'bigdata-openapi'
    GIT_URL = 'http://xxx.com/data/data-openapi.git'
    GIT_CREDENTIAL_ID = 'git-account'
    DOCKER_CREDENTIAL_ID = 'docker-account'
    KUBECONFIG_CREDENTIAL_ID = 'kubeconfig'
  }
  
  parameters {
    string(name: 'BRANCH', defaultValue: 'release/v', description: '要部署的分支')
  }
}
```

**注意：**

**关于environment部分**

部分环境变量需要修改：

- `REGISTRY`对于了docker私服地址
- `DOCKERHUB_NAMESPACE`对应了docker私服里面的命名空间
- `APP_NAME`对应了此流水线的应用名
- `GIT_URL`对应了此项目的git地址，http类型的，和gitlab凭证是对照的

部分环境变量不需要修改：

`GIT_CREDENTIAL_ID`、`DOCKER_CREDENTIAL_ID`、`KUBECONFIG_CREDENTIAL_ID`这三个环境变量对应了三个凭证，和上面凭证名称相对应，不需要改动。

**在Build And Push阶段**

使用的打包命令为`gradle clean bootJar`，maven项目为`mvn clean package`。

**关于maven**

如果使用maven，则配置文件顶部label需要改为maven，里面的所有container也要使用maven。

## References

1. https://kubernetes.io/zh-cn/docs/home/
2. https://kubesphere.io/zh/docs/v3.3/
3. https://zhuanlan.zhihu.com/p/292081941
4. https://zhuanlan.zhihu.com/p/308477039
5. https://www.jianshu.com/p/50b930fa7ca3