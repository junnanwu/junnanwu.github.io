# 泛型

## 为什么会有泛型

Java 5引入了泛型程序设计 (generic programming) ，意味着编写的代码可以对多种不同类型的对象重用。

用ArrayList举例子，要想实现ArrayList里面装任何类型，可以使用Object，实际上，在泛型出现之前，ArrayList也确实是这样设计的。

```java
public class ArrayList{
    private Object[] elementData;
    ...
    public Object get(int i){...}
    public void add(Object o)
}
```

这种方式存在两个问题：

- **当取一个值时必须进行强制转换**

- **没有错误检查，可以向数组中添加任何类的值**

  这样就会造成编译和运行的时候都没有错误，但是在某个地方`get()`后进行强制转换的时候产生错误

基于这种情况，为了在编辑阶段就能解决这些问题，Java 5中引入了泛型。

泛型提供了类型参数（type parameter）

```java
ArrayList<String> names = new ArrayList<>();
```

（菱形语法可以省略构造器中的类型参数，省略的类型可以从变量的类型推断得出。

带来的好处：

- 编译器就会充分利用这个信息，调用get的时候，不需要进行强制类型转换，**编译器知道返回类型是String而不是Object**

  ```java
  String name = names.get(0);
  ```

- 另一方面，编译器还知道add方法里面有一个类型为String的参数，它会**进行检查，防止你插入错误类型的对象**，让你的程序更易读，也更安全，当你add其他类型的时候，是无法通过编译的，编译错误总比运行时出现类型转的异常好的多。

## 什么时候使用泛型

如果代码中原本要使用**大量的通用类型**（Object或Comparable）的强制类型转换，这些代码适合使用泛型。

**已有范性类不要再使用原生态类型**

原生态类型，即没有范型参数的范性，例如`List`，不应该再使用，它的存在是为了兼容旧的Java代码。

## 泛型应用

泛型主要分为两种

- 泛型类/泛型接口

  实例化的时候指明泛型的具体类型

- 泛型方法

  在调用方法的时候指定泛型的指定类型

### 泛型类

类型变量放在类名的后面

```java
public class Generic<T>{ 
    private T key;

    public Generic(T key) {
        this.key = key;
    }

    public T getKey(){
        return key;
    }
}
```

典型的就是各种容器类

类型变量在整个类定义中用于指定方法的返回类型以及字段和局部变量的类型。

Java类库的命名方式：

- E表示集合的元素类型
- K，V分别表示表的键和值的类型
- T（必要时还可以使用相邻的字母U和S）表示任意类型

### 泛型接口

泛型接口与泛型类基本相同，通常被用到各种类的生产器中

```java
public interface Generator<T> {
    public T next();
}
```

当实现泛型的类，未传入泛型参数的时候，该类也需要生命该泛型参数

```java
class FruitGenerator<T> implements Generator<T>{
    @Override
    public T next() {
        return null;
    }
}
```

当实现接口，传入泛型实参时，该类不需要再指定泛型参数

```java
public class FruitGenerator implements Generator<String> {

    private String[] fruits = new String[]{"Apple", "Banana", "Pear"};

    @Override
    public String next() {
        Random rand = new Random();
        return fruits[rand.nextInt(3)];
    }
}
```

### 泛型方法

**泛型变量放在修饰符的后面，返回类型的前面**，泛型方法可以定义在普通类中，也可以定义在泛型类中定义：

```java
class ArrayAlg {
    public static <T> T getMlddle(T...a){
        return a[a.length / 2]; 
    }
}
```

当调用一个泛型方法对的时候，可以把具体类型包围在尖括号中，放在方法名前面：

```java
String middle = ArrayAlg.<String>getMiddle("John","Q","Public");
```

这种情况下，可以省略`<String>`类型参数，因为编译器会将参数的类型与范性进行匹配，推断出T一定是`String`，所以，可以简化为：

```java
String middle = ArrayAlg.getMiddle("John","Q","Public");
```

## 通配符类型

**带有子类型限定的通配符允许你读取一个泛型对象，而带有超类型限定的通配符允许你写入一个泛型对象。**

**通配符的子类型限定**

假设我们想写一个min方法，但是不能传入任意类型，我们希望传入的参数都拥有一个`compareTo()`方法，那么我们可以使用extends关键字来限定T：

```java
pulic static <T extends Comparable> T min(T[] a) ...
```

一个类型变量可以有多个限定，如果有一个类限定，那么类限定必须放在接口限定前面，例如:

```java
T extends Comparable & Serializable
```

再例如：

编写一个打印员工的方法：

```java
public static void printBuddies(Pair<Employee> p){
	Employee first = p.getFirst();
	Employee second = p.getSecond();
	System.out.println(first.getName()+ "and" + second.getName() + "are buddies.")
}
```

但是，但是上述方法有个问题就是，不能将`Pair<Manager>`传递给这个方法，所以为了解决这个问题，可以使用`Pair<? extends Employee>`，如下：

