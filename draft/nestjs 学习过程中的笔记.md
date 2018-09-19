## 基本概念

中文文档： https://docs.nestjs.cn/5.0/firststeps

* 控制器： controller，请求处理层
* 提供者：service， 一些服务层
* 模块：module， 通过模块分离
* 中间件：middleware ， 类似 express 
* 异常过滤器：httpexecption， 通过的异常捕捉
* 守卫：guard， 不同于中间价，可以作用于多个层
* 管道：pipe，处理管道操作
* 拦截器：intercept， 拦截具体行为
* 自定义装饰器：decoratior，可以通过装饰器来传递数据 

## solid 面向对象过程中设计原则

参考： http://www.cnblogs.com/wuyuegb2312/p/7011708.html

* 单一职责原则:  一个类应该只负责一件事、或者说一种事，类似原子性
* 开放封闭原则：顶层类应该是可扩展的，但是不可以修改的
* 里式替换原则：子类应该可以替换父类，但应该保证不能影响父类的行为
* 接口分离原则： 为了程序解耦，应该将接口进一步的做细分，接口应该足够的抽象。
* 依赖倒置原则： 高层次的模块不应该依赖低层次的模块，都应该依赖抽象，抽象不应该依赖于具体的实现，实现应该依赖于抽象。使用 依赖注入或者控制反转就是为了避免这种行为的方式。

## 面向 aop 编程

什么是面向切面编程AOP？ - 柳树的回答 - 知乎 https://www.zhihu.com/question/24863332/answer/350410712

angular 其实就是一种面向 AOP 编程的模式，AOP 编程可能会给程序带来一定的复杂度，但是对程序的扩展性是非常友好的。

## typeorm 

据说是 node 里面最好用的 orm 框架

https://cloud.tencent.com/developer/article/1012625



## angular 里面的依赖注入

https://angular.cn/guide/dependency-injection


## 单元测试
nest 使用的是 jest 的方案：
eggjs mocha的方案：



## Koa 实现 微服务，koa-compose 

https://cnodejs.org/topic/59ca9ecac5ddc93d29365033
koa 的洋葱模型其实也可以理解为一种 aop 的编程模式，koa 底层实现的机制就是 [koa-compose](https://github.com/koajs/compose/)

```js
'use strict'

/**
 * Expose compositor.
 */

module.exports = compose

/**
 * Compose `middleware` returning
 * a fully valid middleware comprised
 * of all those which are passed.
 *
 * @param {Array} middleware
 * @return {Function}
 * @api public
 */

function compose (middleware) {
  if (!Array.isArray(middleware)) throw new TypeError('Middleware stack must be an array!')
  for (const fn of middleware) {
    if (typeof fn !== 'function') throw new TypeError('Middleware must be composed of functions!')
  }

  /**
   * @param {Object} context
   * @return {Promise}
   * @api public
   */

  return function (context, next) {
    // last called middleware #
    let index = -1
    return dispatch(0)
    function dispatch (i) {
      if (i <= index) return Promise.reject(new Error('next() called multiple times'))
      index = i
      let fn = middleware[i]
      if (i === middleware.length) fn = next
      if (!fn) return Promise.resolve()
      try {
        return Promise.resolve(fn(context, dispatch.bind(null, i + 1)));
      } catch (err) {
        return Promise.reject(err)
      }
    }
  }
}
```

