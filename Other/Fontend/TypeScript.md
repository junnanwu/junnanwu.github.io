# TypeScript

## 变量

`!`的用法

在赋值的内容的后面使用，使null和undefined类型可以赋值给其他类型并通过编译

```typescript
// 由于x是可选的，因此parma.x的类型为number | undefined，无法传递给number类型的y，因此需要用x!
interface IDemo {
    x?: number
}

let y:number

const demo = (parma: IDemo) => {
    y = parma.x!
    return y
}
```

`?`的用法

- 表示可选参数
- 当使用A对象属性A.B时，如果无法确定A是否为空，则需要用A?.B，表示当A有值的时候才去访问B属性，没有值的时候就不去访问，如果不使用?则会报错

```typescript
// 由于函数参数可选，因此parma无法确定是否拥有，所以无法正常使用parma.x，使用parma?.x向编译器假设此时parma不为空且为IDemo类型，同时parma?.x无法保证非空，因此使用parma?.x!来保证了整体通过编译
interface IDemo {
    x: number
}

let y:number

const demo = (parma?: IDemo) => {
    y = parma?.x!
    console.log(parma?.x)   // 只是单纯调用属性时就无需!    
    return y
}
// 如果使用y = parma!.x!是会报错的，因为当parma为空时，是不拥有x属性的，会报找不到x的错误
```

但是?用法只能读操作而不能写操作，对一个可能为空的属性赋值是不会被编译通过的，此时还需用用到类型断言

```tsx
interface IDemo {
    x: number
}

// 编译报错，不能赋值给可选属性
const demo = (parma?: IDemo) => {
    parma?.x = 1    
}
    
// 使用类型断言  
const demo = (parma?: IDemo) => {
    let _parma = parma as IDemo
    _parma.x = 1
}
```

数组类型

有两种方式可以定义数组

- 方式一

  ```ts
  let list: number[] = [1, 2, 3];
  ```

- 方式二

  ```ts
  let list: Array<number> = [1, 2, 3];
  ```

## 接口

初始函数：

```ts
function printLabel(labelledObj: { label: string }) {
  console.log(labelledObj.label);
}
```

用接口描述：必须包含一个`label`属性且类型为`string`

```ts
interface LabelledValue {
  label: string;
}

function printLabel(labelledObj: LabelledValue) {
  console.log(labelledObj.label);
}
```

`LabelledValue`接口就好比一个名字，用来描述上面例子里的要求。 它代表了有一个 `label`属性且类型为`string`的对象。

接口的属性里面不全是必需的，可以在可选属性名字定义的后面加一个`?`

- 可选属性的好处之一是可以对可能存在的属性进行预定义
- 好处之二是可以捕获引用了不存在的属性时的错误。

```ts
interface SquareConfig {
  color?: string;
  width?: number;
}

function createSquare(config: SquareConfig): {color: string; area: number} {
}
```

## 类

```ts
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
    greet() {
        return "Hello, " + this.greeting;
    }
}

let greeter = new Greeter("world");
```

TypeScript里，成员都默认为 `public`

## 函数

```js
// Named function
function add(x, y) {
    return x + y;
}

// Anonymous function
let myAdd = function(x, y) { return x + y; };
```

TS改写

```ts
function add(x: number, y: number): number {
    return x + y;
}

let myAdd = function(x: number, y: number): number { return x + y; };
```

定义函数的时候也可以使用`?`实现可选参数

```ts
function buildName(firstName: string, lastName?: string) {
    if (lastName)
        return firstName + " " + lastName;
    else
        return firstName;
}

let result1 = buildName("Bob");  // works correctly now
let result2 = buildName("Bob", "Adams", "Sr.");  // error, too many parameters
let result3 = buildName("Bob", "Adams");  // ah, just right
```

可选参数必须跟在必须参数后面。

### 默认值

在TypeScript里，我们也可以为参数提供一个默认值当用户没有传递这个参数或传递的值是`undefined`时。 它们叫做有默认初始化值的参数。

```ts
function buildName(firstName: string, lastName = "Smith") {
    return firstName + " " + lastName;
}

let result1 = buildName("Bob");                  // works correctly now, returns "Bob Smith"
let result2 = buildName("Bob", undefined);       // still works, also returns "Bob Smith"
```

## 模块

模块在其自身的作用域里执行，而不是在全局作用域里；这意味着定义在一个模块里的变量，函数，类等等在模块外部是不可见的，除非你明确地使用`export`形式之一导出它们。

相反，如果想使用其它模块导出的变量，函数，类，接口等的时候，你必须要导入它们，可以使用 `import`形式之一。

### 导出声明

任何声明（比如变量，函数，类，类型别名或接口）都能够通过添加`export`关键字来导出。

### 导入声明

导入一个模块中的某个导出内容

```ts
import { ZipCodeValidator } from "./ZipCodeValidator";
let myValidator = new ZipCodeValidator();
```

可以对导入内容重命名

```ts
import { ZipCodeValidator as ZCV } from "./ZipCodeValidator";
let myValidator = new ZCV();
```

将整个模块导入到一个变量，并通过它来访问模块的导出部分

```ts
import * as validator from "./ZipCodeValidator";
let myValidator = new validator.ZipCodeValidator();
```

#### 默认导出

每个模块都可以有一个`default`导出。 默认导出使用 `default`关键字标记；并且一个模块只能够有一个`default`导出。 需要使用一种特殊的导入形式来导入 `default`导出。

类和函数声明可以直接被标记为默认导出。 标记为默认导出的类和函数的名字是可以省略的。

#### 类

ZipCodeValidator.ts

```ts
export default class ZipCodeValidator {
    static numberRegexp = /^[0-9]+$/;
    isAcceptable(s: string) {
        return s.length === 5 && ZipCodeValidator.numberRegexp.test(s);
    }
}
```

Test.ts

```ts
import validator from "./ZipCodeValidator";

let myValidator = new validator();
```

#### 函数

StaticZipCodeValidator.ts

```ts
const numberRegexp = /^[0-9]+$/;

export default function (s: string) {
    return s.length === 5 && numberRegexp.test(s);
}
```

Test.ts

```ts
import validate from "./StaticZipCodeValidator";

let strings = ["Hello", "98052", "101"];

// Use function validate
strings.forEach(s => {
  console.log(`"${s}" ${validate(s) ? " matches" : " does not match"}`);
});
```

#### 值

`default`导出也可以是一个值

OneTwoThree.ts

```ts
export default "123";
```

Log.ts

```ts
import num from "./OneTwoThree";

console.log(num); // "123"
```

