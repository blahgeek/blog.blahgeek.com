#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-31

import yaml
import sys

if __name__ == '__main__':
    data = yaml.load(open(sys.argv[1]).read(), Loader=yaml.FullLoader)
    body = open(sys.argv[2]).read()
    data['body'] = body
    with open(sys.argv[1], 'w') as f:
        f.write(yaml.dump(data, default_flow_style=False))
