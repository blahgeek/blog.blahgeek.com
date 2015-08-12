---
permalink: bo-ke-yi-chu-tumblr-gai-yong-pelicansheng-cheng.html
classification: misc
layout: post
title: 博客移出Tumblr 改用Pelican生成
tags: tumblr pelican blog python
expired: true
---

###为什么移出Tumblr

首先声明，个人认为Tumblr在各个方面都做的非常好，有很大的自由度，
能完全更改页面的Html、CSS、JS等，还能绑定域名。不过毕竟不是完全由自己
控制的，作为一个伪Geek总是希望能够完全自己管理、生成。

另外，放在Tumblr的博客肯定无法使用Https，某些含有关键字的内容
可能会被墙Reset。

###为什么使用Pelican

以下几个简单的原因：

- 支持Markdown
- 使用Python
- 生成静态页面
- 支持Disqus, google analytic

###SSL证书

在[StartSSL](http://startssl.com)能申请到免费的SSL证书，有效期一年，但是
不支持域名通配符（形如*.blahgeek.com）。（PS：说到这个，
在[这里](https://ssl.blahgeek.com/)开了个12306的小玩笑..）

