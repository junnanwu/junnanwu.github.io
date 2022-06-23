# Git命令

## git init

初始化Git本地仓库，并为你创建master分支。

## git config

参数：

- `--system`

  修改的是`/etc/gitconfig` 文件，这是系统上的每一个用户的通用配置

- `--global`

  修改的是`~/.gitconfig`，只针对当前用户

- `--local`

  修改的是当前本地仓库的配置文件及`.git/config`，`git config`默认使用的就是这个参数
  
- `--list -l`

  查看Git的配置

举例：

- 安装完Git后，需要先设置用户名和密码

  ```
  $ git config --global user.name "John Doe"
  $ git config --global user.email johndoe@example.com
  ```

  如果使用了 `--global` 选项，那么该命令只需要运行一次，因为之后无论你在该系统上做任何事情， Git 都会使用那些信息。 当你想针对特定项目使用不同的用户名称与邮件地址时，可以在那个项目目录下运行没有 `--global` 选项的命令来配置。

- 查看Git中该变量的原始值

  ```
  $ git config --show-origin user.name
  file:/Users/wujunnan/.gitconfig	wujunnan
  ```
  
- 设置别名

  ```
  $ git config --global alias.co commit
  ```
  
  下次使用commit命令时直接换成`git co` 即可

## git clone

**格式**：

```
git clone <版本库的网址>
```

`<url>`部分支持四种协议：本地协议（Local），HTTP 协议，SSH（Secure Shell）协议及 Git 协议

```
$ git clone git://github.com/schacon/ticgit.git
```

默认情况下会把clone的源仓库取名`origin`，在`.git/config`中存储其对应的地址，本地分支与远程分支的对应规则等。

- 想用其他的主机名

  用`git clone`命令的`-o`选项指定：
  
  ```
  $ git clone -o jQuery https://github.com/jquery/jquery.git
  $ git remote
  jQuery
  ```

## git show

格式：

```
git show [<options>] [<object>…]
```

可以用来展示一个或多个对象，包括blobs、trees、tags、commits。

## git remote

`git remote` 为我们提供了管理远程仓库的途径。
对远程仓库的管理包括，查看，添加，移除，对远程分支的管理等等。

- 查看远程仓库

  ```
  git remote
  ```

- 添加 `-v`，可查看对应的链接

  ```
  $ git remote -v
  origin	https://github.com/schacon/ticgit (fetch)
  origin	https://github.com/schacon/ticgit (push)
  ```

- 查看该主机的详细信息

  ```
  git remote show <主机名>
  ```

- 添加远程主机

  ```
  git remote add <主机名> <网址>
  ```

- 删除远程主机

  ```
  git remote rm <主机名>
  ```

- 改远程主机的名字

  ```
  git remote rename <原主机名> <新主机名> [remote] "github":代表远程仓库的名称；
  ```

## git log

查看某一个分支的提交

```
$ git log --oneline --graph
```

参数：

- `--graph`

  查看日志的图形化版本

- `--oneline`

  将日志放置在一行显示

- `--abbrev-commit`

  简单的格式显示commit id

- `--author="<pattern>" `

  根据作者进行筛选

  ```
  $ git log --author="wujunnan" 
  ```

- `--stat `

  额外显示改动信息

- `<file>`

  显示包含此文件的提交

- 根据分支分类筛选

  - `--all`

    `refs/`中的所有内容

  - `--branches`

    `refs/heads/`中的所有内容

  - `--remotes`

    `refs/remotes/`中的所有内容

  - `--tags`

    `refs/tags/`中的所有内容

举例：

设置查看日志组合命令：

1. 命令如下

   ```
   $ git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all
   ```

2. 设置别名

   ```
   $ git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative --all"
   ```

3. 使用

   ```
   $ git lg
   ```

## git fetch

- 将某个远程主机的更新，全部取回本地

  ```
  git fetch <远程主机名>
  ```

- 默认情况下，`git fetch`取回所有分支（branch）的更新。如果只想取回特定分支的更新，可以指定分支名。

  ```
  git fetch <远程主机名> <分支名>
  ```

  比如，取回`origin`主机的`master`分支。

  ```
  $ git fetch origin master
  ```

## git branch

参数：

- `a`

  所有分支

举例：

- 创建分支

  ```
  $ git branch test_branch
  ```

- 查看分支(默认本地)

  ```
  $ git branch
  ```

- 查看所有分支

  ```
  $ git branch -a
  ```

- 查看远程分支

  ```
  $ git branch -r
  ```

- 删除分支

  ```
  $ git branch -d test_branch
  ```

- 查看所有本地分支，并包含更多的信息

  ```
  $ git branch -vv
  ```

## git status

- 简介的形式显示

  `git status -s`

  - `??`表示新添加的未跟踪文件
  - `A`表示新添加的
  - `M`表示修改的

## git add

## git commit

参数：

- `-a`

  Git就会自动把所有**已经跟踪过**的文件暂存起来一并提交
  
- `--amend`

  当我们不想要上一次的commit的时候，或者想将当前的commit合并到之前的commit时候，可以使用

  ```
  $ git commit --amend
  ```

  这时候，会出现上次的commit message，我们可以进行修改，之后就会替换之前的commit。
  
  注意：
  
  - 会改变你原来的commit id，远程分支比本地的分支新，导致push失败，需要`git push --force-with-lease`
  
  - 此操作相当于回退上个commit，然后重新commit：
  
    ```
    $ git reset --soft HEAD^
    ... do something else to come up with the right tree ...
    git commit -c ORIG_HEAD
    ```


## git diff

`git diff`比较的是工作目录中当前文件和暂存区域快照之间的差异， 也就是修改之后还没有暂存起来的变化内容。若要查看已暂存的将要添加到下次提交里的内容，可以用 `git diff --cached` 命令。

