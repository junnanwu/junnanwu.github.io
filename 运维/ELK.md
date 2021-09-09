# ELK

ELK，是以Elasticsearch为核心的日志采集套件。

ELK分别为三个开源项目的首字母：

- Elasticsearch，搜索引擎
- Logstash，强大的采集管道
- Kibana，灵活的可视化工具

通过上述组件，从而实现了对日志的采集存储、搜索、展示。

在 2015 年，Elasticsearch向ELK Stack中加入了一系列轻量型的单一功能数据采集器，并把它们叫做 Beats。

Beats中包括很多套件，其中就包括，Filebeat——日志文件采集。

## Filebeat

可以查看官方文档：

[Filebeat文档](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)

### Filebeat的工作流程



### 配置文件

**multiline**（多行日志）

- `multiline.pattern`

  匹配的正则表达式，指明了匹配了哪些行

- `multiline.negate`

  匹配上的行是否和pattern相反的

- `multiline.match`

  - `after`

    匹配到的连续行将和前面没有匹配到的一行合成一组

  - `before`

    匹配到的行将和后面没有匹配上的一行合成一组(匹配的行before)

- `multiline.max_lines`

  可合并成一个事件的最大行数，如果一行包含的行数超过`max_lines`则超过的部分被丢弃，默认是500行

例如：

`pattern：^b `(匹配以b开头的行)

| nagete | match  | source | result  | 说明                                                         |
| ------ | ------ | ------ | ------- | ------------------------------------------------------------ |
| false  | after  | abbcbb | abb-cbb | 匹配到的连续行 (bb) 将和前面没有匹配到的一行合成一组 (匹配上的after) |
| false  | before | bbabbc | bba-bbc | 匹配到的行 (bb) 将和后面没有匹配上的一行合成一组 (匹配的行before) |
| true   | after  | bacbde | bac-bde | 同上，只不过现在匹配上的连续行变为了ac/de                    |
| true   | before | acbded | acd-deb | 同上，只不过现在匹配上的连续行变为了cd/ed                    |

举例：

Filebeat将所有不以`[`开始的行于之前的行进行合并。

```
multiline.pattern: '^\[' //以[开头的是匹配上的
multiline.negate: true   //上面规则取反
multiline.match: after   //匹配上的（不以[开头的）和前面一条（以[开头的）没匹配上的一组
```

Java堆栈跟踪

```
Exception in thread "main" java.lang.NullPointerException
        at com.example.myproject.Book.getTitle(Book.java:16)
        at com.example.myproject.Author.getBookTitles(Author.java:25)
        at com.example.myproject.Bootstrap.main(Bootstrap.java:14)
```

在初始行之后的每一行都以空格开头，将任意以空格开始的行合并到前一行

```
multiline.pattern: '^[[:space:]]'
multiline.negate: false
multiline.match: after
```

生产：

```
- type: log
  ebled: true
  paths:
    - /data/davinci/logs/user/schedule/*.log
  fields:
    type: tomcat-errlog-prd-data-BI-node4-schedule
  fields_under_root: true
 	//正则表达式的含义就是：形如2021/09/06-03:00:00开头的文件
  multiline.pattern: ^\d{4}/\d{2}/\d{2}-\d{2}:\d{2}:\d{2}
  //匹配上的的是不包括上述正则的文件
  multiline.negate: true
  //匹配上的放在2021/09/06-03:00:00的后面
  multiline.match: after
```

