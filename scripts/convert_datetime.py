#! /usr/bin/env python
# -*- coding: utf-8 -*-

import sys
from datetime import datetime

from_fmt, to_fmt = sys.argv[1:]
d = datetime.strptime(sys.stdin.read().strip(), from_fmt)
sys.stdout.write(d.strftime(to_fmt))
