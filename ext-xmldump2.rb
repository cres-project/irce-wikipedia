#!/usr/bin/env ruby

require "fileutils"
require "digest/md5"
require "pp"
require "rubygems"
require "libxml"

require "solr.rb"

require "ext-xmldump.rb"
require "mediawiki-parser.rb"

class MyWikipediaDumps
   class Indexer
      def initialize( redirects )
         @indexer = WikipediaSolr.new
	 @redirects = redirects
      end
      def index( title )
         cache = MyWikipediaDumps::CachePage.new( title )
         if not File.exist? cache.filename
            puts "[#{ title }] not found, skip"
            return
         end
         text = open( cache.filename ){|io| io.read }
         if text =~ MyWikipediaDumps::REDIRECT_REGEXP
            puts "[#{ title }] redirect, skip"
            return
         end
         parser = MediaWikiParser::Kiwi.new( title )
         html = parser.to_html( :no_expand_template => true )
         highlight_text = html.gsub( /<[^>]*>/i, "" )
         data = {
            :title => title,
            :text => text,
            :highlight_text => highlight_text,
            :redirects => @redirects[ title ],
         }
         @indexer.add data
      end
      def commit
         @indexer.commit
      end
   end
end

if $0 == __FILE__
   redirects = {}
   open( "redirects.txt" ) do |io|
      io.each do |line|
         redir_from, redir_to, = line.chomp.split( /\t/ )
	 redirects[ redir_to ] ||= []
	 redirects[ redir_to ] << redir_from
      end
   end
   STDERR.puts "reading redirects done. #{ redirects.keys.size } redirects loaded."
   indexer = MyWikipediaDumps::Indexer.new( redirects )
   count = 0
   ARGF.each do |line|
      title = line.chomp.gsub( /_/, " " )
      indexer.index( title )
      count += 1
      indexer.commit if count % 1000 == 0
   end
end
