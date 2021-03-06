## 换新电脑不用慌-轻松搞定 vscode 配置

> 写这个总结的目的是因为发现很多同学并不是很了解 vscode 的隐藏功能。因为之前自己经常换电脑，换出心得了已经，遂总结下。

相信大家都曾有更换新电脑的经历，换新电脑肯定是件开心的事，但是每次换新电脑后复杂的软件配置和数据同步却是件很令人头痛的事情。

同样的，作为一名前端工程师，`vscode` 可能是大部分开发者的灵魂伴侣，但是这个伴侣在有些事情上却并不是那么如意，灵活的配置和丰富的插件生态是 `vscode` 受到大家喜爱的根本，但是在更换新电脑的时候， `vscode` 对于插件的管理的备份却有点捉襟见肘（如果 `vscode` 可以集成微软的账号同步服务那也是个不错的选择，但是作为一个开源软件，微软并不会这么干）。所幸的是 `vscode` 是基于配置的，所以你可以通过**拷贝你的插件配置文件**来达到新电脑同步的目的，但是这样一样存在配置丢失的风险，并且操作也略显复杂。不过显然会有另外一种比较优雅的方式，那就是使用 `Setting Sync` 来同步配置。



### Setting Sync

`Setting Sync` 也是 `vscode` 的一个插件，他利用 `github` 的 `gist` 作为你的配置文件的存储载体，所以理论上只要你的 github 账户不丢失，你的配置文件就不会丢失。同时值得一提的就是，你的这些配置文件还具有版本管理的功能，所以你对配置文件所做的变更都一清二楚。

废话就不多说了，现在来说怎么使用吧。

#### 前置条件

首先，你得有一个 `github` 的账户（别说你没有），如果你已经有了账户，那么 `github` 就会自动给你创建 `gist` 账户，简单的理解就是 **github 之于 项目代码 犹如 gist 之于 代码段**。你可以随意的新建你的代码段，比如这是 [我的代码段](https://gist.github.com/Michaelooo) 。

#### 如何使用？

因为每个人的使用方式都不一样的，所以下面涉及的操作我尽量不使用 快捷键 来提示。

1. **安装 Setting Sync 插件**

   直接在 vscode 插件面板输入 Setting Sync下载安装即可。

2. **新建一个 token**

   为什么需要 token ，因为你需要 授权 Setting Sync ，这个插件可以访问并创建 gist。 

   安装完成之后，需要[新建一个 token ](https://github.com/settings/tokens)，然后勾选的权限只给一个 gist 就可以了，**generate token** 之后复制生成的 token。![](https://shanalikhan.github.io/img/github2.PNG)

   **生成的 token 不用担心丢失，如果不记得了，重新生成一个即可，但是不要把 token 随便给别人。**

3. **新建或者配置 gist 文件**

   你可以调出 vscode 的快捷命令窗口 `cmd + shift + P`，键入 sync 来进行 **上传设置** 操作。**需要注意与 git 的命令区分**。

   

   ![](http://ww1.sinaimg.cn/large/86c7c947gy1fumzabi2bej20f708tdir.jpg)

   

   如果你是第一次使用，那么会提示你输入上个步骤生成的 token ，粘贴回车，第一次上传设置会自动新增一个 gist 的配置，生成成功之后会有成功的提示:

   

   ![](http://shanalikhan.github.io/img/upload2.png)

   

   **生成的 gistID 一定要记住，最好可以保存下来，如果实在记不住，可以去个人的 gist 列表里开启双目扫描查找**。例如这是 [我的 gist 列表](https://gist.github.com/Michaelooo) 。

4. **同步/下载 配置**

   以上的步骤做完，就代表你的 Setting Sync 可以正常使用了，通常，你只需要 调出快捷命令窗口，然后输入 sync 就可以查看并使用 Setting Sync 的同步或者下载配置了（使用快捷键会更方便）。

   即使你更换了新电脑，只要你记得第三个步骤里保存的 gistid，同步也是非常方便的（第二步生成的 token 不记得也没关系，重新生成一个就好）。你可以通过 `cmd + shift + P`  --> `sync 高级选项` --> `编辑本地扩展设置` ，将你的 token 粘贴在配置文件里，然后再执行同步/下载的配置即可，具体如下：

   ```json
   {
     "ignoreUploadFiles": ["projects.json", "projects_cache_vscode.json", "projects_cache_git.json", "projects_cache_svn.json", "gpm_projects.json", "gpm-recentItems.json"],
     "ignoreUploadFolders": ["workspaceStorage"],
     "ignoreExtensions": [],
     "replaceCodeSettings": {},
     "gistDescription": "Visual Studio Code Settings Sync Gist",
     "version": 300,
     "token": "put token in there",
     "downloadPublicGist": true,
     "supportedFileExtensions": ["json", "code-snippets"],
     "openTokenLink": true
   }
   
   ```

   之后进行 **下载设置** 的时候，根据提示输入对应的 gistid ，然后 回车 就可以静静地等待插件下载完成了（下载完成需要重启 vscode）。

5. **新建用户配置的gist**

   因为 Setting Sync 是针对插件的同步，所以你还可以将你的用户配置文件放到 gist 上，等到更换新电脑的时候取回即可。



### 插个嘴

其实 vscode 还有一个很好用但是很少人用的功能就是**工作区**啊，感觉我 一、二十个项目代码没有这个会疯掉的。当然这个功能好像所有的 IDE 都有，不过为啥就是很少人用呢。



以上！
