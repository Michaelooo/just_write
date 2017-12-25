## Mac下的一些命令

### 为某一个命令注册全局变量

有时候，安装visual code 或者 macdown 类似的软件，我们可以使用对应的命令行操作来提供效率。但有一天命令不可以用了怎么办？

没关系，自己加上就好。

#### 配置文件的读取顺序

Mac系统的环境变量，加载顺序为：

```
/etc/profile
/etc/paths
~/.bash_profile
~/.bash_login
~/.profile
~/.bashrc 如果使用了 zsh 就是 ~/.zshrc
```

当然/etc/profile和/etc/paths是系统级别的，系统启动就会加载，后面几个是当前用户级的环境变量。后面3个按照从前往后的顺序读取，如果/.bash_profile文件存在，则后面的几个文件就会被忽略不读了，如果/.bash_profile文件不存在，才会以此类推读取后面的文件。~/.bashrc没有上述规则，它是bash shell打开的时候载入的。

#### 添加环境变量的命令

在 ~/.bashrc 或者 ~/.zshrc 文件中添加指定程序的命令。

```
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
```

添加完成之后，执行

```
source ~/.bashrc
或者 source ~/.zshrc
```

#### 重启失效了？

按照以上顺序再来一遍……

### 删除讨厌的.DS_store文件

有时候node启动服务会遇到很懵逼的报错，其中就有.DS_store文件的报错。原因就是npm不知道这个玩意儿是啥，所以处理不了。直接删了就好。

步骤一：删除当前目录下所有隐藏.DS_store文件（请一定要在当前目录执行）

```
sudo find ./ -name ".DS_Store" -depth -exec rm {} \; 
```

步骤二： 设置不再产生选项, 执行如下命令（建议不要执行，DS_store有它的作用的）

```
defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```




