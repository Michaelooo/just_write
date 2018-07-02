# API Gateway 工具 kong

![](http://ww1.sinaimg.cn/large/86c7c947gy1fsqtxszp0wj21h80j6772.jpg)

> 项目需要，需要对微服务化下的 API 做统一管理，查阅相关资料，给出 kong + cassandra 的实现方案，中间也涉及到微服务以及 API Gateway 的相关知识。以下是关于研究过程中以及实施步骤中的总结笔记。

## 什么是 kong ? 


首先呢，kong 是一个基于 Nginx_Lua 模块写的高可用，易扩展由 Mashape 公司开源的 API Gateway 项目，如果你对 API Gateway 有什么误解，可以先来了解下 [什么是 API Gateway ](https://www.kancloud.cn/good-rain/micro-services/248957)，API Gateway 是服务于微服务架构的一种API解决方案。好像有点绕，举个例子简单来理解一下： 

比如，我们的一个简单来自的购物操作，中间可能涉及到 购物车、下单、评论、快递服务等操作。在一个非微服务的架构里面，客户端想要完成整个购物流程，就需要常见的 REST 请求来获取数据，我们可能在服务层用了一些负载均衡，那么这些请求就会分发到多个应用实例中并作出响应。

但是在一个微服务的体系中，购物车、下单、评论等，这样都可以独立成一个服务出来，也就是我们说的微服务。客户端想要完成整个购物流程，可以去单独的请求某个服务来获取数据。听起来可能有点怪怪的，我为了完成一个购物操作，从之前的一次请求变成了n次请求，毕竟我们知道，客户端频繁的请求的成本是不低的。所以，直接由客户端发n次请求这种事，一般来说是没人会这么干的，那么怎么干呢，就是 API Gateway 来处理了。API Gateway 其实也是一个服务器，所有的请求首先会经过这个网关。这里做 权限控制，安全，负载均衡，请求分发，监控等操作。这里也许放个官网的图会容易解释些：

![](http://ww1.sinaimg.cn/large/86c7c947gy1fsqtusglhvj21s40iojub.jpg)

我们不去讨论微服务和 API Gateway 的好坏，但是 kong 确实就是为微服务而生，并且做着这么一件事情的。相关的 API Gateway 方案还有 [nginx 自家的 API Gateway 工具：nginx plus](https://www.nginx.com/solutions/api-gateway/)。


## kong 的安装 ？

现在 kong 的版本已经迭代到 0.13.x 了，推荐使用新版来实践。

关于 kong 的安装，官网给出了基于多种平台的安装方案，可以在 [这里](https://konghq.com/install/) 查看。比如我个人的平台是 macOS ，就可以按照官方给出的方案，很方便的使用 brew 来安装 kong 。不过需要注意的是，kong 是不支持 Windows平台 的安装的，不接受提问（因为我也不知道为啥没有）。但是没有不代表不可以用，因为 kong 是支持 docker 部署的，而 docker 是支持 Windows 的，所以你可以安装 docker 来部署 kong，并且，从我个人实践的过程中来看，使用 docker 是最方便的部署方式。下面就介绍使用 docker 的部署方式：

对了，首先，你得安装个 [docker](https://www.docker.com/)。

**第一步：创建一个 docker 私有网络**

kong-net 是网络标识名字，最好个性一些。

```
docker network create kong-net
```

**第二步：启动或配置一个 cassandra (or PostgreSQL) 服务器**

如果你还没有 cassandra 服务，那么你可以启动一个,比如下面就是启动了一个 cassandra v3 的docker container，并且映射了9042端口，那么你最后暴露出来的 cassandra 服务就是 `localhost:9042`，记下这个地址，后面会用到。

```
docker run -d --name kong-database \
              --network=kong-net \
              -p 9042:9042 \
              cassandra:3
```

当然，如果你已经有了现成的 Cassandra 服务了，那么就不用这一步了，记下服务地址，后面会用到。

**第三步：kong 启动准备，数据库准备**

官方把这一步叫做 migrations，你可以把这一步理解为修改 kong 配置。

```
docker run --rm \
    --network=kong-net \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=xxx" \
    -e "KONG_CASSANDRA_PORT=9042"\
    -e "KONG_CASSANDRA_KEYSPACE=kong"\
    -e "KONG_DB_UPDATE_PROPAGATION=10"\
    kong:latest kong migrations up
```

这一步的动作其实就是创建一个临时用来写配置的容器来进行写配置。其中 xxx 就是第二步中的 Cassandra 地址。如果你需要使用 PostgreSQL 服务，只需要设置相应的参数就可以了,具体可以参考[kong configuration](https://docs.konghq.com/0.13.x/configuration/)，官方 github 也给出了一个模板配置文件供参考：[kong.conf.default](https://github.com/Kong/kong/blob/master/kong.conf.default)。 需要注意的就是，如果使用上面参数的形式来配置，那么大概就是这么的对比关系： `db_update_propagation => KONG_DB_UPDATE_PROPAGATION`。

**第四步：启动 kong**

启动 kong ，并对外暴露 8001 端口，最终的 `host:8001` 即 kong 对外暴露的网关 url 。

```
docker run -d --name kong \
    --network=kong-net \
    -e "KONG_DATABASE=cassandra" \
    -e "KONG_CASSANDRA_CONTACT_POINTS=xxx" \
    -e "KONG_CASSANDRA_PORT=9042"\
    -e "KONG_CASSANDRA_KEYSPACE=kong"\
    -e "KONG_DB_UPDATE_PROPAGATION=10"\
    -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
    -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
    -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
    -e "KONG_ADMIN_LISTEN=0.0.0.0:8001, 0.0.0.0:8444 ssl" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 8444:8444 \
    kong:latest
```


### 集群

当然，上面的 kong 只是部署在了一个结点，如果是一个集群，需要部署在多个结点的话，可以参考[这里](https://docs.konghq.com/0.13.x/clustering/#multiple-nodes-kong-clusters)。

## kong 可视化界面

当成功部署了 kong 之后，我们可以使用 curl 来测试是否生效，比如我的 kong 是部署在本机，那么执行：

```
curl http://localhost:8001
```

那么就会得到当前 kong 结点的配置信息。更多操作可以可以参考[这里](https://docs.konghq.com/0.13.x/admin-api/)。

但是我们有一种更好的办法是，替换终端操作使用 kong 的可视化界面来管理 kong 。目前关于 kong 使用比较多的开源可视化工程模板有两个，一个是 [koa-dashboard](https://github.com/PGBI/kong-dashboard)，使用 angular 和 koa ,一个是 [konga](https://github.com/pantsel/konga)，使用 sails 和 angular ，推荐使用前者。使用方法如下：

**1. 下载**

下载源代码: `git clone https://github.com/PGBI/kong-dashboard.git`

**2. 安装**

安装方式有两种，一种是使用 npm ，但是需要全局安装 kong-dashboard，这样对于测试生产主机不友好，所以选择第二种，打包 docker 来安装。如果我们想要直接使用，并且部署的主机可以访问 docker 官方镜像仓库，那么执行：

```
docker run --rm -p 8080:8080 pgbi/kong-dashboard start \
  --kong-url http://locahost:8001\
  --basic-auth admin=123456
```
http://locahost:8001 可以换成自己的 kong 对外暴露的 url。

但是，如果说要部署的主机存在某些限制或者我们想自己定制 dashboard 的源代码，我们可以自己打包镜像的方式来操作。在源代码工程目录下执行 

```docker build -t xxxx.com/kong-dashboard .```

（这样做的原因是，一般各家公司都有自己的 docker registry，我们可以更改 Dockerfile 来定制我们自己的镜像），然后执行

```
docker push xxxx.com/kong-dashboard
```

这样我们部署的时候，就可以直接执行：

```
docker run --rm -p 8080:8080 xxxx.com/kong-dashboard start \
  --kong-url http://locahost:8001\
  --basic-auth admin=123456
```

最后打开浏览器打开 `xxx:8080 `,看到的效果大概是这个样子的：

![](http://ww1.sinaimg.cn/large/86c7c947gy1fsquhlol2dj22wi1o2qdu.jpg)

**大功告成！**




## 遇到的问题？

kong 的整体部署过程还是很和谐，并没有什么大问题，倒是在 docker 的使用出现了一些小问题。

**1. kong-dashboard 版本问题**
 
kong-dashboard docker镜像的版本并不是最新的，最新的已经支持到了 V3.3， 而 `pgbi/kong-dashboard` 是 V3.0 ，功能上还是差了一些的。

在部署主机没有外网访问权限的情况下，最后我使用了离线打包 docker 的方式来获取最新版，详细操作如下：

1. 本地打包： `docker save -o xxxx.docker image(镜像名称)` ， xxxx.docker 是输出的离线文件，
2. 传输至远程主机： 使用 rsync 传输至远程主机： `rsync -cavzP ./xxxx.docker root@host:/path`，
3. 装再: 进入到 xxxx.docker 路径并执行： `docker build -i xxxx.docker`

之后本机就成功装在最新版本的 kong-dashboard 镜像了。 

**2. cassandra 可视化管理工具**

在此之前，其实对 cassandra 并未耳闻，简单了解后知道是一套开源分布式 NoSQL 数据库系统。习惯了 mongo 的 studio 3T ，redis 的 RDM 的数据可视化，关于 cassandra 的可视化管理工具貌似并不多，特别是针对 macos 系统的。

查阅相关资料后，最后选择了 [tableplus](https://tableplus.io/)， 免费版虽有限制，但也够用。



