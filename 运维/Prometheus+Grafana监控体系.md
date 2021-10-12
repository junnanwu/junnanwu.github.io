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
  sudo nohup ./prometheus &
  ```

- 查看

  ```
  http://49.233.9.128:9090/
  ```

### 监控Linux

- 安装node_exporter

  ```
  node_exporter-1.1.2.linux-amd64.tar.gz
  ```

- 启动node_exporter

  ```
  node_exporter: $nohup ./node_exporter & 
  ```

  默认为9100端口，也可指定端口启动

  ```
  nohup ./node_exporter --web.listen-address=":10100" &
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

## 告警

