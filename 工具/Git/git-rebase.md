# git rebase

Git一共有两个工具来将两个分支的变化合并到一起，一个是`git merge`，另一个则是`git rebase`。

`git merge`总是向前处理合并，不会修改历史提交，而`git rebase`则会将历史分支的基点从一个commit变更为另一个commit，从而达到合并的目的，使得提交记录看上去更加干净。

`git rebase`工作模式如下图所示：

![git_rebase_example](git-rebase_assets/git_rebase_example.svg 'rebase主要作用是使得提交历史是一条直线')

注意，rebase并不是将目标分支进行了复制粘贴，而是创建了新的commit节点（hash值已改变）。

`git rebase`一共有两种模式：

- 交互模式

  允许你对要变基的commit进行删除，修改，合并等。

- 标准模式

  自动接收要变基的所有commit节点。

例如有当前git log为（feature为当前分支）：

```
* f4b0bf2 - (HEAD -> feature) add b3
* 6b08126 - add b2
* 9801c94 - add b 
| * 6cd2c14 - (master) add a2
| * d8acd26 - add a
|/
* 6a30cc2 - base
```

下面分别用两种模式来合并master分支和feature分支。

## 交互模式

首先示范**交互模式**：

格式：

```
git rebase --interactive <base>
```

- `<base>`

  base可以为分支或者节点

我们执行如下命令：

```
$ git rebase -i master
```

会得到如下界面：

```
pick 9801c94 add b
pick 6b08126 add b2
pick f4b0bf2 add b3

# Rebase 6cd2c14..f4b0bf2 onto 6cd2c14 (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# r, reword <commit> = use commit, but edit the commit message
# e, edit <commit> = use commit, but stop for amending
# s, squash <commit> = use commit, but meld into previous commit
# f, fixup <commit> = like "squash", but discard this commit's log message
# x, exec <command> = run command (the rest of the line) using shell
# b, break = stop here (continue rebase later with 'git rebase --continue')
# d, drop <commit> = remove commit
# l, label <label> = label current HEAD with a name
# t, reset <label> = reset HEAD to a label
# m, merge [-C <commit> | -c <commit>] <label> [# <oneline>]
# .       create a merge commit using the original merge commit's
# .       message (or the oneline, if no original merge commit was
# .       specified). Use -c <commit> to reword the commit message.
#
# These lines can be re-ordered; they are executed from top to bottom.
#
# If you remove a line here THAT COMMIT WILL BE LOST.
#
# However, if you remove everything, the rebase will be aborted.
```

我们改为如下内容：

```
pick 9801c94 add b
pick 6b08126 add b2
d f4b0bf2 add b3
```

再次查看git log：

```
* 95c929f - (HEAD -> feature) add b2
* d6a7c1a - add b
* 6cd2c14 - (master) add a2
* d8acd26 - add a
* 6a30cc2 - base
```

我们可以看到add b3的节点已被删除。

## 标准模式

其次我们同样的情形示范**标准模式**：

格式：

```
git rebase <base>
```

我们可以执行如下代码：

```
$ git rebase master
```

即可查看git log如下：

```
* 139199a - (HEAD -> feature) add b3
* 32706d0 - add b2
* f845baa - add b
* 6cd2c14 - (master) add a2
* d8acd26 - add a
* 6a30cc2 - base
```

## 应用

### 合并节点

时候我们的提交会有多个类似的commit，这个时候我们希望将多个类似的commit合并为一个，然后push，可以利用上面交互模式的`squash`参数。

>s, squash <commit> = use commit, but meld into previous commit.

（也可以用`fixup`，与`squash`类似，只是没有合并节点的commit信息）

例如当前git log为：

```
* cc2b3d3 - (HEAD -> feature) add t3
* 59361e9 - add t2
* f7e2acd - add t1
* 139199a - base
```

明显前三个commit冗余，我们可以合并为一个，执行下面的命令：

```
$ git rebase -i 139199a

//or
$ git rebase -i head~3
```

将弹出的交互式窗口的内容修改为下（即将后面两个节点前的pick修改为`squash`或`s`）：

```
pick d20150f add t1
squash 59361e9 add t2
squash cc2b3d3 add t3
```

然后再调整合并后的message信息，最后三个节点即会被合并为一个（rebase会生成新的节点，即b6f2233）：

```
* b6f2233 - (HEAD -> feature) add t1、t2、t3
* 139199a - base
```

### pull

我们知道`git pull`相当于下面两条命令：

```
git fetch
git merge
```

当远程分支与当前分支产生冲突的时候，此时merge后就会分叉，如果要想要我们的git log是一条直线，那就就需要：

```
git pull --rebase
```

## 注意

> The rebase would replace the old commits with new ones and it would look like that part of your project history abruptly vanished.

注意不要rebase已经push的分支，或者说，生产中，任何已经push的分支都不要动。

## 总结

善用rebase，你就会得到一个干净的提交记录。

## References

1. https://git-scm.com/docs/git-rebase
1. https://www.atlassian.com/git/tutorials/rewriting-history/git-rebase
1. https://www.zhihu.com/question/61283395/answer/186223235
1. https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History
1. https://github.com/torvalds/linux/pull/17#issuecomment-5654674
1. https://zhuanlan.zhihu.com/p/387438871