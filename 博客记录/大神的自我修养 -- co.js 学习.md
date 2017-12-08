# **大神的自我修养 co.js 的学习**

具体的介绍就不多说了。co@4.0支持promise，现在co()会返回一个promise。
![](http://ww1.sinaimg.cn/large/86c7c947gy1fm8c112bnwj20g205aglz.jpg)
## **先看用法**

## **yield支持**
co最方便的操作也就是yield的支持，现在支持yield的对象有：

* promises
* thunks (functions)
* array (parallel execution)
* objects (parallel execution)
* generators (delegation)
* generator functions (delegation)

下文在源码里有体现。

### **一个官网的小例子🌰**

```
var co = require('co');

co(function *(){
  // 执行promise
  var result = yield Promise.resolve(true);
}).catch(onerror);

co(function *(){
  // 并行执行多个promise
  var a = Promise.resolve(1);
  var b = Promise.resolve(2);
  var c = Promise.resolve(3);
  var res = yield [a, b, c];
  console.log(res);
  // => [1, 2, 3]
}).catch(onerror);

// 错误捕捉
co(function *(){
  try {
    yield Promise.reject(new Error('boom'));
  } catch (err) {
    console.error(err.message); // "boom"
 }
}).catch(onerror);

function onerror(err) {
  console.error(err.stack);
}

// 将一个generator函数转换成返回一个promise函数的方法
var fn = co.wrap(function* (val) {
  return yield Promise.resolve(val);
});

fn(true).then(function (val) {

});
```

## **看源码**

### **wrap 函数的实现**

大神写的代码就是十分的精炼，wrap 函数的实现也只是7行代码而已。

![](http://ww1.sinaimg.cn/large/86c7c947gy1fm8c92jch2j20cr0460sy.jpg)

其实有两点需要注意的，就是：

1. **没有写在原型链上而是作为一个私有方法是为了避免每次执行`co()`的时候生成一个新的wrap方法，这个方法显然没必要。**
2. **关键在于返回了一个`co()`,因为`co()`会 return 一个 promise，即生成一个新的promise。同时利用 call 和 apply 改变了 this 的指向，指向 `co` 。**

### **并行多个promise**

其实 co 方法的主体不用细看，基本就是按照 es6 promise 的一种重写。这里需要注意的一点就是并行支持promise。即，当 yield 一个 object 或者 array 的时候，并行执行多个 promise。

一开始当我听到并行的时候，是有点懵的，但看到源码的时候发现没有想得那么复杂，其实就是 promise 的原生方法的功劳：[promise.all()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/all),可以往下看。。。

![](http://ww1.sinaimg.cn/large/86c7c947gy1fm8cz6i569j20h204qdgk.jpg)

这里的 `toPromise()` 是在 next 方法的实现中执行的，关键的代码就两句：

```
var value = toPromise.call(ctx, ret.value);
if (value && isPromise(value)) return value.then(onFulfilled, onRejected);
```

然后，就是 `arrayToPromise` 和 `objectToPromise` 两个方法的实现：

![](http://ww1.sinaimg.cn/large/86c7c947gy1fm8cz6jak7j20dk0dnq49.jpg)

就是这么简单……

![](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1512702212168&di=9bc459180689c8af63056bc2c0a9ca2e&imgtype=jpg&src=http%3A%2F%2Fimg4.imgtn.bdimg.com%2Fit%2Fu%3D2105664939%2C4183524365%26fm%3D214%26gp%3D0.jpg)


### **庐山真面目，真正的源码**

```

var slice = Array.prototype.slice;

module.exports = co['default'] = co.co = co;

co.wrap = function (fn) {
  createPromise.__generatorFunction__ = fn;
  return createPromise;
  function createPromise() {
    return co.call(this, fn.apply(this, arguments));
  }
};

function co(gen) {
  var ctx = this;
  var args = slice.call(arguments, 1);

  return new Promise(function(resolve, reject) {
    if (typeof gen === 'function') gen = gen.apply(ctx, args);
    if (!gen || typeof gen.next !== 'function') return resolve(gen);

    onFulfilled();

    function onFulfilled(res) {
      var ret;
      try {
        ret = gen.next(res);
      } catch (e) {
        return reject(e);
      }
      next(ret);
      return null;
    }

    function onRejected(err) {
      var ret;
      try {
        ret = gen.throw(err);
      } catch (e) {
        return reject(e);
      }
      next(ret);
    }

    function next(ret) {
      if (ret.done) return resolve(ret.value);
      var value = toPromise.call(ctx, ret.value);
      if (value && isPromise(value)) return value.then(onFulfilled, onRejected);
      return onRejected(new TypeError('You may only yield a function, promise, generator, array, or object, '
        + 'but the following object was passed: "' + String(ret.value) + '"'));
    }
  });
}

function toPromise(obj) {
  if (!obj) return obj;
  if (isPromise(obj)) return obj;
  if (isGeneratorFunction(obj) || isGenerator(obj)) return co.call(this, obj);
  if ('function' == typeof obj) return thunkToPromise.call(this, obj);
  if (Array.isArray(obj)) return arrayToPromise.call(this, obj);
  if (isObject(obj)) return objectToPromise.call(this, obj);
  return obj;
}

function thunkToPromise(fn) {
  var ctx = this;
  return new Promise(function (resolve, reject) {
    fn.call(ctx, function (err, res) {
      if (err) return reject(err);
      if (arguments.length > 2) res = slice.call(arguments, 1);
      resolve(res);
    });
  });
}


function arrayToPromise(obj) {
  return Promise.all(obj.map(toPromise, this));
}


function objectToPromise(obj){
  var results = new obj.constructor();
  var keys = Object.keys(obj);
  var promises = [];
  for (var i = 0; i < keys.length; i++) {
    var key = keys[i];
    var promise = toPromise.call(this, obj[key]);
    if (promise && isPromise(promise)) defer(promise, key);
    else results[key] = obj[key];
  }
  return Promise.all(promises).then(function () {
    return results;
  });

  function defer(promise, key) {
    // predefine the key in the result
    results[key] = undefined;
    promises.push(promise.then(function (res) {
      results[key] = res;
    }));
  }
}

function isPromise(obj) {
  return 'function' == typeof obj.then;
}


function isGenerator(obj) {
  return 'function' == typeof obj.next && 'function' == typeof obj.throw;
}

 
function isGeneratorFunction(obj) {
  var constructor = obj.constructor;
  if (!constructor) return false;
  if ('GeneratorFunction' === constructor.name || 'GeneratorFunction' === constructor.displayName) return true;
  return isGenerator(constructor.prototype);
}


function isObject(val) {
  return Object == val.constructor;
}

```