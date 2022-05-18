# Cookie

## cookie规范

- cookies版本0（Netscape cookies）
- cookies版本1（RFC 2965）

cookies版本1是对cookies版本0的扩展，cookies版本0更为广泛，二者都不是HTTP/1.1规范的一部分。

版本0：

- `NAME=VALUES`

  比选

- `Expires`

  生存期，可选

- `Domain`

  可选，浏览器只向指定域中的服务器主机名发送cookie，如果没有指定域，默认为产生Set-Cookie的服务器主机名

  例如：

  ```
  Set-cookie: user="mary17"; domain="baidu.com"
  ```

  此响应头告诉浏览器将cookie `user="mary17"`发送给域`*.baidu.com`的所有站点，包括`www.baidu.com`、`www.tieba.baidu.com`等

- `Path`

  可选，路径`/foo`与`/foobar`和`/foo/bar.html`相匹配，路径`/`与域名中的所有内容相匹配，如果没有指定路径，就将其设置为产生Set-Cookie响应的URL的路径

- `Secure`

  可选，如果包含了这一属性，就只有在HTTPS的时候才会发送cookie

## References

1. 《HTTP权威指南》