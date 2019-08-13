# node 大坑

## node 线上性能监控，内存泄漏……

* [alinode: baba~~](https://alinode.aliyun.com/)
* [easy-monitor: 轻量级实时 Node.js 内核性能监控分析工具(待验证)](https://github.com/hyj1991/easy-monitor)
* [load-test 压测工具](https://github.com/alexfernandez/loadtest)

## node 使用 profile 监控应用性能

* [如何使用 Node Profile](https://github.com/ali-sdk/node-profiler/wiki/%E5%A6%82%E4%BD%95%E4%BD%BF%E7%94%A8Node-Profiler)
* [node profile](https://nodejs.org/uk/docs/guides/simple-profiling/)

## node 启动服务一直报 ENFILE 错误

[![enfile报错](https://t1.picb.cc/uploads/2017/12/04/prBau.png)](https://www.picb.cc/image/prXma)
原因是 mac 的打开文件最大限制设置的太小。执行以下命令解决：从 10240 变成 65536

```bash
echo kern.maxfiles=65536 | sudo tee -a /etc/sysctl.conf
echo kern.maxfilesperproc=65536 | sudo tee -a /etc/sysctl.conf
sudo sysctl -w kern.maxfiles=65536
sudo sysctl -w kern.maxfilesperproc=65536
ulimit -n 65536
```

[![解决办法](https://t1.picb.cc/uploads/2017/12/04/prFDD.png)](https://www.picb.cc/image/prBau)

## 不要 homebrew 安装 node

初始化的时候不要用 homebrew 或者 n 安装 node，好多问题：

[![用homebrew安装报错](https://t1.picb.cc/uploads/2017/12/04/prx7i.png)](https://www.picb.cc/image/prRnv)

解决办法就是老老实实下个安装包去安装

## node 切换版本出现的问题

[![node切换版本报错](https://t1.picb.cc/uploads/2017/12/04/prRnv.jpg)](https://www.picb.cc/image/prFDD)

一直报这个错误，网上查询资料发现时 node 版本切换的问题，但给出的解决方案是都是 npm install,npm update 这些的操作，问题是这些操作会一直报错。无奈只能强行删除，重新安装

### node 在 Mac 的删除方法

1. 在 node 官网上下载的安装包，用安装包安装的 node 的话，应该可以用一下命令行卸载：
   
   在终端输入以下命令：
   
   ```bash
   sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
   ```
   
   该命令操作的步骤就是：
   
   * 删除/usr/local/lib中的所有node和node_modules
   
   * 删除/usr/local/lib中的所有node和node_modules的文件夹
   
   * 如果是从brew安装的, 运行brew uninstall node
   
   * 检查~/中所有的local, lib或者include文件夹, 删除里面所有node和node_modules
   
   * 在/usr/local/bin中, 删除所有node的可执行文件
   
   * 最后运行以下代码:(可能具体安装路径会有区别 ,find ~ -name "node" 可以找到所有
     
     
   2. 删除
      
      ```bash
      sudo rm /usr/local/bin/npm
      sudo rm /usr/local/share/man/man1/node.1
      sudo rm /usr/local/lib/dtrace/node.d
      sudo rm -rf ~/.npm
      sudo rm -rf ~/.node-gyp
      sudo rm /opt/local/bin/node
      sudo rm /opt/local/include/node
      sudo rm -rf /opt/local/lib/node_modules
      ```
      
      

## 生成目录树结构

安装： `brew install tree`

使用：

```
生成指定文件：tree -f > test.txt
设置目录深度：tree -L 2
```

中文显示乱码：`alias tree='tree -N'`

在 Mac 中这个命令有时候会重启失效，可参考此博客修改：[mac 下 alias 命令重启失效的问题](http://blog.csdn.net/lisongjia123/article/details/77962144)

## node切换版本较高版本(8.11.2)问题

[node 和 yarn 缓存策略的异同](https://segmentfault.com/a/1190000009709213)

> 在 npm@5 以前，每个缓存的模块在 `~/.npm` 文件夹中以模块名的形式直接存储，例如 koa 模块存储在 `~/.npm/koa` 文件夹中。而 npm@5 版本开始，数据存储在 `~/.npm/_cacache` 中，并且不是以模块名直接存放。

切换到较高版本的 node 时，有时候会遇到 npm 无法安装的错误，主要还是因为 n 管理 node 版本，npm @5 更新了自己的缓存策略， 所以一些模块会找不到，所以可以先清理cache，再重新切换版本即可。

可以通过 `lsa ~/.npm/cacache` 查看 当然不建议自己手动 clean 缓存，添加 -f 会提示一个 npm 的警告，不用在意。

```
sudo npm cache clean -f
sudo n version
```
