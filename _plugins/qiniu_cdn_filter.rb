#!/usr/bin/ruby
# @Author: BlahGeek
# @Date:   2015-02-06
# @Last Modified by:   BlahGeek
# @Last Modified time: 2015-02-15

require 'liquid'
require 'nokogiri'

module Jekyll
    module QiniuCDNFilter
        def cdn_imgsrc(input)
            conf = Jekyll.configuration({})
            cdn_domain = conf['cdn_domain']
            cdn_img_suffix = conf['cdn_img_suffix']
            doc = Nokogiri::HTML.fragment(input)
            doc.css("img").each do |img|
                orig_src = img.attributes["src"].value
                img.attributes["src"].value = "#{cdn_domain}/#{orig_src}#{cdn_img_suffix}"
                link = Nokogiri::XML::Node.new "a", doc
                link["class"] = "qiniu-cdn-img-link"
                link["href"] = "/#{orig_src}"
                img.add_previous_sibling(link)
            end
            doc.css("a.qiniu-cdn-img-link").each do |link|
                link.add_child(link.next)
            end
            return doc.to_html
        end
    end
end

Liquid::Template.register_filter(Jekyll::QiniuCDNFilter)
