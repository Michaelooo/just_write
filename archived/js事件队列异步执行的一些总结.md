# **关于JS事件队列的一些总结**


## **关于任务队列**

其实之所以我们要去关心JS的任务队列，主要还是因为JS的单线程的特质决定。

### **为什么JavaScript是单线程？**

本段来自阮老师的博客中对JS单线程的介绍。

> JavaScript语言的一大特点就是单线程，也就是说，同一个时间只能做一件事。那么，为什么JavaScript不能有多个线程呢？这样能提高效率啊。
> 
> JavaScript的单线程，与它的用途有关。作为浏览器脚本语言，JavaScript的主要用途是与用户互动，以及操作DOM。这决定了它只能是单线程，否则会带来很复杂的同步问题。比如，假定JavaScript同时有两个线程，一个线程在某个DOM节点上添加内容，另一个线程删除了这个节点，这时浏览器应该以哪个线程为准？
> 
> 所以，为了避免复杂性，从一诞生，JavaScript就是单线程，这已经成了这门语言的核心特征，将来也不会改变。
> 
> 为了利用多核CPU的计算能力，HTML5提出Web Worker标准，允许JavaScript脚本创建多个线程，但是子线程完全受主线程控制，且不得操作DOM。所以，这个新标准并没有改变JavaScript单线程的本质。

### **任务队列的本质**

* 所有同步任务都在主线程上执行，形成一个执行栈（execution context stack）。
* 主线程之外，还存在一个"任务队列"（task queue）。只要异步任务有了运行结果，就在"任务队列"之中放置一个事件。
* 一旦"执行栈"中的所有同步任务执行完毕，系统就会读取"任务队列"，看看里面有哪些事件。那些对应的异步任务，于是结束等待状态，进入执行栈，开始执行。
* 主线程不断重复上面的第三步。

## **关于 setTimeOut、setImmediate、process.nextTick()的比较**


### **setTimeout()**

* 将事件插入到了事件队列，必须等到当前代码（执行栈）执行完，主线程才会去执行它指定的回调函数。
* 当主线程时间执行过长，无法保证回调会在事件指定的时间执行。
* 浏览器端每次`setTimeout `会有4ms的延迟，当连续执行多个`setTimeout `，有可能会阻塞进程，造成性能问题。

### **setImmediate()**

* 事件插入到事件队列尾部，主线程和事件队列的函数执行完成之后立即执行。和setTimeout(fn,0)的效果差不多。
* 服务端node提供的方法。浏览器端最新的api也有类似实现:[window.setImmediate](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/setImmediate),但支持的浏览器很少。

### **process.nextTick()**

* 插入到事件队列尾部，但在下次事件队列之前会执行。也就是说，它指定的任务总是发生在所有异步任务之前，当前主线程的末尾。
* 大致流程：当前"执行栈"的尾部-->下一次Event Loop（主线程读取"任务队列"）之前-->触发process指定的回调函数。
* 服务器端node提供的办法。用此方法可以用于处于异步延迟的问题。
* 可以理解为：此次不行，预约下次优先执行。

## **关于消除 setTimeout 延迟的实践：soon.js**

### **why?**
如`setTimeout` 的介绍所言，浏览器端每次`setTimeout `会有4ms的延迟，当连续执行多个`setTimeout `，有可能会阻塞进程，造成性能问题。

`soon.js`就是关于这个问题的一个好的实践。但其实大多数情况我们不必为这4ms的延迟计较，除非你在一次执行中`setTimeout`的次数足够多。代码很短，可以用来学习下。

### **使用方法**
可以参考[示例](https://jsfiddle.net/0tscgwe6/2/)

### **源码：**

```
// See http://www.bluejava.com/4NS/Speed-up-your-Websites-with-a-Faster-setTimeout-using-soon
// 使用 soon.js 处理在浏览器端 settimeout（大量调用），4ms * n 的延迟问题


var soon = (function() {
	
		var fq = []; // 事件队列;
	
		function callQueue()
		{
			while(fq.length) // 执行队列中事件
			{
				var fe = fq[0];
				fe.f.apply(fe.m,fe.a) // 执行队列中事件
				fq.shift(); 
			}
		}
	
        // 异步执行队列事件，最大效率
		var cqYield = (function() {
	
				// 通过 MutationObserver 来监听 Dom 来执行回调，此法最快
				if(typeof MutationObserver !== "undefined")
				{
					var dd = document.createElement("div");
					var mo = new MutationObserver(callQueue);
					mo.observe(dd, { attributes: true });
	
					return function(fn) { dd.setAttribute("a",0); } // trigger callback to
				}
	
				// 如果支持 setImmediate ，采取此策略，其实 setImmediate 和 setTimeout(callQueue,0) 差不多
				if(typeof setImmediate !== "undefined")
					return function() { setImmediate(callQueue) }
	
				// 没办法了，就用 setTimeOut 的办法
				return function() { setTimeout(callQueue,0) }
			})();
	
		return function(fn) {
                // 队列事件装载进一个数组
				fq.push({f:fn,a:[].slice.apply(arguments).splice(1),m:this});
	
				if(fq.length == 1) // 在添加第一个条目时，启动回调函数
					cqYield();
			};
	
	})();
```

### **分析**

其实，值得分析就是一个新的东西--`MutationObserver`。

`MutationObserver`给开发者们提供了一种能在某个范围内的DOM树发生变化时作出适当反应的能力.该API设计用来替换掉在DOM3事件规范中引入的[Mutation](https://developer.mozilla.org/zh-CN/docs/DOM/Mutation_events)事件.

简而言之，就是这个东西比`setTimeOut`，`setImmediate`快，浏览器支持就用它就行了。

关于`soon.js`的更详细的介绍可以查看这篇文章。[Speed up your Websites with a Faster setTimeout using soon()](http://www.bluejava.com/4NS/Speed-up-your-Websites-with-a-Faster-setTimeout-using-soon)

`MutationObserver`给开发者们提供了一种能在某个范围内的DOM树发生变化时作出适当反应的能力.该API设计用来替换掉在DOM3事件规范中引入的[Mutation](https://developer.mozilla.org/zh-CN/docs/DOM/Mutation_events)事件.



## **参考博客：** 

* [setTimeout和setImmediate以及process.nextTick的区别](http://www.cnblogs.com/cdwp8/p/4065846.html)

* [JavaScript 运行机制详解：再谈Event Loop](http://www.ruanyifeng.com/blog/2014/10/event-loop.html)