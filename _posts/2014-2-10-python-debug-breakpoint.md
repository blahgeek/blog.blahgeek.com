---
permalink: interactive-debug-in-python.html
layout: post
title: 设置“断点”调试Python代码
tags: python debug ipython
---

> 2014/2/10 Update: 更新使用iPython


```python
# blah blah...
from IPython.core.debugger import Tracer
Tracer()()
```

然后就进入了iPython console，可补全等。
或者运行`ipython --pdb file.py`，当`file.py`运行时产生异常时会进入调试的console。

---

code:

```python
#blah blah....

#debug
import code
code.interact(local=locals())

#然后就进入了交互式的python console, 所有变量都在，调试完后按ctrl-D继续...

#go on....

```
