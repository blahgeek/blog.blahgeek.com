#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-31

from bs4 import BeautifulSoup
import yaml
import sys

site = yaml.load(open(sys.argv[2]).read())

soup = BeautifulSoup(open(sys.argv[1]).read())
for img in soup.findAll('img'):
    img_src = '/' + img['src']
    link = soup.new_tag('a', href=img_src)
    link['data-no-instant'] = "1"
    img.insert_before(link)
    link.append(img)
    img['src'] = site['cdn_domain'] + '/' + img['src'] + site['cdn_img_suffix']

with open(sys.argv[1], 'w') as f:
    f.write(str(soup))
