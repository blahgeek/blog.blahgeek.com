---
permalink: ben-zhan-kai-shi-zhi-chi-spdy.html
layout: post
title: 本站开始支持SPDY
tags: spdy google http network
---

###什么是SPDY

>SPDY是Google开发的基于传输控制协议(TCP)的应用层协议 。
Google最早是在Chromium中提出的SPDY协议。
目前已经被用于Google Chrome浏览器中来访问Google的SSL加密服务。（来自[维基百科](https://zh.wikipedia.org/wiki/SPDY)）

SPDY主要的特性有：

- TCP多路复用（并且对于不同资源有不同优先级）
- 默认使用SSL和Gzip（HTTP头部也被压缩）
- 简化HTTP头部（不重复发送User-Agent等信息）
- 支持服务器端推送

总的来说改进了HTTP协议的几点不足，并且加快了连接速度。

浏览器在进行SSL握手时，如果服务器返回的包中包含相应的NPN信息，则认为服务器支持SPDY。

###Nginx上使用SPDY

Nginx 1.3.0+ 版本能通过[patch](http://nginx.org/patches/spdy/README.txt)的方式增加对SPDY的支持。
重新编译安装，略修改配置文件即可。

![](/images/spdy-enable.png)

PS：有时间希望能进行一下载入速度对比测试。

