#!/usr/bin/env ruby

require "fileutils"
require "digest/md5"
require "pp"
require "rubygems"
require "libxml"

require "solr.rb"

require "ext-xmldump.rb"

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
   indexer = WikipediaSolr.new
   count = 0
   ARGF.each do |line|
      data = {}
      title = line.chomp.gsub( /_/, " " )
      cache = MyWikipediaDumps::CachePage.new( title )
      if not File.exist? cache.filename
         puts "[#{ title }] skip"
	 next
      end
      text = open( cache.filename ){|io| io.read }
      if text =~ MyWikipediaDumps::REDIRECT_REGEXP
         puts "[#{ title }] redirect, skip"
         next
      end
      data = {
        :title => title,
	:text => text,
	:redirects => redirects[ title ],
      }
      indexer.add data
      count += 1
      indexer.commit if count % 10000 == 0
   end
end
