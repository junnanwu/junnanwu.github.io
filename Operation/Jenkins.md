# Jenkins

## Jenkins是什么？





## Jenkins自动构建项目的类型

- 自由风格软件项目（Preestyle Project）

  Jenkins定义了一个应用的生命周期，你只需要在每个生命周期使用适当的插件即可。

- Maven项目（Maven Project）

- 流水线项目（Pipeline Project）

  使用流水线项目你可以自定义应用的整个生命周期，非常灵活。



## 自由风格项目

我们生产中实际使用的就是自由风格的方式，能实现简单的自动部署。





```sh
#/bin/bash
# /data/data-web里面存放的是所有源码
cd /data/data-web
# 从远程拉取代码并合并本地的版本
git pull
echo 'checkout $1'
# 切换到$1分支 并与远程分支关联起来
git checkout -b $1 origin/$1
git pull
echo 'starting bootJar...'
# 打开jar包目录
cd data-backend
# ??
gradle :backend:bootJar
echo 'bootJar finished...'
# 删除之前的对应进程
ps -ef|grep java|grep data-web| awk '{print $2}'|xargs --no-run-if-empty kill -9
sleep 5
echo 'kill old process,start new process'cho 'kill old process,start new process'
#切换回develp分支，删除$1分支
git checkout develop
git branch -D $1
#删除原来的jar包
rm -f /data/data-backend/data-web-1.0-SNAPSHOT.jar
#将build里面生成的jar包复制到对应文件夹中
cp backend/build/libs/backend-1.0-SNAPSHOT.jar /data/data-backend/data-web-1.0-SNAPSHOT.jar
cd /data/data-backend
echo 'starting process......'
#调用执行jar脚本
sh -ex execute.sh >nohup.out 2>&1 &
```

hxd-data-api-deploy.sh

```shell
#/bin/bash
cd /data/hxd-web
git pull
echo 'checkout $1'
git checkout -b $1 origin/$1
git pull
echo 'starting bootJar...'
gradle :hxd-data-api:data-api-application:clean :hxd-data-api:data-api-application:bootJar
echo 'bootJar finished...'
ps -ef|grep java|grep hxd-data-api| awk '{print $2}'|xargs --no-run-if-empty kill -9
sleep 5
echo 'kill old process,start new process'cho 'kill old process,start new process'

git checkout develop
git branch -D $1

cd /data/hxd-data-api
rm -f hxd-data-api-1.0-SNAPSHOT.jar
cp /data/hxd-web/hxd-data-api/data-api-application/build/libs/data-api-application-1.0-SNAPSHOT.jar hxd-data-api-1.0-SNAPSHOT.jar
echo 'starting process......'
sh -ex execute.sh >nohup.out 2>&1 &
```

目标shell

```
#/bin/bash
cd /data/data-openapi-repository
git pull
echo 'checkout $1'
git checkout -b $1 origin/$1
git pull
echo 'starting bootJar...'

gradle bootJar

echo 'bootJar finished...'
ps -ef|grep java|grep data-openapi| awk '{print $2}'|xargs --no-run-if-empty kill -9
sleep 5
echo 'kill old process,start new process'cho 'kill old process,start new process'

git checkout develop
git branch -D $1

rm -f /data/data-openapi/data-openapi-1.0-SNAPSHOT.jar
cp /data/data-openapi-repository/build/libs/data-openapi-1.0-SNAPSHOT.jar /data/data-openapi/data-openapi-1.0-SNAPSHOT.jar
cd /data/data-openapi
echo 'starting process......'
sh -ex execute.sh >nohup.out 2>&1 &
```

问题：

gradle的bootJar是干啥的

问题2:

```
[zhuds@app-zlfzb-jr data-openapi]$ git pull
Password for 'https://wujunnan@Kungeek.com@zlfzb.kungeek.com':
remote: Counting objects: 5, done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 5 (delta 2), reused 0 (delta 0)
Unpacking objects: 100% (5/5), done.
来自 https://zlfzb.kungeek.com/bitbucket/scm/hszdat/data-openapi
   8e8017b..7cc79f4  wujunnan   -> origin/wujunnan
Already up-to-date.
[zhuds@app-zlfzb-jr data-openapi]$ git branch
* master
[zhuds@app-zlfzb-jr data-openapi]$
```



## Reference
