# 文件名乱码问题之Content-Disposition标头

## Postman文件名不能正确显示

曾经我遇到过一个问题，在Postman测试下载Excel接口的时候，发现中文文件名并不能正确显示。

例如，下载文件名为`文件名.xlsx`的Excel文件的时候，在Postman选择将响应体保存为文件，我们会看到文件名不能正确显示：

![postman_download_example](header_content_disposition_assets/postman_download_example.png 'Postman下载中文文件名不能正确显示')

但是在浏览器中下载，文件名就没有问题。

当时没有深究，现在记录这个问题背后的来龙去脉，相信你看完本文，文件名乱码问题不再有疑惑。

## Content-Disposition标头

要讨论保存文件的文件名，首先我们需要了解哪个响应头携带了相关信息。

在[Hypertext Transfer Protocol – HTTP/1.1](http://www.rfc-editor.org/rfc/rfc2616.pdf)中提到：

> The Content-Disposition response-header field has been proposed as a means for the origin server to suggest a default filename if the user requests that the content is saved to a file. This usage is derived from the definition of Content-Disposition in RFC 1806.

也就是说，作为响应头的时候，Content-Disposition主要的作用就是告诉浏览器，要保存的文件名叫什么。

其格式如下：

```
Content-Disposition: attachment/inline; filename="$file_name"
```

**attachment/inline**

首先看该标头格式中的第一部分，其中：

- attachment指示浏览器将该文件作为附件下载
- inline指示浏览器直接打开该文件

注意，这里inline直接打开的文件，仅包括浏览器可以打开的格式，例如png、pdf等，如果文件格式为浏览器无法打开的格式，例如Excel、Zip等，文件也会作为附件下载，效果和attachment相同。

**filename**

filename部分，即下载文件的名称。

## filename乱码

问题就出现在filename这里，因为HTTP规定了，**URI和Header中不能出现ASCII以外的字符**（关于ASCII可参考：[字符集与字符编码](ComputerBasic/character_set.md)），所以filename如果是英文名称还好，如果是中文名称，例如下面的响应：

```
Content-Disposition: attachment/inline; filename="文件名.xlsx"
```

那么浏览器收到的Content-Disposition就会乱码，从而导致文件名乱码：

![chrome_download_utf8_raw](header_content_disposition_assets/chrome_download_utf8_raw.png '文件名非ASCII字符不经过URL编码会造成乱码')

## URL编码

为了解决非ASCII字符的编码问题，各大浏览器想出了一些办法，其中IE等浏览器直接在filename中使用**URL编码**（也被称为百分号编码）。

相关标准为[RFC 1738](https://www.ietf.org/rfc/rfc1738.txt)，其规定如下：

>Thus, only alphanumerics, the special characters "`$-_.+!*'(),`", and  reserved characters used for their reserved purposes may be used unencoded within a URL.

即只有字母和数字`[0-9a-zA-Z]`、一些特殊符号`$-_.+!*'(),`、以及某些保留字才可以不经编码直接用于URL，其他字符必须经过编码，具体采用哪种编码，交给浏览器来决定，例如，Chrome浏览器使用了UTF-8编码（详见[URL Encoding](https://developers.google.com/maps/url-encoding)）。

另外，多数语言都提供了URL编码转换的方法，例如，Java提供了`java.net.URLEncoder.encode`方法。

所以，这个时候Content-Disposition响应头的格式变为：

```
Content-Disposition: attachment/inline; filename="$encoded_file_name"
```

其中，encoded_file_name代表URL编码后的文件名。

我们按照上述方式对`文件名.xlsx`进行URL编码，对应Java代码如下：

```java
@GetMapping("UTF8")
public void downloadUTF8(HttpServletResponse response) throws IOException {
    String encodeFileName = URLEncoder.encode("文件名.xlsx", "UTF-8");
    response.setHeader("Content-disposition", "attachment;filename=\"" + encodeFileName + "\"");
    exportExcel(response);
}
```

得到如下响应头：

```
Content-disposition: attachment;filename=%E6%96%87%E4%BB%B6%E5%90%8D.xlsx
```

浏览器再次访问此下载链接，发现文件名显示正常：

![chrome_download_utf8](header_content_disposition_assets/chrome_download_utf8.png '非ASCII字符URL编码后文件名正常显示')

这也解释了我们文章开头的疑问，为什么同样的接口，Postman下载文件无法正常显示呢？

因为我们服务端的代码（大部分的网上的参考代码），使用的方案都是对filename进行URL编码，**Postman并未进行解码**，所以我们保存文件的时候，直接显示的就是响应体中的文件名：`%E6%96%87%E4%BB%B6%E5%90%8D.xlsx`。

而Chrome进行了解码，所以能正常显示`文件名.xlsx`。

## RFC 5987 格式

上面我们提到的方案，即将filename进行URL编码后，按如下格式处理：

```
Content-Disposition: attachment/inline; filename="$encoded_file_name"
```

只是某些浏览器的方案，如IE、Chrome、Firfox等，并不是统一标准，像苹果的Safari浏览器就不支持（已测试），不会进行反编译。

所以，2010年，[RFC 5987](http://tools.ietf.org/html/rfc5987) 发布，正式规定了 HTTP Header 中多语言编码的处理方式采用如下格式：

```
parameter*=charset'lang'value
```

其中：

- lang 是用来标注字段的语言，以供读屏软件朗诵或根据语言特性进行特殊渲染，可以留空
- value使用URL编码，编码方式为指定的charset，并规定浏览器至少应该支持ASCII和UTF-8
- 当 parameter 和 parameter* 同时出现在 HTTP 头中时，浏览器应当使用后者

所以，按照此标准，Content-Disposition响应头的格式就变为：

```
Content-Disposition: attachment/inline; filename*=charset''$encoded_file_name
```

对应的Java代码如下：

```java
@GetMapping("UTF8_declare")
public void downloadUTF8Declare(HttpServletResponse response) throws IOException {
    String encodeFileName = URLEncoder.encode("文件名.xlsx", "UTF-8");
    response.setHeader("Content-disposition", "attachment;filename*=utf-8''" + encodeFileName);
    exportExcel(response);
}
```

得到的响应头如下：

```
Content-disposition: attachment;filename*=utf-8''%E6%96%87%E4%BB%B6%E5%90%8D.xlsx
```

这种标准格式被所有主流浏览器支持（不包括老版本）：

![chrome_download_utf8_declare](header_content_disposition_assets/chrome_download_utf8_declare.png '使用统一格式，文件名正常显示')

上面提到，charset也可以使用其他编码，只是浏览器不一定支持，例如，我们使用GBK，响应头如下：

```
Content-disposition: attachment;filename*=GBK''%CE%C4%BC%FE%C3%FB.xlsx
```

经测试，Chorme（108版本）和Firefox（108版本）是支持的，但是Safari不支持。

## 最佳实践

虽然RFC 5987规定所有浏览器都必须支持其规定的格式，很多用户使用的是老版本浏览器，为了向前兼容，最好**两种响应头都加上**，RFC 5987也给出了范例：

```
Content-Disposition: attachment;
                     filename="EURO rates";
                     filename*=utf-8''%e2%82%ac%20rates
```

这样的话，对于较新的浏览器，会支持新标准的`filename*`，对于旧版本的IE浏览器等，它们无法识别`filename*`，会忽略参数，使用`filename`，这样也不必根据UA判断用户使用的是什么浏览器了。

## 总结

1. Content-Disposition响应头里面指示了浏览器保存文件的文件名

2. URI和HTTP Header中不支持非ASCII字符

3. 服务端需要将文件名进行URL编码之后，放入Content-Disposition响应头中，Java可使用`java.net.URLEncoder.encode`方法

4. 浏览器会将URL编码后的文件名，解码成正确的文件名

5. 最佳实践是`filename`和`filename*`两种参数都返回，以兼容低版本浏览器：

   ```
   Content-Disposition: attachment; filename="$encoded_file_name"; filename*=utf-8''$encoded_file_name
   ```

## References

1. 博客：[正确处理下载文件时HTTP头的编码问题（Content-Disposition）](https://blog.robotshell.org/2012/deal-with-http-header-encoding-for-file-download/)
2. 博客：[HTTP 协议 header 中 Content-Disposition 中文文件名乱码](https://my.oschina.net/pingpangkuangmo/blog/376332)
3. 博客：[探究 Content-Disposition：解决下载中文文件名乱码](https://blog.csdn.net/liuyaqi1993/article/details/78275396)
4. Mozilla文档：[Content-Disposition](https://developer.mozilla.org/docs/Web/HTTP/Headers/Content-Disposition)
5. Google文档：[URL Encoding](https://developers.google.com/maps/url-encoding)
6. 阮一峰：[关于URL编码](https://www.ruanyifeng.com/blog/2010/02/url_encoding.html)
7. Stack Overflow：[Do I need Content-Type: application/octet-stream for file download?](https://stackoverflow.com/questions/20508788/do-i-need-content-type-application-octet-stream-for-file-download)