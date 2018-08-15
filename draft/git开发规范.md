在团队开发中，团队协作是比埋头编程更值得去深入的东西。一套好的开发流程（规范）可以避免很多不必要的麻烦，现在大部分的公司都使用 git 来进行代码管理，这里结合个人工作中的所得以及个人使用中经常遇到的坑，做个简单的总结。

对于 git 的编程规范来说，其实 **[git-flow]( <https://www.git-tower.com/learn/git/ebook/cn/command-line/advanced-topics/git-flow>)**  就是一套好的编程规范，它对工作中的 git 事务性的操作做了一个封装，在团队还不具有一定的规模化的情况下，使用 **git-flow** 是一个不错的选择。如关于常用分支的定义，就可以参考 **git-flow** 的思想：

>  **master** 只能用来包括产品代码。你不能直接工作在这个 master 分支上，而是在其他指定的，独立的特性分支中（这方面我们会马上谈到）。不直接提交改动到 master 分支上也是很多工作流程的一个共同的规则。

> **develop** 是你进行任何新的开发的基础分支。当你开始一个新的功能分支时，它将是 开发 的基础。另外，该分支也汇集所有已经完成的功能，并等待被整合到 master 分支中。

但是当团队有了一定的规模化的时候，要求所有成员再去学习 git-flow 的使用，这样的成本也是很高的，所以这时候我们倾向于使用原生的命令来操作。

下面是我总结的在工作常用的场景下，对 git 的一些操作。

## 开发一个新的功能时

比较好的开发规范就是，当你开发一个新的需求时，应该按照下面的流程进行开发：

**第一步：基于 develop 新建一个人分支** 

```shell
git checkout -b "new-branch"
```

**第二步：同步个人分支至远程仓库**

```shell
git push --set-upstream origin "new-branch"
```

使用 `--set-upstream` 的目的是跟踪远程分支。后面执行命令时可以省掉指定源的操作，如：

``` shell
git pull origin test => git pull 
git push origin test => git push
```



**第三步：功能开发完成后，发送 merge 请求**

`master` 分支和 `develop` 分支应该被保护，只有稳定的版本才可以允许合并操作。合并的方式因团队而异，常规的流程是找到具有`develop` 分支开发权限的成员，执行：

```shell
git checkout develop
git merge "new-branch"
```

如果你的团队使用 gitlab 进行管理，就可以发送一个由 `new-branch` 到 `develop` 分支的 **merge request** 。

## 如何写好一个 git comment

不应当出现语义模糊或毫无意义的 comment 描述。每个团队都要有自己的 comment 规范，当然也可以直接用大家都已经接受了的

```shell
feat：新功能（feature）
fix：修补bug
docs：文档（documentation）
style： 格式（不影响代码运行的变动）
rebuild：重构（即不是新增功能，也不是修改bug的代码变动）
test：增加测试
chore：构建过程或辅助工具的变动
config: 配置

example: git commit -m "[feat] 新功能"
```

以上总结自： [阮一峰： Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)]

如果你很皮，想加个开源库类似 comment 的表情，你可以执行：

```shell
git commit -m ':apple: i have a apple'
```

苹果就出来了，更多表情代码可以点 [这里](https://github.com/Michaelooo/just_write/blob/master/archived/%E5%85%B3%E4%BA%8Egit%2C%E4%BD%A0%E5%BA%94%E8%AF%A5%E7%9F%A5%E9%81%93%E7%9A%84%E6%93%8D%E4%BD%9C.md#git-comment-%E6%B7%BB%E5%8A%A0%E8%A1%A8%E6%83%85)。

## 做一个 hotfix 时

**Hotfix** 是为了应对已上线的产品代码出现的问题出现的紧急修复，所以和开发新功能的流程略有不同。 **Hotfix** 显而易见是基于 **master** 分支的。但实际的操作步骤和上面是一样的，这里不再赘述。

## 分支切换遇到问题时

这里的问题往往是：**使用 checkout 切换分支时遇到的冲突**，或者是 **分支切换的时候遇到尚未添加至暂存区的代码**。对于这两个问题，前者往往很容易解决，解决掉冲突，重新 checkout 就好。后者的话就有些头疼，假如你的源分支已经有了自己大量的神仙逻辑代码，所以你不想使用 `git add` 将这些文件添加到暂存区，你也不想用 `git reset` 的方式去处理，这时相对比较好的方式就是使用下面的方式:

```shell
git stash -u	暂存，区分与 git add 的暂存
git stash list	列出暂存内容
git stash pop 取回暂存
```

这样就可以畅快自如的切换分支了。很显然，使用 `git satge` 的方式条理也会更加清晰些。



## 怎么去处理构建任务时

这个场景可能与这篇文章不是那么符合。

如上所说，如果使用了 [gitlab](https://about.gitlab.com/) 来管理团队代码，gitlab 所集成的 CI/CD 也是很不错的 devops 的选择，目前的项目团队也在使用，使用工程化的 gitlab.ci 配置文件，来自动化执行测试、编译、构建、部署等一系列的工作，原来部署过程中繁杂的工作变成了 **[如何去写好一个 gitlab.ci 文件？](https://docs.gitlab.com/ee/ci/quick_start/)**。

如果没有使用 gitlab， 同样的，使用 github + [travis.ci](https://travis-ci.org/) 也是比较流行的开源库的实现方案。

另外，在之前的工作中，也有使用过 [TFS](https://visualstudio.microsoft.com/zh-hans/tfs/?rr=https%3A%2F%2Fwww.google.com.hk%2F) 的方式，这个是微软提供的服务，国内用的比较少（收费，价格还挺贵），国外很流行。这个的构建配置比起上面两个要复杂些，但是使用过程还是很舒畅的。



**以上。**