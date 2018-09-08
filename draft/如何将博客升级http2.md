最近有在学习 http2 的相关知识，就想着顺便把自己的博客升级一下，其实升级后并不会带来很大的性能提升，不过当做学习用的个人实践也是不错的。

## 怎么升级 http2 ?

### 升级 https

升级的过程其实是很简单，但是因为 http2 必须需要 https 的支持，所以要想用到 http2 ，必须要先使用 https， 使用 https 的话就需要生成证书，所以其实这个步骤才是升级过程中略显复杂的一环。

### 生成 https 证书

证书的话，因为只是个简单的个人网站，在安全性上也并没有太大的要求，所以证书的颁发机构采用大家都喜欢用的开源证书颁发机构 [let's encrypt](https://letsencrypt.org/) 就行了， 关于这个证书的生成就使用大家都喜欢的 [cerbot 生成工具](https://certbot.eff.org/lets-encrypt/centos6-nginx) 就行了。推荐使用官网推荐的 cerbot-auto 脚本的方式来生成证书，你需要做的就是填写邮箱和你的域名之类的操作。

这个生成的过程会有一些小坑，我在下面的 **踩坑总结： 使用 cerbot-auto 生成 Let's Encrypt 证书遇到的问题** 有提及。生成之后，可以使用 `./certbot-auto certificates` 查看你生成的证书的位置。另外有一点需要注意的是，通过上面的这种方式生成的证书的有效期是 90 天，所以到时间了要记得自己去重新生成。

### 配置 nginx 

因为我使用的是 Nginx 服务器，所以只需要简单的配置就可以使用 https ， 配置的内容大致如下：

```nginx
server {
	listen 443 ssl;	
	listen [::]:443 ssl ipv6only=on;
	server_name www.chengpengfei.com;
	ssl_certificate /etc/letsencrypt/live/www.chengpengfei.com/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/www.chengpengfei.com/privkey.pem;
	ssl_trusted_certificate /etc/letsencrypt/live/www.chengpengfei.com/chain.pem;
}
```

一般情况下，再配置好 web 目录， 重启 Nginx 就可以了就可以看到效果了。但是因为我使用了 docker ，所以还不行，请接着往下看。

### 在 docker 中使用 Nginx

因为我是直接在 docker 中使用的 Nginx，我需要让**我的证书以及我定义的 Nginx 配置**对 docker 容器可见。在这里我一开始的思路有两个，第一是通过 Dockerfile 来指定 volume ，然后生成一个新的镜像，并构建容器，一种是直接使用 docker run -v 的形式去构建容器。

表面上看起来第一种的方式更为优雅些，但是在我的实践中发现，第一种方式并不可行，无法挂载到指定的文件路径，查阅了相关资料发现，**当你要重新构建一个docker的image时，在Dockerfile 里指定的 volume 是无效的，因为 image 应是纯净的，不包含有指定路径的。** 所以最后我选择了第二种方式，具体的命令大致如下：

```shell
docker run -d \
-p 80:80 \
-p 443:443 \
--name nginx-blog \
-v "$PWD/html":/usr/share/nginx/html \
-v /var/www/blog/:/var/www/blog/ \
-v /var/www/my_resume/:/var/www/my_resume/ \
-v /home/blog_nginx/:/etc/nginx/ \
nginx
```

可以看到，直接输入命令的方式可能不是很优雅，但是却有效。不过有一个推荐的做法就是将命令保存到一个脚本文件里面，通过脚本来构建也是一个不错的选择。

容器构建成功，就可以访问网站来查看效果了。下面是我的网站更换的效果，由 **不安全 变成了 并非完全安全**😂

![Imgur](https://i.imgur.com/DASIzJQ.jpg)



### 配置 http2

配置 http2 的方式更加简单，直接在 Nginx 的配置里更改就可以了（我用的是最新版的 nginx ，所以是支持 http2 的，别用太老的版本都支持的）。

```nginx
server {
	listen 443 http2 ssl;
	listen [::]:443 http2 ssl ipv6only=on;
	……
}
```

之后重新构建一个容器即可，来看个开启了 http2 之后的效果。

这个是之前的：

![](http://ww1.sinaimg.cn/large/86c7c947gy1fv27gvnz6yj22tu0hmgtd.jpg)

这个是 使用 http2 之后的：

![](http://ww1.sinaimg.cn/large/86c7c947gy1fv27gvjv0pj22vo0b2djw.jpg)



## 踩坑总结： 使用 cerbot-auto 生成 Let's Encrypt 证书遇到的问题

### 1. **提示 Problems with Python virtual environment ？**

官方给出的解释是 [低内存的机器会出现类似的问题](https://certbot.eff.org/docs/install.html#id7) ，但是按照官方给出的 **创建一个临时 swap 文件**的方案并没有解决。后来查阅资料确认是国内 Python mirror 的问题，因为我用的是阿里云提供的 vps ，但是阿里的Python mirror 同步不及时，所以造成安装失败。只需要修改 `/root/.pip/pip.conf` 的配置即可，可以改为其他可用的 mirror (推荐清华大学的 pypi 镜像 — https://pypi.tuna.tsinghua.edu.cn/simple) ，也可以直接注释掉使用原版的。

### **2.生成证书时，使用了 docker 部署 nginx， 但是本机并未安装 nginx ?**

cerbot 给出了两种方案来生成证书，一种是 webroot ，这种也是普遍推荐的一种，因为不需要停止你的服务，只需要在 nginx 配置里做些更改即可，生成方式可以看[这里](https://certbot.eff.org/docs/using.html#id12)，但是因为我用的是 docker 部署，本机并没有安装 nginx ，所以这种方式对我来说并不适用。另一种是 standalone ，这种方式会在本机临时建立一个服务器，但是会默认占用你的 80 端口或者 443 端口，所以这种方式需要先解除掉 80 或者 443 端口的占用， 使用 docker 的话用这种方式就很方便，直接 `docker stop containerId` 停止掉容器即可，等到证书生成完成，重新启动即可。

但这里有一个大坑是：**尽量不要去手动的 kill 掉 80 端口的 pid** ，因为关掉容易，但是不熟悉 Linux 的话，开启就会比较麻烦，我的 阿里云 ECS 是 centos 7 的版本，但是 centos 6 和 7开启端口的方式还是有很大的差异的。



以上！