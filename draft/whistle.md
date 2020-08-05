## 使用 whistle 来用 【线上的数据 + 本地代码】 进行 debug

举个例子： 数据治理平台的血缘图数据测试环境几乎都没有，所以本地开发就很麻烦，可以用这种方式来处理。



配置 [whistle](https://wproxy.org/whistle/) 的匹配规则

```shell
# 将 app-xxxx.js 核心文件映射到本机
^static.esf.fangdd.com/esf/bigdatabloodwebsitebpfdd/***-c59b85660082d252c448.js http://127.0.0.1:18124/esf/bigdatabloodwebsitebpfdd/$1.js

# 因为映射到本机的 app 进行动态加载时是没有hash后缀的代码，所以设置动态加载的 js 文件
^dgp.fangdd.cn/esf/bigdatabloodwebsitebpfdd/***.js http://127.0.0.1:18124/esf/bigdatabloodwebsitebpfdd/$1.js

# 线上本来的 vendor.js 和 style.js 可以忽略，因为都走本地的 app 文件了
```



可能遇到的问题：

whistle 会设置系统代理，很容易与本机的代理设置冲突，所以最好在谷歌浏览器中用个 proxy switchOmega 来管理代理

