# Java Email

如何知道发送邮件的地址是否正确？

> **Q:** If I send a message to a bad address, why don't I get a SendFailedException or TransportEvent indicating that the address is bad?
> **A:** There is no end-to-end address verification on the Internet. Often a message will need to be forwarded to several mail servers before reaching one that can determine whether or not it can deliver the message. If a failure occurs in one of these later steps, the message will typically be returned to the sender as undeliverable. A successful "send" indicates only that the mail server has accepted the message and will try to deliver it.
>
> **Q:** When a message can't be delivered, a failure message is returned. How can I detect these "bounced" messages?
> **A:** While there is an Internet standard for reporting such errors (the multipart/report MIME type, see [RFC1892](http://www.imc.org/rfc1892)), it is not widely implemented yet. [RFC1211](http://www.imc.org/rfc1211) discusses this problem in depth, including numerous examples.
>
> In Internet email, the existence of a particular mailbox or user name can only be determined by the ultimate server that would deliver the message. The message may pass through several relay servers (that are not able to detect the error) before reaching the end server. Typically, when the end server detects such an error, it will return a message indicating the reason for the failure to the sender of the original message. There are many Internet standards covering such Delivery Status Notifications but a large number of servers don't support these new standards, instead using ad hoc techniques for returning such failure messages. This makes it very difficult to correlate a "bounced" message with the original message that caused the problem. (Note that this problem is completely independent of JavaMail.) JavaMail now includes support for parsing Delivery Status Notifications; see the [NOTES.txt](https://javaee.github.io/javamail/docs/NOTES.txt) file in the JavaMail package for details.
>
> There are a number of techniques and heuristics for dealing with this problem - none of them perfect. One technique is Variable Envelope Return Paths, described at http://cr.yp.to/proto/verp.txt. The use of VERP with JavaMail and Apache James is described [here](http://cephas.net/blog/2006/06/09/using-apache-james-and-javamail-to-implement-variable-envelope-return-paths/).



## References

1. https://javaee.github.io/javamail/FAQ#badaddr
