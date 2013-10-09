#!/usr/bin/env ruby
# $Id$

require "rubygems"
require "rsolr"

class WikipediaSolr
   def initialize( url = "http://localhost:18983/solr/" )
      @indexer = RSolr.connect( :url => url )
   end
   def add( context )
      #p context.keys
      @indexer.add( context )
   end
   def commit
      @indexer.commit
   end
end

if $0 == __FILE__
  solr = WikipediaSolr.new
  solr.add( { :title => "test" } )
end
