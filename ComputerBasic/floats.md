# 浮点数

当我们想要存储一个小数的时候，问题就在于如何存储小数点的位置，一种是采用定点位，即小数点就是的固定的。

定点数可以表示为：符号位 + 整数位 + 小数位，这样的话，小数点的存储就是固定在规定的整数位和小数位之间了，正是如此，整数位和小数位都是固定的，那么表示的范围就十分有限了。

与之对应的，是浮点数，即小数点是可以浮动，分别存储有效数字和指数位，现在大部分计算机浮点数都使用的IEEE 754标准。

## 相关名词

- 基数

  基数（radix）例如二进制浮点型的基数为2，十进制浮点型的基数为10。

- 阶码

  阶码（exponent）即浮点型中的指数位。

- 有效数字

  有效数字（significand），略。

- 尾数

  科学计数法中的有效数字称为尾数（mantissa）。

- 偏置

  偏置/偏移量（bias），一个使阶码都在正数范围的常量。

- 偏置指数

  偏置指数（biased exponent） 通过指数位+偏移量（移码）的方式，使要表示的数都为正数。

  这样的好处是，在进行比较大小的时候，不用像补码一样还需要关注符号位。

## 单精度浮点数

单精度浮点型（float）采用4个字节，32位来表示。

格式：
$$
V = (-1)^S×M×2^E
$$

- `S` 

  表示符号位（sign），由最高位31位表示，0表示正数，1表示负数。

- `E`

   表示偏置指数位，一个无符号整数，$E = e + bias$，规定偏置bias为127，由23位-30位表示，共8bit，-127和128被用作特殊值处理。

- `M`

  表示有效位，由于$1⩽m<2$，所以规定m在存储的时候，舍弃第一个1，指存储小数点后面的数字，由0位-22位表示，共23bit。

```
31      30-----23       22-------------------------0 
0       0000 0000    (1)0000 0000 0000 0000 0000 000  
符号位   指数位           有效位
S       exp             fraction
```

- 符号位

  1表示负数，0表示正数。

- 指数位

  分配8比特，如果有符号位，那么取值范围为`1111 1111` - `0111 1111`，即-128～127。

例如：

十进制`55.125`的浮点数存储

1.  [转换为二进制](#十进制转换二进制)

   $55.125_{10} = 11 0111.001_2$

2. 科学计数法表示

   $11 0111.001_2 = 1.10111001 × 2^5$

3. 有效位去除掉1

   10111001

4. 指数位 + 偏置127

   $5 + 127 = 132 = 1000 0100_2$

5. 按规则表示

   ```
   31   30-----23       22-------------------------0 
   0    0000 0000    (1)0000 0000 0000 0000 0000 000    
   0    1000 0100    (1)1011 1001 0000 0000 0000 000
   S    E                M
   ```

   `0b0100 0010 0101 1100 1000 0000 0000 0000`

   可以点下面的链接对浮点型进行转换：

   [IEEE 754 Calculator](http://weitz.de/ieee/)

### 表示范围与精度

float能表示的最大数为：

$1.1111 1111 1111 1111 1111 111  × 2^{127} ≈ 2^{128} ≈ 3.4 × 10^{38}$

(小数点后23个1)

float的精度为$\frac{1}{2^{23}}$。

（如何理解这个精度？）

## 双精度浮点数

双精度浮点型（double）采用8个字节，64位来表示，其中11bit存储指数位，52bit存储有效数字。

## 浮点型精度损失

上面的例子小数位`0.125`是可以精确的用二进制表示的，但是大部分的十进制小数是无法使用二进制精确表示的。

例如0.2：

$0.2_{10} = 0.00110..._2$

这种情况下，有效数字无限长，必然出现精度损失。

## 十进制转换二进制

以`55.125`转换为二进制为例：

**整数部分**

`55`转换位二进制

```
55 ÷ 2 = 27 ———— 1（余数）
27 ÷ 2 = 13 ———— 1
13 ÷ 2 = 6  ———— 1
6 ÷ 2 = 3 ———— 0
3 ÷ 2 = 1 ———— 1
1 ÷ 2 = 0 ———— 1
```

故`55`的十进制表示为`11 0111`（从下到上取）

**小数部分**

`0.125`转换为二进制

```
0.125 × 2 = 0.25 ———— 0 （整数部分）
0.25 × 2 = 0.5 ———— 0 
0.5 × 2 = 1 ———— 1
```

故`0.125`的二进制表示为`0.001`（从上到下取）

故`55.125`的二进制表示为`11 0111.001`

## 问题

### 为什么单精度浮点型的偏置为127

单精度的指数位被分配了8位，取值范围就是`0~255` (`0000 0000 ~1111 1111`)，但是在浮点型的阶码中，`0000 0000`与`1111 1111`被保留用作特殊情况，所以阶码可用的范围为`1~254`，那么选取1和254的中位数，127或128，以127为偏置，则阶码的取值范围为`-126-127`，以128为偏移量，则阶码的取值范围为`-127-126`，选择前者则可表示的范围更大，选择后者则精度更高，需要在两者之间衡量，IEEE标准选择了127，使浮点型的取值范围更大。

### 浮点数在数轴上是均匀分布的吗

由于浮点数就是小数点可以浮动的，在有效位确定的情况下，越靠近0则整数位越小，小数位越多，所以，越靠近0，可表示的浮点数越密集，越远离0，可表示的浮点数越稀疏，这是浮点数的特性决定的。

### 为什么不可精确表示的浮点数(例如十进制0.1)，却可以整取



## References
