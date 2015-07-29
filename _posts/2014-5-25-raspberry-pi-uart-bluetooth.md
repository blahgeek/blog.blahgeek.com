---
permalink: raspberry-pi-uartzong-xian-chuan-kou-lan-ya-mo-kuai-shi-yong-xiao-ji.html
classification: tech
layout: post
title: Raspberry Pi UART总线（串口）蓝牙模块使用小记
tags: raspberrypi hardware uart serial bluetooth
---

> *2014/5/25 UPDATE* 旧版本的树莓派Kernel有[Bug](https://github.com/raspberrypi/linux/issues/12)，会在每次打开串口时发送一个多余的`0xF8`字符，改Bug在最新版本的内核中已修复。（如此神Bug…我已经无力吐槽了）

### 系统准备

树莓派的UART接口默认是用于console的，要用作自己用途首先需要
将其关闭。对于运行Arch的树莓派，是通过systemd控制的，
运行`systemctl disable getty@ttyAMA0.service`，
另外在`/boot/cmdline.txt`中将内核参数`console=ttyAMA0,115200 kgdboc=ttyAMA0,115200`
删除。重启。

### 连线

还是看[Wiki](http://elinux.org/RPi_Low-level_peripherals)
的引脚配置，P1-08为TXD，P1-10为RXD。（PS：注意是派上的TXD与另外模块上的RXD相连啊:)，刚刚就脑残搞错了。）

### 通过串口与模块连接

我用于测试的蓝牙模块是HC-07，3.3V电压。
在树莓派上使用`minicom`（通过`pacman`安装）进行串口通信。
运行`minicom -b 9600 -D /dev/ttyAMA0`，9600为波特率，
不同模块不同。

之后就能想蓝牙模块发送数据了。比如根据文档，发送`AT`后会返回`OK`。

### 电脑与蓝牙连接 实现无线通信

在PC上（依然用的是Arch），打开蓝牙，通过`hcitool scan`获得
蓝牙的地址，再通过`sdptool records 00:12:12:28:28:65`获得channel，
最后运行`rfcomm bind 0 00:12:12:28:28:65 1`（1即channel）。
这个时候应该出现了`/dev/rfcomm0`设备，此时就可以通过`minicom`
进行通信了。

运行`minicom -D /dev/rfcomm0`后，输入任意字符，在树莓派的
`minicom`上就能出现相应的内容，反之依然。

### Python

据说有个叫做`pySerial`的模块可以使用，不再详述。

