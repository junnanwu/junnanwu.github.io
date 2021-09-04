# Elasticsearch安装和配置

## Elasticsearch

注意：本文基于**elasticsearch-7.5.2**单机版的生产实践

**修改配置**

- jvm.options

  ```
  vim jvm.options
  ```

  默认配置如下：

  ```
  -Xms1g
  -Xmx1g
  ```

- elasticsearch.yml

  - 默认配置（即空配置）可以运行，但是只允许本机/kibana访问

  - 想开启密码，允许外部所有IP访问，采用下面的配置：

    ```
    #注意，必须加这个配置
    cluster.initial_master_nodes: ["node-1"]
    # 默认所有host都可以访问
    network.host: 0.0.0.0
    #开启密码
    xpack.security.enabled: true
    xpack.security.transport.ssl.enabled: true
    ```
  
- 注意启动不起来要查看`elasticsearch.log`日志

**运行**

- 启动

  ```shell
  ./elasticsearch
  ```

- 后台启动

  ```shell
  ./elasticsearch -d
  ```

- 启动成功后可以看到两个端口可以看到绑定了两个端口:

  - 9300：集群节点间通讯接口，接收tcp协议
  - 9200：客户端访问接口，接收Http协议
  
- 关闭

  ```shell
  ps -ef| grep Elasticsearch
  ```

- 设置账号密码

  - 在elasticsearch.yml文件里增加配置

    ```
    xpack.security.enabled: true
    xpack.security.transport.ssl.enabled: true
    ```

  - 初始化密码需要在es启动的情况下进行设置，按照提示输入各个内置用户的密码。

    ```
    ./bin/elasticsearch -d
    ./bin/elasticsearch-setup-passwords interactive
    ```

  - 修改Kibana配置

    ```
    elasticsearch.username: “kibana”
    elasticsearch.password: “上一步生成的密码”
    ```

## Kibana

- 配置

  修改kibana.yml文件

  ```
  #server.host为访问Kibana的地址和端口
  server.host: "0.0.0.0"
  #界面中文显示，在最后一行修改
  i18n.locale: "zh-CN":
  ```

- 访问

  `http://xxx.xx.xx.xx:5601`

- 如何后台启动kibana

  ```
  nohup ./kibana &
  ```

- **如何查看kibana进程**

  ```
  ps -ef | grep node
  ```

  注意：`ps -ef | grep kibana`找不到相关进程

## ik分词器

- 在elasticsearch的plugins目录下新建 `analysis-ik` 目录
- [下载地址](https://github.com/medcl/elasticsearch-analysis-ik)下载对应版本的zip包解压即可
- 这里注意，不要下载`tar.gz`包，那个是源代码，需要使用maven编译一下

## 如何使用postman连接Elasticsearch

方法一：

直接在postman中认证

这种方式也会在请求头中生成一个`Authorization`的请求头

![image-20210903235806473](Elasticsearch%E7%9A%84%E5%AE%89%E8%A3%85%E5%92%8C%E9%85%8D%E7%BD%AE_assets/image-20210903235806473.png)

方法二：

1. 先使用chrome插件elasticsearch-head连接Elasticsearch
2. 登陆以后，查看该插件发送的请求，会发现一个`Authorization`的请求头
3. 将这个请求头复制到postman中即可

## 搭建集群

#### 清空elasticsearch中的数据

首先把已经启动的elasticsearch关闭，然后通过命令把之前写入的数据都删除。

```
rm -rf /elasticsearch/data
```

#### 遇到的问题

- data文件夹没有删空

  ```
  [node-2] failed to send join request to master [{node-1}{WbcP0pC_T32jWpYvu5is1A}{2_LCVHx1QEaBZYZ7XQEkMg}{10.10.11.200}{10.10.11.200:9300}], reason [RemoteTransportException[[node-1][10.10.11.200:9300][internal:discovery/zen/join]]; nested: IllegalArgumentException[can't add node {node-2}{WbcP0pC_T32jWpYvu5is1A}{p-HCgFLvSFaTynjKSeqXyA}{10.10.11.200}{10.10.11.200:9301}, found existing node {node-1}{WbcP0pC_T32jWpYvu5is1A}{2_LCVHx1QEaBZYZ7XQEkMg}{10.10.11.200}{10.10.11.200:9300} with the same id but is a different node instance]; ]
  ```

  删除es集群data数据库文件夹下所有文件即可

  [Reference](https://blog.csdn.net/diyiday/article/details/83926488)



