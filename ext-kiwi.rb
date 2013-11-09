#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "pp"

$:.push File.join( File.dirname(__FILE__), ".." )
require "ext-xmldump.rb"

$:.push File.join( File.dirname(__FILE__), "..", "kiwi", "ffi" )
require "yapwtp.rb"

module MediaWikiParser
   class Base
      attr_reader :parser, :cache
      def initialize( title ); end
      def to_html; end
   end
   class Kiwi < Base
      def initialize( title )
         @parser = WikiParser.new
         @cache = MyWikipediaDumps::CachePage.new( title )
      end
      def to_html( linkto_baseurl = "" )
         html = parser.html_from_file( cache.filename )
         templates = @parser.templates
         templates.each do |template|
            #STDERR.puts templates.inspect
            parser2 = self.class.new( "Template:#{ template[:name] }" )
            #p
            if File.exist? parser2.cache.filename
               html.gsub! /#{ template[:replace_tag] }/, parser2.to_html
            else
               html.gsub! /#{ template[:replace_tag] }/, ""
               warn "Template file not found, skip:\t#{ parser2.cache.filename }"
            end
         end
         html.gsub!( /<a href="\//, "<a href=\"#{ linkto_baseurl }" )
	 html.gsub!( /<span class="editsection">.*?<\/span>/, '' )
	 html
      end
   end
end

if $0 == __FILE__
   title = ARGV[0] || "言語"
   parser = MediaWikiParser::Kiwi.new( title )
   puts parser.to_html
end
