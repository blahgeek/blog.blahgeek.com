---
permalink: raspberry-piru-shou-xiao-ji.html
layout: post
title: Raspberry Pi入手小记
tags: raspberrypi hardware
---

>今天是3月14日，派节，入手树莓派一只 :P

![](images/raspberrypi.jpg)


### OS

树莓派官方的[下载页面](http://www.raspberrypi.org/downloads)里提供了基于Debian和Arch的版本，
官方推荐初学者使用前者。不过对于Linuxer来说，我认为后者是个更好的选择。它使用官方的Archlinuxarm
的源，源里面有专为树莓派定制的内核等。系统默认打开sshd，将镜像写入SD卡后插入树莓派，连上网线，
第一次开机后直接就能ssh进去，对于不是用于当播放设备等的情况来说非常方便，不需要外接显示器和键鼠。

另外，直接将镜像写入大于2G的SD卡后需要调整分区大小。

```bash
DEV_ROOT_DISK=/dev/mmcblk0
DEV_ROOT_PART=${DEV_ROOT_DISK}p2
PART_START=$(parted ${DEV_ROOT_DISK} -ms unit s p | grep "^2" | cut -f 2 -d:)
fdisk ${DEV_ROOT_DISK} <<EOF
p
d
2
n
p
2
$PART_START

p
w
EOF

```
然后重启，`resize2fs -p ${DEV_ROOT_PART}`。

### 电源

**一定要选择一个稳定输出的USB电源**。刚开始使用山寨充电器，但是当接上功耗比较大的USB设备后，
它自动重启了。测量输出电压（可以测量板上TP1和TP2两个接口之间的电压）发现只有4.65V，改用原装iPhone
充电器后就没有问题。

### 外设

- U盘和无线网卡（[兼容性列表](http://elinux.org/RPi_VerifiedPeripherals)）均即插即用，但要保证供电。
- 音频输出即插即用。
- HDMI未测试。

### GPIO

即通用的数字IO脚，我认为是在功能上唯一与PC不同的地方，能很方便地与各种硬件连接，比如做一个无线小车等等。
GPIO可以使用[WiringPI库](https://github.com/WiringPi/WiringPi)（在Arch源中有），它还附带了几个Example，
比如对于Examples/test2，编译运行后在GPIO1和GND间连接一个发光二极管和电阻，可以看到亮度逐渐变化。


