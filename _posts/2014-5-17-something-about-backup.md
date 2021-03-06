---
layout: post
classification: tech
title: 我是怎么存储/同步/备份我的数据的
tags: network geek backup gfw
permalink: 2014/05/17/something-about-backup/
---

>提醒一下，如果你认为自己是强迫症患者，那么建议你离开这个页面不要往下读了…正如我几个月前在一个英文的博客中看到了某人的备份方案后从此踏上了买硬盘订服务配环境的剁手不归路……

# 首先

先请大家问问自己几个问题：

- 如果你在外旅游时突然想起来十分钟后是Deadline，能否在Deadline之前将电脑中已经完成的作业提交到网络学堂？
- 如果你的电脑突然无法开机，你能否用同学的/图书馆的电脑在半小时内恢复工作并且不错过几天内的deadline？
- 如果你的电脑由于操作不当无法启动，你能否在一小时内使其恢复至出错之前的状态？
- 如果你和妹子吵架后一怒之下删掉了所有照片，半年后你们重归于好，你还能否找回当年的秀恩爱照？
- 如果你的电脑被偷/硬盘损坏，你能否在一天内恢复所有重要数据？

如果对于这几个问题你的回答都是“必须的无压力”的话，那么恭喜你你的强迫症已经相当严重了；如果有任何一项没有达到的话，强烈建议你从现在开始规划自己的数据存储。也许你会认为自己保证不会粗心大意导致数据丢失，但是需要注意的是机械硬盘的平均使用寿命是30000小时，固态硬盘的平均使用寿命一般是10000次写入，**所以说数据丢失并不是“如果发生了怎么办”的问题，而是“什么时候会发生”的问题。**

# 所以说要这样

我对于数据有两个原则：

- 自己认为有用的数据必须在两个或以上的物理介质中存储
- 自己认为没有用的数据必须在一个或以上的物理介质中存储

>PS:这样的话，电影之类的数据也需要在硬盘中保存吗？不需要，因为电影存在于互联网上的N个物理介质中。

这两个原则对应的原因是：

- 两个物理存储介质同时损坏的几率小到可以忽略不计
- 自己判断错误以及一个物理存储介质损坏这两件事同时发生的几率小到可以忽略不计

# 丧心病狂的我是这么干的

然后我把以上几条需求分为三个方面：

- 同步：能够随时随地通过很小的代价获取到短期内将使用到的数据
- 系统备份：整个系统的备份，能够方便地恢复某一时刻的特定文件或者全盘恢复至某一时刻
- 完全备份：所有数据的增量备份，永远不会被删除

所以，相对应的我同时使用这三个方案：

1. [坚果云](http://jianguoyun.com)（Pro版，￥200每年）：使用坚果云同步课程文件作业、代码等等短期内使用的数据，使其能够随时随地方便地获取到以至于不影响短期内的工作。另一方面，它能够监视文件系统并且实时备份，因此可以适用于“卧槽按错了”情况的文件恢复，但是如果你意识到两个月前自己误删了文件的话可就无解了（会保存已删除文件30天）。
2. Time Machine（Mac OS X自带，免费）：使用Time Machine对系统做全盘备份至寝室的Linux服务器中。它会保存过去24小时的每小时备份、过去一个月的每日备份和过去所有时间的每周备份，当备份容量达到设定值时将自动删除最早的备份。使用它能够很方便地恢复整个系统或者一个文件至某个特定的时间，可以保证能够在电脑被偷/损坏的情况下完全恢复电脑上的数据。
3. [Crashplan](http://crashplan.com)（备份至本地硬盘免费）：最后，我在寝室的Linux服务器中运行着Crashplan将数据备份至一个3T的外接桌面硬盘。一些不常用的大文件会被我归档至Linux服务器中，同时会被备份至外接硬盘。即使我认为它不再需要将其删除，数据也会在备份硬盘中永久保存，并且当该备份硬盘空间满后Crashplan会提醒你更换备份硬盘而不是删除最早的备份。这样保证了所有数据永远不会消失。

# 所以

- 如果看完后有一种买硬盘备份数据的冲动，欢迎入坑
- 如果觉得这样弱爆了，求你一定告诉我哪里还不够科学…
- 如果你觉得我闲的蛋疼…我也是这么想的

