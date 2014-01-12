---
permalink: shi-yong-bittorrent-syncda-jian-zi-ji-de-dropbox.html
layout: post
title: 使用BitTorrent Sync搭建自己的Dropbox
tags: bittorrent dropbox mac sync
---

> 从手动备份，到使用坚果云，到使用ownCloud，最终使用BitTorrent Sync，总算有了一个满意的自己的Dropbox。

### 为什么不用Dropbox

我认为云同步服务与其他服务最大的区别就是需要在不同设备上、不同地点、给不同人访问，
因此被墙（或者有被墙的危险）这一点就异常地无法接受了。

### 为什么不用坚果云

不得不承认，在国内的几家服务商中，我觉得坚果云是做的最好的一个之一。
它在很久之前就做到了全平台的支持，Linux下的运行效果也很好，上传下载大文件小文件速度都很快，
我有一段时间内一直在使用，甚至购买了半年的会员服务。

但是它也有一些缺点，比如不支持自定义不同步某些后缀名的文件。
另外，毕竟是国内的公司，需要注意敏感信息。

### 使用自己的云服务

后来我想到，既然自己有服务器，干脆一劳永逸地搭建一个适合自己的服务，
不限流量不用付钱而且分享时界面可以自定义。

![](/images/oc5files.png)

Google了一阵后，发现了[ownCloud](http://owncloud.org)这个东西，
功能非常齐全，基本可以代替Dropbox，但是使用了一阵后也发现了很多缺点：

- 服务器端很“笨重”，而且是用php写的，而且很慢
- 客户端bug不断，CPU占用率时常飙到100%
- 客户端需要图形界面
- 同步机制很弱智，比如无法检测文件重命名

总之基本无法正常使用……

### 最后的选择

后来我认识到，`同步`和`分享`可以通过两个不同的程序实现，这样一来选择更多，
而且也不会出现像ownCloud这样臃肿的情况。

同步方面，一个偶然的机会，找到了[BitTorrent Sync](http://labs.bittorrent.com/experiments/sync.html)。
（PS：吐槽一句，我一直相信一个好用的软件从代码风格到UI友好度都应该是好的，
但从网站的美观来看，这个站点就完爆ownCloud十条街。）它是一个基于`p2p`的文件同步
工具，可以在多台设备之间同步文件，而且：

- 同步速度：有着BitTorrent多年的基础，自不必说
- 小巧，通过Web页面配置，非常适合在服务器上部署
- 能自动检测文件移动、重命名等

分享方面，自己写了一小段python代码见[这里](https://github.com/blahgeek/personal-file-sharing-center), 

![](/images/cloud-share-screenshot.png)


