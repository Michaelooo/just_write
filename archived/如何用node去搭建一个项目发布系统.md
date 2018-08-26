# 如何用 node 去搭建一个项目发布系统


> 最近在处理一个静态资源系统的发布平台，大概意思就是对于多环境的静态项目，希望可以通过系统控制来改变过去繁琐的项目的部署方式，同时对于静态页面引入的一些接口请求则通过全局的网关来控制来处理跨域。权衡利弊之后，采用最熟悉的 node 来实现这么一个功能，后端框架选用 koa@2 ，前端使用 react 来做管理界面。

项目的部署作为软件开发过程中的最后一环，往往也是最容易出问题的地方。所以，一套优雅的部署方式以及一套完善的部署监管对于项目的稳定运行也有着至关重要的作用。关于部署，有很多已经有一定规模的第三方管理平台，比如 jerkins、travis，以及微软的 TFS 等，都已经是有一套完善的机制，同时也有庞大的用户群。不过另一方面，技术服务于业务需求，所以各家公司因为需求的不一致，对以上产品的使用难以做到合适的定制化，也会选择自研一些项目发布系统。轮子该造还是得造的嘛！

有关项目发布系统，本质上是设计大于实现的，但关于系统的设计我也并不能聊什么，基本大同小异，我就聊下实现的过程的遇到的一些问题好了。项目最重要的有两个部分，一个就是全局的网关控制，另一个就是项目的部署。我就从这两个入手好了。

## 网关控制

在过去的一些部署方案里，对于一些轻量的静态页面，如果涉及到一些页面的跨域请求，我们通常的做法是做一层 Nginx 代理，这样做的后果是，当项目的发布一旦达到一定数量级，那么就要不停的去更新 Nginx 的配置，同时还要重启，这样的方式的确太不优雅了。

