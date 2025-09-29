# Git迁移远程仓库

## 步骤

1. 克隆旧仓库

   ```
   $ git clone --mirror 旧仓库地址
   ```

   `--mirror`会在本地创建一个裸（bare）仓库（通常本地根目录以`.git`结尾，且没有工作目录，也就是将.git文件夹中的内容放在根目录下），同时克隆ref下的所有内容，**不仅仅是远程主机本地的分支**。

2. 修改远程仓库地址

   ```
   $ git remote set-url origin 新仓库地址
   ```

3. 推送到远程仓库

   ```
   $ git push --mirror
   ```

   与第一步类似的，该步骤也会将refs下的所有资源进行push，包括`refs/heads/`、`refs/remotes/`、 `refs/tags/`等。

## 问题

### 问题一：未关闭的PR

当执行`git push --mirror`的时候，报如下错误：

```
remote: You are attempting to update refs that are reserved for Bitbucket's pull request functionality. Bitbucket manages these refs automatically, and they may not be updated by users.
remote: Rejected refs:
remote: 	refs/pull-requests/166/from
remote: 	refs/pull-requests/167/from
remote: 	refs/pull-requests/167/merge
remote: 	refs/pull-requests/46/from
remote: 	refs/pull-requests/46/merge
```

这个原因是我们在执行第一步clone的时候，远程仓库还有未关闭的PR（pull-requests），这些不能被推送到新的仓库，可以执行如下命令，将其删除：

```
$ git show-ref | cut -d' ' -f2 | grep 'pull-request' | xargs -r -L1 git update-ref -d
```

注意：实际上clone的目标远程仓库并没有未关闭的PR，不知道为什么clone后本地refs里面还是显示有未关闭的PR。

## References

1. StackOverflow：[How can I exclude pull requests from git mirror clone](https://stackoverflow.com/questions/37985275/how-can-i-exclude-pull-requests-from-git-mirror-clone)



