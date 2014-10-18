---
permalink: dropzone3-renren/
layout: post
title: 拖拽上传人人照片/快捷发布状态(Dropzone 3)
tags: dropzone renren ruby
---

![](/images/dropzone3-renren.png)

![](/images/dropzone-renren.gif)

# 介绍

[Dropzone 3](http://aptonic.com/dropzone3/)是一个Mac上的应用，可以通过拖动文件、文字至状态栏上的图标来完成上传文件到FTP、分享图片至Twitter、移动文件到指定文件夹等等一系列动作。并且更棒的是，它除了几个自带的动作以外还支持Ruby脚本扩展，能够自己根据[API](https://github.com/aptonic/dropzone3-actions/blob/master/README.md#dropzone-3-api)编写相应的动作。App价格是$9.99。

[这是](https://github.com/blahgeek/dropzone3-actions/tree/master/Renren.dzbundle)一个简单的Dropzone人人网插件，有两个功能：

- 拖拽图片至此将上传图片至相册，并会提示输入图片描述
- 点击动作将提示输入文本发布状态

# 安装和使用

- [下载](https://github.com/blahgeek/dropzone3-actions/tree/master/Renren.dzbundle)`Renren.dzbundle`文件夹并双击，插件会被自动安装
- 进入[人人开放平台](http://app.renren.com/developers/newapp)申请一个新的应用

> *为什么需要自己申请新的应用？*人人开放平台规定未审核的应用只能用于开发者的测试，不允许为其他用户发布状态等，因此需要自己申请一个应用（这样自己就是开发者了）。未审核的应用发布的状态下会显示“通过第三方应用发布”。

- 安装几个Ruby Gems：`sudo gem install rack-oauth2`安装（仅用于下一条中的获得应用授权，插件本身不需要）
- 获得应用授权：使用Ruby运行以下代码，将相应的`API_KEY`等替换为自己应用的信息。获得OAuth地址后通过浏览器打开并授权，记录下跳转后的URL中`access_token`与`mac_key`两个参数，分别填入Dropzone的插件配置中的User和Password。

```ruby
OAUTH_SCOPE = [:photo_upload, :status_update]
 
client = Rack::OAuth2::Client.new(
  :identifier => 'API_KEY',
  :secret => 'API_SECRET',
  :redirect_uri => 'REDIRECT_URI',
  :host => 'graph.renren.com',
  :authorization_endpoint => '/oauth/authorize',
  :token_endpoint => '/oauth/token'
)

p client.authorization_uri(
  :response_type => :token,
  :scope => OAUTH_SCOPE, 
  :token_type => :mac,
)
```

- Enjoy!

