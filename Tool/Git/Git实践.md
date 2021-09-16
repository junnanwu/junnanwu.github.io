# Git操作

![Git 下文件生命周期图。](Git%E5%AE%9E%E8%B7%B5_assets/lifecycle.png)

![Git%E5%AE%9E%E8%B7%B5_assets](Git%E5%AE%9E%E8%B7%B5_assets/20201013223057584.png)

## .gitignore

规范：

- 所有空行或者以 `#` 开头的行都会被 Git 忽略。

- 可以使用标准的 glob 模式匹配，它会递归地应用在整个工作区中。

  所谓的 glob 模式是指 shell 所使用的简化了的正则表达式。 星号（`*`）匹配零个或多个任意字符；`[abc]` 匹配任何一个列在方括号中的字符 （这个例子要么匹配一个 a，要么匹配一个 b，要么匹配一个 c）； 问号（`?`）只匹配一个任意字符；如果在方括号中使用短划线分隔两个字符， 表示所有在这两个字符范围内的都可以匹配（比如 `[0-9]` 表示匹配所有 0 到 9 的数字）。 使用两个星号（`**`）表示匹配任意中间目录，比如 `a/**/z` 可以匹配 `a/z` 、 `a/b/z` 或 `a/b/c/z` 等。

- 匹配模式可以以（`/`）开头防止递归。

  `logs/`：忽略当前路径下的logs目录，包含logs下的所有子目录和文件

  `/logs.txt`：忽略根目录下的logs.txt文件

- 匹配模式可以以（`/`）结尾指定目录。

- 要忽略指定模式以外的文件或目录，可以在模式前加上叹号（`!`）取反。

java开发通用版本：

```
# Compiled class file
*.class

# Eclipse
.project
.classpath
.settings/

# Intellij
*.ipr
*.iml
*.iws
.idea/

# Maven
target/

# Gradle
build
.gradle

# Log file
*.log
log/

# out
**/out/

# Mac
.DS_Store

# others
*.jar
*.war
*.zip
*.tar
*.tar.gz
*.pid
*.orig
temp/
```

## git config

参数：

- `--system`

  修改的是`/etc/gitconfig` 文件，这是系统上的每一个用户的通用配置

- `--global`

  修改的是`~/.gitconfig`，只针对当前用户

- `--local`

  修改的是当前本地仓库的配置文件及`.git/config`，`git config`默认使用的就是这个参数

举例：

- 安装完Git后，需要先设置用户名和密码

  ```
  $ git config --global user.name "John Doe"
  $ git config --global user.email johndoe@example.com
  ```

  如果使用了 `--global` 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息。 当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运行没有 `--global` 选项的命令来配置。

- 检查Git的配置

  ```
  git config --list
  ```

- 查看Git中该变量的原始值

  ```
  git config --show-origin user.name
  file:/Users/wujunnan/.gitconfig	wujunnan
  ```

## git init

- 初始化

  `git init`

  Git会为你创建master分支

## git clone

`git clone`的一般用法为`git clone <url>`

`<url>`部分支持四种协议：本地协议（Local），HTTP 协议，SSH（Secure Shell）协议及 Git 协议

```
$ git clone git://github.com/schacon/ticgit.git
```

1. 复制远程仓库`objects/`文件夹中的内容到本地仓库； (对应`Receiving objects`);

   注意：这里存在了objects/文件夹中的pack文件夹

   ```
   .
   ├── info
   └── pack
       ├── pack-1c3164bae6be1ec896f23c61c438bc32a8a0e8f3.idx
       └── pack-1c3164bae6be1ec896f23c61c438bc32a8a0e8f3.pack
   ```

2. 为所接收到的文件创建索引（对应`Resolving deltas`）;

3. 为所有的远程分支创建本地的跟踪分支,存储在`.git/refs/remote/xxx/`下；

4. 检测远程分支上当前的活跃分支（`.git/HEAD`文件中存储的内容）；

5. 在当前分支上执行`git pull`，保证当前分支和工作区与远程分支一致；

除此之外，`git`会自动在`.git/config`文件中写入部分内容，

```
[remote "origin"]
        url = git@git.in.zhihu.com:zhangwang/zhihu-lite.git
        fetch = +refs/heads/*:refs/remotes/origin/*
```

