# 字符编码

## 基本概念

### 码点

码点（Code Point），一个字符即对应一个码点，也称之为码位（Code Position），有一个编号，称之为码点值。

### 码元

码元（Code Unit），指不同编码下，最小的有意义单元。

| 编码   | 码元   |
| ------ | ------ |
| UTF-8  | 8-bit  |
| UTF-16 | 16-bit |
| UTF-32 | 32-bit |

## ASCII

ASCII（American Standard Code for Information Interchange，美国信息互换标准编码）

单字节编码方案，最高位用于奇偶校验，所以一共128个字符。

ASCII采用单字节作为码元的大小，将0-127这128个编号直接映射为单字节的二进制数据。

详情见附录ASCII码表。

## GB系列

### GB2312

GB2312在1981年开始实施，共收录**6763**个汉字以及682个全角字符，并未收录ASCII字符集的字符。

提出了分区的概念，一共94个区，每个区可以放94个字符（类似行和列），所以定位一个字符的方式就是在第几分区的第几位字符。

例如，汉字`王`，这个字被放在了第45区的第85位，所以`王`对应的`区位码`是`4585`。

编码规则：

- 把`区位码`的区码和位码都加`160`，`45+160=205`，`85+160=245`（目的是使所有汉字的字节数都大于127，与ASCII码作区分）
- 分别拼成两个字节，`11001101 11110101`，对应16进制CDF5

总结：

- 一个小于127的字符的意义与原来相同
- 两个大于127的字符连在一起时，就表示一个汉字，前面的一个字节（他称之为高字节）从`0xA1`用到`0xF7`，后面一个字节（低字节）从`0xA1`到`0xFE`

举例：

```
我爱u

编码：
我对应的区位码是4650，编码后的十六进制是CED2，也就是二进制：1100111011010010。
爱对应的区位码是1614，编码后的十六进制是B0AE，也就是二进制：1011000010101110。
u是ASCII字符集字符，编码后是75，二进制就是：01001011

拼起来：
1100111011010010101100001010111001001011
16进制：
CED2B0AE4B

解码：
读一个字节CE，发现它大于127，所以这是一个两个字节的字符，所以连续读了两个字节CED2，在编码表里查到这是汉字我。
接着再读一个字节B0，发现它大于127，所以连续读了两个字节B0AE，在编码表里查到这是汉字爱。
接着再读一个字节4B，发现它小于127，所以在ASCII码表里查到这是英文子母u。
```

### GBK

GBK（国标、扩展），兼容GB2312，1995年正式发布，共收录了**21003**个汉字（GB2312连总理朱镕基的"镕"字都没有收录）。

### GB18030

兼容GBK，2000年发布，包含多种我国少数民族文字，收入汉字**70000**余个。

在GB系列标准中，一个汉字基本都是两个字节，相当于两个字符。

GB系列的编码模型都类似。

## Unicode

万国码，这套编码废除了除ASCII字符集外的其他所有编码，收录了地球上的所有字符。

如果每次新增一个编码就简单的自增追加在最后，显然不利于管理，所以提出了平面的概念，一共设计了17（0~16）个平面，每个平面65536个编号（2个字节），就像Java中的错误码一样，第一位代表了不同的分类。

其中第0个平面是包含了当前世界上最常用的一些字符。所以这第0个平面也叫做BMP(Basic Multilingual Plane的缩写)，翻译过来就是基本多语言平面。

![unicode_plane](character_set_assets/unicode_plane.png)

Unicode字符集中的编号通常用下面方式表示：

```
U+十六进制编号
```

例如`王`字的十六进制编号是`738B`，所以我们就写成：

```
U+738B
```

### 编码方案

#### UTF-8

这种编码方式的码元采用的1个字节，就还是会产生上面的问题，怎么知道哪个字符是1个码元，哪个是多个呢？

UTF-8采用了首字节的方式来判断是用的几个字节

