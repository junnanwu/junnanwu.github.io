# Git原理

## Git引用

Git引用，也称references/refs，用来代替commit的hash值。

git references存储在`.git/refs`中，存储了所有引用：

```
refs
├── heads
│   ├── develop
│   ├── feature
│   │   ├── HDATA-1104
│   │   └── HDATA-1197
│   ├── hotfix
│   │   └── HDATA-1255
│   └── master
├── remotes
│   └── origin
│       ├── HEAD
│       ├── develop
│       ├── feature
│       │   ├── HDATA-1104
│       │   └── HDATA-1197
│       ├── hotfix
│       │   └── HDATA-1255
│       └── release
│           ├── v1.0.1
│           ├── v1.0.2
│           └── v1.0.3
└── tags
    ├── v1.0.1
    └── v1.0.2
```

每个引用里面都是该引用对应的hash值：

```
$ cat .git/refs/heads/feature/HDATA-279
18bb23ccdf5d05929e749e250f57ab412a826d36
```

注意：

- 其中的tags为轻量级标签，里面仅记录对应的commit的hash值
- 当你把引用传给Git命令的时候，可以使用引用的全称，也可以使用缩写去让Git匹配符合的引用

### 相对引用

可以通过`~`字符来引用相对于另一个commit的commit，例如Head的祖父级：

```
$ git show HEAD~2
```

当进行三路合并的时候，会存在不止一个父commit，第一父级在你执行命令时所在的分支，第二父级在于你穿入git merge命令的那个分支上。

- `~`字符将在第一父级上追踪
- `^`字符表示第二父级

## HEAD文件

git使用HEAD文件来记录当前的分支（当前分支是HDATA-1104）：

```
$ cat .git/HEAD
ref: refs/heads/feature/HDATA-1104
```

HEAD为也是一个特殊的引用。

## tag 

- lightweight tags

  轻量标签很像一个不会改变的分支，其内容是对一个特定提交的引用，这种 tag 存储在`.git/refs/tag/`文件夹下；

- annotated tags

   声明式的标签会在object下添加`tag object`，能记录更多的信息：

  - 对应的 commit hash值
  - 标签号
  - 打标签的人
  - tag message

## branch

分支在本质上仅仅是「指向commit对象的可变指针」，其内容为一个commit对象的SHA-1 值，所以分支的创建和销毁都异常高效。

`git checkout` 实际上就是在操作`HEAD`

### HEAD分离

Git 中有一个比较难理解的概念叫做「HEAD分离」，映射到文件层面，其实指的是 `.git/HEAD` 直接指向某个`commit`对象。

`git checkout <hash|tag>`

HEAD直接指向一个`commit`对象，更新工作区内容为该`commit`对象对应的快照，此时为`HEAD`分离状态，切换到其它分支或者新建分支`git branch -b new-branch`|| `git checkout branch`可以使得`HEAD`不再分离

## 分支合并

### merge

Git 中分支合并有两种算法，快速向前合并和三路合并

- 快速向前合并

  此种情况下，**主分支没有改动**，因此在基于主分支生成的分支上做的更改，一定不会和主分支上的代码冲突，可以直接合并，在底层相当于修改`.refs/heads/` 下主分支的内容为最新的 commit 对象。

  ![git%E6%93%8D%E4%BD%9C_assets](Git%E5%8E%9F%E7%90%86_assets/fastword_merge.webp)

- 三路合并

  分支上的代码也做了修改并添加了新的 commit ，此时合并，需要生成新的合并commit，并指向原来的两个父commit，中间还有可能产生冲突，需要处理。

  ![git%E6%93%8D%E4%BD%9C_assets](Git%E5%8E%9F%E7%90%86_assets/no-fast-forword.webp)

### rebase

![git%E6%93%8D%E4%BD%9C_assets](Git%E5%8E%9F%E7%90%86_assets/git-rebase.webp)

## References

