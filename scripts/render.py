#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-30

import os, sys
import argparse
import yaml

import jinja2

class FilePathLoader(jinja2.BaseLoader):
    """ Custom Jinja2 template loader which just loads a single template file """

    def __init__(self, cwd, encoding='utf-8'):
        self.cwd = cwd
        self.encoding = encoding

    def get_source(self, environment, template):
        # Path
        filename = os.path.join(self.cwd, template)

        # Read
        try:
            with open(template, 'r') as f:
                contents = f.read().decode(self.encoding)
        except IOError:
            raise jinja2.TemplateNotFound(template)

        # Finish
        uptodate = lambda: False
        return contents, filename, uptodate


def render_template(cwd, template_path, context):
    env = jinja2.Environment(loader=FilePathLoader(cwd))

    return env \
        .get_template(template_path) \
        .render(context) \
        .encode('utf-8')


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('--data', nargs='*', help='One or more YAML data file')
    parser.add_argument('--template', help='Template file to process')
    parser.add_argument('--body', help='Body content')
    args = parser.parse_args()

    context = dict()
    for data_f in args.data:
        key, filename = data_f.split(':')
        context[key] = yaml.load(open(filename).read())
    if args.body:
        context['body'] = open(args.body).read().decode('utf8')

    return render_template(
        os.getcwd(),
        args.template,
        context
    )

if __name__ == '__main__':
    sys.stdout.write(main())
