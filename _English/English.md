# English

### 5/23

- delegate 代理

  Examples are provided at the bottom of the file for collections of related commands, which can then be delegated out to particular users or groups.

- mount 挂载

  Allows members of the users group to mount and unmount the cdrom as root.

- drop-in ？

  Read drop-in files from /etc/sudoers.d

### 5/26

- semantic 语义的

  semantic analysis exception

- ambiguous 模糊不清的

  column reference b.three_m_n_x_wlf is ambiguous

### 5/28

- indent 缩进

  Tabs and Indents

- semicolon 分号

  New line around semicolon


### 6/6

```
String[] split(String regex, int limit)
```

Splits this string around matches of the given regular expression.

The array returned by this method contains each substring of this string that **is terminated by** another substring that matches the given expression or is terminated by the end of the string. The substrings in the array are in the order in which they occur in this string. If the expression does not match any part of the input then the resulting array has just one element, **namely** this string.
When there is a **positive-width** match at the beginning of this string then an empty **leading** substring is included at the beginning of the resulting array. A zero-width match at the beginning however never produces such empty leading substring.

The limit parameter controls the number of times the pattern is applied and therefore affects the length of the resulting array. If the limit n is greater than zero then the pattern will be applied at most n - 1 times, the array's length will be no greater than n, and the array's last **entry** will contain all input beyond the last matched **delimiter**. If n is non-positive then the pattern will be applied as many times as possible and the array can have any length. If n is zero then the pattern will be applied as many times as possible, the array can have any length, and **trailing** empty strings will be discarded.

这个方法根据正则表达式的匹配分隔字符串。

这个方法返回的数组包含这个字符串的每一个子字符串，这个子字符串终止于另一个符合给定表达式的子字符串或终止于这个字符串的结尾。数组中子字符串的顺序就是他们在字符串中出现的顺序。如果给定的正则表达式没有匹配到输入的字符串的任何片段，那么结果数组就只有一个元素，那就是这个字符串。如果在字符串开始有一个宽度大于0的匹配，那么在结果数组的开始就会有一个空的子字符串。如果这个匹配宽度为0，那么就不会有这样的字符串产生。

limit参数控制了模式将会被应用多少次，并且因此影响结果数组的长度。如果参数n大于0，那么这个匹配会被应用最多n-1次，数组长度不会超过n，并且数组的最后一项将会包含最后一个匹配到的界定符之后的所有字符串，如果n小于0，那么此模式将会尽可能多的进行匹配，如果n等于0，那么此模式也会尽可能多的进行匹配，数组将有可能是任意长度，并且后面的空字符串将会被丢弃。

### 6/7

- **Sign-off** commit

- Before Commit

  - Reformat code
  - **Rearrange** code
  - **Optimize** imports
  - Perform code analysis
  - Cleanup

- timestamp

  时间戳 

  - stamp邮票, 印记, 标志

### 6/24

- shelve 搁置

  IntelliJ IDEA can slelvet the Changes

- shelf 架子

  Remove successfully applied files from the shelf

### 7/12

- overhead

  This reduces overhead and can greatly increase indexing speed.

  这将会减少开销并且极大的提高了索引速度。

- delimiters

  分隔符

  Because this format uses literal `\n`'s as delimiters

- optimal

  最优秀的

  There is no "correct" number of actions to perform in a single bulk request. Experiment with different settings to find the optimal size for your particular workload

  在执行一个批请求的时候，没有一个正确的操作数。对于特定的工作量，你应该通过测试不同的配置来找到最合适的设置

-  strive to do

  Client libraries using this protocol should try and strive to do something similar on the client side, and reduce buffering as much as possible.

- clauses

  子句

  It is built using one or more boolean **clauses**, each clause with a **typed** **occurrence**. 

  它是由一个或多个布尔子句构成的，每个子句都对应了一个类型的事件

### 7/13

- alphabetically

  Ordering the buckets alphabetically by their terms in an ascending manner

  将bucket按照terms字母的升序方式进行排序


