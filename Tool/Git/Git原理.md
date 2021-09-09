# Git原理

## Git文件目录

```
.
└── .git
    ├── HEAD           //存储着Git仓库当前位于的分支
    ├── config			   //配置文件
    ├── description
    ├── hooks
    │   ├── applypatch-msg.sample
    │   ├── commit-msg.sample
    │   ├── fsmonitor-watchman.sample
    │   ├── post-update.sample
    │   ├── pre-applypatch.sample
    │   ├── pre-commit.sample
    │   ├── pre-push.sample
    │   ├── pre-rebase.sample
    │   ├── pre-receive.sample
    │   ├── prepare-commit-msg.sample
    │   └── update.sample
    │   ├── index      //暂存区，记录add进来的文件状态，文件SHA-1值，文件名
    ├── info
    │   └── exclude
    ├── objects        //存放Blobs,Tree objects,Commit objects这三种类型的数据
    │   ├── info
    │   └── pack
    └── refs
    		├── heads      //里面存放本地分支
				│   ├── master
				│   ├── dev
				│   └── ...
				├── remotes    //里面存放远程分支 
        │   ├── origin
        │   │   ├── ANDROIDBUG-4845
        │   │   ├── ...
        ├── stash     //与git stash相关
        └── tags      //轻量级的tag
```

## Git中存储的五种对象

- `Blobs`， 是Git中最基础的数据类型，一个`blob`对象就是一堆字节，通常是一个文件的二进制表示
- `tree`，有点类似于目录，其内容由对其它`tree`及`blobs`的指向构成；
- `commit`，指向一个树对象，并包含一些表明作者及父 commit 的元数据
- `Tag`，指向一个commit对象，并包含一些元数据
- `References`,指向一个`commit`或者`tag`对象

`blobs` , `tree` , `commit` ,以及声明式的 `tag` 这四种对象会存储在 `.git/object` 文件夹中。这些对象的名称是一段40位的哈希值，此名称由其内容依据`sha-1`算法生成，具体到`.git/object`文件夹下，会取该hash值的前 2 位为子文件夹名称，剩余 38 位为文件名，这四类对象都是二进制文件，其内容格式依据类型有所不同

### blob

`blobs`是二进制文件，我们不能直接查看，不过通过 Git 提供的命令如 `git show [hash]` 或者 `git cat-file -p [hash]` 我们就可以查看 `.git/object` 文件夹下任一文件的内容。

```
wujunnan@localhost test % git cat-file -t 180c
blob
wujunnan@localhost test % git cat-file -p 180c
test2
```

从上面的内容中就可以看出，`blob` 对象中仅仅存储了文件的内容，如果我们想要完整还原工作区的内容，我们还需要把这些文件有序组合起来，这就涉及到 Git 中存储的另外一个重要的对象：`tree`

### tree object

`tree` 对象记录了我们的文件结构，更形象的说法是，某个 `tree` 对象记录了某个文件夹的结构，包含文件以及子文件夹。`tree` 对象的名称也是一个40位的哈希值，文件名依据内容生成，因此如果一个文件夹中的结构有所改变，在 `.git/object/` 中就会出现一个新的 `tree object`

```
wujunnan@localhost test % git cat-file -p 6139
100644 blob a5bce3fd2565d8f458555a0c6f42d0504a848bd5	a.txt
040000 tree 9a18347eb049876e2855d88b091b6516dea58de7	test
```

我们可以看到，`tree` 中包含两种类型的文件，`tree` 和 `blob`，这就把文件有序的组合起来了，如果我们知道了根 `tree`（可以理解为`root`文件夹对应的`tree`），我们就有能力依据此`tree`还原整个工作区。

### commit object

我们知道，`commit`记录了我们的提交历史，存储着提交时的 message，Git 分支中的一个个的节点也是由 commit 构成。一个典型的 `commit object` 内容如下：

```
wujunnan@localhost test % git cat-file -p e8ab
tree 61392b81b60bae1f732e1b08fb5fdfcb4c36d74e
author wujunnan <“mr.wujunnan@qq.com”> 1603189020 +0800
committer wujunnan <“mr.wujunnan@qq.com”> 1603189020 +0800

第一次commit
```

