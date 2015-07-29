---
permalink: shi-yong-pydothui-zhi-asuan-fa-sou-suo-tu.html
classification: tech
layout: post
title: 使用Pydot绘制A算法搜索图
tags: python dot search
---

>人智作业中坑爹的手绘A搜索算法图的题目催生了这篇文章...

用Python的Pydot库。

```python
import pydot
dot = pydot.Dot()
while True:
    OPEN = sorted(OPEN, key=f)
    if isGoal(OPEN[0])
        break
    for n in expand(OPEN[0]):
        OPEN.append(n)
        dot.add_edge(pydot.Edge(toStr(OPEN[0]), toStr(n)))
    OPEN = OPEN[1:]
dot.write_png('out.png')

```
f为启发函数。

对于N=5，K=3的MC问题，画出来的图大概长这样（每个节点的意义为“（M, C, 方向, 深度）, f”）：

![](images/pydot-search-tree.png)