```java
public static void printBuddies(Pair<? extends Employee> p)
```

`Pair<? extends Employee>`的方法如下：

```java
? extends Employee getFrist();
void setFirst(? extends Employee);
```

`getFrist`方法可以正常调用，但是`setFirst`方法却不能调用，编译器只知道Employee的某个子类型，但是不知道具体是什么类型，它决绝传递任何特定的类型，毕竟`?`不匹配。

**通配符的超类型限定**

通配符限定还可以指定一个超类型限定（supertype bound）如下：

```java
? super Manager
```

这个通配符限制为Manager的所有父类，与上述相反，超类型限定**可以为方法提供参数，但是不能使用返回值**。

```java
//非Java语法
void setFirst(? super Manager)
? super Manager getFirst()
```

编译器无法知道setFirst方法的具体类型，因此不能接受参数类型为Employee或Object的方法调用。只能传递Manager类型的对象，如果调用getFirst，不能保证返回对象的类型，只能给它赋Object。

### 无限定通配符

`List<?>`

关于`List<?>`和`List<Object>`有什么区别？

- `List<?>`是指某个确定的范性，但我不确定是哪一个，即某个类型的集合，可以传入任何范性，例如`List<Object>`、`List<String>`

- `List<Object>`是指要求范型内部类型为Object，不接受`List<String>`

  对于任意两个不同类型的类型Type1和Type2，`List<Type1>`既不是`List<Type2>`的子类型，也不是`List<Type2>`的超类型。

## 泛型与虚拟机

虚拟机在编译过程中，正确检查类型结果后，会对泛型进行擦除（erased），例如**对于无限定泛型，就会被替换为Object**（也就是说T会被替换为Object，就像Java语言引入范型之前的实现的一样）

```java
List<String> stringArrayList = new ArrayList<String>();
List<Integer> integerArrayList = new ArrayList<Integer>();

Class classStringArrayList = stringArrayList.getClass();
Class classIntegerArrayList = integerArrayList.getClass();

//上面两种类型是相同的
if(classStringArrayList.equals(classIntegerArrayList)){
    System.out.println("类型相同");
}
```

如果是限定类型范型，例如：

`<T extends Comparable & Serializable>`

转换为：

`Comparable`

在存取的时候，也会加入强制类型转换，例如：

```java
Pair<Empoyee> buddies = ...;
Employee buddy = buddies.getFirst();
```

`getFirst`擦除类型后的返回类型是Object。编译器自动插入转换到Employee的强制类型转换，也就是说，编译器把这个方法调用转换为两条虚拟机指令：

- 对原始`Pair.getFirst`的调用
- 将返回的Object类型强制转换为Employee类型

## 注意

- 不能用基本类型代替类型参数，原因就是当擦除泛型之后，泛型被替换为Object，而Object类型不能接收基本类型。

  即没有`Pair<double>`，只有`Pair<Double>`。

  运行时类型查询只适用于原始类型

  例如：

  ```java
  if (a instanceof Pair<String>)
  if (a instanceof Pair<T>)
  ```

  仅仅测试a是否是任意类型的一个Pair。

  同样道理，getClass方法总是返回原是类型：

  ```java
  Pair<String> stringPair = ...;
  Pair<Employee> employeePair = ...;
  //true 二者都返回Pair.class
  if (stringPair.getClass() == employeePair.getClass())
  ```

- 不能创建参数化类型的数组

  使用`ArrayList<>`来代替

- 不能实例化类型变量

  不能`new T()`

  例如：下列操作是非法的：

  ```java
  public Pair(){
  	first = new T();
  	second = new T();
  } //ERROR
  ```

  类型擦除将 T 变成Object， 而你肯定不希望调用`new Object()`

  在Java8之后，可以提供一个构造器表达式：

  ```java
  Pair<String> p = Pair.makePair(String::new);
  
  public static <T> Pair<T> makePair(Supplier<T> constr){
      return new Pair<>(contr.get(),contr.get());
  }
  ```

  如果使用传统的方法，那么就是使用反射了。

  但是不能通过调用下面方法：

  ```java
  flrst = T.class.getConstructor().newInstance(); // ERROR
  ```

  表达式`T. class`是不合法的，因为它会被擦除为`Object.class`，这个时候，**需要传入一个Class对象**

  ```java
  public static <T> Pair<T> makePair(Class<T> cl){
  	try{
  		return new Pair<>(cl.getConstructor().newInstance(),
                            cl.getConstructor().newInstance());
  	}catch(Exception e){
  		return null;
  	}
  }
  ```

  同过如下方法调用：

  ```java
  Pair<String> p = Pair.makePair(String.class);
  ```

- 不能使用带有泛型变量的静态字段和方法



## 泛型生产应用



## References

1. 《Java核心技术卷1》
2. 《Effective Java》
3. https://blog.csdn.net/s10461/article/details/53941091

