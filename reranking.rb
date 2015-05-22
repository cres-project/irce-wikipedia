#!/usr/bin/env ruby

require_relative "solr.rb"

if $0 == __FILE__
  solr = WikipediaSolr.new
  result = solr.reranking( solr.search_fulltext( "java" ) )
  result.each do |d|
    puts [ d["title"], d["score"] ].join( "\t" ) 
  end
end
