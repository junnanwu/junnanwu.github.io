# git push

完整命令

```
git push <远程主机名> <本地分支名>:<远程分支名>
```

如果省略远程分支名，则表示将本地分支推送与之存在"追踪关系"的远程分支（通常两者同名），如果该远程分支不存在，则会被新建。

```
git push origin master
```

上面命令表示，将本地的`master`分支推送到`origin`主机的`master`分支。如果后者不存在，则会被新建。

如果省略本地分支名，则表示删除指定的远程分支，因为这等同于推送一个空的本地分支到远程分支。

```
$ git push origin :master
# 等同于
$ git push origin --delete master
```

如果当前分支与远程分支之间存在追踪关系，则本地分支和远程分支都可以省略。

```
$ git push origin
```

上面命令表示，将当前分支推送到`origin`主机的对应分支。

如果当前分支只有一个追踪分支，那么主机名都可以省略。

```
$ git push
```

不带任何参数的`git push`，默认只推送当前分支，这叫做simple方式。此外，还有一种matching方式，会推送所有有对应的远程分支的本地分支。Git 2.0版本之前，默认采用matching方法，现在改为默认采用simple方式。如果要修改这个设置，可以采用`git config`命令。

```
git config --global push.default matching
# 或者
git config --global push.default simple
```

## 参数

- `--all`

  不管是否存在对应的远程分支，将本地的所有分支都推送到远程主机。

  ```
  git push --all origin
  ```

  上面命令表示，将所有本地分支都推送到`origin`主机。

- `--force`

  **如果远程主机的版本比本地版本更新**，推送时Git会报错，要求先在本地做`git pull`合并差异，然后再推送到远程主机。这时，如果你一定要推送，可以使用`--force`选项。

  > Usually, "git push" refuses to update a remote ref that is not an ancestor of the local ref used to overwrite it.

  ```
  git push --force origin 
  ```

  上面命令使用`--force`选项，结果导致远程主机上更新的版本被覆盖。

  注意：

  在多人使用同一分支的情况下，禁止使用`--force`选项。

- `--tags`

  最后，`git push`不会推送标签（tag），除非使用`--tags`选项。

  ```
  git push origin --tags
  ```

- `--force-with-lease`

  更安全的push，使用此参数推送，如果远端有其他人推送了新的提交，那么推送将被拒绝，此参数将确保你不会复写其他人的分支。

  >This option allows you to say that you expect the history you are updating is what you rebased and want to replace. 

  此选项通过检查你本地的远程仓库的引用与远程仓库的相关分支是否一致，例如当其他人push了分支，那么你的远程仓库的引用就过时了，这个时候，该参数是不允许你进行push的，除非你fetch或者pull更新你本地的远程仓库的引用。
  
- `--mirror`

  将`refs`下的所有资源都进行push，包括`refs/heads/`、`refs/remotes/`、 `refs/tags/`等，迁移到新仓库，可以使用此参数。

## 举例

- 删除远程分支

  `git push origin --delete master` 删除origin主机的master分支

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

- 如果当前分支与多个主机存在追踪关系，那么这个时候**-u选项会**指定一个默认主机，这样后面就可以不加任何参数使用git push

  `git push -u origin master`

  上面命令将本地的master分支推动到origin分支上，后面就可以直接git push了

## References

- 阮一峰的网络日志：[Git远程操作详解](http://www.ruanyifeng.com/blog/2014/06/git_remote.html)
- 博客：[Git push与pull的默认行为](https://segmentfault.com/a/1190000002783245)