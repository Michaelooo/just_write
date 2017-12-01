> 以下例子依据keystone项目，其他node项目的调试雷动
# 通过vscode来调试keystone后台，适用于**node -v = 7.8.0**
## 1. 配置
在keystone目录下，通过**调试**->**添加配置**->**添加一个配置文件**->配置文件参考如下
如果只需要简单的调试后台，用下面的这个配置即可
```
{
    "version": "0.2.0",
    "configurations": [
        {
        "type": "node",
        "request": "launch",
        "name": "keystone后台调试",
        "program": "${workspaceRoot}/keystone.js",
        "runtimeArgs": [
            "--nolazy",
            "--debug-brk"
        ],
        "env": {
            "NODE_ENV": "local",
            "KEYSTONE_DEV": "true"
        }
    }]
}
```
如果需要设置一个可以检测文件启动的服务，可以先安装 [nodemon](https://github.com/remy/nodemon)
```
npm i --save-dev nodemon
```
默认devpendency已经安装对应依赖
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "通过nodemon来启动",
            "runtimeExecutable": "nodemon",
            "program": "${workspaceRoot}/keystone.js",
            "restart": true,
            "console": "integratedTerminal",
            "internalConsoleOptions": "neverOpen",
            "env": {
                "NODE_ENV": "local",
                "KEYSTONE_DEV": "true"
            }
        }
    ]
}
```

## 2. 启动调试
打开左侧调试界面，选择启动项，启动调试即可。