我们来看看其中每一项的意义：

- `tree`:告诉我们当前 `commit` 对应的根 `tree`,依据此值我们还原此 `commit` 对应的工作区；
- `parent`:父 `commit` 的 hash 值，依据此值，我们可以记录提交历史；
- `author`:记录着此`commit`的修改内容由谁修改；
- `committer`:记录着当前 commit 由谁提交；
- `...bc`: `commit message`;

### references

`References` 对象存储在`/git/refs/`文件夹下，该文件夹结构如下:

```
wujunnan@localhost test % tree .git/refs
.git/refs
├── heads
│   ├── master
│   ├── dev
│   └── ...
├── remotes
│   ├── origin
│   │   ├── ANDROIDBUG-4845
│   │   ├── ActivityCard-za
│   │   ├── ...
├── stash
└── tags
```

heads记录的是本地所有分支，如master等，remotes和HEAD一样，指向**对应的某个远程分支**

```
wujunnan@localhost test % test % cat .git/refs/heads/master
501b5918ce6755eea19476ac6a89f214921b498e
```

master里面就是**commit节点的hash值**

再看看 `.git/refs` 文件夹中其它的内容：

- `.git/refs/remotes` 中记录着远程仓库分支的本地映射，其内容只读；

- `.git/refs/stash` 与 `git stash` 命令相关，后文会详细讲解；
- `.git/refs/tag`, 轻量级的tag，与 `git tag` 命令相关，它也是一个指向某个`commit` 对象的指针；

### tag objects

- lightweight tags，轻量标签很像一个不会改变的分支，其内容是对一个特定提交的引用，这种 tag 存储在`.git/refs/tag/`文件夹下；
- annotated tags： 声明式的标签会在object下添加`tag object`，此种 tag 能记录更多的信息；

```
# lightweight tags
$ git tag 0.1
# 指向添加tag时的commit hash值
➜ cat 0.1 
e9f249828f3b6d31b895f7bc3588df7abe5cfeee

# annotated tags
$ git tag -a -m 'Tagged1.0' 1.0
➜ git cat-file -p 52c2
object e9f249828f3b6d31b895f7bc3588df7abe5cfeee
type commit
tag 1.0
tagger zhangwang <zhangwang2014@iCloud.com> 1521625083 +0800

Tagged1.0
```

对比可以发现，声明式的 tag 不仅记录了对应的 commit ,标签号，额外还记录了打标签的人，而且还可以额外添加 `tag message`（上面的`-m 'Tagged1.0'`）。

## 常见git命令与上述资源间的映射

### git基础

#### git init

`git init`：在当前文件夹下新建一个本地仓库，在文件系统上表现为在当前文件夹中新增一个 `.git` 的隐藏文件夹

#### git add

- `git add file1 file2 file3`将多个文件添加到暂存区

- `git add .`

  `git add --all`将所有文件加入暂存区

- `git config/*`添加config目录下的所有文件

  `git home/*.java`将home目录下的所有java文件添加

`git add [file]`，**这个命令会依次做下面两件事情**：

1. 在 `.git/object/` 文件夹中添加修改或者新增文件对应的 `blob` 对象；
2. 在 `.git/index`文件夹中写入该文件的名称(file01.md)及对应的 `blob` 对象名称(72943a16fb2c8f38f9...)

很多地方会说，git 命令操作的是三棵树。三棵树对应的就是上图中的工作区( working directory )、缓存区( Index )、以及 HEAD。

`HEAD` 其实是一个指针，指向最近的一次 commit 对象

`Index` 就是我们说的缓存区了，它是下次 commit 涉及到的所有文件的列表

**注意：**我们所说的缓存区并不是一个文件夹，而是一个Index文件，里面有

`git ls-files -s` 可以查看所有位于`.git/index`中的文件

```
wujunnan@wujunnandeMacBook-Pro test01 % git ls-files -s          
100644 ca5d0e6e71945129431efcf086d0e96e397046d8 0	.DS_Store
100644 72943a16fb2c8f38f9dde202b7a70ccc19c52f34 0	file01.md
100644 f761ec192d9f0dca3329044b96ebdb12839dbff6 0	test/file02.md
```