- 如果首字节以`0`开头，肯定是单字节编码(1个码元)，读取一个字节即可，`0XXX XXXX`
- 如果首字节以`110`开头，肯定是双字节编码(2个码元)，读取两个字节，`110XXXXX 10XXXXXX`
- 如果首字节以`1110`开头，肯定是三字节编码(3个码元)，读取三个字节，`1110XXXX 10XXXXXX 10XXXXXX`
- ...

（如果某个字符是多个字节编码的，除了首字节外，其余字节都要用10开头，以区别单字解释编码和多字节编码的首字节）

例子：

```
字符 u
u的unicode编号是117(二进制1110101)
套用规则：
01110101

汉字 啊
啊的unicode编号是21834(十六进制0x554A，二进制101010101001010)，占15个位，需要用15个字节编码
所以采用3字节编码模板1110xxxx 10xxxxxx 10xxxxxx，把二进制数据填进去，高位补0
11100101 10010101 10001010

16进制
E5958A
```

#### UTF-16

我们知道`unicode字符集`基本多语言平面(也就是第0平面)，编号范围是:0 ~ 65535(十六进制：`0xFFFF`)。

但是2个字节最多只能表示65536个字符，所以一个两字节的`码元`最多只能直接表示基本多语言平面的编号，所以在表示其余的16个平面的字符时需要用多个`码元`。所以`UTF-16编码方案`和`UTF-8编码方案`一样，也会有这个问题：

计算机如何区分哪个字符是用一个码元(此处是2字节)表示，哪个字符使用多个码元表示的？

`UTF-16`提出了一个`代理区`的概念来解决这个问题。

他们规定基本多语言平面的`56320 ~ 57343`(十六进制`0xDC00 ~ 0xDFFF`)这个区间的编号为`代理区`，这个区间的编号并不对应字符。

1. 对于基本多语言平面(也就是第0平面)中不属于`代理区`编码的字符，使用一个码元(2字节)，编号直接映射为字符编码

2. 对于第1～16平面，采用两个码元来进行编码，具体编码原理见下文：
   
    - 第一个码元的取值范围是`0xD800~0xDBFF`(二进制为`11011000 00000000` ~ `11011011 11111111`，十进制为`55296 ~ 56319`)，第二个码元的取值范围为`0xDC00~0xDFFF`(二进制为`1101 1100 0000 0000` ~ `1101 1111 1111 1111`，十进制为`56320 ~ 57343`)
    
    - 根据上一步确定的码元的取值范围，可以得出它的二进制表现形式：
    
      `110110pp ppxxxxxx 110111xx xxxxxxxx`
    
    - 可以看到，它的有效编码位数只有20位，其中4位pppp代表该编码所在平面(1~16)，16位代表在该平面的位置
    
    - 然后这有效编码位数的20位一共可以表示2的20次方，也就是1048576个编码，正好把16个平面的字符都表示完

由于大部分常用字符都在第0平面，那么大部分编码都是两个字节。

看下怎么对字符`u`进行`UTF-16`编码：

`u`字符的`unicode编号`是`117`(二进制`1110101`)，这个编号小于`65536`，在基本多语言平面中，所以采用直接将编号转为编码的方式进行编码，但是`码元`是两字节的，所以高位补0就行。

字符`u`的`UTF-16`的编码结果就是：

```
00000000 01110101
```

注意：`UTF-16`编码最少采用2个字节，导致了像英文字母这样在`0~127`编号的字符也得用2个字节编码。而`UTF-8`只需要1个字节来编码`0~127`编号的字符。所以`UTF-16`在编码`0~127`编号的字符的时候会比`UTF-8`浪费。

再看`啊`字的栗子：

`啊`的unicode编号是`21834`(二进制`101010101001010`)，这个编号小于`65536`，在基本多语言平面中，所以采用直接将编号转为编码的方式进行编码，但是`码元`是两字节的，所以高位补0就行。

字符`啊`的`UTF-16`的编码结果就是：

```
01010101 01001010
```

生僻汉字`𨢻`，看他的编码过程：

1. `𨢻`的unicode编号是`166075`(二进制`101000100010111011`)，这个编号不小于`65536`，在第2平面中，所以到第二步来处理
2. 根据`110110pp ppxxxxxx 110111xx xxxxxxxx`这个式子，因为在第2平面中，所以`pppp`对应的二进制就是`0010`，这个字在第2平面的第`60514`(二进制`1110110001100010`)位，所以`xxxxxxxxxxxxxxxx`就可以被替换成`1110110001100010`

