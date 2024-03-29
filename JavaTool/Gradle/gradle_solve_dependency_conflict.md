# 如何处理依赖冲突（以Gradle为例）

## 什么是依赖冲突



## 什么是依赖传递

依赖分为两种，一种是直接依赖，也就是你的项目中直接声明的依赖，一种是传递依赖，也就是你的直接依赖所需要的依赖。

由于传递依赖并不那么容易被观察到，而且很容易产生问题，所以Gradle提供了依赖约束（dependecy constraints）。



## 不同工具如何处理依赖冲突

### Maven

Maven根据就近原则，选择路径最短的那个依赖，那么直接依赖就优先于传递依赖，如果不同依赖的路径长度相同，那么选择距离最近的依赖。

Maven就近原则的缺点就是太依赖顺序，如果我们升级了依赖的版本，结果新版本的内部依赖顺序改变了，那么我们已经处理好的依赖冲突就有可能失效了。

### Gradle

Gradle会考虑所有依赖，在满足依赖约束的前提下选择最高版本。





## References

1. https://docs.gradle.org/current/userguide/dependency_resolution.html