默认情况下会把clone的源仓库取名`origin`，在`.git/config`中存储其对应的地址，本地分支与远程分支的对应规则等。

- 如何添加ssh密钥

## git status

- 简介的形式显示

  `git status -s`

  - `??`表示新添加的未跟踪文件
  - `A`表示新添加的
  - `M`表示修改的

- 

## git add

## git commit

参数：

- `-a`

  Git 就会自动把所有**已经跟踪过**的文件暂存起来一并提交

## git diff

## git rm

要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。 可以用 `git rm` 命令完成此项工作

如果只是简单地从工作目录中手工删除文件，运行 `git status` 时就会在 “Changes not staged for commit” 部分（也就是 *未暂存清单*）看到

举例：

- 将文件只从暂存区删除

  ```
  git rm --cached README
  ```

## git mv

??

## git log

查看某一个分支的提交

- 查看日志的图形化版本

  `git log --graph`

- 将日志放置在一行显示

  `git log --oneline`



## 远程命令

如果我们是中途加入某个项目，往往我们的开发会建立在已有的仓库之上。如果使用`github`或者`gitlab`,像已有仓库提交代码的常见工作流是

1. `fork`一份主仓库的代码到自己的远程仓库；
2. `clone` 自己远程仓库代码到本地；
3. 添加主仓库为本地仓库的远程仓库，`git remote add ...`，便于之后保持本地仓库与主仓库同步`git pull`；
4. 在本地分支上完成开发，推送本地分支到个人远程仓库某分支`git push`；
5. 基于个人远程仓库的分支向主仓库对应分支提交`MR`,待`review`通过合并代码到主仓库；

![commit后_git文件夹里发生了什么](Git%E5%AE%9E%E8%B7%B5_assets/commit%E5%90%8E_git%E6%96%87%E4%BB%B6%E5%A4%B9%E9%87%8C%E5%8F%91%E7%94%9F%E4%BA%86%E4%BB%80%E4%B9%88.png)

- 

### git remote

`git remote` 为我们提供了管理远程仓库的途径。
对远程仓库的管理包括，查看，添加，移除，对远程分支的管理等等。

1. 查看远程仓库 `git remote`

   ```
   $ git remote
   origin
   
   # 添加 -v，可查看对应的链接
   $ git remote -v
   origin	https://github.com/schacon/ticgit (fetch)
   origin	https://github.com/schacon/ticgit (push)
   ```

2. 添加远程仓库 `git remote add <shortname> <url>`

   ```
   $ git remote add pb https://github.com/paulboone/ticgit
   $ git remote -v
   origin	https://github.com/schacon/ticgit (fetch)
   origin	https://github.com/schacon/ticgit (push)
   pb	https://github.com/paulboone/ticgit (fetch)
   pb	https://github.com/paulboone/ticgit (push)
   ```

3. 远程仓库重命名 `git remote rename`

   ```
   $ git remote rename pb paul
   $ git remote
   origin
   paul
   ```

4. 远程仓库的移除 `git remote rm <name>`

   ```
   $ git remote rm paul
   $ git remote
   origin
   ```

本地对远程仓库的记录存在于`.git/config`文件中，在`.git/config`中我们可以看到如下格式的内容：

```
# .git/config
[remote "github"]
	url = https://github.com/zhangwang1990/weixincrawler.git
	fetch = +refs/heads/*:refs/remotes/github/*
[remote "zhangwang"]
	url = https://github.com/zhangwang1990/weixincrawler.git
	fetch = +refs/heads/*:refs/remotes/zhangwang/*
```

- `[remote] "github"`:代表远程仓库的名称；
- `url`:代表远程仓库的地址
- `fetch`:代表远程仓库与本地仓库的对应规则，这里涉及到另外一个 Git 命令，`git fetch`

### git fetch

- 拉取所有远程仓库

  `git fetch --all`

- 删除版本库有，但是远程没有的分支

  `git fetch --prune`

  远程版本库有新增分支，git fetch会同步到本地，但是远程有删除分支，git fetch不会删除本地版本库的远程分支

- `git fetch --tags`包含`git fetch`吗

- `git fetch`

  会拉取当前项目所有分支的commit，如果当前项目有很多人参与，那么就会有很多分支，有时候是没有必要的。

