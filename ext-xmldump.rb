#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "fileutils"
require "digest/md5"
require "pp"
require "rubygems"
require "libxml"

require "solr.rb"

class MyWikipediaDumps
   class CachePage
      DIRNAME = File.dirname( __FILE__ )
      attr_reader :basename, :prefix, :filename
      def initialize( title )
         @basename = Digest::MD5.hexdigest( title ) << ".txt"
         @prefix = @basename[ 0, 2 ]
         @filename = File.join( DIRNAME, @prefix, @basename )
      end
   end

   include LibXML::XML::SaxParser::Callbacks
   def initialize
      @count = {}
      @context = nil
      @attr = {}
      @indexer = WikipediaSolr.new
   end
   def on_start_element( element, attributes )
      #puts "Element started: #{element}"
      if element == "page"
         @context = []
	 @attr = {}
      elsif @context
         @context << element
      end
   end
   def on_end_element( element )
      if element == "page"
         output
	 @context = nil
      elsif @context
         @context.pop
      end
   end
   def on_characters( str )
      if @context
         #p @context
         case @context
	 when [ "id" ], [ "title" ], [ "ns" ], [ "revision", "text" ]
            @attr[ @context[-1] ] ||= ""
            @attr[ @context[-1] ] << str
	 end
      end
   end
   def on_end_document
      @indexer.commit
      puts "Indexed:"
      pp @count
   end

   def output
      return unless @attr[ "ns" ] == "0" or @attr[ "ns" ] == "10"
      title = @attr[ "title" ]
      puts title
      cache = CachePage.new( title )
      cache_dirname = File.dirname( cache.filename )
      FileUtils.mkdir( cache_dirname ) unless File.exists? cache_dirname
      open( cache.filename, "w" ) do |io|
         io.print @attr[ "text" ]
      end
      if @attr[ "ns" ] == "0"
	 @indexer.add @attr
      end
      @count[ @attr[ "ns" ] ] ||= 0
      @count[ @attr[ "ns" ] ] += 1
      @indexer.commit if @count.values.inject(:+) % 10000 == 0
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
