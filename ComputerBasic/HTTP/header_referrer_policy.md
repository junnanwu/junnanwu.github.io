# Referrer-Policy标头

## Referer

首先需要了解Referer请求头，当浏览器像服务器发送请求的时候，一般会带上Referer，即当前请求页面的地址，后端可以据此来判断访问来源，我们所熟知的防盗链，就是判断Referer地址是否在指定的白名单中，这样就可以防止其他网站盗用图片链接了（当然可以自己伪造Referer）。

## Referrer-Policy

Referer可能暴露用户的浏览历史，涉及到用户的隐私问题，所以HTTP提供了Referrer-Policy标头，其用来监管和限制哪些访问来源信息会在 Referer中发送（Referer为Referrer的错误拼写，Referrer-Policy不再沿用）。

一般使用方式就是在html里面加一个meta标签来告诉浏览器我们的referer策略：

```
<meta name="referrer" content="origin">
```

Referrer-Policy可取值如下：

- `no-referrer`

  整个Referer请求头会被移除。

- `no-referrer-when-downgrade`

  在同等安全级别的情况下，引用页面的地址会被发送(HTTPS->HTTPS，下同），但是在降级的情况下 (HTTPS->HTTP，下同）不会被发送。

- `origin`

  在任何情况下，仅发送文件的源作为引用地址。例如 `https://example.com/page.html` 会将 `https://example.com/` 作为引用地址。

- `origin-when-cross-origin`

  对于同源的请求，会发送完整的URL作为引用地址，但是对于非同源请求仅发送文件的源。

- `same-origin`

  对于同源的请求会发送引用地址，但是对于非同源请求则不发送引用地址信息。

- `strict-origin`

  在同等安全级别的情况下，发送文件的源作为引用地址，但是在降级的情况下不会发送。

- `strict-origin-when-cross-origin`

  对于同源的请求，会发送完整的URL作为引用地址，在同等安全级别的情况下，发送文件的源作为引用地址，在降级的情况下不发送此首部。

- `unsafe-url`

  无论是同源请求还是非同源请求，都发送完整的 URL（移除参数信息之后）作为引用地址。

## 默认值

如果Referrer-Policy未设置任何策略，则使用浏览器的默认值，`no-referrer-when-downgrade` 是跨浏览器的一种广泛的默认策略。但是现在，许多浏览器正处于向更多提高隐私的默认设置过渡的阶段。

Chrome计划在85版开始，将其切换默认策略 `no-referrer-when-downgrade` 更换到 `strict-origin-when-cross-origin`。

## References

1. mozilla官网：[Referrer-Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Referrer-Policy)
2. Chrome博客：[A new default Referrer-Policy for Chrome - strict-origin-when-cross-origin](https://developer.chrome.com/blog/referrer-policy-new-chrome-default)

