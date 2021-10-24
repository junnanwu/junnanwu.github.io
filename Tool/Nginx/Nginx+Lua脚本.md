# Nginx+Lua脚本

## 背景

**为什么要引入Lua脚本**

随着业务的逐渐深入，Nginx存在以下不足：

- 缺少if...elseif...else的简单逻辑
- 缺少原生的大于、等于、小于等判断逻辑的表达式
- Nginx与数据库的交互能力有限
- 大多数Nginx的模块是C语言开发的，开发人员还需要了解Nginx的内部构造，开发难度较大等

基于上述原因，单纯的使用Nginx的配置已经无法满足需求。

同时：

- 章亦春推出兼容Nginx版本的OpenResty开源软件，Lua-Nginx-Module是其中的核心模块，可以直接编译到Nginx中
- Lua脚本学习成本较低，对Nginx源码的侵入很少，且不需要过多的了解Nginx源码
- 加上Lua有着"全世界最快脚本语言"的称号，性能方面也有保障

**关于Lua**

Lua是巴西里约热内卢天主教大学的一个研究小组在1993年开发的，有如下特点：

- Lua由标准C语言编写而成，可在绝大多数系统上运行
- 可以轻松的和C、C++相互调用，性能强大，非常灵活
- Lua5.1版本在编译后不足200KB，是一个轻量化脚本语言

LuaJIT是采用C语言编写的Lua即时编译器，兼容Lua5.1版本，因此标准的Lua脚本都可以在LuaJIT上运行，LuaJIT把Lua代码即时编译后交由CPU执行。

## OpenResty

基于Nginx和Lua开发的高性能的Web平台，包含大量成熟的第三方库。

如果在Nginx上使用Ngx_Lua，需要先进行编译，而OpenResty已经包含此模块，不需要再进行编译了。

### 安装OpenResty

centOS为例：

- 通过yum安装`perl 5.6.1+`, `libpcre`, `libssl`库

  ```
  yum install pcre-devel openssl-devel gcc curl
  ```

- 安装OpenResty

  在系统添加`openresty`仓库，这样就可以通过yum来安装或者更新软件包。

  ```
  # add the yum repo:
  wget https://openresty.org/package/centos/openresty.repo
  sudo mv openresty.repo /etc/yum.repos.d/
  
  # update the yum index:
  sudo yum check-update
  ```

  通过yum安装软件

  ```
  sudo yum install -y openresty
  ```

## 测试Lua脚本

```nginx
server{
    listen	443 ssl;
    server_name	hxduat.kungeek.com;
    location = /openapi/test {
        default_type 'text/plain';
        content_by_lua_block {
            ngx.say('Hello World')
        }
    }
}
```

测试成功：

```sh
$ curl -X GET 'https://hxduat.kungeek.com/openapi/event/tracking' --header 'Authorization: xxxxxx'
Hello World
```

## 连接Kafka实现日志收集

### 安装lua-resty-kafka模块

- [点击查看lua-resty-kafka](https://github.com/doujiang24/lua-resty-kafka)

- 下载压缩包

  ```
  $ wget https://github.com/doujiang24/lua-resty-kafka/archive/master.zip  
  ```

- 解压并将Kafka工具包复制到openResty/lualib下

  ```
  $ unzip master.zip  
  $ cp -r lua-resty-kafka-master/lib/resty/kafka/ /usr/local/openresty/lualib/
  ```



## Reference

- 王力、汤永全/Nginx实战-基于Lua语言的配置、开发与架构详解
- http://openresty.org/cn/
