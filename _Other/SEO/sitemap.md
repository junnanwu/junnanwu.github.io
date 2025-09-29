# sitemap

sitemap就是告诉搜索引擎，某网站一共都有哪些链接。

## 什么情况下建议创建sitemap

（来自[Google文档](https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview)）

在以下情况下，您可能需要站点地图：

- **网站规模很大。**在这种情况下，Google 网页抓取工具更有可能在抓取时漏掉部分新网页或最近更新的网页。
- **网站有大量内容页归档，这些内容页之间互不关联或缺少有效链接。**如果您的网站网页没有自然地相互引用，那么您可以在站点地图中列出这些网页，确保 Google 不会漏掉其中某些网页。
- **网站为新网站且指向该网站的外部链接不多。**Googlebot 及其他网页抓取工具是通过跟踪网页之间的链接来抓取网页的。因此，如果没有其他网站链接到您的网页，Google 可能不会发现您的网页。
- **您的网站包含大量富媒体内容（视频、图片）或显示在 Google 新闻中。**如果提供了站点地图，在适当情况下，Google 能将站点地图中的其他信息纳入搜索范围。

在以下情况下，您可能不需要站点地图：

- **您的网站规模“较小”。**规模较小是指网站上的网页数不超过 500 个。（只有您认为需要纳入搜索结果中的网页才会计入此总数。）
- **您的网站已在内部全面建立链接。**这意味着，Google 可以沿着首页的链接找到您网站上的所有重要网页。
- 您想在搜索结果中显示的**媒体文件**（视频、图片）**或新闻网页**不多。站点地图可帮助 Google 找到并了解您网站上的视频和图片文件或新闻报道。但如果您不希望这些内容出现在图片、视频或新闻搜索结果中，则可能不需要站点地图。

## 和robots.txt的关系

robots.txt中有指定sitemap的位置。

另外，如果在Robots.txt文件中，为一个页面使用了noindex标签，那么它就不应该出现在站点地图中。

## sitemap类型

sitemap有TXT类型的，XML类型。

TXT类型缺点是只能包括URL地址，而不能包括其他信息。

## XML sitemaps

Google引入了Sitemaps协议，基本各大搜索引擎都支持。网站开发者可以通过暴露此文件来提供给搜索引擎该站点都包括哪些链接。

格式如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>http://www.example.net/?id=who</loc>
    <lastmod>2009-09-22</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
  <url>
    <loc>http://www.example.net/?id=what</loc>
    <lastmod>2009-09-22</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.5</priority>
  </url>
  <url>
    <loc>http://www.example.net/?id=how</loc>
    <lastmod>2009-09-22</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.5</priority>
  </url>
</urlset>
```

- lastmod：链接页面的最后修改日期
- changefreq：页面更新的频率，完整格式为：`2004-10-26T08:56:39+00:00`，也可以省略具体时间
- 该URL相对于其他本站其他URL的权重，取值从0.0-1.0

## 常用生成工具

- https://freesitemapgenerator.com

  在线生成网站，一个账号免费可以添加三个网站，一个网站可以生成5000个url。

  经测试，其他在线网站都不如这个，就不再列举了。

- http://cn.sitemapx.com

  Windows小工具，比起上面在线生成网站，功能更多：

  - 可以定制遍历深度、修改日期、频次、权重等字段
  - 可以设置ftp自动上传文件
  - 可以设置定时任务定时执行

  也发现一个问题，要抓取的网站不能输入https格式的，不然提示格式错误，这点很影响使用，最后我选择了上面的在线生成的方式。

另外，[这里](https://code.google.com/archive/p/sitemap-generators/wikis/SitemapGenerators.wiki)Google汇总了如何生成sitemap的方式，非常全面。

## 如何提交sitemap

- 在搜索引擎提供的页面主动提交
- 使用API通知搜索引擎
- 使用ping工具，在浏览器或命令行中向此指定地址发送 GET 请求，并指定站点地图的完整网址
- 在robots.txt 文件中指定，搜索引擎会在下次抓取 robots.txt 文件时找到该sitemap

## References

1. Google文档：[了解站点地图](https://developers.google.com/search/docs/crawling-indexing/sitemaps/overview)
2. Google文档：[sitemap-generators - SitemapGenerators.wiki](https://code.google.com/archive/p/sitemap-generators/wikis/SitemapGenerators.wiki)
3. 官方网站：[sitemaps.org](https://www.sitemaps.org/)
4. 维基百科：[sitemap](https://en.wikipedia.org/wiki/Site_map)
5. 知乎：[Sitemap（站点地图）全知道](https://zhuanlan.zhihu.com/p/441973408)

