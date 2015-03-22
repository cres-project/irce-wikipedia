#!/usr/bin/env ruby
# $Id$

require "rubygems"
require "rsolr"

class WikipediaSolr
   def initialize( url = "http://localhost:8983/solr/" )
      @solr = RSolr.connect( :url => url )
   end
   def add( context )
      #p context.keys
      @solr.add( context )
   end
   def commit
      @solr.commit
   end

   def search_fulltext( query, opts = {} )
      result = []
      params = {
         :q => query,
         # :rows => 1000,
         :fl => "* score",
         :hl => true,
         :"hl.q" => query,
         :"hl.fl" => "highlight_text",
         :"hl.snippets" => 3,
	 :defType => "edismax",
	 :qf => "title^10.0 redirects^2.0 text^1.0",
      }
      params.update( opts )
      response = @solr.get( "select", :params => params )
   end
end

if $0 == __FILE__
  solr = WikipediaSolr.new
  solr.add( { :title => "test" } )
end