注意

- `git diff`本身只显示尚未暂存的改动，而不是自上次提交以来所做的所有改动

  所以有时候你一下子暂存了所有更新过的文件后，运行 git diff 后却什么也没有，就是这个原因。

## git rm

`git rm`相当于同时删除暂存区和工作区的文件，相当于以下两个命令：

```
$ rm a.txt
$ git add a.txt
```

参数：

- `--cached`

  只从暂存区删除

  如果只把文件只从暂存区删除：

  ```
  $ git rm --cached a.txt
  ```

- `-r`

  删除文件夹

举例：

- 移除已经`push`的文件

  ```
  $ git rm --cached update_frontend
  $ git commit -am '删除文件' 
  ```

- 移除暂存区的文件

  ```
  $ git rm --cached ESUtilTest.java 
  ```

## git mv

## git pull

取回远程主机某个分支的更新，再与本地的指定分支合并。

此命令的完整格式为：

```
$ git pull <远程主机名> <远程分支名>:<本地分支名>
```

比如，取回`origin`主机的`next`分支，与本地的`master`分支合并

```
$ git pull origin next:master
```

如果远程分支是与当前分支合并，那么冒号后面的可以省略

```
$ git pull origin next
```

上面命令表示，取回`origin/next`分支，再与当前分支合并。实质上，这等同于先做`git fetch`，再做`git merge`。

```
$ git fetch origin
$ git merge origin/next
```

如果当前分支与远程分支存在追踪关系，`git pull`就可以省略远程分支名。

```
$ git pull origin
```

上面命令表示，本地的当前分支自动与对应的`origin`主机"追踪分支"（remote-tracking branch）进行合并。

在`git clone`的时候，所有本地分支默认与远程主机的同名分支，建立追踪关系，也就是说，本地的`master`分支自动"追踪"`origin/master`分支。

如果当前分支只有一个追踪分支，连远程主机名都可以省略。

```
$ git pull
```

上面命令表示，当前分支自动与唯一一个追踪分支进行合并。

## git merge

将指定的commit合并到当前分支

例如，你当前在mater分支：

```
	A---B---C topic
	/
D---E---F---G master
```

执行下面命令将topic合并到master分支

```
$ git merge topic
```

## git reset

此命令用于回退版本，退回至某一次提交的版本。

```
git reset [--soft | --mixed | --head] [HEAD]
```

默认参数为`--mixed`，此参数含义是将缓存区与指定的版本保持一致，而工作区文件内容保持不变。

`--hard`参数将暂存区和工作区都与指定的版本保持一致。

暂存区回到上一个版本：

```
$ git reset HEAD^
```

暂存区和工作区都回到上一个版本：

```
$ git reset --hard HEAD^
```

将文件`README.md`回退到上个版本：

```
$ git reset HEAD^ README.md
```

当然我们通过`git reflog`查看之前的版本，然后退回：

```
$ git reset c085db83
```

**IDEA**

commit未push的撤销

VSC => Git=> reset head

退回到上次commit：To Commit: HEAD^

退回到第二次提交之前：To Commit: HEAD~2

退回到指定commit版本：To Commit: id号

## git revert

## git stash

## git tag

Git中，我们通过tag来标记版本。

注意tag与branch的区别：

- tag是对应的某次commit
- branch是一系列commit

参数：

- `-l --list [pattern]`

  列出所有tag，`git tag`即`git tag --list`

举例：

- 拉取标签

  `git pull`和`git fetch`会自动获取设计分支中的所有标签

- 查看

  - 查看所有标签

    ```
    $ git tag
    ```

  - 查看部分标签

    ```
    $ git tag -l 'v2.8*'
    ```

  - 查看标签的散列值

    ```
    $ git  show-ref --tags
    ```

  - 查看某个提交都出现在哪个版本里

    （例如，想查看某次修复的bug都哪些版本包含了）

    ```
    $ git tag --contains 4aa54ce 
    ```

- 打标签

  - 创建标签

    ```
    $ git tag v1.0
    ```

  - 在指定分支的当前版本新建标签

    ```
    $ git tag v2.9.0.2  origin/release/v2.9.0.2
    ```

  - 新建带有信息的分支

    ```
    $ git tag -a v1.1.4 -m "tagging version 1.1.4"
    ```

- 将标签推到远程仓库

  - 将本地`v0.1.2`标签提交到git服务器

    ```
    $ git push v0.1.2
    ```

  - 将所有本地标签推送到远程仓库

    ```
    $ git push –-tags
    ```

  > 注意，如果你创建标签时使用了`-m` 、`-a` 、`-s`或`-u`这些参数，Git会将在版本库中将标签作为一个独立对象来创建。该对象中会包含相关用户以及创建时间等信息。而要是如果没有使用这些选项，Git就只会创建一个所谓的轻量级标签，其中只有用于识别的提交散列。

- 切换到某个标签下

  ```
  $ git checkout v0.21
  ```

  此时会指向打v0.21标签时的代码状态, (但现在处于一个空的分支上)

- 删除本地标签

  ```
  $ git tag -d 标签名
  ```

- 删除远程标签

  ```
  $ git push origin :refs/tags/v2.3.1.1
  ```
  
  >`tag <<tag>>` means the same as `refs/tags/<tag>:refs/tags/<tag>`.
  >
  >Pushing an empty `<src>` allows you to delete the `<dst>` ref from the remote repository.

## 其他

### 添加空文件夹

git空目录无法add，如果想add一个空目录，则需要在它下面创建一个文件，比如（`.gitignore`或`.gitkeep`）。


## References

1. https://segmentfault.com/a/1190000007996197
2. http://www.ruanyifeng.com/blog/2014/06/git_remote.html
