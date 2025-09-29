# Git仓库体积太大

## 背景

迁移Bitbucket后，前端同事说克隆仓库报错，我看了下，发现前端工作区才几十M，但是`.git`目录达到了1.2G，在Clone的时候，超出了Git设置的缓存。

通过了解，前端由于之前线上服务器打包失败，所以每次都在本地打包，然后传到代码仓库中，这样长期以来，代码仓库就累积了很多打包后的压缩包对象。

查看`.git`文件夹大小：

```
$ du -sh .git
1.2G	.git
```

下面介绍两种解决方案，推荐使用第二种工具的方式。

## git filter-branch方式

### 先克隆一个镜像仓库

```
$ git clone --mirror xxx
```

### 查找大文件

```
$ git rev-list --all --objects | grep "$(git verify-pack -v objects/pack/*.idx | sort -k 3 -n | tail -n 3 | awk -F ' ' '{print $1}')"
```

**命令解释**

```
$ git rev-list --objects --all
```

`git rev-list`即按时间倒序列出commit（reverse-list）：

- `--objects` 代表输出对应commit所引用的对象

- `--all` 代表输出所有commit节点

  > Pretend as if all the refs in `refs/`, along with `HEAD`, are listed on the command line as *<commit>*.

```
$ git verify-pack -v .git/objects/pack/*.idx
```

`git verify-pack`命令是查看打包后的package文件。

格式如下：

```
git verify-pack [-v|--verbose] [-s|--stat-only] [--] <pack>.idx …
```

- `-v --verbose`

  验证包之后，显示包中对象的完整内容

  输出格式如下：

  ```
  SHA-1 type size size-in-packfile offset-in-packfile
  ```

接下来是根据size进行排序：

```
sort -k 3 -n 
```

`-k`即根据第几列，`-n`即将第三列识别成数字。

最后是提取出来我们需要的元素，即对象的散列值，来传递给`git rev-list|grep`：

```
awk -F ' ' '{print $1}'
```

其中`-F`是指定分隔符为空格。

解释完这个命令的含义，我们再来看看结果：

```
$ git rev-list --all --objects | grep "$(git verify-pack -v objects/pack/*.idx | sort -k 3 -n | tail -n 3 | awk -F ' ' '{print $1}')"
729df9011c4150907fbdda47662bc6009ba8a9e2 build-zips/dist-dev.zip
a94d15c67495125d4781b3b3c8439cdae895e5fb build-zips/dist-dev.zip
a358e257fe0f4e57c494f24e82ddfbdd7166f39b build-zips/dist-dev.zip
```

该文件，也就是前端打包后的压缩文件，经查，该文件大小为10M，历史记录中一共有159个该文件。这就是该仓库大的原因。

### 删除大文件对象

删除大文件对象命令如下：

```
$ git filter-branch --force --index-filter 'git rm -rf --cached --ignore-unmatch 大文件路径' --prune-empty --tag-name-filter cat -- --all
```

将上面命令中的大文件路径替换为`build-zips/dist-dev.zip`。

`git filter-branch`命令的含义为重写历史分支。

- `-f --force`

  > *git filter-branch* refuses to start with an existing temporary directory or when there are already refs starting with *refs/original/*, unless forced.

- `--index-filter <command>`

  重写过滤器，即删除哪些文件。

- `--prune-empty`

  > Some filters will generate empty commits that leave the tree untouched. This option instructs git-filter-branch to remove such commits if they have exactly one or zero non-pruned parents;

- `--tag-name-filter <command>`

  > use "--tag-name-filter cat" to simply update the tags

- `-- --all`

  `--`用于分隔`git filter-branch`命令的选项和分支。`--all`用于重写所有分支和标签。

  使用`--tag-name-filter cat -- --all`来选择所有分支。

这些底层命令的参数还是很复杂的，笔者还没有完全弄懂所有选项的含义，这里引用了官方文档的解释，但是毕竟涉及到重写历史，所以还是很危险的，尽可能弄懂使用到的命令和选项是有必要的。

### 清理回收空间

```
$ rm -rf refs/original/
$ git reflog expire --expire=now --all
$ git gc --prune=now
$ git gc --aggressive --prune=now
```

### 推送到远程服务器

```
$ git push --force
```

## BFG Repo-Cleaner方式

详见此，[BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)。

此工具用起来要更简单，而且速度更快，推荐使用该工具。

## References

1. Stack Overflow：[How to remove/delete a large file from commit history in the Git repository?](https://stackoverflow.com/questions/2100907/how-to-remove-delete-a-large-file-from-commit-history-in-the-git-repository)
1. Git官方文档：[git-rev-list - Lists commit objects in reverse chronological order](https://git-scm.com/docs/git-rev-list)
1. Git官方文档：[git-verify-pack - Validate packed Git archive files](https://git-scm.com/docs/git-verify-pack)
1. Git官方文档：[git-filter-branch - Rewrite branches](https://git-scm.com/docs/git-filter-branch)
1. BFG Repo-Cleaner官方文档：[BFG Repo-Cleaner](https://rtyley.github.io/bfg-repo-cleaner/)