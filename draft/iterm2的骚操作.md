# iterm2的一些骚操作

一些关于 iterm2 必须记住的操作，快起来自然就骚了

## 存取一行 为session
* `cmd + shift + m`  指定位置设置session点
* `cmd + shift + k`  快速定位到指定位置
* `cmd + shift + 上、下` 如果存在多个定位点，可以通过此命令切换

## 自动填充提示
* `cmd + ;`  输入提示
* `cmd + shift + h`    提示最近的操作记录

## 命令时间轴
* `cmd + option + b` 打开时间轴

## 关于行的快速操作

* `cmd + R` 清空当前窗口，等同于 clear
* `ctrl + W` 删除当前行
* 选中即复制，鼠标 **中键** 即粘贴

## 管理窗口布局
使用[itermocil](https://github.com/TomAnthony/itermocil) 来管理窗口,可以进行简单的配置来存储窗口布局，但是在使用过程中发现并不是特别好用，一些命令并不支持。所以并没有深入研究。

所以最后还是选择了用原生的`arragment`来管理，勉强满足需求吧，主要是懒得折腾。

## bash中使用code打开vscode
网上有看到一种修改bash的方法：

```
vim ~/.bash_profile
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH
#保存退出
source ~/.bash_profile
code . #当前目录就被打开了。
```
但是尝试了，上面可能会有些问题，每次重启打开就不可用（可能是目录问题）。下面的方法可用

在vscode 中快捷键 `shift + command + p` 输入 code ,选择安装code 命令。重启ok

## oh-my-zsh 使用插件

下面的这些插件其实是安装了 oh-my-zsh 才会有的插件，官方的插件列表可以在 [这里](https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins-Overview) 查看。

![](http://ww1.sinaimg.cn/large/86c7c947gy1fnkidt5ibpj214y086di0.jpg)

下面是使用方法：

**打开 zsh 配置**

```
vi ~/.zshrc   // 打开 zsh 的配置文件
```

**添加可用的插件**

```
git node z // 空格隔开，可以去插件列表找适合自己的，默认只有一个git
```

**生效配置文件**

```
source ~/.zshrc
```

可以补一个扩展题：[Linux下 bash 配置文件的读取顺序是怎么样的？](http://cn.linux.vbird.org/linux_basic/0320bash_4.php#settings_bashrc)
