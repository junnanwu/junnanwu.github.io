# Java常见系统方法

## System.exit方法

`java.lang.System.exit`方法终止正在运行的虚拟机，参数为一个状态码，0表示正常退出，非0代表不正常退出。

方法：

```java 
public static void exit(int status) {
    Runtime.getRuntime().exit(status);
}
```

故`System.exit(status);`的效果同`Runtime.getRuntime().exit(status);`

## addShutdownHook钩子函数

钩子函数`java.lang.Runtime.addShutdownHook`方法注册了一个关闭钩子函数，Java虚拟机在以下两种事件中会关闭：

- 程序正常终止，包括最后一个非守护线程停止或者停止函数被调用（例如，`System.exit()`）
- 程序收到终止响应，例如`^C`

方法：

```java
public void addShutdownHook(Thread hook)
```

测试代码：

```java
public class HookDO {
    HookDO(){
        Runtime.getRuntime().addShutdownHook(new Thread(() -> System.out.println("I am hook")));
    }
}

public class SystemTest {
    public static void main(String[] args) {
        //注册hook函数
        HookDO hookDO = new HookDO();
        System.out.println("hello");
        while (true){
			
        }
    }
}
```

- 去掉死循环，正常执行完毕退出

  ```
  hello
  I am hook
  
  Process finished with exit code 0
  ```

- `kill -2`

  ```
  hello
  I am hook
  
  Process finished with exit code 130 (interrupted by signal 2: SIGINT)
  ```

  成功退出，并执行了钩子函数

- `kill -3`

  ```
  hello
  2021-11-18 20:54:44
  Full thread dump Java HotSpot(TM) 64-Bit Server VM (25.211-b12 mixed mode):
  
  "Attach Listener" #12 daemon prio=9 os_prio=31 tid=0x00007fddb1073000 nid=0xa703 runnable [0x0000000000000000]
     java.lang.Thread.State: RUNNABLE
  ```

  并未退出，也未执行钩子函数

- `kill -9`

  ```
  hello
  
  Process finished with exit code 137 (interrupted by signal 9: SIGKILL)
  ```

  成功退出，但是未执行钩子函数

- `kill/kill -15`

  ```
  hello
  I am hook
  
  Process finished with exit code 143 (interrupted by signal 15: SIGTERM)
  ```

  成功退出，并执行钩子函数

- 点击idea停止运行

  ```
  hello
  I am hook
  
  Process finished with exit code 130 (interrupted by signal 2: SIGINT)
  ```

  与`kill -2`效果一样

- 代码中添加`System.exit(1);`

  ```
  hello
  I am hook
  
  Process finished with exit code 1
  ```

  正常退出，exit中的值为多少，退出的code就为多少

