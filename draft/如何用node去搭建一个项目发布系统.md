# 如何用 node 去搭建一个项目发布系统

其实题目是有一些标题党的，项目

设计大于实现


## 项目文件的解压

### 以 stream 的方式解压文件

## 项目的部署

有关于项目的部署，其实初期设想，大部分的资源都是静态资源，对于一些需要体积偏大需要缓存的文件，我们需要上传这些文件去到我们的 CDN 服务。而对于一些不需要做缓存的文件，比如项目的入口文件，我们就可以同步到我们的资源机里面。

对于第一点，我使用的是开源的 [node-ftp-client](https://github.com/noodny/node-ftp-client)，这个并没有什么操作难度，唯一需要注意的就是 node-ftp-client 的方法是异步的，所以为了兼容 koa@2 的 async/await 写法以及保证程序的执行顺序，需要对 node-ftp-client 的方法进行一次 promise 化。代码如下：

```
const test = async (ctx, source, target) => {
  
  let ftpConfig = { };
  let options = {
    logging: 'basic'
  };
  let upOption = {
    baseDir: source,
    overwrite: 'none'
  }

  let fct = new FtpClient(ftpConfig, options);
  return new Promise((resolve, reject)=> {
    fct.connect(()=>{
      fct.upload(source, target, upOption, (r) => {
        console.log(source,target,r);
        resolve(r);
      })
    })
  })
}
```



### 在docker 中使用 rsync 来进行项目发布

这个大概是耽误时间最多的一个操作。

有关于发布系统最重要的一环——发布源码到目标主机，我使用的是开源的 [node-rsync](https://github.com/mattijs/node-rsync)。其实这个库只是对于 linux rsync 命令的一次封装，**底层需要操作主机支持 rsync 命令**。

听起来并不是什么复杂的操作，但是在真正的执行的时候

> 最近在处理一个静态资源系统的发布平台，大概意思就是对于多环境的静态项目，