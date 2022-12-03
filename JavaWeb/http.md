# HTTP

## 请求头

### Referer

Referer请求头包含了当前请求页面的地址

可以以此进行统计分析

### Referer-Policy

`Referer` 请求头可能暴露用户的浏览历史，涉及到用户的隐私问题。所以 HTTP 提供了 `Referrer-Policy` 标头，其用来监管和限制哪些访问来源信息会在 `Referer` 中发送

- `no-referrer`

  整个Referer请求头会被移除

- `no-referrer-when-downgrade （默认值）`

  在同等安全级别的情况下，引用页面的地址会被发送(`HTTPS->HTTPS`)，但是在降级的情况下不会被发送 (`HTTPS->HTTP`)

- `origin`

  在任何情况下，仅发送文件的源作为引用地址。例如 `https://example.com/page.html` 会将 `https://example.com/` 作为引用地址

- `origin-when-cross-origin`

  对于同源的请求，会发送完整的URL作为引用地址，但是对于非同源请求仅发送文件的源

- `same-origin`

  对于同源的请求会发送引用地址，但是对于非同源请求则不发送引用地址信息

- `strict-origin`

  在同等安全级别的情况下，发送文件的源作为引用地址(`HTTPS->HTTPS`)，但是在降级的情况下不会发送 (`HTTPS->HTTP`)

- **`strict-origin-when-cross-origin`**

  对于同源的请求，会发送完整的URL作为引用地址；

  在同等安全级别的情况下，发送文件的源作为引用地址(`HTTPS->HTTPS`)；

  在降级的情况下不发送此首部 (`HTTPS->HTTP`)

- `unsafe-url`

  无论是同源请求还是非同源请求，都发送完整的 URL（移除参数信息之后）作为引用地址

**默认值**

如果 `Referer-Policy` 未设置任何策略，则使用浏览器的默认值。网站通常会遵循浏览器的默认设置。

> 对于导航和 `iframe`, `Referer` 头中的数据也可以通过 `JavaScript` 使用 `document.referrer` 访问。

`no-referrer-when-downgrade` 是跨浏览器的一种广泛的默认策略。但是现在，许多浏览器正处于向更多提高隐私的默认设置过渡的阶段。

`Chrome` 计划在85版开始 将其切换默认策略 `no-referrer-when-downgrade` 更换到 `strict-origin-when-cross-origin`。

[reference](https://cloud.tencent.com/developer/article/1748911)

