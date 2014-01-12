---
permalink: mac-os-xxia-pei-zhi-isatapbao-gua-zai-nathou.html
layout: post
title: Mac OS X下配置ISATAP（包括在NAT后）
tags: mac isatap ipv6 nat
---

这是一个fish脚本，默认的地址为清华大学ISATAP服务器，可以根据自己的情况更改。在NAT后也可以使用。

```bash
#!/usr/local/bin/fish
function isatap

    set REMOTE_IP 166.111.21.1
    set LINK_PREFIX "fe80::200:5efe"
    set GLOBAL_PREFIX "2402:f000:1:1501:200:5efe"

    if sudo ifconfig gif0 destroy
        echo "Previous gif0 destroyed"
    end

    if test (count $argv) = 0
        set PUBLIC_IP (curl ifconfig.me)
    else
        set PUBLIC_IP $argv
    end
    set LOCAL_IP (sudo ifconfig en0 | grep inet | grep -v inet6 | awk '{print $2}')

    echo "Public IP: $PUBLIC_IP, Local IP: $LOCAL_IP"

    sudo ifconfig gif0 create
    sudo ifconfig gif0 tunnel $LOCAL_IP $REMOTE_IP
    sudo ifconfig gif0 inet6 $LINK_PREFIX:$PUBLIC_IP prefixlen 64
    sudo ifconfig gif0 inet6 $GLOBAL_PREFIX:$PUBLIC_IP prefixlen 64

    sudo route delete -inet6 default
    sudo route add -inet6 default $GLOBAL_PREFIX:$REMOTE_IP

    echo "Done"
end


```
