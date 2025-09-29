# mkcert本地安装https证书

## 背景

当我们本地调试的时候，有时候需要https访问，我们可以使用`openssl`工具来生成自己的证书，但是步骤较为麻烦，可以谷歌开源的mkcert小工具来实现。

## mkcert

mkcert是一个用来搭建本地https信任环境的工具，由Go语言实现，使用非常简单，[详见此](https://github.com/FiloSottile/mkcert)。

**安装**

(Mac OS)

```
$ brew install mkcert
```

**使用**

1. 安装根证书

   ```
   $ mkcert -install
   Sudo password:
   The local CA is now installed in the system trust store! ⚡️
   The local CA is now installed in Java's trust store! ☕️
   ```

   安装证书之后Mac OS可以在钥匙串中看到根证书已安装好：

   ![mac_os_ROOT_CA](local_install_mkcert_https_certificate_assets/mac_os_ROOT_CA.png 'Mac OS根证书')

2. 生成指定域名的证书

   (例如localhost)

   ```
   $ mkcert localhost
   
   Created a new certificate valid for the following names 📜
    - "localhost"
   
   The certificate is at "./localhost.pem" and the key at "./localhost-key.pem" ✅
   
   It will expire on 14 September 2024 🗓
   ```

## 使用

以Nginx为例：

1. 在Nginx目录下执行`mkcert localhost`

2. 添加如下配置文件

   ```nginx
   server{
       listen	443;
       ssl on;
       ssl_certificate localhost.pem;
       ssl_certificate_key localhost-key.pem;
       server_name	localhost;
   
       location /{
           root /xxx;
       }
   }
   ```

3. 访问`https://localhost`即可

## 局域网访问

当我们想为局域网中IP地址使用https的时候，由于CA机构是不会给IP地址颁发证书的，而且一般这种场景都是内部使用，我们就可以使用mkcert为此IP生成证书，并将此证书的根证书安装到局域网用户的电脑信任根证书列表中即可。

以Mac OS为例（mac-server为服务提供方，mac-client为服务使用方）：

**server端配置**

1. 生成根证书（一个机器生成一次即可）

   ```
   $ mkcert -install
   ```

2. 生成对应IP证书

   例如mac-server的IP地址为`10.240.xxx.238`

   ```
   $ mkcert 10.240.xxx.238
   ```

3. 配置证书

   （以Nginx为例）

   ```nginx
   server{
       listen	443;
       ssl on;
       ssl_certificate 10.240.xxx.238.pem;
       ssl_certificate_key 10.240.xxx.238-key.pem;
       server_name	10.240.xxx.238;
   
       location /xxx{
           xxx;
       }
   }
   ```

**客户端使用**

1. 打开mac-server的钥匙串访问，将根证书`.cer`复制到出来

2. 打开Mac-client的钥匙串访问，点击左侧系统栏，导入上述证书

3. 右键点击证书，点击显示简介，勾选信任中的：使用此证书时，始终信任

   ![ca_always_trust](local_install_mkcert_https_certificate_assets/ca_always_trust.png '勾选始终信任证书')

4. 即可访问`https://10.240.xxx.238`

## References

1. GitHub仓库：[mkcert](https://github.com/FiloSottile/mkcert)