所以字符`𨢻`的`UTF-16`的编码结果就是：

```
11011100 10111011 11011000 01100010
```

#### UTF-32

这种编码方案的`码元`采用4个字节。

因为整个`unicode字符集`目前编码范围是17个平面，每平面65536个编号，所以一共是`1114112`个数。4个字节就可以表示`4294967296`个数，所以使用一个码元(4字节)就可以表示所有的编号喽。

比如`u`字符，`u`字符的unicode编号是`117`(二进制`1110101`)，所以就直接被编号为：

```
00000000 00000000 00000000 01110101
```

再看`𨢻`字符，它的unicode编号是`166075`(二进制`101000100010111011`)，所以就直接被编号为：

```
00000000 00000001 01000100 010111011
```

### 在线转换注意

有时候想查一下一个字符对应的utf-8编码是啥，就会去搜索utf-8在线转换，但是实际上，大部分中文在线ut f-8转换工具都是错的，经测试（2022年11月18日），百度搜索出来第一页的utf-8在线转换中，只有一个是对的，其他所有都是返回的该字符的Unicode。

例如上面测算过的`啊`，对应的Unicode为`0x554A`，utf-8编码为`e5 95 8a`，很多工具返回的是`0x554A`，在查询的时候注意辨别。

可以使用如下转换工具：[UTF8 Encode Decode](https://convertcodes.com/utf8-encode-decode-convert-string/)

## 字节顺序标记

字节顺序标记（byte order mark、BOM），在文本文件的最开头，有如下作用：

- 指示了文件使用的编码格式

- 指示了字符编码的高有效位是否存储在文件的初始位置，当字符编码的高有效位被存储在文件的初始位置，被称为"大端序"（big-endian），否则，称为"小端序"。

  例如，`0x00000744`这个字符，用UTF-16编码可以表示为 `07 44` 或 `44 07`在UTF-32中可以表示为 `07 44 00 00` 或 `00 00 44 07`。

  注意，UTF-8编码采用了单字节码元，且规定了顺序，所以不需要BOM来指定顺序。

| 编码                 | BOM         |
| -------------------- | ----------- |
| UTF-8                | EF BB BF    |
| UTF-16 big-endian    | FE FF       |
| UTF-16 little-endian | FF FE       |
| UTF-32 big-endian    | 00 00 FE FF |
| UTF-32 little-endian | FF FE 00 00 |

### 实际应用

有时候读取文件的时候，文件开头的BOM会影响我们对文件的解析，需要进行处理。

## 附录

### ASCII码表

| Bin(二进制) | Dec(十进制) | 缩写/字符                   | 解释         |
| ----------- | ----------- | --------------------------- | ------------ |
| 0000 0000   | 0           | NUL(null)                   | 空字符       |
| 0000 0001   | 1           | SOH(start of headline)      | 标题开始     |
| 0000 0010   | 2           | STX (start of text)         | 正文开始     |
| 0000 0011   | 3           | ETX (end of text)           | 正文结束     |
| 0000 0100   | 4           | EOT (end of transmission)   | 传输结束     |
| 0000 0101   | 5           | ENQ (enquiry)               | 请求         |
| 0000 0110   | 6           | ACK (acknowledge)           | 收到通知     |
| 0000 0111   | 7           | BEL (bell)                  | 响铃         |
| 0000 1000   | 8           | BS (backspace)              | 退格         |
| 0000 1001   | 9           | HT (horizontal tab)         | 水平制表符   |
| 0000 1010   | 10          | LF (NL line feed, new line) | 换行键       |
| 0000 1011   | 11          | VT (vertical tab)           | 垂直制表符   |
| 0000 1100   | 12          | FF (NP form feed, new page) | 换页键       |
| 0000 1101   | 13          | CR (carriage return)        | 回车键       |
| 0000 1110   | 14          | SO (shift out)              | 不用切换     |
| 0000 1111   | 15          | SI (shift in)               | 启用切换     |
| 0001 0000   | 16          | DLE (data link escape)      | 数据链路转义 |
| 0001 0001   | 17          | DC1 (device control 1)      | 设备控制1    |
| 0001 0010   | 18          | DC2 (device control 2)      | 设备控制2    |
| 0001 0011   | 19          | DC3 (device control 3)      | 设备控制3    |
| 0001 0100   | 20          | DC4 (device control 4)      | 设备控制4    |
| 0001 0101   | 21          | NAK (negative acknowledge)  | 拒绝接收     |
| 0001 0110   | 22          | SYN (synchronous idle)      | 同步空闲     |
| 0001 0111   | 23          | ETB (end of trans. block)   | 结束传输块   |
| 0001 1000   | 24          | CAN (cancel)                | 取消         |
| 0001 1001   | 25          | EM (end of medium)          | 媒介结束     |
| 0001 1010   | 26          | SUB (substitute)            | 代替         |
| 0001 1011   | 27          | ESC (escape)                | 换码(溢出)   |
| 0001 1100   | 28          | FS (file separator)         | 文件分隔符   |
| 0001 1101   | 29          | GS (group separator)        | 分组符       |
| 0001 1110   | 30          | RS (record separator)       | 记录分隔符   |
| 0001 1111   | 31          | US (unit separator)         | 单元分隔符   |
| 0010 0000   | 32          | (space)                     | 空格         |
| 0010 0001   | 33          | !                           | 叹号         |
| 0010 0010   | 34          | "                           | 双引号       |
| 0010 0011   | 35          | #                           | 井号         |
| 0010 0100   | 36          | $                           | 美元符       |
| 0010 0101   | 37          | %                           | 百分号       |
| 0010 0110   | 38          | &                           | 和号         |
| 0010 0111   | 39          | '                           | 闭单引号     |
| 0010 1000   | 40          | (                           | 开括号       |
| 0010 1001   | 41          | )                           | 闭括号       |
| 0010 1010   | 42          | *                           | 星号         |
| 0010 1011   | 43          | +                           | 加号         |
| 0010 1100   | 44          | ,                           | 逗号         |
| 0010 1101   | 45          | -                           | 减号/破折号  |
| 0010 1110   | 46          | .                           | 句号         |
| 0010 1111   | 47          | /                           | 斜杠         |
| 0011 0000   | 48          | 0                           | 字符0        |
| 0011 0001   | 49          | 1                           | 字符1        |
| 0011 0010   | 50          | 2                           | 字符2        |
| 0011 0011   | 51          | 3                           | 字符3        |
| 0011 0100   | 52          | 4                           | 字符4        |
| 0011 0101   | 53          | 5                           | 字符5        |
| 0011 0110   | 54          | 6                           | 字符6        |
| 0011 0111   | 55          | 7                           | 字符7        |
| 0011 1000   | 56          | 8                           | 字符8        |
| 0011 1001   | 57          | 9                           | 字符9        |
| 0011 1010   | 58          | :                           | 冒号         |
| 0011 1011   | 59          | ;                           | 分号         |
| 0011 1100   | 60          | <                           | 小于         |
| 0011 1101   | 61          | =                           | 等号         |
| 0011 1110   | 62          | >                           | 大于         |
| 0011 1111   | 63          | ?                           | 问号         |
| 0100 0000   | 64          | @                           | 电子邮件符号 |
| 0100 0001   | 65          | A                           | 大写字母A    |
| 0100 0010   | 66          | B                           | 大写字母B    |
| 0100 0011   | 67          | C                           | 大写字母C    |
| 0100 0100   | 68          | D                           | 大写字母D    |
| 0100 0101   | 69          | E                           | 大写字母E    |
| 0100 0110   | 70          | F                           | 大写字母F    |
| 0100 0111   | 71          | G                           | 大写字母G    |
| 0100 1000   | 72          | H                           | 大写字母H    |
| 0100 1001   | 73          | I                           | 大写字母I    |
| 01001010    | 74          | J                           | 大写字母J    |
| 0100 1011   | 75          | K                           | 大写字母K    |
| 0100 1100   | 76          | L                           | 大写字母L    |
| 0100 1101   | 77          | M                           | 大写字母M    |
| 0100 1110   | 78          | N                           | 大写字母N    |
| 0100 1111   | 79          | O                           | 大写字母O    |
| 0101 0000   | 80          | P                           | 大写字母P    |
| 0101 0001   | 81          | Q                           | 大写字母Q    |
| 0101 0010   | 82          | R                           | 大写字母R    |
| 0101 0011   | 83          | S                           | 大写字母S    |
| 0101 0100   | 84          | T                           | 大写字母T    |
| 0101 0101   | 85          | U                           | 大写字母U    |
| 0101 0110   | 86          | V                           | 大写字母V    |
| 0101 0111   | 87          | W                           | 大写字母W    |
| 0101 1000   | 88          | X                           | 大写字母X    |
| 0101 1001   | 89          | Y                           | 大写字母Y    |
| 0101 1010   | 90          | Z                           | 大写字母Z    |
| 0101 1011   | 91          | [                           | 开方括号     |
| 0101 1100   | 92          | \                           | 反斜杠       |
| 0101 1101   | 93          | ]                           | 闭方括号     |
| 0101 1110   | 94          | ^                           | 脱字符       |
| 0101 1111   | 95          | _                           | 下划线       |
| 0110 0000   | 96          | `                           | 开单引号     |
| 0110 0001   | 97          | a                           | 小写字母a    |
| 0110 0010   | 98          | b                           | 小写字母b    |
| 0110 0011   | 99          | c                           | 小写字母c    |
| 0110 0100   | 100         | d                           | 小写字母d    |
| 0110 0101   | 101         | e                           | 小写字母e    |
| 0110 0110   | 102         | f                           | 小写字母f    |
| 0110 0111   | 103         | g                           | 小写字母g    |
| 0110 1000   | 104         | h                           | 小写字母h    |
| 0110 1001   | 105         | i                           | 小写字母i    |
| 0110 1010   | 106         | j                           | 小写字母j    |
| 0110 1011   | 107         | k                           | 小写字母k    |
| 0110 1100   | 108         | l                           | 小写字母l    |
| 0110 1101   | 109         | m                           | 小写字母m    |
| 0110 1110   | 110         | n                           | 小写字母n    |
| 0110 1111   | 111         | o                           | 小写字母o    |
| 0111 0000   | 112         | p                           | 小写字母p    |
| 0111 0001   | 113         | q                           | 小写字母q    |
| 0111 0010   | 114         | r                           | 小写字母r    |
| 0111 0011   | 115         | s                           | 小写字母s    |
| 0111 0100   | 116         | t                           | 小写字母t    |
| 0111 0101   | 117         | u                           | 小写字母u    |
| 0111 0110   | 118         | v                           | 小写字母v    |
| 0111 0111   | 119         | w                           | 小写字母w    |
| 0111 1000   | 120         | x                           | 小写字母x    |
| 0111 1001   | 121         | y                           | 小写字母y    |
| 0111 1010   | 122         | z                           | 小写字母z    |
| 0111 1011   | 123         | {                           | 开花括号     |
| 0111 1100   | 124         | \|                          | 垂线         |
| 0111 1101   | 125         | }                           | 闭花括号     |
| 0111 1110   | 126         | ~                           | 波浪号       |
| 0111 1111   | 127         | DEL (delete)                | 删除         |

## References

1. 博客：[字符集与编码](https://www.zybuluo.com/xiaohaizi/note/897775)
1. stack overflow：[What's the difference between a character, a code point, a glyph and a grapheme?](https://stackoverflow.com/questions/27331819/whats-the-difference-between-a-character-a-code-point-a-glyph-and-a-grapheme)
1. 维基百科：[Byte order mark](https://en.wikipedia.org/wiki/Byte_order_mark)
1. stack overflow：[Why UTF-8 encoding doesn't need a Byte Order Mark?](https://stackoverflow.com/questions/63443051/why-utf-8-encoding-doesnt-need-a-byte-order-mark)