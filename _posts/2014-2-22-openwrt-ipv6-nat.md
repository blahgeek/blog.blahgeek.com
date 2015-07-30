---
layout: post
classification: tech
title: OpenWRT配置IPv6的NAT（一般结合isatap使用）
tags: openwrt ipv6 network
permalink: 2014/02/22/openwrt-ipv6-nat/
---

### 前言

在一般IPv6网络环境下，一个局域网的子网大小为`/64`，接口通过NDP协议获得自己的唯一IPv6地址（前64位为子网前缀，后64位一般由接口本身的MAC地址产生）。这种环境下若想使家用路由器后的所有设备能够得到IPv6地址，一般有两种方法：

- IPv4依然采用NAT，但IPv6采用bridge
- 使路由器转发NDP发现的包，参见[6relayd](http://wiki.openwrt.org/doc/uci/6relayd)、[ndppd](http://priv.nu/projects/ndppd/)

但是众所周知清华大学紫荆宿舍的Native IPv6**就是一坨x**，只能通过[ISATAP](http://en.wikipedia.org/wiki/ISATAP)隧道访问。然而由于ISATAP本身的特性，一个公共的IPv4地址只能对应一个IPv6地址（因为其不是使用邻居发现协议来路由，而是直接根据IPv4地址路由），因此只能使路由器获得IPv6地址或者使[NAT后的某一台设备获得IPv6地址](http://blog.blahgeek.com/mac-os-xxia-pei-zhi-isatapbao-gua-zai-nathou.html)。

因此要使（只拥有一个外网IPv4地址的）多个设备通过ISATAP均能访问IPv6，只能使用IPv6 NAT。

### IPv6 NAT 解决方案

Google一下，大多数文章告诉我们：IPv6地址很多，不需要、不应该有NAT。再Google一下，[@dangfan](http://dangfan.me)的[这篇文章](https://dangfan.me/zhs/blog/router)给出的解决方案是使用北邮同学的[NAT66](http://code.google.com/p/napt66/)。

然而似乎所有人都没发现，**[Netfilter](http://www.netfilter.org)支持“all kinds of network address and port translation, e.g. NAT/NAPT (IPv4 and IPv6)”** 所以说，`ip6tables`是像`iptables`一样有nat表的，只不过相应的内核模块一般没有被默认安装。

### 在OpenWRT上安装使用IPv6 NAT

- <del>当然，我们需要自己[Build OpenWRT](http://wiki.openwrt.org/doc/howto/build)，在`make menuconfig`时选中</del>使用opkg安装`kmod-ip6tables`，`kmod-ipt-nat6`两个包（其余的自己看着办咯），需要较新版本的内核。
- 安装后如果`ip6tables -t nat -L`能输出结果就说明其nat表可用啦
- 在路由器上配置ISATAP
- 在`/etc/config/network`中给路由器的lan口指定Private IPv6地址：在`option ipaddr 192.168.1.1`后加入`option ip6addr fc00:0101:0101::1/64`
- 配置radvd（作用类似IPv4的DHCP），广播`fc00:0101:0101::/64`前缀的Private IPv6地址
- 配置ip6tables，在`/etc/firewall.user`中加入`ip6tables -t nat -I POSTROUTING -s fc00:101:101::/64 -j MASQUERADE`
- Done！

### PS：代码

路由器上ISATAP自动配置脚本`/etc/init.d/isatap`（修改`YOUR_IP`）：

```bash
#!/bin/sh /etc/rc.common
# By blahgeek

# before led, after everything else
START=95

start() {
    ip tunnel add sit1 mode sit remote 166.111.21.1 local YOUR_IP
    ifconfig sit1 up
    ifconfig sit1 add fe80::200:5efe:YOUR_IP/64
    ifconfig sit1 add 2402:f000:1:1501:200:5efe:YOUR_IP/64
    ip route add ::/0 via 2402:f000:1:1501:200:5efe:166.111.21.1 metric 1
}

stop() {
    ip tunnel del sit1
}
```

radvd配置文件`/etc/radvd.conf`：

```
interface br-lan {
    AdvSendAdvert on;
    MinRtrAdvInterval 5;
    MaxRtrAdvInterval 10;
    AdvManagedFlag off;
    AdvOtherConfigFlag off;
    AdvDefaultPreference high;
    prefix fc00:0101:0101::/64 {
        AdvOnLink on;
        AdvAutonomous on;
        AdvRouterAddr on;
    };
};
```
