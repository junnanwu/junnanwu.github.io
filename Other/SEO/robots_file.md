# robots.txt文件

robots.txt 文件规定了搜索引擎抓取工具可以访问您网站上的哪些网址。 此文件主要用于避免您的网站收到过多请求；它并不是一种阻止 Google 抓取某个网页的机制。若想阻止 Google 访问某个网页，请使用 `noindex` 禁止将其编入索引，或使用密码保护该网页。

例如：简单规则的robots.txt文件：

```
User-agent: Googlebot
Disallow: /nogooglebot/

User-agent: *
Allow: /

Sitemap: https://www.example.com/sitemap.xml
```

**以下是该 robots.txt 文件的含义**：

1. 名为 Googlebot 的用户代理不能抓取任何以 `https://example.com/nogooglebot/` 开头的网址。
2. 其他所有用户代理均可抓取整个网站。不指定这条规则也无妨，结果是一样的；默认行为是用户代理可以抓取整个网站。
3. 该网站的站点地图文件路径为 `https://www.example.com/sitemap.xml`。

## 格式和位置

- 文件必须命名为 robots.txt。
- 网站只能有 1 个 robots.txt 文件。
- robots.txt 文件必须位于其要应用到的网站主机的根目录下。例如，若要控制对 `https://www.example.com/` 下所有网址的抓取，就必须将 robots.txt 文件放在 `https://www.example.com/robots.txt` 下

## References

1. Google文档：[robots.txt 简介](https://developers.google.com/search/docs/crawling-indexing/robots/intro)