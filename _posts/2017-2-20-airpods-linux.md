---
layout: post
classification: misc
title: AirPods在Linux上的使用体验
tags: airpods archlinux linux xps apple
permalink: airpods-in-linux/
---

挺好的。

![](./images/airpods-linux.jpg)


1. Linux在XPS 15上的蓝牙固件有问题，导致可以找到设备但是无法配对，<del>照[此贴](https://bbs.archlinux.org/viewtopic.php?id=204739)下载固件</del>从AUR安装`bcm20703a1-firmware`即可。
2. 标准[蓝牙耳机配置流程](https://wiki.archlinux.org/index.php/Bluetooth_headset)。关键词：`bluetoothctl`, `pulseaudio-bluetooth`, `uinput`。

我另外使用一台iPhone，一起使用的效果如下（第一次都先连接一遍，在Linux上trust该蓝牙设备）：

- 在iPhone上如预期照常使用。
- 盒子打开状态、或者佩戴状态下（即使正与iPhone连接），在Linux上执行`echo "connect 11:22:33:44:55:66" | bluetoothctl`可以连接耳机；约两秒后耳机中发出一声提示音，iPhone失去对其的连接，Linux上即可正常使用。
- 在Linux下，双击（正常激活Siri的手势）触发`XF86AudioPlay`键；距离传感器不工作（把耳机摘下来什么都不会发生）；把耳机装回盒子并盖上会断开连接。
- 在盒子打开或佩戴状态，并且与Linux连接中时，在iPhone控制中心（底部上划）可以选择输出设备为AirPods；约两秒后耳机中发出一声提示音，Linux失去对其的连接，iPhone上即可正常使用。
- AirPods从盒子中重新拿出来后，将恢复之前的连接；即如果放入前与Linux连接，则会自动恢复与Linux的连接。

总之，表现出乎我的意料，与Linux配合使用除了缺失距离传感器功能和显示电量功能（待验证），其他体验与Apple设备上几乎一样。

赞。
