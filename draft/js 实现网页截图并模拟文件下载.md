js 实现网页截图并模拟文件下载

## 网页截图

如果想要实现一个网页截图，我们通常想到的实现方式就是： 先找到对应的 dom 节点，然后绘制成一个canvas ，然后使用 canvas.toDataUrl 方法生成 base64 格式的图片。这种情况，我们一般使用 [html2canvas](<https://github.com/niklasvh/html2canvas>) 来实现，使用很方便。如果 dom 节点中包含有 一些复杂的 svg 标签，我们同样可以使用 [rasterizeHTML.js](https%3A%2F%2Fgithub.com%2Fcburgmer%2FrasterizeHTML.js) 将 svg hack 成 canvas。

## 模拟下载

1. 使用 window.open 直接打开模拟下载

```js
// 作为 png 图片下载

export const downloadAsPng = (id, fileName) => {

  const query = `${id} canvas_1`;

  const element = document.querySelector(query);

  html2canvas(element).then((canvas) => {

    const img = canvas.toDataURL('image/png');

    const aLink = document.createElement('a');

    aLink.download = fileName || '血缘分析图';

    aLink.style.display = 'none';

    aLink.href = img;

    document.body.appendChild(aLink);

    aLink.click();

    document.body.removeChild(aLink);

  });

};

```

2. 新建一个隐藏的 a 元素，模拟点击事件下载

```js
// 作为 blob 下载

export const downloadAsBlob = (id, fileName) => {

  const query = `${id} canvas_1`;

  const element = document.querySelector(query);

  html2canvas(element).then((canvas) => {

    const img = canvas.toDataURL('image/png');

    const aLink = document.createElement('a');

    aLink.download = fileName || '血缘分析图';

    aLink.style.display = 'none';

    const blob = new Blob([img]);

    aLink.href = URL.createObjectURL(blob);

    document.body.appendChild(aLink);

    aLink.click();

    document.body.removeChild(aLink);

  });

};
```



## 参考

1. [浅析 js 实现网页截图的两种方式](<https://juejin.im/entry/58b91491570c35006c4f7fdf>)
2. [实现Google带截图功能的web反馈插件](<https://juejin.im/post/5afd2a0c5188251b8015de1d>)
3. [纯JS生成并下载各种文本文件或图片](<https://juejin.im/post/5bd1b0aa6fb9a05d2c43f004>)