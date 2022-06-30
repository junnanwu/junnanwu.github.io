# Git协作

## 分支分类

- master分支，即主分支。任何项目都必须有个这个分支。对项目进行tag或发布版本等操作，都必须在该分支上进行。
- develop分支，即开发分支，从master分支上检出。团队成员一般不会直接更改该分支，而是分别从该分支检出自己的feature分支，开发完成后将feature分支上的改动merge回develop分支。同时release分支由此分支检出。
- release分支，即发布分支，从develop分支上检出。该分支用作发版前的测试，可进行简单的bug修复。如果bug修复比较复杂，可merge回develop分支后由其他分支进行bug修复。此分支测试完成后，需要同时merge到master和develop分支上。
- feature分支，即功能分支，从develop分支上检出。团队成员中每个人都维护一个自己的feature分支，并进行开发工作，开发完成后将此分支merge回develop分支。此分支一般用来开发新功能或进行项目维护等。
- fix分支，即补丁分支，由develop分支检出，用作bug修复，bug修复完成需merge回develop分支，并将其删除。所以该分支属于临时性分支。
- hotfix分支，即热补丁分支。和fix分支的区别在于，该分支由master分支检出，进行线上版本的bug修复，修复完成后merge回master分支，并merge到develop分支上，merge完成后也可以将其删除，也属于临时性分支。

## 提交PR

如果我们是中途加入某个项目，往往我们的开发会建立在已有的仓库之上。如果使用`github`或者`gitlab`,像已有仓库提交代码的常见工作流是

1. `fork`一份主仓库的代码到自己的远程仓库；
2. `clone` 自己远程仓库代码到本地；
3. 添加主仓库为本地仓库的远程仓库，`git remote add ...`，便于之后保持本地仓库与主仓库同步`git pull`；
4. 在本地分支上完成开发，推送本地分支到个人远程仓库某分支`git push`；
5. 基于个人远程仓库的分支向主仓库对应分支提交`MR`,待`review`通过合并代码到主仓库；