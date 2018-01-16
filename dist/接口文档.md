## 获取所有的股友数据，可查询条件

- **url**: http://localhost:3000/app/gf-litebbs/manager/get?type=all

- **method**: get

- **params:**
 
```
{
	type: 'disabled', 'normal', 'all'   必填， 代表 禁言 未禁言 全部
	name: 'y' 选填，模糊查询
	page: 1 选填。默认1
	pageSize: 8 选填，默认8
}
```

- **response:**
 
```
{
	code: 0,
	data: [
		...
		{
            "id": "5a0a7e2b2e8eb000084bc4f9",  用户id
            "portal_id": "1531877",	用户账户id
            "name": "离婚啦",	股友名称
            "status": "normal", 禁言状态
            "fans_count": 1, 粉丝数目
            "left_time": 1 剩余时长，单位小时，账户未禁用状态返回 '无'
        },
	]
}

```


## 获取所有的股友数据，可查询条件

- **url**: http://localhost:3000/app/gf-litebbs/manager/get?type=all

- **method**: get

- **params:**
 
```
{
	type: 'disabled', 'normal', 'all'   必填， 代表 禁言 未禁言 全部
	name: 'y' 选填，模糊查询
	page: 1 选填。默认1
	pageSize: 8 选填，默认8
	sortByFans: 0,1  0 = 排序，1 = 粉丝数从到小，默认时间排序
}
```

- **response:**
 
```
{
	code: 0,
	data: {
		"count": 804,
       "page": 101,
		"results": [
			...
			{
            "id": "5a0a7e2b2e8eb000084bc4f9",  用户id
            "portal_id": "1531877",	用户账户id
            "name": "离婚啦",	股友名称
            "status": "normal", 禁言状态
            "fans_count": 1, 粉丝数目
            "left_time": 1 剩余时长，单位小时，账户未禁用状态返回 '无'
        }
		]
	]
}

```

## 查询自己的所有发言

- **url**: http://localhost:3000/app/gf-litebbs/manager/fetchall/:id

- **method**: get

- **params:**
 
 同 [评论拉取接口](http://wiki.gf.com.cn/pages/viewpage.action?pageId=45939068)，多传一个 **property: 'post','comment'  对应帖子，和评论**
 

- **response:**


  同 [评论拉取接口](http://wiki.gf.com.cn/pages/viewpage.action?pageId=45939068)，


## **批量审核通过**

- **url**: http://localhost:3000/app/gf-litebbs/audit/pass

- **method**: post

- **params:**
 
```
{
	id:   评论或者帖子id
	type: 'comment','post'  必填 
}
```

- **response:**
 
```
{
	code: 0,
	msg: 'ok'
	result: {}  db执行结果，不用在意
}

```

## **批量审核不通过**

- **url**: http://localhost:3000/app/gf-litebbs/audit/deny

- **method**: post

- **params:**
 
```
{
	id:   评论或者帖子id
	type: 'comment','post'  必填 
}
```

- **response:**
 
```
{
	code: 0,
	msg: 'ok'
	result: {}  db执行结果，不用在意
}

```
## 禁言,两种模式，48小时禁言，或者限时禁言

- **url**: http://localhost:3000/app/gf-litebbs/manager/cancel-disabled/:id

- **method**: put

- **params:**
 
```
id 为用户id
```

- **response:**
 
```
{
	code: 0,
	msg: 'ok'
}

```


