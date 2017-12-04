# webpack奇淫巧技
## webpack做持久化缓存
[参考原文地址](https://juejin.im/entry/5a0567f9518825293b4fc74e?utm_source=gold_browser_extension)

![持久化缓存](https://t1.picb.cc/uploads/2017/12/04/p5OwL.png)

## postcss解决兼容问题
![postcss解决兼容问题](https://t1.picb.cc/uploads/2017/12/04/p5ALi.png)

## 利用webpack-dashboard改善控制台用户体验
![webpack-dashboard](https://t1.picb.cc/uploads/2017/12/04/p58hv.png)
[Github](https://github.com/FormidableLabs/webpack-dashboard)

使用方法：

```
// Import the plugin:
var DashboardPlugin = require('webpack-dashboard/plugin');

// If you aren't using express, add it to your webpack configs plugins section:
plugins: [
    new DashboardPlugin()
]

// If you are using an express based dev server, add it with compiler.apply
compiler.apply(new DashboardPlugin());
```