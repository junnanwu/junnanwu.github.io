# git clone

**格式**

```
git clone <版本库的网址> [目标文件夹]
```

`<url>`部分支持四种协议：本地协议（Local），HTTP 协议，SSH（Secure Shell）协议及 Git 协议

```
$ git clone git://github.com/schacon/ticgit.git
```

默认情况下会把clone的源仓库取名`origin`，在`.git/config`中存储其对应的地址，本地分支与远程分支的对应规则等。

## 参数

- `-o name --origin name`

  使用其他远程主机名，而不是默认的origin。

- `--bare`

  创建一个`xxx.git`裸仓库，没有工作目录，相当于正常clone目录的`.git`文件夹里面的东西。

- `--mirror`

  相当于裸库的基础上，同时clone了ref下的所有内容，包括其他远程分支，适合在迁移数据库ß的场景下使用。

## 裸库

裸库没有工作目录，所以不能进行一般的`add`、`commit`操作，一般是作为其他仓库的远程库，使用`push`操作进行推送。

## References

1. https://stackoverflow.com/questions/3959924/whats-the-difference-between-git-clone-mirror-and-git-clone-bare