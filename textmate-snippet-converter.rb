#!/usr/bin/env ruby
# You can use this to convert Textmate2 snippets located on folder #{directory} and will be copied as ST2 format to #{out_dir}

require 'rubygems'
require 'plist'
require 'Nokogiri'
require 'CGI'

directory =   './Snippets/'
out_dir =     './converted/'
extension =   '.sublime-snippet'

# read all files on DI
Dir.foreach(directory) do |item|
  next if item == '.' or item == '..'
  # do work on real items
  filename = out_dir + item.split('.')[0] + extension
  p "Will write to #{filename}:"
  result = Plist::parse_xml(directory+item)
  # generate XML
  builder = Nokogiri::XML::Builder.new do |xml|
    xml.snippet {
        xml.content{
          xml.cdata " #{result['content']} "
        }
        xml.name result['name']
        xml.tabTrigger result['tabTrigger']
        xml.scope result['scope']
    }
  end
  p "XML: #{builder.to_xml}"
  # write to the new file
  File.open(filename, 'w') {|f| f.write(builder.to_xml) }

end