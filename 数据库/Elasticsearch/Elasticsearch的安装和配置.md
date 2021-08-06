## Elasticsearch安装和配置

#### 新建并切换用户

```
useradd elastic
passwd elastic
su - elastic
```

#### 上传安装包并解压

```
tar xvf elasticsearch-6.8.0.tar.gz
mv elasticsearch-6.8.0/ elasticsearch
```

#### 目录结构

```
[elastic@VM-0-7-centos elasticsearch]$ ls
bin     lib          logs     NOTICE.txt  README.textile
config  LICENSE.txt  modules  plugins
```

- bin，二进制脚本，包含启动命令等 config 配置文件目录
- lib，依赖包目录
- logs，日志文件目录
- modules，模块库
- plugins，插件目录，这里存放一些常用的插件比如IK分词器插件
- data 数据储存目录(暂时没有，需要在配置文件中指定存放位置，启动es时会自动根据指定位置创建)

#### 修改配置

- jvm.options

  ```
  vim jvm.options
  ```

  默认配置如下：

  ```
  -Xms1g
  -Xmx1g
  ```

  内存占用太多了，我们调小一些，大家虚拟机内存设置为2G：

  **最小设置128m，如果虚机内存允许的话设置为512m**

  ```
  -Xms256m 
  -Xmx256m
  ```

- elasticsearch.yml

  ```
  cluster.name: xuecheng   #配置elasticsearch的集群名称，默认是elasticsearch。建议修改成一个有意义的名称。
  node.name: xc_node_1  #节点名，通常一台物理服务器就是一个节点，es会默认随机指定一个名字，建议指定一个有意义的名称，方便管理
  network.host: 0.0.0.0  #绑定ip地址
  http.port: 9200  #暴露的http端口
  transport.tcp.port: 9300  #内部端口
  node.master: true  #主节点
  node.data: true  #数据节点
  discovery.zen.ping.unicast.hosts: ["0.0.0.0:9300", "0.0.0.0:9301", "0.0.0.0:9302"]  #设置集群中master节点的初始列表
  discovery.zen.minimum_master_nodes: 1  #主结点数量的最少值 ,此值的公式为：(master_eligible_nodes / 2) + 1 ，比如：有3个符合要求的主结点，那么这里要设置为2。
  bootstrap.memory_lock: false  #内存的锁定只给es用
  node.max_local_storage_nodes: 1 #单机允许的最大存储结点数，通常单机启动一个结点建议设置为1，开发环境如果单机启动多个节点可设置大于1
  path.data: D:\ElasticSearch\elasticsearch‐6.2.1\data  #索引目录
  path.logs: D:\ElasticSearch\elasticsearch‐6.2.1\logs    #日志
  http.cors.enabled: true #  跨域设置
  http.cors.allow‐origin: /.*/
  ```

- 提示系统堆内存不足，需要扩大

  ```
  [3]: max virtual memory areas vm.max_map_count [65530] likely too low, increase to at least [262144]
  ```

  elasticsearch用户拥有的最大虚拟内存太小，至少需要262144；

  先赋予当前用户sudo权限

  继续修改配置文件：

  ```
  sudo vim /etc/sysctl.conf 
  ```

  添加下面内容：

  ```
  vm.max_map_count=262144
  ```

  然后执行命令：

  ```
  sudo sysctl -p
  ```

#### 运行

- 启动

  ```
  ./elasticsearch
  ```

- 后台启动

  ```
  ./elasticsearch -d
  ```

- 启动成功后可以看到两个端口可以看到绑定了两个端口:

  - 9300：集群节点间通讯接口，接收tcp协议
  - 9200：客户端访问接口，接收Http协议

### 图形化界面

Kibana是一个基于Node.js的Elasticsearch索引库数据统计工具，可以利用Elasticsearch的聚合功能，生成各种图表，如柱形图，线状图，饼图等。

而且还提供了操作Elasticsearch索引数据的控制台，并且提供了一定的API提示，非常有利于我们学习Elasticsearch的语法。

[下载](https://www.elastic.co/cn/products/kibana )

配置

修改kibana.yml文件

```
#修改server.host地址：
server.host: "0.0.0.0"
#界面中文显示，在最后一行修改
i18n.locale: "zh-CN"
```

访问http://192.168.129.134:5601即可

### 集成ik分词器

- [下载](https://github.com/medcl/elasticsearch-analysis-ik)
- 在elasticsearch的plugins目录下新建 `analysis-ik` 目录
- 将elasticsearch-analysis-ik-6.8.0.zip解压在`analysis-ik`目录下，然后删除压缩包

## 使用ES

如何关闭ES

- 查看已经启动的ES线程并杀死

  - ```
    grep --color=auto elasticserch
    ```

  - ```
    jps
    ```

  - ```
    kill -9
    ```

- 使用elasticsearch-head关闭服务

## 搭建集群

#### 清空elasticsearch中的数据

首先把已经启动的elasticsearch关闭，然后通过命令把之前写入的数据都删除。

```
rm -rf /elasticsearch/data
```

#### 修改配置文件

#### 遇到的问题

- failed to obtain node locks, tried [[/elasticsearch-5.4.0/data/elasticsearch]] with lock id [0]; maybe these locations are not writable or multiple nodes were started without increasing [node.max_local_storage_nodes] (was [1])

  解决：

   /usr/local/elasticsearch-6.2.0/config/elasticsearch.yml  配置文件最后添加  node.max_local_storage_nodes: 2

- 访问跨域问题

  在elasticsearch的安装目录下找到config文件夹，找到elasticsearch.yml文件，打开编辑它，加上如下这两行配置

  ```
  http.cors.enabled: true
  http.cors.allow-origin: "*"
  ```

  [Reference1](https://blog.csdn.net/fst438060684/article/details/80936201)

  [Reference2](https://blog.csdn.net/jingzuangod/article/details/99673361)  

- data文件夹没有删空

  ```
  [node-2] failed to send join request to master [{node-1}{WbcP0pC_T32jWpYvu5is1A}{2_LCVHx1QEaBZYZ7XQEkMg}{10.10.11.200}{10.10.11.200:9300}], reason [RemoteTransportException[[node-1][10.10.11.200:9300][internal:discovery/zen/join]]; nested: IllegalArgumentException[can't add node {node-2}{WbcP0pC_T32jWpYvu5is1A}{p-HCgFLvSFaTynjKSeqXyA}{10.10.11.200}{10.10.11.200:9301}, found existing node {node-1}{WbcP0pC_T32jWpYvu5is1A}{2_LCVHx1QEaBZYZ7XQEkMg}{10.10.11.200}{10.10.11.200:9300} with the same id but is a different node instance]; ]
  ```

  删除es集群data数据库文件夹下所有文件即可

  [Reference](https://blog.csdn.net/diyiday/article/details/83926488)

