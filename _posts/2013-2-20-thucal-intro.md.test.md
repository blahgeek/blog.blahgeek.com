---
permalink: xin-ban-qing-hua-ke-biao-zhi-googleri-li-dao-ru-gong-ju-ji-shang-ke-di-dian-sou-suo.html
layout: post
title: 新版清华课表至Google日历导入工具及上课地点搜索
tags: thucal google calendar
---

如题。无聊把上学期的版本在Django上重写了一下，功能基本相同，即：

- 上传课表文件，导入至Google日历。
- 将大家的课程的上课地点开放查询。

>功能：能把课表中的所有课程（未安排时间的课除外）插入到google日历里面，支持全周、双周、单周、x-y周、第a,b,c,d...周重复。全周、双周、单周的课重复至16周。

这次的改进有：

- 一个能看的UI
- 换了自己的服务器，应该会快一点
- 改进了对课程信息的识别，能应对很多特殊情况
- 改进了时间重复的表示方式，能正常同步到手机并且编辑
- 其他...

使用说明：

- 在*选课系统*(可以从info进入)的**一级选课**栏里面点击“导出xls”将课表保存至电脑。
- Submit
- Enjoy!

###[页面点此进入](http://thucal.blahgeek.com/to_cal/)。感谢使用。

![](/images/thucal_screenshot.png)

