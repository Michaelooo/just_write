## **Docker是啥？**
如果有人问起了你这个问题，你可以这样回答他：**Docker就是一个轻量型的虚拟机，可以充分利用服务器性能。**

如果你的这个回答被怼了？

* 爱怼怼用户A：什么轻量型的虚拟机，跟虚拟机本质上是有区别的好吧？虚拟机多了一层guest OS，同时Hypervisor会对硬件资源进行虚拟化，运行在虚拟机上的应用程序在进行数值计算时是运行在Hypervisor虚拟的CPU上的（如果你使用过win10的hyper-v虚拟机工具，你就会发现如果要开启虚拟机就要在bios开启cpu的虚拟化）。而docker直接使用硬件资源虚拟机增加了一层虚拟硬件层，所以资源利用率相对docker低。
* 爱怼怼用户B： Docker其实也是类似于虚拟机的。至少在作用目的上是一致的。用一个“经典”的例子来作对比就是：将部署应用比作鸣人来搓螺旋丸，虚拟机类似于鸣人的影分身之术，每个分身（虚拟机）都拥有同样的身体（OS，环境）,但是在查克拉（CPU）的使用上，每个分身的查克拉会均分自真身（真正的主机），这个行为也可以称之为CPU虚拟化，但是这里浪费了分身，用分身来搓一个小螺旋丸，太浪费了……而对于docker来说，就像是九尾模式的鸣人，我直接利用我体内的九尾查克拉（硬件资源），分成九只爪子，每只爪子相互独立，也可以搓小螺旋丸……
* 爱怼怼用户C： 楼上菜鸡，直接看官方介绍不就行了，[Docker官方介绍](https://www.docker.com/what-docker)，[Docker集装箱](https://www.zhihu.com/question/22871084/answer/88293837)
* ……

对于这些，你只需回答：看来你不是都知道么……

那么使用Docker有哪些好处呢?

## **用Docker有啥好处？**

* 速度飞快以及优雅的隔离框架： 每个Docker之间互相隔离。
* 物美价廉： 服务器一台多贵晓得不，省了不少经费了。
* CPU/内存的低消耗：少了大部分虚拟机的没太大作用的硬件资源占用，自然消耗少了。  
* 快速开/关机： 相对于虚拟机肉鸡开机速度而言。
* 跨云计算基础构架： 就是云计算喽。

## **简单操作：搭建 Docker 环境**

#### **安装与配置 Docker**

**安装 Docker**

Docker 软件包已经包括在默认的 CentOS-Extras 软件源里。因此想要安装 docker，只需要运行下面的 yum 命令：

```
yum install docker-io -y
直接yum安装，安装成功后查看版本

docker -v
启动docker

service docker start
设置开机启动

chkconfig docker on
配置 Docker
```

因为国内访问 Docker Hub 较慢, 可以使用腾讯云提供的国内镜像源, 加速访问 Docker Hub

依次执行以下命令

```
echo "OPTIONS='--registry-mirror=https://mirror.ccs.tencentyun.com'" >> /etc/sysconfig/docker

systemctl daemon-reload

service docker restart
```

#### **Docker 的简单操作**

**下载镜像**

```
下载一个官方的 CentOS 镜像到本地

docker pull centos
下载好的镜像就会出现在镜像列表里

docker images
运行容器
```

这时我们可以在刚才下载的 CentOS 镜像生成的容器内操作了。

生成一个 centos 镜像为模板的容器并使用 bash shell

```
docker run -it centos /bin/bash
```

这个时候可以看到命令行的前端已经变成了 [root@(一串 hash Id)] 的形式, 这说明我们已经成功进入了 CentOS 容器。

在容器内执行任意命令, 不会影响到宿主机, 如下

```
mkdir -p /data/simple_docker
可以看到 /data 目录下已经创建成功了 simple_docker 文件夹

ls /data
退出容器

exit
查看宿主机的 /data 目录, 并没有 simple_docker 文件夹, 说明容器内的操作不会影响到宿主机

ls /data
保存容器

查看所有的容器信息， 能获取容器的id

docker ps -a
然后执行如下命令[?]，保存镜像：

docker commit -m="备注" 你的CONTAINER_ID 你的IMAGE

请自行将 -m 后面的信息改成自己的容器的信息
```

## **Docker实践，利用DaoCould来部署应用**

该部分内容过多，请直接参考我的另一篇博客：[Docker实践，利用DaoCould来部署应用]()