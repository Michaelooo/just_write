# nginx知识备忘
## Nginx是什么？


引用百科的话说，**Nginx** (engine x) 是一个高性能的HTTP和反向代理服务器,也可以作为IMAP/POP3/SMTP邮件服务器。Nginx很轻（占用内存少）、Nginx支持高并发、Nginx足够稳定，当然还有一点，Nginx开源。

## 怎么学习Nginx
任何编程语言的学习都应当是理论加上实践，特别是对于码农来说，你的真知往往来自于你的实践。Nginx作为服务器的一门技术，更偏向于运维知识，而且其中大部分的知识其实需要具有一定的业务场景你才可以实践的到，所以对于**Nginx**的学习，我的想法是理论学习、引经论述、归纳总结、简单实践，具体到深入的业务场景再深入学习。
基于以上的学习需求，并结合我英语水平差的现状我选择下面这两个网站：

* [Nginx中文网](http://www.nginx.cn/doc/)
Nginx的中文文档，排版和易读性都比官网要好一些，但是要看最新相关还是看英文原版好一些
* [阿里关于Nginx的实践](http://tengine.taobao.org/)
**Tengine**,官网给的自我介绍是：Tengine(T-engine)是由淘宝网发起的Web服务器项目。它在Nginx的基础上，针对大访问量网站的需求，添加了很多高级功能和特性。Tengine的性能和稳定性已经在大型的网站如淘宝网，天猫商城等得到了很好的检验。它的最终目标是打造一个高效、稳定、安全、易用的Web平台。因为基于Nginx，所以官网也提供了Nginx的中文文档。

当然还有一种方法是看视频，个人推荐但不支持看视频。推荐是因为对于大部分人（我的名字叫大部分人）来说，服务器的知识就像海底的冰山，看到就会有种莫名的恐惧。看视频可以让你对服务器的知识做一个大致的梳理，帮助你理清思路。不支持的原因也很简单，现在的学习视频价格不菲，而且讲的知识点都比较基础，特别对于Nginx来说，个人觉得更加没必要。


## 关于反向代理服务器的几个疑问？
### 1.正向代理和反向代理的区别？
[知乎：反向代理为何叫反向代理？](https://www.zhihu.com/question/24723688/answer/128105528)
个人理解来说，可以总结为两点：
- **反向代理和正向代理都是代理**，看到这儿你可能要问，为什么需要代理服务器呢？其实原因如下：用代理服务器的一个好处是可以使你的IP地址不被暴露出去，比如下面的去访问百度的host时，会发现返回的是 www.a.shifen.com 的结果。同样的，新浪搜狐等一些大型网站都有类似的解决方案。想要了解更多，可以看这里，[为什么要使用代理服务器，代理服务器的优势](https://www.aliyun.com/zixun/content/3_12_81613.html)
图片
另外的一个好处就是你常见的 vpn ，这其实也是一种代理的体现。
- **反向代理代理的是服务器响应**，即你得到的响应可能是来自一个服务器集群的结果。**正向代理代理的是客户端请求**，减轻服务端压力，代理请求。
<br>
### 2.适合做反向代理服务器的有哪些？
传统的服务器比如IIS或者Apache用来做反向代理，其实略显臃肿。Nginx常被用来做反向代理服务器的原因是足够稳定，足够轻量，并且支持高并发。
[几种反向代理服务器比较。](http://blog.csdn.net/zhu_tianwei/article/details/19396527)


### 3.Nginx、Apache和之前用的Tomcat有什么区别？
[知乎：tomcat 与 nginx，apache的区别是什么？](https://www.zhihu.com/question/32212996)
### 4.Nginx的配置文件怎么看？
先放一个完整的Nginx配置文件
```
#user  nobody; 运行的用户，设置配置文件访问权限
worker_processes  1; 可以启动的进程，通常设置为与CPU核心数目相同

#日志文件记录
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

# 
events {
    #epoll是多路复用IO(I/O Multiplexing)中的一种方式,
    #仅用于linux2.6以上内核,可以大大提高nginx的性能
    use   epoll; 
    worker_connections  1024; # 单个进程的最大并发连接数

    #此处参考： http://www.nginx.cn/76.html
    # 并发总数是 worker_processes 和 worker_connections 的乘积
    # 即 max_clients = worker_processes * worker_connections
    # 在设置了反向代理的情况下，max_clients = worker_processes * worker_connections / 4  为什么
    # 为什么上面反向代理要除以4，应该说是一个经验值
    # 根据以上条件，正常情况下的Nginx Server可以应付的最大连接数为：4 * 8000 = 32000
    # worker_connections 值的设置跟物理内存大小有关
    # 因为并发受IO约束，max_clients的值须小于系统可以打开的最大文件数
    # 而系统可以打开的最大文件数和内存大小成正比，一般1GB内存的机器上可以打开的文件数大约是10万左右
    # 我们来看看360M内存的VPS可以打开的文件句柄数是多少：
    # $ cat /proc/sys/fs/file-max
    # 输出 34336
    # 32000 < 34336，即并发连接总数小于系统可以打开的文件句柄总数，这样就在操作系统可以承受的范围之内
    # 所以，worker_connections 的值需根据 worker_processes 进程数目和系统可以打开的最大文件总数进行适当地进行设置
    # 使得并发总数小于操作系统可以打开的最大文件数目
    # 其实质也就是根据主机的物理CPU和内存进行配置
    # 当然，理论上的并发总数可能会和实际有所偏差，因为主机还有其他的工作进程需要消耗系统资源。
    # ulimit -SHn 65535
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server {
        #侦听80端口
        listen    80;
        #定义使用 www.nginx.cn访问
        server_name  www.nginx.cn;
 
        #定义服务器的默认网站根目录位置
        root html;
 
        #设定本虚拟主机的访问日志
        access_log  logs/nginx.access.log  main;
 
        #默认请求
        location / {
            
            #定义首页索引文件的名称
            index index.php index.html index.htm;   
 
        }
 
        # 定义错误提示页面
        error_page   500 502 503 504 /50x.html;
        location = /50x.html {
        }
 
        #静态文件，nginx自己处理
        location ~ ^/(images|javascript|js|css|flash|media|static)/ {
            
            #过期30天，静态文件不怎么更新，过期可以设大一点，
            #如果频繁更新，则可以设置得小一点。
            expires 30d;
        }

 
        #禁止访问 .htxxx 文件
            location ~ /.ht {
            deny all;
        }
    }
```
### 5.怎么用Nginx做负载均衡？
一个负载均衡的例子，把www.domain.com均衡到本机不同的端口，也可以改为均衡到不同的地址上
```
http {
    upstream myproject {
    server 127.0.0.1:8000 weight=3; #weight 表示权重
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
    server 127.0.0.1:8003;
  }

  server {
    listen 80;
    server_name www.domain.com;
    location / {
        proxy_pass http://myproject; #定向到myproject
    }
  }
}
```
### 6.Nginx虚拟主机？
要在Nginx里面配置多个虚拟主机，首先需要新建几个虚拟主机。一个虚拟主机其实就可以理解一个虚拟操作系统。通常的，这个虚拟主机可以存在在虚拟机或者docker里面。对于Linux，你也可以通过命令行来创建虚拟主机。可以参考：[Linux 中http中创建虚拟主机实例](http://wodemeng.blog.51cto.com/1384120/1538310)

Nginx里面配置虚拟主机
```
http {
    server {
        listen          80;
        server_name     www.domain1.com;
        access_log      logs/domain1.access.log main;
        location / {
        index index.html;
            root  /var/www/domain1.com/htdocs;
        }
    }
    server {
        listen          80;
        server_name     www.domain2.com;
        access_log      logs/domain2.access.log main;
        location / {
            index index.html;
            root  /var/www/domain2.com/htdocs;
        }
    }
}
```
### 7.Nginx缓存处理？
这一方面理解不是很深入，看看先人的博客来学习一下
- [如何利用Nginx的缓冲、缓存优化提升性能](http://www.cnblogs.com/bokejiayuan/p/4233332.html)
- [nginx缓存cache的5种方案](http://www.jb51.net/article/77602.htm)
- [nginx的web缓存服务环境部署记录](http://www.cnblogs.com/kevingrace/p/6198287.html)
