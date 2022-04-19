# Linux网络

## 测试远程端口

### telnet

```
$ telnet ip port
```

telnet之后如何退出？

先按`ctrl+]`然后输入`quit`

### nmap

```
$ nmap ip -p port
```

### nc

```
$ nc -v ip port
```

## ssh

SSH  (Secure Shell)，专为远程登录会话和其他网络服务提供安全性的协议，如果一个用户从本地计算机，使用SSH协议登录另一台远程计算机，我们就可以认为，这种登录是安全的，即使被中途截获，密码也不会泄露，目前已经成为Linux系统的标准配置。

```
ssh <username>@<hostname or IP address>
```

参数：

- `-p` ssh默认端口为22，指定端口

举例：

- 使用2222端口登陆

  ```
  $ ssh -p 2222 user@host
  ```

### 配置ssh免密登陆

### ssh-keygen

ssh-keygen命令用于为ssh生成、管理和转换认证密钥，它支持RSA和DSA两种认证密钥。

参数：

- `-b` 指定密钥长度

- `-t` 指定要创建的密钥类型

  [查看此](https://www.ssh.com/academy/ssh/keygen)

  - `rsa`

  - `dsa`

  - `ecdsa`

    支持三种长度， 256, 384, and 521 

  - `ed25519`

- `-C` 添加注释

- `-f` 指定用来保存密钥的文件名

**不同密钥类型举例：**

```
$ ssh-keygen -t rsa -b 4096
$ ssh-keygen -t dsa 
$ ssh-keygen -t ecdsa -b 521
$ ssh-keygen -t ed25519
```

**配置SSH免密步骤：**

1. 生成RSA类型私钥公钥

   ```
   ssh-keygen -t rsa -C "wujunnan@kungeek.com"
   ```

   注意，一般接下来的两个都回车处理即可，即使用默认名字（`id_rsa`），默认位置（`./ssh`），不使用密钥密码，会默认生成`id_rsa`和`id_rsa.pub`

2. 将生成的公钥上传到目标服务器上

   - 方法一：将上步骤生成的`id_rsa.pub`复制到目标服务器的`~/.ssh/authorized_keys`

   - 方法二：使用ssh-copy-id工具

     ```
     $ ssh-copy-id username@remote-server
     ```

     举例：

     ```
     $ ssh-copy-id -i id_rsa.pub jinp@172.27.0.8
     ```

**注意：**

1. 私钥默认放在`.ssh`下才会生效

2. 如果是想通过ssh免密git操作，将上述的步骤二换成将公钥保存到相关git远程仓库即可

3. GitHub没有我的私钥，他是怎么解密我加密过的数据呢

   你用私钥加密的东西，GitHub用公钥可以解开，能解开说明你有对应的私钥，就是上传公钥那个人

4. GitHub已不支持RSA-1，但是OpenSSH 7.2以下版本只支持RSA-1，所以7.2以下版本要么升级版本，使用RSA-2，要么使用ECDSA算法，如下：

   ```
   $ ssh-keygen -t ecdsa -C "wujunnan-ECDSA"
   ```

## scp

scp是secure copy的简写，用于在Linux下进行远程拷贝文件的命令

**上传命令**

```
$ scp local_file remote_ip:remote_folder 
```

**多文件传输**

- 多个文件用空格分割

  ```
  $ scp execute.sh jenkins.war jinp@172.27.0.8:
  ```

- 从本地文件复制整个文件夹到远程主机上（文件夹假如是diff）
  先进入本地目录下，然后运行如下命令：

  ```
  $ scp -v -r diff root@192.168.1.104:/usr/local/nginx/html/webs
  
  $ scp -r /Users/wujunnan/develop/WWW/zookeeper-3.4.6 root@wujunnan.net:/usr/local/zookeeper
  ```

- 使用压缩来加快传输
  在文件传输的过程中，我们可以使用压缩文件来加快文件传输，我们可以使用 C选项来启用压缩功能，该文件在传输过程中被压缩，
  在目的主机上被解压缩。

  ```
  $ scp -vrC diff root@192.168.1.104:/usr/local/nginx/html/webs
  ```

**从远程主机复制到本机**

从远程主机复制文件到本地主机(下载)的命令如下：（假如远程文件是about.zip）
先进入本地目录下，然后运行如下命令：

```
$ scp root@192.168.1.104:/usr/local/nginx/html/webs/about.zip .
```

注意：

1. zsh中scp命令的通配符`*`不能，`scp ip:/home/tommy/* .`命令在bash下可以执行，但是zsh下却不能识别通配符

   shell不会按照远程地址上的文件去扩展参数，当你使用`ip:/home/tommy/`，因为本地当前目录中，不存在`ip:/home/tommy/*`，所以匹配失败。默认情况下，bash在匹配失败时就使用原来的内容，zsh则报告一个错误。在zsh中执行`setopt nonomatch` 则告诉它不要报告`no matches`的错误，而是当匹配失败时直接使用原来的内容。

   实际上，不管是 bash 还是 zsh，不管设置了什么选项，只要把`ip:/home/tommy/*`加上引号，就可解决问题。

   [reference](https://forum.ubuntu.org.cn/viewtopic.php?t=284253)

## 防火墙

- 查看防火墙状态

  ```
  $ systemctl status firewalld
  #下面表示未开启防火墙
  Active: inactive (dead)
  ```

- 开启防火墙

  ```
  $ systemctl start firewalld
  ```

- 开启端口

  ```
  $ firewall-cmd --permanent --zone=public --add-port=8080/tcp
  ```

  没有 --perman此参数重启后失效

- 查看端口

  ```
  $ firewall-cmd --permanent --query-port=8080/tcp
  ```

  提示yes，即查询成功

- 重启防火墙

  ```
  $ firewall-cmd --reload
  ```

- 查看已经开放的端口

  ```
  $ firewall-cmd --list-ports 
  ```

- 关闭防火墙端口

  ```
  $ firewall-cmd --zone=public --remove-port=3338/tcp --permanent
  ```

- 设置防火墙开机自动启动

  ```
  $ systemctl enable firewalld
  ```

- 开机禁用防火墙

  ```
  $ systemctl disable firewalld
  ```

```
$ service iptables status
```

## curl

curl来自client的URL工具，用于请求Web服务器

参数：

- `-X`

  `--request`

  指定要使用的请求动作，默认为get

  例如：

  ```
  $ curl -X POST www.example.com
  ```

  POST请求携带表单：

  ```
  $ curl -X POST --data "data=xxx" example.com/form.cgi
  ```

- `-L`

  `--location` 

  参数会让 HTTP 请求跟随服务器的重定向。curl 默认不跟随重定向。

- `-H`

  `--header`

  添加请求头

  例如：

  ```
  $ curl 'https://hxduat.kungeek.com/openapi/event/tracking' --header 'Authorization: xxxxxx'
  ```

- `-b`

  `--cookie`

  携带cookie

  例如：

  ```
  $ curl --cookie "name=xxx" www.example.com
  ```

- `-O`

  参数将服务器回应保存成文件，并将 URL 的最后部分当作文件名。

## dig

dig (domain information groper) DNS查询工具

例如：

- 查询域名解析的IP地址

  ```
  $ dig junnanwu.com
  
  ; <<>> DiG 9.10.6 <<>> junnanwu.com
  ;; global options: +cmd
  ;; Got answer:
  ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20792
  ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
  
  ;; QUESTION SECTION:
  ;junnanwu.com.			IN	A
  
  ;; ANSWER SECTION:
  junnanwu.com.		600	IN	A	185.199.108.153
  
  ;; Query time: 59 msec
  ;; SERVER: 114.114.114.114#53(114.114.114.114)
  ;; WHEN: Tue Apr 12 22:08:32 CST 2022
  ;; MSG SIZE  rcvd: 46
  ```

  解析：

  1. 第一部分为dig命令的版本和输出参数
  2. 第二部分为显示服务返回的一些技术详情，status状态为NOERROR则表示本次查询结束
  3. 第三部分QUESTION SECTION为我们要查询的域名
  4. 第四部分ANSWER SECTION为查询的结果，其中600位DNS的缓存时间，单位为秒
  5. 第五部分为本次查询的一些统计信息，例如用时，查询了哪个DNS服务器，查询时间等

- 简短输出

  ```
  $ dig +short baidu.com
  220.181.38.251
  220.181.38.148
  ```

## References

1. https://www.ssh.com/academy/ssh/keygen