# 系列分享三：字符集



MySQL added this utf8mb4 code after 5.5.3, Mb4 is the most bytes 4



The limit of 17 planes is **due to UTF-16**, which can encode 220 code points (16 planes) as pairs of words, plus the BMP as a single word.

[Plane (Unicode)](https://en.wikipedia.org/wiki/Plane_(Unicode))







# Unicode在其他语言中的体现



JVM最早采用UTF-16编码，最开始是只有两个字节，足以表示当时Unicode中的所有符号，所以Java Char即是两个字节，但是随着Unicode中字符的增加，两个字节无法表示所有字符，UTF-16采用两个或四个字节的方式来表示一个字符，Java为了应对这种情况，考虑到向前兼容，Java采用一对Char来表示需要四个字符的情况。

所以，Java中的Char占用两个字节，有的字符占用两个Char。

https://www.zhihu.com/question/27562173