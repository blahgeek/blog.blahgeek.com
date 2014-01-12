---
permalink: mac-os-x-dot-underscore.html
layout: post
title: 关于Mac OS X中的.DS_STORE、._xxx文件
tags: mac geek
---

### .DS_STORE

在OS X中的很多目录下都有一个隐藏文件.DS_STORE（通过`ls -a`看到），其作用是：

> 保存所有与文件夹视图有关的信息（窗口大小、排序、图表摆放位置等）、SpotLight元数据、文件夹图标等。

`DS`代表`Desktop Service`，在`/System/Library/PrivateFrameworks/DesktopServicesPriv.framework`下。

### ._xxx

好吧，`.DS_STORE`很容易发现，也很容易猜到它是干嘛的，而`._xxx`（xxx是文件名）文件就更加神奇一点了。

一般情况下在OS X中是没有这样的文件的，但是当你：

- 将OS X下得某个文件压缩成zip，在PC上解压，会发现一个`__MACOSX`的目录下存放着`._xxx`文件
- 将某个文件复制到另外一个磁盘上（非`HFS+`文件系统）后，会产生`._xxx`文件

总的来说，该文件的作用是：

> 保存所有`HFS+`文件系统支持的，而目标文件系统不支持的文件信息。当压缩为zip或者将文件复制到其他文件系统时，OS X会自动将`HFS+`文件系统下的文件信息提取保存至`._xxx`文件中，而当解压或者复制回`HFS+`文件系统时，进行反操作，文件被移除。而当直接访问一个非`HFS+`文件系统是，OS X会从该文件中读取文件信息。以此来保证应用在不同文件系统上均能工作。

示例：

有一个文件叫做`test.png`，由系统截屏产生，`ls -l`可以看到文件属性中有个`@`，表示的是`HFS+`文件系统特有的metadata，通过`ls -l@`可以看到具体数据项：

<script src="https://gist.github.com/8366368.js"></script>

通过`xattr -l test.png`可以查看元数据具体数据：

<script src="https://gist.github.com/8366370.js"></script>

当我们使用预览程序编辑之后，元数据会发生改变：

<script src="https://gist.github.com/8366395.js"></script>

<script src="https://gist.github.com/8366397.js"></script>

将其压缩后，查看zip包的文件：

<script src="https://gist.github.com/8366403.js"></script>

在PC上解压，`._test.png`文件的内容为：

<script src="https://gist.github.com/blahgeek/8366647.js"></script>

