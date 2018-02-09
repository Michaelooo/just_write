# **Go 语言**

## 学习网站

* [**Go 入门指南**](https://www.kancloud.cn/kancloud/the-way-to-go/72675)
* [**Go web编程**](https://www.kancloud.cn/kancloud/web-application-with-golang/44105)
* [**官网**](https://golang.org/doc/)
* [**深入解析 Go**](https://tiancaiamao.gitbooks.io/go-internals/content/zh/04.0.html)
* [**Go 仓库大全**](https://gowalker.org/search?q=gorepos)
* [**Go 标准库指南（中文）**](http://cngolib.com/)
* [**awesome go**](https://github.com/avelino/awesome-go)


## 踩坑记录

### 1. GOPATH 和 GOROOT 的配置，或者区别？

* **GOROOT:**  GOROOT 就是go的安装路径。Mac 下安装的一般不用管，默认是 **/usr/local/go**；
* **GOPATH:** go install/go get和 go的工具等会用到 GOPATH 环境变量。所以 GOPATH 的位置可以自定义位置，个人使用 **/Users/user/go** 。

设置成功后，可以使用 `go env` 查看。

### 2. vscode 安装 go 插件部分失败?

解决办法：[让你成功安装 vscode 中 go 的相关插件](https://cloud.tencent.com/developer/article/1013066)

### 3. vscode debug go项目时报错？

报错内容：

```
Failded to continue:"Cannot find Delve debugger. Install from https://github.com/derekparker/delve & ensure it is in your "GOPATH/bin" or "PATH"
```

**go path 目录下执行 `go get github.com/derekparker/delve/cmd/dlv` 解决。**

然后启动 go server 的话也会报错：

```
lldb-server needs to be installed in $PATH
```

解决办法：

执行 `xcode-select --install` 解决，[原因未知](https://github.com/derekparker/delve/issues/986)。