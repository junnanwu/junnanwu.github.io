# Prometheus+Grafana监控体系

这个监控由三个体系组成

- 相关exporter程序，负责通过http接口的形式将监听对象的状态信息暴露出来

  也可以由应用本身暴露此接口，例如Spring的actuator开启后即会通过接口暴露Spring的各项指标信息

- Prometheus收集上述点数据，并存储成时序数据

- Grafana对监控数据进行图标展示

  我们可以从Grafana Dashboard库中寻找别人做好的仪表盘，然后将其id复制到Grafana中即可，非常方便。

  [Grafana Dashboards](https://grafana.com/grafana/dashboards)

## 监控

### Prometheus

- 后台启动

  ```
  $ sudo nohup ./prometheus &
  ```

- 查看

  ```
  http://49.233.9.128:9090/targets
  ```
  
- 修改配置文件后重启

  ```
  $ sudo kill -hup 6580
  ```

#### Prometheus配置文件说明

[官方文档点此可见](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration)

```yml
# my global config
global:
  # 采集被监控端的一个周期
  # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  scrape_interval:     15s 
  # 告警的评估周期
  # Evaluate rules every 15 seconds. The default is every 1 minute.
  evaluation_interval: 15s 

# 告警配置
# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
       - 127.0.0.1:9093

# 指定告警规则 
# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  - "rules/*.yml"
  # - "first_rules.yml"
  # - "second_rules.yml"
  
  
# 服务发现
# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    # 静态配置为一种简单的配置方式
    static_configs:
    - targets: ['localhost:9090']
    # 用于解决prometheus server的label与exporter端用户自定义label冲突的问题
    # true: 同名的标签以被采集的标签为准, 忽略服务端本地标签
    # false: 默认值，同名的被采集的标签将不会覆盖服务端本地标签，而是标签名前增加exported_而服务端本地标签保留
    honor_labels: true
    
  - job_name: 'linux'
    static_configs:
      - targets: ['172.16.120.88:9100']
      #可以定义一些自己的标签
        labels:
          instance: staging2
      - targets: ['172.16.180.243:10100']
        labels:
          instance: staging
```



### 监控Linux

- 安装node_exporter

  ```
  $ node_exporter-1.1.2.linux-amd64.tar.gz
  ```

- 启动node_exporter

  ```
  $ node_exporter: $nohup ./node_exporter & 
  ```

  默认为9100端口，也可指定端口启动

  ```
  $ nohup ./node_exporter --web.listen-address=":10100" &
  ```

- ip+端口访问，查看存在信息

- 修改prometheus配置文件

  ```yml
  scrape_configs:
    - job_name: 'linux'
      static_configs:
        - targets: ['172.16.120.88:9100']
          labels:
            instance: staging2
        - targets: ['172.16.180.243:10100']
          labels:
            instance: staging
  ```

- 重启Prometheus

- 在Grafana的数据源配置为prometheus，在Grafana Dashboards选择一个Dashboards即可

![image-20210910000832378](Prometheus+Grafana%E7%9B%91%E6%8E%A7%E4%BD%93%E7%B3%BB_assets/image-20210910000832378.png)

### 监控Spring

- 导入spring-boot-starter-actuator依赖，并且增加micrometer-registry-prometheus的依赖，将原本的监控指标输出成prometheus的格式

  ```
  compile group: 'org.springframework.boot', name: 'spring-boot-starter-actuator', version: '2.1.6.RELEASE'
  implementation group: 'io.micrometer', name: 'micrometer-registry-prometheus', version: '1.6.5'
  ```

- 修改spring的配置文件

  ```yml
  #actuator配置
  management:
    endpoints:
      web:
        exposure:
          include:
             - "*" # 开放所有endpoints：health，info，metrics等，通过actuator/+端点名就可以获取相应的信息。默认打开health和info
      health:
        show-details: always
    metrics:
      export:
        prometheus:
          enabled: true
  ```

- 修改prometheus配置文件，可以新增一个job，不同的jobname即可

  ```yml
  scrape_configs:
    - job_name: 'openapi'
      metrics_path: '/openapi/actuator/prometheus'
      static_configs:
      - targets: ['172.16.173.204:9098']
  ```

- 同样在Grafana上找一个Spring的dashboard id，数据源选择prometheus即可

![image-20210910000808016](Prometheus+Grafana%E7%9B%91%E6%8E%A7%E4%BD%93%E7%B3%BB_assets/image-20210910000808016.png)

### 监控ClickHouse

- 使用Grafana自带的ClickHouse的数据源
- 选择一个能使用ClickHouse数据源的dashboard即可

最终如下：

![image-20210909234603402](Prometheus+Grafana%E7%9B%91%E6%8E%A7%E4%BD%93%E7%B3%BB_assets/image-20210909234603402.png)

### 监控Mysql

- [下载对应exporter](https://github.com/prometheus/mysqld_exporter/releases/download/v0.13.0/mysqld_exporter-0.13.0.linux-amd64.tar.gz)

- 上传、解压

  ```
  $ sudo tar -xvf mysqld_exporter-0.13.0.linux-amd64.tar.gz
  ```

- 登录mysql为exporter创建账号并授权

  ```
  CREATE USER 'exporter'@'localhost' IDENTIFIED BY 'XXXXXXXX' WITH MAX_USER_CONNECTIONS 3;
  GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';
  ```

- 创建文件`.my.cnf`

  ```
  [client]
  user=exporter
  password=xxxxxxx
  ```

- 运行

  ```
  $ nohup ./mysqld_exporter --config.my-cnf=.my.cnf &
  ```

- 访问端口测试

  ```
  http://xxxxxxxx:9104/
  ```

- 修改prometheus.yml添加job

  ```yml
  - job_name: "mysql"
      static_configs:
      - targets: ["172.16.74.199:9104"]
      - targets: ["172.27.0.26:9104"]
      honor_labels: true
  ```

- 重启prometheus

[官方介绍详见此](https://github.com/prometheus/mysqld_exporter)

效果如图：

<img src="Prometheus+Grafana%E7%9B%91%E6%8E%A7%E4%BD%93%E7%B3%BB_assets/image-20211103201401338.png" alt="image-20211103201401338" style="zoom: 50%;" />

## 告警

