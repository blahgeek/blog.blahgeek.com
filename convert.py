#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2014-01-11

import os
import re

files = filter(lambda x: '.md' in x and not x.startswith('20'), os.listdir('.'))

print files

def slugify(value):
    """
    Normalizes string, converts to lowercase, removes non-alpha characters,
    and converts spaces to hyphens.

    Took from django sources.
    """
    if type(value) == unicode:
        import unicodedata
        from unidecode import unidecode
        value = unicode(unidecode(value))
        value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
    value = unicode(re.sub('[^\w\s-]', '', value).strip().lower())
    return re.sub('[-\s]+', '-', value)

def get(f):
    s = open(f).read()
    header, body = s.split('\n\n', 1)
    ret = {'filename': f, 'body': body}
    for h in header.split('\n'):
        if not len(h.strip()):
            continue
        a, b = h.split(':', 1)
        ret[a.strip()] = b.strip()
    return ret

def convert_head(d):
    ret = {}
    if 'Slug' in d:
        ret['permalink'] = d['Slug'] + '.html'
    else:
        ret['permalink'] = slugify(d['Title'].decode('utf8')) + '.html'
        ret['permalink'] = ret['permalink'].encode('utf8')
    ret['layout'] = 'post'
    if 'Tags' in d:
        ret['tags'] = d['Tags'].replace(',', ' ').replace('  ', ' ')
    ret['title'] = d['Title']
    for x in ('filename', 'body', 'Date'):
        ret[x] = d[x]
    return ret

def get_filename(d):
    return d['Date'].partition(' ')[0] + '-' + d['filename'] + '.test.md'

def content(d):
    ret = '---\n'
    for x in d:
        if x in ('filename', 'body', 'Date'):
            continue
        ret += '%s: %s\n' % (x, d[x])
    ret += '---\n\n'
    ret += convert_body(d['body'])
    return ret

def convert_body(body):
    lines = [x + '\n' for x in body.split('\n')]
    ret = ''
    in_code = False
    for l in lines:
        if l.startswith('#'):
            l = '##' + l
        if not len(l.strip()):
            ret += '\n'
            continue
        l = l.replace('\t', '    ')
        if in_code:
            if not l.startswith('    '):
                in_code = False
                ret += '```\n'
                ret += l
            else:
                ret += l[4:]
        else:
            if l.startswith('    '):
                in_code = True
                if l.startswith('    :::'):
                    typ = l[7:].strip()
                    if typ == 'fish':
                        typ = 'bash'
                    ret += '```' + typ + '\n'
                else:
                    ret += '```\n'
                    ret += l[4:]
            else:
                ret += l
    if in_code:
        ret += '```\n'
    ret = ret.replace('(images', '(/images')
    ret = ret.replace('(file', '(/file')
    return ret

for f in files:
    d = convert_head(get(f))
    with open(get_filename(d), 'w') as fp:
        fp.write(content(d))
