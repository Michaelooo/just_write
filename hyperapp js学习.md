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

当然学习使用不是我们的目的，这些操作其他库中都有实现，真正感兴趣的是他说的1kb，所以还是来看袁源码吧。