我们继续看看`git fetch`是如何工作的：

```
# config中的配置[remote "origin"]    url = /home/demo/bare-repo/    fetch = +refs/heads/*:refs/remotes/origin/* #<remote-refs>:<local-refs> 远程的对应本地的存储位置
```

`fetch`的格式为`fetch = +<src>:<dst>`,其中

- `+`号是可选的，用来告诉 Git 即使在不能采用「快速向前合并」也要（强制）更新引用；
- `<src>`代表远程仓库中分支的位置；
- `<dst>` 远程分支对应的本地位置。

我们来看一个`git fetch`的实例，看看此命令是怎么作用于本地仓库的：

`git fetch origin`

1. 会在本地仓库中创建`.git/refs/remotes/origin`文件夹；
2. 会创建一个名为`.git/FETCH_HEAD`的特殊文件，其中记录着远程分支所指向的`commit` 对象；
3. 如果我们执行 `git fetch origin feature-branch`,Git并不会为我们创建一个对应远程分支的本地分支，但是会更新本地对应的远程分支的指向；
4. 如果我们再执行`git checkout feature-branch`, git 会基于记录在`.git/FETCH_HEA`中的内容新建本地分支，并在`.git/config`中添加如下内容，用以保证本地分支与远程分支`future-branch`的一致

![Git%E5%AE%9E%E8%B7%B5_assets](Git%E5%AE%9E%E8%B7%B5_assets/v2-686ae54f78ea69b6c00cc8b159cf7369_b.webp)





### git push

我们在本地某分支开发完成之后，会需要推送到远程仓库，这时候我们会执行如下代码：

`git push origin featureBranch:featureBranch`

此命令会帮我们在远程建立分支`featureBranch`,之所以要这样做的原因也在于上面定义的`fetch`模式。

因为引用规格（的格式）是 `<src>:<dst>`，所以其实会在远程仓库建立分支`featureBranch`,从这里我们也可以看出，分支确实是非常轻量级的。

此外，如果我们执行 `git push origin :topic`：，这里我们把 `<src>`留空，这意味着把远程版本库的 `topic` 分支定义为空值，也就说会删除对应的远程分支。

回到`git push`,我们从资源的角度看看发生了什么?

1. 从本地仓库的`.git/objects/`目录，上传到远程仓库的`/objects/`下;
2. 更新远程仓库的`refs/heads/master`内容，指向本地最新的commit;
3. 更新文件`.git/refs/remotes/delta/master`内容，指向最新的`commit`;

