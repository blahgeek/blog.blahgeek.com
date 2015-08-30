---
layout: post
classification: tech
title: 安利一个靠谱的个人邮件服务：Fastmail
tags: geek email mail osx domain
permalink: fastmail-is-good/
---

关于邮件，最开始我用Gmail，后来开始使用自己的域名邮箱，依次用过Outlook（后来关了…）、Google Apps（后来被墙了…），最近一年左右在用Zoho.com，它虽然免费并且功能全面，但用着总是各种不爽快，比如：

- 可能由于发信IP比较少，经常由于IP frequency limited被各邮件商退信
- 简直无法忍受的垃圾邮件过滤
- 简直无法忍受的Web界面（虽然我不用）
- 简直无法忍受并且看不懂的复杂设置界面
- 收费版包含很多用不到的邮件以外的功能，导致不想升级

忍无可忍之下，我在两天前决定迁移至Fastmail（使用域名邮箱的好处就是随便换服务～再也不担心倒闭了被墙了的情况，实在不行还可以自己搭建），试用后感觉浑身舒畅，特来安利一发。

### 一切想要的功能

Fastmail是一个做邮件并且只做邮件的老牌公司，对于邮件的服务非常专业，可以说所有你能想到的一个电子邮箱应该具有的功能它都具备：IMAP Push/CalDAV/Alias等等，并且做得非常好，访问速度很快。

### 标准IMAP＋标准SMTP

使用过客户端用Gmail的人一定知道Gmail有多么的蛋疼，虽然Gmail的web界面很好用，然而他为了实现自己的各种功能将协议实现的面目全非：一封邮件既出现在Inbox又出现在All Mails、又有folder又有label又有tab、SMTP发送无视Alias…而Fastmail不仅web界面好用，IMAP和SMTP都是标准的，能和各种客户端非常完美的一起使用。在Fastmail中，客户端并不是二等公民，几乎所有功能都会说明在web界面和客户端中分别如何工作。

### "个人"邮箱

几乎所有其他域名邮箱的提供商（Google Apps/Zoho.com/Outlook）都是面向团体或者公司的，而Fastmail特别的有针对个人用户设计，价格更加合理，功能也更加合适，比如：

- 你可以使用多个域名（或者所有子域名）、多个地址（或者域名下的所有地址）均指向同一个你的个人邮箱，同时Fastmail也提供各种后缀的地址供你使用
- 可以根据不同的发件地址使用不同的设置，包括签名、”回复至”地址、保存至文件夹、使用的SMTP服务器等

### 高级功能设置

同时，Fastmail在不打破标准协议的前提下实现了许多高级功能并且在高级设置页面中完全供你配置，比如：

- IMAP协议中没有"报告垃圾邮件”的功能，Fastmail允许指定某folder，所有放入该folder的邮件会等同于在页面中点击"报告垃圾邮件”；同时，你可以看到贝叶斯分类器的工作状态、每封邮件的各项垃圾邮件指标评分、评分阈值等等。
- 完善的规则功能，甚至允许用户自己编写规则脚本
- 各种Alias功能，比如子域名、加号地址、通配符、转发至域外邮箱等等
- ……

### 完善的帮助和支持

Fastmail的帮助文档是我见过给用户的最棒的文档，没有之一。它的文档中不仅仅会描述每一个设置选项的功能，还会尝试解释其中的工作原理，甚至指出”标准是怎么样的，大家都是怎么干的，我们是怎么干的”这种点，比如[这个页面](https://www.fastmail.com/help/send/identities.html)。

除了完善的帮助文档外，技术支持人员也非常专业，不像某一些公司的支持人员只会回答文档上提供的问题，[这是一个我提交的ticket](https://www.fastmail.com/html/?MLS=SU-*&u=9158414d&MSignal=TZ-**842225*86c79a27)，大家感受一下。



总之在我看来，Fastmail唯一的缺点就是略贵，使用自定义域名＋15G容量的plan价格是$40/yr。不过话又说回来，[If you’re not paying for it, you’re the product being sold](http://www.metafilter.com/95152/Userdriven-discontent#3256046)。

最后，如果你也想尝试一下的话，欢迎使用我的[Referral link](http://www.fastmail.com/?STKI=14918785)～

