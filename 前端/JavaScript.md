如何将文本中所有的换行符替换为`<br>`

```
this.submitForm.content.replace(/\n/g,"<br/>");
```

1. `/pattern/`是正则表达式的界定符，里面的内容(pattern)是要匹配的内容，就是本例中的`/\n/`
2. `\`是转义的意思，`\n/`代表的是`/n`换行字符
3. 如果直接用`str.replace(/\n/g, '<br/>')`只会替换第一个匹配的字符. 而`str.replace(/\n/g, '<br/>')`则可以替换掉全部匹配的字符（g为全局标志）。

