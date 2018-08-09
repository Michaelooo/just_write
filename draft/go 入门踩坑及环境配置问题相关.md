# go 入门踩坑及环境配置问题相关


## 学习网站

* [**Go 入门指南**](https://www.kancloud.cn/kancloud/the-way-to-go/72675)
* [**Go web 编程**](https://www.kancloud.cn/kancloud/web-application-with-golang/44105)
* [**官网**](https://golang.org/doc/)
* [**深入解析 Go**](https://tiancaiamao.gitbooks.io/go-internals/content/zh/04.0.html)
* [**Go 仓库大全**](https://gowalker.org/search?q=gorepos)
* [**Go 标准库指南（中文）**](http://cngolib.com/)
* [**awesome go**](https://github.com/avelino/awesome-go)

## 1.安装

直接去官网下载 [go的包](https://golang.org/dl/)，下载后解压安装。

### 配置 gopath 

gopath 可以简单理解为你的工作目录，可以自己定义位置。

```
echo 'export GOPATH=$HOME/go
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin' >> ~/.zshrc
```
使配置生效

```
source ~/.zshrc
```

### 使用 `go env` 查看配置是否生效

一般目录是下面的这个样子就是对的，`GOPATH="/Users/xxx/go"`，xxx 是当前用户名称。

## 2.配置 vscode 开发环境

### **配置 debug 环境**

使用 vscode 调试 go 的话，需要安装一个go的第三方依赖：[delve](https://github.com/derekparker/delve)，可以使用下面的命令安装：

```
go get github.com/derekparker/delve/cmd/dlv
```

安装后就可以在 debug 面板添加 debug 配置文件调试了，示例如下：

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch",
      "type": "go",
      "request": "launch",
      "mode": "debug",
      "remotePath": "",
      "port": 7000,
      "host": "0.0.0.0",
      "program": "${workspaceRoot}",
      "env": {
        "GOPATH": "/Users/michael/Documents/go"
      },
      "args": [],
      "showLog": true
    }
  ]
}
``` 

如果启动后报下面的错误：

```
lldb-server needs to be installed in $PATH
```

可以采用下面的方法解决：

执行 `xcode-select --install` 解决，[原因未知](https://github.com/derekparker/delve/issues/986)。


### **配置开发语法提示**

随便建一个 `.go` 的文件用 vscode 打开，会自动提示安装 go 的相关插件，但是一般会有一些插件安装失败，一般都是下面的几个：

```
Installing github.com/nsf/gocode SUCCEEDED
Installing github.com/uudashr/gopkgs/cmd/gopkgs SUCCEEDED
Installing github.com/ramya-rao-a/go-outline FAILED
Installing github.com/acroca/go-symbols FAILED
Installing golang.org/x/tools/cmd/guru FAILED
Installing golang.org/x/tools/cmd/gorename FAILED
Installing github.com/rogpeppe/godef SUCCEEDED
Installing github.com/sqs/goreturns FAILED
Installing github.com/golang/lint/golint FAILED
```

可以参考这个[修改办法: 让你成功安装vscode中go的相关插件](https://cloud.tencent.com/developer/article/1013066) 修改。

### **注意(如果没遇到就忽略)**

但是在最近的测试过程中，发现 golint 依然会报安装失败，原因是 [https://github.com/golang/tools.git](https://github.com/golang/tools.git) 这个仓库里不包含这个 lint 的工具了，所以我们需要单独的安装这个工具包。

通过查询此 [issue: Where did golint go?](https://github.com/golang/lint/issues/397) 解决

```
mkdir -p $GOPATH/src/golang.org/x \
  && git clone https://github.com/golang/lint.git $GOPATH/src/golang.org/x/lint \
  && go get -u golang.org/x/lint/golint
```

上述命令可能会遇到文件夹已存在的问题，可以直接跳过第一步文件夹创建的操作就可以。

## 3.使用一些包管理工具来管理第三方包

因为 go 官方没有提供自己的包管理机制，所以包的管理是个坑。市面上各家提供的包管理都是各玩各的，但也有大家用的多的，关于 go 比较常用的包管理工具，有以下几个推荐的:

* godep : [golang 包依赖管理 godep 使用](https://www.jianshu.com/p/db59b10c8c51)
* govendor : [go 依赖管理-govendor](https://studygolang.com/articles/9785)
* **glide** : [glide 包依赖管理](https://github.com/Masterminds/glide)
 
目前项目中正在使用 glide， 使用 glide 管理包的话，会生成一个 venndor 的目录，可以理解为一个跟随项目的局部 gopath， 这样子在引入第三方包的时候，实际的读取顺序就是： 局部 vendor -> 全局 gopath 。

另外，在使用第三方包的时候，有些第三方包会托管在 google 的服务上，因为墙的原因，我们没法方便的拿下来，甚至你搭了梯子还是很蛋疼。所以我们只能自己配置镜像源了，因为我们用的是 glide ，所以就拿 glide 的来做例子。

我们只需要使用 `glide mirror set` 命令来设置镜像配置（[参考](https://github.com/xkeyideal/glide/blob/master/README_CN.md)）： 

```
glide mirror set https://golang.org/x/sys https://github.com/golang/sys
``` 

## 后续待补……