# feign源码解析

- 下面即是Feign客户端

  ![image-20210807215604829](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20210807215604829.png)

  Feign在启动的时候，会ConsumerService接口创建一个代理类，并且注册到IOC容器，`getUserById()`这个抽象方法用于完成上面的`"/user/getUserById/{id}"`http请求

- 创建动态代理类的时候，需要传入一个`InvocationHandler`，如下：

  `static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h)`

  这个`InvocationHandler`接口里面有如下方法：

  `Object invoke(Object proxy, Method method, Object[] args)`

- `getUserById()`方法走进来，进入默认的FeignInvocationHandler的invoke方法，其中有一个非常重要Map类型成员 dispatch 映射，保存着远程接口方法到MethodHandler方法处理器的映射，远程映射接口中有几个方法，这里面就有几个映射对。

  - dispatch中的key为远程接口的方法名：

    ```
    public abstract net.wujunnan.springclouddemo.pojo.User net.wujunnan.springcloudconsumerservice02.service.ConsumerService.getUserById(java.lang.Integer)
    ```

  - value

    ```
    SynchronousMethodHandler@9327
    ```

    > Synchronous:同步的

  ![image-20201218122059531](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20201218122059531.png)

  总之，重点就在最后一行，这个invoke每个方法都会被传入，找到对应的MethodHandler

- MethodHandler为Feign定义的一个内部接口，里面有一个`invoke()`方法，主要职责是完成实际远程URL请求，然后返回解码后的远程URL的响应结果。

  ![image-20201218123415870](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20201218123415870.png)

  SynchronousMethodHandler是MethodHandler的一个实现类

  ![image-20201218124531125](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20201218124531125.png)

- SynchronousMethodHandler的invoke(…)方法，调用了自己的executeAndDecode(…) 请求执行和结果解码方法。

  ![image-20201218132204044](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20201218132204044.png)

  这个Client为LoadBalancerFeignClient，这是内部使用了负载均衡的实现类，Client还有默认的实现类，Client.Default，使用了LoadBalancerFeignClient发起请求之后，得到了response，通过decoder的decode方法，将response转换为对象。

  ![image-20201218134352169](feign%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90_assets/image-20201218134352169.png)

  这个metadata是我们定义的方法，这里获取到这个方法的返回值类型，然后进行转换

- 上面使用的是，Decoder接口的decoder方法，实现类是OptionalDecoder()这是一个包装类，里面是ResponseEntityDecoder，这个里面又是SpringDecoder...最终将respond转换成对应方法的返回类型。

所以综上，消费端的service接口中的方法是不需要一一映射的，也就说方法名并无要求，因为我们只取了方法的参数和返回值类型，方法的参数是用于拼接URL最后的参数，返回值类型是用于将返回的response进行转换的。

Reference：[Feign原理 （图解）](https://www.cnblogs.com/crazymakercircle/p/11965726.html)