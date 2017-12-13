# Linux搭建 Node.js 环境

## 安装 Node.js 环境

Node.js 是运行在服务端的 JavaScript, 是基于 Chrome JavaScript V8 引擎建立的平台。

### 下载并安装 Node.js

下载最新的稳定版 v6.10.3 到本地

```
wget https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz
```

下载完成后, 将其解压

```
tar xvJf node-v6.10.3-linux-x64.tar.xz
```

将解压的 Node.js 目录移动到 /usr/local 目录下

```
mv node-v6.10.3-linux-x64 /usr/local/node-v6
```
配置 node 软链接到 /bin 目录

```
ln -s /usr/local/node-v6/bin/node /bin/node
```

## 配置和使用 npm

### 配置 npm

npm 是 Node.js 的包管理和分发工具。它可以让 Node.js 开发者能够更加轻松的共享代码和共用代码片段

下载 node 的压缩包中已经包含了 npm , 我们只需要将其软链接到 bin 目录下即可

```
ln -s /usr/local/node-v6/bin/npm /bin/npm
```

配置环境变量

将 `/usr/local/node-v6/bin` 目录添加到 $PATH 环境变量中可以方便地使用通过 npm 全局安装的第三方工具

`echo 'export PATH=/usr/local/node-v6/bin:$PATH' >> /etc/profile`
生效环境变量

```
source /etc/profile
```
### 使用 npm

通过 npm 安装进程管理模块 forever

npm install forever -g
完成实验

恭喜！您已经成功完成了搭建 Node.js 环境的实验任务。