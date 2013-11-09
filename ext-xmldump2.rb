#!/usr/bin/env ruby

require "fileutils"
require "digest/md5"
require "pp"
require "rubygems"
require "libxml"

require "solr.rb"

require "ext-xmldump.rb"

class MyWikipediaDumps
   def output
      if @attr[ "ns" ] == "0"
         title = @attr[ "title" ]
         puts title
         fname = Digest::MD5.hexdigest( title ) << ".txt"
         prefix = fname[ 0, 2 ]
         FileUtils.mkdir( prefix ) unless File.exists? prefix
         open( "#{prefix}/#{fname}", "w" ) do |io|
            io.print @attr[ "text" ]
         end

	 @indexer.add @attr
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
