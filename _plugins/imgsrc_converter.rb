#!/usr/bin/ruby
# @Author: BlahGeek
# @Date:   2015-02-06
# @Last Modified by:   BlahGeek
# @Last Modified time: 2015-02-06

require 'liquid'
require 'nokogiri'

module Jekyll
    module ImgSrcFilter
        def cdn_imgsrc(input)
            cdn = Jekyll.configuration({})['cdn_domain']
            doc = Nokogiri::HTML.fragment(input)
            doc.css("img").each do |img|
                img.attributes["src"].value = "#{cdn}#{img.attributes["src"].value}"
            end
            return doc.to_html
        end
    end
end

Liquid::Template.register_filter(Jekyll::ImgSrcFilter)
