一个关于Nginx配置目录的问题

我有下面的一种需求。

* 假设我有两个需要部署的静态资源 **A  B** ，A B都有一个index.html
* 我有一个已经解析到这台服务器的域名 www.111.com
* 我把它放到一台服务器上的  /var/www/A   /var/www/B 两个目录

我可以实现用一个域名代理以下的请求吗？想达到以下效果的话，我该怎么去配置Nginx配置可以生效？

* www.111.com/  访问A的 资源
* www.111.com/B 访问B的 资源

查阅了一些资料，发现都是使用 rewrite 来重定向。也有 设置 autoindex 的，但是这种不可取。

使用 rewrite 来重定向，发现并没有起作用，报404的错误。

```
server {
	http / {
		root /var/www/A;
		index index.html;
	}
	http /b/ {
		if ($uri = /b/) {
			rewrite /b/$ /var/www/B;
			index index.html;
		}
	}
}
```

最后通过使用alias解决了此问题

```
server {
	http / {
		root /var/www/A;
		index index.html;
	}
	http /b/ {
		alias /var/www/B;
	}
	
}
```


使用Nginx alias 需要注意的地方：

1. 使用alias时，目录名后面一定要加”/“。
1. 使用alias标签的目录块中不能使用rewrite的break。
1. alias在使用正则匹配时，必须捕捉要匹配的内容并在指定的内容处使用。
1. alias只能位于location块中

思考？ 

理论上讲，rewrite 是可以用的，但是在使用的时候，却总是404，找不到指定的资源。有机会使用 rewrite 重新写一次配置文件。