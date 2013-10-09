#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "fileutils"
require "digest/md5"
require "pp"
require "rubygems"
require "libxml"

require "solr.rb"

class MyWikipediaDumps
   include LibXML::XML::SaxParser::Callbacks
   def initialize
      @context = {}
      @indexer = WikipediaSolr.new
   end
   def on_start_element( element, attributes )
      #puts "Element started: #{element}"
      case element
      when "page"
         @context = {}
      when "title", "text", "ns"
         @context[ :state ] = element
      end
   end
   def on_end_element( element )
      case element
      when "page"
         output
      when "title", "text", "ns"
         @context.delete( :state )
      end
   end
   def on_characters( str )
      if @context[ :state ]
         @context[ @context[ :state ] ] ||= ""
         @context[ @context[ :state ] ] << str
      end
   end
   def on_end_document
      @indexer.commit
   end

   def output
      if @context[ "ns" ] == "0"
         title = @context[ "title" ]
         puts title
         fname = Digest::MD5.hexdigest( title ) << ".txt"
         prefix = fname[ 0, 2 ]
         FileUtils.mkdir( prefix ) unless File.exists? prefix
         open( "#{prefix}/#{fname}", "w" ) do |io|
            io.print @context[ "text" ]
         end

	 @indexer.add @context
      end
   end
end

if $0 == __FILE__
   #parser = LibXML::XML::Parser.io( ARGF )
   parser = LibXML::XML::SaxParser.io( ARGF )
   parser.callbacks = MyWikipediaDumps.new
   parser.parse
   #doc = parser.parse
   #doc.root.namespaces.default_prefix = 'mw'
   #pages = doc.find( "//mw:page" )
   #puts pages.size

#    pages.each do |page|
#       namespace = page.find( "./mw:ns" )[0].content.to_i
#       title = page.find( "./mw:title" )[0].content
#       unless namespace != 0
#          STDERR.puts title
#          next
#       end
#       text = page.find( ".//mw:text" )[0].content
#       puts [ title, text.size ].join( "\t" )
#    end
end
