---
permalink: linux-NIC-teaming/
classification: tech
title: 使用NIC Teaming配置多个网络接口提升带宽
layout: post
tags: network linux
---

之前为了一个视频编码相关的项目，需要几台机器之间有比较大的带宽。每台机器拥有两个万兆网卡（光纤连接），另外还有一台万兆交换机，我的目标是每台机器之间**单TCP连接**能够达到双万兆的带宽。用到了NIC Teaming（旧版本的Linux叫NIC Bonding，功能上类似）的东西。

## Round-robin?

NIC Teaming是Linux内核的一个功能，能在多个物理接口之上虚拟出一个网络接口，达到提高带宽、增强稳定性的目的。类似硬盘的RAID，NIC Teaming也分为多种模式，比如round-robin、broadcast、active-backup等等。其中round-robin模式顾名思义，就是将发送的包按顺序分别从几个物理接口上发送出去，理论上能达到成倍的带宽（类似RAID 0），于是很自然的就想到用这个模式。

配置如下：

ifcfg-team0:

```
DEVICE="team0"
DEVICETYPE="Team"
ONBOOT="yes"
BOOTPROTO="none"
NETMASK=255.255.255.0
IPADDR=192.168.42.1
TEAM_CONFIG='{"runner": {"name": "roundrobin"}}'
```

ifcfg-ethX:

```
DEVICE="ethX"
DEVICETYPE="TeamPort"
ONBOOT="yes"
BOOTPROTO="none"
TEAM_MASTER="team0"
```

每台机器均这样配置，所有网口均插在交换机上。

但是……并不可以。可以预见，为了能够让两个物理接口能够轮流发送包，它们的MAC地址会被设为相同，但如此一来在接受包的时候交换机只会将包发往其中一个接口（或者一会儿这个一会儿另一个…类似ARP攻击），总带宽依然限制于一个接口的带宽。

## LACP?

然后我意识到，由于上述原因，为了加倍带宽肯定需要在交换机上作一些配置，于是想到了[LACP](http://en.wikipedia.org/wiki/Link_Aggregation_Control_Protocol)模式。该模式需要在主机和交换机上同时配置，因此不会有上述问题。LACP可以做到load balance，然而它只能根据源IP/源MAC/目的IP/目的MAC等值做哈希，也就是说单个TCP/UDP链接的包并不会被负载均衡，达不到增加单个链接带宽的效果。

## Round-robin... with VLAN!

最终我想到使用VLAN的方式。

将交换机划分为两个VLAN（或者干脆用两个交换机），将每台机器的eth0通过一个VLAN连接，每台机器的eth1通过另一个VLAN连接，依然使用上述的round-robin模式。这样一来，发送的包会轮流从两个接口发送，经过不同的VLAN，也就会被接受方的两个接口分别收到（即使他们的MAC地址相同，因为在两个不同的子网中），达到带宽加倍的目的。
