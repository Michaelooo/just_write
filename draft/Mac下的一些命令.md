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

当然我们为了简写可以直接这样写（以配置 homebrew 源为例子）

```
echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.zshrc
source ~/.zshrc
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

### Macbook 升级系统后安全箱隐私策略找不到**任何来源**

执行 `sudo spctl --master-disable` 解决

### Mac升级后，出现的 xcrun: error, 或者安装 homebrew 出错，大部分是因为 **/Library/Developer/CommandLineTools** 的原因

执行 `xcode-select --install` 解决

### 执行某些命令出现 Fail to watch directory[ too many open files

* 参考： https://gist.github.com/tombigel/d503800a282fcadbee14b537735d202c
* http://wudaijun.com/2017/02/max-osx-ulimit/

查看现在的限制大小

```
launchctl limit maxfiles 
```

新建一个配置文件

```
sudo launchctl load -w /System/Library/LaunchDaemons/org.apache.httpd.plist
```

配置文件的内容

```
<?xml version="1.0" encoding="UTF-8"?>  
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"  
         "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">  
   <dict>
     <key>Label</key>
     <string>limit.maxfiles</string>
     <key>ProgramArguments</key>
     <array>
       <string>launchctl</string>
       <string>limit</string>
       <string>maxfiles</string>
       <string>64000</string>
       <string>524288</string>
     </array>
     <key>RunAtLoad</key>
     <true/>
     <key>ServiceIPC</key>
     <false/>
   </dict>
 </plist>
```

修改文件权限

```
sudo chown root:wheel /Library/LaunchDaemons/limit.maxfiles.plist
sudo chmod 644 /Library/LaunchDaemons/limit.maxfiles.plist
```

加载文件

```
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
```

配置完成之后必须重启才可以生效  

### Mac 对 ntfs 外接磁盘不可写的问题

可以使用付费软件：Paragon NTFS for MAC

也可以通过命令修改： https://www.cnblogs.com/MDK-L/p/4531778.html
