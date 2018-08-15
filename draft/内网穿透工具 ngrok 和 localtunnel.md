# 内网穿透工具 ngrok 和 localtunnel

[内网穿透工具 ngrok 和 localtunnel](https://jacobke.github.io/2016/08/31/tunnels-to-localhost/)

localtunnel 虽然较之于 ngrok 更加方便，但确实很不稳定。

在安装使用 ngrok 的过程中，需要先把下载的包解压到指定目录，解压后的文件是一个可执行文件。

```
unzip -n ngrok-stable-darwin-amd64.zip -d /tmp
cd /tmp
```

使用的时候就可以运行以下命令，比如下面是开启 3000 的端口

```./ngrok http localhost:3000```

