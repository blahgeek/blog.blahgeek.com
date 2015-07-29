#!/usr/bin/ruby
# @Author: BlahGeek
# @Date:   2015-07-30
# @Last Modified by:   BlahGeek
# @Last Modified time: 2015-07-30

module Jekyll

  class ClassificationPage < Page
    def initialize(site, classification)
      @site = site
      @base = site.source
      @dir = classification
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'classification.html')
      self.data['classification'] = classification
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      conf = Jekyll.configuration({})
      conf["classifications"].map do |classification|
        site.pages << ClassificationPage.new(site, classification)
      end
    end
  end

end
