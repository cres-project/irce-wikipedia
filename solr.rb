#!/usr/bin/env ruby
# $Id$

require "set"
require "pp"
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
	 :qf => "title^10.0 category^5.0 redirects^2.0 text^1.0",
      }
      params.update( opts )
      response = @solr.get( "select", :params => params )
   end

   def reranking( response, params = { :alpha => 0.5 } )
     alpha = params[ :alpha ]
     docs = response[ "response" ][ "docs" ]
     results = []
     results << docs.shift
     until docs.empty? do
       previous_categories = results.map{|e| e[ "category" ] }.flatten.uniq
       docs.sort_by! do |e| 
         score = e[ "score" ].to_f
         category = e[ "category" ]
	 if category.empty?
	   cat_score = 0.1
	 else
	   cat_score = ( Set[ *previous_categories ] & Set[ *category ] ).size / category.size.to_f
         end
         alpha * score * ( 1-alpha ) * cat_score
       end
       results << docs.shift
     end
     results
   end
end

if $0 == __FILE__
  solr = WikipediaSolr.new
  #solr.add( { :title => "test" } )
end
