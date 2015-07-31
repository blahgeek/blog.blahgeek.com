#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-30

import yaml
import sys
from collections import defaultdict

ret = list()

for yaml_file in sys.argv[1:]:
    yaml_data = yaml.load(open(yaml_file).read())
    ret.append(yaml_data)

# calculate related posts
def populate_related_posts(posts):
    tags = defaultdict(int)
    for post in posts:
        post['tags'] = post['tags'].strip().split(' ')
        for tag in post['tags']:
            tags[tag] += 1
    highest_freq = max(tags.itervalues())
    for post in posts:
        related_scores = list()
        for other in posts:
            if other is post:
                continue
            score = 0
            for tag in post['tags']:
                if tag not in other['tags']:
                    continue
                score += (1 + highest_freq - tags[tag])
            related_scores.append((other, score))
        related = sorted(related_scores, key=lambda x: x[1], reverse=True)[:3]
        post['related'] = map(lambda x: {"permalink": x[0]["permalink"], 
                                         "title": x[0]["title"],
                                         "date_human": x[0]["date_human"]},
                              related)

populate_related_posts(ret)
for i, yaml_file in enumerate(sys.argv[1:]):
    with open(yaml_file.replace('.yaml.raw', '.yaml'), 'w') as f:
        f.write(yaml.dump(ret[i], default_flow_style=False))

ret.sort(key=lambda x: x['date'], reverse=True)
print yaml.dump(ret, default_flow_style=False)
