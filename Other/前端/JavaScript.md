# JavaScript

## 逻辑运算符

`||`

```javascript
var c = a() || b()
```

如果a()为true，直接短路，则表达式返回a()的值，**b()不执行**，如果a()为false，则执行b()并返回b()的值

`&&`

```javascript
var c = a() && b()
```

如果a()执行后为true，则执行b()并返回b()的值，如果a()执行后返回false，直接断路，则整个表达式返回a()的值，b()不执行

注意：

- 在js逻辑运算符中，**0,null,false,undefined,NaN**都会被判为false，其他为true

- &&优先级高于||

  ```javascript
  //结果为4
  alert(0&&3||1&&4)
  ```

## 模版字符串

```javascript
`${变量}`
```

ES6引入的模版字符串，用来解决字符串拼接问题

```javascript
var a = 1; console.log('一共有'+a+'个鸡蛋！')
//那么现在你只要
console.log(`一共有${a}个鸡蛋！`)
```

## 拓展运算符

`...`

它将一个数组转为用逗号分隔的参数序列

```javascript
var numbers = [4, 38];
add(...numbers) // 42
```

- 可用于合并数组

  ```javascript
  var arr1 = ['a', 'b'];
  var arr2 = ['c'];
  var arr3 = ['d', 'e'];
  // ES5 的合并数组
  arr1.concat(arr2, arr3);
  // [ 'a', 'b', 'c', 'd', 'e' ]
  // ES6 的合并数组
  [...arr1, ...arr2, ...arr3]
  // [ 'a', 'b', 'c', 'd', 'e' ]
  ```

- 还可以用于将字符串转换成数组

  ```javascript
  [...'hello']
  // [ "h", "e", "l", "l", "o" ]
  ```

## 计时器

setTimeout是指在指定时间后执行一次

setInterval以指定时间为周期循环执行

`setInterval()`的返回值是一个ID数字，可以奖这个ID传给`clearInterval()`以取消执行

**setTimeout是同步的还是异步的？**

```jsx
console.log('111');
setTimeout(()=>{
    console.log('222')
},1000);
console.log('333');
setTimeout(()=>{
    console.log('444')
},0);
console.log('555');
```

执行的结果为：

111 -> 333 -> 555 -> 444 -> 222

我们把需要执行的代码看成一个个任务，把任务分成两种，同步任务(sknchronous)，异步任务(asynchronous)。

 下面是它们的运行机制：

1. 所有同步任务都在主线程上，形成一个执行栈
2. 主线程之外还有一个“任务队列”，只要异步任务有了运行结果 ，就在任务队列中放一个事件
3. 当执行栈中所有的任务执行完了，就去看看任务队列中有没有需要执行的事件 ，如果有的话，就结束它们的等待，进入执行栈 ，开始执行。

所以上述代码的执行顺序为：

- 111进栈，执行完出栈
- 222进任务队列
- 333进栈，执行完出栈
- 444进任务队列
- 555进栈，执行完出栈
- 栈中执行完，开始任务队列，222执行，1秒后打印，444执行，立即打印

setTimeout()接受两个参数，第一个是回调函数，第二个是推迟执行的毫秒数。
**需要注意的是，setTimeout()只是将事件插入了"任务队列"，必须等到当前代码（执行栈）执行完，主线程才会去执行它指定的回调函数。要是当前代码耗时很长，有可能要等很久，所以并没有办法保证，回调函数一定会在setTimeout()指定的时间执行。**

综上所属，setTimeout是单线程，类似异步，但不是异步 。

## Array对象

**some()**

```javascript
let result = this._tableDataClone.some((item) => {
    return item.analysisFlag == 1
})
```

```javascript
array.some(function(currentValue,index,arr),thisValue)
```

`some()`用于检测数组中的元素是否满足指定条件（函数提供）;
`some()`方法会依次执行数组中的每一个元素：

- 如果有一个元素满足条件，则表达式返回true，剩余的元素不会再执行检测。
- 如果没有满足条件的元素，则返回false。

类似的方法还有every方法，他们的区别是：

只要数组中有一个元素满足条件，some() 就返回 true；只有当数组中的所有元素都满足条件时，every() 才返回 true。

**splice()**

```javascript
arrayObject.splice(index,howmany,item1,.....,itemX)
```

- index 规定添加，删除项目的位置
- howmany 必须，要删除的项目数量
- item1...X 可选，向数组中添加的新项目
- 返回值Array 包含被删除项目的新数组，如果有的话

实例：

- ```javascript
  arr.splice(2,0,"William")
  ```

  向数组中下标为2的位置添加一个“William”

- ```javascript
  arr.splice(2,1,"William")
  ```

  删除数组中下标为2的元素，并添加一个新元素来代替他

- ```javascript
  arr.splice(0, arr.length);
  ```

  清空数组

**findIndex()**

findIndex() 方法返回传入一个测试条件（函数）符合条件的数组**第一个**元素位置。

```javascript
var ages = [3, 10, 18, 20];
 
function checkAdult(age) {
    return age >= 18;
}
 
function myFunction() {
  	//结果为2
    alert(ages.findIndex(checkAdult));
}
```

## References

1. https://www.jianshu.com/p/4c377e876dac