# Webpack 对比 Parcel

> 最近火的一塌糊涂的打包工具`parcel`,5天左右就已经达到了**8K**个star。相对于webpack的蜗牛编译，parcel宣称**Parcel 使用 worker 进程去启用多核编译。同时有文件系统缓存，即使在重启构建后也能快速再编译**。换句话说就是高性能，这也是它最吸引人的地方。
> 
> 因为在项目被webpack折磨过，所以今天这里简单用两个小demo来测试一下。


## 官网地址

* [官方网址](https://parceljs.org/)
* [Parcel中文网](http://www.parceljs.io/)
* [Github](https://github.com/parcel-bundler/parcel)
* [其他同仁的测试](https://github.com/justjavac/parcel-example)
* [Parceljs和Webpack在React项目上打包速度对比](https://juejin.im/post/5a2b6c0cf265da431523d4e2?utm_source=gold_browser_extension)

## 初级测试

这里有两个基于`webpack`和`parcel`构建的react小项目。

* [parcel_demo](https://github.com/Michaelooo/webpackToParcel/tree/master/parcel_demo)
* [webpack_demo](https://github.com/Michaelooo/webpackToParcel/tree/master/webpack_demo)

两个小项目同时引用了 `react` ,`react-demo`,以及用于解析的`babel-preset-react`。对于`webapck`,还引入了一个解析 es6 的`babel-loader`。

### 速度对比

**parcel初次构建**（2s）

![](http://ww1.sinaimg.cn/large/86c7c947gy1fmcnecmt65j20xa05s3zh.jpg)

**parcel已打包的情况下再次构建** (556ms)
![](http://ww1.sinaimg.cn/large/86c7c947gy1fmcnecnk99j20xw05yq3w.jpg)

**webpack初次构建** (4s)
![](http://ww1.sinaimg.cn/large/86c7c947gy1fmcnecmyj6j20ps060gms.jpg)

**webpack已打包的情况下再次构建** (4s)

这里有些问题，因为未对webpack的配置做优化，比如提取公共模块，分开打包等，所以即使加了`cache = true `测出的结果和初次构建也差不多，都是 **4s**左右。

## 进一步测试

正在进行中。。。

## 总结

**不负责任版：** 根据以上情况来看，`Parcel`在速度上来看确实有不小的优势，但是如果在一个已经用了`webpack`的项目迁移的话，估计还是会有些麻烦。
