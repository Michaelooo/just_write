![](http://ww1.sinaimg.cn/large/86c7c947gy1fnqmycqqxhj20xc0hi0tb.jpg)

# **关于 git 你应该知道的操作**

## **git 的使用工具**

首先有两个 可视化工具推荐 ：

* [gitkraken](https://www.gitkraken.com/features)
一个新出的广受好评的git 可视化工具。有付费。
* [sourcetree](https://www.sourcetreeapp.com/)
一直在用，就是注册麻烦，需要翻墙。免费。

个人在用第二个，sourcetree 日常使用可以说是hin方便了。当然，不想额外下软件的还可以使用 vscode 内置的 git 管理工具，同样的也是棒棒的。

### v**scode 的git插件**

当然我也在使用 vscode ，除了 vscode 自带的 git 支持，还可以安装以下的插件来更好的使用git：

* **Git Lens** 官推的 git 插件，几乎该有的都有了，最强大的就是可以查看具体代码的具体变更,就像下面的这样：
![](http://ww1.sinaimg.cn/large/86c7c947gy1fnqmw9ig2vj210u062jsa.jpg)
上一个让我感觉这么厉害的还是 visual studio 的内部集成的版本控制功能，但是 visual studio 实在是太大了。不过这个插件美中不足的就是查看历史实在是太丑了，所以有了下面的这个插件。
* **git history** 没毛病，这个插件就是让你的 提交历史 可以很直观的展示出来。

不过，无论怎么说，git 原生命令还是要了解的，对学习和理解 git 的工作机制会很有帮助，当然对提升逼格也有成效。so,下面的部分主要是针对于 git 命令行的一些快捷操作。

### **Mac下不可以使用的问题**
```error: xcrun:error invalid actiive ... missing xcrun at ...```

出现的原因是 git 依赖这个 xcode 的这个工具，所以要更新，一般会在更新系统之后出现。
解决办法就是：

```
sudo xcode-select --install
```
等待安装完成之后就可以了。

## **git 命令行的一些骚操作**

下面总结一些 git 命令中可以快速提高效率和提升幸福度的操作。

### **git配置别名**

可以直接使用命令行修改全局配置，

```
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

也可以通过 vim 更改配置文件来操作。

```
vi ~/.gitconfig
source ~/.gitconfig
```

两者的效果是一致的，可以通过 `git config --list` 查看添加的配置是否存在。 

该部分总结自 [廖雪峰：git——配置别名](https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/001375234012342f90be1fc4d81446c967bbdc19e7c03d3000)。

### **（踩坑）常用的回退（救命）操作**

如果你已经提交到暂存区了，你可以：

* 撤销上次提交 
`git reset --hard '指定的记录'`

如果你想放弃本地修改，你可以：

* 检出本地
`git checkout 'branch'`

如果你想修改上一次的提交信息，你可以：

* 修改最后的一次提交
`git commit --amend`

如果你在排查问题的时候，你可以
* 使用 `git fetch` 替换 `git pull`, 因为`git pull = git fetch + merge local`

### **（踩坑）git 上传文件忽略大小写**

好的约定其实比技术本身更重要，所以尽可能统一规范大小写，从而避免修改默认的配置。

```
git config core.ignorecase false
git config --global core.ignorecase false // 全局设置
```

### **git comment 添加规范**

```
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

总结自 [阮一峰： Commit message 和 Change log 编写指南](http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html)。

### **git comment 添加表情**

看到别人的comment history有那么多的卡哇伊的表情，是不是很羡慕，现在自己也可以做到。只需要在comment加入`:apple:`这样的代码，测试`GitHub`和`Gitlab`是可用的
```
git commit -m ':apple: i have a apple'
```

**表情列表如下：**


emoji                                   | emoji 代码                   | commit 说明
:--------                               | :--------                    | :--------
:art: (调色板)                          | `:art:`                      | 改进代码结构/代码格式
:zap: (闪电)<br>:racehorse: (赛马)                            | `:zap:`<br>`:racehorse:`                      | 提升性能
:fire: (火焰)                           | `:fire:`                     | 移除代码或文件
:bug: (bug)                             | `:bug:`                      | 修复 bug
:ambulance: (急救车)                    | `:ambulance:`                | 重要补丁
:sparkles: (火花)                       | `:sparkles:`                 | 引入新功能
:memo: (备忘录)                         | `:memo:`                     | 撰写文档
:rocket: (火箭)                         | `:rocket:`                   | 部署功能
:lipstick: (口红)                       | `:lipstick:`                 | 更新 UI 和样式文件
:tada: (庆祝)                           | `:tada:`                     | 初次提交
:white_check_mark: (白色复选框)         | `:white_check_mark:`         | 增加测试
:lock: (锁)                             | `:lock:`                     | 修复安全问题
:apple: (苹果)                          | `:apple:`                    | 修复 macOS 下的问题
:penguin: (企鹅)                        | `:penguin:`                  | 修复 Linux 下的问题
:checkered_flag: (旗帜)                 | `:checked_flag:`             | 修复 Windows 下的问题
:bookmark: (书签)                       | `:bookmark:`                 | 发行/版本标签
:rotating_light: (警车灯)               | `:rotating_light:`           | 移除 linter 警告
:construction: (施工)                   | `:construction:`               | 工作进行中
:green_heart: (绿心)                    | `:green_heart:`              | 修复 CI 构建问题
:arrow_down: (下降箭头)                 | `:arrow_down:`               | 降级依赖
:arrow_up: (上升箭头)                   | `:arrow_up:`                 | 升级依赖
:construction_worker: (工人)            | `:construction_worker:`      | 添加 CI 构建系统
:chart_with_upwards_trend: (上升趋势图) | `:chart_with_upwards_trend:` | 添加分析或跟踪代码
:hammer: (锤子)                         | `:hammer:`                   | 重大重构
:heavy_minus_sign: (减号)               | `:heavy_minus_sign:`         | 减少一个依赖
:whale: (鲸鱼)                          | `:whale:`                    | Docker 相关工作
:heavy_plus_sign: (加号)                | `:heavy_plus_sign:`          | 增加一个依赖
:wrench: (扳手)                         | `:wrench:`                   | 修改配置文件
:globe_with_meridians: (地球)           | `:globe_with_meridians:`     | 国际化与本地化
:pencil2: (铅笔)                        | `:pencil2:`                  | 修复 typo



## **写在最后**

骚操作那么多，肯定不止上面那些，所以本文还是会持续更新的。

最后，希望你和 git 过的幸福。