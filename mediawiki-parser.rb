#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "pp"

$:.push File.join( File.dirname(__FILE__), ".." )
require "ext-xmldump.rb"

$:.push File.join( File.dirname(__FILE__), "..", "kiwi", "ffi" )
require "yapwtp.rb"

module MediaWikiParser
   class Base
      Namespace_name = {
         "" => "",
         "-2" => "Media", "-1" => "Special", "0" => "",
         "2"  => "User", "4" => "Wikipedia", "6" => "File",
         "8" => "MediaWiki", "10" => "Template", "12" => "Help",
         "14" => "Category",
	 "1" => "Talk", "3" => "User talk", "5" => "Wikipedia talk",
	 "9" => "MediaWiki talk", "11" => "Template talk", "13" => "Help talk",
	 "15" => "Category talk",
      }
      attr_reader :parser, :cache, :title
      def initialize( title ); end
      def to_html; end
   end
   class Kiwi < Base
      def initialize( title )
         @title = title
         @parser = WikiParser.new
         @cache = MyWikipediaDumps::CachePage.new( title )
      end
      def to_html( linkto_baseurl = "" )
         html = parser.html_from_file( cache.filename )
         templates = @parser.templates
         templates.each do |template|
            #STDERR.puts templates.inspect
            case template[ :name ]
            when "PAGENAME"
               html.gsub!( template[ :replace_tag ], @title )
            when /DEFAULTSORT:/
               html.gsub!( template[ :replace_tag ], "" )
            when /ns:(\w+)/
	       #STDERR.puts [ $1, Namespace_name[ $1.to_s ] ].inspect
               html.gsub!( template[ :replace_tag ], Namespace_name[ $1.to_s ] )
            else
               template_title = template[ :name ].strip
               template_title.sub!( /\A(.)/ ){|e| e.upcase }
               parser2 = self.class.new( "Template:#{ template_title }" )
               if File.exist? parser2.cache.filename
                  html.gsub!( template[ :replace_tag ], parser2.to_html )
               else
                  html.gsub!( template[ :replace_tag ], "" )
                  warn "Template file not found, skip:\t{{#{ template_title }}}, #{ parser2.cache.filename }"
               end
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
