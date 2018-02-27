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
* 管道 （ pipe ）
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

| 生成对象  | 命令                                | 注意事项                                                                                       |
| :-------- | :---------------------------------- | :--------------------------------------------------------------------------------------------- |
| project   | ng new PROJECT-NAME                 | 生成新项目                                                                                     |
| debug     | ng serve --host 0.0.0.0 --port 4201 | 启动本地服务                                                                                   |
| Component | ng g component my-new-component     | 生成 component                                                                                 |
| Directive | ng g directive my-new-directive     | 生成[自定义指令](https://angular.cn/guide/attribute-directives)                                |
| Pipe      | ng g pipe my-new-pipe               | 生成[自定义管道](https://angular.cn/guide/pipes#%E8%87%AA%E5%AE%9A%E4%B9%89%E7%AE%A1%E9%81%93) |
| Service   | ng g service my-new-service         | 生成服务                                                                                       |
| Class     | ng g class my-new-class             | 生成类，几乎不用                                                                               |
| Guard     | ng g guard my-new-guard             | 生成自定义路由向导，通用拦截等                                                                 |
| Interface | ng g interface my-new-interface     | 生成接口                                                                                       |
| Enum      | ng g enum my-new-enum               | 生成自定义枚举文件                                                                             |
| Module    | ng g module my-module               | 生成自定义 module                                                                              |

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

用上面的脚手架生成最方便，也不容易出错。如下，生成一个 名为 check 的指令：

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

答： 结构型指令 — 通过添加和移除 DOM 元素改变 DOM 布局的指令，专注于布局，ngIf 这种。属性型指令 — 改变元素、组件或其它指令的外观和行为的指令，专注于内部属性，ngClass 这种。两种都可以自定义。

### **管道 （ pipe ）**

如果习惯了 bash 命令的童鞋，一定对 管道 很熟悉， 你可能经常会见到 `ls xxx | grep xxx` 这种的写法，其实 ng 中的 管道 和这个其实是一个意思，写法都是一样的，通过 "|" 来分割，不过 ng 的明显要弱一些，ng 中管道的常见用法都是用来格式化钱币、数值精度、日期格式化这些操作。

**内置管道**

ng 内置了一些管道，比如 DatePipe、UpperCasePipe、LowerCasePipe、CurrencyPipe 和 PercentPipe。 它们全都可以直接用在任何模板中。

常见的[内置管道](https://angular.cn/api?type=pipe)。
![](http://ww1.sinaimg.cn/large/86c7c947gy1fo5d5hqq4fj21ic0hstar.jpg)

**自定义管道**

当内置的管道不能满足需求的时候，往往我们需要自定义自己的管道。我们可以使用 `ng g pipe my-new-pipe` 来生成自定义管道，如下是一个简单的 money 格式化的例子,对属于任意的数值，进行金额的精度控制，当然底层其实还是使用了内置的 DecimalPipe 。

```
import { Pipe } from '@angular/core';
import { DecimalPipe } from '@angular/common';

@Pipe({
  name: 'money'
})
export class MoneyPipe {

  constructor(protected decimalPipe: DecimalPipe) {

  }

  public transform(value: any, digits?: string): string | null {
    value = parseFloat(value) || 0;
    return this.decimalPipe.transform(value, digits);

  }

}
```

在需要格式化金额的地方，比如我们要保留两位小数，我们可以这么用，`{{ 10.2222 | money:'1.2-2'}}`，具体第二个精度的使用方法可以[参考](https://angular.cn/api/common/DecimalPipe)。

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

父组件使用 `[data]='{}'` 向子组件接收值，子组件通过 `@input() data` 来接收。

**子组件向父组件传值**

一般用于封装的组件。

在子组件中，使用

    @Output() outData = new EventEmitter<string>();
    ……
    this.outData.emit(data);

在父组件中获取,定义一个 getData 事件

    <a (outData)='getData()'></a>

### **模块 ( model )**

其实模块这个东西现在一点都不陌生，主流的编程框架都使用了模块化的编程方式。官方的文档是这么介绍的：

> Angular 模块是带有 @NgModule 装饰器函数的类。 @NgModule 接收一个元数据对象，该对象告诉 Angular 如何编译和运行模块代码。 它标记出该模块拥有的组件、指令和管道， 并把它们的一部分公开出去，以便外部组件使用它们。 它可以向应用的依赖注入器中添加服务提供商。

我们理解起来就是，**一个 Angular 模块 = 接收元数据对象（metadata）+ 暴露部分便于外部组件访问。** 如果不清楚什么是 **元数据** 的，可以看下官方的[介绍](https://angular.cn/guide/metadata)。

### **服务 ( service )**

在后端编程中经常会用到 服务 ( service ), 我个人的理解是，服务就是可高度抽象且与业务逻辑耦合低的一系列操作。比如所有应用场景下的登录都需要一个公用的验证码，那么生成验证码的这个功能就可以抽象成为一个服务，服务不是必须的，但是适当写服务会让代码耦合度降低，是一种好的编程习惯。

截止到目前，我用的 ng 中的服务一般是用作某一个模块的请求封装，或者是日期的一些特殊操作，就像是一个工厂方法库一样。

### **Rxjs ( Oberverable )**

关于异步请求，ng2 自带的 http 模块返回的就是一个 Oberverable ，所以在项目中引入 Rx.js 自然无可厚非。官方评价为 promise 的超集，使用起来的确和 promise 很像，应该说是更加强大。但是正因为强大，导致要记的方法确实不少，直接戳一个[中文 api](http://cn.rx.js.org/)。

### **依赖注入 （ injectable ）**

依赖注入其实之前也接触过一些， 依赖注入的目的在我看来有两个，一个是降低程序间的耦合性和复杂度，一个是减少复杂对象实例化带来的扩展问题。

关于依赖注入，这里有两篇不错的可以用来理解的文章（都是基于 java ）：

* [spring 中的控制反转和依赖注入](https://www.cnblogs.com/xxzhuang/p/5948902.html)
* [依赖注入和控制反转](http://blog.csdn.net/bestone0213/article/details/47424255)

当然 ng 中的依赖出入也差不多，而且实现方式也更优雅，东西挺多，可以看[官方文档](https://angular.cn/guide/dependency-injection#%E9%85%8D%E7%BD%AE%E6%B3%A8%E5%85%A5%E5%99%A8)。

## **总结**

其实也是刚接触 angularv2 不久，自己也只是结合过去的知识对自己认为的 ng2 做了一个总结，认识还是比较粗鄙的，行文也比较乱。

写博客总结的这个习惯，希望自己可以继续坚持下去，即使只有自己看，hahah……
