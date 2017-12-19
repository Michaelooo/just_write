---
title: 'ES6黑科技实践--proxy,reflect'
date: 2017-12-19 14:36
categories:
  - 前端
tags:
  - ES6
  - proxy
  - reflect
---

# **ES6黑科技实践--proxy,reflect**

## **开始之前**

[** reflect兼容性**](https://kangax.github.io/compat-table/es6/#test-Reflect)

![](http://ww1.sinaimg.cn/large/86c7c947gy1fmm18swndlj220c0ttauh.jpg)

[**proxy兼容性**](https://caniuse.com/#search=proxy)

![](http://ww1.sinaimg.cn/large/86c7c947gy1fmltxsptfxj21yq11710d.jpg)

上面两图分别是截止当前，proxy和reflect的浏览器支持程度。可以看出proxy和reflect的支持已经相当好了，新一点的主流浏览器都支持了（除了IE）。

所以还是相当有必要玩耍一下的。

## **proxy**

### **简单介绍**

其实es6出来了这么久了，在实际的项目中也都使用es6编程。对于某些特殊的属性，如proxy，虽然用的不多，但我们或多或少也了解到proxy的用法。详细的介绍这里不赘述，可以移步[**MDN**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy)查看es6介绍，当然这里也有一篇大神的[**es6使用大全**](http://pinggod.com/2016/%E5%AE%9E%E4%BE%8B%E8%A7%A3%E6%9E%90-ES6-Proxy-%E4%BD%BF%E7%94%A8%E5%9C%BA%E6%99%AF/)，值得深究。

总之，用一句话总结就是：改变了过去对象监听的复杂操作，使用proxy可以用一种更优雅的方式实现外部对对象的访问。

### **es5的实现**

那么或许问题来了，在没有proxy之前，我们是怎么样实现对对象的监听呢？

其实在es5中，我们可以使用 `Object.defineProperty`和`Object.defineProperty`来实现对对象的监听。利用es5对象的getter 和 setter方法，可以实现简单的文件监听，使用方法如下：


```
// 如何实现一个自存档对象。 当设置temperature 属性时，archive 数组会获取日志条目。
function Archiver() {
  var temperature = null;
  var archive = [];

  Object.defineProperty(this, 'temperature', {
    get: function() {
      console.log('get!');
      return temperature;
    },
    set: function(value) {
      temperature = value;
      archive.push({ val: temperature });
    }
  });

  this.getArchive = function() { return archive; };
}

var arc = new Archiver();
arc.temperature; // 'get!'
arc.temperature = 11;
arc.temperature = 13;
arc.getArchive(); // [{ val: 11 }, { val: 13 }]
```

目前支持双向绑定的Vue中的实现就是这种方法。但是这种方法不太好的地方就是对于数组之类的对象，类似修改数组的length，直接用索引设置元素如items[0] = {}，以及数组的push，pop等变异方法是无法触发setter的。针对这些，vue中的实现是在Object和Array的原型添加了定制方法来处理这些特殊操作，可以实现上述要求。

### **第三方库的实现**

请移步：

* [Vue.js](https://github.com/vuejs/vue)
* [Watch.js](https://github.com/melanke/Watch.JS/blob/master/src/watch.js)
* [Angularjs](https://github.com/angular/angular)
* [Knockout.js](https://github.com/knockout/knockout)



## **reflect**

### **怎么理解reflect**
reflect 是es6新增的一个全局对象。顾名思义，**反射**，类似于Java里面的反射机制。在Java里面，反射是个很头疼的概念。简单理解为：**通过反射，我们可以在运行时获得程序或程序集中每一个类型的成员和成员的信息。对于Java来说，程序中一般的对象的类型都是在编译期就确定下来的，而Java反射机制可以动态地创建对象并调用其属性，这样的对象的类型在编译期是未知的。所以我们可以通过反射机制直接创建对象，即使这个对象的类型在编译期是未知的。**

而对于js来说自然是有些不同了。毕竟**js不需要编译**，同时**万物皆对象**的特性，这些都让理解js的reflect起来相当简单。

对于JS中的reflect，我们就可以理解为：**有这么一个全局对象，上面直接挂载了对象的某些特殊方法，这些方法可以通过`Reflect.apply`这种形式来使用，当然所有方法都是可以在 Object 的原型链中找到的。**是不是相当简单。

### **使用reflect的好处**

引自[知乎专栏：ES6 Reflect](https://zhuanlan.zhihu.com/p/24778807)

1. Reflect上面的一些方法并不是专门为对象设计的，比如Reflect.apply方法，它的参数是一个函数，如果使用Object.apply(func)会让人感觉很奇怪。
2. 用一个单一的全局对象去存储这些方法，能够保持其它的JavaScript代码的整洁、干净。不然的话，这些方法可能是全局的，或者要通过原型来调用。
3. 将一些命令式的操作如delete，in等使用函数来替代，这样做的目的是为了让代码更加好维护，更容易向下兼容；也避免出现更多的保留字。

### **常见的方法**

```
Reflect.apply
Reflect.construct
Reflect.defineProperty
Reflect.deleteProperty
Reflect.enumerate // 废弃的
Reflect.get
Reflect.getOwnPropertyDescriptor
Reflect.getPrototypeOf
Reflect.has
Reflect.isExtensible
Reflect.ownKeys
Reflect.preventExtensions
Reflect.set
Reflect.setPrototypeOf
```

具体用法当然是看：[MDN: reflect介绍](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Reflect)

## **一个使用proxy和reflect实现监听对象的小例子**

栗子来源(非本人):[https://github.com/sindresorhus/on-change](https://github.com/sindresorhus/on-change)

on-change是一个可以监听对象或者**数组**内部变化的小工具，主要使用proxy来实现。以下是核心代码：

```
// onChange 即要进行的监听操作
module.exports = (object, onChange) => {
	const handler = {
		get(target, property, receiver) {
			try {
				return new Proxy(target[property], handler);
			} catch (err) {
				return Reflect.get(target, property, receiver);
			}
		},
		defineProperty(target, property, descriptor) {
			onChange();
			return Reflect.defineProperty(target, property, descriptor);
		},
		deleteProperty(target, property) {
			onChange();
			return Reflect.deleteProperty(target, property);
		}
	};

	return new Proxy(object, handler);
};
```

代码很精简，但是也是有必要研究下，是一位大大牛 **[sindresorhus](https://sindresorhus.com/)** 的作品。

其实一共有三个方法，`get` `defineProperty` [defineProperty](),上面代码可以对数组进行操作就是因为用了proxy，具体的实现在`get`方法，每一层返回一个proxy，需要注意的是在监听操作这里依然使用的是 es5的 defineProperty 方法。具体的可以自己研究下，还是很有可玩性的。

## **参考**

* [《深入理解ES6》笔记——代理（Proxy）和反射（Reflection）API](https://segmentfault.com/a/1190000010471230)
* [ES6 之 Proxy 介绍](http://www.jianshu.com/p/34f0e6abe312)
* [实例解析 ES6 Proxy 使用场景](http://pinggod.com/2016/%E5%AE%9E%E4%BE%8B%E8%A7%A3%E6%9E%90-ES6-Proxy-%E4%BD%BF%E7%94%A8%E5%9C%BA%E6%99%AF/)
* [知乎回答：如何监听 js 中变量的变化?](https://www.zhihu.com/question/44724640?sort=created)
* [知乎专栏：ES6 Reflect](https://zhuanlan.zhihu.com/p/24778807)