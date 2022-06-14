# mkcert本地安装https证书

## 背景

当我们本地调试的时候，有时候需要https访问，我们可以使用`openssl`工具来生成自己的证书，但是步骤较为麻烦，可以mkcert小工具来实现。

## mkcert

mkcert是一个用来搭建本地https信任环境的工具，使用非常简单，[详见此](https://github.com/FiloSottile/mkcert)

**安装**

(Mac OS)

```
$ brew install mkcert
```

使用

1. 安装根证书

   ```
   $ mkcert -install
   Sudo password:
   The local CA is now installed in the system trust store! ⚡️
   The local CA is now installed in Java's trust store! ☕️
   ```

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

## References

1. https://github.com/FiloSottile/mkcert