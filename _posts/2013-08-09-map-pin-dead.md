---
permalink: zai-google-mapsshang-ding-ge-da-tou-zhen-neng-zha-si-duo-shao-ren.html
layout: post
title: 在Google Maps上定一个大头针，能扎死多少人？
tags: boring google zhihu
---

这是在[知乎](http://www.zhihu.com/question/21398888)上的一个问题，真是太萌了……于是（蛋疼地）来回答一下。

### 问题分析

如果没搞错的话，题目的意思应该是在iPhone的地图应用中按一下“放置大头针”按钮后掉落下来的大头针
在现实世界中能扎死多少人。显然答案与放置大头针时地图的缩放比例有关，为造成最大的破坏效果，
不妨将比例尺调至最小。如图。为分析方便，忽略大头针的“大头”，仅考虑一个与针尖直径相等的球形物体掉落至地面。

![](/images/pin.png)


### 数据估计

- 根据截图，针尖直径为5像素，而图中美国东西海岸距离为175像素。
  而美国东西海岸实际距离越为4500千米，因此针尖直径约为128千米。
- 根据iPhone掉落大头针的动画，一个合理的近似是大头针从地球北极上方匀速飞入，
  穿越大气层后以45度夹角撞击地表。
- 目测大头针在0.2秒左右的时间内从北极上方飞至地面，地球半径为6371千米，
  由其飞行角度，其飞行距离为8983千米，飞行速度约为45000千米每秒。
- 不锈钢的密度约为7800千克每立方米。

### 计算

好吧，其实Gareth S. COLLINS等人发过一篇Paper叫做《[Earth Impact Effects Program: A Web-based computer program for calculating the regional environmental consequences of a meteoroid impact on Earth](http://impact.ese.ic.ac.uk/ImpactEffects/effects.pdf)》, 
而且还写了一个[在线的撞击模拟程序](http://impact.ese.ic.ac.uk/)。输入以上参数即可计算。

### 结果

撞击释放的能量为$2.07\times{}10^{22}$吨TNT当量，而广岛的“胖子”原子弹的TNT当量为$2.1\times{}10^4$吨，相当于一百亿亿个“胖子”，或者这样来理解：
如果从宇宙诞生到现在，每一秒钟产生一个“胖子”，积累下来一起放在这里爆炸，所产生的能量也不过是它的一半不到。

对地球的影响就是，地球不见了，金星和火星之间多了一个小行星带。

至于能扎死多少人这个问题，一个不太准确的数字是70.57亿。


