## Mac 下的一些命令，踩坑

### 为某一个命令注册全局变量

有时候，安装 visual code 或者 macdown 类似的软件，我们可以使用对应的命令行操作来提供效率。但有一天命令不可以用了怎么办？

没关系，自己加上就好。

**配置文件的读取顺序**

Mac 系统的环境变量，加载顺序为：

```
/etc/profile
/etc/paths
~/.bash_profile
~/.bash_login
~/.profile
~/.bashrc 如果使用了 zsh 就是 ~/.zshrc
```

当然/etc/profile 和/etc/paths 是系统级别的，系统启动就会加载，后面几个是当前用户级的环境变量。后面 3 个按照从前往后的顺序读取，如果/.bash_profile 文件存在，则后面的几个文件就会被忽略不读了，如果/.bash_profile 文件不存在，才会以此类推读取后面的文件。~/.bashrc 没有上述规则，它是 bash shell 打开的时候载入的。

**添加环境变量的命令**

在 ~/.bashrc 或者 ~/.zshrc 文件中添加指定程序的命令。

```
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
```

添加完成之后，执行

```
source ~/.bashrc
或者 source ~/.zshrc
```

**重启失效了？**

按照以上顺序再来一遍……

### 删除讨厌的.DS_store 文件

有时候 node 启动服务会遇到很懵逼的报错，其中就有.DS_store 文件的报错。原因就是 npm 不知道这个玩意儿是啥，所以处理不了。直接删了就好。

**步骤一：删除当前目录下所有隐藏.DS_store 文件（请一定要在当前目录执行）**

```
sudo find ./ -name ".DS_Store" -depth -exec rm {} \;
```

**步骤二： 设置不再产生选项, 执行如下命令（建议不要执行，DS_store 有它的作用的）**

```
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```

### 关闭讨厌的 Adobe creative cloud 服务开机项

以下只针对于没有 Adobe 账户或者没有登录的用户，如果有 Adobe 账号的，可以直接登录然后修改开机启动项。

```
// 禁用
launchctl unload -w /Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist

//启用
launchctl load -w /Library/LaunchAgents/com.adobe.AdobeCreativeCloud.plist
```

### Macbook 下使用缩放的体验

**结论： 如果是开发设计，不要用**

对于日常开发来说， MacBook 什么都好，就是屏幕太小。不过好说 MacBook 在 系统偏好设置--显示器 选项有缩放的选项，开启后可以扩大图像范围，可以适当的伪装成大屏的显示效果（当然视力要足够好，因为字体会变小）。

日常使用了一阵子，发现确实棒棒的，但是有一个致命缺陷就是，假如你安装了 Adobe 的大型图像处理软件之类的，比如 PS、基于 Adobe air 的 Markman 等，你就会发现电脑会运行极其卡顿，发热极其严重。其原因就是缩放改了你屏幕的显示分辨率，分辨率越大，Adobe 需要渲染处理的东西就越多，有多少内存就用掉多少，显卡也撑不住，造成的结果就是 CPU、GPU 狂飙 90°c,电脑极其卡顿。

当然，我也尝试过去修改 PS 的可用内存、渲染质量之类的[（官方 PS 优化策略）](https://helpx.adobe.com/cn/photoshop/kb/optimize-photoshop-cc-performance.html)，调整之后略有改善，但是那种卡顿感还是非常强。最后无奈放弃，使用默认的分辨率 1440x900 ， 然后运行如飞。
