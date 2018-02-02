# **ng2 体验**

> 当然，现在 angular 最新的版本已经出到 5.0 了，现在才来说 ng2 有点老套了，只是最近忽然的从 react 的项目组转到了做 angular v2 (ng2) 的项目组，同时对谷歌和微软的"孩子"也比较感兴趣，所以还是有必要好好学习一下的。
> 
> 上手了一阵子，大概摸清了 ng2 的套路，其实在此之前，对于习惯了 React、 Vue 开发模式的我来说，对于 ng2 是有一定的误解的。过去的我一直以为 ng2 只是简单的视图框架，就是一个简单的模板系统，现在看来我是错了，较之于 React、 Vue 复杂的项目构建来说， ng2 才是真正的框架啊，如果你有一定的后端基础，你一定能很快的理解 ng2 知识体系， 而且你也会明白 ng2 作为一个框架对于开发效率的提升。
 
## **关于学习网站**

学习 ng2 最好的就是看官网了，当然所有的语言都是一样的，以下是几个可能需要经常去逛的网站。

1. [angular-cli 脚手架工具，快速构建项目；](https://github.com/angular/angular-cli/blob/master/README.md)
2. [angular 官网，最新的已经是 V5 版本了，可以继续深入学习；](https://v2.angular.cn/docs/ts/latest/quickstart.html)
3. [Rx.js 中文速查手册；](http://cn.rx.js.org/)
4. [javascript 的超集 typescript；](https://www.tslang.cn/docs/home.html)
5. [待补……]()

## **重要概念**

有关于 ng2 几个重要的概念如下：

* 脚手架 （ scaffold ）
* 指令（ directive ）
* 通道 （ pipe ）
* 路由 （ router ）
* 父子组件通信 （ @input & @output ）
* 模块 ( model )
* 服务 ( service )
* Rxjs ( Oberverable )
* 依赖注入 （ injectable ）

当然，赘述官方的文档不是我想要的，我更希望通过我个人的理解来介绍这几个知识点（或许有错误）

### **脚手架 （ scaffold ）**

唠叨一句：一般来说，脚手架这个东西，只有新手小白或者大牛会喜欢用，往往处于中间层的大佬们是比较鄙视的，因为这让程序变得没有技术含量，或者，被一些低级的脚手架给坑到。不过话说回来，使用好的脚手架的确能让让你的开发更加幸福，与其打开另一个文件复制代码，为何不让脚手架来给你生成呢。

ng2 (angular) 使用的脚手架是官方提供的 angular-cli ，常用的几个操作如下：


生成对象		| 命令			| 注意事项
:-------- 	|:--------  	|:-------- 
project		|ng new PROJECT-NAME |生成新项目
debug			|ng serve --host 0.0.0.0 --port 4201 |启动本地服务
Component		|ng g component my-new-component |生成 component
Directive		|ng g directive my-new-directive |生成[自定义指令](https://angular.cn/guide/attribute-directives)
Pipe			|ng g pipe my-new-pipe |生成[自定义管道](https://angular.cn/guide/pipes#%E8%87%AA%E5%AE%9A%E4%B9%89%E7%AE%A1%E9%81%93)
Service		|ng g service my-new-service |生成服务
Class			|ng g class my-new-class |生成类，几乎不用
Guard			|ng g guard my-new-guard |生成自定义路由向导，通用拦截等
Interface		|ng g interface my-new-interface |生成接口
Enum			|ng g enum my-new-enum | 生成自定义枚举文件
Module			|ng g module my-module | 生成自定义module

以上常用的几个命令参数同样的路径模式，意思就是你使用 `ng new ./test` 这样的格式也是可以的。

### **指令（ directive ）**

指令系统是 angular 的一大特色，当你写 react 你一定特别希望也有自己的指令系统（当然这是玩笑话，因为 angular 是没有用 vdom 的）。 在开发过程中，你一定与遇到过如下的指令：

**常见结构性指令 `*ngIf *ngFor *ngSwitch` 的用法：**

```
<!-- 来自官网的英雄榜例子 -->

<div *ngIf="hero" >{{hero.name}}</div>

<ul>
  <li *ngFor="let hero of heroes">{{hero.name}}</li>
</ul>

<div [ngSwitch]="hero?.emotion">
  <app-happy-hero    *ngSwitchCase="'happy'"    [hero]="hero"></app-happy-hero>
  <app-sad-hero      *ngSwitchCase="'sad'"      [hero]="hero"></app-sad-hero>
  <app-confused-hero *ngSwitchCase="'app-confused'" [hero]="hero"></app-confused-hero>
  <app-unknown-hero  *ngSwitchDefault           [hero]="hero"></app-unknown-hero>
</div>

```

**ng-template ng-container**

还有一些常用来和结构性指令结合使用的语法，类似 `ng-template ng-container` 这些。 关于这两个模板语法，其实并不是有必须要使用的必要，但在很多时候，合理的使用可以让你的代码更加语义化，或者说更加优美。关于这两个，我怕我解释不当，官网给了两个比较好的例子：

* [ng-template](https://angular.cn/guide/structural-directives#ng-template%E6%8C%87%E4%BB%A4)
* [ng-container，消除 div 带来的副作用。](https://angular.cn/guide/structural-directives#%E4%BD%BF%E7%94%A8ng-container%E6%8A%8A%E4%B8%80%E4%BA%9B%E5%85%84%E5%BC%9F%E5%85%83%E7%B4%A0%E5%BD%92%E4%B8%BA%E4%B8%80%E7%BB%84)

当然，ng-template 另外的一个用途是 [作为动态组件加载器](https://angular.cn/guide/dynamic-component-loader)。


**自定义指令**

用上面的脚手架生成最方便，也不容易出错。如下，生成一个 名为check 的指令：

```
<!-- 执行 ng g directive -->
ng g directive 

<!-- 自定义生成示例,并已在 当前 model 声明 -->
import { Directive } from '@angular/core';

@Directive({
  selector: '[check]'
})
export class CheckDirective {

  constructor() { }

}

<!--在html模板中使用-->
<input check="xxx" >

```


**问题： 官文文档会看到一种 属性型指令 和 结构性指令 ，两者有什么区别？**

答： 结构型指令 — 通过添加和移除 DOM 元素改变 DOM 布局的指令，专注于布局，ngIf 这种。
属性型指令 — 改变元素、组件或其它指令的外观和行为的指令，专注于内部属性，ngClass 这种。两种都可以自定义。


### **通道 （ pipe ）** 

### **路由 （ router ）** 

**路由重定向**

可以这么写：

```
export const routes: Routes = [
  { path: '', redirectTo: 'A', pathMatch: 'full' },
  { path: 'a', component: A },
  { path: 'b', component: B, child:{
  	[
      { path: '', redirectTo: 'b-a', pathMatch: 'full' },
      { path: 'b-a', component: ba },
      { path: 'b-b', component: bb }
    ]
  } }
];
```

**路由跳转**

可以这么写：

```
<a [routerLink]="['/a']">a</a>
```

也可以这么写：

```
this.router.navigate(['/a']);
```

**路由参数**

比如一个通知列表，点击不同的通知可以链接到不同的通知内容。

路由配置：

```
export const routes: Routes = [
  { path: '', redirectTo: 'A', pathMatch: 'full' },
  { path: 'notice-list', component: A },
  { path: 'notice-content/:id', component: B }
];
```

在 notice-list 设置路由跳转：

```
this.router.navigate(['/notice-content']，id);
this.router.navigate(['/notice-content']，params);
```
读取路由参数

```
this.route.params.subscribe(params => {
   console.log(params['id']);
});

this.route.queryParams.subscribe(params => {
   console.log(params);
});
```

**路由拦截**

使用 `ng g guard login` 来快速生成。

```
import { CanActivate } from '@angular/router';
import { Injectable } from '@angular/core';
import { LoginService } from './login-service';

@Injectable()
export class LoginRouteGuard implements CanActivate {

  constructor(private loginService: LoginService) {}

  canActivate() {
    return this.loginService.isLoggedIn();
  }
}
```

### **父子组件通信 （ @input & @output ）** 

**父组件向子组件传值**

太简单，不提了。

**子组件向父组件传值**

一般用于封装的组件。

在子组件中，使用

	@Output() outData = new EventEmitter<string>();
	……
	this.outData.emit(data);
	
在父组件中获取,定义一个 getData 事件

	<a (outData)='getData()'></a>
	


### **模块 ( model )** 

### **服务 ( service )** 

### **Rxjs ( Oberverable )** 

关于异步请求，ng2 自带的 http 模块返回的就是一个 Oberverable ，所以在项目中引入 Rx.js 自然无可厚非。官方评价为 promise 的超集，使用起来的确和 promise 很像，应该说是更加强大。但是正因为强大，导致要记的方法确实不少，直接戳一个[中文api](http://cn.rx.js.org/)。

### **依赖注入 （ injectable ）** 