- 关于`git push`的默认行为

  当我们在本地新建了一个分支之后，在该分支上commit之后，如果直接执行`git push`命令，那么在2.0版本之前，可以push成功，但是2.0版本之后，则不能。

  因为在git的全局配置中有一个push属性，在2.0版本之前，这个属性是'matching'，2.0之后，这个属性变为了'simple'

  - matching，push所有本地和远程都存在的同名分支
  - upstream，push当前分支到它的upstream分支上
  - simple，simple和upstream是相似的，只有一点不同，simple必须保证本地分支和它的远程分支同名，否则会拒绝push操作
  - current，push当前分支到远程同名分支，如果远程同名分支不存在那么就会自动创建同名分支

  当我们把仓库A中某分支x的代码push到仓库B分支y，此时仓库B的这个分支y就叫做A中x分支的upstream，初次提交本地分支，例如`git push origin develop`操作，并不会定义当前本地分支的upstream分支，我们可以通过`git push --set-upstream origin develop`，关联本地develop分支的upstream分支，另一个更为简洁的方式是初次push时，加入-u参数，例如`git push -u origin develop`，这个操作在push的同时会指定当前分支的upstream。

  当我们选择current模式的时候，我们在第一次push的时候，就可以直接输入git push而不必显示指定远程分支。

  `git push -u origin mybranch1` 

  相当于

   `git push origin mybranch1` + `git branch --set-upstream-to=origin/mybranch1 mybranch1`

  git push的一般形式为 `git push <远程主机名> <本地分支名> : <远程分支名>`

  平时都是习惯省略远程分支名，如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系（即-u的含义）的远程分支（通常两者同名），如果该远程分支不存在，则会被新建。

  [Git push与pull的默认行为](https://segmentfault.com/a/1190000002783245)

- **关于 refs/for**

  `refs/for`的意义在于我们提交代码到服务器之后是需要经过code review之后才能进行merge的，而`refs/heads`不需要

- 将本地分支推到远程分支

  git push语法

  `git push <远程主机名> <本地分支名>:<远程分支名>`

  `git push origin master:master`

- 不写远程分支意味着什么

  `git push origin master` 将本地master分支推送到远程分支

  将本地分支推到与之存在追踪关系的远程分支

  如果该远程分支不存在呢？

- 如果省略本地分支名

  `git push origin ：refs/for/master` 

  则表示把空的分支推到远程分支，也就是删除远程分支，等同于下面的删除远程分支

- 删除远程分支

- `git push origin --delete master` 删除origin主机的master分支

- 将当前分支推送到origin主机对应分支

  `git push origin`

- 如果当前分支只有一个追踪分支，那么主机名都可以省略 

  `git push`

- 如果当前分支与多个主机存在追踪关系，那么这个时候**-u选项会**指定一个默认主机，这样后面就可以不加任何参数使用git push

  `git push -u origin master`

  上面命令将本地的master分支推动到origin分支上，后面就可以直接git push了

- 强制推送

  `git push --force origin`

- 推送所有分支

  `git push --all origin`



### git pull

此命令的通用格式为 `git pull <remote> <branch>`
它做了以下几件事情：

1. `git fetch <remote>`：下载最新的内容
2. 查询`.git/FETCH_HEAD`找到应该合并到的本地分支；
3. 如果满足要求，没有冲突，执行`git merge`

`git pull` 在大多数情况下它的含义是一个 `git fetch` 紧接着一个 `git merge` 命令。

![Git%E5%AE%9E%E8%B7%B5_assets](Git%E5%AE%9E%E8%B7%B5_assets/v2-1298832b975cf9cf0ad6c399ec5da32d_b.webp)

```
尽管 git fetch 可用于获取某个分支的远程信息，但我们也可以执行 git pull。git pull 实际上是两个命令合成了一个：git fetch 和 git merge。当我们从来源拉取修改时，我们首先是像 git fetch 那样取回所有数据，然后最新的修改会自动合并到本地分支中。
```

```
对拉取（pulling）这幅图有疑问，为什么在 master 没有新提交的时候，没有进行 fast foward 方式进行合并，而是创建了一个新的commit？
```

- git pull属性

  当我们执行git pull的时候，实际上是做了git fetch + git merge操作，fetch操作更新本地仓库，之后进行merge的时候，对git来说，如果没有指定当前分支的upstream，它并不会知道我们要合并到哪个分支到当前分支，所以我们需要设置当前分支的upstream

  ```
  git branch --set-upstream-to=origin/<branch> develop// 或者git push --set-upstream origin develop 
  ```

  实际上，如果我们没有指定upstream，git在merge时会访问git config中当前分支(develop)merge的默认配置，我们可以通过配置下面的内容指定某个分支的默认merge操作

  ```
  [branch "develop"]    remote = origin    merge = refs/heads/develop // [1]为什么不是refs/remotes/develop?
  ```

  或者通过command-line直接设置：

  ```
  git config branch.develop.merge refs/heads/develop
  ```

  这样当我们在develop分支git pull时，如果没有指定upstream分支，git将根据我们的config文件去`merge origin/develop`；如果指定了upstream分支，则会忽略config中的merge默认配置。

reference：

[Git-深入一点点](https://github.com/Val-Zhang/blogs/issues/9)

[手撕Git，告别盲目记忆](https://zhuanlan.zhihu.com/p/98679880)

[用动画图解 Git 的 10 大命令](https://zhuanlan.zhihu.com/p/147356242)

[图文详解如何利用Git+Github进行团队协作开发](https://zhuanlan.zhihu.com/p/23478654)

分支分类：

- master分支，即主分支。任何项目都必须有个这个分支。对项目进行tag或发布版本等操作，都必须在该分支上进行。
- develop分支，即开发分支，从master分支上检出。团队成员一般不会直接更改该分支，而是分别从该分支检出自己的feature分支，开发完成后将feature分支上的改动merge回develop分支。同时release分支由此分支检出。
- release分支，即发布分支，从develop分支上检出。该分支用作发版前的测试，可进行简单的bug修复。如果bug修复比较复杂，可merge回develop分支后由其他分支进行bug修复。此分支测试完成后，需要同时merge到master和develop分支上。
- feature分支，即功能分支，从develop分支上检出。团队成员中每个人都维护一个自己的feature分支，并进行开发工作，开发完成后将此分支merge回develop分支。此分支一般用来开发新功能或进行项目维护等。
- fix分支，即补丁分支，由develop分支检出，用作bug修复，bug修复完成需merge回develop分支，并将其删除。所以该分支属于临时性分支。
- hotfix分支，即热补丁分支。和fix分支的区别在于，该分支由master分支检出，进行线上版本的bug修复，修复完成后merge回master分支，并merge到develop分支上，merge完成后也可以将其删除，也属于临时性分支。







- 查看远程仓库

  `git remote -v`

- 更换远程仓库

  ```
  git remote origin set-url [url]
  ```

- 删除远程仓库

  ```
  git remote rm origin
  ```

  

  ```
  git remote add origin [url]
  ```

- 取回所有分支的更新

  `git fetch`

- 取回特定分支的更新

  `git fetch <远程主机名> <分支名>`

  例如，取回origin主机上的master分支

  `git fetch origin master`



## 其他

### pack文件

git原理：pack打包

git向磁盘中存储对象使用“松散（loose）”对象格式。比如文件a.txt第一个版本大小是10k，第二个版本向其中添加了一行代码，假如此时文件为10.1k，那么第二个版本会重新产生一个10.1k的文件，这样会很浪费磁盘空间，所以git会时不时地将多个这些对象打包成一个称为“包文件（packfile）”的二进制文件，以节省空间和提高效率。在手动执行git gc的时候，或者向远程推送的时候，都会进行打包的操作

执行git gc会主动出发git的打包机制，打包以后，会在 .git/objects/pack文件夹中产生两个文件，其他的文件都是在此次打包过程中，git认为不能是摇摆的文件，一般是没有被添加到任何提交记录中的文件

.pack 是包文件，这个文件包含了从文件系统中移除的所有对象的内容
.idx是索引文件，这个文件包含了包文件的偏移信息

reference：

[git原理：pack打包]( https://www.cnblogs.com/413xiaol/p/7828770.html)

[为什么你的 Git 仓库变得如此臃肿]( https://www.jianshu.com/p/7231b509c279)

### 关于空文件夹

问题：每次cherry-pick老师的初始化项目的时候，总是不显示idea给建出来的Java,resources,test/java等文件夹，这是因为每次提交的时候，这些空文件夹不会被提交

因为git空目录无法add。如果想add一个空目录，则需要在它下面创建一个文件，比如（.gitignore）

原因：

> 见 [Can_I_add_empty_directories]( https://git.wiki.kernel.org/index.php/GitFaq#Can_I_add_empty_directories.3F)
> Currently the design of the git index (staging area) only permits files to be listed, and nobody competent enough to make the change to allow empty directories has cared enough about this situation to remedy it.

解决方案：

现在的主流做法是在空文件夹里放置一个.gitkeep文件，加个.gitconfig文件在里面比较实用，也不会觉得突兀。

reference：

[大坑：git无法添加一个空的文件夹]( https://blog.csdn.net/u013467442/article/details/88806250)



标签

HEAD reflogs

[Git 之术与道 -- 索引](https://www.jianshu.com/p/6c06773d1311)



### 关于untracked files

请记住，你工作目录下的每一个文件都不外乎这两种状态：**已跟踪** 或 **未跟踪**

什么时候会出现未跟踪呢？

例如我们新建一个README文件，这时候我们git status就会显示这个文件是untracked的

如果我们确实想跟踪这个文件

就git add README，这时候就会显示Changes to be committed，这就说明是已暂存状态

```
$ git statusOn branch masterChanges to be committed:  (use "git restore --staged <file>..." to unstage)        modified:   READEME.md
```



#### git restore

```
注意这个git restore 意思是返回到未add的状态 即modified$ git restore --staged READEME.mdgit restore --staged [file] : 表示从暂存区将文件的状态修改成 unstage 状态。当然，也可以不指定确切的文件 ，例如：git restore --staged *.java 表示将所有暂存区的java文件恢复状态git restore --staged . 表示将当前目录所有暂存区文件恢复状态--staged 参数就是表示仅仅恢复暂存区的
```

问题总结接踵而至，如果我不们不止执行了 `add` 命令，还执行了 `commit` 命令。是不是也可以利用 `restore` 命令返回呢？答案是肯定的。

```
$ git restore -s HEAD~1 READEME.md  // 该命名表示将版本回退到当前快照的前一个版本
```

这时候和reset作用是一样的





删除untracked files

```
# 删除 untracked files$ git clean -f# 连 untracked 的目录也一起删掉$ git clean -fd# 连 gitignore 的untrack 文件/目录也一起删掉 （慎用，一般这个是用来删掉编译出来的 .o之类的文件用的）$ git clean -xfd# 在用上述 git clean 前，建议加上 -n 参数来先看看会删掉哪些文件，防止重要文件被误删$ git clean -nxfd$ git clean -nf$ git clean -nfd
```



## 实际操作





Your branch is ahead of 'origin/master' by 14 commits.

表示在你之前已经有14个commit而没有push到远程分支上

- git stutas的几种情况

  - 如果只在本地修改，还没有commit，那么用git status, 打印信息为：

    ```
    # On branch master# Changes not staged for commit:#   (use "git add <file>..." to update what will be committed)#   (use "git checkout -- <file>..." to discard changes in working directory)##    modified:   conf/gitolite.conf#no changes added to commit (use "git add" and/or "git commit -a")
    ```

  - commit之后，用git status，打印信息为：

    ```
    # On branch master# Your branch is ahead of 'origin/master' by 1 commit.#nothing to commit (working directory clean)
    ```

  - 说明没有文件需要commit，但是本地仓库 有一个commit ahead原来的master，就是本地仓库有一个提交，比远程仓库要先进一个commit。git push origin master之后，再用git staus，打印信息为：

    ```
    # On branch masternothing to commit (working directory clean)
    ```

  - 切换分支前想保存本地的更改，但是又不想commit

    - 点击工具栏的 VCS -> Git -> Stash Changes
    - 输入Message，然后点击 Create Stash
    - 切换分支
    - 想要复原，切回原来的分支，VCS -> Git -> UnStash Changes

    调用 git stash –keep-index。只会备份那些没有被add的文件

- 

### git branch

参数：

- `a`

  所有分支

- 

举例：

- 创建分支

  `git branch test_branch` 

- 查看分支(默认本地)

  `git branch`

- 查看所有分支

  `git branch -a`

- 删除分支

  `git branch -d test_branch`

- 删除远程分支

  `git push origin  --delete release/v2.9.0.3 `

- 查看所有本地分支，并包含更多的信息

  `git branch -vv`

### git checkout

- 切换分支

  `git checkout testing` 切换到testing分支

  `git checkout -b newtest` 创建并切换到newtest分支

- 远程先创建了分支，本地如何切换到本地对应的分支

  `git checkout feature/HDATA-335`

  当checkout后面的分支不存在，但是正好存在一个远程分支与这个分支相匹配，那么这个命令相当于

  `git checkout -b <branch> --track <remote>/<branch>`

  ```
  ➜  data-web-notice-backend git:(develop) ✗ git checkout feature/HDATA-335Branch 'feature/HDATA-335' set up to track remote branch 'feature/HDATA-335' from 'origin'.Switched to a new branch 'feature/HDATA-335'
  ```

- 切换到线上分支并且跟踪远程的分支

  `git checkout -b 本地新建的分支名 origin/线上分支名`

- 

### git fetch

当远程创建了新的分支，或者新的tag，或者分支有了新的提交，就需要更新到本地的版本库中

- 指定远程主机

  `git fetch <远程主机名>`

- 指定远程主机和分支

  `git fetct <远程主机名><分支名>`

- **拉取全部（常用）**

  `git fetch`

  > When no remote is specified, by default the `origin` remote will be used, unless there’s an upstream branch configured for the current branch.


### git pull



### git push

- 将当前分支推送到远程分支

  `git push`

  (默认的为simple模式，即将本地的当前分支推到远程的同名分支，不存在的话将报错)

  工作场景，一版都是先创建远程分支，然后创建本地同名分支，commit，最后push

### git merge

- 将某分支合并到当前分支

  `git merge 分支名`

### git tag

Git中，我们通过tag来标记版本。

注意tag与branch的区别：

- tag是对应的某次commit
- branch是一系列commit

举例：

- 拉取标签

  `git pull`和`git fetch`会自动获取设计分支中的所有标签

- 查看

  - 查看所有标签

    `git tag`

  - 查看部分标签

    `git tag -l 'v2.8*'`

  - 查看标签的散列值

    ` git  show-ref --tags  `

  - 查看某个提交都出现在哪个版本里

    （例如，想查看某次修复的bug都哪些版本包含了）

    `git tag --contains 4aa54ce `

- 打标签

  - 在当前分支的当前版本新建标签

    `git tag v1.0`

  - 在指定分支的当前版本新建标签

    `git tag v2.9.0.2  origin/release/v2.9.0.2`

  - 新建带有信息的分支

    `git tag -a v1.1.4 -m "tagging version 1.1.4"`

- 将标签推到远程仓库

  - 将本地v0.1.2标签提交到git服务器

    `git push v0.1.2` 

  - 将所有本地标签推送到远程仓库

    `git push –-tags` 

  > 注意，如果你创建标签时使用了`-m` 、`-a` 、`-s`或`-u`这些参数，Git会将在版本库中将标签作为一个独立对象来创建。该对象中会包含相关用户以及创建时间等信息。而要是如果没有使用这些选项，Git就只会创建一个所谓的轻量级标签，其中只有用于识别的提交散列。

- 切换到某个标签下

  `git checkout v0.21` 此时会指向打v0.21标签时的代码状态, (但现在处于一个空的分支上)

- 删除本地标签

  `git tag -d 标签名`

- 删除远程标签

  `git push origin :refs/tags/v2.3.1.1`

  >`tag <<tag>>` means the same as `refs/tags/<tag>:refs/tags/<tag>`.
  >
  >Pushing an empty `<src>` allows you to delete the `<dst>` ref from the remote repository.

- 按照时间顺序查看tag

  `git tag --sort=-creatordate`

  `git for-each-ref --sort=creatordate --format '%(refname)' refs/tags`

  包括具体时间：

  ```
  git for-each-ref --sort=creatordate --format '%(refname) %(creatordate)' refs/tags
  ```



问题记录：

`git tag后git push失败`

```
➜  data-ui git:(feature/HDATA-584) ✗ git merge origin/release/v2.9.1
Updating dccea066..b8457a13
Fast-forward
➜  data-ui git:(feature/HDATA-584) ✗ git tag v2.9.1  
➜  data-ui git:(feature/HDATA-584) ✗ git push v2.9.1
fatal: 'v2.9.1' does not appear to be a git repository
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
➜  data-ui git:(feature/HDATA-584) ✗ git push origin v2.9.1
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
```



### git reset



### git clean



## 场景

### 移除暂存区的文件

- IDEA

  暂未知

- Git

  `git rm --cached ESUtilTest.java `

  把文件从暂存区删除

  关于删除操作详见`git rm`

### 撤销未push的commit

- IDEA

commit未push的撤销

VSC => Git=> reset head

退回到上次commit：To Commit: HEAD^

退回到第二次提交之前：To Commit: HEAD~2

退回到指定commit版本：To Commit: id号

- Git

```
git reset HEAD~git reset --soft|--mixed|--hard <commit_id>
```

既能保证你原本的修改还在，又能撤销本次提交失误

mixed  会保留源码,只是将git commit和index 信息回退到了某个版本

soft  保留源码,只回退到commit信息到某个版本.不涉及index的回退,如果还需要提交,直接commit即可

index即暂存区，add后添加到的位置

hard  源码也会回退到某个版本,commit和index 都会回退到某个版本.(注意,这种方式是改变本地代码仓库源码)

注意：git revert是用一次新的commit来回滚之前的commit，git reset是直接删除指定的commit，看似达到的效果是一样的,其实完全不同

### checkout

当我们在一个分支上进行了修改，但是并没有进行Commit

当我们在checkout的时候，IDEA会弹出让我们选择如下

- Smart Checkout

  会把冲突的这部分代码带到目的分支

- Force Checkout

  当前分支所做的修改就会被删除

### 丢弃本地修改

​       