1. https://git-scm.com/book/en/v2/Git-Internals-Git-References
2. https://segmentfault.com/a/1190000007996197
3. [Git-深入一点点](https://github.com/Val-Zhang/blogs/issues/9)
4. [手撕Git，告别盲目记忆](https://zhuanlan.zhihu.com/p/98679880)
5. [用动画图解 Git 的 10 大命令](https://zhuanlan.zhihu.com/p/147356242)
6. [图文详解如何利用Git+Github进行团队协作开发](https://zhuanlan.zhihu.com/p/23478654)





git cherry-pick

`git cherry-pick`做的事情是将一个或者多个commit应用到当前commit的顶部，复制commit，会保留对应的二进制文件，但是会修改`parent`信息。

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-486f540aaf172d27349c217f87e9fba8_b.webp)

```
当一个特定分支包含我们的活动分支需要的某个提交时，我们对那个提交执行 cherry-pick！对一个提交执行 cherry-pick 时，我们会在活动分支上创建一个新的提交，其中包含由拣选出来的提交所引入的修改。

假设 dev 分支上的提交 76d12 为 index.js 文件添加了一项修改，而我们希望将其整合到 master 分支中。我们并不想要整个 dev 分支，而只需要这个提交！

现在 master 分支包含 76d12 引入的修改了。
```



git revert

**还原（Reverting）**

git revert 命令本质上就是一个逆向的 git cherry-pick 操作。 它将你提交中的变更的以完全相反的方式的应用到一个新创建的提交中，本质上就是撤销或者倒转。

```
另一种撤销修改的方法是执行 git revert。通过对特定的提交执行还原操作，我们会创建一个包含已还原修改的新提交。

假设 ec5be 添加了一个 index.js 文件。但之后我们发现其实我们再也不需要由这个提交引入的修改了。那就还原 ec5be 提交吧！

完美！提交 9e78i 还原了由提交 ec5be 引入的修改。在撤销特定的提交时，git revert 非常有用，同时也不会修改分支的历史。
```



git reset

`git reset` 具有以下常见用法：

1. `git reset <file>`:从缓存区移除特定文件，但是不会改变工作区的内容
2. `git reset` : 重设缓存区，会取消所有文件的缓存
3. `git reset --hard` : 重置缓存区和工作区，修改其内容对最新的一次 commit 对应的内容
4. `git reset <commit>` : 移动当前分支的末端到指定的`commit`处
5. `git reset --hard <commit>`: 重置缓存区和工作区，修改其内容为指定 commit 对应的内容
   相对而言,`git reset`是一个相对危险的操作，其危险之处在于可能会让本地的修改丢失，可能会让分支历史难以寻找。

我们看看`git reset`的原理

1. 移动`HEAD`所指向的分支的指向：如果你正在 master 分支上工作，执行 `git reset 9e5e64a` 将会修改 `master` 指向哈希值为 `9e5e64a` 的 `commit object`。

- 无论你是怎么使用的`git reset`，上述过程都会发生，不同用法的区别在于会如何修改工作区及缓存区的内容，如果你用的是 `git reset --soft`，将仅仅执行上述过程；

  ![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-ada73b43d7146e071f9557372d733d66_b.webp)

- `git reset`本质上是撤销了上一次的 `git commit` 命令。

> 执行 `git commit` ，Git 会创建一个新的 commit 对象，并移动 `HEAD` 所指向的分支指向该commit。 而执行`git reset`会修改 `HEAD` 所指向的分支指向 `HEAD~`（HEAD 的父提交），也就是把该分支的指向修改为原来的指向，此过程不会改变`index`和工作目录的内容。

1. 加上 `—mixed` 会更新索引：`git reset --mixed` 和 `git reset` 效果一致，这是`git reset`的默认选项，此命令除了会撤销一上次提交外，还会重置`index`，相当于我们回滚到了 `git add` 和 `git commit` 前的状态。
2. 添加`—hard`会修改工作目录中的内容：除了发生上述过程外，还会恢复工作区为 上一个 `commit`对应的快照的内容，换句话说，是会清空工作区所做的任何更改。

> `—hard` 可以算是 `reset` 命令唯一的危险用法，使用它会真的销毁数据。

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-3456eebeb80dca402dbf5b55e88c4291_b.webp)

如果你给 `git reset` 指定了一个路径，`git reset` 将会跳过第 1 步，将它的作用范围限定为指定的文件或文件夹。 此时分支指向不会移动，不过索引和工作目录的内容则可以完成局部的更改，会只针对这些内容执行上述的第 2、3 步。

> `git reset file.txt` 其实是 `git reset --mixed HEAD file.txt` 的简写形式,他会修改当前`index`看起来像 HEAD 对应的`commit`所依据的索引，因此可以达到取消文件缓存的作用。

```
git reset分为三种模式：

soft
mixed
hard

git reset --hard commit的hash值
会重置暂存区和工作区，完全重置为指定的commit节点。当前分支没有commit的代码必然会被清除。

git reset --soft commit的hash值
会保留工作目录，并把指定的commit节点与当前分支的差异都存入暂存区。也就是说，没有被commit的代码也能够保留下来。

git reset commit的hash值
不带参数，也就是mixed模式。将会保留工作目录，并且把工作区，暂存区以及与reset的差异都放到工作区，然后清空暂存区。因此执行后，只要有所差异，文件都会变成红色，变得难以区分。
```





git stash

有时候，我们在新分支上的`feature`开发到一半的时候接到通知需要去修复一个线上的紧急bug🐛，这时候新`feature`还达不到该提交的程度，命令`git stash`就派上了用场。

`git stash`被用来保存当前分支的工作状态，便于再次切换回本分支时恢复。其具体用法如下：

1. 在`feature`分支上执行`git stash 或 git stash save`，保存当前分支的工作状态；
2. 切换到其它分支，修复bug,并提交
3. 切换回`feature`分支，执行`git stash list`，列出保存的所有`stash`，执行 `git stash apply`，恢复最新的`stash`到工作区;

> 也可以覆盖老一些的`stash`, 用法如`git stash apply stash@{2}`;

关于`git stash`还有其它一些值得关注的点：

1. 直接执行`git stash`会恢复所有之前的文件到工作区，也就是说之前添加到缓存区的文件不会再存在于缓存区，使用 `git stash apply --index` 命令，则可以恢复工作区和缓存区与之前一样；
2. 默认情况下，`git stash` 只会储藏已经在索引中的文件。 使用 `git stash —include-untracked` 或 `git stash -u` 命令，Git 才会将任何未跟踪的文件添加到`stash`;
3. 使用命令`git stash pop` 命令可以用来应用最新的`stash`,并立即从`stash`栈上扔掉它;
4. 使用命令 `git stash —patch` ，可触发交互式`stash`会提示哪些改动想要储藏、哪些改动需要保存在工作目录中。
5. 使用命令`git stash branch <new branch>`：构建一个名为`new branch`的新分支，并将stash中的内容写入该分支

说完了`git stash`的基本用法，我们来看看，其在底层的实现原理：

上文中我们提到过，Git 操作的是 工作区，缓存区及 HEAD 三棵文件树，我们也知道，`commit` 中包含的根 `tree` 对象指向，可以看做文档树的快照。

当我们执行`git stash`时，实际上我们就是依据工作区，缓存区及HEAD这三棵文件树分别生成`commit`对象，之后以这三个commit 为 `parent` 生成新的 `commit`对象，代表此次`stash`，并把这个 commit 的 hash值存到`.git/refs/stash`中。

当我们执行`git stash apply`时，就可以依据存在 `.git/refs/stash` 文件中的 commit 对象找到 `stash` 时工作区，缓存区及HEAD这三棵文件树的状态，进而可以恢复其内容。



git clean

使用`git clean`命令可以去除冗余文件或者清理工作目录。 使用`git clean -f -d`命令可以用来移除工作目录中所有未追踪的文件以及空的子目录。

此命令真的会从工作目录中移除未被追踪的文件。 因此如果你改变主意了，不一定能找回来那些文件的内容。 一个更安全的命令是运行 `git stash --all` 来移除每一项更新，但是可以从`stash`栈中找到并恢复它们。。

`git clean -n` 命令可以告诉我们`git clean`的结果是什么，如下：

```
$ git clean -d -n
Would remove test.o
Would remove tmp/
```

所有在不知道 `git clean` 命令的后果是什么的时候，不要使用`-f`,推荐先使用 `-n` 来看看会有什么后果。

讲到这里，常用的操作本地仓库的命令就基本上说完了，下面我们看看 Git 提供的一些操作远程仓库的命令。