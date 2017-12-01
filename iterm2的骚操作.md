# iterm2的一些操作


## 存取一行 为session
* `cmd + shift + m`  指定位置设置session点
* `cmd + shift + k`  快速定位到指定位置
* `cmd + shift + 上、下` 如果存在多个定位点，可以通过此命令切换

## 自动填充提示
* `cmd + ;`  输入提示
* `cmd + shift + h`    提示最近的操作记录

## 命令时间轴
* `cmd + option + b` 打开时间轴

## 管理窗口
使用[itermocil](https://github.com/TomAnthony/itermocil) 来管理窗口,可以进行简单的配置来存储窗口布局，但是在使用过程中发现并不是特别好用，一些命令并不支持。所以并没有深入研究。

所以最后还是选择了用远程的`arragment`来管理，勉强满足需求吧，主要是懒得折腾。

## 使用code打开
网上有看到一种修改bash的方法：

```
vim ~/.bash_profile
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH
#保存退出
source ~/.bash_profile
code . #当前目录就被打开了。
```
但是尝试了，上面可能会有些问题，每次重启打开就不可用。下面的方法可用

在vscode 中快捷键 `shift + command + p` 输入 code ,选择安装code 命令。重启ok
