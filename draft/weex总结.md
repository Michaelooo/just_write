**git clone https://github.com/CocoaPods/Specs.git 缓慢 的问题：**

cocopads specs 国内镜像站：https://juejin.im/post/5afa542ff265da0b863665a6

相关源的更换推荐： https://juejin.im/post/5a32900a6fb9a045132aba3c

解决办法：

```
pod repo remove master

git clone https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git ~/.cocoapods/repos/master

pod repo update
```



**打包出现下面的报错 You should config `CodeSign` and `Profile` in the `ios.config.json**`



基础踩坑： https://segmentfault.com/a/1190000010984857#articleHeader14