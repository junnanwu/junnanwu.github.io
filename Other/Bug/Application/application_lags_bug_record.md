# 应用卡顿问题bug记录

## 背景

产品反应davinci系统卡顿，由于是内部报表网站，刚开始以为是复杂SQL用时太长，结果后来还是一直有反应系统慢，发现并非是数据接口，而是普通页面卡顿一分钟左右，很多前端js文件请求（前后端不分离），也有少量后端接口速度很慢。

## 分析

首先，卡顿的时候，查看相关服务器Linux资源是否正常， 结果发现CPU、内存等资源充足。

进一步，查看请求时间较长的具体后端接口，如下图所示：

![lags_interface](application_lags_bug_record_assets/lags_interface.png)

Chrome显示，此接口花费52秒，而奇怪的是，查看Spring监控，这个接口仅耗时不到0.1秒，如下图：

![interface_monitor](application_lags_bug_record_assets/interface_monitor.png)

当时认为是不是监控出问题了，查看后端代码后发现此接口代码非常简单，不应该阻塞这么长时间的。

当时就没什么思路了，想着经常看到Chrome Waterfall灰色的条，绿色的条，但却不是很熟，准备总结一下 ，在看[文章](https://www.cnblogs.com/webvision/p/11595772.html)的时候，突然看到一句话：

> 出现和目标服务器已经建立了6个TCP链接时，浏览器会把当前请求放入队列中进行排队。

再一看阻塞的请求waterfall，如下图所示：

![interface_waterfall](application_lags_bug_record_assets/interface_waterfall.png)

这大部分时间，不正是在Queueing中吗？也就是说时间长是因为大部分时间都在等待队列，根本没有发出请求，这也正好解释了为啥监控显示的接口请求时间和Chrome显示的请求时间不一致。

继续查看，发现确实有一个请求一直在等待（绿色的条）：

![interface_queue](application_lags_bug_record_assets/interface_queue.png)

那就基本清晰了，这个接口是请求网站icon的 ，之前看到过报错，但是想着这种非业务请求，加上页面的icon也正常加载了，就没有管了，但没想到居然影响了正常的请求。

第二天一早，查看Nginx，发现html文件夹中有这个favicon.ico图片，但是配置文件中的`/`根目录前缀匹配不存在了，可能中间不知道啥时候更改了这个配置，导致此链接失效了。

修复这个链接后，可预料的，网页果然不卡顿了。

## 总结

首先是手里的每天用的工具不熟练，每天都在用的Chrome网络很多东西还想当然，没有研究。

其次就是遇到Bug没思路就多测试、对比，寻找规律，例如刚开始发现大部分都是js请求卡住，怀疑是前端问题，在多测试几次发现也有少部分后端接口也慢得离谱，基本就不会一直看前端了。

## References

- 博客：[前端性能之Chrome的Waterfall](https://www.cnblogs.com/webvision/p/11595772.html)