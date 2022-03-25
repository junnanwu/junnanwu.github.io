# 关于GitHub

## GitHub不再支持账号密码的验证

从2021年8月13号开始GitHub不再支持基于密码身份验证，替换为token的方式。

token的方式相比密码有如下优势：

- 唯一性——令牌特定于 GitHub，可按使用次数或按设备生成
- 可撤销——可以随时单独撤销令牌，不需要更新未受影响的凭据
- 有限性——令牌的使用范围严格控制，仅允许执行用例中需要的访问活动
- 随机性——令牌的复杂度远高于用户设计的简单密码，因此不受暴力破解等行为的影响

也就是使用token代替了密码。

## 更新支持的算法

随着算力和加密算法的发展，2001年的看法已经不适用于现在，所以Github新增了一些安全措施，本次变更涉及到SSH或`git://`，不涉及Https方式。

具体：

- 删除了对DSA加密方式的支持

  DSA的方式不安全。

- 对新添加的RSA密钥新增了一些要求

  RSA的加密方式的是安全的，但是RSA-1算法是不安全的，所以对于新增的RSA密钥，不再支持添加RSA-1，仅支持RSA-2签名算法。

- 移除一些遗留的SSH算法（HMAC-SHA-1、CBC）

- 增加ECDSA和Ed25519算法

- 关闭未加密的git协议

### 实际影响

#### 关于SSH生成公钥

> You can also use OpenSSH versions as old as 6.5 with Ed25519 keys or 5.7 with ECDSA keys.

当我们想使用github的ssh的方式免密操作的时候，我们需要在GitHub设置客户端的生成的公钥，但是`7.2`版本 以下的OpenSSH生成的是RSA-1，GitHub已不再支持，所以7.2以下版本要么升级版本，使用RSA-2，要么使用ECDSA算法，如下：

```
$ ssh-keygen -t ecdsa -C "wujunnan-ECDSA"
```



## References

1. https://github.blog/2020-12-15-token-authentication-requirements-for-git-operations/
2. https://github.blog/2021-09-01-improving-git-protocol-security-github/
2. https://superuser.com/questions/1556852/how-to-check-if-your-ssh-keys-are-in-the-ssh-rsa2-format