所以为了更方便的管理，我们使用一个开源的 API gateway 工具来控制。如果不了解 kong 是什么，可以先来看一下这篇文章： [微服务 api GateWay 工具： kong](http://www.chengpengfei.com/2018/06/29/)。

kong 的使用很简单，没有什么特别大的问题，但有两点需要注意，一个是 kong 的迭代目前有些快，我使用的时候是 0.13，但是现在看已经是 0.14 了，所以可能会有更新的变化需要做兼容处理，另一个就是，kong 提供的 admin 接口在于 koa 实践的过程中，并不是那么契合，特别是在异常捕捉这里，你需要对 kong 的异常行为在 koa 里面单独处理。


## 项目的部署

### 文件的解压

对于上传的部署文件都是以压缩包的形式存在的，所以我们需要对项目文件进行解压，这里在我的实践我调研了三个库

* [node-unzip](https://github.com/EvanOxfeld/node-unzip) ：支持 stream 的方式读文件，但文件过大，会导致报错 [Error: invalid signature: 0x6064b50](https://github.com/EvanOxfeld/node-unzip/issues/110)
* [decompress](https://github.com/kevva/decompress)：不支持 stream 的方式读文件，提取文件的过程无法捕捉
* [compressing](https://github.com/node-modules/compressing)：支持 stream 的方式读文件，提取文件过程操作方便

最后我选择使用了第三种方案，过程中遇到最大的问题是，如果你要使用以 stream 的方式解压文件，这种效率最快，但当你使用 fs.createReadStream 去创建一个只读流，然后又使用 fs.createWriteStream 创建了多个写入流，这时候你无法无获取最后一个写入流结束时的状态，这个问题还是困扰了我，最后我只能用这种方式，使用 setTimeout() 函数来“保证”在写入完成之后才可以进行接下来的操作，大致的代码如下：

```
const compressingStream = async (ctx, source, target, options) => {
  return new Promise((resolve, reject) => {
    let isExist = fs.existsSync(source);
    if (!isExist) {
      reject(new Error('file not exist'))
      return;
    }
    let targetExist = fs.existsSync(target);
    if (!targetExist) {
      mkdirp.sync(target);
    }
    fs.createReadStream(source)
      .on('error', function (error) {
        reject(error)
      })
      .pipe(new compressing.zip.UncompressStream())
      .on('error', function (error) {
        reject(error)
      })
      .on("finish", function() {
        resolve("ok");
      })
      .on("entry", function(header, stream, next) {
        stream.on("end",next);
        <!--不是一个好的解决方案，设置延时函数-->
        setTimeout(() => {
          resolve('ok');
        }, 2000);
        

        let fileName = header.name;
        let type = header.type;
        if(options && !/^__MACOSX\//.test(fileName)){
          fileName = path.join(options.prefix, fileName);
        }

        let reg = /^\d|\s/;
        if (reg.test(fileName)) {
          reject(new Error(fileName + "文件名称不合法,不允许空格或者数字开头"));
        }
        if (!/^__MACOSX\//.test(fileName) && type === "file") {
          stream.pipe(fs.createWriteStream(path.join(target, fileName)));
        } else if (!/^__MACOSX\//.test(fileName) && type === "directory") {
          // directory
          mkdirp(path.join(target, fileName), err => {
            if (err) return reject(err);
            stream.resume();
          });
        }
      });
  });
};
```


### CDN 的处理

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

听起来并不是什么复杂的操作，但是在真正的执行的时候，问题还是挺多的，因为要发布的目标主机是在 docker 内部，当然这不是最大的痛点，最大的痛点是我要操作的服务机器没有外网访问权限。下面就几个遇到的问题做一些分析总结：

**1. docker 中不存在 rsync 的命令？**

看到这个，你可能会觉得很简单，没有 rsync 的命令，使用 linux 的 apt-get 或者类似的工具安装一下就好了啊。但是如上所说，测试主机是没有外网访问权限的，所以直接安装这种方法是不可行的。

当然，即使没有外网访问权限，对于一些常用的包，我们也有一些类似的镜像源，我们只需要在安装的时候修改一下这个源就可以了，这个应该大部分公司都是一样的。这个方法当然是可行的，但是我还是放弃了。因为项目的迭代性比较高的话，我认为每次都在打包镜像的时候，去修改 docker 内部 apt-get 的源再安装，不是很优雅的方式。所以为了以后更好的执行类似的操作，我采用构建一个 node+rsync 精简的基础镜像，构建方法如下：

第一步，新建 Dockerfile, 这里我用的基础 node 镜像是 node:8-alpine，Dockerfile 内容如下

```
FROM node:8-alpine
RUN apk add --no-cache rsync
```

第二步，进入到 Dockerfile 文件目录，本地构建镜像

```
docker build -t xxxx.com/node-rsync .
```

第三步，或者部署到内部 docker 镜像服务

```
部署到内部镜像服务,也可以指定版本，默认为 latest
docker push xxxx.com/node-rsync

```

第四步，无推送权限的情况下，推送到目标主机（非必需）


```
docker save -o node-rsync.docker xxx.com/node-rsync   //打包离线docker文件：node-rsync.docker
rsync -cavzP ./xxxx.docker root@host:/path    //使用 rsync 推送到目标主机
docker load -i xxxx.docker   //本地离线安装镜像

```


**2. 在 docker 中使用 rsync 传输公钥密钥的问题**

因为使用 rsync 传输需要一次密码认证，所以我们需要对 rsync 做一次免密认证。解决思路就是在构建的镜像里生成本机的公钥，然后将公钥添加到部署主机的 `~/.ssh/authorized_keys` 中来实现免密登陆。当然更进一步，如果每次构建镜像的时候都生成一次公钥再添加这样的操作是很冗余的。所以我们可以生成一个通用的公钥密钥，在每次构建的时候只需要复制到镜像内部即可以解决。

以下是详细的构建脚本：

```
BUILD_TIME=`date "+%Y%m%d%H%M"`
SERVER_HOST=""
SERVER_PATH="/home/web"
CONTAIN_NAME='web'
IMAGE_NAME="xxx.com/web:$BUILD_TIME"
rsync -cavzP --delete-after ./ --exclude-from='.rsync-exclude' $SERVER_HOST:$SERVER_PATH
ssh $SERVER_HOST "\
  cd $SERVER_PATH; \
  echo "删除旧容器";\
  docker stop web;\
  docker rm web; \

  echo "清理过时的测试镜像"; \
  docker images | awk '/^xxx.com\/web[ ]+/ { print $3 }' | xargs docker rmi -f; \
  
  echo "构建docker镜像 $IMAGE_NAME"; \
  docker build -t $IMAGE_NAME . ;\

  echo "发布docker镜像"; \
  docker push $IMAGE_NAME ;\

  echo "docker start"; \
  docker run -d -p 7777:3000 -e NODE_ENV=test \
  --hostname ubuntu-14 \
  -v /data/package/:/data/package/ \
  -v /home/:/home/ \
  --name=$CONTAIN_NAME $IMAGE_NAME ; \

  echo "生成 .ssh 目录"; \
  docker exec -i $CONTAIN_NAME \
  mkdir -p  ~/.ssh/ ;\
  echo "ok"; \

  echo "复制公钥,为了ssh登陆"; \
  docker exec -i $CONTAIN_NAME \
  cp -rf ./auth/test/* ~/.ssh/ ;\
  echo "ok"; \

  echo "修改权限"; \
  docker exec -i $CONTAIN_NAME \
  chmod 0600 ~/.ssh/id_rsa ;\
  echo "ok"; \

  echo "模拟登陆主机：首次使用rsync登陆主机存在验证合法性的问题"; \
  /usr/bin/expect << EOF
    
    set timeout -1
    spawn docker exec -it $CONTAIN_NAME ssh $SERVER_HOST ; \
    expect { 
      "*yes/no" { send "yes\\r"; exp_continue}
      "*\#" {exit } ;\
    }

  EOF ;\
  exit; \
  "


echo "\033[40;32m\n"
echo "Sync to Server: $SERVER_HOST"
echo "Build source code path: $SERVER_PATH"
echo "Image: $IMAGE_NAME"
echo "Image deploy success."
echo "\033[0m"


```

以上

