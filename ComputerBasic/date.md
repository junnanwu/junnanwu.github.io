# 关于时间

## 背景

工业革命前期，世界各地都有自己时间标准，每个地方都可以通过日晷等方式来得到太阳时来作为地方时间标准，当然由于所在的经度不通，不同的经度时间就会有所差异，由于工业革命中火车的出现，人们的移动速度和距离大大增加，那么不通地方的时间差异就会带来巨大的破坏，例如，1853年8月12日，美国东部罗德岛州，两辆火车迎头相撞，14人因此死亡。事故的原因居然是两车工程师的手表差了2分钟。

同一时期，电报的出现也使得远距离的即时时间校验变得可能。在铁轨和电报大规模建设的帮助下，交通与通信网密集的相连，变得越来越复杂，对时间误差的容忍度越来越低。铁路公司开始强硬的要求经过的城镇，都修改为伦敦（格林威治）标准时，这对应了现代社会多数国家使用一个标准的时间。

而全球时区的建立，则离不开航海业。与铁路为了提高运输效率不同，航海对标准时间的需求，是为了确定船舶的地理位置。在海中航行的船只如果不知道自己所处的经纬度，那将无法避开一些危险区域。例如，1707年，因为在暴风中无法测量经纬度，四艘英国军舰在锡利群岛沉没，1400余士兵死亡。

在海上，纬度的测量很简单，只要量出正午的太阳高度就能知道。但是经度测量则比较困难，先根据太阳测量出当地时间，再参照一个标准时间，才能计算出结果，麻烦在于，传统基于钟摆的时钟都经不起海洋的颠簸，失去了测量准度。

1761年约克郡工匠约翰·哈里森提交了十周内误差不超过10秒的海洋钟，此后，西方的船舶揣着哈里森钟表，开始了全世界的航行。

不过，经度的另一个问题，确定标准时间，在此时变得突出：要以哪个天文台观测的时间为标准时间？由于英国的海洋霸主地位，越来越多的轮船采用格林威治标准时间。

1876年，一个更为大胆的计划被加拿大工程师桑福德·弗莱明提出：以格林威治时间为标准，建立东西半球协调一致的24个时区，这是时区制第一次系统的表述，这也是如今通行时区的雏形。**它将全球纳入统一的标准时间系统，各地区将抛弃地方时，而归入格林威治为中心的各个时区**。

最终在1883年，经美国提议，41个国家参加了华盛顿的国际经度会议，通过了格林威治所在经线为本初子午线，180°经线为国际日期变更线，格林威治天文台时间为标准时，称为**格林威治标准时间（Greenwich Mean Time —— GMT）**，1928 年，国际天文学联合会引入了**世界时 (Universal Time——UT)** 一词来指代格林威治标准时间。

1955年，铯原子钟问世。这提供了一种比天文观测更稳定、更方便的计时形式，1967年第十三届国际计量大会决定，把在海平面上铯 -133 原子基态的两个超精细能级间在零磁场下跃迁辐射9,192,631,770周所持续的时间规定为一秒，任何原子钟在确定起始历元（1958年1月1日0时0分0秒世界时的瞬间）后的一个连续时间尺度为**原子时（International Atomic Time——TAI）**。

由于地球的自转不断变慢，为了使原子时更接近世界时，后来在原子时的基础上又有了地球**协调世界时（Coordinated Universal Time-UTC）**，当协调世界时和世界时在同一时刻相差超过0.9秒的时候，国际时间局会通知，到特定时间在协调世界时上闰秒+1s，所以协调世界时是不连续的。

当今世界使用协调世界时为民用时间标准。

## 表示时间的格式/标准

### RFC 2822

这个是规定邮件的协议，关于时间的部分是该协议的子集。