其中各项的含义如下：

- `100644`： `100`代表regular file，`644`代表文件权限
- `8baef1b4abc478178b004d62031cf7fe6db6f903`：blob对象的名称；
- `0`：当前文件的版本，如果出现冲突，我们会看到`1`，`2`；
- `data/d.txt`: 该文件的完整路径
  Git 还额外提供了一个命令来帮我我们查看文件在这三棵树中的状态，`git status`。

#### git status

`git status`有三个作用：

1. 查看当前所在分支；
2. 列出已经缓存，未缓存，未追踪的文件（依据上文中的三棵树生成）；
3. 给下一步的操作一定的提示；

#### git commit

对应到文件层面，`git commit`做了如下几件事情：

1. 新增`tree`对象，有多少个修改过的文件夹，就会添加多少个`tree`对象；
2. 新增`commit`对象，其中的的`tree`指向最顶端的tree，此外还包含一些其它的元信息，`commit`对象中的内容，上文已经见到过， `tree`对象中会包含一级目录下的子`tree`对象及`blob`对象，由此可构建当前commit的文档快照；
3. 同时当前分支(head指向的分支)指向最新的commit对象

![commit后_git文件夹里发生了什么](git%E5%8E%9F%E7%90%86_assets/commit%E5%90%8E_git%E6%96%87%E4%BB%B6%E5%A4%B9%E9%87%8C%E5%8F%91%E7%94%9F%E4%BA%86%E4%BB%80%E4%B9%88.png)

#### git rm

```
rm test.txt
```

rm删除工作区的文件

rm 命令只是删除工作区的文件，并没有删除版本库的文件，想要删除版本库文件还要执行下面的命令：

```
$ git add test.txt
$ git commit -m "delete test"
```

**git rm **

删除工作区文件，并且将这次删除放入暂存区。要删除的文件是没有修改过的，就是说和当前版本库文件的内容相同。

**git rm -f **

删除工作区和暂存区文件，并且将这次删除放入暂存区。**要删除的文件已经修改过，就是说和当前版本库文件的内容不同。**

**git rm --cached**

删除暂存区文件，但保留工作区的文件，并且将这次删除放入暂存区

然后提交

```
$ git commit -m "delete test"
```

成功删除了版本库文件。



要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。 可以用 `git rm` 命令完成此项工作，并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清单中了

如果只是简单地从工作目录中手工删除文件，运行 `git status` 时就会在 “Changes not staged for commit” 部分（也就是 *未暂存清单*）看到：

```
$ rm PROJECTS.md
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        deleted:    PROJECTS.md

no changes added to commit (use "git add" and/or "git commit -a")
```

也就是执行了add操作后，又将其删除，再次commit就会出错

然后再运行 `git rm` 记录此次移除文件的操作：

```console
$ git rm PROJECTS.md
rm 'PROJECTS.md'
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    deleted:    PROJECTS.md
```

下一次提交时，该文件就不再纳入版本管理了。  如果要删除之前修改过或已经放到暂存区的文件，则必须使用强制删除选项 `-f`（译注：即 force 的首字母）。 这是一种安全特性，用于防止误删尚未添加到快照的数据，这样的数据不能被 Git 恢复。

另外一种情况是，我们想把文件从 Git 仓库中删除（亦即从暂存区域移除），但仍然希望保留在当前工作目录中。 换句话说，你想让文件保留在磁盘，但是并不想让 Git 继续跟踪。 当你忘记添加 `.gitignore` 文件，不小心把一个很大的日志文件或一堆 `.a` 这样的编译生成文件添加到暂存区时，这一做法尤其有用。

为达到这一目的，使用 `--cached` 选项：

```console
$ git rm --cached README
```

`git rm` 命令后面可以列出文件或者目录的名字，也可以使用 `glob` 模式。比如：

```console
$ git rm log/\*.log
```

