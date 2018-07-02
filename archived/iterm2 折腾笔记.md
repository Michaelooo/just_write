# iterm2 折腾笔记

## 以下是废话

> emmm……，这其实不是一篇技术文，因为没有代码、没有逻辑、没有人气，纯粹是小部分人基于逼格的一些尝试（当然具体有没有还要另说），所以就当我胡说八道，值不值得看自己心里琢磨。

起因是这样的，浏览 v2ex 时看到一篇帖子：[看看你们炫酷的命令行界面](https://www.v2ex.com/t/439713?p=2)，回复不多，但是看得我春心荡漾。回复大概是这样子的，

![](http://wx1.sinaimg.cn/mw690/8849a1a4gy1fpk9383mylj20sl0ixq3r.jpg)

或者是这个样子的，

![](https://ws2.sinaimg.cn/large/bb4bb99egy1fpku9yt9f8j211x0lbgms.jpg)

再或者是这个样子的，

![](https://camo.githubusercontent.com/b5d7eb49a30bfe6bdb5706fa3c9be95fe8e5956e/687474703a2f2f67696679752e636f6d2f696d616765732f70396b6e65772e676966)

总之，看的我是蠢蠢欲动。在此之前，我的 terminal 的配色就是简单的 iterm2 + zsh + oh-my-zsh ，设置了简单的颜色主题，其实已经很漂亮了，大致效果是下面这个样子的：

![](http://img.blog.csdn.net/20170725190119447?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvdTAxMzcwNzI0OQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

然而，对比之下，就发现了：我为毛没有图标，简直就是高富帅和穷屌的对比啊！！ 加上之前的配色方案已经用了半年之久（相当的审美疲劳），于是决定果断换掉。

## 划重点（以上是废话）

我喜欢对做每一件事情之前进行调研，研究其充分的可能，然后再做行动。同时，加上我实践之后得出的真知，在这里先画个重点：

1. 只适用于 MacOS。首先 Windows 没有 iterm2(当然也不仅仅是用在 iterm2上面)，其次是因为 macOS 所搭载的平台（MacBook，iMac）都是对高分辨率有强迫症的，所以才会有好的视觉效果，Windows 就暂时先放一放。
2. 好看确实好看，不一定好用。 不好用体现在两个方面，布局和性能。在布局上，或许只有在全屏下才能看到最佳的视觉效果，因为行内有大量的内容区域被占用，大大压榨了可输入区域的大小，虽然有些主题可以设置另起一行来选择输入，但是体验是相当差的。在性能上，对于一些特殊的主题，因为会实时的显示本地的内存占用、时间时期等信息，每次执行命令都会执行一遍，不卡才怪（反正我在使用过程中发现了绝对能够影响我感官的卡顿感）。

如果你觉得以上的问题还 OK，那就继续看下去。现在开始折腾……

## 开始折腾

其实配置的方法很简单，比较纠结的地方在于怎么去找适合的主题，于是我开始 深入浅出 GitHub……

### 关于主题选择

其实 iterm 的[主题](https://github.com/robbyrussell/oh-my-zsh/wiki/Themes)有很多，我们可以随便选择一种。默认的主题是 robbyrussell ，我们可以通过 `vi ~/.zshrc` 命令然后找出 ZSH_THEME="xxx" 的语句，xxx 就是默认主题的配置。

在官方给出的[主题列表](https://github.com/agnoster/agnoster-zsh-theme)里，有一款主题其实很不错（其他都丑）：agnoster，效果如下：

![](https://cloud.githubusercontent.com/assets/2618447/6316862/70f58fb6-ba03-11e4-82c9-c083bf9a6574.png)

配置官方的主题方案很简单，可以参考此篇[博客](https://www.jianshu.com/p/e42c7e7a4253)。

emmm…… 这看起来和开篇的效果图还不太一样啊。当然，除了官方的主题，还有一些第三方的主题，比如我今天要用的 powerlevel9k，在搭配效果上还会有更多的方案。

### powerlevel9k

对于 powerlevel9k，其实已经有了一个还不错的生态圈了，毕竟GitHub也是有 4k+ 的存在。在官方的说明中已经有了一份很详细的安装文档。可以戳[这里](https://github.com/bhilburn/powerlevel9k)查看。

这里就不赘述安装细节做无用功了。文档是英文的，但是也很容易可以看懂，大致意思就是 powerlevel9k 提供了针对不同平台的主题安装方案，对于一些特殊的主题效果，还需要安装一些特殊的字体用作图标展示，在这里都可以选择安装，比如我选择的就是 zsh 的主题安装 和 Nerd-Fonts 的字体安装方案。同时，powerlevel9k 也提供了社区分享的一些不错的[配色方案](https://github.com/bhilburn/powerlevel9k/wiki/Show-Off-Your-Config)，我们可以直接拿来用,嘿嘿……

![](http://ww1.sinaimg.cn/large/86c7c947gy1fplepu0f5dj20hs0cmdho.jpg)

自己可以选择自己喜欢的主题和字体。安装完成之后，只需要在 zsh 的配置文件中配置一下即可：

```
1. 打开 zsh 配置文件

vi ~/.zshrc

2. 写入配置方案， 主题选择你安装的主题，配色方案可以去上面社区分享的列表去找，比如我的

ZSH_THEME="powerlevel9k/powerlevel9k"
# ZSH_THEME="agnoster"
POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="000"
POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="007"
POWERLEVEL9K_DIR_HOME_BACKGROUND="001"
POWERLEVEL9K_DIR_HOME_FOREGROUND="000"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="001"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="000"
POWERLEVEL9K_NODE_VERSION_BACKGROUND="black"
POWERLEVEL9K_NODE_VERSION_FOREGROUND="007"
POWERLEVEL9K_NODE_VERSION_VISUAL_IDENTIFIER_COLOR="002"
POWERLEVEL9K_LOAD_CRITICAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_WARNING_BACKGROUND="black"
POWERLEVEL9K_LOAD_NORMAL_BACKGROUND="black"
POWERLEVEL9K_LOAD_CRITICAL_FOREGROUND="007"
POWERLEVEL9K_LOAD_WARNING_FOREGROUND="007"
POWERLEVEL9K_LOAD_NORMAL_FOREGROUND="007"
POWERLEVEL9K_LOAD_CRITICAL_VISUAL_IDENTIFIER_COLOR="red"
POWERLEVEL9K_LOAD_WARNING_VISUAL_IDENTIFIER_COLOR="yellow"
POWERLEVEL9K_LOAD_NORMAL_VISUAL_IDENTIFIER_COLOR="green"
POWERLEVEL9K_RAM_BACKGROUND="black"
POWERLEVEL9K_RAM_FOREGROUND="007"
POWERLEVEL9K_RAM_VISUAL_IDENTIFIER_COLOR="001"
POWERLEVEL9K_RAM_ELEMENTS=(ram_free)
POWERLEVEL9K_TIME_BACKGROUND="black"
POWERLEVEL9K_TIME_FOREGROUND="007"
POWERLEVEL9K_TIME_FORMAT="%D{%H:%M} %F{003}\uF017"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=('context' 'dir' 'vcs')
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=('node_version' 'load' 'ram_joined' 'time')
POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=$'\uE0B0'
POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=$'\uE0B2'

3. 使配置文件生效

source ~/.zshrc

```

综上，就可以略微有些逼格了，放个我的

![](http://ww1.sinaimg.cn/large/86c7c947gy1fplemwhjjqj21xu13216d.jpg)

## 结语

喜欢折腾的值得一试哦（内心：真的有点卡啊，不行不行，明天我就卸了）。