>date-time       =       [ day-of-week "," ] date FWS time [CFWS]
>
>day-of-week     =       ([FWS] day-name) / obs-day-of-week
>
>day-name        =       "Mon" / "Tue" / "Wed" / "Thu" /
>                        "Fri" / "Sat" / "Sun"
>
>date            =       day month year
>
>year            =       4*DIGIT / obs-year
>
>month           =       (FWS month-name FWS) / obs-month
>
>month-name      =       "Jan" / "Feb" / "Mar" / "Apr" /
>                        "May" / "Jun" / "Jul" / "Aug" /
>                        "Sep" / "Oct" / "Nov" / "Dec"
>
>day             =       ([FWS] 1*2DIGIT) / obs-day
>
>time            =       time-of-day FWS zone
>
>time-of-day     =       hour ":" minute [ ":" second ]
>
>hour            =       2DIGIT / obs-hour
>
>minute          =       2DIGIT / obs-minute
>
>second          =       2DIGIT / obs-second
>
>zone            =       (( "+" / "-" ) 4DIGIT) / obs-zone

例如：

`Date: Fri, 21 Nov 1997 09:55:06 -0600`

### ISO 8601

- 需要从最大的时间单位到最小的时间单位，如：

  年、月（或周）、日、小时、分钟、秒和秒的小数部分

- 每个日期或者时间都有固定的位数，不足的需要补0

- 有两种表示的格式，一种是具有最少分隔符的基本格式，一种是可读性更高的扩展模式

  日期之间的分隔符是英文短杠（hyphen），时间之间的分隔符是冒号（colon）。

  例如：2021年10月31号可以表示为

  - 基本格式：`20211031`
  - 扩展模式：`2021-10-31`

- 为了表示低精度时间，任何一个字段都可以省去不写，但是必须按照顺序读取

  例如，

  `2021-10`是合法的表示形式，且只能表示10月

- 最小的时间单位可以增加小数

格式：

- 年月日

  - 基本格式：

    `[YYYYMMDD]`

  - 扩展模式：

    `[YYYY-MM-DD]`

- 周

  `[Www]`

  2008 年 12 月 29 日星期一写成`2009-W01-1`

- 一年的第几天

  `[DDD]` 

  例如：

  `1981-04-05` 也可以写做：`1981-095`

- **时间**

  分为以下几种：

  - 本地时间

    没有时区的信息

  - UTC

    如果时间是 UTC，则直接在时间后添加一个 Z，不带空格。 Z 是零 UTC 偏移的区域指示符。

    因此，`09:30 UTC`表示为`09:30Z`或`T0930Z`。 `14:45:15 UTC`将是`14:45:15Z`或`T144515Z`。

  - UTC偏移时间

    可以和上述Z一样将UTC偏移量添加到时间中，负数偏移描述UTC±00:00以西的时区。

    格式可以为：

    `<time>±hh:mm`、 `<time>±hhmm`、 `<time>±hh`

    例如：

    `−05:00`表示纽约标准时间

- 日期和时间结合

  单个时间点可以通过日期表达式+分隔符`T`+时间表达式来表示。

  例如：

  `2007-04-05T14:30`

  也可以加上时区指示：

  `2007-04-05T14:30Z`

### RFC 3339

RFC 3339是一个用于规定DateTime格式的协议，是一套源自ISO 8601的标准，所以，两个协议是非常相似的。

>The following profile of ISO 8601 [ISO8601] dates SHOULD be used in new protocols on the Internet.  This is specified using the syntax description notation defined in [ABNF].
>
>   date-fullyear   = 4DIGIT
>   date-month      = 2DIGIT  ; 01-12
>   date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on month/year; 
>   time-hour       = 2DIGIT  ; 00-23
>   time-minute     = 2DIGIT  ; 00-59
>   time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap second; rules
>   time-secfrac    = "." 1*DIGIT
>   time-numoffset  = ("+" / "-") time-hour ":" time-minute
>   time-offset     = "Z" / time-numoffset
>
>   partial-time    = time-hour ":" time-minute ":" time-second[time-secfrac]
>   full-date       = date-fullyear "-" date-month "-" date-mday
>   full-time       = partial-time time-offset
>
>   date-time       = full-date "T" full-time

只是有一些小的区别：

- RFC 3339 允许其他字符替换 `T`
- ...

如图：

![RFC_and_ISO8601](date_assets/RFC_and_ISO8601.png)

## References

1. [大象公会 | 进击的格林威治时间](https://www.gdjv.cn/article/7164386)
2. https://en.wikipedia.org/wiki/ISO_8601
3. https://datatracker.ietf.org/doc/html/rfc2822
4. https://datatracker.ietf.org/doc/html/rfc3339
5. https://ijmacd.github.io/rfc3339-iso8601/





