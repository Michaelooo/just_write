## git 可视化工具
* `gitkraken`
一个新出的广受好评的git 可视化工具。[gitkraken](https://www.gitkraken.com/features)
* `sourcetree`
一直在用，就是注册麻烦，需要翻墙

## Mac下不可以使用的问题
```error: xcrun:error invalid actiive ... missing xcrun at ...```

出现的原因是 git 依赖这个 xcode 的这个工具，所以要更新，一般会在更新系统之后出现。
解决办法就是：
`sudo xcode-select --install`
等待安装完成之后就可以

## git别名

```

vi ~/.gitconfig

git config --list

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.unstage 'reset HEAD'
git config --global alias.last 'log -1'
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```
## 基本回退操作
* 撤销上次提交 
`git reset --hard '指定的记录'`

* 修改最后的一次提交
`git commit --amend`

## git comment 添加表情
看到别人的comment history有那么多的卡哇伊的表情，是不是很羡慕，现在自己也可以做到。只需要在comment加入`:apple:`这样的代码，测试`GitHub`和`Gitlab`是可用的
```
git commit -m ':apple: i have a apple'
```

## git 上传文件忽略大小写

```
git config core.ignorecase false
```

### 表情列表如下：


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