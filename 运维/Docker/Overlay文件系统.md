# Overlay文件系统

OverlayFS是一种堆叠文件系统，它依赖并建立在其他文件系统之上，并不直接参与磁盘空间结构的划分，仅仅将原来底层文件系统中不同的目录进行合并，然后向用户呈现，这就是联合挂载技术。

Docker使用overlay文件系统来构建和管理镜像与容器的磁盘结构。

Linux内核为Docker提供的OverlayFS驱动有两种，overlay和overlay2，overlay2是相对于overlay的一种改进，在inode利用率方面比overlay更有效。

OverlayFS通过三个目录实现：

- lower目录
- upper目录
- work目录

当lower和upper目录里有相同的文件及相同的文件夹，合并到merged目录的时候显示规则如下：

- 文件名及目录名不相同的时候，直接将lower和upper目录里相同的文件，合并到merged目录
- 文件名相同的时候，只显示upper的，而将lower的隐藏
- 目录名相同的时候，对目录进行合并成一个目录，内部有相同的文件，则只显示upper的文件

overlay只支持两层，upper文件系统通常是可写的，lower文件系统则是只读的，这就表示着，当我们对overlay文件系统做任何更改都只会修改upper文件系统中的文件。

lower层是只读的，所以无论对lower上文件和目录做任何操作都不会对lower做变更，所有变更操作都对upper做。

镜像在下载的时候，每一层的镜像都会有自己的id，每个镜像都会有自己的目录，保存在`/var/lib/docker/overlay`目录下。

启动一个容器的时候，也在这个目录下产生一个层目录，进入到目录可以看到有三个文件夹，分别是merged、upper、work和一个文件lower-id，而在lower-id中保存的就是镜像最上层id，所以对于容器来说，还是一个两层的文件系统。

overlay两层对应的就是docker的镜像层（只读）和容器层（可写），只是把原来AUFS的多层镜像合并成了lower层，而upper层代表的是容器层。



我们假设一个镜像文件的大小是 500MB，启动 100 个容器的话，就需要下载 500MB*100= 50GB 的文件，并且占用 50GB 的磁盘空间，这明显不现实嘛。

从图中可以看到所有APP都共用"ubuntu:18.04"发行版文件系统，这样如果一个镜像文件的大小是 500MB，操作系统是400M，APP是100M的话，100个容器，就只需要 400MB + 100MB * 100 = 1G400M左右，是远远小于50GB。

UnionFS 有很多种，Docker 目前支持的联合文件系统包括 `OverlayFS`, `AUFS`, `Btrfs`, `VFS`, `ZFS` 和 `Device Mapper`。它的厉害之处在于可以将多个目录挂载到一个根目录。我机器上用的是OverlayFS.

在 Linux 内核 3.18 版本中，OverlayFS 代码正式合入 Linux 内核的主分支。在这之后，OverlayFS 也就逐渐成为各个主流 Linux 发行版本里默认使用的容器文件系统了。



镜像是分层的，通过镜像的层级结构主要的一个优点是你可以把你的基础镜像进行共享，什么意思呢？比如你现在需要一个Nginx镜像、一个Tomcat镜像它们都可以通过一个base镜像如centos或者ubuntu制作而成，它看起来是这样的

## References

1. https://blog.51cto.com/u_15060545/2652666
2. https://blog.csdn.net/a985588764/article/details/101024357
3. https://blog.csdn.net/weixin_42445065/article/details/123686614
4. https://zhuanlan.zhihu.com/p/458409783