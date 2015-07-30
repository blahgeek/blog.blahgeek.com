#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-30

import yaml
import os
import sys
from datetime import datetime

def populate_related(alldata, data):
    date_str = '-'.join(os.path.basename(filename).split('-')[:3])
    date = datetime.strptime(date_str, '%Y-%m-%d')
    data['date'] = date.strftime('%Y-%m-%d')
    data['date_human'] = date.strftime('%d %b %Y')

if __name__ == '__main__':
    filename = sys.argv[1]
    data = yaml.load(open(filename).read())
    populate_date(filename, data)
    print yaml.dump(data, default_flow_style=False)
