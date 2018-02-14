记一次 nginx 目录配置的问题

一个关于 Nginx 配置目录的问题

我有下面的一种需求。

* 假设我有两个需要部署的静态资源 **A B** ，A B 都有一个 index.html
* 我有一个已经解析到这台服务器的域名 www.111.com
* 我把它放到一台服务器上的 /var/www/A /var/www/B 两个目录

我可以实现用一个域名代理以下的请求吗？想达到以下效果的话，我该怎么去配置 Nginx 配置可以生效？

* www.111.com/ 访问 A 的 资源
* www.111.com/B 访问 B 的 资源

查阅了一些资料，发现都是使用 rewrite 来重定向。也有 设置 autoindex 的，但是这种不可取。

使用 rewrite 来重定向，发现并没有起作用，报 404 的错误。

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

最后通过使用 alias 解决了此问题

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

使用 Nginx alias 需要注意的地方：

1. 使用 alias 时，目录名后面一定要加”/“。
1. 使用 alias 标签的目录块中不能使用 rewrite 的 break。
1. alias 在使用正则匹配时，必须捕捉要匹配的内容并在指定的内容处使用。
1. alias 只能位于 location 块中

思考？

理论上讲，rewrite 是可以用的，但是在使用的时候，却总是 404，找不到指定的资源。有机会使用 rewrite 重新写一次配置文件。
