## **JS 参数验证： Joi 四问 **

以下内容均可在[Joi官方地址](https://github.com/hapijs/joi/blob/v13.1.0/README.md)参考（文档略长，英文），本文仅为个人总结的几个小疑问。

### 1. 定义 **schema** 时 **Joi.object.keys()** 和 **Joi.object()** 有什么区别？

答： 并没有什么区别，官方给了三种定义 `schema` 的方式。如下：

```
// 使用 { } 来定义
const schema = {
    a: Joi.string(),
    b: Joi.number()
};

// 使用 Joi.object()
const schema = Joi.object({
    a: Joi.string(),
    b: Joi.number()
});

// 使用 Joi.object.keys()
const schema = Joi.object().keys({
    a: Joi.string(),
    b: Joi.number()
});

```

三种方式实现的效果其实都是一样的，但是在使用的时候会有一些略微不同，具体如下：

* 当使用 {} 时，只是定义了一个普通的js对象，它不是一个完整的 schema 对象。你可以将它传递给验证方法，但不能调用对象的validate（）方法，即类似这种 `object.validate()`的操作是不可以的，因为它只是一个普通的js对象。此外，每次将{}对象传递给validate（）方法，都将对每个验证执行一个昂贵的模式编译操作。
* 当使用 Joi.object() 时，相对于使用 {} ，这是正经的schema 对象，它会在第一次编译，所以你可以多次将它传递给validate（）方法，不会增加开销。另外，你还可以设置 options 来验证。
* 当使用 Joi.object.keys() 时，其实和使用 Joi.object() 是类似的，但是当你想添加更多的键（例如多次调用keys（））时，使用joi.object（）.keys（[schema]）会更有用。如果只添加一组键，则可以跳过keys（）方法，直接使用object（）。有些人喜欢用keys（）来使代码看起来更加精确（其实这只是一种编程风格）。

### 2. Joi.validate(value, schema, [options], [callback])中的 options 取值有哪些？

答：options可用的值有如下：

* **abortEarly：** 设置true，可以在检测到第一个错误时立即返回，默认false（检查全部）。推荐设置true
* **convert：**设置true，可以尝试将值转换为所需的类型（例如，将字符串转换为数字）。默认为true。推荐采用默认
* **allowunknown：** 设置true，则允许对象包含被忽略的未知键。默认为false。推荐设置true
* **skipfunctions：**如果为true，则忽略具有函数值的未知键。默认为false。推荐采用默认
* **stripunknown：** 如果为true,从对象和数组中删除未知的元素。默认为false。也可以特殊的设置成 `{ objects: true , arrays: true }`的形式，可以对象和数组分别处理。推荐采用默认
* **presence：** 设置默认的可选需求。支持的模式：'optional','required',和'forbidden'。默认为'optional'。推荐采用默认
* **escapehtml：** 当为true时，出于安全目的，错误消息模板将特殊字符转义为html实体。默认为false。推荐采用默认
* **nodefaults：**如果为true，则不应用默认值。默认为false。推荐采用默认
* **context：** 提供一个外部数据集用于引用。只能设置为外部选项来验证（）而不使用any.options（）。使用方法：

```
const schema = Joi.object().keys({
    a: Joi.ref('b.c'),
    b: {
        c: Joi.any()
    },
    c: Joi.ref('$x')
});

Joi.validate({ a: 5, b: { c: 5 } }, schema, { context: { x: 5 } }, (err, value) => {});
```

* language: 设置默认的错误提示。修改可参考：[默认](https://github.com/hapijs/joi/blob/v13.1.0/lib/language.js) 

### **3. 我需要 promisify Joi.validate 方法吗？**

答： 其实只是两种写法，promise和非promise的写法。首先，Joi.validate() 的写法很像promise，但是还真不是promise实现的，所以你不用promise的写法就像这种（官网的这种）：

```
// 场景： 在一个CGI的入口请求参数验证

const data = { a : '123' };

let schema = Joi.object().keys({
	a: Joi.string().required()
});

const {error, query} = Joi.validate(data, schema);

if (error) {
	// 需要人工处理异常
	console.log(error);
}
```

使用promise的写法，就是下面这种，必须要使用 promisify 的，而且强制建议必须要使用 try-catch。

```
// 场景： 在一个CGI的入口请求参数验证

const Promise = require('bluebird');
const JoiValidatePromise = Promise.promisify(Joi.validate);

try {

    const data = { a : '123' };

	let schema = Joi.object().keys({
		a: Joi.string().required()
	});
	
	const query = await JoiValidatePromise(data, schema);   
	  
} catch (error) {
	// 使用 catch 捕获错误
    console.log(error);
}

```

两种写法都可以，没有孰好孰坏，不过更推荐第二种写法，利用try-catch全局捕获错误，另外 Joi 的维护者 [目前在实现 async 的写法](https://github.com/hapijs/joi/issues/1194)， 到时候应该就是直接支持promise了，那就不用promisify了，妙哉。

### **4. 希望可以有一个包罗万象的例子？**

答：如下：

```
let testData = { xxx };

let paramSchema = Joi.object().keys({
    username: Joi.string().alphanum().min(3).max(30).required(),
    password: Joi.string().regex(/^[a-zA-Z0-9]{3,30}$/),
    access_token: [Joi.string(), Joi.number()],
    birthyear: Joi.number().integer().min(1900).max(2013),
    email: Joi.string().email(),
    website: Joi.string().uri({
        scheme: [
            'git',
            /git\+https?/
        ]
    }),
    search: Joi.string().allow(''),
    type: Joi.string().valid('disabled', 'normal', 'all').default('all'),
    startTime: Joi.date().min('1-1-1974').max('now'),
    endTime: Joi.when( Joi.ref('startTime'), { is: Joi.date().required(), then: Joi.date().max('1-1-2100') } ),
    page: Joi.number().integer().min(1).default(1),
    pageSize: Joi.number().integer().default(8),
    deleteWhenLtTen: Joi.number().integer().max(10).strip(),
    arraySelect: Joi.array().items(Joi.string().label('My string').required(), Joi.number().required()),
});

let { error, value } = Joi.validate(testData, paramSchema, { allowUnknown: true, abortEarly: true });
if (error) {
    throw error;
}
query = value;
```

简单的使用可以看上面，详细的使用直接看 [API](https://github.com/hapijs/joi/blob/v13.1.0/API.md)



喏，这就是一篇总结文，可能还会继续增加内容，笑纳。