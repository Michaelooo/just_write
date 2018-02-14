# 玩转 centos

常用的都记住在脑袋里，不常用的来烂笔头了。

## 查看硬件配置

* **查看 cpu 信息：** `more /proc/cpuinfo`
* **查看内存：** `free -m`
* **查看磁盘空间占用：** `df -h`

## 通过 ssh 传输文件

**将本地文件/文件夹拷贝到远程**

scp 文件名用户名@计算机 IP 或者计算机名称:远程路径

本地 192.168.1.8 客户端

`scp /root/install.* root@192.168.1.8:/usr/local/src`

添加 -r 表示传输文件夹

**从远程将文件/文件夹拷回本地**

scp 用户名@计算机 IP 或者计算机名称:文件名本地路径

本地 192.168.1.8 客户端取远程服务器 12、11 上的文件

```
scp root@192.168.1.12:/usr/local/src/*.log /root/
scp root@192.168.1.11:/usr/local/src/*.log /root/
```

添加 -r 表示传输文件夹

## 新装 centos 有公网 IP 不能访问（阿里云）？

1. 检查防火墙设置。[参考](https://www.cnblogs.com/rainy-shurun/p/6195448.html)
2. 添加网络安全规则。[参考](https://help.aliyun.com/knowledge_detail/40596.html?spm=5176.10695662.1996646101.searchclickresult.672801fccvjRWb)

## 网站设计架构，善用 OSS 和 CDN

买了阿里云的 ECS 服务之后，会有赠送的 OSS 资源包和 CDN 资源包。CDN 熟悉，但是 OSS 就不知道了，于是简单了解了一下，发现网站在遇到性能瓶颈的时候使用 OSS 和 CDN 可以很好的提升性能。但是需要注意的是，OSS 在超出资源包的范围之后是按量付费的，个人使用无影响，企业使用应该资源也过得去。

### 为什么要用 OSS 和 CDN？

过去的网站架构设计，会比较慢。
![](http://ww1.sinaimg.cn/large/86c7c947gy1fmf4onh6alj20we0qwjtv.jpg)

![](http://ww1.sinaimg.cn/large/86c7c947gy1fmf4onek69j210w0uc78f.jpg)

### 怎么使用？

赠送的 OSS (腾讯的叫 COS）和 CDN 使用方法，需要有域名。[参考](https://www.alibabacloud.com/help/zh/doc-detail/31936.htm)
