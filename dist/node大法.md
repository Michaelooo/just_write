# node大坑

## node使用profile监控应用性能


## node启动服务一直报 ENFILE 错误
[![enfile报错](https://t1.picb.cc/uploads/2017/12/04/prBau.png)](https://www.picb.cc/image/prXma)
原因是mac的打开文件最大限制设置的太小。
执行以下命令解决：
从 10240 变成 65536

``` 
$ echo kern.maxfiles=65536 | sudo tee -a /etc/sysctl.conf
$ echo kern.maxfilesperproc=65536 | sudo tee -a /etc/sysctl.conf
$ sudo sysctl -w kern.maxfiles=65536
$ sudo sysctl -w kern.maxfilesperproc=65536
$ ulimit -n 65536 
```
[![解决办法](https://t1.picb.cc/uploads/2017/12/04/prFDD.png)](https://www.picb.cc/image/prBau)

## 不要homebrew安装node
初始化的时候不要用n安装node，好多问题：


[![用homebrew安装报错](https://t1.picb.cc/uploads/2017/12/04/prx7i.png)](https://www.picb.cc/image/prRnv)
解决办法就是老老实实下个安装包去安装

## node 切换版本出现的问题

[![node切换版本报错](https://t1.picb.cc/uploads/2017/12/04/prRnv.jpg)](https://www.picb.cc/image/prFDD)

一直报这个错误，网上查询资料发现时node版本切换的问题，但给出的解决方案是都是npm install,npm update这些的操作，问题是这些操作会一直报错。
无奈只能强行删除，重新安装

### node在Mac的删除方法
* 在 node 官网上下载的安装包，用安装包安装的node.应该可以用一下命令行卸载：
在终端输入以下命令：

```
sudo rm -rf /usr/local/{bin/{node,npm},lib/node_modules/npm,lib/node,share/man/*/node.*}
```
      a. 删除/usr/local/lib中的所有node和node_modules
      b. 删除/usr/local/lib中的所有node和node_modules的文件夹
      c. 如果是从brew安装的, 运行brew uninstall node
      d. 检查~/中所有的local, lib或者include文件夹, 删除里面所有node和node_modules
      e. 在/usr/local/bin中, 删除所有node的可执行文件
      f. 最后运行以下代码:(可能具体安装路径会有区别 ,find ~ -name "node"   可以找到所有
      g. 

* 删除

```
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

安装： `brew  install tree`

使用：

```
生成指定文件：	tree -f > test.txt
设置目录深度：	tree -L 2
```

中文显示乱码：`alias tree='tree -N'`

在 Mac中这个命令有时候会重启失效，可参考此博客修改：[mac下alias命令重启失效的问题](http://blog.csdn.net/lisongjia123/article/details/77962144)
