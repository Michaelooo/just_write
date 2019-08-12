# mac 下的 vim

因为 mac 下的 vim 实在是有点难用，所以被逼无奈折腾一下。因为不想在这上面花费太多的时间，所以会选用一些比较简单（傻瓜）的方案，最后的目标是将 vim 当做除了 vscode 主力编辑器之外的一个查看零碎文件的易用的工具。

最后选用的方案就是直接 macvim。

## 操作步骤

### 1. 参考[小胡子哥]([https://github.com/barretlee/autoconfig-mac-vimrc/blob/master/README.md](https://github.com/barretlee/autoconfig-mac-vimrc/blob/master/README.md)的快速安装脚本

```bash
git clone https://github.com/barretlee/autoconfig-mac-vimrc.git;
cd autoconfig-mac-vimrc;
chmod +x install;
./install;
```

中间可能会遇到一些安装缓慢的问题，这时最好设置一个代理下载。[参考 git clone 缓慢问题解决办法]([https://github.com/Michaelooo/just_write/blob/a201d35bbe567727227ff8027b8961872cd7cd51/archived/%E5%85%B3%E4%BA%8Egit%2C%E4%BD%A0%E5%BA%94%E8%AF%A5%E7%9F%A5%E9%81%93%E7%9A%84%E6%93%8D%E4%BD%9C.md#2-git-clone-%E6%9E%81%E5%85%B6%E7%BC%93%E6%85%A2%E7%9A%84%E9%97%AE%E9%A2%98](https://github.com/Michaelooo/just_write/blob/a201d35bbe567727227ff8027b8961872cd7cd51/archived/%E5%85%B3%E4%BA%8Egit%2C%E4%BD%A0%E5%BA%94%E8%AF%A5%E7%9F%A5%E9%81%93%E7%9A%84%E6%93%8D%E4%BD%9C.md#2-git-clone-%E6%9E%81%E5%85%B6%E7%BC%93%E6%85%A2%E7%9A%84%E9%97%AE%E9%A2%98)

### 2. 做些适当的调整

其实也可以用自己配置好的 ~/.vimrc 替代上面仓库中的 .vimrc 文件，我们这里只做一些简单的修改。

1. 去掉超过行最大宽度后的竖白线
   
   ```bash
   # 搜索 textwidth=80
   set textwidth=150
   " let &colorcolumn=join(range(81,999),",")
   " let &colorcolumn="80,".join(range(120,999),",")
   " set colorcolumn=+1
   ```

2. 去掉当前列高亮
   
   ```bash
   " set cursorcolumn
   ```

3. 安装一些其他的插件等
   
   查看 [https://www.jianshu.com/p/56385f4f95f5](https://www.jianshu.com/p/56385f4f95f5) 安装适合自己的插件



## 可能会遇到的问题？

1. 提示报错： `The ycmd server SHUT DOWN (restart with ':YcmRestartServer')`
   
   ```bash
   cd ~/.vim/bundle/YouCompleteMe  
   ./install.py --clang-completer  
   ```
   
   使用以上命令可以解决，参考 [https://blog.m157q.tw/posts/2017/11/27/youcompleteme-ycmd-server-shut-down-restart-with-ycmrestartserver/](https://blog.m157q.tw/posts/2017/11/27/youcompleteme-ycmd-server-shut-down-restart-with-ycmrestartserver/)
2. git clone 下载很缓慢

## 参考

- 快速安装 macvim ： [https://github.com/barretlee/autoconfig-mac-vimrc](https://github.com/barretlee/autoconfig-mac-vimrc)

- macvim 的进阶使用： [https://www.jianshu.com/p/56385f4f95f5](https://www.jianshu.com/p/56385f4f95f5)
