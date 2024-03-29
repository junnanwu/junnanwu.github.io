# Email Protocol

## SMTP

SMTP（Simple Mail Transfer Protocol）是因特网电子邮件中主要的应用层协议，它使用TCP协议传输数据。

它是一个推协议，即发送文件服务器将文件推向接收邮件服务器，而HTTP则是拉协议，在Web服务器上装载信息，用户使用HTTP从该服务器拉取这些信息。

SMTP一般不使用中间邮件服务器发送邮件，即使这两个邮件服务器位于地球两端，这个TCP连接也是直接连接的。

发送过程：

- 客户SMTP在25号端口建立一个到服务器SMTP的TCP连接

- 连接建立后，服务器和客户执行应用层握手

  在传输信息前相互介绍，SMTP客户指示发送方和接收方的邮件地址

- 客户发送报文

  SMTP能依赖TCP提供的可靠数据传输无差错的将邮件投递到接受服务器

- 客户有另外的报文要发送，则基于这个TCP连接重复这种处理，否则，关闭连接

**接收方如何获取邮件呢？**

接受方不能使用SMTP得到报文，因为取报文是一个拉操作，而SMTP是一个推协议。通过引入一个特殊的邮件访问协议来解决这个问题，例如：POP3（Post Office Protocol — Version 3）、IMAP（Internet Mail Access Protocol）以及HTTP。

因特网电子邮件的一些协议：

![email_protocol](email_protocol_assets/email_protocol.jpg)

- SMTP用来将邮件从发送方的邮件服务器传输到接受方的邮件服务器
- SMTP也用来将邮件从发送方的用户代理发送到发送方的邮件服务器
- POP3等的邮件访问协议将邮件从接收方的邮件服务器传送到接收方的用户代理

注意：

- 用户代理（User Agent），如Outlook等客户端
- 邮件服务器（Mail Server），如Outlook等服务器。

观察电脑上的客户端也可以看到发送邮件使用的是SMTP，收件使用的是IMAP：

![my_email_client](email_protocol_assets/my_email_client.png)**缺点**

- 初始SMTP协议要求每个报文采用7比特ASCII格式

### MIME

由于Internet的迅速发展，人们已不满足于电子邮件仅仅是用来交换文本信息，而是希望交换更为更为丰富的多媒体信息，故有了MIME（Multipurpose Internet Mail Extensions）协议对SMTP协议进行扩充。

一封MIME 邮件可以由多个不同类型的MIME消息组合而成，一个MIME消息表示邮件中的一个基本MIME资源或若干基本MIME消息的组合体。每个MIME消息的 数据格式与RFC822数据格式相似，也包括头和体两部分，分别称为MIME消息头和MIME消息体，它们之间使用空行分隔。MIME消息体中包含了资源的具体内容，MIME消息头中则包含了对资源的描述信息。

MIME类型由两部分组成，前面是数据的大类别，例如声音audio、图象image等，后面定义具体的种类，例如：

- 超文本标记语言文本（ .html ）`text/html`
- 普通文本（.txt）`text/plain`
- PNG图像（.png）`image/png`

MIME使得邮件也支持了非ASCII字符，二进制文件等多种格式的邮件消息。

最早的HTTP协议所有的传送数据都被客户端解释为HTML文档，为了支持多媒体数据类型，HTTP协议后续也支持了MIME。

## POP3

POP3是一个极为简单的邮件访问协议，POP有如下三个阶段：

- 特许

  用户代理发送用户名和口令以鉴别用户

- 事务处理阶段

  这个阶段用户代理发出一些指令，服务器对每个命令做出回答。

  此操作包括：

  - 用户代理取回报文
  - 对报文做删除处理
  - 取消报文删除标记
  - 获取邮件的统计信息

- 更新阶段

  出现在客户端发出quit命令之后，目的是结束该POP3会话，这时，邮件服务器将删除那些标记为删除的邮件

POP3并不在会话过程中携带状态信息。

## IMAP

同POP3一样，IMAP也是邮件访问协议，但POP3协议没有给用户提供任何创建远程文件夹并为报文指派文件夹的方法。

IMAP服务器维护了IMAP会话的用户状态信息，例如文件夹的名字以及哪些报文与哪些文件夹相关联。

IMAP的另一个重要特性是它具有允许用户代理获取报文某些部分的命令，当用户代理与邮件服务器之间低带宽连接的时候，用户可以取回邮箱中的部分邮件。



## 基于Web的邮件

当使用Web浏览器收发邮件的时候，用户代理就是浏览器，用户代理和邮件服务器之间采用HTTP进行通信，在此情况下：

- 发件人通过HTTP协议将邮件报文从浏览器发送到邮件服务器
- 收件人通过HTTP协议将邮件从邮件服务器发送到他的浏览器
- 然而，发件人的邮件服务器和收件人的邮件服务器之间仍采用SMTP通信

![email_protocol_http](email_protocol_assets/email_protocol_http.jpg)

## References

1. 书籍：《计算机网络——自顶向下方法》第七版