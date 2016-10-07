#!/usr/bin/env python
# -*- coding: utf-8 -*-
# Created by i@BlahGeek.com at 2015-07-30

import os
import argparse
import yaml

import jinja2


class FilePathLoader(jinja2.BaseLoader):
    """ Custom Jinja2 template loader which just loads a single template file """

    def __init__(self, cwd):
        self.cwd = cwd

    def get_source(self, environment, template):
        # Path
        filename = os.path.join(self.cwd, template)

        # Read
        try:
            with open(filename, 'r') as f:
                contents = f.read()
        except IOError:
            raise jinja2.TemplateNotFound(filename)

        # Finish
        uptodate = lambda: False
        return contents, filename, uptodate


def render_template(cwd, template_path, context):
    env = jinja2.Environment(loader=FilePathLoader(cwd))

    return env \
        .get_template(template_path) \
        .render(context)


def main():
    parser = argparse.ArgumentParser()

    parser.add_argument('--dir', default='.', help='Template directory')
    parser.add_argument('--data', nargs='*', help='One or more YAML data file')
    parser.add_argument('--template', help='Template file to process')
    parser.add_argument('--body', help='Body content')
    args = parser.parse_args()

    context = dict()
    for data_f in args.data if args.data else []:
        key, filename = data_f.split(':')
        if filename:
            context[key] = yaml.load(open(filename).read())
        else:
            context[key] = {'_': True}
    if args.body:
        context['body'] = open(args.body).read()

    return render_template(
        args.dir,
        args.template,
        context
    )

if __name__ == '__main__':
    print(main())
