---
permalink: raspberry-pi-i2czong-xian-shi-yong-xiao-ji.html
layout: post
title: Raspberry Pi I2C总线使用小记
tags: raspberrypi hardware i2c compass
---

### 系统准备

Debian下可以参考官方文档。在Arch下，装载`i2c_bcm2708`, `i2c-dev`模块，安装i2c-tools：

```bash
modprobe i2c_bcm2708
modprobe i2c_dev
pacman -S i2c-tools

```
### 连线

引脚配置见[Wiki](http://elinux.org/RPi_Low-level_peripherals)，P1-03为SDA，P1-05为SCL，
注意这些引脚都是**3.3V**的逻辑电平，而且直接连接到芯片上没有保护装置，需要注意。

### 检测

我用于测试的是一个HMC5883三轴电子罗盘模块，支持3.3V电压，I2C通信。接上后运行`i2cdetect 1`
检测I2C设备，其中1表示检测`/dev/i2c-1`（需要root权限）。输出如下：


```text
RPi> sudo i2cdetect 1
WARNING! This program can confuse your I2C bus, cause data loss and worse!
I will probe file /dev/i2c-1.
I will probe address range 0x03-0x77.
Continue? [Y/n] y
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- 1e -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --                         

```
其中1e就表示检测到的设备在总线上的地址。

### 读写

使用`i2cset`和`i2cget`命令能对其进行读写，比如`i2cset 1 0x1e 0x02 1`就能将0x1e设备的0x02寄存器
写1。在Python下，可以使用smbus模块进行操作，一段读取电子罗盘三个方向磁场强度的代码如下
（模块的寄存器地址分别代表什么需要查看数据手册）：

```python
#!/usr/bin/env python
# -*- coding=UTF-8 -*-
# Created at Mar 16 14:32 by BlahGeek@Gmail.com

import time
import smbus
import struct
bus = smbus.SMBus(1)
addr = 0x1e

def getVector():
    bus.write_byte_data(addr, 0x02, 0x01)
    time.sleep(0.01)
    s = ''.join(map(chr, bus.read_i2c_block_data(addr, 0x03, 6)))
    return struct.unpack(">hhh", s)

print getVector()

```
输出：`(395, -75, -85)`

