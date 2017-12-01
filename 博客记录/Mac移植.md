一篇文章，从windows10成功移植macOS

作为习惯了Windows温暖怀抱的码畜一名，初次使用macOS，总是会有各种的不适应。记不住的快捷键，理不清的bash命令，找不到的文件夹，个个都能让人激动地拔起29米大刀。这篇文章，简单介绍作为一小白从Windows10系统成功移植macOS的过程。在几天的适应时间里，查阅了大量（一点儿）的资料，踩着前人的尸首整理出这篇文章。一方面算作是给自己一个记录，另一方面是最近略忙，无法更新博客，只能写点这些来充数。

因为我是码农一名，所以对macOS的使用理解可能与大众视角不太一样，所以将就看。

配置VPN

首先，刚接触到macOS，我认为应该做的第一件事就是配网络，毕竟在程序界，国外的月亮的确是圆一些。关于vpn，最近国家风头正紧，前阵子，博主一直用的greenvpn已经跑路，所以防止查水表，这里就简单提一下，希望没人看到。

一般在macOS上使用VPN，会推荐两个，一个是使用shadowsock客户端，然后自己去somewhere找线路，进行配置后访问，这一种略微麻烦下。因为我是小白嘛，所以我用简单的，lantern ，比起使用shadowsock，lantern使用很简单，直接下载打开就可以用。lantern默认会在打开的时候，在你的机器上跑一个服务，免费的也可以用，但是速度稳定性稍微差些，重要的是会限制流量。专业版的就不会做流量限制，而且现在两年套餐才300块左右（我用的就是这个），我不会告诉你在购买的时候填写这个验证码 YY7VYWQ 还可以额外获得是三个月的使用时间。

对了，最重要的是，下载lantern别去百度搜索下载，搜到的中文官网已经下了，直接去这里下载 下载地址： https://github.com/getlantern/lantern/releases/tag/latest，而且需要注意的是lantern没有ios版本的，所以ios上的lantern都是盗版。

记住快捷键

首先MacBook的键位是和普通的键盘不一样的，更重要的是好多快捷键也是很有自己的freestyle，的确是相当难记（当然也不需要全部记住，只需要在工作熟悉常用的即可）。这里推荐一个软件CheatSheet，没别的，就是当你长按住command键的时候，会显示当前电脑的所有常用快捷键方式，好记性不用带小抄。下载地址点这里，CheatSheet https://www.mediaatelier.com/CheatSheet/

bash命令

讲道理，不看其他的，macOS上的bash命令我可以玩儿一天。这里直接看了前人的教程来配置自己的terminal。结合美观、使用高效的需求，前人给出的解决方案是iterm2+oh-my-zsh+各种配置,思路很清晰，但是安装会有一点麻烦。
整理一下思路大致就是， 先安装iterm2 -> iterm2简单配置，配色方案 -> 安装zsh，mac自带的有zsh，但是可以去更新下 -> 安装oh-my-zsh插件 -> 愉快玩耍

iterm2的安装
直接去iterm2的官网下载就行了，https://www.iterm2.com/，免费的软件。

iterm2简单配置，配色方案
网上有很多大神有自己的配色方案，可以 百度 ‘iterm2配色方案’，可以按照教程自己设置。当然我是小白，所以直接用现成的。iterm2有专门的主题网站，可以登录这里http://iterm2colorschemes.com/，下载网站上的包，然后知己导入就行了，你要问怎么导入？直接看这里，iterm2导入配色方案http://jingyan.baidu.com/article/48a42057029f99a92425048e.html

安装zsh
在安装zsh之前，可以先安装一个homebrew，https://brew.sh/index_zh-cn.html，有了这个玩意儿，可以一键安装你想安装的东西。安装完成后，直接bash输入
$brew install zsh 
安装成功后，需要修改为默认的shell，先去确认一下自己zsh的安装目录
$ chsh -s /bin/zsh

安装oh-my-zsh插件
只剩下最后一步,一行命令搞定
$ curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

以上，就稍微有点逼格了，

一些我记不住的命令：
顺便给自己备忘一下老是记不住的命令：
显示隐藏文件/目录： $ defaults write com.apple.finder AppleShowAllFiles -bool true
隐藏隐藏文件/目录： $ defaults write com.apple.finder AppleShowAllFiles -bool false 