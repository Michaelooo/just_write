# hyperapp js学习

## **hyperapp 是什么鬼？**

hyperapp 是一个前端的应用构建库。初见写法，很有一种写react的亲切的感觉（其实就是一个套路），不过这肯定不能成为吸引广发gay友从而在短短两个月拿到 8K star的理由。更重要的一个原因是 官方宣称的1kb。是的， hyperapp 的核心代码只有1kb，这对早已习惯react全家桶，同时对当今web应用一个页面动辄3、4M毒害的gay友来说，的确是一个福音。基于此，官方给自己的定位是：

* 更小：只要1kb，做到其他框架应该做的；
* 更实用：主流的前端应用思想，不会对学习带来额外负担；
* 开箱即用：完善的虚拟Dom、key更新、应用生命周期。
* 以上个人翻译，有吹嘘成分

既然听起来这么厉害，今天就来一探究竟了……

## **简单的使用**

最简单的使用方法就是看官网给的 **计数器** 示例，可以在 [这里]() 查看最终效果：

```
<body>
<script src="https://unpkg.com/hyperapp"></script>
<script>

// ******划重点

const { h, app } = hyperapp

const state = {
  count: 0
}

const actions = {
  down: value => state => ({ count: state.count - value }),
  up: value => state => ({ count: state.count + value })
}

const view = (state, actions) =>
  h("div", {}, [
    h("h1", {}, state.count),
    h("button", { onclick: () => actions.down(1) }, "–"),
    h("button", { onclick: () => actions.up(1) }, "+")
  ])

window.main = app(state, actions, view, document.body)

// *****划重点
</script>
</body>
```

显而易见，state 定义了应用的状态， view 定义了应用的视图，通过 h 方法生成一个虚拟Dom,也就是可以被浏览器解释的结点树，action 则定义了应用的一些行为逻辑，最后在通过 app 方法挂载到真实的Dom元素结点上。

当然这只是很简单的使用。对于已经习惯了react写法的我们来说，我们可能在 view 的部分更习惯写纯函数，或者说一些牵扯到生命周期的操作，当然这些在 hyperapp 中也是可以的。

具体的操作可以参考 [**官方文档**](https://github.com/hyperapp/hyperapp/blob/master/docs/concepts/)。

## **看源码吧还是**

当然学习使用不是我们的目的，这些操作其他库中都有实现，真正感兴趣的是他说的1kb，所以还是来看源码吧。

核心的方法只有两个，h 函数 和 app 函数，h函数很简单，只是用来构建 dom 结点的。源码如下：

```
/**
 * 先来看h的用法，作用是生成一个虚拟dom节点
 * name 可以是 一个标签名字符串，如‘div’, 也可以是一个已经被渲染的component，如‘h(div,'',)’
 * props 标签的属性定义，如‘class’，事件等
 * 不定参数，都会当做当前节点的子节点计算
 */

export function h(name, props) {
  var node
  var stack = []
  var children = []

  for (var i = arguments.length; i-- > 2; ) {
    stack.push(arguments[i])
  }

  while (stack.length) {
    if (Array.isArray((node = stack.pop()))) {
      for (i = node.length; i--; ) {
        stack.push(node[i])
      }
    } else if (null == node || true === node || false === node) {
    } else {
      children.push(typeof node === "number" ? node + "" : node)
    }
  }

  return typeof name === "string"
    ? {
        name: name,
        props: props || {},
        children: children
      }
    : name(props || {}, children)
}
```

app 方法则是项目的入口，整个构建的操作其实在这里执行。在app函数里又定义了许多常用的工具方法，比如 createElement（创建元素），getKey（获取元素结点的key），removeElement（移除元素）等等。又很多，这里不在一一分析，重点方法只有两个 init 方法和 patch方法。

