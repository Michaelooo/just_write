# go 环境配置

## 安装

直接去官网下载 [go的包](https://golang.org/dl/)，下载后解压安装。

1. 配置 gopath 

```
echo 'export GOPATH=$HOME/go
PATH=$PATH:$HOME/.local/bin:$HOME/bin:$GOPATH/bin' >> ~/.zshrc
```
使配置生效

```
source ~/.zshrc
```

2. 使用 `go env` 查看配置是否生效

一般目录是下面的这个样子就是对的，`GOPATH="/Users/xxx/go"`，xxx是当前账户目录。

## 配置 vscode 环境
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

但是在最近的测试过程中，发现 golint 依然会报安装失败，原因是 `https://github.com/golang/tools.git`这个仓库里不包含这个 lint 的工具了，所以我们需要单独的安装这个工具包。

通过查询此 [issue: Where did golint go?](https://github.com/golang/lint/issues/397) 解决

```
mkdir -p $GOPATH/src/golang.org/x \
  && git clone https://github.com/golang/lint.git $GOPATH/src/golang.org/x/lint \
  && go get -u golang.org/x/lint/golint
```

上述命令可能会遇到文件夹已存在的问题，可以直接跳过第一步文件夹创建的操作就可以。

## 使用一些包管理工具来管理外部包

常用的有 :

* godep: [golang 包依赖管理 godep 使用](https://www.jianshu.com/p/db59b10c8c51)
* govendor: [go依赖管理-govendor](https://studygolang.com/articles/9785)


