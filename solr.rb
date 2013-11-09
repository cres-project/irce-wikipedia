#!/usr/bin/env ruby
# $Id$

require "rubygems"
require "rsolr"

class WikipediaSolr
   def initialize( url = "http://localhost:18983/solr/" )
      @solr = RSolr.connect( :url => url )
   end
   def add( context )
      #p context.keys
      @solr.add( context )
   end
   def commit
      @solr.commit
   end

   def search_fulltext( query )
      result = []
      response = @solr.get( "select", :params => {
                               :q => query,
                               # :rows => 1000,
                               :fl => "* score",
                            } )
   end
end

if $0 == __FILE__
  solr = WikipediaSolr.new
  solr.add( { :title => "test" } )
end
