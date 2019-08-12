# mac 下的 vim

因为 mac 下的 vim 实在是有点难用，所以被逼无奈折腾一下。因为不想在这上面花费太多的时间，所以会选用一些比较简单（傻瓜）的方案，最后的目标是将 vim 当做除了 vscode 主力编辑器之外的一个查看零碎文件的易用的工具。

最后选用的方案就是直接 macvim

* 快速安装 macvim ： [https://github.com/barretlee/autoconfig-mac-vimrc](https://github.com/barretlee/autoconfig-mac-vimrc)

* macvim 的进阶使用： [https://www.jianshu.com/p/56385f4f95f5](https://www.jianshu.com/p/56385f4f95f5)

## 可能会遇到的问题？

1. 提示报错： `The ycmd server SHUT DOWN (restart with ':YcmRestartServer')`
   
   ```bash
   cd ~/.vim/bundle/YouCompleteMe  
   ./install.py --clang-completer  
   ```
   
   使用以上命令可以解决，参考 [https://blog.m157q.tw/posts/2017/11/27/youcompleteme-ycmd-server-shut-down-restart-with-ycmrestartserver/](https://blog.m157q.tw/posts/2017/11/27/youcompleteme-ycmd-server-shut-down-restart-with-ycmrestartserver/)