注意到星号 `*` 之前的反斜杠 `\`， 因为 Git 有它自己的文件模式扩展匹配方式，所以我们不用 shell 来帮忙展开。 此命令删除 `log/` 目录下扩展名为 `.log` 的所有文件。 类似的比如：

```console
$ git rm \*~
```

该命令会删除所有名字以 `~` 结尾的文件。

#### git mv

 要在 Git 中对文件改名，可以这么做：

```console
$ git mv file_from file_to
```

它会恰如预期般正常工作。 实际上，即便此时查看状态信息，也会明白无误地看到关于重命名操作的说明：

```console
$ git mv README.md README
$ git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

    renamed:    README.md -> README
```

其实，运行 `git mv` 就相当于运行了下面三条命令：

```console
$ mv README.md README
$ git rm README.md
$ git add README
```

如此分开操作，Git 也会意识到这是一次重命名，所以不管何种方式结果都一样。 两者唯一的区别是，`mv` 是一条命令而非三条命令，直接用 `git mv` 方便得多。



### 建立使用分支

#### git branch

前文我们提到过，分支在本质上仅仅是「指向commit对象的可变指针」，其内容为一个commit对象的SHA-1 值，所以分支的创建和销毁都异常高效

使用 `git branch [newBranchName]` 可以创建新分支 `newBranchName`。不过一个更常见的用法是`git checkout -b [newBranchName]`，此命令在本地创建了分支 `newBranchName`，并切换到了分支 `newBranchName`。

HEAD 也可以看做一个指向当前所在的本地分支的特殊指针

存在两种分支，本地分支和远程分支

本地分支：

对应存储在`.git/refs/heads`中；

还存在一种叫做「跟踪分支」(也叫「上游分支」)的本地分支，此类分支从一个远程跟踪分支检出，是与远程分支有直接关系的本地分支。 如果在一个跟踪分支上输入 git pull，Git 能自动地识别去那个远程仓库上的那个分支抓取并合并代码

`.git/config`文件中信息进一步指明了远程分支与本地分支之间的关系：

```
➜ cat .git/config
...
[remote "origin"]
	url = git@git.in.zhihu.com:zhangwang/zhihu-lite.git
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
[remote "wxa"]
	url = https://git.in.zhihu.com/wxa/zhihu-lite.git
	fetch = +refs/heads/*:refs/remotes/wxa/*
```

`git status` 命令的输出十分详细，但其用语有些繁琐。 Git 有一个选项可以帮你缩短状态命令的输出，这样可以以简洁的方式查看更改。 如果你使用 `git status -s` 命令或 `git status --short` 命令，你将得到一种格式更为紧凑的输出。

```console
$ git status -s
 M README
MM Rakefile
A  lib/git.rb
M  lib/simplegit.rb
?? LICENSE.txt
```

新添加的未跟踪文件前面有 `??` 标记，新添加到暂存区中的文件前面有 `A` 标记，修改过的文件前面有 `M` 标记。 输出中有两栏，左栏指明了暂存区的状态，右栏指明了工作区的状态。例如，上面的状态报告显示： `README` 文件在工作区已修改但尚未暂存，而 `lib/simplegit.rb` 文件已修改且已暂存。 `Rakefile` 文件已修，暂存后又作了修改，因此该文件的修改中既有已暂存的部分，又有未暂存的部分。

#### git checkout

git checkout` 实际上就是在操作`HEAD

Git 中有一个比较难理解的概念叫做「HEAD分离」，映射到文件层面，其实指的是 `.git/HEAD` 直接指向某个`commit`对象。

我们来看`git checkout`的具体用法

1. `git checkout <file>`

   其操作为恢复文件`<file>`的内容为，HEAD对应的快照时的内容

2. `git checkout <branch>`

   修改 `.git/HEAD` 中的内容为 `<branch>`

   更新工作区内容为 `<branch>` 所指向的 `commit` 对象

   ```
   ➜ cat .git/HEAD
   ref: refs/heads/master
   ```

3. `git checkout <hash|tag>`

   HEAD直接指向一个`commit`对象，更新工作区内容为该`commit`对象对应的快照，此时为`HEAD`分离状态，切换到其它分支或者新建分支`git branch -b new-branch`|| `git checkout branch`可以使得`HEAD`不再分离

   ```
   ➜ cat .git/HEAD
   8e1dbd367283a34a57cb226d23417b95122e5754
   ```

```
commit ef96b7209cfce4d4402afa0bf2080a3548ffa4f8 (HEAD -> dev)
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 21:05:52 2020 +0800

    第三次修改——支线

commit c223b9bc871e4587d165d2bd525ab7ade6110a75 (master)
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 20:59:36 2020 +0800

    第二次修改——主线

commit e8ab8a1e4707a0939e6d59af3c04a9c621a30819
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 18:17:00 2020 +0800

    第一次commit
```

### 分支的合并

#### git merge

Git 中分支合并有两种算法，快速向前合并和三路合并

**快速向前合并：**

此种情况下，**主分支没有改动**，因此在基于主分支生成的分支上做的更改，一定不会和主分支上的代码冲突，可以直接合并，在底层相当于修改`.refs/heads/` 下主分支的内容为最新的 commit 对象。

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-0a0431c992211561f14ee66f1cf0ea89_b.webp)

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-0a0431c992211561f14ee66f1cf0ea89_b.webp)



**三路合并：**

新的feature分支在开发过程中，主分支上的代码也做了修改并添加了新的 commit ，此时合并，需要对比 feature 分支上最新的 commit，feature 分支的 base commit 以及 master 分支上最新的 commit 这三个commit的快照。如果一切顺利，这种合并会生成新的合并 commit ，格式如下：

```
➜ git cat-file -p 43cfbd24b7812b7cde0ca2799b5e3305bd66a9b3
tree 78f3bc25445be087a08c75ca62ca1708a9d2e33a
parent 51b45f5892f640b8e9b1fec2f91a99e0d855c077
parent 96e66a5b587b074d834f50d6f6b526395b1598e5
author zhangwang <zhangwang2014@iCloud.com> 1521714339 +0800
committer zhangwang <zhangwang2014@iCloud.com> 1521714339 +0800

Merge branch 'feature'
```

和普通的 commit 对象的区别在于其有两个`parent`，分别指向被合并的两个`commit`

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-d5be0dfa20f8a7c57f99f2b48b521bda_b.webp)

不过三路合并往往没有那么顺利，往往会有冲突，此时需要我们解决完冲突后，再合并，三路合并的详细过程如下（为了叙述便利，假设合并发生在 master 分支与 feature 分支之间）：

1. Git 将*接收 commit* 的哈希值写入文件 `.git/MERGE_HEAD`。此文件的存在说明 Git 正在做合并操作。(记录合并提交的状态)
2. Git 查找 *base commit*：被合并的两个分支的第一个共有祖先 commit
3. Git 基于 *base commit*、*master commit* 和 *feature commit* 创建索引；
4. Git 基于 *base commit — master commit* 和*base commit — feature commit* 分别生成 diff，diff 是一个包含文件路径的列表，其中包含添加、移除、修改或冲突等变化;
5. Git 将 diff 应用到工作区;
6. Git 将 diff 应用到 index，如果某文件有冲突，其在index中将存在三份;
7. 如果存在冲突，需要手动解决冲突
8. `git add` 以更新 index 被提交, `git commit`基于此 index 生成新的`commit`;
9. 将主分支`.git/refs/heads/master`中的内容指向第8步中新生成的 `commit`，至此三路合并完成;

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-2a8ce9f5e3f32b399cca693f38418e65_b-20201020214611307.webp)

```
wujunnan@MacbookPro test % git log 
commit e28f209d9d5975c714559e87f284b3fa3a6ed3b1 (HEAD -> master)
Merge: fd5b3c1 ef96b72
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 21:31:02 2020 +0800

    处理冲突后再次提交

commit fd5b3c1fab7c92bd9f4ebf45bf6e537f4e8c8af1
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 21:10:48 2020 +0800

    第二次主线修改

commit ef96b7209cfce4d4402afa0bf2080a3548ffa4f8 (dev)
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 21:05:52 2020 +0800

    第三次修改——支线

commit c223b9bc871e4587d165d2bd525ab7ade6110a75
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 20:59:36 2020 +0800

    对a.txt进行第二次修改

commit e8ab8a1e4707a0939e6d59af3c04a9c621a30819
Author: wujunnan <“mr.wujunnan@qq.com”>
Date:   Tue Oct 20 18:17:00 2020 +0800

    第一次commit
```

##### merge详解

git merge是用于从指定的commit(s)合并到当前分支的操作

```
这里的指定commit(s)是指从这些历史commit节点开始，一直到当前分开的时候
```

![image-20201113193528823](git%E5%8E%9F%E7%90%86_assets/image-20201113193528823.png)

那么`git merge topic`命令将会把在master分支上二者共同的节点（E节点）之后分离的节点（即topic分支的A B C节点）重现在master分支上，直到topic分支当前的commit节点（C节点），并位于master分支的顶部。并且沿着master分支和topic分支创建一个记录合并结果的新节点，该节点带有用户描述合并变化的信息。

![image-20201113193636531](git%E5%8E%9F%E7%90%86_assets/image-20201113193636531.png)



**fast-forward合并**

通常情况下分支合并都会产生一个合并节点，但是在某些特殊情况下例外。例如调用git pull命令更新远端代码时，如果本地的分支没有任何的提交，那么没有必要产生一个合并节点。这种情况下将不会产生一个合并节点，HEAD直接指向更新后的顶端代码，这种合并的策略就是fast-forward合并。





#### git rebase

**变基**

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-6b8427b4baf6cdfb08b852ab1cdb4941_b.webp)

```
我们刚看到可通过执行 git merge 将一个分支的修改应用到另一个分支。另一种可将一个分支的修改融入到另一个分支的方式是执行 git rebase。

git rebase 会将当前分支的提交复制到指定的分支之上。

变基与合并有一个重大的区别：Git 不会尝试确定要保留或不保留哪些文件。我们执行 rebase 的分支总是含有我们想要保留的最新近的修改！这样我们不会遇到任何合并冲突，而且可以保留一个漂亮的、线性的 Git 历史记录。

上面这个例子展示了在 master 分支上的变基。但是，在更大型的项目中，你通常不需要这样的操作。git rebase 在为复制的提交创建新的 hash 时会修改项目的历史记录。

如果你在开发一个 feature 分支并且 master 分支已经更新过，那么变基就很好用。你可以在你的分支上获取所有更新，这能防止未来出现合并冲突。

完美，现在我们在 dev 分支上获取了 master 分支上的所有修改。
```

### git cherry-pick

**拣选**

`git cherry-pick`做的事情是将一个或者多个commit应用到当前commit的顶部，复制commit，会保留对应的二进制文件，但是会修改`parent`信息。

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-486f540aaf172d27349c217f87e9fba8_b.webp)

```
当一个特定分支包含我们的活动分支需要的某个提交时，我们对那个提交执行 cherry-pick！对一个提交执行 cherry-pick 时，我们会在活动分支上创建一个新的提交，其中包含由拣选出来的提交所引入的修改。

假设 dev 分支上的提交 76d12 为 index.js 文件添加了一项修改，而我们希望将其整合到 master 分支中。我们并不想要整个 dev 分支，而只需要这个提交！

现在 master 分支包含 76d12 引入的修改了。
```

### 版本回滚

#### git revert

**还原（Reverting）**

git revert 命令本质上就是一个逆向的 git cherry-pick 操作。 它将你提交中的变更的以完全相反的方式的应用到一个新创建的提交中，本质上就是撤销或者倒转。

```
另一种撤销修改的方法是执行 git revert。通过对特定的提交执行还原操作，我们会创建一个包含已还原修改的新提交。

假设 ec5be 添加了一个 index.js 文件。但之后我们发现其实我们再也不需要由这个提交引入的修改了。那就还原 ec5be 提交吧！

完美！提交 9e78i 还原了由提交 ec5be 引入的修改。在撤销特定的提交时，git revert 非常有用，同时也不会修改分支的历史。
```

![git%E6%93%8D%E4%BD%9C_assets](git%E5%8E%9F%E7%90%86_assets/v2-381df5ae9b3d97906e9235f3723f84a8_b.webp)

#### git reset

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

### 代码暂存

#### git stash

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

### git clean

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