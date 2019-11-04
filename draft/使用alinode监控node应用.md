# 使用 alinode 监控 node 应用

> 开篇想引用阿里天猪的一篇分享中对前端的总结：
前端 = 人机交互工程师，负责人机交互层的领域研究与技术实现。
前端的核心价值，是完成技术的最后一公里，让技术可交付给用户使用，是科技触达用户的桥梁，是数字世界里的建筑工。

> 随着应用规模的不断扩大和行业技术的发展，前端在复杂应用体系下的话语权也越来越重。前端工程师也早已不是过去的切图仔，随着 node 的横空出世，js 在各种前端工程化的实践中大放异彩，同时也因为 js 高度的灵活性，也使 js 在过去前端不敢涉足的服务领域也发出了一些声音。

## 为啥用 alinode ? 

在房多多，在大部分的前端应用工程里，node 主要负责的职责还是类似网关的作用、仅负责了前端应用的一些服务端渲染和类似接口透传的功能。我们现在大部分的 node 应用其实是这个样子的：

使用 Docker 打包镜像发布到我们的服务机，同时使用 pm2 管理我们的 node 服务，生产环境一般会启动至少两个 node 应用实例来充分利用机器的性能，同时在某些特殊的情况下（内存超过阈值或者应用崩溃等）自动重启，保证应用存活，如下图：

![111.png](http://ww1.sinaimg.cn/large/86c7c947gy1g8m9ag0jrlj20xv036776.jpg)

因为我们每个 docker container 设置的内存都蛮小的，貌似只有 250M，上图中的应用因为在 node 有做了一些复杂的数据逻辑，虽然内存占用并不高，但还是超了……

跑题了，在 node 应用的监控上，其实 pm2 也为我们提供了一些工具，比如 pm2 monit 可以在控制台输入一些简单实例信息：

![222.png](http://ww1.sinaimg.cn/large/86c7c947gy1g8m9ag54woj21h20eiaeo.jpg)

再比如 pm2 还提供了一种浏览器的可视化界面，pm2 web， 这种方式其实和 [easy-monitor](https://github.com/hyj1991/easy-monitor) 类似，显示的内容会更直观，但是最要命的缺陷是需要额外开启一个端口来启动服务，因为我们是在docker 容器中跑应用的，每个应用再额外开启一个端口跑监控着实有点浪费。

再比如，看图不行我直接看日志好嘛， pm2 事实上也给我们提供了很多查日志的方法，在房多多，pm2 的日志一般都是记录在 /app/.pm2/{application name}/ 文件夹下面，我们随便打开一个错误日志看下： 

```
tail -20 /data0/nodejs/bigdata.blood.website.bp.fdd/.pm2/logs/bigdata.blood.website.bp.fdd-error.log
```

![333.png](http://ww1.sinaimg.cn/large/86c7c947gy1g8m9ag8h31j21ey0cwak0.jpg)

emmmm ，我觉得差点儿意思。有没有一种 侵入性更小、显示更直观、操作更容易的方式呢。所以就想到了 alinode ， alinode 是阿里 朴灵（《深入浅出 nodejs》作者）团队牵头做的，是面向中大型 Node.js 应用提供 性能监控、安全提醒、故障排查、性能优化 等服务的整体性解决方案。凭借对 Node.js 内核深入的理解，我们提供完善的工具链和服务，协助客户主动、快速发现和定位线上问题。

所以， alinode， 就先用它了。

## alinode 怎么用呢？

alinode 核心是对 node 运行时做了一些操作然后重新编译的，官方宣称可以完全用 alinode 替换掉的 node 而不会产生任何副作用。目前我采用的是通过修改 docker base-image 的方式来使用的，我已经对此做了改造，并传到了我们的 docker 仓库: docker.esf.fangdd.net/fdd-alinode:4.7.2， 使用方式很简单：

1. 去阿里云[申请](https://www.aliyun.com/product/nodejs)一个账号（很重要，即使不需要你新建应用也要创建，可以把你拉进应用组，从而可以查看监控），新建一个应用，然后你将会获得一个 appid  和 secret

2.  项目根目录新建一个 alinode.config.json 文件，填入第一步中的 appId 和 secret ，下面的配置不熟悉可以先不用改

```
{
  "appid": "81645",
  "secret": "9830080f0a8f5c5dfc9f6736a9547a70b3f27e5f",
  "logdir": "/tmp/",
  "error_log": [
    "/root/.logs/error.#YYYY#-#MM#-#DD#-#HH#.log"
  ],
  "packages": [
    "</path/to/your/package.json>",
    "可以输入多个package.json的路径",
    "可选"
  ]
}
```


3. 修改 Dockerfile 文件

如果在 .gitignore 中文件忽略了 Dockerfile 文件，这是因为你使用了 rsr 框架的默认打包 Dockerfile，删掉 .gitignore 中 Dockerfile 那一行，然后新建一个 Dockerfile ，内容参考如下，只需额外关注应用名和端口号就行了

```
FROM docker.esf.fangdd.net/fdd-alinode:4.7.2

ENV HOME=/data0/nodejs/bigdata.blood.website.bp.fdd

WORKDIR $HOME

COPY . .

EXPOSE 18124

HEALTHCHECK --timeout=5s --interval=10s \
 CMD curl -f http://localhost:18124/ping/ || exit 1

CMD [ "pm2-runtime", "ecosystem.config.js" ]
```



4. 按正常的方式打包成功后，然后进入到 [控制台](https://node.console.aliyun.com/?spm=a2c4g.11186623.2.14.70f94633yFR23C&accounttraceid=585e8bc8bd5a46ac956677eef19f8a1bnvgr#!/owned) 就可以看到新加入的实例了（可能会有 1 min 的延迟）

至此，你就可以 alinode 来监控你的应用性能，同时你也可以在线打一些 heap snapshot 、GC 或者 cpu info 来排查可能出现的问题，详细的使用方式，可以参考：https://help.aliyun.com/product/60298.html?spm=a2c4g.11186623.6.540.70f94633yFR23C

## 有可能遇到的问题？

**1. 打了 heap snapshot  点击转储报错？**

由于我们使用的是 pm2 保证 node 应用的存活，这个时候如果遇到 alinode 打不到堆快照，有可能是 pm2 正在重启。

**2. alinode 版本映射问题 ?**

目前最新的 docker image 仅支持到了node@10.15.3，也就是对应到我们的  alinode@4.7.2 ，所以最新的 node@13 是用不了的，只能等 alinode 团队后续支持了。
查看详细的映射关系可参考： https://help.aliyun.com/document_detail/65376.html?spm=a2c4g.11174283.6.583.71eb30b1DT6QHc

**3. 怎么测试 alinode 效果如何？**

适当压测-等待片刻-查看效果

**4. 怎么接入钉钉告警？**

alinode 支持钉钉告警，但是目前因为一些不可抗力因素，钉钉接入自定义webhook 的功能被屏蔽了： https://www.v2ex.com/t/604762


## 参考资料：

* alinode 5分钟快速入门： https://help.aliyun.com/document_detail/60338.html?spm=a2c4g.11174283.3.1.576830b1WomRkn
* nodejs 问题排查手册（阿里）： https://github.com/aliyun-node/Node.js-Troubleshooting-Guide
* nodejs 调试指南： https://github.com/nswbmw/node-in-debugging/blob/master/2.2%20heapdump.md#222-chrome-devtools
* 朴灵 alinode 普及视频： https://yq.aliyun.com/video/play/333/
* egg: https://eggjs.org/zh-cn/intro/