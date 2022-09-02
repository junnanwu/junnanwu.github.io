# 装配Bean

- @service修饰两个相同的类，则会报错，原因如下：

  spring会将类名的第一个字母转换成小写，作为bean的名称，比如：testService1，而默认情况下bean名称必须是唯一的。

- @Autowired装配顺序

  





## Reference

1. https://www.zhihu.com/question/39356740/answer/1907479772