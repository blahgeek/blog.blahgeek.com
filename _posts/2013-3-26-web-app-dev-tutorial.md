---
permalink: ru-he-xie-ge-shu-dong.html
classification: project
layout: post
title: 如何写一个树洞
tags: django python treehole thu
---

>其实这篇文章的标题应该大概是“一个简单的网页应用是如何搞出来的”，
因为之前有好几个同学问过我类似的问题，而且根据贵系的培养方案不知道要到
猴年马月才能了解相关内容，于是以简单的树洞为例写一下。
这不是一个教程，因为省略了太多细节，只是说明一下整个应用是怎么回事，
需要准备什么东西，我认为这样的入门有时候占用了我们太多的搜索时间。

### 域名和服务器

树洞的域名thutreehole.tk是从[dot.tk](http://dot.tk/)免费申请的，也可以购买收费的域名（.com, .net等），
价格约每年十美元。域名只是一个名称，需要将其指向运行着网站的服务器的IP地址，没有服务器的话可以使用
自己在寝室的电脑，国外一般配置的虚拟服务器的价格大概是每月十美元左右。

### 服务器端

服务器端就是要接受用户的浏览器发送过来的请求，对其进行处理，返回相应的页面。
服务器端可以用各种语言写，可以选择使用各种不同的框架（库），比如我使用Python上的Django。

先准备数据库（在Django中为Model），记录发布者的IP和时间：

```python
class ContentModel(models.Model):
    ip = models.CharField(max_length=20, db_index=True)
    time = models.DateTimeField(db_index=True)

```
然后就是处理请求的过程：

```python
def index(request):
    ipaddr = request.META.get('REMOTE_ADDR', '')
    if request.method == 'POST':
        _content = request.POST.get('content', '')
        if not checkIP(ipaddr):
            messages.error(request, MSG['IP_NOT_VALID'])
        elif not (len(_content) < 120 and len(_content) > 5):
            messages.error(request, MSG['CONTENT_TOO_LONG'])
        elif ContentModel.objects.filter(ip=ipaddr, time__range=\
                (datetime.now()-timedelta(minutes=30), datetime.now())).count() > 0:
            messages.error(request, MSG['TOO_MANY_TIMES'])
        else:
            new_content = ContentModel(ip=ipaddr, 
                    time=datetime.now())
            new_content.save()
            try:
                postStatu(_content, ContentModel.objects.count())
            except RuntimeError:
                messages.error(request, MSG['PUBLISH_ERROR'])
                logging.error('Error in ' + str(ContentModel.objects.count()))
            else:
                messages.success(request, MSG['PUBLISH_OK'])
    return render_to_response('index.html', \
            context_instance=RequestContext(request))

```
代码很简单，不需要解释。
另外再写一个`checkIP`，`postStatu`（可以参考小黄鸡代码），就搞定了。

### 页面

上一段代码的最后返回了`index.html`，就是用户看到的页面，关键内容如下：

<script src="https://gist.github.com/blahgeek/a324554ad4ebfff68072.js"></script>

### 然后

然后就...写完了..总时间不用超过一个小时...

UPDATE: [Fork Me On Github](https://github.com/blahgeek/treehole)

