>适用于macos
有时候想要在readme中添加类似下面的目录结构，可以使用tree命令，操作步骤如下
```
.
├── README.md
├── index.html
├── server
│   ├── Dockerfile
│   ├── app.js
│   ├── config
│   ├── controllers
│   ├── docs
│   ├── event
│   ├── libs
│   ├── logs
│   ├── middlewares
│   ├── models
│   ├── my_models
│   ├── node_modules
│   ├── package-lock.json
│   ├── package.json
│   ├── remarket.conf
│   ├── run-test.sh
│   ├── schemas
│   ├── service
│   ├── test
│   ├── tmp
│   ├── update-docker.sh
│   ├── update-test-15.sh
│   └── update-test.sh
└── web
    ├── Dockerfile
    ├── cfg
    ├── dist
    ├── docker.start.sh
    ├── karma.conf.js
    ├── mock
    ├── nginx.conf
    ├── node_modules
    ├── package-lock.json
    ├── package.json
    ├── server.js
    ├── src
    ├── test
    ├── update-docker-15.sh
    ├── update-docker.sh
    ├── update-test-15.sh
    ├── update-test.sh
    └── webpack.config.js
```

# 安装： 
```
brew  install tree
```
# 使用：
##生成指定文件：	
```
tree -f > test.txt
```
## 设置目录深度：	
```
tree -L 2
```

## 显示中文（解决乱码）:
```
tree -N
```

## 更多操作
```
tree --help
```